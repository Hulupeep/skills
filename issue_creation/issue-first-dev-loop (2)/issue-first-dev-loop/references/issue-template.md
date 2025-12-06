# Issue Template

Use this template when drafting issues from user bug reports or change requests.

## Standard Issue Format

```markdown
## [TYPE]: [Title]

**Type:** Bug | Feature | Refactor | Tech Debt
**Priority:** Critical | High | Medium | Low
**Project:** [project-name]
**Labels:** [comma-separated]

### Context

- **Component:** [affected component/module]
- **Branch:** [branch name if known]
- **Commit:** [commit hash if relevant]
- **Environment:** [dev/staging/prod]

### Problem Statement

[2-3 sentences describing what's wrong or what needs to change]

### Reproduction Steps

1. [First action]
2. [Second action]
3. [Third action]
4. [Observe: description of failure]

### Expected Behavior

[What should happen]

### Actual Behavior

[What actually happens]

### Evidence

```
[Paste relevant logs, error messages, or stack traces]
```

[Screenshot references if provided]

### Hypothesis

[Your informed analysis of what's likely causing this. Include:
- Which code path is likely involved
- What condition might be triggering it
- Any patterns you notice]

### Acceptance Criteria

- [ ] [Specific, testable outcome 1]
- [ ] [Specific, testable outcome 2]
- [ ] [No regression in related functionality]
- [ ] [Tests pass]

### Related

- Related issues: [links if any]
- Docs: [relevant documentation]
- Previous discussions: [links if any]
```

## Field Extraction Guide

When parsing messy user input:

| User provides | Extract to |
|---------------|------------|
| Log snippets | Evidence section |
| "It should do X but does Y" | Expected vs Actual |
| "When I click..." | Reproduction steps |
| "This broke after..." | Context/Commit |
| Emotional language ("hate this", "so frustrating") | Ignore, extract facts only |
| Screenshots | Evidence, describe what they show |

## Priority Assessment

- **Critical**: System unusable, data loss, security issue
- **High**: Core functionality broken, workaround difficult
- **Medium**: Feature degraded, workaround exists
- **Low**: Minor annoyance, cosmetic, edge case

## Minimum Viable Issue

At minimum, an issue MUST have:
1. Clear title
2. Problem statement
3. At least 1 acceptance criterion

Everything else is valuable but optional if user hasn't provided enough info.
