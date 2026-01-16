# Unified Task: Multi-Tenant SaaS Platform with Real-Time Analytics

> **Template Version**: 1.0
> **Created**: 2026-01-15
> **Author**: Example Team

---

## Goal

Build a complete multi-tenant SaaS platform with tenant isolation, real-time analytics dashboard, subscription management, and webhook system for third-party integrations.

---

## Context

### Current State
- Existing Node.js/Express API with PostgreSQL database
- Single-tenant architecture (all users share one namespace)
- No billing or subscription system
- No analytics or dashboard
- No webhook/integration capabilities

### Problem
- Need to support multiple organizations (tenants) with data isolation
- Need to monetize with tiered subscriptions (Free, Pro, Enterprise)
- Customers request usage analytics and real-time dashboards
- Third-party apps need webhook notifications for events

### Constraints
- Must maintain backward compatibility for existing single-tenant users
- Database must support 10,000+ tenants efficiently
- Analytics must handle 1M+ events per day
- Webhook delivery must be reliable (retry on failure)
- Must comply with SOC 2 requirements (data isolation, audit logging)
- Implementation deadline: 4 weeks
- Budget: $1,000 for external services (Stripe, message queue)

---

## Success Criteria (Global)

- [ ] All tests pass
- [ ] Linting clean
- [ ] Test coverage >= 85%
- [ ] Security scan clean (0 critical/high vulnerabilities)
- [ ] Performance benchmarks met (API p95 < 200ms, analytics query < 1s)
- [ ] Documentation complete (README, API docs, CHANGELOG, architecture diagram)
- [ ] SOC 2 compliance verified (data isolation, audit logs)
- [ ] All phases complete
- [ ] PR created and approved

---

## Safety Bounds

**Maximum iterations per task**: 30
**Maximum cost**: $20 (for AI consultations)
**Maximum time**: 3 hours per session

---

## Phases & Tasks

### Phase 1: Multi-Tenant Foundation

**Goal**: Implement tenant isolation at database and application levels

#### Task 1.1: Database schema for multi-tenancy

**Description**: Add tenant_id to all tables, create tenants table, set up row-level security

**Success Criteria**:
- [ ] tenants table created (id, name, subdomain, created_at)
- [ ] All existing tables have tenant_id foreign key
- [ ] Row-level security policies enforce tenant isolation
- [ ] Migrations tested on test database
- [ ] Cannot query data from different tenant (tested)

**Agents Needed**:
- `architect` (GPT - design multi-tenant schema)

**Complexity**: High

**Dependencies**: None

**Estimated Effort**: Medium (1-2h)

---

#### Task 1.2: Tenant context middleware

**Description**: Create middleware to identify tenant from subdomain/header and set context

**Success Criteria**:
- [ ] Middleware extracts tenant from subdomain (e.g., acme.example.com → tenant: acme)
- [ ] Falls back to X-Tenant-Id header if subdomain not available
- [ ] Sets req.tenant for all downstream handlers
- [ ] Returns 404 if tenant not found
- [ ] All tenant middleware tests pass (15+ tests)

**Agents Needed**: None

**Complexity**: Medium

**Dependencies**: Task 1.1

**Estimated Effort**: Short (30m-1h)

---

#### Task 1.3: Audit logging system

**Description**: Implement audit logs for all tenant data changes (SOC 2 requirement)

**Success Criteria**:
- [ ] audit_logs table created (id, tenant_id, user_id, action, resource, timestamp, changes)
- [ ] Middleware logs all CREATE, UPDATE, DELETE operations
- [ ] Logs include before/after state for updates
- [ ] Logs are tenant-isolated (cannot read other tenant logs)
- [ ] Audit log tests pass (10+ tests)

**Agents Needed**:
- `security-analyst` (GPT - verify audit logging meets SOC 2)

**Complexity**: Medium

**Dependencies**: Task 1.2

**Estimated Effort**: Medium (1-2h)

