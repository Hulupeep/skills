---
name: Proof-of-Work Agent Contract
description: Trust-verification framework that prevents "confidently wrong" agents. Forces evidence, receipts, and traceability before any code changes. LLM must prove it analyzed the right code, followed all instructions, and fixed everything. Use when agent changes break your app or you need high confidence in correctness.
---

# Proof-of-Work Agent Contract

## Core Philosophy

**RECEIPTS, NOT PROSE. EVIDENCE, NOT ANALYSIS.**

The real problem: you lack **evidence** that the agent's reasoning, scope, and changes matched your intent.

**This skill prevents:**
- ❌ Partial ingestion (read some files, not all)
- ❌ Instruction drift (satisfied easy parts, skipped tricky ones)
- ❌ Silent divergence (changed code without tying to acceptance criteria)
- ❌ No receipts (outputs without proof of what was read, tested, verified)
- ❌ "Confidently wrong" fixes that cause regressions
- ❌ Breaking your app with untested changes

**Designed for:**
- ✅ High-stakes changes where regressions are unacceptable
- ✅ Complex refactors requiring complete coverage
- ✅ UI fixes where "looks right" isn't enough
- ✅ When you've been burned by agent mistakes before
- ✅ Establishing trust with new codebases

---

## When to Use This Skill

**ALWAYS use when:**
- Agent has caused regressions in the past
- UI/UX changes that must not break layout
- Critical path code (auth, payments, data integrity)
- Multiple acceptance criteria that ALL must pass
- Working with unfamiliar codebase
- Need audit trail of what changed and why

**DO NOT skip the dry-run. If agent won't produce a patch first, stop.**

---

## The 5-Step Protocol

### Step 1: Analysis Receipt (REQUIRED BEFORE CODE)

Agent MUST produce before any changes:

```markdown
## ANALYSIS RECEIPT

### Files Scanned
| Path | Size | LOC | Responsibility |
|------|------|-----|----------------|
| src/components/Layout.tsx | 8.2KB | 268 | Grid layout, sticky positioning |
| src/globals.css | 2.1KB | 73 | CSS tokens, layout variables |
| ... | ... | ... | ... |

**Total:** N files, X KB, Y LOC

### Coverage Map
| Acceptance Criterion | Related Files | Coverage |
|---------------------|---------------|----------|
| AC1: No row separators | ListRow.tsx, styles.css | ✅ Complete |
| AC2: Row height ≤ 36px | ListRow.tsx, globals.css | ✅ Complete |
| AC3: Single border | Viewport.tsx, Card.tsx | ⚠️  Card.tsx not found - need clarification |
| ... | ... | ... |

### Risks & Unknowns
- **Risk:** Async timing may affect control plane position
- **Unknown:** Is ShareLayout.tsx affected? Not in scope.
- **Out of scope:** Auth logic, networking

### Self-Quiz (What Could Go Wrong)
1. What if grid recalculation happens during data load?
2. What if sticky positioning breaks in different browsers?
3. What regressions could this introduce?
4. What's explicitly NOT being changed?
5. What must NOT regress?
```

**If agent cannot produce this, STOP. It hasn't read enough.**

---

### Step 2: Plan-of-Change (REQUIRED BEFORE CODE)

Agent MUST map each AC to concrete changes:

```markdown
## PLAN-OF-CHANGE

### AC1: No row separators
**Target:** `src/components/ListRow.tsx`
- **Selector:** Line 43, className string
- **Change:** Remove `border-t` and `border-b` classes
- **Test:** `test_no_row_separators` - assert borderTopWidth === '0px'

### AC2: Row height ≤ 36px
**Target:** `src/globals.css`
- **Selector:** Line 27, `--popup-row-height`
- **Change:** `46px` → `36px`
- **Test:** `test_row_height_compact` - assert row.offsetHeight <= 36

### AC3: Single border
**Target:** `src/components/Viewport.tsx`, `src/components/Card.tsx`
- **Selector:** Line 12 (Viewport), Line 8 (Card)
- **Change:** Remove border from Card, keep on Viewport
- **Test:** `test_single_outer_border` - assert 1 border total

### Forecasted Diff
- **Files changed:** 3 (ListRow.tsx, globals.css, Viewport.tsx)
- **Lines added:** ~15
- **Lines removed:** ~8
- **Total delta:** ~23 LOC
```

