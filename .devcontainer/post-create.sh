#!/usr/bin/env bash
# post-create.sh — runs once after the devcontainer is first created
set -euo pipefail

echo "🔧 Running post-create setup..."

# ── Git config (uses your host git identity automatically via VS Code) ────────
git config --global core.editor "code --wait"
git config --global push.autoSetupRemote true

# ── Python: set up a default venv if a requirements.txt exists ───────────────
if [ -f "requirements.txt" ]; then
  echo "📦 Installing Python dependencies..."
  python3 -m venv .venv
  .venv/bin/pip install --upgrade pip
  .venv/bin/pip install -r requirements.txt
fi

# ── Node.js: install deps if a package.json exists ───────────────────────────
if [ -f "package.json" ]; then
  echo "📦 Installing Node dependencies..."
  npm install
fi

echo "✅ Post-create setup complete."

# ── Clone and install dotfiles ─────────────────────────────────────────────
echo "🔧 Cloning and installing dotfiles..."
DOTFILES_REPO="https://github.com/DavidWinterbottom-2/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  if [ -f "$DOTFILES_DIR/install" ]; then
    chmod +x "$DOTFILES_DIR/install"
    "$DOTFILES_DIR/install"
  fi
else
  echo "Dotfiles already cloned. Skipping."
fi

# ── SSH Agent setup ────────────────────────────────────────────────────────
# VS Code forwards the WSL host's SSH agent into the container via SSH_AUTH_SOCK.
# If that agent has no identities (WSL agent not set up), we add the mounted keys
# to it directly. If no agent is reachable at all, we start a local persistent one.
echo "🔑 Setting up SSH agent..."

ssh-add -l &>/dev/null
_ssh_rc=$?

if [ $_ssh_rc -eq 0 ]; then
  echo "  SSH agent already has identities loaded (forwarded from host)."
elif [ $_ssh_rc -eq 1 ]; then
  # Agent socket reachable but empty — add the mounted key files to it
  echo "  Agent reachable but empty; adding mounted keys..."
  [ -f "$HOME/.ssh/id_ed25519" ] && ssh-add "$HOME/.ssh/id_ed25519" && echo "  + id_ed25519" || true
  [ -f "$HOME/.ssh/id_rsa"     ] && ssh-add "$HOME/.ssh/id_rsa"     && echo "  + id_rsa"     || true
else
  echo "  No agent reachable; starting local persistent agent..."
  export SSH_AUTH_SOCK="$HOME/.ssh/ssh-agent.sock"
  rm -f "$SSH_AUTH_SOCK"
  eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" > /dev/null
  [ -f "$HOME/.ssh/id_ed25519" ] && ssh-add "$HOME/.ssh/id_ed25519" && echo "  + id_ed25519" || true
  [ -f "$HOME/.ssh/id_rsa"     ] && ssh-add "$HOME/.ssh/id_rsa"     && echo "  + id_rsa"     || true
fi

# ~/.bashrc_custom (from dotfiles) handles _init_ssh_agent for all future shells.