---

### Phase 2: Subscription & Billing

**Goal**: Integrate Stripe for subscription management and tiered plans

#### Task 2.1: Stripe integration

**Description**: Integrate Stripe for subscription management (Free, Pro, Enterprise plans)

**Success Criteria**:
- [ ] Stripe SDK integrated
- [ ] Webhook endpoint /webhooks/stripe handles subscription events
- [ ] subscriptions table tracks tenant plan (tenant_id, stripe_subscription_id, plan, status)
- [ ] Plans enforce limits (Free: 100 users, Pro: 1000 users, Enterprise: unlimited)
- [ ] Stripe webhook signature verification working
- [ ] All Stripe integration tests pass (20+ tests)

**Agents Needed**:
- `security-auditor` (verify webhook signature validation)
- `code-reviewer` (GPT - review Stripe integration)

**Complexity**: High

**Dependencies**: Task 1.1

**Estimated Effort**: Large (2h+)

---

#### Task 2.2: Plan enforcement middleware

**Description**: Create middleware to enforce plan limits and features

**Success Criteria**:
- [ ] Middleware checks tenant plan before allowing operations
- [ ] Free plan: max 100 users, no API access, no webhooks
- [ ] Pro plan: max 1000 users, API access, webhooks
- [ ] Enterprise plan: unlimited users, API access, webhooks, custom integrations
- [ ] Returns 402 Payment Required if limit exceeded
- [ ] All plan enforcement tests pass (15+ tests)

**Agents Needed**: None

**Complexity**: Medium

**Dependencies**: Task 2.1

**Estimated Effort**: Short (30m-1h)

---

### Phase 3: Real-Time Analytics

**Goal**: Build analytics pipeline and dashboard API

#### Task 3.1: Analytics event collection

**Description**: Create event collection system for user actions (page views, API calls, feature usage)

**Success Criteria**:
- [ ] events table created (id, tenant_id, event_type, user_id, metadata, timestamp)
- [ ] Event collection API: POST /analytics/events
- [ ] Events batched and written async (not blocking)
- [ ] Events partitioned by tenant_id and date for query performance
- [ ] Event collection tests pass (10+ tests)

**Agents Needed**:
- `architect` (GPT - design analytics schema for scale)

**Complexity**: High

**Dependencies**: Task 1.1

**Estimated Effort**: Medium (1-2h)

---

#### Task 3.2: Analytics query API

**Description**: Create API for querying aggregated analytics (daily active users, feature usage, API calls)

**Success Criteria**:
- [ ] GET /analytics/summary returns: DAU, MAU, API calls, top features
- [ ] GET /analytics/timeseries returns time-series data for charts
- [ ] Queries use materialized views for performance (refresh daily)
- [ ] Queries complete in < 1 second (tested with 1M events)
- [ ] All analytics API tests pass (15+ tests)

**Agents Needed**:
- `architect` (GPT - optimize query performance)

**Complexity**: High

**Dependencies**: Task 3.1

**Estimated Effort**: Large (2h+)

---

#### Task 3.3: Real-time dashboard WebSocket

**Description**: Implement WebSocket endpoint for real-time analytics updates

**Success Criteria**:
- [ ] WebSocket endpoint /ws/analytics streams real-time events
- [ ] Clients receive events only for their tenant (isolation)
- [ ] Events throttled to 1 update per second to avoid overwhelming clients
- [ ] WebSocket authentication using JWT
- [ ] WebSocket tests pass (10+ tests)

**Agents Needed**:
- `security-auditor` (verify WebSocket security)

**Complexity**: High

**Dependencies**: Task 3.2

**Estimated Effort**: Medium (1-2h)

---

### Phase 4: Webhook System

**Goal**: Build reliable webhook delivery system for third-party integrations

#### Task 4.1: Webhook registration API

**Description**: Create API for tenants to register webhook endpoints

