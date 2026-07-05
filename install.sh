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
