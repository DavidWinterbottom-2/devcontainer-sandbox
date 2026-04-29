#!/usr/bin/env bash
# post-create-mcp.sh — ensures remote-mcp-servers from dotfiles are available in the workspace
set -euo pipefail

DOTFILES_MCP="$HOME/.dotfiles/remote-mcp-servers"
WORKSPACE_MCP="/workspaces/devcontainer-sandbox/.devcontainer/remote-mcp-servers"

if [ -d "$DOTFILES_MCP" ]; then
  if [ ! -e "$WORKSPACE_MCP" ]; then
    ln -s "$DOTFILES_MCP" "$WORKSPACE_MCP"
    echo "✅ Symlinked dotfiles remote-mcp-servers to workspace."
  else
    echo "remote-mcp-servers directory already exists in workspace."
  fi
else
  echo "No remote-mcp-servers directory found in dotfiles."
fi