**Success Criteria**:
- [ ] webhooks table (id, tenant_id, url, events[], secret, status)
- [ ] POST /webhooks creates webhook (validates URL, generates secret)
- [ ] GET /webhooks lists tenant webhooks
- [ ] DELETE /webhooks/:id deletes webhook
- [ ] Webhook CRUD tests pass (10+ tests)

**Agents Needed**: None

**Complexity**: Simple

**Dependencies**: Task 1.1

**Estimated Effort**: Quick (<30m)

---

#### Task 4.2: Webhook delivery system

**Description**: Implement reliable webhook delivery with retries and dead-letter queue

**Success Criteria**:
- [ ] Webhook events queued (using Redis or message queue)
- [ ] Worker process delivers webhooks asynchronously
- [ ] Retries on failure (exponential backoff: 1s, 5s, 30s, 5m, 1h)
- [ ] Signature included in header (HMAC-SHA256 with secret)
- [ ] Delivery logs stored (webhook_deliveries table)
- [ ] Dead-letter queue for failed deliveries after 5 retries
- [ ] Webhook delivery tests pass (20+ tests)

**Agents Needed**:
- `architect` (GPT - design reliable delivery system)
- `code-reviewer` (GPT - review retry logic)

**Complexity**: High

**Dependencies**: Task 4.1

**Estimated Effort**: Large (2h+)

---

#### Task 4.3: Webhook security hardening

**Description**: Harden webhook system against abuse and vulnerabilities

**Success Criteria**:
- [ ] Rate limiting: max 100 webhook calls per minute per tenant
- [ ] Webhook URL validation (no localhost, internal IPs, or cloud metadata endpoints)
- [ ] Timeout: webhook requests timeout after 10 seconds
- [ ] Payload size limit: max 1MB
- [ ] Security scan clean (no SSRF vulnerabilities)
- [ ] All security tests pass (15+ tests)

**Agents Needed**:
- `security-analyst` (GPT - comprehensive security audit)

**Complexity**: High

**Dependencies**: Task 4.2

**Estimated Effort**: Medium (1-2h)

---

### Phase 5: Performance & Scale Testing

**Goal**: Verify system meets performance requirements at scale

#### Task 5.1: Load testing

**Description**: Run load tests to verify performance benchmarks

**Success Criteria**:
- [ ] API endpoints p95 latency < 200ms under 1000 req/s load
- [ ] Analytics queries < 1s with 1M events
- [ ] Webhook delivery handles 10,000 events/min
- [ ] Database connection pool tuned for load
- [ ] Load test report generated

**Agents Needed**: None

**Complexity**: Medium

**Dependencies**: All previous tasks

**Estimated Effort**: Medium (1-2h)

---

#### Task 5.2: Optimization based on load test results

**Description**: Fix performance bottlenecks identified in load testing

**Success Criteria**:
- [ ] All performance benchmarks met
- [ ] Database indexes added for slow queries
- [ ] Caching implemented where beneficial (Redis)
- [ ] Connection pooling optimized
- [ ] Optimization tests pass

**Agents Needed**:
- `architect` (GPT - recommend optimizations)

**Complexity**: High

**Dependencies**: Task 5.1

**Estimated Effort**: Medium (1-2h)

---

## Supervisor Checks

**Enable Supervisor**: Yes

**Check Frequency**:
- [x] Pre-task
- [x] Post-task
- [x] On-demand

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
- [ ] Documentation complete (all modules documented)
- [ ] Consistent patterns (error handling, logging, auth)
- [ ] Security best practices (no vulnerabilities, SOC 2 compliant)
- [ ] Test coverage >= 85%
- [ ] Performance benchmarks met

**Focus Areas**:
- Code quality
- Test coverage
- Security
- Performance
- Documentation
- SOC 2 compliance

**Maximum Iterations**: 15

---

## Delegation Strategy

### Proactive Delegations

