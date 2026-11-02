"""Run with python3 tests/test_git_setup.py; no network or real home changes."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class GitSetupTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles git test ")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.env = {key: value for key, value in os.environ.items()
                    if not key.startswith("GIT_")}
        self.env.update(HOME=str(self.home), XDG_CONFIG_HOME=str(self.home / ".config"),
                        GIT_CONFIG_NOSYSTEM="1")

    def run_cmd(self, *args, cwd=None, check=True):
        return subprocess.run(args, cwd=cwd or self.home, env=self.env,
                              capture_output=True, text=True, check=check)

    def install(self, check=True):
        return self.run_cmd("bash", str(REPO / "setup_git.sh"), check=check)

    def fill_profiles(self):
        for profile in ("personal", "work"):
            path = str(self.home / f".gitconfig-{profile}")
            self.run_cmd("git", "config", "--file", path, "user.name", profile)
            self.run_cmd("git", "config", "--file", path, "user.email", f"{profile}@example.invalid")

    def init(self, relative, remote=None):
        path = self.home / relative
        path.mkdir(parents=True)
        self.run_cmd("git", "init", "-q", str(path))
        if remote:
            self.run_cmd("git", "remote", "add", "origin", remote, cwd=path)
        return path

    def value(self, path, key):
        return self.run_cmd("git", "config", "--get", key, cwd=path).stdout.strip()

    def test_fresh_install_and_repeat_preserve_profiles(self):
        self.install()
        self.fill_profiles()
        before = (self.home / ".gitconfig-personal").read_bytes()
        self.install()
        self.assertEqual(before, (self.home / ".gitconfig-personal").read_bytes())
        includes = self.run_cmd("git", "config", "--global", "--get-all", "include.path").stdout.splitlines()
        self.assertEqual(includes, [str(self.home / ".config/git/dotfiles.inc")])
        self.assertTrue((self.home / ".config/git/dotfiles.inc").is_symlink())
        for profile in ("personal", "work"):
            self.assertEqual((self.home / f".gitconfig-{profile}").stat().st_mode & 0o777, 0o600)
        self.assertFalse((self.home / ".gitconfig-gitlab").exists())

    def test_existing_config_backed_up_and_preserved(self):
        config = self.home / ".gitconfig"
        original = b"[alias]\n    example = status\n"
        config.write_bytes(original)
        self.install()
        self.install()
        backups = list(self.home.glob(".local/state/dotfiles/backups/*/.gitconfig"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_bytes(), original)
        self.assertEqual(self.run_cmd("git", "config", "--global", "--get", "alias.example").stdout.strip(), "status")

    def test_xdg_config_backed_up(self):
        config = self.home / ".config/git/config"
        config.parent.mkdir(parents=True)
        original = b"[alias]\n    example = status\n"
        config.write_bytes(original)
        self.install()
        backups = list(self.home.glob(".local/state/dotfiles/backups/*/.gitconfig"))
        self.assertEqual(backups[0].read_bytes(), original)
        self.assertFalse((self.home / ".gitconfig").exists())

    def test_global_symlink_is_made_local_without_editing_source(self):
        source = self.home / "old-checkout.gitconfig"
        original = b"[alias]\n    example = status\n"
        source.write_bytes(original)
        config = self.home / ".gitconfig"
        config.symlink_to(source)
        self.install()
        self.assertFalse(config.is_symlink())
        self.assertEqual(source.read_bytes(), original)
        self.assertEqual(config.stat().st_mode & 0o777, 0o600)

    def test_conflict_stops_before_changing_global_or_profiles(self):
        conflict = self.home / ".config/git/dotfiles.inc"
        conflict.parent.mkdir(parents=True)
        conflict.write_text("existing\n")
        self.assertNotEqual(self.install(check=False).returncode, 0)
        self.assertEqual(conflict.read_text(), "existing\n")
        self.assertFalse((self.home / ".gitconfig").exists())
        self.assertFalse((self.home / ".gitconfig-personal").exists())

    def test_routing_and_local_override(self):
        self.install()
        self.fill_profiles()
        cases = [
            ("anywhere/dotfiles", "git@github.com:example/dotfiles.git", "work"),
            ("elsewhere/https", "https://github.com/example/project.git", "work"),
            ("elsewhere/ssh", "ssh://git@gitlab.com/example/project.git", "work"),
            ("elsewhere/lab", "git@gitlab.com:example/project.git", "work"),
            ("code/work/nested/project", "git@github.com:example/work.git", "work"),
            ("code/work/new", None, "work"),
            ("code/personal/new", None, "personal"),
            ("code/personal/lab", "git@gitlab.com:example/project.git", "personal"),
            ("code/work/lab", "git@gitlab.com:example/project.git", "work"),
            ("code/work/private", "git@internal.example.invalid:team/repo.git", "work"),
            ("elsewhere/new", None, "work"),
            ("code/personal/nested/project", "git@github.com:example/project.git", "personal"),
            ("code/personal-other/project", "git@github.com:example/project.git", "work"),
        ]
        for directory, remote, profile in cases:
            path = self.init(directory, remote)
            self.assertEqual(self.value(path, "user.name"), profile)
            key = "id_ed25519_personal" if profile == "personal" else "id_ed25519"
            self.assertEqual(self.value(path, "core.sshCommand"),
                             f"ssh -i ~/.ssh/{key} -o IdentitiesOnly=yes")
        self.run_cmd("git", "config", "user.email", "override@example.invalid", cwd=path)
        self.assertEqual(self.value(path, "user.email"), "override@example.invalid")

    def test_broken_profile_link_stops_before_installing(self):
        (self.home / ".gitconfig-work").symlink_to(self.home / "missing")
        self.assertNotEqual(self.install(check=False).returncode, 0)
        self.assertFalse((self.home / ".gitconfig").exists())
        self.assertFalse((self.home / ".gitconfig-personal").exists())
        self.assertFalse((self.home / ".config/git/dotfiles.inc").exists())

    def test_upgrade_overrides_old_work_key_without_editing_identity(self):
        work = self.home / ".gitconfig-work"
        original = ('[user]\n    name = Existing Work\n    email = work@example.invalid\n'
                    '[core]\n    sshCommand = ssh -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes\n')
        work.write_text(original)
        self.install()
        path = self.init("outside/project", "git@github.com:example/project.git")
        self.assertEqual(self.value(path, "user.email"), "work@example.invalid")
        self.assertEqual(self.value(path, "core.sshCommand"),
                         "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes")
        self.assertEqual(work.read_text(), original)
        self.install()
        self.assertEqual(work.read_text(), original)

    def test_blank_profile_rejects_commit_even_with_global_identity(self):
        self.run_cmd("git", "config", "--global", "user.name", "Old Default")
        self.run_cmd("git", "config", "--global", "user.email", "old@example.invalid")
        self.install()
        path = self.init("code/work/project")
        result = self.run_cmd("git", "commit", "--allow-empty", "-m", "test", cwd=path, check=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("empty ident", result.stderr)

    def test_clone_uses_directory_key_before_checkout_exists(self):
        self.install()
        self.fill_profiles()
        # Intercept SSH so this checks clone's selected key without a network call.
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        ssh = bin_dir / "ssh"
        ssh.write_text('#!/bin/sh\nprintf "%s\\n" "$@" >> "$HOME/ssh-args"\nexit 1\n')
        ssh.chmod(0o700)
        self.env["PATH"] = f"{bin_dir}:{self.env['PATH']}"
        for directory, key, host in (("code/work/project", "id_ed25519", "github.com"),
                                     ("elsewhere/project", "id_ed25519", "github.com"),
                                     ("code/personal/project", "id_ed25519_personal", "github.com"),
                                     ("code/personal/lab", "id_ed25519_personal", "gitlab.com"),
                                     ("code/work/lab", "id_ed25519", "gitlab.com")):
            log = self.home / "ssh-args"
            log.unlink(missing_ok=True)
            result = self.run_cmd("git", "clone", f"git@{host}:example/project.git",
                                  str(self.home / directory), check=False)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn(str(self.home / ".ssh" / key), log.read_text().splitlines())


if __name__ == "__main__":
    unittest.main()
