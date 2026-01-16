# Prepare Task Skill

**Name**: `prepare-task`
**Invocation**: `/prepare-task <raw-description>`
**Purpose**: Transform raw task descriptions into complete, workflow-ready task documents

---

## Overview

The prepare-task skill uses the task-refiner agent to interview you about your task, ask clarifying questions, and generate a complete task.md file ready for the `/workflow` command.

---

## Usage

```bash
# Basic usage
/prepare-task "Add user authentication to the app"

# With more details
/prepare-task "Build a real-time analytics dashboard showing daily active users, API calls, and top features"

# From file (if you have a rough draft)
/prepare-task --input ~/rough-task.md
```

---

## What It Does

1. **Understands your goal** - Parses raw description
2. **Asks clarifying questions** - Systematically covers:
   - Goal clarity
   - Context (current state, problem, constraints)
   - Phases and tasks
   - Success criteria
   - Agents and complexity
   - Supervisor and quality settings
   - Safety bounds and delegation
3. **Generates draft** - Creates complete task.md
4. **Iterates with you** - Refines based on your feedback
5. **Saves final document** - Ready for `/workflow`

---

## Example Session

### Simple Task

```bash
User: /prepare-task "Add input validation to API endpoints"

Agent: I'll help you create a complete task document. Let me ask a few questions:

Goal Clarity:
1. Which API endpoints need validation?
   - All endpoints, or specific ones?
2. What type of validation?
   - Required fields, data types, formats (email, phone)?

User: All user-facing endpoints (5 total). Validate required fields, email format, string lengths.

Agent: Got it.

Context:
3. What exists now?
   - No validation at all, or partial?
4. What happens with invalid input currently?
   - Server crash? Unclear error? Accepted anyway?

User: No validation exists. Server sometimes crashes on malformed JSON. Users get cryptic errors.

Agent: Clear. Let me suggest phases:

Phase 1: Create validation middleware (reusable functions)
  - Task 1.1: Create validation middleware
  - Task 1.2: Apply to all 5 endpoints

Does this structure make sense?

User: Yes

Agent: [Generates draft task.md]

Here's your task document draft:

# Task: Add Input Validation to API Endpoints

## Goal
Add comprehensive input validation to all 5 user-facing API endpoints to prevent malformed data and improve error messages.

## Context
- No validation currently exists
- Server crashes on malformed JSON
- Users receive cryptic error messages

## Success Criteria (Global)
- [ ] All tests pass
- [ ] Linting clean
- [ ] Test coverage >= 80%
- [ ] All endpoints validate input
- [ ] Clear error messages returned

... [full task.md shown] ...

Does this look good, or would you like to adjust anything?

User: Looks good!

Agent: ✓ Task document saved: ~/input-validation-task.md

Next steps:
1. Review the document
2. Run: /workflow ~/input-validation-task.md

Estimated time: ~30 minutes
Estimated cost: ~$1
```

### Complex Task

```bash
User: /prepare-task "Build a multi-tenant SaaS platform"

Agent: That's a large project. Let me ask systematically to break it down:

Goal Clarity:
1. What is the core functionality?
   - What does your SaaS do (analytics? CRM? project management)?
2. What features are must-have for MVP?
   - Multi-tenancy (yes), but what else?

User: It's a project management tool. MVP: multi-tenancy, user auth, projects/tasks CRUD, basic dashboard.

Agent: Got it.

Context:
3. What exists today?
   - Starting from scratch, or extending existing app?
4. What's your deadline and budget?
   - This affects how we scope phases

User: Starting from scratch. 4 weeks timeline, $1000 budget for tools (Stripe, hosting).

Agent: Understood.

Phases & Tasks:
5. I suggest this structure:
   Phase 1: Foundation (multi-tenant DB, auth)
   Phase 2: Core features (projects, tasks CRUD)
   Phase 3: Dashboard (analytics)
   Phase 4: Billing (Stripe integration)
   Phase 5: Testing & deployment

   Does this make sense, or different priority?

User: Yes, but billing is lower priority. Can we do: Foundation → Core → Dashboard → Testing, and save Billing for v2?

Agent: Absolutely. Updating...

[Continues asking about success criteria, security requirements, etc.]

... [10 more questions] ...

Agent: [Generates comprehensive task.md]

Here's your task document:

# Task: Multi-Tenant Project Management SaaS (MVP)

[Shows complete document with 4 phases, 12 tasks, security considerations, etc.]

This is a large project. I've:
- Broken it into 4 phases
- Sized tasks to < 2h each
- Enabled supervisor (catches architectural conflicts)
- Enabled outer Ralph (final quality pass)
- Recommended Architect consultation before Phase 1
- Set safety bounds: $15 budget, 3h per session

Does this look good?

User: Perfect!

Agent: ✓ Task document saved: ~/saas-mvp-task.md

Next steps:
1. Review the document (it's detailed!)
2. Adjust if needed (it's just markdown)
3. Run: /workflow ~/saas-mvp-task.md

Estimated time: 6-8 hours (across multiple sessions)
Estimated cost: $15-20
```

---

## When to Use

**Use prepare-task when**:
- You have a rough idea but not a detailed plan
- You're unsure how to break down a complex task
- You want guidance on best practices (supervisor, agents, criteria)
- You want to ensure your task is well-defined before running workflow

