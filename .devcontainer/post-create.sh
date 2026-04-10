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