**Architect**:
- [x] Consult before Phase 1 (multi-tenant architecture design)
- [x] Consult before Phase 3 (analytics schema design)
- [x] Review after Phase 4 (webhook system architecture)

**Security Analyst**:
- [x] Review after Phase 1 (tenant isolation security)
- [x] Review after Phase 2 (Stripe integration security)
- [x] Review after Phase 4 (webhook security audit)
- [x] Final audit after all phases

**Code Reviewer**:
- [x] Review after each phase
- [x] Final review before PR

**Plan Reviewer**:
- [x] Review work plan before execution (validate plan completeness)

### Reactive Delegations

- [x] After 2+ failed iterations → Architect
- [x] Security issue detected → Security Analyst
- [x] Complex design decision → Architect
- [x] Performance bottleneck → Architect

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
# Must show >= 85%
```

**Security**:
```bash
npm audit --audit-level=moderate
# Must show 0 vulnerabilities
```

**Performance**:
```bash
npm run load-test
# Must meet benchmarks (p95 < 200ms)
```

### Manual Checks

- [ ] Can create tenant and isolated data
- [ ] Cannot access other tenant data
- [ ] Stripe subscription flow works end-to-end
- [ ] Plan limits enforced correctly
- [ ] Analytics dashboard shows real-time data
- [ ] Webhooks deliver successfully with retries
- [ ] Load test meets all benchmarks
- [ ] SOC 2 audit logs complete
- [ ] README has setup and deployment instructions

---

## Rollback Plan

**If task fails**:
1. Revert all commits from this workflow
2. Drop new tables (tenants, subscriptions, events, webhooks, webhook_deliveries, audit_logs)
3. Restore database to pre-migration state
4. Cancel Stripe subscription (if created)
5. Preserve learnings.jsonl, load test results, and failure report

---

## Learning Objectives

**Patterns to discover**:
- [ ] Multi-tenant database architecture with row-level security
- [ ] Reliable webhook delivery with retries and dead-letter queue
- [ ] Real-time analytics at scale (event collection, aggregation, streaming)
- [ ] Stripe subscription management and webhook handling
- [ ] SOC 2 compliance patterns (audit logging, data isolation)

**Antipatterns to avoid**:
- [ ] Shared database without tenant isolation
- [ ] Synchronous webhook delivery (blocking)
- [ ] Missing webhook signature validation
- [ ] Analytics queries without indexes (slow at scale)
- [ ] Hardcoded plan limits (should be configurable)
- [ ] Missing audit logs for compliance

---

## Performance Benchmarks

| Metric | Target | Measurement |
|--------|--------|-------------|
| API p95 latency | < 200ms | Load test at 1000 req/s |
| Analytics query time | < 1s | Query with 1M events |
| Webhook delivery rate | 10,000/min | Sustained load test |
| Database connections | < 100 | Connection pool monitor |
| Memory usage | < 2GB | Production monitoring |

---

## Security Requirements (SOC 2)

- [ ] Tenant data isolation (row-level security)
- [ ] Audit logs for all data changes
- [ ] Webhook URL validation (no SSRF)
- [ ] Authentication on all endpoints
- [ ] Encryption in transit (HTTPS)
- [ ] Encryption at rest (database)
- [ ] Rate limiting on public endpoints
- [ ] No hardcoded secrets (environment variables)

---

## Notes

**Architecture Decisions**:
- Using PostgreSQL row-level security for tenant isolation (discussed 2026-01-10)
- Redis for webhook queue (decided over AWS SQS for cost)
- Materialized views for analytics (refresh nightly)

**Helpful Resources**:
- Multi-tenancy patterns: https://docs.microsoft.com/en-us/azure/architecture/patterns/multi-tenancy
- Stripe webhooks: https://stripe.com/docs/webhooks
- SOC 2 compliance: https://www.aicpa.org/soc2

**Team Contacts**:
- Stripe integration questions: @billing-team
- Performance optimization: @infrastructure-team
- Security audit: @security-team
