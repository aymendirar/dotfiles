#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SETUP_DIR/.." && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=../utils.sh
source "$REPO_DIR/utils.sh"
ENV_FILE="${ENV_FILE:-$SETUP_DIR/.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "missing $ENV_FILE (copy .env.example to .env and fill it in)" >&2
  exit 1
fi
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${VPS_HOST:?Set VPS_HOST in $ENV_FILE}"
: "${VPS_PASSWORD:?Set VPS_PASSWORD in $ENV_FILE}"
VPS_USER="${VPS_USER:-root}"
VPS_PORT="${VPS_PORT:-22}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"

dotfiles_require_command sshpass "sshpass is required: brew install hudochenkov/sshpass/sshpass"

ssh_opts=(-p "$VPS_PORT" -o StrictHostKeyChecking=accept-new)

if [ ! -f "$SSH_KEY" ]; then
  echo "==> generating ssh key at $SSH_KEY"
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "$(whoami)@$(hostname -s)-vps"
fi

echo "==> installing public key on $VPS_HOST (using initial password)"
SSHPASS="$VPS_PASSWORD" sshpass -e ssh "${ssh_opts[@]}" "$VPS_USER@$VPS_HOST" \
  "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" \
  < "${SSH_KEY}.pub"

echo "==> verifying key-based auth"
ssh "${ssh_opts[@]}" -o BatchMode=yes -i "$SSH_KEY" "$VPS_USER@$VPS_HOST" "echo ok" >/dev/null

echo "==> syncing dotfiles to VPS"
ssh "${ssh_opts[@]}" -i "$SSH_KEY" "$VPS_USER@$VPS_HOST" "mkdir -p ~/dotfiles"
rsync -az --delete -e "ssh ${ssh_opts[*]} -i $SSH_KEY" \
  --exclude '.git' --exclude 'vps-setup/.env' \
  "$REPO_DIR/" "$VPS_USER@$VPS_HOST:~/dotfiles/"

echo "==> running vps-install.sh on the VPS"
ssh "${ssh_opts[@]}" -i "$SSH_KEY" "$VPS_USER@$VPS_HOST" "chmod +x ~/dotfiles/vps-install.sh && ~/dotfiles/vps-install.sh"

echo "==> installing ghostty terminfo on the VPS"
if infocmp -x xterm-ghostty >/dev/null 2>&1; then
  infocmp -x xterm-ghostty | ssh "${ssh_opts[@]}" -i "$SSH_KEY" "$VPS_USER@$VPS_HOST" -- tic -x -
else
  echo "    xterm-ghostty terminfo not found locally (run this from a Ghostty window, not tmux or another terminal) — skipping"
fi

echo
echo "done. ssh in with: ssh $VPS_USER@$VPS_HOST"
