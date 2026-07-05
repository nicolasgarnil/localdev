#!/bin/bash
# Symlink versioned dev config into place. Idempotent - safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$REPO_DIR/.claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
link "$REPO_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$REPO_DIR/AGENTS.md" "$HOME/.claude/AGENTS.md"
link "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
link "$REPO_DIR/.zshrc" "$HOME/.zshrc"

# Machine-local shell secrets are not versioned: .zshrc sources ~/.zshrc.local.
# Seed it from the template on first install; never overwrite real values.
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$REPO_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
  chmod 600 "$HOME/.zshrc.local"
  echo "created $HOME/.zshrc.local from template - fill in real values"
fi

# Git identity is machine-local (not versioned): the shared .gitconfig includes
# ~/.gitconfig.local. Prompt for it, offering the existing value as the default.
local_config="$HOME/.gitconfig.local"
current_name=$(git config --file "$local_config" user.name 2>/dev/null || true)
current_email=$(git config --file "$local_config" user.email 2>/dev/null || true)

read -rp "Git user name${current_name:+ [$current_name]}: " name
name=${name:-$current_name}
read -rp "Git user email${current_email:+ [$current_email]}: " email
email=${email:-$current_email}

git config --file "$local_config" user.name "$name"
git config --file "$local_config" user.email "$email"
echo "wrote git identity to $local_config"