**If AC lacks a plan, STOP. Agent doesn't know what to change.**

---

### Step 3: Tests First (REQUIRED BEFORE CODE)

Agent MUST write tests that fail NOW, pass AFTER:

```markdown
## TESTS FIRST

### New/Modified Tests

#### test_no_row_separators
```typescript
it("rows must not have border separators", () => {
  const rows = screen.getAllByTestId("tab-row")
  rows.forEach(row => {
    const styles = window.getComputedStyle(row)
    expect(styles.borderTopWidth).toBe("0px")
    expect(styles.borderBottomWidth).toBe("0px")
  })
})
```
**Status:** ❌ FAILS (current code has borders)

#### test_row_height_compact
```typescript
it("row height must be <= 36px", () => {
  const rows = screen.getAllByTestId("tab-row")
  rows.forEach(row => {
    expect(row.offsetHeight).toBeLessThanOrEqual(36)
  })
})
```
**Status:** ❌ FAILS (current height is 46px)

### Test Run Results (BEFORE)
```
FAIL src/__tests__/layout.test.ts
  ✗ test_no_row_separators (12ms)
  ✗ test_row_height_compact (8ms)
  ✗ test_single_outer_border (6ms)

3 failed, 0 passed
```
```

**If all tests pass NOW, STOP. Tests aren't testing the bug.**

---

### Step 4: Dry-Run Patch (REQUIRED BEFORE APPLY)

Agent MUST produce patch/diff, NOT apply changes:

