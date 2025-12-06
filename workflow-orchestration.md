---
name: Web Dev Workflow Orchestrator
description: Meta-skill that coordinates 7 specialized skills for full-stack web development with neurodivergent-optimized workflows. Manages thin-slice MVPs, TDD, database design, API contracts, debugging, and context preservation across hyperfocus sessions.
---

# Web Development Workflow Orchestrator

## Core Philosophy
**SHIP WORKING CODE EVERY 2-4 HOURS. NEVER LOSE CONTEXT.**

This orchestrator manages 7 specialized skills:

## 🎯 The Workflow Decision Tree
```
NEW WORK SESSION
│
├─> Read RESUME.md (Interruption Recovery)
│   └─> Load context from last session
│
├─> NEW FEATURE?
│   │
│   ├─> Step 1: THIN-SLICE MVP
│   │   └─> Define: What's the ONE flow to prove?
│   │   └─> Gate: Can build in 2-4 hours?
│   │
│   ├─> Step 2: DATABASE DESIGN (if needs DB)
│   │   └─> Define queries FIRST
│   │   └─> Design minimal schema
│   │   └─> Add indexes
│   │   └─> Gate: Performance <50ms?
│   │
│   ├─> Step 3: API-FIRST DESIGN (if needs API)
│   │   └─> Write OpenAPI contract
│   │   └─> Generate types
│   │   └─> Write contract tests
│   │   └─> Gate: Tests failing?
│   │
│   ├─> Step 4: PRE-FLIGHT ARCHITECTURE
│   │   └─> Present 3+ architecture options
│   │   └─> Human chooses
│   │   └─> Write integration test
│   │   └─> Gate: Test proves architecture works?
│   │
│   └─> Step 5: LONDON TDD
│       └─> RED: Write failing Playwright test
│       └─> GREEN: Implement minimal solution
│       └─> REFACTOR: Clean up (only if tests green)
│       └─> Gate: All tests passing?
│
├─> BUG APPEARS?
│   └─> DEBUG PROTOCOL
│       └─> Phase 1: Reproduce reliably (>90%)
│       └─> Phase 2: Generate 5+ hypotheses
│       └─> Phase 3: Binary search investigation
│       └─> Phase 4: Identify root cause
│       └─> Phase 5: Fix with regression test
│       └─> Phase 6: Document & prevent
│       └─> Gate: Bug no longer reproduces?
│
└─> EVERY 2 HOURS (MANDATORY)
    └─> INTERRUPTION RECOVERY: 2-Hour Checkpoint
        ├─> What did I build?
        ├─> Architecture smell check
        ├─> Scope creep check
        ├─> Energy/focus check
        ├─> Commit checkpoint
        └─> Define next 2-hour actions
```

## 🚦 Checkpoint Gates (CANNOT SKIP)

### Gate 1: Session Start (5 mins)
```markdown
- [ ] Read RESUME.md
- [ ] Verify tests still pass
- [ ] Load TODO.md
- [ ] Set 2-hour timer
```

### Gate 2: 2-Hour Checkpoint (2 mins)
```markdown
- [ ] Commit work
- [ ] Check for smells (arch, scope, database)
- [ ] Update TODO.md
- [ ] Define next 2-hour actions
- [ ] Reset timer
```

### Gate 3: 4-Hour Hard Stop (10 mins)
```markdown
- [ ] Run session end protocol
- [ ] Update RESUME.md
- [ ] Push commits
- [ ] Walk away (hyperfocus limit reached)
```

## 🔥 Emergency Procedures

### "Tests Are Failing"
1. DON'T refactor
2. DON'T add features
3. READ: debug-protocol skill
4. Fix tests FIRST
5. Then resume workflow

### "Lost Context"
1. READ: RESUME.md
2. READ: last CHECKPOINT-*.md
3. Run tests to see what works
4. Start from "Current State" in RESUME.md

### "Stuck >1 Hour"
1. STOP coding
2. Document stuck point
3. Take 30-min break
4. Return with fresh eyes
5. If still stuck, ask for help

