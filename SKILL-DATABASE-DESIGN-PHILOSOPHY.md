---
name: Database Design Philosophy - Thin-Slice Schemas
description: Query-first database design that prevents over-engineering. Forces you to define queries before schema, start minimal, and grow incrementally. Integrates with Pre-Flight, TDD, and Interruption Recovery skills. Use BEFORE creating any table.
---

# Database Design Philosophy - Thin-Slice Schemas

## Core Philosophy
**QUERIES DEFINE SCHEMA. NOT THE REVERSE.**

LLMs will design "perfect normalized schemas" with tables you'll never use. This skill forces:
1. Define queries first (what does UI actually need?)
2. Design minimal schema (just enough for those queries)
3. Add indexes (optimize the queries)
4. Verify performance (test with realistic data)
5. Grow incrementally (add tables/columns when needed)

**This prevents:**
- ❌ Over-engineered schemas with unused tables
- ❌ Missing indexes causing slow queries
- ❌ N+1 query patterns
- ❌ Premature optimization
- ❌ Schema that doesn't match actual use
- ❌ Production performance issues

**Designed for:**
- ✅ MVP-first thinking
- ✅ Supabase/Postgres
- ✅ Query performance from day 1
- ✅ Easy schema evolution
- ✅ Clear decision trail

---

## When to Use This Skill

**ALWAYS use before:**
- Creating any new table
- Adding columns to existing table
- Designing multi-table relationships
- Choosing indexes
- Making normalization decisions

**DO NOT skip query definition. Ever.**

---

## The Database Design Protocol

### Phase 1: Define Queries First

**BEFORE designing schema, define what queries you'll run:**

```markdown
# Database Design: [Feature Name]

## What Queries Will I Run?

### Q1: [Query Purpose]
**User action:** [What triggers this query]
**Frequency:** [Every page load | On action | Background job]

```sql
-- Write the SELECT you want to run
SELECT 
  id,
  title,
  created_at,
  user_id
FROM stories
WHERE user_id = ?
ORDER BY created_at DESC
LIMIT 10;
```

**Expected result:** [What data shape this returns]

**Performance target:** <50ms with 100k rows

---

### Q2: [Another Query]
**User action:** [What triggers this]
**Frequency:** [How often]

```sql
SELECT 
  s.*,
  u.email,
  COUNT(f.id) as frame_count
FROM stories s
JOIN users u ON s.user_id = u.id
LEFT JOIN frames f ON f.story_id = s.id
WHERE s.id = ?
GROUP BY s.id, u.email;
```

**Expected result:** [What this returns]

**Performance target:** <50ms with 100k rows

---

### Q3: [Another Query]
[Same pattern]

---

## Queries Summary

**Total queries defined:** 3
**Read queries:** 3
**Write queries:** 0

**Most frequent:** Q1 (every page load)
**Most complex:** Q2 (JOIN + GROUP BY)

**⚠️  If > 5 queries:** Feature might be too big - consider thin-slicing
```

---

### Phase 2: Design Minimal Schema

**Design schema that supports ONLY the queries above:**

