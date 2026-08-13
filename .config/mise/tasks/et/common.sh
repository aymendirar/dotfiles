# shellcheck shell=bash
#
# Shared helpers for the et:* tasks. Deliberately not executable: mise only
# treats executable files in a tasks directory as tasks, so this stays a
# library rather than becoming an et:common task.

ET_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/et/et.cfg"
ET_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/et"
ET_PID_FILE="$ET_STATE_DIR/etserver.pid"
ET_LOG_FILE="$ET_STATE_DIR/etserver.log"

# Prints the pid recorded in the pid file, or fails if there isn't a usable one.
et_read_pid() {
  local pid
  [ -r "$ET_PID_FILE" ] || return 1
  pid=$(tr -dc '0-9' <"$ET_PID_FILE")
  [ -n "$pid" ] || return 1
  printf '%s\n' "$pid"
}

# A pid file outlives the process that wrote it, and the kernel reuses pid
# numbers, so a stale file can name something else entirely by the time we read
# it. Confirm the pid is a live etserver owned by this user before any signal.
et_pid_is_ours() {
  local pid=$1 comm uid
  [ -n "$pid" ] || return 1
  # no pipeline here: $? must be ps's, so a dead pid fails the check
  comm=$(ps -o comm= -p "$pid" 2>/dev/null) || return 1
  uid=$(ps -o uid= -p "$pid" 2>/dev/null) || return 1
  comm=${comm//[[:space:]]/}
  uid=${uid//[[:space:]]/}
  # macOS ps reports an absolute path, Linux reports the bare name
  [ "${comm##*/}" = "etserver" ] && [ "$uid" = "$(id -u)" ]
}

# Prints the pid of the running server, or fails if it isn't up.
et_running_pid() {
  local pid
  pid=$(et_read_pid) || return 1
  et_pid_is_ours "$pid" || return 1
  printf '%s\n' "$pid"
}
