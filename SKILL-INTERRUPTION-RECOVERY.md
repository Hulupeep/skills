---
name: Interruption Recovery Protocol
description: Preserves context during hyperfocus sessions and enables fast resumption after interruptions. Designed for 2-4 hour work windows with automatic checkpoints. Use this to never lose context when switching focus.
---

# Interruption Recovery Protocol

## Core Philosophy
**YOUR BRAIN DOESN'T NEED TO REMEMBER. THE SYSTEM DOES.**

Hyperfocus is powerful but fragile. Interruptions happen. Context is lost. This skill creates automatic context preservation so:
1. You can hyperfocus without worrying about forgetting
2. Interruptions don't destroy progress
3. Resuming work takes <5 minutes, not hours
4. Future you knows exactly what past you was thinking

**This prevents:**
- ❌ "Where was I?" confusion after interruptions
- ❌ Re-reading entire codebase to remember context
- ❌ Lost architectural decisions
- ❌ Forgotten "why" behind code choices
- ❌ Abandoned projects because too hard to resume

**Design for:**
- ✅ 2-4 hour hyperfocus windows
- ✅ Non-linear thinking patterns
- ✅ Context switching between projects
- ✅ Weeks/months between work sessions

---

## When to Use This Skill

**ALWAYS use when:**
- Starting a hyperfocus session
- Every 2 hours during work
- Before any interruption (lunch, meeting, end of day)
- When losing focus/getting distracted
- Switching to different project

**DO NOT skip checkpoints. They're your insurance policy.**

---

## The Checkpoint System

### Three Types of Checkpoints

```markdown
┌─────────────────────────────────────────┐
│ 1. SESSION START (5 mins)              │
│    Read context, verify what works      │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ 2. MICRO CHECKPOINT (2 mins @ 2hrs)    │
│    Save state, check for drift          │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ 3. SESSION END (10 mins @ 4hrs)        │
│    Full context dump, next actions      │
└─────────────────────────────────────────┘
```

---

## Checkpoint 1: Session Start Protocol

**BEFORE writing any code, run this protocol:**

### File: `RESUME.md` (check if exists)

**If file exists:**

```markdown
# ✅ SESSION START: [Current Date/Time]

## Last Session Context
**Date:** [From RESUME.md]
**Duration:** [How long ago]

## Reading Last Session Notes
- [ ] Read "What's Working" section
- [ ] Read "What's Broken" section  
- [ ] Read "Next Action" (this is what I'll do first)
- [ ] Read "Architecture Decisions"

## Verification (DON'T TRUST PAST YOU)
- [ ] Run tests: `npm test && npx playwright test`
- [ ] Start dev server: `npm run dev`
- [ ] Check claimed "working" features actually work
- [ ] Check claimed "broken" items are actually broken

## Test Results
**Tests:** [X passing / Y failing]
**Dev server:** [Working / Errors]
**Features verified:** [List what you checked]

## Discrepancies Found
[Anything that doesn't match last session notes?]

## Actual Current State
**What's ACTUALLY working:**
- [Verified working feature 1]
- [Verified working feature 2]

**What's ACTUALLY broken:**
- [Actual bug 1]
- [Actual bug 2]

## Next Action (From Last Session)
[Copy from RESUME.md]

**Estimated time:** [X mins]

**Starting now:** [Time]
**Expected done:** [Time + X mins]

---

## LLM Instructions for This Session

**Context loaded from:** RESUME.md
**Current focus:** [Next action from RESUME.md]

**CRITICAL RULES:**
1. Do ONLY the next action listed
2. No feature creep
3. No "while I'm here" changes
4. Set timer for 2 hours (micro checkpoint)
5. If blocked on next action, document why and move to backup action

**Timer set:** 2 hours from [current time]
```

**If NO RESUME.md exists (new project/session):**

