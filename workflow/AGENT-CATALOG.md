# Agent Catalog

**Version**: 1.0
**Last Updated**: 2026-01-16

Central reference for all available agents in the workflow system.

---

## Quick Reference

| Category | Agents |
|----------|--------|
| **Quality** | `code-reviewer`, `code-improvement-scanner`, `debugger` |
| **Infrastructure** | `build-engineer`, `dependency-manager`, `git-workflow-manager`, `cli-developer` |
| **Architecture** | `architect-reviewer` |
| **Documentation** | `documentation-engineer`, `api-documenter` |
| **Specialized** | `ai-engineer`, `fintech-engineer`, `quant-analyst`, `risk-manager` |
| **Research** | `research-analyst` |

---

## Agents by Category

### Quality Agents

#### code-reviewer

**Specialty**: Code quality, security vulnerabilities, and best practices

**When to Use**:
- Reviewing code changes before merging
- Finding security vulnerabilities
- Identifying performance bottlenecks
- Enforcing coding standards

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Checklist**:
- Zero critical security issues
- Code coverage > 80%
- Cyclomatic complexity < 10
- No high-priority vulnerabilities
- Documentation complete

---

#### code-improvement-scanner

**Specialty**: Proactive code quality scanning and improvement suggestions

**When to Use**:
- After completing feature implementation
- During code quality audits
- When refactoring existing code
- Before creating pull requests

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Focus Areas**:
- Readability improvements
- Performance optimizations
- Best practice enforcement
- Technical debt reduction

---

#### debugger

**Specialty**: Issue diagnosis, root cause analysis, and systematic debugging

**When to Use**:
- Investigating runtime errors
- Tracing complex bugs
- Performance issue diagnosis
- Integration problem debugging

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Approach**:
- Systematic hypothesis testing
- Log analysis
- Stack trace interpretation
- Reproduction steps documentation

---

### Infrastructure Agents

#### build-engineer

**Specialty**: Build system optimization, compilation strategies, and developer productivity

**When to Use**:
- Optimizing build times
- Configuring caching strategies
- Setting up monorepo builds
- Bundle size optimization

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Targets**:
- Build time < 30 seconds
- Rebuild time < 5 seconds
- Cache hit rate > 90%
- Zero flaky builds

---

#### dependency-manager

**Specialty**: Package management, version control, and dependency security

**When to Use**:
- Adding/updating dependencies
- Resolving version conflicts
- Security vulnerability scanning
- License compliance checking

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Focus Areas**:
- Dependency auditing
- Version strategy
- Lock file management
- Transitive dependency analysis

---

#### git-workflow-manager

**Specialty**: Version control workflows, branching strategies, and repository management

**When to Use**:
- Setting up branching strategies
- Managing merge workflows
- Resolving git conflicts
- Configuring CI/CD git hooks

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Workflows**:
- GitFlow
- Trunk-based development
- Feature branching
- Release management

---

#### cli-developer

**Specialty**: Command-line interface development, argument parsing, and user experience

**When to Use**:
- Building CLI tools
- Adding commands to existing CLIs
- Improving CLI UX
- Creating interactive prompts

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Focus Areas**:
- Argument parsing
- Help text generation
- Interactive prompts
- Output formatting
- Error handling

---

### Architecture Agents

#### architect-reviewer

**Specialty**: System design validation, architectural patterns, and technical decisions

**When to Use**:
- Validating system designs
- Reviewing architectural decisions
- Evaluating technology choices
- Assessing scalability strategies

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Review Areas**:
- Design patterns appropriateness
- Scalability requirements
- Technology choices justification
- Integration patterns soundness
- Technical debt assessment

---

### Documentation Agents

#### documentation-engineer

**Specialty**: Technical documentation systems, tutorials, and developer-friendly content

**When to Use**:
- Creating documentation systems
- Writing technical guides
- Setting up doc-as-code workflows
- Maintaining API documentation

**Tools Available**: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch

