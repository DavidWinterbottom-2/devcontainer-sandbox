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
echo "🔑 Setting up SSH agent..."
eval "$(ssh-agent -s)"
if [ -f "$HOME/.ssh/id_rsa" ]; then
  ssh-add "$HOME/.ssh/id_rsa"
else
  echo "No default SSH key found in ~/.ssh. You may need to add one manually."
fi