**Skip prepare-task when**:
- You already have a complete task.md file
- You're very familiar with the task document format
- Task is trivial (just use `/workflow` directly with a simple task)

---

## Integration with Workflow

**Typical flow**:
```
/prepare-task "your idea"
  → Questions & refinement
  → Saves task.md
  → /workflow task.md
  → Execution
```

**Seamless handoff**:
- Task refiner generates workflow-compatible task.md
- No manual editing needed (unless you want to)
- Ready to execute immediately

---

## Tips

1. **Be specific in initial description** - More details = fewer questions
2. **Reference examples** - "Like simple-example.md but for X"
3. **Answer incrementally** - Agent asks 3-5 questions at a time
4. **Iterate** - See draft, request changes, refine
5. **Save iterations** - Agent can save multiple drafts as you refine

---

## Advanced Usage

### From Rough Draft

If you have a partial task.md:

```bash
/prepare-task --input ~/rough-draft.md
```

Agent will:
- Read your draft
- Identify missing sections
- Ask questions to fill gaps
- Generate complete version

### With Constraints

Specify constraints upfront:

```bash
/prepare-task "Add auth" --max-time 1h --max-cost $5
```

Agent will:
- Size tasks accordingly
- Recommend simple approaches
- Warn if scope too large for constraints

### For Existing Project

If task affects existing codebase:

```bash
/prepare-task "Refactor auth system" --context-files "src/auth/*.ts"
```

Agent will:
- Read existing files first
- Ask questions informed by current code
- Generate task that integrates smoothly

---

## Output Files

**Primary output**: `task-[name].md`

**Optional outputs**:
- `task-[name]-draft-1.md` - First draft (if you want iterations saved)
- `task-[name]-draft-2.md` - Second draft
- `task-[name]-final.md` - Final approved version

---

## Validation

Before saving, agent validates:

**Completeness**:
- [ ] Goal is clear and specific
- [ ] Context explains current state
- [ ] Success criteria are testable
- [ ] All tasks have success criteria
- [ ] Complexity assessed
- [ ] Agents assigned where needed
- [ ] Supervisor configured
- [ ] Outer Ralph configured
- [ ] Safety bounds set

**Quality**:
- [ ] No vague language
- [ ] Success criteria verifiable
- [ ] Tasks sized appropriately
- [ ] Dependencies clear
- [ ] Rollback plan exists

Agent will warn you if issues detected.

---

## Error Handling

**If description too vague**:
```
Agent: "Add features" is too vague. Could you specify:
- Which features?
- Why are they needed?
- What defines success?
```

**If scope too large**:
```
Agent: This seems like a 40-hour project, but your budget is $5.
Options:
1. Reduce scope (MVP approach)
2. Split into multiple workflows
3. Increase budget
Which would you prefer?
```

**If contradictory requirements**:
```
Agent: You said "must complete in 1 hour" but also "comprehensive test coverage."
These conflict. Should we:
1. Extend time budget
2. Reduce test coverage requirement
3. Scope down the feature
```

---

## Best Practices

1. **Start with prepare-task** - Don't write task.md manually (tedious)
2. **Provide context** - More info upfront = fewer questions
3. **Use examples** - "Like simple-example.md" helps agent understand scope
4. **Iterate freely** - Draft → Feedback → Refine
5. **Save final version** - Keep for future reference
6. **Review before running** - Task.md is editable markdown

---

## Comparison

| Without prepare-task | With prepare-task |
|---------------------|-------------------|
| Write task.md manually (30-60 min) | Answer questions (5-10 min) |
| Miss important sections | All sections covered |
| Unclear success criteria | Specific, testable criteria |
| Guess at task sizing | Agent recommends based on scope |
| Forget supervisor/Ralph | Best practices recommended |
| Trial and error | Validated before execution |

---

## Dependencies

**Required**:
- Agent: task-refiner
- Tools: AskUserQuestion, Write, Read

**Optional**:
- Scope Analyst (GPT expert for complex projects)

---

## Examples

**Simple tasks**:
- "Add logging to API endpoints"
- "Fix SQL injection in user search"
- "Create README documentation"

**Medium tasks**:
- "Add user authentication with JWT"
- "Implement caching layer with Redis"
- "Build admin dashboard with charts"

**Complex tasks**:
- "Build multi-tenant SaaS platform"
- "Migrate from monolith to microservices"
- "Implement real-time analytics pipeline"

---

## Troubleshooting

**Agent asks too many questions**:
- Provide more detail in initial description
- Reference examples: "Like simple-example.md"

**Generated task.md too complex**:
- Ask agent to simplify: "Can we break this into smaller tasks?"
- Reduce scope: "Let's focus on MVP only"

**Generated task.md too simple**:
- Provide more requirements: "Also need test coverage, security audit"
- Reference complex example: "More like complex-example.md"

**Want to edit manually**:
- That's fine! Task.md is just markdown
- Use generated version as starting point
- Edit as needed before running /workflow

---

## Future Enhancements

Planned:
- [ ] Learn from previous successful workflows
- [ ] Suggest phases based on similar tasks
- [ ] Auto-detect tech stack and recommend agents
- [ ] Generate test specifications with tasks
- [ ] Integration with GitHub issues

---

**Ready to create your task document?**

```bash
/prepare-task "your task description here"
```
