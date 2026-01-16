# Automated Workflow System - Construction Summary

Complete autonomous AI system with multi-agent coordination, self-improvement loops, and GPT expert delegation.

## What Was Built

### 1. Global Preferences
**File**: `~/.claude/preferences.md`

Defines behavior across all sessions:
- ✓ Extreme conciseness in all communication
- ✓ Mandatory plan mode before implementation
- ✓ Multi-phased planning with unresolved questions
- ✓ GitHub CLI as primary tool
- ✓ Automatic branch creation (feature/, fix/, docs/)
- ✓ Milestone issues at checkpoints
- ✓ Auto-compaction after TODOs/phases
- ✓ Multi-agent coordination protocol
- ✓ Ralph loop integration
- ✓ Safety bounds enforcement
- ✓ Learning system
- ✓ Delegation rules

### 2. Agents

**Workflow Orchestrator** (`~/.claude/agents/workflow-orchestrator.md`)
- End-to-end workflow execution
- Phase management (multi-phased plans)
- Subagent coordination
- Safety enforcement (iterations, cost, time)
- GitHub integration (branches, issues, PRs)
- Context management (checkpointing, compaction)
- Expert delegation
- Learning feedback loop

**Ralph Improver** (`~/.claude/agents/ralph-improver.md`)
- Self-improving code quality loop
- Scan → Prioritize → Plan → Implement → Verify → Review → Learn
- Integrates with code-improvement-scanner
- Delegates to GPT Code Reviewer for validation
- Records learnings for future iterations
- Autonomous until all issues resolved

### 3. Skills

**`/automated-workflow`** (`~/.claude/skills/automated-workflow.md`)
- Launch full workflow from task document
- Parse task doc, initialize state
- Launch workflow-orchestrator agent
- Monitor progress, report completion

**`/ralph`** (`~/.claude/skills/ralph.md`)
- Launch Ralph self-improvement loop
- Automatic branch creation
- Autonomous quality improvement
- Report metrics on completion

**`/milestone-issue`** (`~/.claude/skills/milestone-issue.md`)
- Create GitHub milestone issue
- Include plan state, completed TODOs, metrics
- Automatic labeling

**`/compact-checkpoint`** (`~/.claude/skills/compact-checkpoint.md`)
- Save state before compaction
- Compact context
- Verify critical info preserved

### 4. Hooks

**Post-Edit/Write Hook** (`~/.claude/hooks/format-python.sh`)
- Auto-format Python files with ruff
- Runs after every Edit/Write tool use
- Silent execution (errors suppressed)

**Post-TodoWrite Hook** (`~/.claude/hooks/check-milestone.sh`)
- Check if milestone condition met
- Triggers after TODO completion
- Signals orchestrator to create issue

**Configuration** (`.claude/settings.json`)
- Hooks registered and enabled
- Commands whitelisted (gh, bash, jq)

### 5. Templates & Examples

**Task Template** (`~/.claude/templates/automated-task-template.md`)
- Goal, context, success criteria
- Safety bounds, strategy preferences
- Escalation triggers, behavioral overrides

**Example Task** (`~/.claude/examples/example-automated-task.md`)
- Real-world example: Add input validation
- Shows proper format and detail level

### 6. Documentation

**Workflow Guide** (`~/.claude/AUTOMATED-WORKFLOW-GUIDE.md`)
- Complete usage instructions
- System architecture diagram
- Component descriptions
- Example workflows
- Troubleshooting

**System Summary** (this file)
- Construction overview
- Integration points
- Usage instructions

### 7. Integration with Delegator

**Updated** (`~/.claude/rules/delegator/orchestration.md`)
- Automated workflow integration section
- Enhanced delegation context
- Auto-delegation rules
- Learning from expert feedback

---

## How It All Works Together

### Stand-by Mode (Interactive)

```
User: "Add authentication"
  ↓
Claude (Main):
  - Detects implementation request
  - Checks preferences.md: "always plan mode"
  - Enters plan mode
  ↓
Exploration:
  - Reads codebase
  - Understands current architecture
  ↓
Plan Creation:
  - Phase 1: Setup
  - Phase 2: Implementation
  - Phase 3: Testing
  - Phase 4: Documentation
  - Unresolved Questions: [list]
  ↓
User Approval
  ↓
Implementation:
  - Creates feature/add-auth branch
  - Executes plan phase by phase
  - Compacts after each phase
  - Creates milestone issues
  - Delegates to experts when needed
  ↓
Completion:
  - Final PR created
  - All milestones linked
```

### Automated Mode (Autonomous)

