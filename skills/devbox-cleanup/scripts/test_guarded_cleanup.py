"""Regression checks for deletion boundaries and live references."""

import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location("guard", Path(__file__).with_name("guarded_cleanup.py"))
guard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(guard)


class GuardTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name).resolve()
        self.repo = self.home / "repo"
        self.repo.mkdir()
        self.git("init", "--quiet")
        (self.repo / ".gitignore").write_text("node_modules/\n")
        (self.repo / "source.txt").write_text("keep source\n")
        self.git("add", ".gitignore", "source.txt")
        self.git("-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "-m", "add fixture")
        self.base = self.home / ".cache/bazel/_bazel_fixture" / ("a" * 32)
        (self.base / "execroot").mkdir(parents=True)
        self.proc = self.home / "proc"
        (self.proc / str(os.getpid())).mkdir(parents=True)
        (self.proc / str(os.getpid()) / "status").write_text("PPid:\t0\n")

    def git(self, *args):
        env = os.environ.copy()
        env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1")
        return subprocess.run(["git", "-C", str(self.repo), *args], env=env, check=True, capture_output=True, text=True)

    def test_output_base_requires_layout_and_never_accepts_roots(self):
        self.assertEqual(guard.classify("bazel-output", self.base, self.home, self.repo), self.base)
        for path in (self.home, self.repo, self.base.parent):
            with self.subTest(path=path), self.assertRaises(guard.Refusal):
                guard.classify("bazel-output", path, self.home, self.repo)

    def test_symlink_does_not_make_source_eligible(self):
        alias = self.base.parent / ("b" * 32)
        alias.symlink_to(self.repo, target_is_directory=True)
        with self.assertRaises(guard.Refusal):
            guard.classify("bazel-output", alias, self.home, self.repo)
        self.assertEqual((self.repo / "source.txt").read_text(), "keep source\n")

    def test_real_git_packs_and_recent_temporary_files_are_protected(self):
        pack = self.repo / ".git/objects/pack"
        temp = pack / "tmp_pack_ABC123"
        temp.write_text("unfinished pack")
        with self.assertRaises(guard.Refusal):
            guard.classify("git-temp", temp, self.home, self.repo)
        os.utime(temp, (time.time() - 3600,) * 2)
        self.assertEqual(guard.classify("git-temp", temp, self.home, self.repo), temp)
        real = pack / "pack-fixture.pack"
        real.write_text("real pack")
        with self.assertRaises(guard.Refusal):
            guard.classify("git-temp", real, self.home, self.repo)

    def test_only_ignored_untracked_secondary_dependencies_are_eligible(self):
        secondary = self.home / "secondary"
        self.git("worktree", "add", "--quiet", "-b", "secondary", str(secondary))
        node = secondary / "node_modules"
        node.mkdir()
        (node / "package.js").write_text("generated package")
        self.assertEqual(guard.classify("worktree-deps", node, self.home, self.repo), secondary)
        self.git("-C", str(secondary), "add", "--force", "node_modules/package.js")
        with self.assertRaises(guard.Refusal):
            guard.classify("worktree-deps", node, self.home, self.repo)
        main_node = self.repo / "node_modules"
        main_node.mkdir()
        with self.assertRaises(guard.Refusal):
            guard.classify("worktree-deps", main_node, self.home, self.repo)

    def test_reference_matching_does_not_confuse_similar_worktree_names(self):
        self.assertTrue(guard.matches(str(self.base) + "/execroot/file", {self.base}))
        self.assertFalse(guard.matches(str(self.base) + "-old/file", {self.base}))

    def test_open_hardlink_protects_git_temporary_inode(self):
        temp = self.repo / ".git/objects/pack/tmp_pack_ABC123"
        temp.write_text("unfinished pack")
        alias = self.home / "alias"
        os.link(temp, alias)
        process = self.proc / "99999999"
        (process / "fd").mkdir(parents=True)
        (process / "cmdline").write_bytes(b"reader\0")
        (process / "fd/7").symlink_to(alias)
        with self.assertRaises(guard.Refusal):
            guard.processes(self.proc, {temp}, temp, "git-temp")

    def test_mount_boundary_is_refused_before_activity_or_deletion(self):
        (self.proc / "self").mkdir()
        (self.proc / "self/mountinfo").write_text(f"1 0 0:1 / {self.base}/execroot rw - tmpfs tmpfs rw\n")
        with self.assertRaises(guard.Refusal):
            guard.inspect_target("bazel-output", self.base, self.home, self.repo, None, self.proc)
        self.assertTrue(self.base.exists())

    def test_docker_context_change_and_unstable_inventory_fail_closed(self):
        def result(stdout="", code=0):
            return subprocess.CompletedProcess([], code, stdout, "")
        with patch.object(guard, "run", return_value=result("different-engine")), patch.object(guard.shutil, "which", return_value="docker"):
            with self.assertRaises(guard.Refusal):
                guard.docker({self.base}, "audited-engine")

        def changing(args, timeout=30):
            if args[1] == "info":
                return result("audited-engine")
            if args[1] == "inspect":
                return result('[{"Id":"old","Mounts":[]}]')
            return result("new\n")

        with patch.object(guard, "run", side_effect=changing), patch.object(guard.shutil, "which", return_value="docker"):
            with self.assertRaises(guard.Refusal):
                guard.docker({self.base}, "audited-engine")


if __name__ == "__main__":
    unittest.main()
