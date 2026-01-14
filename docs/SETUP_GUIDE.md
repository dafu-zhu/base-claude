# Boris Workflow Setup Guide

Step-by-step guide to set up the Boris Claude Code workflow for Python projects.

---

## Prerequisites

- [ ] Claude Code CLI installed (`claude` command works)
- [ ] Python 3.8+
- [ ] Git configured
- [ ] GitHub account

---

## Step 1: Install uv and Dependencies

```sh
# Install uv (fast Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
uv --version

# Initialize project with dependencies
uv init
uv add --dev ruff pytest mypy

# Or sync from existing pyproject.toml
uv sync

# Verify installations
uv run ruff --version
uv run pytest --version
```

**Check:** Run `uv --version` - should show version number.

**Why uv?** 10-100x faster than pip, built-in virtual environment management, and lockfile for reproducible builds.

---

## Step 2: Set Up iTerm2 Notifications

1. Open iTerm2 → Preferences → Profiles → Terminal
2. Enable "Send notification when idle" or configure Shell Integration
3. See full guide: https://code.claude.com/docs/en/terminal-config#iterm-2-system-notifications

**Why:** Get notified when Claude needs input across 5 parallel tabs.

---

## Step 3: Configure GitHub Token

For GitHub MCP to work:

```sh
# Generate token at: https://github.com/settings/tokens
# Needs: repo, read:org scopes

# Add to shell profile (~/.zshrc or ~/.bashrc)
export GITHUB_TOKEN="ghp_your_token_here"

# Reload shell
source ~/.zshrc
```

**Check:** Run `echo $GITHUB_TOKEN` - should show your token.

---

## Step 4: Install GitHub CLI

```sh
# macOS
brew install gh

# Authenticate
gh auth login

# Verify
gh pr list
```

**Check:** `gh pr list` shows your PRs (or empty list).

---

## Step 5: Test the Setup

### 5a. Test Slash Command

```sh
cd /path/to/your/project
claude
```

Then type: `/commit-push-pr`

Should show git status and recent commits.

### 5b. Test Auto-Format Hook

In Claude, ask it to edit any `.py` file. After edit, ruff should auto-run.

### 5c. Test GitHub MCP

Ask Claude: "list my open PRs on GitHub"

---

## Step 6: Install GitHub Action

In Claude Code, run:

```
/install-github-action
```

Follow prompts to enable @.claude PR reviews.

---

## Step 7: Set Up Parallel Workflow

1. Open iTerm2
2. Create 5 tabs (Cmd+T)
3. Rename tabs 1-5 (right-click → Edit Tab Title)
4. Run `claude` in each tab
5. Use notifications to know when each needs input

**Pro tip:** Also run sessions on https://claude.ai/code for 10+ parallel Claudes.

---

## Step 8: Learn Key Workflows

### CRITICAL: Always Start in Plan Mode
**Default workflow:** Press `Shift+Tab` twice BEFORE giving any coding task.

**Use plan mode for:**
- ✅ Creating any PR (100% of the time)
- ✅ Adding features, even small ones
- ✅ Multi-file changes or refactors
- ✅ Bug fixes beyond single-line changes
- ✅ Performance optimizations
- ✅ Any code change affecting existing behavior
- ✅ When you're unsure what the best approach is

**Skip plan mode only for:**
- ❌ Single-line typo fixes
- ❌ Adding a single console.log for debugging
- ❌ Pure research/exploration questions

**Why this matters:** Plan mode prevents wasted implementation time. Claude will explore your codebase, understand existing patterns, and draft an approach for your approval. This 30-second planning step eliminates 5+ minutes of back-and-forth fixes from wrong implementations.

**Mental model:** Would you create a PR for this change? → Use plan mode.

### Use Opus 4.5
Run `/model` and select Opus 4.5 for best results.

### Verify Your Work
Always give Claude a way to verify (tests, browser, CLI output).

---

## File Reference

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project instructions for Claude |
| `.claude/settings.json` | Hooks + allowed commands |
| `.claude/commands/commit-push-pr.md` | Git workflow slash command |
| `.mcp.json` | MCP server configs |

---

## Use as Template for New Projects

### Method 1: GitHub Template (Recommended)
1. Click "Use this template" on GitHub
2. Clone your new repo
3. Run `./uv-init.sh` to set up dependencies

### Method 2: Manual Copy
```sh
# Copy template files to new project
cp -r .claude/ /path/to/new-project/
cp CLAUDE.md /path/to/new-project/
cp .mcp.json /path/to/new-project/
cp pyproject.toml /path/to/new-project/
cp .gitignore /path/to/new-project/

cd /path/to/new-project/
uv init  # Or use copied pyproject.toml
uv sync
```

### Method 3: Quick Script
```sh
cd /path/to/new-project/
/path/to/claude-code-setup/uv-init.sh
```

Then customize `CLAUDE.md` for project-specific notes.

---

## Whitelisted Commands Reference

Commands pre-allowed in `.claude/settings.json` (no permission prompts):

| Category | Commands |
|----------|----------|
| **Git** | `git:*` (all git operations) |
| **Utils** | `ls`, `tree`, `pwd`, `which`, `echo`, `date`, `wc`, `head`, `tail`, `diff` |
| **Python** | `python`, `python3`, `pip`, `pip3`, `ruff`, `pytest`, `mypy`, `uv`, `conda` |
| **Cloud** | `gh:*`, `aws:*`, `docker:*` |
| **K8s** | `kubectl get`, `kubectl describe`, `kubectl logs` (read-only) |

To add more, edit `.claude/settings.json`:
```json
"allowedCommands": [
  "your-command:*"
]
```

---

## Troubleshooting

### Ruff not running on edit
- Check: `which ruff` returns a path
- Check: `.claude/settings.json` exists in project root

### GitHub MCP not working
- Check: `echo $GITHUB_TOKEN` shows token
- Check: Token has `repo` scope
- Restart Claude session after setting token

### Slash command not found
- Check: `.claude/commands/` directory exists
- Check: File ends in `.md`

---

## Next Steps

- [ ] Add project-specific notes to `CLAUDE.md`
- [ ] Create custom subagents for your workflow
- [ ] Set up Confluence integration (if needed)
- [ ] Share `.claude/` configs with team via git
