---
name: Debug Protocol & Root Cause Analysis
description: Methodical troubleshooting framework that prevents "try random things" debugging. Forces hypothesis-driven investigation with binary search approach. LLM must show reasoning at each step. Use when bugs appear or systems behave unexpectedly.
---

# Debug Protocol & Root Cause Analysis

## Core Philosophy
**UNDERSTAND BEFORE FIXING. REPRODUCE BEFORE CLAIMING FIXED.**

LLMs will suggest random fixes without understanding the problem. This skill forces:
1. Reproduce the bug reliably
2. Form hypothesis about cause
3. Test hypothesis (not the fix)
4. Narrow search space (binary search)
5. Identify root cause
6. Fix with verification
7. Add test to prevent regression

**This prevents:**
- ❌ "Try this" without understanding why
- ❌ Fixing symptoms instead of root cause
- ❌ "Works on my machine" bugs
- ❌ Same bug reappearing later
- ❌ Breaking other things while fixing
- ❌ Wasting hours on random attempts

**Designed for:**
- ✅ Systematic investigation
- ✅ Works with hyperfocus (deep dive methodology)
- ✅ Non-linear thinking (multiple hypotheses in parallel)
- ✅ Clear stopping points (when to take break)
- ✅ Context preservation (document investigation)

---

## When to Use This Skill

**ALWAYS use when:**
- Bug appears in tests
- Feature works in dev, fails in production
- Intermittent/flaky behavior
- Performance degradation
- Error message unclear
- System behaving unexpectedly
- "It was working yesterday"

**DO NOT skip reproduction step. If you can't reproduce, you can't fix.**

---

## The Debug Protocol

### Phase 1: Reproduction (MANDATORY)

**Cannot proceed to Phase 2 until bug is reproducible.**

```markdown
## Bug Reproduction Report

### Bug ID: [Descriptive name]
**Reported:** [Date/Time]
**Severity:** [Critical/High/Medium/Low]

---

### Symptom (What You See)

**User-facing symptom:**
[What the user sees/experiences]
Example: "Form submission shows success but data not saved"

**Technical symptom:**
[What the system shows]
Example: "POST /api/save returns 200 but database shows no new row"

**Error messages:**
```
[Exact error text, stack traces, console errors]
```

---

### Environment

**Where it happens:**
- [ ] Development
- [ ] Staging
- [ ] Production
- [ ] Tests

**Browser/Device:**
[Browser version, device type if relevant]

**User context:**
- Logged in: [Yes/No]
- User role: [Role]
- Data state: [What data exists]

---

### Reproduction Steps (MUST BE EXACT)

**Prerequisites:**
1. [Setup needed before starting]
2. [Data that must exist]
3. [State system must be in]

**Steps to reproduce:**
1. [Exact action 1]
2. [Exact action 2]
3. [Exact action 3]
...

**Expected result:**
[What should happen]

**Actual result:**
[What actually happens]

---

### Reproduction Success

**Attempt 1:** [Success/Failure] - [Time: X mins]
**Attempt 2:** [Success/Failure] - [Time: X mins]
**Attempt 3:** [Success/Failure] - [Time: X mins]

**Reproduction rate:** [X/3] = [X%]

**If <100% reproducible:**
- [ ] Identify what varies between attempts
- [ ] Document conditions when it fails vs succeeds
- [ ] Make it more reproducible before continuing

---

### Isolation Test

**Does bug occur in isolation?**
- [ ] Fresh database
- [ ] Cleared browser cache
- [ ] Incognito/private mode
- [ ] Different user account
- [ ] Minimal reproduction case

**Minimal steps needed:**
[Fewest steps that still reproduce bug]

---

### 🚦 GATE: Can you reproduce this reliably (>90%)?

- [ ] YES → Proceed to Phase 2
- [ ] NO → STOP. Make it reproducible first.

**If NO:**
- Document what you know
- Ask for more information
- Try different environment
- Add logging/instrumentation
- Come back when reproducible
```

---