```markdown
## Schema Design (Minimal)

### Table: stories

**Purpose:** Store user stories (supports Q1, Q2)

```sql
CREATE TABLE stories (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES auth.users NOT NULL,
  title text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
```

**Column decisions:**

| Column | Why Needed | Which Query |
|--------|------------|-------------|
| id | Primary key | All queries |
| user_id | Filter by user | Q1, Q2 |
| title | Display in UI | Q1, Q2 |
| created_at | Sort by date | Q1, Q2 |
| updated_at | Audit trail | Q2 |

**What we're NOT adding (yet):**
- [ ] `description` - No query uses it
- [ ] `tags` - No filtering by tags yet
- [ ] `category` - Not in any query
- [ ] `priority` - No sorting by priority

**Will add when:**
- User requests filtering by category
- We write a query that needs it

---

### Row Level Security (RLS)

```sql
ALTER TABLE stories ENABLE ROW LEVEL SECURITY;

-- Users can view own stories
CREATE POLICY "Users can view own stories"
  ON stories FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create own stories
CREATE POLICY "Users can create own stories"
  ON stories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update own stories
CREATE POLICY "Users can update own stories"
  ON stories FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

**⚠️  Test RLS locally before deploying**
```sql
-- Test as different user
SET LOCAL role TO authenticated;
SET LOCAL request.jwt.claims TO '{"sub": "user-id-here"}';
SELECT * FROM stories;  -- Should only see own stories
```

---

## Phase 3: Add Indexes for Performance

**Index ONLY columns used in WHERE, ORDER BY, or JOIN:**

```markdown
## Index Strategy

### Index 1: User's Recent Stories (Q1)
**Query optimized:** Q1 (user_id filter + created_at sort)

```sql
CREATE INDEX idx_stories_user_recent 
  ON stories(user_id, created_at DESC);
```

**Why composite:** 
- Filter by user_id (first column)
- Then sort by created_at (second column)
- Single index satisfies both operations

**Query plan:**
```sql
EXPLAIN ANALYZE
SELECT * FROM stories 
WHERE user_id = '...' 
ORDER BY created_at DESC 
LIMIT 10;

-- Result: Index Scan using idx_stories_user_recent
-- Time: 2.4ms âœ…
```

---

### Index 2: Story Details (Q2)
**Query optimized:** Q2 (id lookup)

```sql
-- Primary key already indexed - NO ACTION NEEDED
```

**Note:** Primary keys are automatically indexed

---

### What We're NOT Indexing:
- [ ] title - No queries filter by title
- [ ] updated_at - No queries sort by updated_at

**Will add when:**
- We add search by title query
- We add "recently updated" sorting
```

---

## Phase 4: Performance Verification

**Test with realistic data:**

```markdown
## Performance Testing

### Test Data Generation

```sql
-- Insert 10,000 test stories
INSERT INTO stories (user_id, title, created_at)
SELECT 
  -- Rotate through 10 test users
  CASE (random() * 10)::int % 10
    WHEN 0 THEN '123e4567-e89b-12d3-a456-426614174000'
    WHEN 1 THEN '223e4567-e89b-12d3-a456-426614174000'
    -- ... 8 more user IDs
  END,
  'Story ' || generate_series,
  now() - (random() * 365 || ' days')::interval
FROM generate_series(1, 10000);
```

---

### Query Performance Results

**Q1: User's recent stories**
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM stories 
WHERE user_id = '123e4567-e89b-12d3-a456-426614174000'
ORDER BY created_at DESC 
LIMIT 10;
```

**Result:**
```
Index Scan using idx_stories_user_recent
Time: 2.4ms
Buffers: shared hit=12
```

**Status:** ✅ PASS (<50ms target)

---

**Q2: Story with details**
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.*, COUNT(f.id) as frame_count
FROM stories s
LEFT JOIN frames f ON f.story_id = s.id
WHERE s.id = '...'
GROUP BY s.id;
```

**Result:**
```
Nested Loop
  -> Index Scan on stories  (time: 0.8ms)
  -> Index Scan on frames   (time: 1.2ms)
Time: 3.1ms total
```

**Status:** ✅ PASS (<50ms target)

---

### Performance Summary

| Query | Target | Actual | Status |
|-------|--------|--------|--------|
| Q1 | <50ms | 2.4ms | ✅ |
| Q2 | <50ms | 3.1ms | ✅ |

**All queries passing:** âœ… Ready to implement
```

---

## Phase 5: Migration Creation

**Now create the migration:**

```bash
# Create migration file
supabase migration new create_stories_table
```

**Write migration with comments explaining WHY:**

```sql
-- Create stories table
-- 
-- Supports queries:
-- Q1: Get user's recent stories (main dashboard view)
-- Q2: Get story details with frame count
--
-- Design decisions:
-- - Minimal schema: Only columns needed by Q1/Q2
-- - Composite index on (user_id, created_at) for Q1 performance
-- - RLS policies enforce user can only see own stories
--
-- Performance verified:
-- - Q1: 2.4ms with 10k rows ✅
-- - Q2: 3.1ms with 10k rows ✅

CREATE TABLE stories (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES auth.users NOT NULL,
  title text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Index for Q1: user's recent stories
CREATE INDEX idx_stories_user_recent 
  ON stories(user_id, created_at DESC);

-- Row Level Security
ALTER TABLE stories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own stories"
  ON stories FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own stories"
  ON stories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own stories"
  ON stories FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Trigger for updated_at
CREATE TRIGGER update_stories_updated_at
  BEFORE UPDATE ON stories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

---

## Phase 6: Document Decision

**Create decision record:**

```markdown
# Database Decision: Stories Table

**Date:** 2025-10-21
**Feature:** User story creation

---

## Queries Defined

1. Get user's recent stories (dashboard)
2. Get single story with details

---

## Schema Design

**Chose:** Minimal single table
**Alternative:** Multi-table with categories/tags
**Why minimal:** No queries need categories yet

---

## Normalization Decision

**Chose:** Store user_id as foreign key
**Alternative:** Denormalize user email into stories
**Why this:** 
- User email rarely changes
- But JOIN is cheap at our scale (<10k stories)
- Revisit if queries show JOIN bottleneck

---

## Index Strategy

**Added:** Composite index (user_id, created_at DESC)
**Why composite:**
- Q1 filters by user_id
- Q1 sorts by created_at
- Single index handles both

**Did NOT add:** Index on title
**Why not:** No queries filter/search by title yet

---

## Performance Results

| Query | Time | Status |
|-------|------|--------|
| Get recent stories | 2.4ms | ✅ |
| Get story details | 3.1ms | ✅ |

---

## What We Did NOT Build

- [ ] Categories table
- [ ] Tags table  
- [ ] Description field
- [ ] Priority field

**Will add IF:**
- User requests filtering by category
- We write queries that need these

---

## Revisit This Decision If:

1. Queries take >50ms (add indexes)
2. Users request category filtering (add categories table)
3. JOIN on users becomes bottleneck (denormalize email)

**Next review:** After 1 week of production use
```

---

## Integration with Other Skills

### How Database Design Works with Your Workflow

```markdown
## When Starting New Feature with Database

**Scenario:** Building user story creation feature

### Step 1: Pre-Flight Architecture (Skill #1)
**Question:** Do I need state management for stories?
**Answer:** Yes - multiple components will need story data

**Decision:** Zustand for client state + Supabase for server state

### Step 2: Database Design (Skill #6 - YOU ARE HERE)
**Before writing ANY code:**

1. **Define queries first** (what data does UI need?)
   ```sql
   -- Q1: Get user's stories
   SELECT * FROM stories WHERE user_id = ? ORDER BY created_at DESC
   
   -- Q2: Get single story with all data
   SELECT * FROM stories WHERE id = ?
   ```

2. **Design minimal schema** (just enough for these queries)
   ```sql
   CREATE TABLE stories (
     id uuid PRIMARY KEY,
     user_id uuid REFERENCES auth.users,
     title text NOT NULL,
     created_at timestamptz DEFAULT now()
   );
   ```

3. **Add indexes** (optimize the queries)
   ```sql
   CREATE INDEX idx_stories_user_recent 
     ON stories(user_id, created_at DESC);
   ```

4. **Verify performance** (test with fake data)
   ```sql
   -- Insert 10k test records
   -- Run EXPLAIN ANALYZE on queries
   -- Verify <50ms performance
   ```

### Step 3: London TDD (Skill #5)
**Now you can write code:**

1. Write failing Playwright test
2. Implement feature using database
3. Refactor if needed

### Step 4: Interruption Recovery (Skill #3)
**At 2-hour checkpoint:**

Check for database smells:
- [ ] Any N+1 query patterns?
- [ ] Missing indexes causing slow queries?
- [ ] Unused columns added "just in case"?
- [ ] Tables that should be separate?

If smell detected → Stop coding → Run database design protocol again
```

---

## 2-Hour Checkpoint: Database Smell Detection

**Every 2 hours, LLM must check for these patterns:**

```markdown
## Database Architecture Smells

### Smell 1: N+1 Queries
**Symptom:** Making separate query for each item in list

```typescript
// ❌ BAD: N+1 pattern
const stories = await supabase.from('stories').select('*')
for (const story of stories) {
  const frames = await supabase
    .from('frames')
    .select('*')
    .eq('story_id', story.id)  // Separate query per story!
}
```

**Detection:** Watch for loops that query database
**Fix:** Use JOIN or batch query
```typescript
// ✅ GOOD: Single query with JOIN
const stories = await supabase
  .from('stories')
  .select(`
    *,
    frames (*)
  `)
```

**When to refactor:** Immediately when detected

---

### Smell 2: Missing Indexes on Foreign Keys
**Symptom:** Queries using foreign keys are slow

```sql
-- Query using foreign key
SELECT * FROM frames WHERE story_id = ?

-- But no index!
\d frames  -- Check indexes
```

**Detection:** Run EXPLAIN ANALYZE, see Seq Scan on foreign key column
**Fix:** Add index
```sql
CREATE INDEX idx_frames_story_id ON frames(story_id);
```

**When to refactor:** Before adding 100+ records

---

### Smell 3: Unused Columns
**Symptom:** Columns added but never queried

```sql
-- Added these columns "just in case"
ALTER TABLE stories ADD COLUMN tags jsonb;
ALTER TABLE stories ADD COLUMN category text;
ALTER TABLE stories ADD COLUMN priority int;

-- But no queries use them!
```

**Detection:** Search codebase for column name
**Fix:** Remove unused columns
```sql
ALTER TABLE stories DROP COLUMN tags;
ALTER TABLE stories DROP COLUMN category;
```

**When to refactor:** After 1 week if still unused

---

### Smell 4: Overly Generic Names
**Symptom:** Table/column names too vague

```sql
-- ❌ BAD
CREATE TABLE items (
  id uuid,
  type text,
  data jsonb
);

-- What ARE these items?
```

**Detection:** Can't tell what table stores from name alone
**Fix:** Rename to specific domain concept
```sql
-- ✅ GOOD
CREATE TABLE stories (
  id uuid,
  template_type text,
  metadata jsonb
);
```

**When to refactor:** As soon as you notice confusion

---

### Smell 5: JSONB Abuse
**Symptom:** Storing structured data as JSONB

```sql
-- ❌ BAD: Should be columns
CREATE TABLE stories (
  id uuid,
  data jsonb  -- { title, notes, cta_label, cta_url }
);
```

**Detection:** JSONB column with consistent structure across rows
**Fix:** Extract to proper columns
```sql
-- ✅ GOOD: Proper columns
CREATE TABLE stories (
  id uuid,
  title text,
  notes text,
  cta_label text,
  cta_url text
);
```

**Exception:** Keep JSONB for truly variable/extensible data
**When to refactor:** When structure becomes clear

---

### 🚨 If ANY Smell Detected at Checkpoint:

1. **Stop feature work**
2. Document current state in CHECKPOINT file
3. Run database design protocol again
4. Create migration to fix smell
5. Verify performance improved
6. Update decision record: "Changed from [X] to [Y] because [smell]"
7. Resume feature work

**Cost of refactor now:** 15-30 mins
**Cost of refactor later:** 2-4 hours + production slowness
```

---

## Emergency Procedures

### Stuck on Schema Design (>1 Hour)

**Symptoms:**
- Can't decide between normalization vs denormalization
- Overthinking edge cases
- Paralyzed by "what if we need X later?"

**Action:**
1. **STOP designing** - You're overthinking
2. **Return to queries** - What do you NEED to query today?
3. **Implement minimal schema** - Just enough for today's queries
4. **Set timer for 15 mins** - Build the minimal version
5. **Move forward** - Perfect is enemy of done

**Template for breaking analysis paralysis:**

```markdown
## Schema Decision: STUCK

**I'm stuck on:** [What I can't decide]

