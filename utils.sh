# shellcheck shell=bash
# Shared helpers for the dotfiles Bash and Zsh scripts.

dotfiles_path_exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

dotfiles_trash_directory_contents() {
  local directory="$1"
  if [ -d "$directory" ]; then
    find "$directory" -mindepth 1 -maxdepth 1 -exec trash {} \;
  fi
}

dotfiles_ensure_directory() {
  local directory="$1"
  if [ -d "$directory" ]; then
    return
  fi
  if dotfiles_path_exists "$directory"; then
    mv "$directory" "${directory}.bak.$(date +%s)"
  fi
  mkdir -p "$directory"
}

dotfiles_ensure_git_checkout() {
  local repository="$1"
  local directory="$2"
  local checkout_root
  local directory_root
  local origin_url

  if [ -d "$directory" ]; then
    if ! checkout_root="$(git -C "$directory" rev-parse --show-toplevel 2>/dev/null)"; then
      printf 'existing checkout path is not a Git worktree: %s\n' "$directory" >&2
      return 1
    fi
    checkout_root="$(cd "$checkout_root" && pwd -P)"
    directory_root="$(cd "$directory" && pwd -P)"
    if [ "$checkout_root" != "$directory_root" ]; then
      printf 'checkout path belongs to another Git worktree: %s\n' "$directory" >&2
      return 1
    fi
    if ! origin_url="$(git -C "$directory" remote get-url origin 2>/dev/null)"; then
      printf 'checkout has no origin remote: %s\n' "$directory" >&2
      return 1
    fi
    if [ "$origin_url" != "$repository" ]; then
      printf 'checkout origin does not match %s: %s\n' "$repository" "$directory" >&2
      return 1
    fi
    return
  fi
  if dotfiles_path_exists "$directory"; then
    printf 'existing checkout path is not a directory: %s\n' "$directory" >&2
    return 1
  fi
  git clone "$repository" "$directory"
}

dotfiles_force_symlink() {
  local source_path="$1"
  local destination_path="$2"
  mkdir -p "$(dirname "$destination_path")"
  ln -sfn "$source_path" "$destination_path"
}

dotfiles_backup_and_symlink() {
  local source_path="$1"
  local destination_path="$2"

  if [ ! -e "$source_path" ]; then
    printf 'missing symlink source: %s\n' "$source_path" >&2
    return 1
  fi

  mkdir -p "$(dirname "$destination_path")"

  if [ -L "$destination_path" ] && [ "$(readlink "$destination_path")" = "$source_path" ]; then
    return
  fi
  if dotfiles_path_exists "$destination_path"; then
    mv "$destination_path" "${destination_path}.bak.$(date +%s)"
  fi
  ln -s "$source_path" "$destination_path"
}

# never displaces an existing skill: a name that is already taken is reported and
# skipped, because shadowing an agent's own skill is silent and hard to notice
dotfiles_link_skill() {
  local source_path="$1"
  local destination_path="$2"

  if [ -L "$destination_path" ]; then
    if [ "$(readlink "$destination_path")" = "$source_path" ]; then
      return 0
    fi
    printf 'skill collision: %s already links to %s, leaving it\n' \
      "$destination_path" "$(readlink "$destination_path")" >&2
    return 1
  fi

  if dotfiles_path_exists "$destination_path"; then
    printf 'skill collision: %s already exists, not shadowing it with %s\n' \
      "$destination_path" "$source_path" >&2
    return 1
  fi

  ln -s "$source_path" "$destination_path"
}