```markdown
## DRY-RUN PATCH

### Git Diff Preview
```diff
diff --git a/src/components/ListRow.tsx b/src/components/ListRow.tsx
index abc123..def456 100644
--- a/src/components/ListRow.tsx
+++ b/src/components/ListRow.tsx
@@ -40,7 +40,7 @@
 export const ListRow = ({ tab }) => {
   return (
     <div
-      className="flex py-1 border-t border-b"
+      className="flex py-1"
       data-testid="tab-row"
     >
...
```

### Traceability Table
| AC | Test Name | Files Changed | Expected Result |
|----|-----------|---------------|-----------------|
| AC1 | test_no_row_separators | ListRow.tsx | PASS |
| AC2 | test_row_height_compact | globals.css, ListRow.tsx | PASS |
| AC3 | test_single_outer_border | Viewport.tsx, Card.tsx | PASS |
| AC4 | test_control_plane_stable | ControlPlane.tsx | PASS |

### Human Review Checklist
- [ ] All ACs have corresponding tests
- [ ] All tests currently fail
- [ ] Diff looks reasonable (no surprise changes)
- [ ] No changes outside stated scope
- [ ] Traceability table complete
```

**DO NOT APPLY until human reviews and approves.**

---

### Step 5: Apply + Verify (ONLY AFTER APPROVAL)

After human approval, agent applies and verifies:

```markdown
## APPLY + VERIFY

### Changes Applied
✅ Applied patch from Step 4
✅ No merge conflicts
✅ Build successful

### Test Results (AFTER)
```
PASS src/__tests__/layout.test.ts
  ✓ test_no_row_separators (8ms)
  ✓ test_row_height_compact (6ms)
  ✓ test_single_outer_border (7ms)
  ✓ test_control_plane_stable (1502ms)

4 passed, 0 failed
```

### Change Bill of Materials
- **Files modified:** 3
- **Lines changed:** 23
- **Tests added:** 4
- **Tests updated:** 0
- **Regressions:** 0 detected

### Residual Risk
- **Low risk:** Browser compatibility (tested Chrome, Firefox, Safari)
- **Medium risk:** Async timing edge cases (added 1.5s test wait)
- **Rollback:** `git revert abc123` restores previous state

### Verification Screenshots
[If UI change, include before/after screenshots]
```

---

## Work Order Template

Use this to communicate intent to agent:

```markdown
# WORK ORDER: [Project] - [Brief Description]

## CONTEXT (short)
[1-2 sentences explaining the problem]

## ACCEPTANCE CRITERIA (must ALL be true)
AC1. [Specific, measurable criterion]
AC2. [Specific, measurable criterion]
AC3. [Specific, measurable criterion]
AC4. [Specific, measurable criterion]
AC5. [Specific, measurable criterion]
AC6. Tests exist that fail now and pass after the fix

## SCOPE
- [What's in scope]
- [What's in scope]

## OUT OF SCOPE
- [What's NOT being changed]
- [What's NOT being changed]

## ENV/ENTRY
- Repo root: [path]
- Entry point: [path to main file]
- Build: [command]
- Test: [command]

## NOTES
- [Any additional context]
- [Constraints]
```

---

## UI Test Invariants Template

For UI/layout changes, define these invariants:

```typescript
// UI INVARIANTS (encode as tests)

// No visual separators between rows
test("no row borders", () => {
  rows.forEach(row => {
    expect(getComputedStyle(row).borderTopWidth).toBe('0px')
    expect(getComputedStyle(row).borderBottomWidth).toBe('0px')
  })
})

// Compact row height
test("compact rows", () => {
  rows.forEach(row => {
    expect(row.offsetHeight).toBeLessThanOrEqual(36)
  })
})

// Single container border
test("single card border", () => {
  const borders = countBordersInTree(container)
  expect(borders).toBe(1)
})

// Anchored control plane (no bounce)
test("control plane stable", async () => {
  const initialTop = controlPlane.getBoundingClientRect().top
  await wait(1500) // Wait for async operations
  const finalTop = controlPlane.getBoundingClientRect().top
  expect(Math.abs(finalTop - initialTop)).toBeLessThanOrEqual(0)
})

// No scroll outside viewport
test("only viewport scrolls", () => {
  const scrollers = findElementsWithScroll(container)
  expect(scrollers).toEqual([viewport]) // Only viewport
})
```

---

## Traceability Table Template

Agent MUST fill this out completely:

```markdown
| AC | Test Name | Files Changed | Status |
|----|-----------|---------------|--------|
| A1 | test_invariant_1 | file1.ts, file2.css | PASS ✅ |
| A2 | test_invariant_2 | file3.tsx | PASS ✅ |
| A3 | test_invariant_3 | file4.ts | PASS ✅ |
| A4 | test_invariant_4 | file5.tsx | PASS ✅ |
| A5 | test_invariant_5 | file6.ts | PASS ✅ |
| A6 | meta_all_ac_have_tests | tests/* | PASS ✅ |
```

**If any row is incomplete or status is not PASS, do not merge.**

---

## PR Template (Enforce in Git)

Require this in every PR:

```markdown
### Summary
[One-line description]

### Receipts
- Files scanned: [N], total LOC: [X]
- Coverage map: [Link to Analysis Receipt]

### Plan-of-Change
[Link to Plan-of-Change document]

### Tests
- New tests: [N]
- Updated tests: [N]
- Before/after results: [Link or inline]

### Diff Forecast vs Actual
- Forecasted files/LOC: [X/Y]
- Actual files/LOC: [X/Y]
- Variance explanation: [If > 20% variance]

### Traceability
[Insert traceability table]

### Residual Risk & Rollback
- Risks: [List any remaining risks]
- Rollback: `git revert [commit-sha]`
```

---

## Human Operator Checklist

Before approving any agent changes:

- [ ] **Analysis Receipt** exists with file list and coverage map
- [ ] **Plan-of-Change** maps every AC to specific files/selectors
- [ ] **Tests written** and currently FAILING for each AC
- [ ] **Dry-run patch** produced (no changes applied yet)
- [ ] **Traceability table** complete (AC → Test → Files)
- [ ] **Test results** show all tests pass after patch
- [ ] **Change BoM** provided with residual risk assessment
- [ ] **Diff review** shows no surprise changes outside scope

**If ANY checkbox is unchecked, DO NOT APPROVE.**

---

## Stop Conditions

Agent MUST stop and ask questions if:

- Cannot find a file mentioned in ACs
- AC is ambiguous or has multiple interpretations
- Environment/build fails
- Test framework not found
- Cannot reproduce current behavior
- Scope uncertainty (is X in scope?)

**Better to ask 1-3 precise questions than guess and break things.**

---

## Why This Works

### Instruction Coverage
Traceability table enforces "no AC, no merge"

### Reading Coverage
Analysis Receipt proves files were read and understood

### Correctness
Tests-first + dry-run prevents untested changes

### Human Leverage
You approve plans and patches, not guess at what happened

### Audit Trail
Every change tied to AC, test, and file - full traceability

---

## Cost-Benefit Analysis

### Pros
- ✅ Auditability (know exactly what changed and why)
- ✅ Fewer regressions (tests prevent breaking changes)
- ✅ Faster convergence (correct on first try, not third)
- ✅ Trust building (agent proves correctness)
- ✅ Learning tool (understand codebase through receipts)

### Costs
- ⏱️ Upfront ceremony (writing tests, creating receipts)
- ⏱️ Human review time (approving patches)
- ⏱️ Agent token usage (more analysis work)

### Answer
**This is minimum viable governance for agentic development.**

Without it, you're gambling that agent:
- Read the right files
- Understood the requirements
- Tested the changes
- Didn't break anything else

**With regressions costing hours or days, the ceremony pays for itself in the first prevented bug.**

---

## Example Workflow

### 1. User Writes Work Order

```markdown
# WORK ORDER: TabStax Popup - Compact List

CONTEXT:
Popup tab list is too airy (46px rows), shows grey dividers, and control plane bounces after auth loads.

ACCEPTANCE CRITERIA:
AC1. No visual row separators
AC2. Row height ≤ 36px
AC3. Single border on viewport only (no double border)
AC4. Control plane anchored (no bounce after 2s)
AC5. Layout consistent pre/post auth
AC6. Tests exist that fail now, pass after

SCOPE:
- Popup components (list, rows, container, control plane)

OUT OF SCOPE:
- Auth logic, networking, other views

ENV:
- Repo: ~/code/tabstax
- Build: npm run build
- Test: npm test
```

### 2. Agent Produces Analysis Receipt

```markdown
## ANALYSIS RECEIPT

Files Scanned: 8 files, 42.3 KB, 1,247 LOC

Coverage Map:
- AC1: ListRow.tsx ✅, StaxTabsList.tsx ✅
- AC2: globals.css ✅, ListRow.tsx ✅
- AC3: Viewport.tsx ✅, Card.tsx ⚠️ (min-h not h)
- AC4: PopupLayout.tsx ✅, ControlPlane.tsx ✅
- AC5: MainPopup.tsx ✅, useStaxData.ts ✅

Risks:
- Grid 1fr vs auto conflict
- Async timing in useStaxData.ts:1316

Self-Quiz:
1. Will removing borders affect row hover states?
2. Can sticky position break without 1fr?
3. Will height change affect scroll calculations?
4. What happens during data loading?
5. Browser compatibility risks?
```

### 3. Agent Produces Plan-of-Change

```markdown
## PLAN-OF-CHANGE

AC1: Remove row separators
- Target: src/components/StaxTabsList.tsx:43
- Change: Remove border-t, border-b classes
- Test: test_no_row_separators

AC2: Reduce row height
- Target: src/globals.css:27
- Change: --popup-row-height: 46px → 36px
- Test: test_row_height_compact

[...continues for all ACs...]

Forecasted Diff: 5 files, ~38 LOC
```

### 4. Agent Writes Failing Tests

```markdown
## TESTS FIRST

test_no_row_separators - ❌ FAILS
test_row_height_compact - ❌ FAILS
test_single_outer_border - ❌ FAILS
test_control_plane_stable - ❌ FAILS

4 failures confirmed
```

### 5. Agent Produces Dry-Run Patch

```markdown
## DRY-RUN PATCH

[Git diff showing all changes]

Traceability:
AC1 → test_no_row_separators → StaxTabsList.tsx
AC2 → test_row_height_compact → globals.css, ListRow.tsx
[...complete table...]

AWAITING HUMAN APPROVAL
```

### 6. Human Reviews & Approves

- ✅ Receipts look complete
- ✅ All ACs mapped
- ✅ Tests failing as expected
- ✅ Diff looks reasonable
- **APPROVED**

### 7. Agent Applies & Verifies

```markdown
## APPLY + VERIFY

✅ Patch applied
✅ Tests pass (4/4)
✅ Build successful
✅ No regressions detected

Change BoM: 5 files, 38 LOC, 4 tests
Residual Risk: Low
```

---

## Integration with Other Skills

### Works With
- **london-tdd**: Use for TDD workflow, this skill adds verification layer
- **debug-protocol**: Use for reproducing bugs before fixing
- **preflight-architecture**: Use for design decisions before implementation
- **thin-slice-mvp**: Use to verify MVP slice is complete

### Supercedes
- Ad-hoc "just fix it" requests
- "Try this and see if it works" debugging
- Unverified agent changes

---

## Success Criteria

You know this skill is working when:

- ✅ Agent produces receipts BEFORE touching code
- ✅ Every AC has a failing test before implementation
- ✅ You review diffs BEFORE they're applied
- ✅ Traceability table is complete for every PR
- ✅ Regressions drop to near-zero
- ✅ You trust agent changes without manual verification
- ✅ Rollbacks are easy (clear audit trail)

**If agent tries to "just fix it" without receipts, invoke this skill.**

---

## Common Mistakes

### Mistake 1: Skipping Analysis Receipt
**Wrong:** "Just fix the layout issue"
**Right:** "Use proof-of-work-agent skill. Produce Analysis Receipt first."

### Mistake 2: Accepting Passing Tests
**Wrong:** Tests pass before and after → seems fine
**Right:** Tests MUST fail before fix. If passing, they're not testing the bug.

### Mistake 3: Approving Without Dry-Run
**Wrong:** Agent applies changes, then shows diff
**Right:** Agent shows diff, you approve, then agent applies

### Mistake 4: Incomplete Traceability
**Wrong:** AC5 has no test in the table
**Right:** Every AC must have test, file, and status

### Mistake 5: Trusting "Looks Good"
**Wrong:** Visual inspection suggests it's fixed
**Right:** Tests prove it's fixed, measurements confirm

---

## Advanced: Measurement-Driven Verification

For layout/UI issues where "looks right" isn't enough:

```typescript
// Add measurement instrumentation
useLayoutEffect(() => {
  const measurements = {
    windowHeight: window.innerHeight,
    cardHeight: card.getBoundingClientRect().height,
    gridHeight: grid.getBoundingClientRect().height,
    listHeight: list.getBoundingClientRect().height,
    commandPlaneTop: commandPlane.getBoundingClientRect().top,
    statusBarBottom: statusBar.getBoundingClientRect().bottom,
    gapFromBottom: window.innerHeight - statusBar.getBoundingClientRect().bottom
  }

  console.table(measurements)

  // Assert measurements match expected
  expect(measurements.gapFromBottom).toBeLessThanOrEqual(1)
  expect(measurements.commandPlaneTop).toBeGreaterThan(400)
})
```

**Measurements provide objective proof that visual inspection cannot.**

---

## Feedback Loop

After using this skill, improve it by documenting:

1. **What receipts revealed issues?** → Add to checklist
2. **What tests caught regressions?** → Add to invariants template
3. **What questions agent should have asked?** → Add to stop conditions
4. **What traceability gaps appeared?** → Strengthen table requirements

**This skill gets better the more you use it.**

---

## TL;DR

**Before any code changes:**
1. Analysis Receipt (files read, coverage map, risks)
2. Plan-of-Change (AC → files → changes)
3. Tests First (failing tests for each AC)
4. Dry-Run Patch (show diff, don't apply)

**After human approval:**
5. Apply + Verify (run tests, provide BoM)

**Never accept:**
- Changes without receipts
- Tests that pass before the fix
- Applied changes before review
- Incomplete traceability

**This prevents "confidently wrong" agents from breaking your app.**