```
User: "/automated-workflow task.md"
  ↓
automated-workflow skill:
  - Parses task document
  - Creates feature branch if needed
  - Initializes .claude/agent-state.json
  - Launches workflow-orchestrator agent
  ↓
Workflow Orchestrator:
  - Enters plan mode (mandatory)
  - Creates multi-phased plan
  - Lists unresolved questions
  - Waits for user approval
  ↓
[User approves]
  ↓
Execution Loop:
  For each phase:
    - Execute TODOs
    - Run tests after each
    - Compact after each TODO
    - Create milestone issue after phase
    - Delegate to experts if needed
    ↓
Verification:
  - All success criteria met?
  - Tests passing?
  - Linting clean?
  - Coverage threshold?
  ↓
Finalization:
  - Create final milestone issue
  - Generate PR with summary
  - Report metrics (time, cost, iterations)
```

### Ralph Loop (Self-Improvement)

```
User: "/ralph"
  ↓
ralph skill:
  - Creates fix/ralph-improvements branch
  - Launches ralph-improver agent
  ↓
Ralph Improver:
  ↓
  [Scan] code-improvement-scanner
  ↓
  [Prioritize] High → Medium → Low
  ↓
  For each issue:
    ↓
    [Plan] If complex, enter plan mode
    ↓
    [Implement] Fix the issue
    ↓
    [Verify] Run tests
    ↓
    [Review] Delegate to GPT Code Reviewer
    ↓
    If approved:
      - Commit with concise message
      - Compact context
      - Record learning
      - Next issue
    ↓
    If rejected:
      - Learn from feedback
      - Retry with adjusted approach
      - Max 3 retries, then escalate
    ↓
  [Milestone] Every 5 issues, create GitHub issue
  ↓
  [Stop] When all issues resolved or limits hit
  ↓
  [Report] Create PR with all fixes
```

### Multi-Agent Coordination

```
Orchestrator
  ↓
  Spawns parallel task agents:
  ├─ code-improver (working on auth.py)
  ├─ test-runner (working on test_auth.py)
  └─ doc-updater (working on README.md)
  ↓
  Each agent:
  - Checks .claude/locks.json before editing
  - Adds lock: {"file": "auth.py", "agent": "code-improver"}
  - Makes changes
  - Removes lock
  - Updates .claude/agent-state.json
  ↓
  Orchestrator monitors agent-state.json
  ↓
  When complex decision needed:
  - Delegate to GPT Architect
  - Get recommendation
  - Record in learnings.jsonl
  - Apply to all agents
```

---

## Usage Instructions

### Quick Start

**Ralph (code quality improvement)**:
```bash
/ralph
```

**Custom automated task**:
```bash
cp ~/.claude/templates/automated-task-template.md my-task.md
# Edit my-task.md with your goal, criteria, bounds
/automated-workflow my-task.md
```

**Interactive with auto-planning**:
```bash
# Just describe what you want
"Add user authentication"
# System automatically enters plan mode
```

### File Locations

```
~/.claude/
├── preferences.md                    # Global behavior
├── AUTOMATED-WORKFLOW-GUIDE.md       # Usage guide
├── SYSTEM-SUMMARY.md                 # This file
├── agents/
│   ├── workflow-orchestrator.md
│   └── ralph-improver.md
├── skills/
│   ├── automated-workflow.md
│   ├── ralph.md
│   ├── milestone-issue.md
│   └── compact-checkpoint.md
├── hooks/
│   ├── format-python.sh              # Executable
│   └── check-milestone.sh            # Executable
├── templates/
│   └── automated-task-template.md
├── examples/
│   └── example-automated-task.md
└── rules/
    └── delegator/
        └── orchestration.md          # Updated with workflow integration

/project/.claude/
├── settings.json                     # Hooks configured
├── agent-state.json                  # Created during execution
└── locks.json                        # Created during execution
```

### State Files (Created Automatically)

**`.claude/agent-state.json`**:
```json
{
  "orchestrator": {
    "status": "executing",
    "phase": 2,
    "iteration": 15,
    "cost": 3.45,
    "time_elapsed": "45m"
  },
  "completed_todos": ["Fixed auth", "Added tests"],
  "pending_todos": ["Update docs", "Security review"]
}
```

**`.claude/locks.json`**:
```json
{
  "src/auth.py": {
    "agent": "code-improver",
    "timestamp": "2026-01-15T12:30:00Z"
  }
}
```

**`.claude/checkpoint.json`**:
```json
{
  "timestamp": "2026-01-15T12:35:00Z",
  "phase": 2,
  "completed_todos": ["Fixed auth", "Added tests"],
  "pending_todos": ["Update docs"],
  "metrics": {"iteration": 15, "cost": 3.45}
}
```

