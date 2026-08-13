# .files

handy dandy settings, defaults, and configurations

## Eternal Terminal on a Coder devbox

A plain `ssh` session dies when the laptop changes network or sleeps. Eternal
Terminal reconnects instead of dropping, so the shell (and whatever is running
in it) survives.

ET uses ssh only for the initial authentication and key exchange. Once that
completes the terminal runs over ET's own connection, and that connection is
what reconnects — so an interrupted network no longer costs you the session.

### Client setup (macOS)

```bash
brew install et
brew install --cask coder/coder/coder-desktop
```

Then sign in to <https://coder.figdev.systems> in Coder Desktop and enable
**Coder Connect**.

### Connecting

```bash
et devcontainer.aymen-devbox-2.adirar.coder
```

That is the whole flow. Coder Connect publishes the workspace's TCP ports at
its `.coder` hostname, so ET reaches `etserver` on 2022 with no tunnel to set
up and no SSH alias to maintain.

`bin/coder-et` is an optional convenience wrapper that starts the server first
and then execs the same command:

```bash
coder-et devcontainer.aymen-devbox-2.adirar.coder
```

### Server setup

On the devbox, `install.sh` installs `et` from `ppa:jgmath2000/et`, links the
server config to `~/.config/et/et.cfg`, links the task directory into mise, and
runs `mise run et:start`. Managing it afterwards:

```bash
mise run et:start    # idempotent
mise run et:status
mise run et:stop
```

The PID and log live under `~/.local/state/et`. There is no systemd in the
devcontainer, so the tasks daemonize `etserver` themselves and track it by PID
file, checking that the recorded PID really is this user's `etserver` before
signalling it.

The server binds `127.0.0.1` only. Coder Connect and `coder port-forward` both
reach it from inside the workspace, so loopback costs nothing and keeps the
terminal port off the workspace network. Telemetry is disabled.

### Verifying

```bash
coder connect exists devcontainer.aymen-devbox-2.adirar.coder
nc -vz devcontainer.aymen-devbox-2.adirar.coder 2022
et devcontainer.aymen-devbox-2.adirar.coder --command 'printf ET_CODER_OK'
```

The last command prints `ET_CODER_OK` and exits 0.

### On a VPS

`vps-install.sh` installs `et` from the same PPA, copies
`.config/et/et.vps.cfg` to `/etc/et.cfg`, and enables the packaged systemd
unit. A VPS has systemd, so the `et:*` mise tasks are not used there:

```bash
systemctl status et
```

The VPS config binds `0.0.0.0` rather than loopback, because the box is dialled
straight from the internet instead of through a Coder tunnel. ET requires a
full ssh handshake before handing over a terminal, so it is ssh-authenticated
rather than an open shell, but keep the port behind a firewall that only admits
addresses you actually connect from. Connect with:

```bash
et user@vps-hostname
```

### Fallback: machines without Coder Desktop

**Not the normal flow.** Only for a machine that cannot run Coder Connect.
Forward the port by hand, in its own terminal:

```bash
coder port-forward aymen-devbox-2.devcontainer --tcp 127.0.0.1:12022:2022
```

Then, because ET still needs to ssh somewhere to authenticate and the address
it has been handed is loopback, route that handshake through Coder's ssh:

```bash
et ubuntu@127.0.0.1:12022 \
  --ssh-option "ProxyCommand=coder ssh --stdio aymen-devbox-2.devcontainer" \
  --ssh-option StrictHostKeyChecking=no \
  --ssh-option UserKnownHostsFile=/dev/null
```

Host key checking is off for that hop because the loopback address means a
different machine for every workspace. Remember to stop the port-forward when
finished.
