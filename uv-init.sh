#!/bin/bash
# Quick initialization script for new projects using uv + Claude Code template

set -e

PROJECT_NAME=${1:-$(basename "$PWD")}

echo "🚀 Initializing Claude Code + uv project: $PROJECT_NAME"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "✓ uv found: $(uv --version)"
echo ""

# Initialize uv project
echo "📝 Initializing project structure..."
if [ ! -f "pyproject.toml" ]; then
    uv init --name "$PROJECT_NAME"
fi

# Add dev dependencies
echo "📥 Adding dev dependencies..."
uv add --dev ruff pytest mypy

# Sync environment
echo "🔄 Syncing environment..."
uv sync

echo ""
echo "✅ Project initialized!"
echo ""
echo "Structure created:"
echo "  .venv/          - Virtual environment (uv-managed)"
echo "  pyproject.toml  - Project config"
echo "  uv.lock         - Locked dependencies"
echo ""
echo "Next steps:"
echo "  1. Activate: source .venv/bin/activate"
echo "  2. Run tests: uv run pytest"
echo "  3. Start Claude: claude"
echo ""