**`~/.claude/learnings.jsonl`**:
```json
{"action": "Fixed SQL injection", "pattern": "Parameterize queries", "success": true, "cost": 0.12}
{"action": "Refactored auth", "pattern": "Extract to module", "success": false}
```

---

## Key Features

### 1. Extreme Conciseness
Every output uses timestamp format, fragments, no filler words.

### 2. Mandatory Planning
All implementation tasks enter plan mode first. Multi-phased plans with unresolved questions.

### 3. GitHub Integration
- Auto-create branches (feature/, fix/, docs/)
- Milestone issues at checkpoints
- PR generation with metrics
- Uses `gh` CLI exclusively

### 4. Context Management
- Auto-compact after TODOs, phases
- Checkpoint before compaction
- State preserved across compactions

### 5. Multi-Agent Coordination
- Parallel execution where possible
- Resource locking prevents conflicts
- Shared state file for coordination

### 6. Expert Delegation
- Auto-delegate to GPT experts
- Architecture, security, code review
- Learning from expert feedback

### 7. Self-Improvement (Ralph)
- Learn from outcomes
- Query learnings before action
- Adapt strategy based on results

### 8. Safety Bounds
- Max iterations, cost, time
- Automatic rollback on failure
- Escalation to user when stuck

---

## Communication Examples

### Status Updates
```
[12:30] Scanning...
[12:31] Found 5 issues
[12:32] Fixing auth.py:45
[12:33] Tests passed. Committed.
```

### Commit Messages
```
feat: add auth
fix: SQL injection in auth
docs: update API guide
refactor: extract validation logic
```

### Phase Reports
```
=== Phase 2/4: Implementation ===
TODOs: 5/5 complete
Time: 45m
Cost: $3.20
Status: ✓ Complete
```

### Final Summary
```
# Workflow Complete

## Metrics
Time: 2h 30m | Cost: $7.45 | Iterations: 38/50

## Phases
- [x] Phase 1: Foundation (30m, $1.80)
- [x] Phase 2: Implementation (1h, $3.20)
- [x] Phase 3: Testing (45m, $1.80)
- [x] Phase 4: Documentation (15m, $0.65)

## PR
https://github.com/user/repo/pull/123

## Milestones
#120, #121, #122, #123
```

---

## Testing the System

### Test 1: Preferences Loaded
```
User: "Add a login button"
Expected: "Entering plan mode..."
```

### Test 2: Conciseness
```
User: "What files handle auth?"
Expected: "Searching..." (NOT "I'll search through...")
```

### Test 3: Branch Creation
```
User: "Fix bug in auth"
Expected: Creates fix/bug-in-auth branch automatically
```

### Test 4: Milestone Issues
```
Complete 5 TODOs
Expected: GitHub issue created automatically
```

### Test 5: Ralph Loop
```
User: "/ralph"
Expected: Scans, fixes issues autonomously until done
```

### Test 6: Expert Delegation
```
User: "Should I use JWT or sessions?"
Expected: "Delegating to Architect..."
```

---

## Troubleshooting

**Hooks not running**:
```bash
chmod +x ~/.claude/hooks/*.sh
ls -la ~/.claude/hooks/  # Verify executable
```

**Context too large**:
```
/compact
```

**Workflow stuck**:
```bash
cat .claude/agent-state.json  # Check status
```

**Learnings not applied**:
```bash
tail -20 ~/.claude/learnings.jsonl
```

**Expert delegation failing**:
```bash
# Check MCP server running
# Verify GITHUB_TOKEN set
```

---

## Next Steps

System is complete and ready to use.

**Try it**:
1. `/ralph` - Let Ralph improve code quality
2. Create task doc from template
3. `/automated-workflow task.md`
4. Watch autonomous execution

**Monitor**:
- `.claude/agent-state.json` - Live progress
- `~/.claude/learnings.jsonl` - Accumulated knowledge
- GitHub milestone issues - Phase completions

**Customize**:
- Edit `~/.claude/preferences.md` for different behavior
- Create custom agents in `.claude/agents/`
- Add custom skills in `.claude/skills/`

---

## System Status

✓ Global preferences configured
✓ Workflow orchestrator agent created
✓ Ralph improver agent created
✓ Skills created (automated-workflow, ralph, milestone-issue, compact-checkpoint)
✓ Hooks created and executable
✓ Templates and examples provided
✓ Documentation complete
✓ Delegator integration updated
✓ All components loaded and active

**System ready for autonomous operation.**