**Option A:** [First approach]
**Option B:** [Second approach]

**Time stuck:** [X minutes] ⚠️

**DECISION FRAMEWORK:**
1. Which option lets me ship TODAY?
2. Which option has fewer unknowns?
3. Which option is easier to change later?

**Choosing:** [Simpler option]

**Why:** Ship now, optimize later if needed

**Revisit if:** [Condition that proves I need other approach]

**Timer:** 15 minutes to implement and move on
```

---

### Migration Broke Production

**Symptoms:**
- Application errors after migration
- Queries timing out
- Data looks wrong

**Immediate Actions:**

1. **Don't panic** - Rollback exists
2. **Check logs:**
```bash
# Supabase function logs
supabase functions logs --project-ref your-ref

# Check for migration errors
supabase db remote status
```

3. **Rollback options:**

**Option A: Quick rollback via new migration**
```sql
-- Create reverse migration immediately
supabase migration new rollback_feature_name

-- In migration file, reverse the changes
DROP INDEX idx_that_caused_problem;
ALTER TABLE stories DROP COLUMN new_column;
-- etc.
```

**Option B: Manual database fix**
```bash
# Connect to production (⚠️ dangerous)
supabase db remote connect

# Manually reverse changes
DROP INDEX problematic_index;
```

**Option C: Revert commit and redeploy**
```bash
git revert [commit-hash]
git push origin main
# Triggers new deployment without bad migration
```

4. **After fixing:**
   - Document what went wrong in incident log
   - Add to pre-migration checklist
   - Test locally with production-like data

---

### Query Performance Degraded

**Symptoms:**
- Queries were fast (<50ms), now slow (>500ms)
- Application feels sluggish
- Database CPU high

**Investigation Protocol:**

```sql
-- 1. Find slow queries
SELECT 
  query,
  mean_exec_time,
  calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- 2. Check missing indexes
