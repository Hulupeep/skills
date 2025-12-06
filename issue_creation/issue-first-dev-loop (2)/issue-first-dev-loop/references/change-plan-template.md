# Change Plan Template

Use this template after an issue is approved, before any code implementation.

## Standard Change Plan Format

```markdown
# Change Plan: [Issue Title]

**Issue Reference:** #[number] or [link]
**Prepared by:** Claude (Issue-First Dev Loop)
**Date:** [date]

## Scope

### Files to Modify

| File | Change Type | Description |
|------|-------------|-------------|
| `src/path/file.ts` | Modify | [Brief description] |
| `src/path/other.ts` | Modify | [Brief description] |
| `tests/path/file.test.ts` | Add/Modify | [Test coverage] |

### Files Explicitly OUT of Scope

These files must NOT be modified:
- `src/path/untouched.ts` — [reason why out of scope]
- `config/sensitive.json` — [reason]

## Invariants

Behaviors that MUST NOT change:

1. **[Invariant name]**: [Description of behavior that must be preserved]
2. **[Invariant name]**: [Description]
3. **[Invariant name]**: [Description]

## Implementation Approach

### Step 1: [First logical unit of work]
- [What to do]
- [Expected outcome]

### Step 2: [Second logical unit of work]
- [What to do]
- [Expected outcome]

### Step 3: [Testing]
- [Tests to add]
- [Tests to run]

## Test Plan

### New Tests to Add

- [ ] `test_[description]` — Verifies [acceptance criterion]
- [ ] `test_[description]` — Verifies [acceptance criterion]

### Existing Tests to Verify

- [ ] `existing_test_suite` — Should still pass
- [ ] `integration_tests` — Should still pass

## Risk Assessment

### Migration/Data Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| [Risk description] | Low/Med/High | [How to mitigate] |
| None identified | — | — |

### Rollback Plan

If this change causes issues:
1. [Rollback step]
2. [Verification]

## Dependencies

- [ ] No external dependencies
- [ ] Requires: [dependency if any]

## Definition of Done

- [ ] All acceptance criteria from issue met
- [ ] Tests pass
- [ ] No files modified outside scope
- [ ] Invariants verified
- [ ] PR description references issue
```

## Scope Determination Guide

When determining file scope:

**Include:**
- Files directly related to the bug/feature
- Test files for modified code
- Type definitions if interfaces change

**Exclude:**
- Unrelated modules (even if "while we're at it...")
- Configuration files unless explicitly needed
- Generated files
- Node modules, vendor code

## Invariant Identification

Ask these questions:
1. What does this code currently do that must keep working?
2. What API contracts exist?
3. What data formats must stay compatible?
4. What downstream consumers depend on this?

## Risk Categories

| Category | Questions to Ask |
|----------|-----------------|
| Data | Could this corrupt/lose data? |
| Performance | Could this slow things down? |
| Security | Could this expose vulnerabilities? |
| Compatibility | Could this break existing integrations? |
| UX | Could this confuse users? |

## Handoff Instructions

After plan is approved, instruct the coder agent:

```
## Implementation Task

**Issue:** [reference]
**Approved Plan:** [date]

### Strict Constraints
- ONLY modify files listed in scope
- PRESERVE all invariants listed
- ADD tests specified in test plan
- STOP if you need to touch out-of-scope files

### Expected Deliverables
1. Code changes
2. Test additions/modifications
3. PR description referencing issue

Begin implementation.
```
