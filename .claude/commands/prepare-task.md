---
description: Create task documents interactively via task-refiner agent
argument-hint: <task description>
allowed-tools: Read, Write, Edit, Task, AskUserQuestion, Glob, Grep
---

# Prepare Task Document

Create a complete, workflow-ready task document for: $ARGUMENTS

## Step 1: Spawn Task Refiner Agent

Use the Task tool to spawn the task-refiner agent:

```
Task({
  subagent_type: "general-purpose",
  prompt: "Read .claude/agents/task-refiner.md for your instructions.

TASK: Create a workflow-ready task document for: $ARGUMENTS

PROCESS:
1. Understand the user's goal
2. Ask systematic clarifying questions:
   - Goal clarity (what exactly needs to be done?)
   - Context (what exists today? what's the problem?)
   - Constraints (technical, timeline, budget)
   - Phases and task breakdown
   - Success criteria (specific, testable)
   - Agent recommendations
   - Supervisor configuration
   - Safety bounds (max iterations, cost, time)
3. Generate complete task.md using the template
4. Iterate based on user feedback
5. Save final document

TEMPLATE: .claude/templates/task-template.md

EXAMPLES:
- .claude/examples/simple-example.md
- .claude/examples/complex-example.md

GPT DELEGATION: Use rules/delegator → Scope Analyst for complex requirements analysis.

OUTPUT: Save to ~/[task-name]-task.md

Read the task-refiner agent instructions and begin.",
  description: "Task document creator"
})
```

## Question Categories

The task-refiner will ask about:

| Category | Questions |
|----------|-----------|
| **Goal** | What exactly needs to be done? What's the end state? |
| **Context** | What exists today? What's the problem? |
| **Constraints** | Technical requirements? Timeline? Budget? |
| **Phases** | How to break down the work? Dependencies? |
| **Success Criteria** | How do we know it's done? Testable metrics? |
| **Agents** | Which specialized agents needed? |
| **Supervisor** | Conflict types to watch for? |
| **Safety** | Max iterations? Cost budget? Time limit? |

## Output

Generates a task document with:
- Clear goal statement
- Context and background
- Global success criteria
- Phased task breakdown with per-task criteria
- Agent assignments
- Supervisor configuration
- Safety bounds
- Delegation strategy

Ready for: `/workflow ~/[task-name]-task.md`

## Examples

**Simple task:**
```bash
/prepare-task "Add input validation to API endpoints"
→ 1 phase, 2-3 tasks, ~30 min, ~$1
```

**Complex task:**
```bash
/prepare-task "Build multi-tenant SaaS platform"
→ 4-5 phases, 12+ tasks, ~6-8 hrs, ~$15-20
```
