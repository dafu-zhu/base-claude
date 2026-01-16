# Task: [Task Name]

> **Template Version**: 1.0
> **Created**: [Date]
> **Author**: [Your Name]

---

## Goal

[One sentence describing the specific, measurable outcome of this task]

**Example**: Implement a user authentication system with JWT tokens, role-based permissions, and secure session management.

---

## Context

### Current State
[Describe what exists now - architecture, codebase state, current functionality]

**Example**:
- Application is a Node.js/Express API with PostgreSQL database
- No authentication currently exists
- User model exists but has no password or role fields
- Frontend makes unauthenticated API calls

### Problem
[What problem are you solving or what need are you addressing?]

**Example**:
- Users can access any endpoint without authentication
- No way to restrict admin functionality
- Security vulnerability: sensitive data exposed

### Constraints
[Technical, business, or time constraints that limit the solution]

**Example**:
- Must work with existing PostgreSQL database
- Cannot change existing User model primary key
- Must maintain API backward compatibility for public endpoints
- Maximum 2 weeks implementation time

---

## Success Criteria (Global)

[High-level criteria that apply to the entire task - these must ALL be met]

- [ ] All tests pass
- [ ] Linting clean (no warnings or errors)
- [ ] Test coverage >= 80%
- [ ] Security scan clean (no critical or high vulnerabilities)
- [ ] Documentation updated (README, API docs, CHANGELOG)
- [ ] All phases complete
- [ ] PR created and approved

---

## Safety Bounds

**Maximum iterations per task**: 30
**Maximum cost**: $10
**Maximum time**: 2 hours

> These bounds prevent runaway execution. Orchestrator will pause and ask for approval if any limit is approached.

---

## Phases & Tasks

### Phase 1: [Phase Name]

**Goal**: [What this phase achieves]

#### Task 1.1: [Task Name]

**Description**: [What needs to be done]

**Success Criteria**:
- [ ] [Specific, verifiable criterion 1]
- [ ] [Specific, verifiable criterion 2]
- [ ] [Specific, verifiable criterion 3]

**Agents Needed**: [List of agents, or "None" for direct implementation]
- `security-auditor` (if handling auth, sensitive data)
- `test-runner` (if high test coverage required)
- `code-reviewer` (GPT - if complex design)
- `architect` (GPT - if architectural decisions needed)

> **Agent Selection Guide**: See [AGENT-CATALOG.md](./AGENT-CATALOG.md)
>
> Common choices:
> - Code changes: `code-reviewer`, `code-improvement-scanner`
> - Build/deps: `build-engineer`, `dependency-manager`
> - Docs: `documentation-engineer`, `api-documenter`
> - Debug: `debugger`
> - Architecture: `architect-reviewer`
> - Domain: `ai-engineer`, `fintech-engineer`, `cli-developer`

**Complexity**: Simple | Medium | High

**Dependencies**: [Other tasks this depends on, or "None"]

**Estimated Effort**: Quick (<30m) | Short (30m-1h) | Medium (1-2h) | Large (2h+)

---

#### Task 1.2: [Task Name]

**Description**: [What needs to be done]

**Success Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**Agents Needed**: [List or "None"]

**Complexity**: Simple | Medium | High

**Dependencies**: Task 1.1

**Estimated Effort**: Quick | Short | Medium | Large

---

### Phase 2: [Phase Name]

**Goal**: [What this phase achieves]

#### Task 2.1: [Task Name]

[Follow same format as above]

---

## Supervisor Checks

**Enable Supervisor**: Yes | No

**Check Frequency**:
- [x] Pre-task (before each task starts)
- [x] Post-task (after each task completes)
- [ ] On-demand (during task execution if structural changes detected)

**Check For**:
- [x] Architecture violations
- [x] Cross-task dependency conflicts
- [x] API contract changes
- [ ] Pattern inconsistencies (auto-fix enabled)
- [x] Security concerns

**Auto-Fix Minor Issues**: Yes | No
> If Yes, supervisor will autonomously fix style/pattern issues without interrupting workflow

---

## Outer Ralph Loop

**Enable Outer Ralph**: Yes | No

**Success Criteria** (applied to entire implementation):
- [ ] No code smells (cyclomatic complexity < 10, no duplication > 5 lines)
- [ ] Documentation complete (all public functions have docstrings)
- [ ] Consistent patterns across all changes (error handling, logging, imports)
- [ ] Security best practices followed (no SQL injection, XSS, hardcoded secrets)
- [ ] Test coverage >= 80% overall

**Focus Areas**:
- Code quality
- Test coverage
- Security
- Maintainability
- Documentation

**Maximum Iterations**: 10

---

## Delegation Strategy

### Proactive Delegations
[Which GPT experts should be consulted automatically during this task?]

**Architect**:
- [ ] Consult for initial architecture design
- [ ] Review architecture before Phase 2

**Security Analyst**:
- [x] Review all auth/authz implementation
- [x] Final security audit after all phases

