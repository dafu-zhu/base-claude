# Automated Workflow - Quick Reference

## Commands

| Command | Action |
|---------|--------|
| `/ralph` | Start self-improvement loop |
| `/automated-workflow task.md` | Run automated task |
| `/milestone-issue` | Create GitHub milestone |
| `/compact-checkpoint` | Save state & compact |
| `/compact` | Manual context compaction |

## Files

| File | Purpose |
|------|---------|
| `~/.claude/preferences.md` | Global behavior |
| `.claude/agent-state.json` | Live progress |
| `.claude/locks.json` | Resource locks |
| `~/.claude/learnings.jsonl` | Knowledge base |

## Workflow Modes

**Stand-by** (Interactive)
- You control flow
- Exploration, questions, review

**Automated** (Autonomous)
- AI runs until done
- Clear goal, defined criteria

## Planning

Every implementation → Plan mode (automatic)

Plan includes:
- Multiple phases
- Specific TODOs
- Unresolved questions

## GitHub

Branch naming:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation

Auto-created:
- Branches (before edits)
- Milestone issues (at checkpoints)
- PRs (at completion)

## Communication

Extreme conciseness:
```
[12:30] Scanning...
[12:31] Found 5 issues
[12:32] Fixing auth.py:45
[12:33] Tests passed. Committed.
```

Commits:
```
feat: add auth
fix: SQL injection
docs: update API
```

## Safety Bounds

Default limits:
- Iterations: 50
- Cost: $10
- Time: 2h
- Files/iteration: 10

## Expert Delegation

Auto-delegate to GPT:
- Architecture → Architect
- Security → Security Analyst
- Code review → Code Reviewer
- After 2 failures → Architect

## Context Management

Auto-compact after:
- TODO completion
- Phase completion
- Every 10 tool calls
- Expert delegation

## Ralph Loop

```
Scan → Prioritize → Plan → Implement
  ↓
Verify → Review → Learn → Next
  ↑__________________|
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Hooks not running | `chmod +x ~/.claude/hooks/*.sh` |
| Context too large | `/compact` |
| Workflow stuck | `cat .claude/agent-state.json` |
| Learnings not applied | `tail ~/.claude/learnings.jsonl` |

## Quick Start

```bash
# Code improvement
/ralph

# Custom task
cp ~/.claude/templates/automated-task-template.md task.md
# Edit task.md
/automated-workflow task.md

# Interactive
"Add authentication"  # Auto enters plan mode
```

## Key Preferences

- ✓ Extreme conciseness
- ✓ Always plan mode
- ✓ Multi-phased plans
- ✓ GitHub CLI (gh)
- ✓ Auto-branch creation
- ✓ Milestone issues
- ✓ Auto-compact

## Status Check

```bash
# Live progress
cat .claude/agent-state.json

# Learnings
tail ~/.claude/learnings.jsonl

# Locks
cat .claude/locks.json
```

---

**Full docs**: `~/.claude/AUTOMATED-WORKFLOW-GUIDE.md`
**System summary**: `~/.claude/SYSTEM-SUMMARY.md`