dotfiles_link_agent_skills() {
  local source_dir="$1"
  shift

  if [ ! -d "$source_dir" ]; then
    printf 'note: no skills directory at %s, skipping agent skill links\n' "$source_dir" >&2
    return
  fi

  local skills_root
  local skill_dir
  local collisions=0

  for skills_root in "$@"; do
    # agents ship their own skills into these directories, so link per skill
    # rather than the root; drop a whole-root link left by an earlier install
    if [ -L "$skills_root" ]; then
      rm "$skills_root"
    fi
    dotfiles_ensure_directory "$skills_root"
    while IFS= read -r skill_dir; do
      [ -n "$skill_dir" ] || continue
      [ -f "$skill_dir/SKILL.md" ] || continue
      if ! dotfiles_link_skill "$skill_dir" "$skills_root/$(basename "$skill_dir")"; then
        collisions=$((collisions + 1))
      fi
    done <<EOF
$(find "$source_dir" -mindepth 1 -maxdepth 1 -type d)
EOF
  done

  # a name clash is worth fixing, but not worth failing the whole install over
  if [ "$collisions" -gt 0 ]; then
    printf 'warning: skipped %d skill link(s) whose name is already taken; rename yours in %s\n' \
      "$collisions" "$source_dir" >&2
  fi
}

# skills are stored per repository in the state checkout, so link every
# repos/<repo>/skills directory rather than naming one of them here
dotfiles_link_state_skills() {
  local state_dir="$1"
  shift

  if [ ! -d "$state_dir/repos" ]; then
    printf 'note: no state checkout at %s, skipping agent skill links\n' "$state_dir" >&2
    return
  fi

  local source_dir
  while IFS= read -r source_dir; do
    [ -n "$source_dir" ] || continue
    dotfiles_link_agent_skills "$source_dir" "$@"
  done <<EOF
$(find "$state_dir/repos" -mindepth 2 -maxdepth 2 -type d -name skills)
EOF
}

dotfiles_install_tmux_plugins() {
  local plugins_dir="${HOME}/.tmux/plugins"
  local tpm_dir="${plugins_dir}/tpm"
  local catppuccin_dir="${HOME}/.tmux/catppuccin/tmux"
  local reload_tmux=false

  if tmux list-sessions >/dev/null 2>&1; then
    reload_tmux=true
  fi

  mkdir -p "$plugins_dir" "$(dirname "$catppuccin_dir")"

  if [ ! -d "$tpm_dir/.git" ]; then
    if dotfiles_path_exists "$tpm_dir"; then
      printf 'existing TPM path is not a Git checkout: %s\n' "$tpm_dir" >&2
      return 1
    fi
    git clone --depth=1 https://github.com/tmux-plugins/tpm.git "$tpm_dir"
  fi

  if [ ! -d "$catppuccin_dir/.git" ]; then
    if dotfiles_path_exists "$catppuccin_dir"; then
      printf 'existing Catppuccin path is not a Git checkout: %s\n' "$catppuccin_dir" >&2
      return 1
    fi
    git clone --depth=1 --branch v2.3.0 https://github.com/catppuccin/tmux.git "$catppuccin_dir"
  fi

  # keep an existing tmux server aligned with the path configured in tmux.conf
  tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$plugins_dir/"
  "$tpm_dir/bin/install_plugins"

  if [ "$reload_tmux" = true ]; then
    tmux source-file "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
  fi
}

dotfiles_update_editor_settings() {
  local editor_name="$1"
  local source_dir="$2"
  local user_dir="$3"

  if [ -d "$user_dir" ]; then
    echo "Updating ${editor_name} settings..."
    cp "$source_dir/settings.json" "$user_dir/settings.json"
    cp "$source_dir/keybindings.json" "$user_dir/keybindings.json"
  else
    echo "Warning: No ${editor_name} installation found"
  fi
}

dotfiles_capture_editor_settings() {
  local editor_name="$1"
  local user_dir="$2"
  local destination_dir="$3"

  if [ -f "$user_dir/settings.json" ]; then
    echo "Copying ${editor_name} settings..."
    mkdir -p "$destination_dir"
    cp "$user_dir/settings.json" "$destination_dir/settings.json"
    if [ -f "$user_dir/keybindings.json" ]; then
      cp "$user_dir/keybindings.json" "$destination_dir/keybindings.json"
    fi
  else
    echo "Warning: No ${editor_name} settings found"
  fi
}

dotfiles_require_command() {
  local command_name="$1"
  local install_hint="$2"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "$install_hint" >&2
    return 1
  fi
}