**Code Reviewer**:
- [ ] Review after each phase
- [x] Final review before PR

**Plan Reviewer**:
- [ ] Review work plan before execution

**Scope Analyst**:
- [ ] Analyze scope for ambiguities before planning

### Reactive Delegations
[When should the orchestrator delegate based on signals?]

- [x] After 2+ failed task iterations → Architect
- [x] Security issue detected → Security Analyst
- [x] Complex design decision needed → Architect
- [x] Code quality concerns → Code Reviewer

---

## Verification Requirements

### Automated Checks
[What automated checks must pass?]

**Tests**:
```bash
npm test
# Must exit with code 0
```

**Linting**:
```bash
npm run lint
# Must exit with code 0
```

**Coverage**:
```bash
npm run test:coverage
# Must show >= 80% coverage
```

**Security**:
```bash
npm audit --audit-level=moderate
# Must show 0 vulnerabilities (moderate and above)
```

### Manual Checks
[What should be manually verified?]

- [ ] All API endpoints respond correctly
- [ ] Frontend integrates successfully
- [ ] Database migrations run without errors
- [ ] Environment variables documented
- [ ] README updated with setup instructions

---

## Rollback Plan

**If task fails after max iterations**:
1. [What should be reverted?]
2. [How to restore previous state?]
3. [What should be preserved (learnings, partial work)?]

**Example**:
1. Revert all commits from this workflow
2. Restore database to pre-migration state
3. Preserve learnings.jsonl and failure report for analysis

---

## Learning Objectives

**Patterns to discover**:
- [ ] Optimal authentication flow for this codebase
- [ ] Best practices for role-based access control
- [ ] Secure session management patterns

**Antipatterns to avoid**:
- [ ] Plaintext password storage
- [ ] Client-side auth logic
- [ ] Hardcoded secrets

---

## Example: Filled Template

Below is an example of a filled template for a user authentication task:

---

# Unified Task: User Authentication System

> **Template Version**: 1.0
> **Created**: 2026-01-15
> **Author**: Development Team

---

## Goal

Implement secure user authentication with JWT tokens, role-based permissions, and session management for the Express API.

---

## Context

### Current State
- Node.js/Express API with PostgreSQL database
- No authentication exists
- User model has id, email, name fields (no password or role)
- All API endpoints are public

### Problem
- Security vulnerability: sensitive data exposed without auth
- Cannot restrict admin functionality
- No user session tracking

### Constraints
- Must use existing PostgreSQL database
- Cannot change User.id primary key
- Must maintain backward compatibility for 3 public endpoints (/health, /status, /docs)
- Implementation deadline: 2 weeks

---

## Success Criteria (Global)

- [ ] All tests pass
- [ ] Linting clean
- [ ] Test coverage >= 80%
- [ ] Security scan clean (0 critical/high vulnerabilities)
- [ ] Documentation updated
- [ ] All phases complete
- [ ] PR created and approved

---

## Safety Bounds

**Maximum iterations per task**: 30
**Maximum cost**: $10
**Maximum time**: 2 hours

---

## Phases & Tasks

### Phase 1: Foundation

**Goal**: Set up authentication infrastructure

#### Task 1.1: Update User model and database schema

**Description**: Add password_hash and role fields to User model, create migration

**Success Criteria**:
- [ ] User model has password_hash (string, not null) and role (enum: user, admin)
- [ ] Database migration created and tested
- [ ] Migration runs successfully on test database
- [ ] Model tests updated and passing

**Agents Needed**: None

**Complexity**: Simple

**Dependencies**: None

**Estimated Effort**: Quick (<30m)

---

#### Task 1.2: Implement JWT authentication

**Description**: Create JWT generation and validation logic

**Success Criteria**:
- [ ] JWT tokens generated on login (payload: userId, role, exp)
- [ ] Tokens expire after 1 hour
- [ ] Token validation middleware created
- [ ] Refresh token flow implemented
- [ ] All JWT tests passing (15+ tests)

**Agents Needed**:
- `security-auditor` (verify JWT implementation secure)
- `test-runner` (ensure high test coverage)

**Complexity**: Medium

**Dependencies**: Task 1.1

**Estimated Effort**: Short (30m-1h)

---

### Phase 2: Core Features

**Goal**: Implement authentication endpoints and middleware

#### Task 2.1: Create auth endpoints

**Description**: Implement /auth/register, /auth/login, /auth/refresh, /auth/logout

**Success Criteria**:
- [ ] POST /auth/register creates user with hashed password
- [ ] POST /auth/login returns JWT on valid credentials
- [ ] POST /auth/refresh returns new JWT with valid refresh token
- [ ] POST /auth/logout invalidates refresh token
- [ ] All endpoints have validation (email format, password strength)
- [ ] 90%+ coverage for auth routes

**Agents Needed**:
- `security-auditor` (check for vulnerabilities)
- `code-reviewer` (GPT - review endpoint logic)

**Complexity**: High

