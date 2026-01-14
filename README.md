# Claude Code Setup Template

A production-ready template for Python projects using Claude Code with `uv` for fast dependency management.

## Quick Start

### 1. Use This Template

**Option A: On GitHub**
```sh
# Click "Use this template" button on GitHub, then:
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

**Option B: Manual Copy**
```sh
# Copy template files to new project
cp -r .claude/ /path/to/new-project/
cp CLAUDE.md /path/to/new-project/
cp .mcp.json /path/to/new-project/
cp pyproject.toml /path/to/new-project/  # if using uv init, this is optional
```

### 2. Initialize with uv

```sh
# Install uv if needed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Initialize project
uv init
uv add --dev ruff pytest mypy

# Install dependencies
uv sync
```

### 3. Configure GitHub Token

```sh
# Create token at: https://github.com/settings/tokens
# Scopes needed: repo, read:org

# Add to ~/.zshrc or ~/.bashrc
export GITHUB_TOKEN="ghp_your_token_here"

# Reload
source ~/.zshrc
```

### 4. Start Claude

```sh
claude
```

## What's Included

- **`.claude/settings.json`** - Auto-formatting hooks + whitelisted commands
- **`.claude/commands/commit-push-pr.md`** - Git workflow slash command
- **`CLAUDE.md`** - Project instructions for Claude (uv-based workflow)
- **`.mcp.json`** - GitHub MCP server configuration
- **`pyproject.toml`** - Python project config with ruff/pytest settings

## Features

✅ **Auto-formatting** - Ruff runs automatically on every Python file edit
✅ **Pre-whitelisted commands** - No permission prompts for git, gh, uv, pytest, etc.
✅ **GitHub integration** - MCP server for PR management
✅ **Slash commands** - `/commit-push-pr` for streamlined git workflow
✅ **Fast dependencies** - `uv` for 10-100x faster installs than pip

## Workflow

```sh
# Daily development
source .venv/bin/activate
uv run pytest          # Run tests
uv run ruff check .    # Lint

# Add dependencies
uv add requests
uv add --dev pytest-cov

# Git workflow
/commit-push-pr        # In Claude Code
```

See **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** for detailed setup instructions.

## Customization

Edit `CLAUDE.md` to add project-specific notes:
- API keys location
- Database connection steps
- Deployment commands
- Team conventions

## Requirements

- Python 3.8+
- Claude Code CLI
- `uv` (recommended) or `pip`
- Git + GitHub CLI

## License

MIT - Use freely for your projects.
