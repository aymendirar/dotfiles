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