### Phase 2: Hypothesis Formation

**LLM must generate MULTIPLE hypotheses, not just one.**

```markdown
## Hypothesis Generation

### System Components Involved

**Draw the path:** [User action → System response]

Example:
```
User clicks "Save"
  ↓
Button onClick handler
  ↓
Form validation
  ↓
API call to /api/save
  ↓
Server route handler
  ↓
Database insert
  ↓
Response to client
  ↓
UI update
```

**Failure could be at any step.**

---

### Hypothesis List (Brainstorm)

Generate 5-10 possible causes. Don't filter yet.

**Hypothesis 1: [Cause]**
- **Why this might be it:** [Reasoning]
- **Evidence for:** [What supports this]
- **Evidence against:** [What contradicts this]
- **Test:** [How to test this hypothesis]
- **Time to test:** [Estimated minutes]

**Hypothesis 2: [Cause]**
[Same structure]

**Hypothesis 3: [Cause]**
[Same structure]

...

---

### Hypothesis Prioritization

**Order by:**
1. **Likelihood** (how probable)
2. **Impact** (how severe if true)
3. **Test speed** (fastest to test)

**Priority order:**
1. [Hypothesis #X] - Likely + Fast to test
2. [Hypothesis #Y] - Likely + Medium test
3. [Hypothesis #Z] - Less likely + Fast to test
...

---

### 🎯 Starting with Hypothesis: [#X]

**Why test this first:** [Reasoning]

**How to test:** [Specific test plan]

**Expected result if correct:** [What we'll see]

**Expected result if incorrect:** [What we'll see]

**Time budget:** [X minutes]
```

---

### Phase 3: Binary Search Investigation

**Cut the search space in HALF with each test.**

```markdown
## Investigation Log

### Test 1: [Hypothesis Name]

**Time:** [Start time]

**Testing:** [What we're testing]

**Method:** [How we're testing it]

**Prediction if hypothesis correct:** [Expected outcome]

**Prediction if hypothesis incorrect:** [Expected outcome]

---

**Actual result:**
[What actually happened]

**Conclusion:**
- [ ] Hypothesis CONFIRMED (move to Phase 4)
- [ ] Hypothesis REJECTED (search space narrowed)
- [ ] Hypothesis INCONCLUSIVE (need more info)

**If rejected, what we learned:**
[What this rules out]

**New search space:** [What's left to investigate]

**Time spent:** [X minutes]

---

### Test 2: [Next Hypothesis]

[Same structure]

---

## Binary Search Checkpoints

**After each test, ask:**

1. **Did I narrow the search space?**
   - Yes: By how much? [X%]
   - No: Test was not discriminating enough

2. **How many possibilities remain?**
   - [N possibilities left]

3. **What's the next most discriminating test?**
   - [Test that eliminates most possibilities]

4. **Am I going in circles?**
   - Testing same thing different ways?
   - Need to pivot approach?

5. **Should I take a break?**
   - Been investigating >2 hours?
   - Getting frustrated/stuck?
   - Need fresh perspective?
```

---

### Phase 4: Root Cause Identification

**Once you know WHERE the bug is:**

