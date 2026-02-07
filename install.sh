#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
#  Thriven OS — One-Shot Installer
#
#  For new users:
#    bash install.sh YOUR_DEPLOY_TOKEN
#
#  Or if Homebrew is already installed:
#    mkdir -p ~/.config/thriven && echo 'TOKEN' > ~/.config/thriven/token
#    brew tap thrive-intelligence/thriven && brew install thriven
# ═══════════════════════════════════════════════════════
set -euo pipefail

TOKEN="${1:-}"

echo ""
echo "  ╔═══════════════════════════════════╗"
echo "  ║   Thriven OS — Installing...      ║"
echo "  ╚═══════════════════════════════════╝"
echo ""

# ─── 0. Token ────────────────────────────────────────
if [[ -z "$TOKEN" ]]; then
  if [[ -f "$HOME/.config/thriven/token" ]]; then
    TOKEN=$(cat "$HOME/.config/thriven/token")
    echo "[0/5] Deploy token ✓ (from ~/.config/thriven/token)"
  else
    echo "ERROR: Deploy token required."
    echo ""
    echo "  Usage: bash install.sh YOUR_DEPLOY_TOKEN"
    echo ""
    echo "  Get your token from your Thriven admin."
    exit 1
  fi
else
  echo "[0/5] Saving deploy token..."
  mkdir -p "$HOME/.config/thriven"
  echo "$TOKEN" > "$HOME/.config/thriven/token"
fi

# ─── 1. Xcode CLT + Homebrew ────────────────────────
if ! command -v brew &>/dev/null; then
  echo "[1/5] Installing Homebrew (this takes a few minutes)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "[1/5] Homebrew ✓"
fi

# ─── 2. Tap + Install ───────────────────────────────
echo "[2/5] Installing Thriven via Homebrew..."
brew tap thrive-intelligence/thriven
brew install thriven

# ─── 3. Docker Desktop (optional) ───────────────────
if ! command -v docker &>/dev/null; then
  echo "[3/5] Installing Docker Desktop..."
  brew install --cask docker
  echo "  ⚠  Docker installed. Open it from Applications to finish setup."
else
  echo "[3/5] Docker ✓"
fi

# ─── 4. Initialize project ──────────────────────────
PROJECT_DIR="$HOME/thriven-project"
echo "[4/5] Setting up project in $PROJECT_DIR..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
thriven init --yes

# ─── 5. Health check ────────────────────────────────
echo "[5/5] Running health check..."
echo ""
thriven doctor

echo ""
echo "  ╔═══════════════════════════════════╗"
echo "  ║   Thriven OS — Install Complete   ║"
echo "  ╚═══════════════════════════════════╝"
echo ""
echo "  Next steps:"
echo "    cd $PROJECT_DIR"
echo "    claude"
echo ""
echo "  Thriven activates automatically."
echo ""