```markdown
# 🆕 SESSION START: [Date/Time]

## New Session

**Project:** [Name]
**Goal:** [What I'm trying to achieve today]

## Pre-Work Checklist
- [ ] Thin-Slice defined (if new feature)
- [ ] Pre-Flight decisions made (if new feature)
- [ ] TODO.md created/updated
- [ ] Tests are green (if existing project)
- [ ] Dev environment running

## Starting Context
**What I know:**
[What I'm starting with - even if it's just an idea]

**First task:**
[What I'll do first]

**Time budget:** [X hours]

**Timer set:** 2 hours from [current time]
```

---

## Checkpoint 2: 2-Hour Micro Checkpoint

**LLM must run this automatically after 2 hours of work:**

### File: `CHECKPOINT-[timestamp].md`

```markdown
# ⏱️ 2-HOUR CHECKPOINT: [Date/Time]

## Session Stats
**Started:** [Time]
**Now:** [Time]  
**Duration:** 2 hours
**Next checkpoint:** 2 hours from now OR end session

---

## What I Built (Last 2 Hours)

**Files changed:**
- [file1] - [what changed]
- [file2] - [what changed]

**Lines of code:** ~[X lines]

**Features added:**
- [Feature 1] - [status: working/in-progress/broken]
- [Feature 2] - [status]

**Tests written:**
- [X] [Test description] - [passing/failing]
- [X] [Test description] - [passing/failing]

---

## Current State

**Tests:** [X passing / Y failing]
**Console errors:** [X errors]
**Build status:** [Clean / Warnings / Errors]

**What's working:**
- [Working feature 1] - verified by [test name]
- [Working feature 2] - verified by [test name]

**What's broken:**
- [Bug 1] - [specific error message]
- [Bug 2] - [specific error message]

---

## Architecture Decisions (Last 2 Hours)

**Decisions made:**
1. [Decision] - WHY: [reason] - ALTERNATIVE: [what I didn't choose]
2. [Decision] - WHY: [reason] - TRADE-OFF: [what we gave up]

**Tech debt incurred:**
- [Debt 1] - [why it's OK for now] - [when to fix]
- [Debt 2] - [why it's OK for now] - [when to fix]

---

## Smell Detection

**Checking for architectural drift:**

- [ ] **Prop drilling >2 levels?**
  - Found: [Yes/No]
  - If YES: [Should refactor to Zustand - add to tech debt]

- [ ] **Duplicate code >3 places?**
  - Found: [Yes/No]
  - If YES: [Extract to shared function - add to tech debt]

- [ ] **Same API call >2 components?**
  - Found: [Yes/No]
  - If YES: [Should use React Query - add to tech debt]

- [ ] **Hard to test?**
  - Found: [Yes/No]
  - If YES: [Architecture issue - consider refactor]

- [ ] **File >300 lines?**
  - Found: [Yes/No]
  - If YES: [Split into smaller files - add to tech debt]

- [ ] **Function >50 lines?**
  - Found: [Yes/No]
  - If YES: [Extract helper functions - add to tech debt]

**🚨 IF ANY SMELL FOUND:**
- [ ] Document in tech debt
- [ ] Decide: Fix now OR fix later?
- [ ] If fix now: Stop feature work, refactor (tests must stay green)
- [ ] If fix later: Add to TODO.md with "WHY OK for now"

---

## Scope Creep Check

**Original plan (from session start):**
[Copy original next action]

**What I actually built:**
[What you built]

**Did I stay on track?**
- [ ] Built only what was planned
- [ ] No "while I'm here" features
- [ ] No premature optimization
- [ ] Stuck to thin-slice definition

**🚨 IF OFF TRACK:**
- What feature crept in: [Feature]
- Why: [Reason]
- Worth it? [Yes/No]
- If No: Revert and stick to plan

---

## Energy & Focus Check

**Current energy:** [High / Medium / Low]
**Current focus:** [Sharp / Fuzzy / Scattered]

**If energy LOW or focus SCATTERED:**
- [ ] Take 10 min break
- [ ] Come back for final 2 hour push
- [ ] OR run Session End checkpoint and stop

**If energy HIGH and focus SHARP:**
- [ ] Continue for 2 more hours
- [ ] Set timer for next checkpoint

---

## Next Actions (Next 2 Hours)

**Based on current state, next actions are:**

1. **[Action 1]** - [30 mins]
   - WHY: [Reason]
   - OUTCOME: [What will be done]
   - TEST: [How to verify]

2. **[Action 2]** - [45 mins]
   - WHY: [Reason]
   - OUTCOME: [What will be done]
   - TEST: [How to verify]

3. **[Action 3]** - [45 mins]
   - WHY: [Reason]
   - OUTCOME: [What will be done]
   - TEST: [How to verify]

**Backup action (if blocked):**
- [Alternative task if main actions are blocked]

---

## Commit Checkpoint

**Before continuing:**
- [ ] Commit current work: `git add . && git commit -m "checkpoint: [summary]"`
- [ ] Update TODO.md with progress
- [ ] Save this checkpoint file

**Timer reset:** 2 hours from [current time]
**Expected next checkpoint:** [Time + 2 hours]

---

## 🎯 RESUMING FROM HERE

**If interrupted before next checkpoint, read:**
1. This checkpoint file (you are here)
2. "Next Actions" section above
3. Verify tests still pass
4. Execute Action #1
```

