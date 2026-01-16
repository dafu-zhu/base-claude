# Milestone Issue Skill

Create GitHub issue at workflow milestone.

## Purpose

Automatically create issue documenting:
- Current plan state
- Completed TODOs
- Next steps
- Metrics

## Process

1. Gather current state:
```bash
# Read agent state
state=$(cat .claude/agent-state.json)
# Read current plan
plan=$(cat .claude/current-plan.md)
# Calculate metrics
```

2. Generate issue body:
```markdown
# Milestone: [Phase Name] Complete

## Current Plan
[Relevant plan section]

## Completed TODOs
- [x] TODO 1
- [x] TODO 2
- [x] TODO 3

## Next Steps
- [ ] TODO 4
- [ ] TODO 5

## Metrics
- Time: Xm
- Cost: $X
- Files changed: X
- Tests: X/X passed

## Status
Phase X/Y complete. [Brief status]
```

3. Create issue:
```bash
gh issue create \
  --title "Milestone: [name]" \
  --body "$issue_body" \
  --label "milestone,automated"
```

4. Update agent state with issue number

5. Report:
```
[12:30] Created milestone issue #123
```

## Communication

Extreme conciseness. Report only issue number.
