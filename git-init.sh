#!/usr/bin/env bash
# Run this once after cloning / moving the folder to init git and push to GitHub.
# Usage: ./git-init.sh <your-github-username>

set -euo pipefail

GITHUB_USER="${1:-}"

if [ -z "$GITHUB_USER" ]; then
  echo "Usage: ./git-init.sh <github-username>"
  exit 1
fi

REPO="dotfiles"

# (Re-)init git in case the .git dir is incomplete
rm -rf .git
git init -b main
git add -A
git commit -m "feat: initial dotfiles — tmux + neovim (catppuccin mocha)"

echo ""
echo "Now create a new repo on GitHub named '$REPO', then run:"
echo ""
echo "  git remote add origin git@github.com:${GITHUB_USER}/${REPO}.git"
echo "  git push -u origin main"