### "Scope Creep Detected"
1. STOP coding
2. READ: original thin-slice definition
3. Revert "nice to have" features
4. Ship what's planned
5. Add extras to "Next Slice"

## 📋 LLM Requirements (CRITICAL)

### Before Starting ANY Code:

1. **Read relevant skills:**
```
   - Starting new feature? Read: thin-slice, preflight, database (if DB)
   - Implementing? Read: london-tdd, api-first (if API)
   - Debugging? Read: debug-protocol
   - Any work? Read: interruption-recovery
```

2. **Ask decision questions:**
```
   - What's the thinnest possible slice?
   - What can I hardcode?
   - What architecture options exist?
   - What queries will I run? (if database)
   - What's the API contract? (if API)
```

3. **Wait for human decisions:**
   - ❌ CANNOT choose architecture alone
   - ❌ CANNOT define scope alone
   - ✅ CAN present options
   - ✅ CAN recommend based on context

### During Implementation:

1. **Show reasoning at each step**
2. **Run tests after EVERY change**
3. **Commit frequently (every 15-30 mins)**
4. **Check for smells at 2-hour checkpoint**
5. **NEVER skip gates**

### At Checkpoints:

1. **Run smell detection** (architecture, database, scope)
2. **Document investigation** (if debugging)
3. **Update context files** (TODO.md, CHECKPOINT-*.md)
4. **Verify time budget** (staying in 2-4 hour window)

## 🎓 Skill Integration Examples

### Example 1: Building User Authentication
```markdown
SESSION START (5 mins)
└─> Read RESUME.md
└─> Load context: "Next: Add user auth"

THIN-SLICE (15 mins)
└─> ONE flow: Login with email/password
└─> REAL: Email input, password input, submit button
└─> FAKE: No signup, no password reset, one hardcoded user
└─> MISSING: OAuth, 2FA, email verification
└─> Time budget: 3 hours

DATABASE DESIGN (20 mins)
└─> Query: SELECT * FROM users WHERE email = ?
└─> Schema: users(id, email, password_hash, created_at)
└─> Index: CREATE INDEX idx_users_email ON users(email)
└─> Test: 10k users, query <10ms ✅

PRE-FLIGHT (30 mins)
└─> Option A: Supabase Auth (recommended)
└─> Option B: NextAuth.js
└─> Option C: Manual JWT
└─> Decision: Supabase Auth
└─> Why: Integrated with our stack, handles security

LONDON TDD (2 hours)
└─> RED: Write failing Playwright test for login flow
└─> GREEN: Implement with Supabase Auth
└─> REFACTOR: Extract useAuth hook
└─> All tests passing ✅

2-HOUR CHECKPOINT (2 mins)
└─> Built: Login form + Supabase integration
└─> Smells: None detected
└─> Scope: Stayed on track (no signup added)
└─> Next: Add protected route middleware

CONTINUE (1 hour)
└─> Build route protection
└─> Tests still passing ✅

4-HOUR HARD STOP (10 mins)
└─> Update RESUME.md
└─> Commit: "feat: add user login with Supabase"
└─> Next session: Add signup flow
└─> Walk away
```

### Example 2: Debugging Slow Query
```markdown
SESSION START (5 mins)
└─> Read RESUME.md
└─> Issue: Dashboard loading slow (3+ seconds)

DEBUG PROTOCOL (1.5 hours)

Phase 1: Reproduce (15 mins)
└─> Steps: Login → Navigate to dashboard
└─> Reproduction rate: 100% (10/10 attempts)
└─> Observed: Slow on production, fast locally

Phase 2: Hypotheses (10 mins)
└─> H1: Missing index on user_id
└─> H2: N+1 query pattern
└─> H3: Database overloaded
└─> H4: Network latency
└─> Priority: H1 (most likely + fast to test)

Phase 3: Investigation (30 mins)
└─> Test H1: EXPLAIN ANALYZE shows Seq Scan ❌
└─> Hypothesis CONFIRMED
└─> Root cause: Missing composite index

Phase 4: Root Cause (10 mins)
└─> Query: SELECT * FROM stories WHERE user_id = ? ORDER BY created_at
└─> Missing: Index on (user_id, created_at)
└─> Why missed: Created table before defining queries
└─> Lesson: Always define queries FIRST

Phase 5: Fix (15 mins)
└─> Write failing test: Query must complete <50ms
└─> Create migration: ADD INDEX idx_stories_user_recent
└─> Verify: Query now 8ms ✅
└─> Test passes ✅

Phase 6: Prevention (10 mins)
└─> Added to checklist: "Run EXPLAIN ANALYZE on all queries"
└─> Document in ADR: "Always add indexes for WHERE + ORDER BY"
└─> Commit: "fix: add missing index on stories(user_id, created_at)"

2-HOUR CHECKPOINT (2 mins)
└─> Fixed: Dashboard now loads in <500ms
└─> Smells: Checked for similar missing indexes - found 1 more
└─> Next: Add index on frames table
```

