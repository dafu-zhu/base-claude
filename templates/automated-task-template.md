# Automated Task: [Task Name]

## Goal
[Specific, measurable outcome]

## Context
- Current state: [what exists]
- Problem: [what needs fixing/building]
- Constraints: [what can't change]

## Success Criteria (Machine-Verifiable)
- [ ] Tests pass: `pytest`
- [ ] Lint clean: `ruff check .`
- [ ] Type check: `mypy .`
- [ ] Coverage >= 80%

## Safety Bounds
- max_iterations: 50
- max_cost: $10
- max_time: 2h

## Strategy
- Prefer: [patterns]
- Avoid: [patterns]
- When uncertain: [action]

## Escalation Triggers
- Security vulnerability
- 3+ test failures
- Ambiguous requirements
- 80% budget exceeded