**Targets**:
- API documentation 100% coverage
- Code examples tested and working
- Search functionality implemented
- Mobile responsive design

---

#### api-documenter

**Specialty**: API documentation, OpenAPI specs, and endpoint reference

**When to Use**:
- Documenting REST APIs
- Creating OpenAPI/Swagger specs
- Writing API tutorials
- Generating SDK documentation

**Tools Available**: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch

**Focus Areas**:
- OpenAPI/Swagger integration
- Request/response examples
- Authentication documentation
- Error code references

---

### Specialized Agents

#### ai-engineer

**Specialty**: AI system design, model implementation, and production deployment

**When to Use**:
- Designing AI/ML systems
- Implementing model pipelines
- Optimizing inference performance
- Deploying ML models

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Targets**:
- Model accuracy targets met
- Inference latency < 100ms
- Model size optimized
- Bias metrics tracked
- Explainability implemented

---

#### fintech-engineer

**Specialty**: Financial systems, regulatory compliance, and secure transaction processing

**When to Use**:
- Building payment systems
- Implementing banking integrations
- Ensuring regulatory compliance (PCI DSS, KYC/AML)
- Creating trading platforms

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Targets**:
- Transaction accuracy 100%
- System uptime > 99.99%
- Latency < 100ms
- PCI DSS compliance
- Comprehensive audit trail

---

#### quant-analyst

**Specialty**: Quantitative analysis, financial modeling, and algorithmic strategies

**When to Use**:
- Building financial models
- Implementing trading algorithms
- Risk calculations
- Statistical analysis

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Focus Areas**:
- Statistical modeling
- Backtesting frameworks
- Risk metrics (VaR, Sharpe ratio)
- Time series analysis

---

#### risk-manager

**Specialty**: Risk assessment, mitigation strategies, and compliance frameworks

**When to Use**:
- Risk analysis and modeling
- Compliance framework implementation
- Threat assessment
- Mitigation planning

**Tools Available**: Read, Write, Edit, Bash, Glob, Grep

**Focus Areas**:
- Risk identification
- Impact assessment
- Mitigation strategies
- Monitoring frameworks

---

### Research Agents

#### research-analyst

**Specialty**: Information gathering, synthesis, and insight generation

**When to Use**:
- Conducting technology research
- Competitive analysis
- Trend identification
- Decision support research

**Tools Available**: Read, Grep, Glob, WebFetch, WebSearch

**Targets**:
- Information accuracy verified
- Sources credible
- Analysis comprehensive
- Insights actionable

---

## Phase Mapping

Which agents to use in each workflow phase:

### Planning Phase

| Task | Recommended Agents |
|------|-------------------|
| Architecture design | `architect-reviewer` |
| Requirements research | `research-analyst` |
| Technology evaluation | `architect-reviewer`, `research-analyst` |
| Risk assessment | `risk-manager` |

### Implementation Phase

| Task | Recommended Agents |
|------|-------------------|
| Code changes | `code-reviewer`, `code-improvement-scanner` |
| Build configuration | `build-engineer` |
| Dependency updates | `dependency-manager` |
| CLI development | `cli-developer` |
| AI/ML features | `ai-engineer` |
| Financial features | `fintech-engineer`, `quant-analyst` |
| Bug fixes | `debugger` |
| Git operations | `git-workflow-manager` |

### Review Phase

| Task | Recommended Agents |
|------|-------------------|
| Code review | `code-reviewer` |
| Architecture review | `architect-reviewer` |
| Quality scan | `code-improvement-scanner` |
| Security review | `code-reviewer` |
| Documentation review | `documentation-engineer` |

### Documentation Phase

| Task | Recommended Agents |
|------|-------------------|
| Technical docs | `documentation-engineer` |
| API docs | `api-documenter` |
| Architecture docs | `architect-reviewer`, `documentation-engineer` |

---

## Spawning Agents

### Basic Syntax