**Dependencies**: Task 1.2

**Estimated Effort**: Medium (1-2h)

---

#### Task 2.2: Add role-based access control

**Description**: Implement middleware for role-based authorization

**Success Criteria**:
- [ ] requireAuth middleware validates JWT
- [ ] requireRole(role) middleware checks user role
- [ ] Admin-only endpoints protected (e.g., DELETE /users/:id)
- [ ] Unauthorized requests return 401/403
- [ ] All authz tests passing

**Agents Needed**:
- `security-auditor` (verify authz logic secure)
- `test-runner` (test edge cases)

**Complexity**: Medium

**Dependencies**: Task 2.1

**Estimated Effort**: Short (30m-1h)

---

### Phase 3: Integration & Security

**Goal**: Integrate auth with existing endpoints and harden security

#### Task 3.1: Protect existing endpoints

**Description**: Add auth middleware to all non-public endpoints

**Success Criteria**:
- [ ] All endpoints except /health, /status, /docs require auth
- [ ] Admin endpoints require admin role
- [ ] Existing endpoint tests updated with auth headers
- [ ] All integration tests passing

**Agents Needed**: None

**Complexity**: Simple

**Dependencies**: Task 2.2

**Estimated Effort**: Quick (<30m)

---

#### Task 3.2: Security hardening

**Description**: Final security audit and hardening

**Success Criteria**:
- [ ] Passwords hashed with bcrypt (cost factor 10)
- [ ] No hardcoded secrets (JWT_SECRET from env)
- [ ] Rate limiting on auth endpoints (5 req/min)
- [ ] CORS configured correctly
- [ ] Security headers added (helmet.js)
- [ ] npm audit clean

**Agents Needed**:
- `security-auditor` (comprehensive scan)
- `security-analyst` (GPT - final audit)

**Complexity**: High

**Dependencies**: Task 3.1

**Estimated Effort**: Short (30m-1h)

---

## Supervisor Checks

**Enable Supervisor**: Yes

**Check Frequency**:
- [x] Pre-task
- [x] Post-task
- [ ] On-demand

**Check For**:
- [x] Architecture violations
- [x] Cross-task dependency conflicts
- [x] API contract changes
- [x] Pattern inconsistencies (auto-fix enabled)
- [x] Security concerns

**Auto-Fix Minor Issues**: Yes

---

## Outer Ralph Loop

**Enable Outer Ralph**: Yes

**Success Criteria**:
- [ ] No code smells (complexity < 10, no duplication)
- [ ] Documentation complete (all auth functions documented)
- [ ] Consistent patterns (error handling, logging)
- [ ] Security best practices (no vulnerabilities)
- [ ] Test coverage >= 80%

**Focus Areas**:
- Code quality
- Test coverage
- Security
- Documentation

**Maximum Iterations**: 10

---

## Delegation Strategy

### Proactive Delegations

**Architect**:
- [x] Consult before Phase 1 (architecture design for auth system)

**Security Analyst**:
- [x] Review after Phase 2 (audit auth implementation)
- [x] Review after Phase 3 (final security audit)

**Code Reviewer**:
- [x] Review after Phase 3 (final code review)

### Reactive Delegations

- [x] After 2+ failed iterations → Architect
- [x] Security issue detected → Security Analyst
- [x] Complex design decision → Architect

---

## Verification Requirements

### Automated Checks

**Tests**:
```bash
npm test
```

**Linting**:
```bash
npm run lint
```

**Coverage**:
```bash
npm run test:coverage
```

**Security**:
```bash
npm audit --audit-level=moderate
```

### Manual Checks

- [ ] Can register new user via POST /auth/register
- [ ] Can login with valid credentials
- [ ] Cannot login with invalid credentials
- [ ] Admin can access admin endpoints
- [ ] Non-admin cannot access admin endpoints
- [ ] JWT expires after 1 hour
- [ ] Refresh token flow works
- [ ] README has auth setup instructions

---

## Rollback Plan

**If task fails**:
1. Revert all commits from this workflow (`git revert`)
2. Drop auth-related database migrations
3. Preserve learnings.jsonl and failure report
4. Notify team of failure reason

---

## Learning Objectives

**Patterns to discover**:
- [ ] JWT token management in Express
- [ ] bcrypt best practices for password hashing
- [ ] Role-based access control patterns

**Antipatterns to avoid**:
- [ ] Plaintext password storage
- [ ] Weak JWT secrets
- [ ] Client-side role validation
- [ ] Missing rate limiting on auth endpoints

---

## Notes

[Any additional context, links, or references]

**Helpful Resources**:
- JWT best practices: https://tools.ietf.org/html/rfc7519
- OWASP Auth cheatsheet: https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
- bcrypt documentation: https://github.com/kelektiv/node.bcrypt.js

**Team Decisions**:
- Decided on 1-hour token expiry (discussed in team meeting 2026-01-10)
- Using bcrypt cost factor 10 (security team recommendation)