## 🧠 Neurodivergent-Optimized Features

### Built for Hyperfocus Sessions:
- ✅ 2-4 hour work windows (matches natural focus cycle)
- ✅ Hard stop at 4 hours (prevents burnout)
- ✅ Clear gates between phases (executive function support)
- ✅ Context preservation (memory support)
- ✅ "Show your work" protocol (externalize thinking)

### Built for Non-Linear Thinking:
- ✅ Multiple hypotheses in parallel (debug protocol)
- ✅ Decision trees (not linear sequences)
- ✅ "IF this THEN that" logic (clear branching)
- ✅ Quick reference cards (visual decision aids)

### Built for Context Switching:
- ✅ RESUME.md (pick up exactly where you left off)
- ✅ Checkpoints every 2 hours (never lose >2 hours of context)
- ✅ Next actions always clear (no decision fatigue on resume)
- ✅ Recovery time <15 mins after days/weeks away

## 📚 Skill Reference Quick Links

When you need detailed guidance:
```bash
# Scoping feature
file_read ~/.config/claude/skills/user/thin-slice-mvp/SKILL.md

# Choosing tech stack
file_read ~/.config/claude/skills/user/preflight-architecture/SKILL.md

# Database schema
file_read ~/.config/claude/skills/user/database-design/SKILL.md

# API design
file_read ~/.config/claude/skills/user/api-first-design/SKILL.md

# Implementation
file_read ~/.config/claude/skills/user/london-tdd/SKILL.md

# Fixing bugs
file_read ~/.config/claude/skills/user/debug-protocol/SKILL.md

# Context preservation
file_read ~/.config/claude/skills/user/interruption-recovery/SKILL.md
```

## ✅ Success Criteria

**This orchestrator is working when:**
- ✅ Every session starts with RESUME.md
- ✅ Features start with thin-slice definition
- ✅ Architecture decisions documented before coding
- ✅ All tests passing before refactoring
- ✅ 2-hour checkpoints happen automatically
- ✅ Context never lost after interruptions
- ✅ Scope creep caught at checkpoints
- ✅ Bugs debugged systematically

**This orchestrator is failing when:**
- ❌ Coding without thin-slice definition
- ❌ Choosing architecture without presenting options
- ❌ Skipping 2-hour checkpoints
- ❌ Refactoring with failing tests
- ❌ Building features without queries defined first
- ❌ Lost context after interruptions
- ❌ "Where was I?" confusion

## 🚀 Quick Start Commands
```bash
# Start new project
"I'm starting [project name]. Help me define the thinnest possible first slice."

# Start work session
"Read my RESUME.md and help me pick up where I left off."

# Hit 2-hour mark
"Run my 2-hour checkpoint. Check for smells and define next actions."

# Bug appeared
"I have a bug: [description]. Let's follow the debug protocol."

# End of session
"Run session end protocol. I'm at the 4-hour mark."

# Lost context
"I haven't worked on this in 2 weeks. Help me recover context."
```

---

**Remember:**
> You have 7 specialized skills. This orchestrator ensures you use the right skill at the right time, in the right order, with proper gates between each phase.

**Current Priority:**
> Read this skill at the start of EVERY work session. It will route you to the right specialized skill based on what you're doing.
