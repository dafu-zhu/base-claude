# Ralph Self-Improvement Skill

Launch Ralph to autonomously improve code quality.

## Purpose

Continuously scan, fix, verify issues until codebase meets quality standards.

## Usage

```
/ralph
```

Or with custom config:
```
/ralph --max-iterations 30 --max-cost 5
```

## Process

1. Check current branch. Create feature/ralph-improvements if on main.

2. Initialize state:
```bash
cat > .claude/agent-state.json <<EOF
{
  "ralph": {
    "status": "scanning",
    "start_time": "$(date -Iseconds)",
    "issues_found": 0,
    "issues_fixed": 0,
    "iteration": 0
  }
}
EOF
```

3. Launch ralph-improver agent:
```python
Task(
    subagent_type="ralph-improver",
    prompt="Autonomously improve code quality. Scan, prioritize, fix, verify, review until all issues resolved or limits reached."
)
```

4. Monitor progress via agent-state.json

5. On completion:
```
[14:30] Ralph complete
[14:30] Fixed: 12/12 issues
[14:30] Time: 2h 30m
[14:30] Cost: $7.45
[14:30] PR: #123
```

## Default Config

From preferences.md:
- max_iterations: 50
- max_cost: $10
- max_time: 2h
- compact_after_issue: true
- milestone_every: 5 issues

## Communication

Report only: issues fixed, time, cost, PR link.
