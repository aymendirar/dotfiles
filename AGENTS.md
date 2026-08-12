# Dotfiles Repository

- `.agents/global.md` is the canonical global policy and is linked into each agent's global instruction path. Keep root `AGENTS.md` repository-specific so the global policy is not loaded twice.
- Treat tracked configuration as the source of truth. Do not edit installed copies in the home directory instead of their tracked sources.
- Do not run `install.sh`, `update.sh`, or `vps-install.sh` unless explicitly requested; they modify live configuration and may install software.
- After changing shell scripts, run `zsh -n copy.sh install.sh update.sh utils.sh` and `bash -n utils.sh vps-install.sh vps-setup/setup.sh`.