```markdown
## Root Cause Analysis

### The Bug Location

**Component:** [Specific file/function/line]

**The failure:** [Exactly what's failing]

**How I found it:**
1. [Investigation step 1]
2. [Investigation step 2]
3. [Investigation step 3]

---

### Root Cause (The "Why")

**Immediate cause:**
[What directly causes the failure]
Example: "Variable is null when it shouldn't be"

**Why did that happen:**
[One level deeper]
Example: "API returns null when user has no profile"

**Why did THAT happen:**
[One more level]
Example: "New users don't get default profile created"

**True root cause:**
[The real problem]
Example: "Signup flow doesn't call createDefaultProfile()"

---

### The "5 Whys" Analysis

**Problem:** [The symptom]

**Why?** [First answer]
**Why?** [Deeper answer]
**Why?** [Deeper answer]
**Why?** [Deeper answer]
**Why?** [Root cause]

---

### Contributing Factors

**What made this bug possible:**
- [ ] Missing validation
- [ ] Untested code path
- [ ] Incorrect assumption
- [ ] Race condition
- [ ] Missing error handling
- [ ] Documentation gap
- [ ] Deployment issue
- [ ] Configuration error

**Why wasn't this caught earlier:**
[Why tests didn't catch it]

---

### Blast Radius

**What else might be affected:**
- [ ] [Related feature 1]
- [ ] [Related feature 2]
- [ ] [Related feature 3]

**Search for similar patterns:**
```bash
# Search codebase for similar issues
grep -r "similar pattern" .
```

**Found:** [X similar locations]

---

### Impact Assessment

**Users affected:**
- Number: [X users or X%]
- Data loss: [Yes/No - If yes, how much]
- Security impact: [Yes/No - If yes, severity]

**Workaround available:**
- [ ] Yes: [Describe workaround]
- [ ] No: [Critical to fix]

**Time bug existed:**
- Introduced: [Commit/Date if known]
- Duration: [Days/Weeks/Months]
```

---

### Phase 5: Fix Implementation

**Now that you know the root cause:**

```markdown
## Fix Plan

### The Fix (High Level)

**What needs to change:**
[Description of fix]

**Why this fixes the root cause:**
[Explanation]

**Why not just patch the symptom:**
[Why going deeper]

---

### Fix Strategy

**Option A: [Approach 1]**
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]
- **Risk:** [What could go wrong]
- **Effort:** [Time estimate]

**Option B: [Approach 2]**
[Same structure]

**Chosen:** [Option X]
**Why:** [Reasoning]

---

### Pre-Fix Checklist

- [ ] Root cause clearly understood
- [ ] Fix strategy chosen
- [ ] Can reproduce bug reliably (>90%)
- [ ] Have test that fails with bug
- [ ] Know what "fixed" looks like
- [ ] Checked for similar bugs elsewhere
- [ ] Considered impact on other features

---

### Fix Implementation (TDD Style)

**Step 1: Write failing test**
```typescript
test('regression test for [bug]', () => {
  // This test should FAIL before fix
  // This test should PASS after fix
});
```

**Step 2: Implement fix**
[Use your London TDD skill]

**Step 3: Verify test passes**
```bash
npm test -- [test-name]
```

**Step 4: Verify original reproduction fails**
[Go through reproduction steps]

**Step 5: Run full test suite**
```bash
npm test && npx playwright test
```

---

### Verification

**Before fix:**
- [ ] Bug reproduces reliably
- [ ] Test case fails

**After fix:**
- [ ] Bug no longer reproduces
- [ ] Test case passes
- [ ] All other tests pass
- [ ] No new console errors
- [ ] Performance not degraded

**Manual verification:**
- [ ] Original reproduction steps
- [ ] Edge cases
- [ ] Related features still work

**Tested by:** [Your name]
**Date:** [Date]
```

---

### Phase 6: Documentation & Prevention

```markdown
## Bug Resolution Documentation

### Summary (For Future Reference)

**Bug:** [One line description]

**Root cause:** [One line]

**Fix:** [One line]

**Regression test:** [Link to test file]

---

### Timeline

**Reported:** [Date/Time]
**Reproduced:** [Date/Time] - [X hours after report]
**Root cause found:** [Date/Time] - [X hours of investigation]
**Fixed:** [Date/Time] - [X hours to fix]
**Verified:** [Date/Time]

**Total time:** [X hours from report to verified fix]

---

### What We Learned

**Prevention for future:**
- [ ] Add validation at [location]
- [ ] Add test for [scenario]
- [ ] Update docs to clarify [thing]
- [ ] Add monitoring for [metric]
- [ ] Refactor [component] to prevent [issue]

**Process improvements:**
- [ ] [What would have caught this earlier]
- [ ] [What would have prevented this]

---

### Related Issues

**Similar bugs to watch for:**
- [Pattern 1]
- [Pattern 2]

**Technical debt identified:**
- [Debt item 1] - [Priority]
- [Debt item 2] - [Priority]

---

### Commit Message

```
fix: [short description]

