#!/usr/bin/env python3
"""Exercise the updater with local remotes and full or partial Git clones."""

import argparse
import os
from pathlib import Path
import subprocess
import tempfile


UPDATER = Path(__file__).resolve().parents[1] / "pull-figma-master"


def main(partial_clone=False):
    with tempfile.TemporaryDirectory(prefix="pull-figma-master-test-") as directory:
        root = Path(directory)
        home = root / "home"
        home.mkdir()
        remote = root / "origin.git"
        writer = root / "writer"
        checkout = root / "checkout"
        environment = {
            **os.environ,
            "HOME": str(home),
            "GIT_CONFIG_NOSYSTEM": "1",
            "GIT_CONFIG_GLOBAL": "/dev/null",
            "GIT_TERMINAL_PROMPT": "0",
        }

        def git(repo, *arguments):
            return subprocess.check_output(
                ["/usr/bin/git", "-C", str(repo), *arguments],
                env=environment,
                stderr=subprocess.STDOUT,
                text=True,
            ).strip()

        def update():
            return subprocess.run(
                ["/bin/zsh", str(UPDATER)],
                env={
                    **environment,
                    "PATH": "/usr/bin:/bin",
                    "FIGMA_REPO_DIR": str(checkout),
                },
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                timeout=30,
            )

        def expect_update(success, message):
            result = update()
            assert (result.returncode == 0) == success, result.stdout
            assert message in result.stdout, result.stdout

        def publish(label, push_lfs=True):
            (writer / "a-first.txt").write_text(label)
            (writer / "asset.bin").write_bytes(label.encode() * 128)
            git(writer, "add", "--", "a-first.txt", "asset.bin")
            git(writer, "commit", "-m", label)
            options = [] if push_lfs else ["-c", "core.hooksPath=/dev/null"]
            git(writer, *options, "push", "origin", "master")
            return git(writer, "rev-parse", "HEAD")

        git(root, "init", "--bare", "--initial-branch=master", str(remote))
        if partial_clone:
            git(remote, "config", "uploadpack.allowFilter", "true")
            git(remote, "config", "uploadpack.allowAnySHA1InWant", "true")
        git(root, "init", "--initial-branch=master", str(writer))
        git(writer, "config", "user.name", "Updater test")
        git(writer, "config", "user.email", "updater@example.invalid")
        git(writer, "lfs", "install", "--local")
        (writer / ".gitattributes").write_text(
            "*.bin filter=lfs diff=lfs merge=lfs -text\n"
        )
        git(writer, "add", "--", ".gitattributes")
        git(writer, "remote", "add", "origin", str(remote))
        publish("first")
        if partial_clone:
            git(root, "clone", "--filter=blob:none", remote.as_uri(), str(checkout))
        else:
            git(root, "clone", str(remote), str(checkout))
        git(checkout, "lfs", "install", "--local")
        git(checkout, "lfs", "pull")

        (writer / ".gitattributes").write_text(
            "*.bin filter=lfs diff=lfs merge=lfs -text\n"
            "*.asset filter=lfs diff=lfs merge=lfs -text\n"
        )
        (writer / "new.asset").write_bytes(b"newly tracked asset" * 128)
        git(writer, "add", "--", ".gitattributes", "new.asset")
        target = publish("second")
        if partial_clone:
            git(checkout, "fetch", "--no-tags", "origin", "master")
            missing = git(checkout, "rev-list", "--objects", "--missing=print", "HEAD..origin/master")
            pointer_oid = git(writer, "rev-parse", f"{target}:asset.bin")
            assert f"?{pointer_oid}" in missing, missing
        expect_update(True, "master updated successfully")
        assert git(checkout, "rev-parse", "HEAD") == target
        assert git(checkout, "status", "--porcelain") == ""
        assert (checkout / "asset.bin").read_bytes() == b"second" * 128
        assert (checkout / "new.asset").read_bytes() == b"newly tracked asset" * 128
        expect_update(True, "already up to date")
        print("PASS: minimal PATH, LFS download, changed attributes, clean fast-forward, repeat run")

        (checkout / "a-first.txt").write_text("user edit")
        expect_update(True, "has tracked changes")
        assert (checkout / "a-first.txt").read_text() == "user edit"
        assert git(checkout, "rev-parse", "HEAD") == target
        git(checkout, "add", "--", "a-first.txt")
        expect_update(True, "has tracked changes")
        assert git(checkout, "diff", "--cached", "--name-only") == "a-first.txt"
        git(checkout, "reset", "--hard", target)
        print("PASS: preserve unstaged and staged edits")

        git(checkout, "checkout", "-b", "feature")
        expect_update(True, "is on feature")
        assert git(checkout, "rev-parse", "HEAD") == target
        git(checkout, "checkout", "master")
        print("PASS: leave other branches alone")

        lock_path = checkout / ".git" / "pull-figma-master.lock"
        with subprocess.Popen(
            [
                "/bin/zsh", "-fc",
                'zmodload zsh/system; zsystem flock -f fd "$1"; '
                'print locked; read -r release',
                "test-lock", str(lock_path),
            ],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            text=True,
        ) as holder:
            assert holder.stdout.readline().strip() == "locked"
            expect_update(True, "another master update is running")
            holder.communicate("release\n", timeout=10)
        expect_update(True, "already up to date")
        print("PASS: prevent overlapping runs and release lock")

        original_remote = git(checkout, "remote", "get-url", "origin")
        git(checkout, "remote", "set-url", "origin", str(root / "missing.git"))
        expect_update(False, "fetch failed; checkout was not changed")
        assert git(checkout, "rev-parse", "HEAD") == target
        assert git(checkout, "status", "--porcelain") == ""
        git(checkout, "remote", "set-url", "origin", original_remote)
        print("PASS: failed fetch preserves checkout")

        publish("missing-lfs-object", push_lfs=False)
        expect_update(False, "LFS download failed; checkout was not changed")
        assert git(checkout, "rev-parse", "HEAD") == target
        assert git(checkout, "status", "--porcelain") == ""
        assert (checkout / "a-first.txt").read_text() == "second"
        git(writer, "lfs", "push", "--all", "origin", "master")
        print("PASS: failed LFS download preserves branch, index, and files")

        upload_pack = root / "upload-pack"
        upload_pack.write_text(
            '#!/bin/sh\n'
            '/usr/bin/git -C "$TEST_CHECKOUT" checkout -b during-fetch >&2\n'
            'exec /usr/bin/git upload-pack "$@"\n'
        )
        upload_pack.chmod(0o755)
        environment["TEST_CHECKOUT"] = str(checkout)
        git(checkout, "config", "remote.origin.uploadpack", str(upload_pack))
        expect_update(True, "is on during-fetch")
        assert git(checkout, "branch", "--show-current") == "during-fetch"
        assert git(checkout, "rev-parse", "HEAD") == target
        assert git(checkout, "status", "--porcelain") == ""
        git(checkout, "config", "--unset", "remote.origin.uploadpack")
        git(checkout, "checkout", "master")
        print("PASS: branch switch during fetch is preserved")

        git(checkout, "config", "user.name", "Updater test")
        git(checkout, "config", "user.email", "updater@example.invalid")
        (checkout / "local.txt").write_text("local commit")
        git(checkout, "add", "--", "local.txt")
        git(checkout, "commit", "-m", "local commit")
        local_head = git(checkout, "rev-parse", "HEAD")
        expect_update(False, "master has diverged")
        assert git(checkout, "rev-parse", "HEAD") == local_head
        assert git(checkout, "status", "--porcelain") == ""
        print("PASS: refuse divergence without rewriting local commits")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--partial-clone", action="store_true")
    main(parser.parse_args().partial_clone)