---

## Checkpoint 3: Session End Protocol (4-Hour Hard Stop)

**LLM must FORCE this after 4 hours total work time:**

### File: `RESUME.md` (overwrites previous)

```markdown
# 🛑 SESSION END: [Date/Time]

**⚠️ HYPERFOCUS LIMIT REACHED: 4 HOURS ⚠️**

## Session Summary

**Started:** [Time]
**Ended:** [Time]
**Duration:** 4 hours

**Micro checkpoints:**
- [Link to CHECKPOINT-timestamp1.md]
- [Link to CHECKPOINT-timestamp2.md]

---

## What Was Accomplished

### Features Completed
- [x] [Feature 1] - [What it does] - [Link to test]
- [x] [Feature 2] - [What it does] - [Link to test]

### Features In Progress
- [ ] [Feature 3] - [Status: 60% done] - [What's left]

### Bugs Fixed
- [x] [Bug 1] - [What the fix was]

### Bugs Discovered
- [ ] [Bug 1] - [Description] - [Error message]

---

## Current State (VERIFIED)

### What's Working
**Feature:** [Feature name]
- **Works:** [Specific user flow that works]
- **Verified by:** [Test name or manual check]
- **Try it:** [How to see it working]

**Feature:** [Feature name]
- **Works:** [Specific user flow that works]
- **Verified by:** [Test name or manual check]
- **Try it:** [How to see it working]

### What's NOT Working
**Bug:** [Bug description]
- **Symptom:** [What user sees]
- **Error:** [Technical error message]
- **Reproduce:** [Steps to reproduce]
- **Impact:** [High/Medium/Low]

**Known limitation:** [Limitation]
- **Why:** [Reason it's not built yet]
- **Workaround:** [How to work around it]

### Tests
**Passing:** [X / Y]
**Failing:** [Test names that fail]

**Run tests:**
```bash
npm test && npx playwright test
```

**Expected result:** [X passing, Y failing]

---

## Architecture Decisions Made

### Decision 1: [Decision Name]
**What:** [What we chose]
**Why:** [Reasoning]
**Alternatives considered:**
- [Alt 1] - Rejected because [reason]
- [Alt 2] - Rejected because [reason]

**Trade-offs accepted:**
- [Trade-off 1] - OK because [reason]
- [Trade-off 2] - OK because [reason]

**Revisit if:** [Conditions that would make us reconsider]

**Date:** [Date]
**Reference:** [Link to pre-flight doc]

### Decision 2: [Decision Name]
[Same structure]

---

## Tech Debt Registry

**Debt 1: [Description]**
- **Why it exists:** [Reason we took shortcut]
- **Impact:** [What it affects]
- **Fix effort:** [Estimated time]
- **Fix when:** [Condition that triggers fix]
- **OK because:** [Why it's acceptable for now]

**Debt 2: [Description]**
[Same structure]

---

## Mental Model (The "Why" Behind Code)

**This section captures thinking that's not in the code:**

### How It Works (High Level)
[Explain the system in 3-4 sentences like you're explaining to future you who forgot everything]

### Key Insights
- [Insight 1] - [Why this matters]
- [Insight 2] - [Why this matters]

### Non-Obvious Patterns
- [Pattern 1] - [Where used] - [Why we do it this way]
- [Pattern 2] - [Where used] - [Why we do it this way]

### Gotchas
- [Gotcha 1] - [Why it's tricky] - [How to handle]
- [Gotcha 2] - [Why it's tricky] - [How to handle]

### Things That Seem Wrong But Aren't
- [Thing 1] - [Why it looks wrong] - [Why it's actually correct]

---

## Next Session: DO THIS FIRST

### Immediate Next Action (30 mins)
**Task:** [Specific, concrete task]

**Why this:** [Why this is the right next step]

**How to do it:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**You'll know it's done when:**
- [ ] [Success criterion 1]
- [ ] [Success criterion 2]

**Test:** [How to verify it worked]

### Backup Action (if blocked)
**If main action is blocked by [blocker], do this instead:**
[Alternative task]

### After That (Next 3 Actions)
1. [Action 2] - 45 mins - [Why] - [Outcome]
2. [Action 3] - 1 hour - [Why] - [Outcome]
3. [Action 4] - 45 mins - [Why] - [Outcome]

---

## Session Start Checklist (Copy This on Resume)

**When you return to this project:**

- [ ] Read this RESUME.md file completely (10 mins)
- [ ] Don't trust memory - verify "What's Working" section
- [ ] Run tests: `npm test && npx playwright test`
- [ ] Start dev: `npm run dev`
- [ ] Check "What's NOT Working" - still broken?
- [ ] Review "Architecture Decisions" - remember why?
- [ ] Do "Immediate Next Action" - nothing else
- [ ] Set 2-hour timer for micro checkpoint

**⏱️ Time to resume and be productive: <15 minutes**

---

## Emergency Info (If Stuck)

### Where to Look
- **TODO.md** - Original plan, what we're building
- **Pre-flight decision:** [Link to file]
- **Thin-slice definition:** [Link to file]
- **Last 3 commits:** `git log --oneline -3`
- **Micro checkpoints:** [Links to CHECKPOINT files]

### Common Questions

**Q: What was I building?**
A: [One sentence summary]

**Q: Why did I choose [technology]?**
A: [Reason - link to pre-flight decision]

**Q: What's the immediate priority?**
A: [See "Immediate Next Action" above]

**Q: Why is [code] structured this way?**
A: [See "Mental Model" section above]

---

## Session Stats

**Total time:** 4 hours
**Features completed:** [X]
**Tests written:** [Y]
**Commits made:** [Z]
**LOC added:** ~[N]

**Effectiveness score:** [How did it go? 1-10]
**Energy level end:** [High/Medium/Low]
**Focus level end:** [Sharp/Fuzzy/Scattered]

---

## Final Commit

**Before closing:**
```bash
# Commit all work
git add . TODO.md RESUME.md
git commit -m "session end: [summary of what was accomplished]"