SELECT
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation
FROM pg_stats
WHERE schemaname = 'public'
  AND n_distinct > 100  -- High cardinality, probably needs index
  AND correlation < 0.1; -- Low correlation, definitely needs index

-- 3. Check table bloat
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- 4. Run EXPLAIN ANALYZE on slow query
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM stories WHERE user_id = '...' ORDER BY created_at DESC;
```

**Common fixes:**

```sql
-- Fix 1: Add missing index
CREATE INDEX CONCURRENTLY idx_slow_column ON table(column);

-- Fix 2: Update statistics
ANALYZE table_name;

-- Fix 3: Add composite index
CREATE INDEX CONCURRENTLY idx_composite 
  ON table(frequently_filtered_col, often_sorted_col);

-- Fix 4: Vacuum if bloated
VACUUM ANALYZE table_name;
```

---

### Can't Remember Why Schema Designed This Way

**If you return to project after time away:**

1. **Check decision record:** `decisions/database/db-schema-[feature].md`
2. **Check migration comments:**
```bash
# View migration that created table
cat supabase/migrations/*_create_stories.sql

# Should have comments explaining why:
-- Denormalized user_email because:
-- 1. Queried on every page load
-- 2. User rarely changes email
-- 3. JOIN too expensive at scale
```

3. **Run query analysis:**
```bash
# See what queries actually use the table
grep -r "from('stories')" app/
grep -r "FROM stories" supabase/
```

4. **If still unclear:**
   - Trust past you
   - Don't refactor without understanding why
   - Add comments now for future you

---

## Anti-Patterns You're Likely to Fall Into

**Based on neurodivergent thinking patterns:**

### Anti-Pattern 1: Designing "The Perfect Schema"

**Your brain:** "Let me think through every possible future scenario..."

**Trap:** 2 hours later, still designing, haven't written code

**Fix:** Set 15-min timer. Design minimal schema. Ship it.

**Rule:** You can't predict future needs. Build for TODAY's queries.

---

### Anti-Pattern 2: JSONB for Everything

**Your brain:** "JSONB is flexible! I can change it easily later!"

**Trap:** Can't index it, can't query it efficiently, causes N+1 patterns

**Fix:** Use JSONB ONLY for truly variable data (user preferences, metadata)

**Rule:** If structure is consistent, use proper columns.

---

### Anti-Pattern 3: Over-Normalization

**Your brain:** "Every concept should be its own table for purity"

**Trap:** 7 tables for simple feature, 5 JOINs per query, slow performance

**Fix:** Denormalize for query performance. Optimize for reads, not schema purity.

**Rule:** If you JOIN it every time, consider denormalizing.

---

### Anti-Pattern 4: Adding Columns "Just in Case"

**Your brain:** "We MIGHT need tags/categories/priority later..."

**Trap:** Unused columns clutter schema, confuse future you, never get used

**Fix:** Add columns when you write code that USES them, not before

**Rule:** No column without a query that selects it.

---

### Anti-Pattern 5: Skipping Performance Testing

**Your brain:** "It's just 100 rows, performance doesn't matter yet"

**Trap:** At 10,000 rows, queries timeout, users complain, production issue

**Fix:** Test with 10k rows from day 1. Find slow queries early.

**Rule:** If you wouldn't test it with 100k rows, fix it now.

---

## Common Patterns

### Pattern: One-to-Many with Counts

**Scenario:** Stories have many frames, need frame count

```sql
-- ❌ BAD: N+1 query
SELECT * FROM stories WHERE user_id = ?;
-- Then for each story:
SELECT COUNT(*) FROM frames WHERE story_id = ?;

-- ✅ GOOD: Single query with JOIN
SELECT 
  s.*,
  COUNT(f.id) as frame_count
FROM stories s
LEFT JOIN frames f ON f.story_id = s.id
WHERE s.user_id = ?
GROUP BY s.id;

-- ✅ BETTER: Materialized count (if frames rarely change)
ALTER TABLE stories ADD COLUMN frame_count int DEFAULT 0;

-- Trigger to maintain count
CREATE TRIGGER update_frame_count
  AFTER INSERT OR DELETE ON frames
  FOR EACH ROW
  EXECUTE FUNCTION update_story_frame_count();
```

**Choose based on:**
- Frames change often? → JOIN query
- Frames rarely change? → Materialized count

---

### Pattern: Soft Deletes

**Scenario:** Need to "delete" but keep records

```sql
-- Add deleted_at column
ALTER TABLE stories ADD COLUMN deleted_at timestamptz;

-- Filter out soft-deleted in all queries
SELECT * FROM stories 
WHERE user_id = ? 
  AND deleted_at IS NULL;

-- "Delete" by setting timestamp
UPDATE stories 
SET deleted_at = now() 
WHERE id = ?;

-- Index for performance
CREATE INDEX idx_stories_active 
  ON stories(user_id, created_at DESC) 
  WHERE deleted_at IS NULL;  -- Partial index!
```

---

### Pattern: Polymorphic Associations

**Scenario:** Comments on multiple types (stories, frames)

```sql
-- ❌ BAD: Two nullable foreign keys
CREATE TABLE comments (
  story_id uuid REFERENCES stories,
  frame_id uuid REFERENCES frames
);

-- ✅ GOOD: Explicit tables
CREATE TABLE story_comments (
  story_id uuid REFERENCES stories NOT NULL,
  comment_text text
);

CREATE TABLE frame_comments (
  frame_id uuid REFERENCES frames NOT NULL,
  comment_text text
);
```

**Why better:**
- Enforces referential integrity
- Clearer queries
- Better performance (no nullable FKs)

---

### Pattern: Temporal Queries

**Scenario:** Get user's activity in date range

```sql
-- Composite index for range queries
CREATE INDEX idx_stories_user_daterange 
  ON stories(user_id, created_at);

-- Range query uses index efficiently
SELECT * FROM stories
WHERE user_id = ?
  AND created_at BETWEEN ? AND ?
ORDER BY created_at DESC;
```

---

## Metrics to Track

**Track these in session notes:**

```markdown
## Database Performance Log

| Date | Table | Rows | Query | Time (ms) | Status |
|------|-------|------|-------|-----------|---------|
| 2025-10-21 | stories | 100 | user's stories | 2.4ms | ✅ |
| 2025-10-21 | stories | 10k | user's stories | 45ms | ✅ |
| 2025-10-22 | stories | 50k | user's stories | 210ms | ⚠️ |

**Actions:**
- 2025-10-22: Added composite index → 48ms ✅
- 2025-10-23: Denormalized user_email → 32ms ✅

**Goal:** All queries <50ms with 100k rows
**Current:** 95% under 50ms
**Needs work:** Dashboard query (87ms)
```

---

## Success Criteria

**This skill is working when:**
- ✅ Queries defined before schema
- ✅ All queries perform <50ms
- ✅ Indexes used (no seq scans)
- ✅ Schema starts minimal, grows incrementally
- ✅ Migrations tested locally first
- ✅ No unused tables/columns
- ✅ Performance measured from day 1
- ✅ Decision records exist for all tables
- ✅ 2-hour checkpoints catch database smells

**This skill is failing when:**
- ❌ "Design perfect schema" approach
- ❌ Slow queries after deployment
- ❌ Missing indexes
- ❌ Unused tables/columns
- ❌ N+1 query problems
- ❌ Migration breaks production
- ❌ No performance testing
- ❌ Skipping smell detection checkpoints

---

## Quick Reference Card

```
╔═══════════════════════════════════════╗
║   DATABASE DESIGN QUICK REFERENCE     ║
╚═══════════════════════════════════════╝

BEFORE ANY TABLE:
□ Define queries first (what does UI need?)
□ Design minimal schema (just enough)
□ Add indexes for query performance
□ Test with 10k rows (EXPLAIN ANALYZE)
□ Document decision (WHY, not just WHAT)

DURING DEVELOPMENT (2-hour checkpoints):
□ Check for N+1 queries
□ Check for missing indexes on foreign keys
□ Check for unused columns
□ Check for JSONB abuse
□ Check for vague names

BEFORE MIGRATION:
□ Test locally with realistic data
□ Run EXPLAIN ANALYZE on all queries
□ Verify rollback plan exists
□ Document WHY in migration comments
□ Test RLS policies

EMERGENCY:
□ Stuck >1 hour? → Pick simpler option, 15-min timer
□ Migration broke? → Rollback via new migration
□ Query slow? → EXPLAIN ANALYZE, add index
□ Forgot why? → Check decision docs, trust past you

ANTI-PATTERNS TO AVOID:
✗ Designing perfect schema
✗ JSONB for everything
✗ Over-normalization
✗ Columns "just in case"
✗ Skipping performance tests

REMEMBER:
→ Queries define schema, not the reverse
→ Minimal today, grow tomorrow
→ Performance verified, not assumed
→ Denormalize for reads
→ Ship it, then optimize
```

---

## Next Actions

1. **Add to workflow** - Use before creating any table
2. **Create `decisions/database/` folder** - Store schema decisions
3. **Test in current project** - Design next table using this skill
4. **Track performance** - Measure every query with EXPLAIN ANALYZE
5. **Set 2-hour checkpoint alarms** - Check for database smells

---

**Remember:**
> "Premature optimization is the root of all evil. But so is premature complication." - Adapted from Knuth

**Current Priority:**
> Queries first. Minimal schema. Performance verified. Grow incrementally.
