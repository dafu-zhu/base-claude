# Quick Workflow Reference

## Starting a New Project with This Template

### Option 1: GitHub (Recommended)
```sh
# 1. Click "Use this template" on GitHub
# 2. Clone your new repo
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT

# 3. Initialize with uv
./uv-init.sh

# 4. Start coding
source .venv/bin/activate
claude
```

### Option 2: Local Copy
```sh
# 1. Create new project directory
mkdir my-new-project && cd my-new-project

# 2. Copy template files
cp -r /path/to/claude-code-setup/.claude .
cp /path/to/claude-code-setup/{CLAUDE.md,.mcp.json,pyproject.toml,.gitignore} .

# 3. Initialize with uv
uv init
uv sync

# 4. Start coding
source .venv/bin/activate
claude
```

---

## Daily Development Commands

### Environment
```sh
source .venv/bin/activate  # Activate environment
```

### Dependencies
```sh
uv add package-name        # Add runtime dependency
uv add --dev pytest-cov    # Add dev dependency
uv sync                    # Install all dependencies
uv lock --upgrade          # Update lockfile
```

### Testing & Quality
```sh
uv run pytest              # Run all tests
uv run pytest -x           # Stop on first failure
uv run pytest -k "name"    # Run specific test
uv run ruff check .        # Lint code
uv run ruff format .       # Format code
uv run mypy .              # Type check
```

### Git Workflow (in Claude Code)
```
/commit-push-pr            # Commit, push, and create PR
```

Or manually:
```sh
git add .
git commit -m "Your message"
git push
gh pr create
```

---

## Claude Code Tips

### Parallel Development
Open 5 iTerm tabs, run `claude` in each:
- Tab 1: Main feature work
- Tab 2: Tests
- Tab 3: Documentation
- Tab 4: Bug fixes
- Tab 5: Refactoring

Enable iTerm notifications to know when Claude needs input.

### Key Shortcuts
- `Shift+Tab` twice: Enter plan mode before complex tasks
- `/model`: Switch between Sonnet/Opus
- `/commit-push-pr`: Git workflow
- `Ctrl+C`: Interrupt Claude

### Best Practices
1. **Always use plan mode** for multi-file changes
2. **Give Claude verification methods** (tests, CLI output, browser)
3. **Let auto-formatting work** - hooks run ruff automatically
4. **Use uv run** for consistency - ensures correct environment

---

## File Structure

```
your-project/
├── .claude/
│   ├── settings.json              # Hooks + allowed commands
│   └── commands/
│       └── commit-push-pr.md      # Git workflow slash command
├── .venv/                         # Virtual environment (gitignored)
├── CLAUDE.md                      # Instructions for Claude
├── .mcp.json                      # MCP server config
├── pyproject.toml                 # Project config
├── uv.lock                        # Locked dependencies
└── .gitignore                     # Git ignore rules
```

---

## Customizing for Your Project

### 1. Update CLAUDE.md
Add project-specific instructions:
```markdown
## Project Notes
- API keys: Set OPENAI_API_KEY in .env
- Database: Run `docker-compose up -d postgres`
- Main branch: `main` (requires PR)
```

### 2. Add Custom Commands
Create `.claude/commands/my-command.md`:
```markdown
# My Command

Run my custom workflow...
```

Use with: `/my-command`

### 3. Whitelist New Tools
Edit `.claude/settings.json`:
```json
"allowedCommands": [
  "existing:*",
  "your-new-tool:*"
]
```

### 4. Add MCP Servers
Edit `.mcp.json`:
```json
"mcpServers": {
  "your-server": {
    "command": "npx",
    "args": ["-y", "@your/mcp-server"]
  }
}
```

---

## Troubleshooting

### uv not found
```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"
```

### Dependencies not syncing
```sh
rm -rf .venv uv.lock
uv sync
```

### Ruff not auto-running
Check `.claude/settings.json` exists in project root and contains the PostToolUse hook.

### GitHub MCP failing
```sh
echo $GITHUB_TOKEN  # Should show token
# If empty, add to ~/.zshrc:
export GITHUB_TOKEN="ghp_..."
source ~/.zshrc
```

---

## Resources

- [Claude Code Docs](https://code.claude.com/docs)
- [uv Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [GitHub CLI](https://cli.github.com/)