Root cause: [One sentence]

The bug occurred because [brief explanation].

Fixed by [what changed].

Regression test: [test file name]

Fixes #[issue number]
```
```

---

## LLM Requirements (CRITICAL)

### "Show Your Work" Protocol

**LLM MUST document reasoning at EVERY step:**

```markdown
## LLM Investigation Journal

### Hypothesis: [What I'm testing]

**Why I think this might be the cause:**
[Reasoning]

**Evidence that supports this:**
1. [Observation 1]
2. [Observation 2]

**Evidence that contradicts this:**
1. [Observation 1]

**How I'll test this:**
[Specific test]

**Prediction:** If this hypothesis is correct, I expect [X]. If incorrect, I expect [Y].

---

### Test Result

**What I did:**
```bash
[Exact command run]
```

**What I observed:**
[Exact output]

**Interpretation:**
[What this means]

**Conclusion:**
- [ ] Hypothesis confirmed
- [ ] Hypothesis rejected
- [ ] Need more data

**If rejected, what I learned:**
[What this rules out]

**Next step:**
[What to test next and why]
```

**LLM CANNOT:**
- ❌ Say "try this" without explaining why
- ❌ Suggest fixes without understanding root cause
- ❌ Skip reproduction step
- ❌ Test only one hypothesis
- ❌ Claim "fixed" without verification

---

## Common Bug Patterns

### Pattern 1: "Works in Dev, Fails in Prod"

**Likely causes (in order):**
1. Environment variable missing/different
2. Database state different
3. Timing/race condition (more load in prod)
4. CORS/security settings
5. Build/bundle issue

**Investigation order:**
```markdown
1. Check environment variables
   - Compare dev vs prod: `env | grep API`
   - Verify all required vars exist

2. Check database state
   - Does test data exist in prod?
   - Schema migrations applied?

3. Check logs
   - What errors appear in prod but not dev?
   - Network requests failing?

4. Reproduce in prod-like environment
   - Can you reproduce locally with prod env vars?
```

---

### Pattern 2: Intermittent/Flaky Failures

**Likely causes:**
1. Race condition
2. Network timing
3. Shared state between tests
4. Random data generation
5. Time-dependent logic

**Investigation:**
```markdown
1. Run test 100 times
   ```bash
   for i in {1..100}; do npm test -- test-name || break; done
   ```
   - Failure rate: [X%]

2. Check for shared state
   - Are tests isolated?
   - Database reset between tests?
   - Singleton instances?

3. Add delays to expose race
   ```typescript
   await sleep(100); // Make race condition more obvious
   ```

4. Check for time dependencies
   - `Date.now()` without mocking?
   - `setTimeout` logic?

5. Add extensive logging
   - Log every state change
   - Find pattern in failures
```

---

### Pattern 3: Performance Degradation

**Likely causes:**
1. N+1 query problem
2. Missing database index
3. Memory leak
4. Unbounded list growth
5. Inefficient algorithm

**Investigation:**
```markdown
1. Profile the slow operation
   ```bash
   # Add timing logs
   console.time('operation');
   // ... code
   console.timeEnd('operation');
   ```

2. Check database queries
   ```sql
   EXPLAIN ANALYZE [your query];
   ```
   - Seq scans? (Need index)
   - High row count?

3. Memory profiling
   - Chrome DevTools memory profiler
   - Check for growing heap

4. Binary search for slowdown
   - Disable half the features
   - Which half is slow?
   - Narrow down

5. Compare to baseline
   - When was it fast?
   - What changed?
   - Git bisect to find commit
```

---

### Pattern 4: "It Was Working Yesterday"

