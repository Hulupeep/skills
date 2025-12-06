# Issue-First Dev Loop

A Claude Code skill that enforces structured development workflow: **Issue → Plan → Code**.

## The Problem

When you report a bug or request a change, LLMs immediately suggest code fixes. This leads to:
- No traceability of what was changed and why
- Scope creep and unintended side effects
- Fixes that address symptoms, not root causes
- No documentation for future reference

## The Solution

This skill forces a deterministic workflow:

1. **Phase 1: Issue Draft** - Structured problem statement (no code)
2. **Phase 2: Change Plan** - Explicit scope and invariants (still no code)
3. **Phase 3: Implementation** - Code only after approval

## Installation

```bash
cp -r issue-first-dev-loop ~/.claude/skills/
```

The skill auto-triggers on development keywords.

## Usage

Just describe your bug or change request naturally:

```
"The auth flow is broken, users can't log in after password reset"
```

Instead of immediately suggesting code, Claude will:

1. Draft a structured issue with reproduction steps, hypothesis, and acceptance criteria
2. Wait for your approval
3. Create a change plan listing files to modify and invariants to preserve
4. Wait for your approval
5. Only then implement the fix

## Example Flow

### Before (Chaotic)

```
You: "The extension is binding to current window instead of all windows"

Claude: "Try changing line 47 from getCurrent to getAll..."
```

No traceability. No plan.

### After (Deterministic)

```
You: "The extension is binding to current window instead of all windows"

Claude:

## Issue Draft

**Title:** Extension binds to current window instead of all windows

**Reproduction:**
1. Open multiple windows
2. Activate extension
3. Only current window tracked

**Hypothesis:** getCurrent() returns only active window

**Acceptance Criteria:**
- [ ] All windows monitored
- [ ] No regression in single-window use

---
Approve or edit this issue.
```

You: "Approved"

```
Claude:

## Change Plan

**Files to modify:**
- background.js — Change window fetching logic

**Files NOT to touch:**
- popup.js — UI layer

**Invariants:**
- Single-window still works
- Storage format unchanged

---
Approve to implement.
```

You: "Go"

```
Claude: [Implements fix within approved scope]
```

## Trigger Phrases

- "bug", "there's a bug", "found a bug"
- "fix this", "change this", "refactor"
- "broken", "not working", "error in"
- Any complaint + evidence (logs, screenshots)

## Key Behaviors

| Trigger | Response |
|---------|----------|
| "Bug in X" | Issue draft (NO code) |
| "Fix this" | Issue draft (NO code) |
| "Just fix it quickly" | **Still** issue draft first |
| "Approved" | Change plan (NO code) |
| "Plan approved" | Code implementation |

## Integration

### GitHub Issues
Copy the issue draft markdown directly into a GitHub issue.

### Pull Requests
Change plan becomes PR description with:
- Issue reference
- Files modified (matches scope)
- Test coverage
- Invariants preserved

## Tips

1. **Be messy in your input** — The skill extracts structure from chaos
2. **Include logs/errors** — More evidence = better hypothesis
3. **Edit the issue draft** — It's collaborative
4. **Trust the phases** — Skipping to code is the old way

## Override

If you truly need to skip:

```
SKIP ISSUE WORKFLOW: [your request]
```

Use sparingly — you lose traceability.

## Files

| File | Purpose |
|------|---------|
| `issue-first-dev-loop/SKILL.md` | Main skill definition |
| `issue-first-dev-loop-system-prompt.md` | Standalone system prompt |
