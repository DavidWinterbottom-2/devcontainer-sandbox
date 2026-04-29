#!/usr/bin/env bash
# post-create-skills.sh — ensures skills from dotfiles are available in the workspace
set -euo pipefail

DOTFILES_SKILLS="$HOME/.dotfiles/skills"
WORKSPACE_SKILLS="/workspaces/devcontainer-sandbox/skills"

if [ -d "$DOTFILES_SKILLS" ]; then
  if [ ! -e "$WORKSPACE_SKILLS" ]; then
    ln -s "$DOTFILES_SKILLS" "$WORKSPACE_SKILLS"
    echo "✅ Symlinked dotfiles skills to workspace."
  else
    echo "Skills directory already exists in workspace."
  fi
else
  echo "No skills directory found in dotfiles."
fi