**Investigation:**
```markdown
1. What changed?
   ```bash
   git log --since="yesterday" --oneline
   git diff HEAD~1
   ```

2. Recent deployments
   - Any deploys in last 24 hours?
   - Rollback and test

3. External dependencies
   - API changes from third party?
   - Library updates?
   - Check package-lock.json changes

4. Infrastructure changes
   - Database migration?
   - Environment variable changes?
   - Server updates?

5. Git bisect
   ```bash
   git bisect start
   git bisect bad HEAD
   git bisect good [last-known-good-commit]
   # Test at each step
   ```
```

---

## Debug Tools & Commands

### Browser DevTools

```markdown
## Essential DevTools Workflows

### Network Tab
- Filter: XHR/Fetch only
- Look for: Failed requests (red)
- Check: Request payload vs response
- Verify: Headers (auth, content-type)

### Console Tab
- Clear before reproducing
- Red errors: Click to see stack trace
- Yellow warnings: Often hints to real issue
- Filter by: Error, Warning, Info

### Application Tab
- Check: LocalStorage for state
- Check: Cookies for auth
- Clear: Storage and retry

### Performance Tab
- Record during slow operation
- Look for: Long tasks (>50ms)
- Check: JS execution time
```

---

### Server Debugging

```markdown
## Server-Side Investigation

### Check Logs
```bash
# Vercel logs
vercel logs --follow

# Supabase logs
supabase functions logs function-name

# Filter for errors
grep -i error logs.txt

# Search for specific request
grep "POST /api/split" logs.txt
```

### Database Queries
```bash
# Connect to database
psql postgresql://postgres:postgres@localhost:54322/postgres

# Check query performance
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';

# Check indexes
\d users

# Check table size
SELECT pg_size_pretty(pg_total_relation_size('users'));
```

### API Testing
```bash
# Test endpoint directly
curl -X POST http://localhost:3000/api/split \
  -H "Content-Type: application/json" \
  -d '{"total": 100, "people": 4}'

# With auth
curl -X POST https://yourapp.com/api/split \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"total": 100, "people": 4}'
```
```

---

### Git Archaeology

```markdown
## Finding When Bug Introduced

### Git Bisect (Binary Search in Commits)
```bash
# Start bisect
git bisect start

# Mark current as bad
git bisect bad

# Mark last known good commit
git bisect good v1.2.0

# Git will checkout middle commit
# Test if bug exists
npm test

# If bug exists:
git bisect bad

# If bug doesn't exist:
git bisect good

# Repeat until git finds the commit
# Git will tell you: "X is the first bad commit"
```

### Blame (Who Changed This Line)
```bash
# Who changed this line?
git blame path/to/file.ts

# Detailed view
git blame -L 10,20 path/to/file.ts  # Lines 10-20 only
```

### History of File
```bash
# See all changes to file
git log --follow path/to/file.ts

# See actual changes
git log -p path/to/file.ts
```
```

---

## Debugging Checklist

**Before claiming you understand the bug:**

```markdown
## Understanding Verification

- [ ] I can reproduce the bug >90% of the time
- [ ] I know the EXACT steps to reproduce
- [ ] I've identified the root cause (not just symptom)
- [ ] I can explain WHY the bug happens
- [ ] I know why tests didn't catch it
- [ ] I've checked for similar bugs elsewhere
- [ ] I have a failing test case
- [ ] I know what "fixed" looks like

**If any checkbox is unchecked, keep investigating.**
```

---

## Integration with Other Skills

### How Debug Protocol Works with Your Skills

```markdown
## When Bug Appears During TDD

**Scenario:** Test is failing unexpectedly

1. **Don't immediately fix it** - Understand it first
2. **Run Debug Protocol Phase 1** - Reproduce reliably
3. **Run Phase 2** - Generate hypotheses
4. **Run Phase 3** - Binary search investigation
5. **Once understood** - Continue with TDD GREEN phase

## When Bug Appears in Production

**Scenario:** User reports issue

1. **Interruption Recovery** - Create CHECKPOINT (you're context switching)
2. **Debug Protocol** - Full investigation (all 6 phases)
3. **Thin-Slice** - Fix might reveal need for bigger change
4. **Pre-Flight** - Fix might reveal architecture issue
5. **London TDD** - Implement fix with regression test
6. **Interruption Recovery** - Document for next session

## During 2-Hour Checkpoint

**Check:** Are you debugging? If yes:
- [ ] Are you making progress? (Search space narrowing?)
- [ ] Do you understand root cause yet?
- [ ] Should you take a break? (>2 hours investigating)
- [ ] Should you ask for help? (Stuck on same hypothesis)
```

