---
name: issue-first-dev-loop
description: |
  Enforces deterministic development workflow. Use when user mentions: "bug", "fix this", "change this", "refactor", "broken", "not working", "error in", or tags with dev/bug, dev/change, dev/refactor. CRITICAL: Never propose code in first response. Always produce structured issue first, then change plan, then hand off to coder. Acts as orchestrator layer that transforms messy bug reports into traceable artifacts before any code mutation.
---

# Issue-First Dev Loop

Orchestrator agent that transforms development chaos into deterministic, traceable artifacts.

## Core Constraint

**NEVER modify or propose code in your first response to a bug/change request.**

Always:
1. Summarize the problem
2. Draft a structured issue
3. Wait for approval before any implementation

## Workflow Phases

### Phase 1: Issue Drafting (MANDATORY FIRST STEP)

When user reports any bug, error, or requests code changes:

1. **Do not propose code**
2. Parse the messy input
3. Return a filled issue using the template in `references/issue-template.md`
4. Ask: "Does this capture the issue? Edit, approve, or I can push to GitHub."

Output format:
```
## Issue Draft

**Title:** [Concise problem statement]

**Context:**
- Project: [inferred or ask]
- Branch/Commit: [if provided]
- Component: [affected area]

**Reproduction:**
1. [step]
2. [step]
3. [step]

**Expected:** [what should happen]
**Actual:** [what happened]

**Evidence:**
> [quoted logs/errors/screenshots referenced]

**Hypothesis:** [your informed guess at root cause]

**Acceptance Criteria:**
- [ ] [specific testable outcome]
- [ ] [specific testable outcome]

---
Approve, edit, or say "push to GitHub as project:X label:bug"
```

### Phase 2: Change Plan (ONLY AFTER ISSUE APPROVED)

When user says "implement this" or "go ahead":

1. **Still no code**
2. Read the approved issue
3. Produce a change contract using `references/change-plan-template.md`

Output format:
```
## Change Plan for: [Issue Title]

**Files to modify:**
- `path/to/file.ts` — [what changes]
- `path/to/other.ts` — [what changes]

**Files NOT to touch:** (explicit scope boundary)
- `path/to/untouched.ts`

**Invariants (must not break):**
- [existing behavior that must remain]
- [data format that must stay compatible]

**Tests to add/modify:**
- [ ] [test description]
- [ ] [test description]

**Migration/Data risks:**
- [any risks, or "None identified"]

---
Approve this plan to begin implementation, or edit.
```

### Phase 3: Handoff to Coder (ONLY AFTER PLAN APPROVED)

When user approves the plan:

1. Now code implementation begins
2. Follow the plan strictly—no files outside scope
3. Implement tests as specified
4. Prepare PR summary referencing the issue

Coder instructions:
```
Implementing Issue: [title]
Following approved plan.
Scope: [files listed]
Invariants: [behaviors to preserve]

[Implementation proceeds]

PR ready. References Issue #[X] / [link].
```

## Trigger Phrases

Activate this workflow on:
- "bug", "there's a bug", "found a bug"
- "fix this", "can you fix"
- "change this", "make this change"
- "refactor", "refactor this"
- "broken", "not working", "stopped working"
- "error in", "failing", "crashes"
- "dev/bug:", "dev/change:", "dev/refactor:"
- Any code-related complaint + evidence (logs, screenshots)

## Anti-Patterns (DO NOT DO)

❌ Immediately suggesting code fixes
❌ Saying "try changing line X to Y"
❌ Providing patches without an issue first
❌ Skipping the plan phase
❌ Modifying files not in the approved scope

## Integration Notes

This skill produces artifacts that can feed into:
- **chat2repo**: Issue markdown → GitHub Issues
- **GitHub Actions**: Automated routing and coder agent triggering
- **PR workflows**: Change plans become PR descriptions

## Quick Reference

| User says | You do |
|-----------|--------|
| "Bug in X" | Phase 1: Draft issue |
| "Fix this" | Phase 1: Draft issue |
| "Approved, implement" | Phase 2: Change plan |
| "Plan looks good, go" | Phase 3: Code implementation |
| "Just make the change" | **Still** Phase 1 first |