# Push if working branch
git push origin [branch]
```

**Status:** [Committed / Pushed]

---

## 🚦 TRAFFIC LIGHT: Project Health

**🟢 GREEN - Healthy**
- All tests passing
- Core flow working
- Clear next steps
- No blocking issues

**🟡 YELLOW - Caution**  
- Some tests failing (but not critical path)
- Minor bugs present
- Architecture smells detected
- Should address before adding features

**🔴 RED - Blocked**
- Critical tests failing
- Core flow broken
- Blocking technical decision needed
- Should fix before continuing

**Current status:** [Green/Yellow/Red]

**If Yellow/Red:** [What needs to be fixed first]

---

## Context for Future You

**When you come back to this in [days/weeks]:**

You were [describe mental state, approach, thinking].

The goal was [original goal].

You got [this far] and the main challenge was [challenge].

The approach is working / not working because [reason].

Next session should focus on [focus area].

Don't forget: [Important thing to remember].

---

**Last updated:** [Timestamp]
**Next session:** TBD
**Status:** Ready to resume ✅
```

---

## Integration with Other Skills

### How All 3 Skills Work Together

```markdown
## Session Structure

### BEFORE SESSION (15 mins)
1. **Interruption Recovery (Skill #3):** Run Session Start
   - Read RESUME.md
   - Verify what's working
   - Load mental context

### START OF FEATURE (30 mins)
2. **Thin-Slice (Skill #2):** Define what to build
   - One flow only
   - Hardcode plan
   - Success metrics

3. **Pre-Flight (Skill #1):** Choose architecture
   - Present options
   - Make decision
   - Write integration test

### DURING WORK (2 hours)
4. **TDD (existing):** Build the feature
   - RED → GREEN → REFACTOR
   - Small commits

5. **Interruption Recovery (Skill #3):** 2-Hour Checkpoint
   - Save state
   - Check for drift
   - Plan next 2 hours

### DURING WORK (2 more hours)
6. Continue building
7. Another 2-Hour Checkpoint

### END OF SESSION (10 mins)
8. **Interruption Recovery (Skill #3):** Session End
   - Full context dump
   - Next actions defined
   - Ready to resume
```

