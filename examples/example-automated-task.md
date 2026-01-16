# Automated Task: Add Input Validation

## Goal
Add comprehensive input validation to all API endpoints.

## Context
- Current state: API endpoints accept unvalidated input
- Problem: Potential injection attacks, invalid data causing errors
- Constraints: Can't break existing API contracts
- Dependencies: FastAPI/Flask (detect which), pydantic for validation

## Success Criteria (Machine-Verifiable)
- [ ] All tests pass: `pytest --exitfirst`
- [ ] No lint errors: `ruff check .`
- [ ] Type checking clean: `mypy .`
- [ ] Coverage >= 80%: `pytest --cov --cov-fail-under=80`
- [ ] Security scan clean: `bandit -r src/`

## Safety Bounds
- max_iterations: 30
- max_cost: $5
- max_time: 1h
- max_files_per_iteration: 5

Protected files:
- .env
- .claude/settings.json

## Behavioral Overrides
```yaml
github:
  branch_prefix: "fix"  # This is a fix, not feature
  create_milestone_issues: true
  issue_frequency: 3  # Every 3 endpoints

delegation:
  auto_delegate:
    - condition: "security_concern"
      expert: "security_analyst"
```

## Strategy
Prefer:
- Pydantic models for validation
- Whitelist approach (allow known good, reject rest)
- Explicit validation errors (helpful messages)

Avoid:
- Blacklist approach (trying to block bad inputs)
- Silent failures (always return clear errors)
- Breaking existing valid requests

When uncertain:
- Delegate to Security Analyst for validation approach

## Escalation Triggers
- Security vulnerability found
- Tests failing after 3 attempts
- Breaking existing valid API calls
- Cost exceeds $4 (80% of budget)

## Expected Output

Deliverables:
- [ ] Validation models for each endpoint
- [ ] Input sanitization functions
- [ ] Comprehensive tests for valid/invalid inputs
- [ ] Updated API documentation
- [ ] Security scan passing

PR Format:
```
fix: add input validation to API endpoints

## Summary
Added comprehensive input validation using Pydantic models.
Prevents injection attacks and invalid data errors.

## Testing
- Tests: 45/45 passed
- Coverage: 85%
- Security scan: Clean
- Linting: Clean

## Validated Endpoints
- POST /users
- PUT /users/:id
- POST /auth/login
- POST /posts
- PUT /posts/:id

## Milestone Issues
#130, #131, #132

🤖 Automated workflow
```

## Notes
Check existing validation library first. Don't reinvent if good solution exists.