---

## Anti-Patterns (What NOT To Do)

### ❌ "Let Me Try This"

**Wrong:**
```
LLM: "Try adding await here"
YOU: *adds await*
LLM: "Try changing this to async"
YOU: *changes to async*
LLM: "Try wrapping in try-catch"
YOU: *wraps in try-catch*
```

**Right:**
```
LLM: "I hypothesize the issue is async handling."
LLM: "My reasoning: Error happens before response completes"
LLM: "To test this, I'll add logging before and after await"
LLM: *adds logging*
LLM: "Result: Log shows function returns before await completes"
LLM: "Hypothesis CONFIRMED. Root cause: missing await."
LLM: "Fix: Add await to line 42"
```

---

### ❌ Changing Multiple Things at Once

**Wrong:**
```
- Change API endpoint
- Update validation
- Modify response format
- Change error handling
*Test*
"It works now!" (But which change fixed it?)
```

**Right:**
```
- Change only API endpoint
- Test (doesn't fix)
- Revert
- Change only validation  
- Test (doesn't fix)
- Revert
- Change only response format
- Test (FIXES IT!)
- Now we know which change worked
```

---

### ❌ "Works For Me" Syndrome

**Wrong:**
```
LLM: "I can't reproduce the bug. Maybe it's fixed?"
YOU: "Ship it"
```

**Right:**
```
LLM: "I can't reproduce yet. Let me:"
1. Try user's exact environment
2. Check what's different in my setup
3. Ask for more reproduction details
4. Add instrumentation to understand
5. Only claim fixed after reproducing AND verifying fix
```

---

### ❌ Symptom Patching

**Wrong:**
```
Bug: Error "Cannot read property 'name' of null"
Fix: if (user) { user.name }
```

**Right:**
```
Investigation: WHY is user null?
Root cause: API returns null for new users
Real fix: Create default user object in signup
Plus: Add validation earlier in chain
Plus: Add test for new user case
```

---

## Emergency Procedures

### Stuck After 2 Hours

**Symptoms:**
- Testing same hypotheses repeatedly
- Not narrowing search space
- Getting frustrated

**Action:**
1. **STOP debugging**
2. **Document current state:**
   ```markdown
   ## Investigation Stuck Point
   
   **What I know:**
   - [Facts discovered]
   
   **What I've ruled out:**
   - [Hypotheses rejected]
   
   **What I'm stuck on:**
   - [Current confusion]
   
   **What I need:**
   - [ ] Fresh perspective (take break)
   - [ ] More information (add logging)
   - [ ] Help from others (ask colleague)
   - [ ] Different approach (try something radical)
   ```
3. **Take 30-min break**
4. **Return with fresh eyes**
5. **If still stuck, ask for help**

---

### Production Fire (Critical Bug)

**Symptoms:**
- Users can't complete critical flow
- Data loss happening
- Security issue

**Action:**
1. **IMMEDIATE: Rollback or hotfix**
   ```bash
   # Rollback last deploy
   vercel rollback
   
   # OR apply quick hotfix
   git revert [bad-commit]
   git push
   ```

2. **THEN: Investigate properly**
   - Don't skip debug protocol because it's urgent
   - Urgent bugs need MORE rigor, not less
   - Quick fix might introduce worse bug

3. **Document incident:**
   ```markdown
   ## Production Incident
   
   **Start:** [Time]
   **End:** [Time]
   **Impact:** [Users affected]
   **Immediate action:** [Rollback/hotfix]
   **Root cause:** [TBD - investigate properly]
   **Prevention:** [TBD - after investigation]
   ```