---

## File Structure

**Your project should have:**

```
project/
├── TODO.md                  # Overall plan (Thin-Slice)
├── RESUME.md               # Latest session end (Interruption Recovery)
├── CHECKPOINT-*.md         # 2-hour checkpoints
├── decisions/
│   ├── preflight-*.md     # Architecture decisions (Pre-Flight)
│   └── adr-*.md           # Architecture Decision Records
└── session-notes/
    └── YYYY-MM-DD.md      # Daily notes (optional)
```

---

## Automation Helpers

### Timer Script

```bash
#!/bin/bash
# checkpoint-timer.sh
# Run at session start

echo "⏱️  2-hour checkpoint timer started"
echo "Session started: $(date)"

# Wait 2 hours
sleep 7200

# Alert
echo "🔔 CHECKPOINT TIME!"
echo "Run: npm run checkpoint"
osascript -e 'display notification "Time for 2-hour checkpoint!" with title "Hyperfocus Timer"'
```

### Checkpoint Command

Add to `package.json`:

```json
{
  "scripts": {
    "checkpoint": "node scripts/checkpoint.js",
    "session:start": "node scripts/session-start.js",
    "session:end": "node scripts/session-end.js"
  }
}
```

---

## Common Patterns

### Resuming After 1 Day

**Fast path:** (15 mins)
1. Read RESUME.md (10 mins)
2. Run tests (2 mins)
3. Start next action (immediately)

**Slow path - don't do this:**
1. ❌ Try to remember what you were doing
2. ❌ Re-read all the code
3. ❌ Start random task
4. ❌ Get overwhelmed

### Resuming After 1 Week

**Fast path:** (30 mins)
1. Read RESUME.md (15 mins)
2. Run tests + verify features (10 mins)
3. Read "Mental Model" section (5 mins)
4. Start next action

### Resuming After 1 Month+

**Fast path:** (1 hour)
1. Read RESUME.md completely (20 mins)
2. Read last 2-3 CHECKPOINT files (20 mins)
3. Run tests + manually verify everything (15 mins)
4. Read pre-flight decisions (5 mins)
5. Start next action

**Still faster than:** Re-reading entire codebase (4+ hours)

---

## Anti-Patterns

### ❌ "I'll remember this"

**Wrong:** Thinking you'll remember context

**Right:** Writing it down immediately

**Cost of wrong:** 1-2 hours lost figuring out where you were

### ❌ Skipping checkpoints "to keep momentum"

**Wrong:** "I'm in flow, don't want to stop"

**Right:** 2-min checkpoint doesn't break flow, losing all context does

**Cost of wrong:** Lost all progress if interrupted

### ❌ Vague next actions

**Wrong:** "Continue working on feature"

**Right:** "Add email validation to signup form - verify with test"

**Cost of wrong:** 30 mins figuring out what "continue" means

### ❌ Not verifying on resume

