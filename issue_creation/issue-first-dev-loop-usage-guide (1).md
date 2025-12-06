# Issue-First Dev Loop: Usage Guide

## Installation

1. Download `issue-first-dev-loop.skill`
2. In Claude Code settings, add the skill to your skills directory
3. The skill auto-triggers on development keywords

## The Experience

### Before (Chaotic)

```
You: "The TabStax extension is binding to current window instead of all windows, 
      here's the log output... [paste]"

Claude Code: "I see the issue! Try changing line 47 in background.js from 
              chrome.windows.getCurrent to chrome.windows.getAll..."
```

↑ This immediately proposes code. No traceability. No plan. Silent mutation.

### After (Deterministic)

```
You: "The TabStax extension is binding to current window instead of all windows, 
      here's the log output... [paste]"

Claude (Issue Agent): 

## Issue Draft

**Title:** TabStax binds to current window instead of all windows

**Context:**
- Project: TabStax
- Component: Window binding logic

**Reproduction:**
1. Open multiple Chrome windows
2. Activate TabStax
3. Observe: Only current window's tabs are tracked

**Expected:** All windows should be monitored
**Actual:** Only current window monitored

**Evidence:**
> [quotes your log showing getCurrent call]

**Hypothesis:** `chrome.windows.getCurrent()` in background.js returns only active 
window. Should use `chrome.windows.getAll()` with callback iteration.

**Acceptance Criteria:**
- [ ] Extension monitors all open windows
- [ ] Tab changes in any window trigger updates
- [ ] No regression in current window functionality

---
Approve, edit, or "push to GitHub as project:tabstax label:bug"
```

You: "Approved, implement it"

```
Claude (Issue Agent):

## Change Plan: TabStax binds to current window instead of all windows

**Issue Reference:** (pending GitHub push)

### Files to Modify

| File | Change Type | Description |
|------|-------------|-------------|
| `background.js` | Modify | Change window fetching logic |
| `tests/window-binding.test.js` | Add | Test multi-window scenarios |

### Files Explicitly OUT of Scope
- `popup.js` — UI layer, not relevant
- `manifest.json` — No permission changes needed

### Invariants
1. **Single-window still works**: Users with one window see no change
2. **Tab event listeners**: Existing tab listeners remain functional
3. **Storage format**: Saved stax format unchanged

### Test Plan
- [ ] `test_multi_window_detection` — Opens 3 windows, verifies all monitored
- [ ] `test_single_window_unchanged` — Existing behavior preserved
- [ ] `test_tab_events_across_windows` — Tab changes in any window fire events

### Risk Assessment
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Performance with many windows | Low | Lazy evaluation of window list |

---
Approve this plan to begin implementation.
```

You: "Go"

```
Claude (Coder Agent):

Implementing Issue: TabStax window binding
Following approved plan.
Scope: background.js, tests/window-binding.test.js

[Code implementation follows]
[Tests added]

PR ready. References: TabStax Window Binding Issue
```

## Key Behaviors

| Trigger | Response |
|---------|----------|
| "Bug in X" | Issue draft (NO code) |
| "Fix this" | Issue draft (NO code) |
| "Just fix it quickly" | **Still** issue draft first |
| "Approved" | Change plan (NO code) |
| "Plan approved, implement" | Code implementation |

## Integration with Your Stack

### chat2repo
The issue markdown can be pushed directly:
```
"Push this issue to GitHub as project:tabstax label:bug priority:high"
```

### GitHub Actions
Issue file → Action parses → Real GitHub Issue created → Coder agent triggered

### PR Workflow
Change plan becomes PR description template with:
- Issue reference
- Files modified (matches scope)
- Test coverage
- Invariants preserved

## Tips

1. **Be messy in your input** — The skill extracts structure from chaos
2. **Include logs/errors** — More evidence = better hypothesis
3. **Edit the issue draft** — It's collaborative, not prescriptive
4. **Trust the phases** — Skipping to code is the old way

## Override (Emergency Only)

If you truly need to skip the workflow:
```
"SKIP ISSUE WORKFLOW: [your request]"
```

This bypasses the skill. Use sparingly — you lose traceability.
