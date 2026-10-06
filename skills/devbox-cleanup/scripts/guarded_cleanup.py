#!/usr/bin/env python3
"""Inspect or remove one classified disposable target on a Linux devbox."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time


class Refusal(Exception):
    pass


def run(args, timeout=30):
    return subprocess.run(args, capture_output=True, text=True, timeout=timeout)


def git_command(repo, *args):
    command = ["git", "-C", str(repo), *args]
    owner = repo.stat().st_uid
    if os.geteuid() == 0 and owner != 0:
        command = ["sudo", "-n", "-u", f"#{owner}", "--", *command]
    return command


def git(repo, *args):
    result = run(git_command(repo, *args))
    if result.returncode:
        raise Refusal(f"Git inspection failed in {repo}")
    return result.stdout.strip()


def worktrees(repo):
    return [Path(line[9:]) for line in git(repo, "worktree", "list", "--porcelain").splitlines()
            if line.startswith("worktree ")]


def classify(kind, path, home, repo):
    if not path.is_absolute() or path.resolve() != path or path.is_symlink():
        raise Refusal("target must be an absolute path without symlink components")
    if not path.exists():
        return None
    if not home.is_absolute() or home.resolve() != home or not home.is_dir():
        raise Refusal("home must be the actual user's absolute home directory")
    if path in (Path("/"), home, Path("/tmp"), repo):
        raise Refusal("refusing a filesystem, home, temporary, or repository root")
    if kind == "git-temp":
        common = Path(git(repo, "rev-parse", "--path-format=absolute", "--git-common-dir"))
        objects = common / "objects"
        pack_temp = path.parent == objects / "pack" and re.fullmatch(r"tmp_(pack|idx|rev)_[A-Za-z0-9]+", path.name)
        loose_temp = path.parent.parent == objects and re.fullmatch(r"[0-9a-f]{2}", path.parent.name) and re.fullmatch(r"tmp_obj_[A-Za-z0-9]+", path.name)
        if not path.is_file() or not (pack_temp or loose_temp):
            raise Refusal("target is not a recognized Git temporary object file")
        if time.time() - path.stat().st_mtime < 900:
            raise Refusal("Git temporary file is newer than fifteen minutes")
        return path
    if not path.is_dir():
        raise Refusal("expected a directory")
    registered = worktrees(repo)
    if kind == "worktree-deps":
        if path.name != "node_modules" or path.parent not in registered or path.parent == registered[0]:
            raise Refusal("target is not dependencies of a registered secondary worktree")
        if git(path.parent, "ls-files", "--", "node_modules"):
            raise Refusal("dependency directory contains tracked files")
        result = run(git_command(path.parent, "check-ignore", "--quiet", "node_modules"))
        if result.returncode != 0:
            raise Refusal("dependency directory is not ignored")
        return path.parent
    cache = home / ".cache" / "bazel"
    in_cache = path.parent.parent == cache and path.parent.name.startswith("_bazel_")
    in_tmp = path.is_relative_to(Path("/tmp"))
    if not (in_cache or in_tmp) or path.name in {"cache", "install"} or not (path / "execroot").is_dir():
        raise Refusal("target is not an individual Bazel output base")
    if (path / ".git").exists() or any(p == path or p.is_relative_to(path) for p in registered):
        raise Refusal("output directory contains a source worktree")
    pidfile = path / "server" / "server.pid.txt"
    if pidfile.is_file():
        pid = pidfile.read_text().strip()
        if pid.isdigit() and (Path("/proc") / pid).exists():
            raise Refusal(f"Bazel server PID {pid} is alive")
    for link in registered[0].glob("bazel-*"):
        if link.is_symlink() and str(link.resolve()).startswith(str(path) + "/"):
            raise Refusal("main checkout references this output base")
    return path


def ancestors(proc):
    ids = {os.getpid()}
    pid = os.getpid()
    while pid > 1:
        try:
            text = (proc / str(pid) / "status").read_text()
        except FileNotFoundError:
            break
        pid = int(re.search(r"^PPid:\s+(\d+)", text, re.M).group(1))
        ids.add(pid)
    return ids


def matches(text, scopes):
    return any(re.search(re.escape(str(p)) + r"(?=/|\s|\x00|$|[\"'])", text) for p in scopes)


def processes(proc, scopes, target, kind):
    ignored = ancestors(proc)
    fingerprints = set()
    inode = (target.stat().st_dev, target.stat().st_ino)
    for process in proc.iterdir():
        if not process.name.isdigit():
            continue
        try:
            args = (process / "cmdline").read_bytes().decode(errors="replace").replace("\0", " ").strip()
            if int(process.name) in ignored:
                if args:
                    fingerprints.add(" ".join(args.split()))
            elif matches(args, scopes):
                raise Refusal(f"process PID {process.name} references the target")
            if kind == "git-temp" and re.search(r"\bgit(?:-|\s+)(pack-objects|index-pack|repack|gc)\b", args):
                raise Refusal(f"Git packing PID {process.name} is active")
            for field in ("cwd", "exe"):
                link = process / field
                try:
                    if matches(os.readlink(link), scopes):
                        raise Refusal(f"process PID {process.name} uses the target")
                    s = link.stat()
                    if kind == "git-temp" and (s.st_dev, s.st_ino) == inode:
                        raise Refusal(f"process PID {process.name} holds the target inode")
                except FileNotFoundError:
                    pass
            for fd in (process / "fd").iterdir():
                try:
                    s = fd.stat()
                    if (s.st_dev, s.st_ino) == inode or matches(os.readlink(fd), scopes):
                        raise Refusal(f"process PID {process.name} has an open target reference")
                except FileNotFoundError:
                    pass
        except FileNotFoundError:
            continue
        except PermissionError:
            raise Refusal(f"cannot inspect PID {process.name}; retry with sufficient privileges")
    return fingerprints


def docker(scopes, expected_id):
    if not expected_id and not Path("/var/run/docker.sock").exists() and not os.environ.get("DOCKER_HOST"):
        return scopes, [], None
    if not shutil.which("docker"):
        raise Refusal("Docker is present but its CLI is unavailable")
    result = run(["docker", "info", "--format", "{{.ID}}"])
    if result.returncode or not result.stdout.strip():
        raise Refusal("cannot inspect the Docker engine")
    engine = result.stdout.strip()
    if expected_id and engine != expected_id:
        raise Refusal("Docker engine differs from the audited engine")
    for attempt in range(3):
        ids = run(["docker", "ps", "--no-trunc", "-q"])
        if ids.returncode:
            raise Refusal("cannot list running containers")
        if not ids.stdout.strip():
            return scopes, [], engine
        result = run(["docker", "inspect", *ids.stdout.split()])
        try:
            containers = json.loads(result.stdout)
            seen = {c["Id"] for c in containers}
        except (ValueError, KeyError, TypeError):
            continue
        now = run(["docker", "ps", "--no-trunc", "-q"])
        if now.returncode == 0 and set(now.stdout.split()) <= seen:
            break
    else:
        raise Refusal("container inventory did not stabilize; preserve the target")
    aliases = set(scopes)
    for c in containers:
        for m in c.get("Mounts", []):
            source, dest = Path(m["Source"]), Path(m["Destination"])
            for p in scopes:
                if p == source or p.is_relative_to(source):
                    aliases.add(dest / p.relative_to(source))
                if p == dest or p.is_relative_to(dest):
                    aliases.add(source / p.relative_to(dest))
    for c in containers:
        cwd = c.get("Config", {}).get("WorkingDir", "")
        if matches(cwd, aliases):
            raise Refusal(f"container {c['Id'][:12]} works in the target")
        for m in c.get("Mounts", []):
            if any(Path(m["Source"]) == p or Path(m["Source"]).is_relative_to(p) for p in aliases):
                raise Refusal(f"container {c['Id'][:12]} mounts the target")
    return aliases, containers, engine


def inspect_target(kind, path, home, repo, expected_id, proc=Path("/proc")):
    scope = classify(kind, path, home, repo)
    if scope is None:
        return {"status": "gone", "path": str(path)}
    before = path.stat()
    mountinfo = (proc / "self" / "mountinfo").read_text()
    for line in mountinfo.splitlines():
        mount = re.sub(r"\\([0-7]{3})", lambda m: chr(int(m[1], 8)), line.split()[4])
        if Path(mount) == path or Path(mount).is_relative_to(path):
            raise Refusal("target contains a mount boundary")
    scopes, containers, engine = docker({scope}, expected_id)
    fingerprints = processes(proc, scopes, path, kind)
    for c in containers:
        result = run(["docker", "top", c["Id"], "-eo", "pid,args"])
        if result.returncode:
            raise Refusal("container processes changed during inspection; retry the audit")
        for line in result.stdout.splitlines()[1:]:
            args = " ".join(line.split()[1:])
            if any(f in args for f in fingerprints):
                continue
            if matches(args, scopes):
                raise Refusal(f"container {c['Id'][:12]} processes reference the target")
    after = path.stat()
    if (before.st_ino, before.st_mtime_ns, before.st_size) != (after.st_ino, after.st_mtime_ns, after.st_size):
        raise Refusal("target changed during inspection")
    return {"status": "eligible", "path": str(path), "kind": kind, "engine_id": engine}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--kind", required=True, choices=("bazel-output", "worktree-deps", "git-temp"))
    parser.add_argument("--home", required=True, type=Path)
    parser.add_argument("--repo", required=True, type=Path)
    parser.add_argument("--docker-id")
    parser.add_argument("--apply", action="store_true", help="delete the single eligible target")
    parser.add_argument("path", type=Path)
    args = parser.parse_args()
    try:
        if sys.platform != "linux":
            raise Refusal("run this helper on the Linux devbox")
        if args.apply and os.geteuid() != 0:
            raise Refusal("apply requires sudo and explicit user home/repository paths")
        result = inspect_target(args.kind, args.path, args.home, args.repo, args.docker_id)
        if args.apply and result["status"] == "eligible":
            command = ["rm", "--force", "--", str(args.path)]
            if args.path.is_dir():
                command = ["rm", "--recursive", "--force", "--one-file-system", "--", str(args.path)]
            deleted = run(command, timeout=None)
            if deleted.returncode:
                raise Refusal("deletion failed; re-audit the remaining target before retrying")
            if args.path.exists():
                raise Refusal("target still exists after deletion")
            result["status"] = "removed"
        print(json.dumps(result))
    except (Refusal, OSError, subprocess.SubprocessError) as error:
        print(json.dumps({"status": "refused", "path": str(args.path), "reason": str(error)}))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