**Wrong:** Trust that RESUME.md is accurate

**Right:** Run tests, verify features work

**Cost of wrong:** Building on broken foundation

---

## Emergency Procedures

### Lost Context (No RESUME.md)

**If you return and have no context:**

1. **Don't panic**
2. Check git history:
   ```bash
   git log --oneline -10
   git show HEAD  # See last commit
   ```
3. Look at TODO.md if it exists
4. Run tests - what passes tells you what works
5. Create new RESUME.md from current state:
   - "Current state: [what tests pass]"
   - "Next action: [smallest thing to verify]"

### Interruption Mid-Task

**If interrupted in middle of something:**

Quick save (2 mins):
```bash
# Save work in progress
git add .
git commit -m "WIP: [what you were doing]"

# Quick note
echo "Mid-task: [what you were doing]" >> RESUME.md
echo "Next: [literal next step]" >> RESUME.md
```

### Context Switching

**If need to switch projects:**

1. Run session end checkpoint (10 mins)
2. Commit everything
3. Add to calendar: "Resume [project] - read RESUME.md"
4. Switch to new project
5. Run session start on new project

---

## Success Criteria

**This skill is working when:**
- ✅ Resume from interruption in <15 minutes
- ✅ No "where was I?" confusion
- ✅ Tests verify what's working
- ✅ Next action is always clear
- ✅ Architecture decisions remembered
- ✅ Can resume after weeks/months
- ✅ 2-hour checkpoints happen automatically

**This skill is failing when:**
- ❌ Spend >30 mins figuring out where you were
- ❌ Re-reading entire codebase to remember
- ❌ Can't remember why you made decisions
- ❌ Interruptions cause panic
- ❌ Abandoned projects due to lost context
- ❌ Skipping checkpoints

---

## Metrics to Track

**Track these over time:**

```markdown
## Recovery Time Tracking

| Date | Time Away | Recovery Time | Worked? |
|------|-----------|---------------|---------|
| 2025-01-15 | 2 days | 12 mins | ✅ |
| 2025-01-20 | 5 days | 25 mins | ✅ |
| 2025-02-01 | 2 weeks | 45 mins | ⚠️ |
| 2025-03-15 | 6 weeks | 90 mins | ❌ |

**Goal:** <15 mins for <1 week away
**Acceptable:** <30 mins for 1-2 weeks away
**Needs improvement:** >30 mins recovery time

**Actions to improve:**
- Better next action specificity
- More detail in mental model
- Verify more thoroughly before stopping
```

---

## Quick Reference Card

**Print and keep visible:**

```
╔════════════════════════════════════════╗
║   INTERRUPTION RECOVERY QUICK REF     ║
╚════════════════════════════════════════╝

SESSION START (Every time)
□ Read RESUME.md (10 mins)
□ Run tests (don't trust notes)
□ Do immediate next action only
□ Set 2-hour timer

2-HOUR CHECKPOINT (Every 2 hours)
□ Save work (commit)
□ What's working? What's broken?
□ Check for architecture smells
□ Define next 2-hour actions
□ Reset timer

4-HOUR HARD STOP (End of session)
□ Run session end protocol (10 mins)
□ Update RESUME.md
□ Define next action (specific!)
□ Commit everything
□ Walk away

RESUME AFTER TIME AWAY
1 day:  Read RESUME.md (10 min)
1 week: Read RESUME.md + verify (20 min)
1 month: Read RESUME.md + checkpoints (45 min)

NEVER:
✗ Skip checkpoints
✗ Trust memory
✗ Vague next actions
✗ Work past 4 hours

ALWAYS:
✓ Write everything down
✓ Verify on resume
✓ Specific next actions
✓ Take breaks
```

---

## Next Actions

1. **Print quick reference card** (5 mins)
2. **Add to your workflow** (integrate with TDD skill)
3. **Try in Penny project** (test all 3 skills together)
4. **Track recovery times** (measure improvement)

---

**Remember:**
> "Your brain is for having ideas, not storing them." - David Allen

**Current Priority:**
> Checkpoint every 2 hours. Future you will thank present you.
