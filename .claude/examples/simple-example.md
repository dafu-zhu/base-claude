# Task: Add Input Validation to API Endpoints

> **Template Version**: 1.0
> **Created**: 2026-01-15
> **Author**: Example Developer

---

## Goal

Add comprehensive input validation to all user-facing API endpoints to prevent malformed data and improve error messages.

---

## Context

### Current State
- Express API with 5 user endpoints (/users CRUD + /users/:id/avatar)
- No input validation currently exists
- Server crashes on malformed JSON
- Unclear error messages returned to clients

### Problem
- Server vulnerable to malformed input
- Poor user experience with cryptic error messages
- No validation for required fields, data types, or formats

### Constraints
- Must maintain backward compatibility (don't break existing clients)
- Cannot add new dependencies (use built-in validation)
- Must complete in 1 day

---

## Success Criteria (Global)

- [ ] All tests pass
- [ ] Linting clean
- [ ] Test coverage >= 80%
- [ ] All phases complete
- [ ] PR created

---

## Safety Bounds

**Maximum iterations per task**: 30
**Maximum cost**: $5
**Maximum time**: 1 hour

---

## Phases & Tasks

### Phase 1: Add Validation Middleware

**Goal**: Create reusable validation middleware and apply to endpoints

#### Task 1.1: Create validation middleware

**Description**: Create validation functions for common patterns (email, required fields, string length)

**Success Criteria**:
- [ ] Validation middleware created in src/middleware/validate.ts
- [ ] Functions: validateRequired, validateEmail, validateStringLength, validateEnum
- [ ] Returns 400 with clear error message on validation failure
- [ ] Middleware tests pass (10+ tests)

**Agents Needed**: None

**Complexity**: Simple

**Dependencies**: None

**Estimated Effort**: Quick (<30m)

---

#### Task 1.2: Apply validation to all endpoints

**Description**: Add validation middleware to all 5 user endpoints

**Success Criteria**:
- [ ] POST /users validates: email (required, valid format), name (required, 1-100 chars)
- [ ] PUT /users/:id validates: email (valid format if provided), name (1-100 chars if provided)
- [ ] DELETE /users/:id validates: id (required, UUID format)
- [ ] GET /users/:id validates: id (required, UUID format)
- [ ] POST /users/:id/avatar validates: id (UUID), file (image type, max 5MB)
- [ ] All validation tests pass (20+ tests)
- [ ] Error responses include field name and reason

**Agents Needed**:
- `test-runner` (ensure comprehensive test coverage)

**Complexity**: Simple

**Dependencies**: Task 1.1

**Estimated Effort**: Quick (<30m)

---

## Supervisor Checks

**Enable Supervisor**: Yes

**Check Frequency**:
- [x] Pre-task
- [x] Post-task

**Check For**:
- [x] Pattern inconsistencies (auto-fix enabled)

**Auto-Fix Minor Issues**: Yes

---

## Outer Ralph Loop

**Enable Outer Ralph**: Yes

**Success Criteria**:
- [ ] No code smells
- [ ] Documentation complete (validation functions documented)
- [ ] Consistent patterns across all endpoints

**Focus Areas**:
- Code quality
- Documentation

**Maximum Iterations**: 5

---

## Delegation Strategy

### Proactive Delegations

None (simple task, no delegation needed)

### Reactive Delegations

- [x] After 2+ failed iterations → Architect

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

### Manual Checks

- [ ] POST /users with invalid email returns 400 with clear message
- [ ] POST /users with missing name returns 400
- [ ] POST /users with valid data returns 201
- [ ] PUT /users/:id with invalid UUID returns 400
- [ ] All error messages include field name and validation reason

---

## Rollback Plan

**If task fails**:
1. Revert all commits from this workflow
2. Preserve learnings.jsonl

---

## Learning Objectives

**Patterns to discover**:
- [ ] Express middleware validation patterns
- [ ] Error response formatting

**Antipatterns to avoid**:
- [ ] Silent validation failures
- [ ] Cryptic error messages