---

## Success Criteria

**This skill is working when:**
- ✅ Bugs reproduced before fixing attempted
- ✅ Root cause understood before fix implemented
- ✅ Multiple hypotheses tested
- ✅ Investigation documented (can resume later)
- ✅ Regression tests added
- ✅ Similar bugs caught proactively
- ✅ "Why" understood, not just "where"

**This skill is failing when:**
- ❌ "Try this" without understanding
- ❌ Random changes hoping something works
- ❌ Same bug reappears later
- ❌ Can't explain why fix works
- ❌ No regression test added
- ❌ Breaking other things while fixing
- ❌ Stuck investigating >4 hours

---

## Quick Reference

```
╔════════════════════════════════════════╗
║      DEBUG PROTOCOL QUICK REF         ║
╚════════════════════════════════════════╝

PHASE 1: REPRODUCE (Don't skip!)
□ Exact steps to reproduce
□ >90% reproduction rate
□ Minimal reproduction case
□ Document environment

PHASE 2: HYPOTHESIZE
□ Generate 5-10 hypotheses
□ Prioritize by likelihood + test speed
□ Document reasoning for each

PHASE 3: INVESTIGATE (Binary Search)
□ Test most discriminating hypothesis
□ Narrow search space by 50%
□ Document each test + result
□ Stop after 2 hours if stuck

PHASE 4: ROOT CAUSE
□ Know WHERE bug is
□ Know WHY bug happens
□ 5 Whys analysis
□ Check for similar bugs

PHASE 5: FIX
□ Write failing test first
□ Implement fix
□ Verify original reproduction fails
□ All tests pass

PHASE 6: PREVENT
□ Regression test added
□ Documentation updated
□ Similar patterns checked
□ Lessons learned documented

LLM MUST:
✓ Show reasoning at each step
✓ Test hypotheses, not fixes
✓ Document investigation
✓ Reproduce before claiming fixed

NEVER:
✗ "Try this" without why
✗ Change multiple things at once
✗ Skip reproduction
✗ Patch symptoms vs root cause
```

---

## Debugging Session Template

**Use this for each bug investigation:**

```markdown
# Debug Session: [Bug Name]

**Started:** [Time]
**Status:** [Investigating/Blocked/Fixed]

---

## Phase 1: Reproduction ✅/⏳/❌

**Reproduction rate:** [X%]
**Minimal steps:** [Listed]
**Environment:** [Documented]

---

## Phase 2: Hypotheses ✅/⏳/❌

**Generated:** [X hypotheses]
**Testing:** [Hypothesis #N]

---

## Phase 3: Investigation ✅/⏳/❌

**Tests completed:** [N]
**Search space remaining:** [X%]
**Time invested:** [X hours]

---

## Phase 4: Root Cause ✅/⏳/❌

**Location:** [File/Line]
**Cause:** [Explanation]
**Why:** [5 Whys completed]

---

## Phase 5: Fix ✅/⏳/❌

**Test written:** [Yes/No]
**Fix implemented:** [Yes/No]
**Verified:** [Yes/No]

---

## Phase 6: Prevention ✅/⏳/❌

**Regression test:** [Link]
**Documentation:** [Updated]
**Similar bugs:** [Checked]

---

## Time Tracking

- Reproduction: [X mins]
- Investigation: [X mins]
- Fix: [X mins]
- Verification: [X mins]
**Total:** [X mins]

---

## Next Actions (If Interrupted)

1. [Resume at Phase X]
2. [Test hypothesis Y]
3. [Check for Z]
```

---

## Next Actions

1. **Add to workflow** - Use when bugs appear
2. **Create debug-logs folder** - Store investigation docs
3. **Practice on next bug** - Follow protocol strictly
4. **Track time to resolution** - Measure improvement

---

**Remember:**
> "Everyone knows that debugging is twice as hard as writing a program in the first place." - Brian Kernighan

**Current Priority:**
> Reproduce reliably. Understand deeply. Fix confidently.
