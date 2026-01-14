# The "&" Command Tutorial: Session Handoff Between Terminal and Web

## What is the "&" Command?

The **`&` suffix** is a session management feature in Claude Code that uploads your current terminal session to [claude.ai/code](https://claude.ai/code) for web continuation. It enables seamless handoff of work between your terminal and browser.

**Think of it as:** A "send to web" button for your Claude Code session.

## Why Use It?

### Common Use Cases

1. **Continue work on another device** - Start in terminal, finish on laptop/tablet
2. **Share visual results** - Hand off to web for easier screenshot sharing
3. **Long-running tasks** - Move resource-intensive work to web while keeping terminal free
4. **Parallel workflows** - Run 5 terminal sessions + 10 web sessions simultaneously
5. **Mobile continuation** - Upload from terminal, check on phone via Claude iOS app

## Quick Start

### Basic Usage

```bash
# In your Claude Code session
claude> Fix the authentication bug &
```

**That's it!** The `&` at the end uploads your session to claude.ai/code.

### What Happens When You Use "&"

1. Claude completes the current task in your terminal
2. The full session (conversation + codebase context) uploads to claude.ai/code
3. You receive a link to continue the session in your browser
4. Terminal session ends, web session begins

## Complete Workflow: Terminal ↔ Web

### Scenario: Building a Feature Across Devices

**Step 1: Start in Terminal**
```bash
$ claude
claude> Create a new user authentication system with JWT tokens &
```

**Step 2: Continue in Browser**
- Claude completes the initial implementation
- Click the provided link to claude.ai/code
- Session continues in browser with full context
- Review, test, or extend the implementation

**Step 3: Bring Back to Terminal (Optional)**
```bash
$ claude --teleport
```

The `--teleport` flag pulls the web session back to your terminal, allowing you to continue locally.

### Full Session Management Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `&` | Upload terminal → web | `claude> Add dark mode &` |
| `--teleport` | Pull web → terminal | `claude --teleport` |
| `--resume` or `-c` | Continue any session | `claude --resume` |
| iOS app | Auto-sync all sessions | (Open Claude app) |

## Real-World Workflow: The Boris Pattern

This workflow comes from Boris, who runs **5 terminal sessions + 5-10 web sessions** in parallel:

### Terminal Setup (iTerm2)
```bash
# Tab 1: Main feature work
$ claude
claude> Implement user dashboard with analytics &

# Tab 2: Bug fixes
$ claude
claude> Fix the memory leak in data processing &

# Tab 3: Refactoring
$ claude -c  # Resume previous session
claude> Continue refactoring the API layer

# Tabs 4-5: Additional parallel work
```

### Web Sessions (Chrome)
- Open [claude.ai/code](https://claude.ai/code)
- 5-10 additional sessions running in parallel tabs
- Some started via `&`, others started directly on web
- All sessions share the same GitHub/codebase access

### Benefits of This Approach
✅ **Maximize throughput** - Work never blocks on a single Claude instance
✅ **Context switching** - Each session maintains its own focused context
✅ **Device flexibility** - Check on progress from phone, tablet, or different laptop
✅ **Resource distribution** - Heavy tasks on web, quick iterations in terminal

## Practical Examples

### Example 1: Visual UI Work
```bash
$ claude
claude> Add a new chart component to the dashboard &

# Uploads to web where you can:
# - Use browser DevTools to inspect
# - Take screenshots easily
# - Share with team via link
```

### Example 2: Long-Running Migration
```bash
$ claude
claude> Migrate the entire database schema to PostgreSQL &

# Frees your terminal for other work
# Check progress in browser
# Get notification when complete
```

### Example 3: Code Review Workflow
```bash
$ claude
claude> Review PR #123 and suggest improvements &

# Continue review in browser
# Add comments directly on GitHub via MCP
# Share review session link with team
```

### Example 4: Morning Workflow
```bash
# Start multiple tasks from terminal
$ claude
claude> Update all dependencies and fix breaking changes &

$ claude  # New session
claude> Write integration tests for payment service &

$ claude  # Another session
claude> Optimize database queries in analytics module &

# All three upload to web
# Check progress on phone during commute
# Pull back completed ones via --teleport later
```

## Advanced: Session Synchronization

### iOS App Integration
1. **Start on terminal:** `claude> Build feature X &`
2. **Uploads to claude.ai/code**
3. **Auto-syncs to iOS app**
4. **Check progress on phone**
5. **Return to laptop:** Session still available on web or via `--teleport`

### Parallel Sessions Strategy
```
Terminal (5 sessions)     Web (10 sessions)      Mobile (check-in)
├─ Feature A              ├─ Research task       └─ Monitor all
├─ Bug fix B             ├─ Documentation
├─ Refactor C            ├─ Code review
├─ Tests D               ├─ Performance work
└─ Migration E           └─ Dependency updates
```

**Total: 15+ Claude instances working in parallel**

## Troubleshooting

### Session Not Appearing on Web?
- Check your internet connection
- Ensure you're logged into the same Claude account
- Look for the upload confirmation message in terminal
- Check claude.ai/code directly in browser

### Lost Session Link?
- Go to [claude.ai/code](https://claude.ai/code)
- Recent sessions appear in session list
- Or use `claude --resume` in terminal to see all sessions

### Terminal Hangs During Upload?
- Press `Ctrl+C` to cancel
- Try again with a shorter command
- Check firewall/proxy settings

### Want to Keep Terminal Session Active?
- Don't use `&` suffix
- Instead, manually start a new session on web
- Both will run in parallel

## Tips & Best Practices

### ✅ DO
- Use `&` for long-running tasks you want to monitor later
- Combine with `--teleport` for true bidirectional workflow
- Start multiple sessions in parallel for different tasks
- Check in on web sessions periodically

### ❌ DON'T
- Use `&` for quick commands that finish in seconds
- Expect terminal session to continue after `&` (it uploads and ends)
- Use `&` if you need to stay in terminal for immediate follow-up

### Pro Tips
1. **Name your sessions** - Start with clear, specific prompts so you can identify web sessions later
2. **Use iTerm notifications** - Get alerted when sessions need input (see tutorial.md:7-9)
3. **Bookmark claude.ai/code** - Quick access to all your running sessions
4. **Check mobile regularly** - iOS app shows all active sessions for quick check-ins

## Integration with Other Features

### With `/commit-push-pr`
```bash
claude> Implement feature X, run tests, and create PR &

# Session uploads to web
# Continue in browser to review PR
# Merge directly from web when ready
```

### With MCP Servers
```bash
claude> Search Slack for recent bug reports and fix them &

# Uploads with MCP context
# Web session maintains Slack/GitHub access
# Continue investigation in browser
```

### With Hooks
```bash
# PostToolUse hook runs before upload
# Session uploads with formatted code
# Continue in browser with clean codebase
```

## Comparison: When to Use Each Command

| Scenario | Command | Why |
|----------|---------|-----|
| Quick terminal task | (no suffix) | Stays in terminal |
| Long task, want to check later | `&` | Uploads to web |
| Web session, want terminal | `--teleport` | Pulls to terminal |
| Continue any previous session | `--resume` | Shows session picker |
| Start fresh on web | (Open claude.ai/code) | Web-only session |

## Summary

The `&` command is your **session handoff tool**:

```
Terminal Session → & → claude.ai/code → Web Session → --teleport → Terminal Session
```

**Key Takeaways:**
1. **`&` suffix** uploads your terminal session to web
2. **`--teleport`** brings web sessions back to terminal
3. **Perfect for parallel workflows** - run 5-15+ Claude instances simultaneously
4. **Cross-device continuation** - start terminal, continue mobile/web
5. **No context loss** - full conversation + codebase access maintained

**Start experimenting:**
```bash
$ claude
claude> Try implementing a small feature &
```

Then check [claude.ai/code](https://claude.ai/code) to see your session! 🚀

---

## Additional Resources

- **Main Tutorial:** [tutorial.md](../tutorial.md) - Boris's full workflow
- **Setup Guide:** [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Initial configuration
- **Workflow Reference:** [WORKFLOW.md](./WORKFLOW.md) - Development patterns
- **Official Docs:** [code.claude.com/docs](https://code.claude.com/docs) - Complete documentation

## Quick Reference Card

```bash
# Upload to web
claude> Your task here &

# Pull from web
claude --teleport

# Resume any session
claude --resume

# Continue specific session
claude -c

# Check all sessions
Visit: claude.ai/code
```
