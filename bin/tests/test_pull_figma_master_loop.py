#!/usr/bin/env python3
"""Check the foreground loop and removal of its obsolete cron entry."""

import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


REPO = Path(__file__).resolve().parents[2]


def main():
    with tempfile.TemporaryDirectory(prefix="figma-master-loop-test-") as directory:
        root = Path(directory)
        scripts = root / "scripts"
        commands = root / "commands"
        scripts.mkdir()
        commands.mkdir()
        wrapper = scripts / "pull-figma-master-loop"
        shutil.copy2(REPO / "bin/pull-figma-master-loop", wrapper)
        link = root / "installed-loop"
        link.symlink_to(wrapper)

        def executable(path, body):
            path.write_text(f"#!{sys.executable}\n" + body)
            path.chmod(0o755)

        environment = {
            **os.environ,
            "PATH": str(commands) + os.pathsep + os.environ["PATH"],
            "TEST_LOOP_ROOT": str(root),
            "CODER_AGENT_URL": "http://test-agent.invalid",
            "CODER_AGENT_TOKEN": "fake-token-for-test",
        }
        executable(scripts / "pull-figma-master", '''
import os
from pathlib import Path
import sys
assert os.environ["CODER_AGENT_URL"] == "http://test-agent.invalid"
assert os.environ["CODER_AGENT_TOKEN"] == "fake-token-for-test"
counter = Path(os.environ["TEST_LOOP_ROOT"]) / "updates"
count = int(counter.read_text()) + 1 if counter.exists() else 1
counter.write_text(str(count))
sys.exit(1 if count == 1 else 0)
''')
        executable(commands / "sleep", '''
import os
from pathlib import Path
import signal
import sys
assert sys.argv[1:] == ["300"]
root = Path(os.environ["TEST_LOOP_ROOT"])
with (root / "sleep-intervals").open("a") as output:
    output.write("300\\n")
if (root / "updates").read_text() == "2":
    os.kill(os.getppid(), signal.SIGTERM)
''')
        result = subprocess.run(
            ["/bin/zsh", str(link)], env=environment,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, timeout=10,
        )
        assert result.returncode == 0, result.stdout
        assert "update failed; retrying in 5 minutes" in result.stdout
        assert (root / "updates").read_text() == "2"
        assert (root / "sleep-intervals").read_text() == "300\n300\n"
        print("PASS: inherited Coder environment, retry, 300-second interval, symlink, termination")

        executable(commands / "crontab", '''
import os
from pathlib import Path
import sys
root = Path(os.environ["TEST_LOOP_ROOT"])
table = root / "crontab"
if sys.argv[1:] == ["-l"]:
    if not table.exists():
        sys.exit(1)
    print(table.read_text(), end="")
else:
    table.write_text(Path(sys.argv[1]).read_text())
    with (root / "crontab-writes").open("a") as output:
        output.write("write\\n")
''')

        def remove_cron():
            subprocess.run(
                ["/bin/zsh", "-fc",
                 'set -euo pipefail; source "$1"; '
                 'dotfiles_remove_cron_job "dotfiles: pull-figma-master"',
                 "test-cron", str(REPO / "utils.sh")],
                env=environment, check=True,
            )

        retained = "# user comment\n0 * * * * other-job\n0 * * * * other-job # dotfiles: pull-figma-master-extra\n"
        obsolete = "*/5 * * * * old-updater # dotfiles: pull-figma-master\n"
        table = root / "crontab"
        table.write_text(retained + obsolete)
        remove_cron()
        assert table.read_text() == retained
        remove_cron()
        assert (root / "crontab-writes").read_text() == "write\n"
        table.write_text(obsolete)
        remove_cron()
        assert table.read_text() == ""
        table.unlink()
        remove_cron()
        assert not table.exists()
        print("PASS: exact cron marker removal, preserve unrelated jobs, idempotence, no crontab")


if __name__ == "__main__":
    main()