```typescript
Task({
  subagent_type: "agent-name",
  prompt: "Task description with context",
  description: "Brief description"
})
```

### Example: Code Review

```typescript
Task({
  subagent_type: "code-reviewer",
  prompt: `
    Review the changes in src/auth/ for:
    - Security vulnerabilities
    - Code quality issues
    - Test coverage gaps

    Files changed:
    - src/auth/login.ts
    - src/auth/session.ts
    - tests/auth/login.test.ts
  `,
  description: "Review auth changes"
})
```

### Example: Build Optimization

```typescript
Task({
  subagent_type: "build-engineer",
  prompt: `
    Optimize the build configuration:
    - Current build time: 120s
    - Target: < 30s
    - Focus: caching, parallelization

    Config files:
    - webpack.config.js
    - package.json
  `,
  description: "Optimize build times"
})
```

---

## Parallel Patterns

### Code Quality Check (3 agents in parallel)

```typescript
// Spawn all three simultaneously
Task({
  subagent_type: "code-reviewer",
  prompt: "Review src/api/ for security issues",
  description: "Security review"
})

Task({
  subagent_type: "code-improvement-scanner",
  prompt: "Scan src/api/ for quality improvements",
  description: "Quality scan"
})

Task({
  subagent_type: "debugger",
  prompt: "Investigate the intermittent timeout in src/api/client.ts",
  description: "Debug timeout"
})
```

### Infrastructure Update (2 agents in parallel)

```typescript
Task({
  subagent_type: "build-engineer",
  prompt: "Update webpack config for tree shaking",
  description: "Build optimization"
})

Task({
  subagent_type: "dependency-manager",
  prompt: "Audit and update outdated dependencies",
  description: "Dependency update"
})
```

### Documentation Sprint (2 agents in parallel)

```typescript
Task({
  subagent_type: "documentation-engineer",
  prompt: "Create getting started guide for new developers",
  description: "Dev guide"
})

Task({
  subagent_type: "api-documenter",
  prompt: "Generate OpenAPI spec for /api/v2/ endpoints",
  description: "API docs"
})
```

---

## Agent Selection Guide

### By Task Type

| I need to... | Use this agent |
|--------------|----------------|
| Review code changes | `code-reviewer` |
| Find bugs | `debugger` |
| Improve code quality | `code-improvement-scanner` |
| Speed up builds | `build-engineer` |
| Update packages | `dependency-manager` |
| Manage git workflow | `git-workflow-manager` |
| Build CLI tools | `cli-developer` |
| Validate architecture | `architect-reviewer` |
| Write docs | `documentation-engineer` |
| Document APIs | `api-documenter` |
| Build AI features | `ai-engineer` |
| Build financial systems | `fintech-engineer` |
| Create financial models | `quant-analyst` |
| Assess risks | `risk-manager` |
| Research topics | `research-analyst` |

### By Domain

| Domain | Primary Agents |
|--------|---------------|
| Web Development | `code-reviewer`, `build-engineer`, `dependency-manager` |
| API Development | `code-reviewer`, `api-documenter`, `architect-reviewer` |
| AI/ML | `ai-engineer`, `code-reviewer` |
| Fintech | `fintech-engineer`, `quant-analyst`, `risk-manager` |
| DevOps | `build-engineer`, `git-workflow-manager`, `dependency-manager` |
| Documentation | `documentation-engineer`, `api-documenter` |

---

## Best Practices

1. **Match agent to task** - Use specialized agents for domain-specific work
2. **Parallelize when possible** - Spawn independent agents simultaneously
3. **Provide full context** - Include relevant files, constraints, and goals
4. **Verify results** - Check agent outputs before proceeding
5. **Learn from patterns** - Record successful agent combinations

---

## See Also

- [Task Template](./task-template.md) - How to specify agents in task documents
- [Task Executor](./agents/task-executor.md) - How agents are coordinated
- [Workflow Guide](./WORKFLOW-GUIDE.md) - Complete workflow documentation
