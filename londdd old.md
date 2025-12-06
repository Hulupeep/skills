---
name: London TDD Development
description: London School TDD workflow for React/Next.js/Supabase with Playwright testing, comprehensive refactoring metrics, console error tracking, TODO management, and commit discipline. Use for building web applications with test-first methodology.
---

# London TDD Development Skill

## Core Philosophy
This skill enforces **London School TDD (Outside-In)** for React/Next.js/Supabase applications. Every feature starts with a failing acceptance test, drills down through collaboration tests, and ends with fast, isolated unit tests using mocks.

**Stack:**
- React + Next.js (App Router)
- Shadcn/ui + Tailwind CSS
- Supabase (Auth, Postgres, Edge Functions)
- Playwright (UI Testing)
- Local development via Supabase CLI
- Deploy: Vercel via GitHub Actions

## Integration with Meta-Skills

**BEFORE starting TDD cycle:**
1. ✅ Thin-Slice defined (what to build)
2. ✅ Pre-Flight decision made (architecture chosen)
3. ✅ Session started (context loaded)

**DURING TDD cycle:**
- Use this skill as written
- 2-hour checkpoints (Interruption Recovery)
- Update TODO.md as normal

**AFTER TDD cycle:**
- Session End checkpoint (Interruption Recovery)
- Next actions defined

**Your London TDD skill is the BUILD phase.**
**It plugs into the meta-skill framework.**

---

## Pre-Coding Protocol

### 1. Create Session TODO List
**ALWAYS** start by creating `TODO.md` in the project root with:

```markdown
# Session TODOs - [Date]

## Current Focus

### Feature: [Feature Name]
**WHY THIS:** [What this does, why now, and the benefit]
SO THAT [user/business outcome]

Tasks:
- [ ] [Task 1] - WHY: [Brief reason] SO THAT [benefit]
- [ ] [Task 2] - WHY: [Brief reason] SO THAT [benefit]
- [ ] [Task 3] - WHY: [Brief reason] SO THAT [benefit]

### Feature: [Another Feature if applicable]
**WHY THIS:** [Longer explanation of feature value]
SO THAT [clear outcome]

Tasks:
- [ ] [Task 1] - WHY: [Brief reason] SO THAT [benefit]

## Blocked/Waiting
- [ ] [Item] - WHY: [What's blocking and impact]

## Completed This Session
### ✅ Feature: [Completed Feature]
**DELIVERED:** [What was achieved]
- [x] [Task 1]
- [x] [Task 2]

## Next Session
- [ ] [Next action] - WHY: [Context for future you] SO THAT [you can pick up easily]
```

**Rule:** Never proceed without this file. Update it after every meaningful change.

**Examples:**

```markdown
### Feature: User Authentication
**WHY THIS:** Users need to create accounts and log in securely. Implementing now 
because it's a prerequisite for the profile and story creation features planned 
for next sprint. This establishes the foundation for all user-specific functionality.
SO THAT users can securely access their personalized content and we can track ownership.

Tasks:
- [ ] Create auth schema migration - WHY: Define users table structure SO THAT we have secure user data storage
- [ ] Add Supabase auth integration - WHY: Leverage managed auth SO THAT we don't build security from scratch
- [ ] Build login form with validation - WHY: User-friendly entry point SO THAT users can access their accounts
- [ ] Add protected route middleware - WHY: Secure private pages SO THAT unauthorized users can't access user data

### Feature: Story Creation Wizard
**WHY THIS:** Core product feature that allows users to create video stories. Doing 
now because auth is complete and this is the primary value proposition. Three-step 
wizard reduces cognitive load and increases completion rate.
SO THAT users can easily transform their videos into interactive stories with CTAs.

Tasks:
- [ ] Build template selector UI - WHY: Let users choose story type SO THAT they start with appropriate structure
- [ ] Implement video upload - WHY: Accept user content SO THAT stories have video assets
- [ ] Create form for story details - WHY: Capture metadata SO THAT stories are discoverable and actionable

## Blocked/Waiting
- [ ] QR code API selection - WHY: Need to choose between 3 providers, impacts cost and features, blocking public sharing feature

## Next Session
- [ ] Add email verification flow - WHY: Currently users can sign up without verifying, creates spam risk SO THAT we reduce fake accounts and improve deliverability
```

### 2. Verify Local Supabase
```bash
# Check if Supabase is running
supabase status

# If not running
supabase start

# Check postgres connection
psql postgresql://postgres:postgres@localhost:54322/postgres
```

### 3. CLI Tools for Automation

**Use CLI tools for automation and investigation. Minimize manual steps.**

#### Supabase CLI Commands

**Investigation & Status:**
```bash
# Check what's running
supabase status

# Check database migrations status
supabase migration list

# Inspect database schema
supabase db diff

# Check remote project status (if linked)
supabase projects list
```

**Automated Operations:**
```bash
# Reset local database (automated - no human intervention)
supabase db reset

# Generate TypeScript types from database (automated)
supabase gen types typescript --local > lib/database.types.ts

# Run functions locally (automated)
supabase functions serve

# Check edge function logs (automated)
supabase functions logs function-name
```

**🚨 Human Intervention Required:**
```bash
# Create new migration (automated generation, human reviews)
supabase migration new feature_name
# → HUMAN: Review generated SQL before committing

# Push migrations to remote (automated push, human confirms)
supabase db push
# → HUMAN: Confirm migration plan before applying to production

# Link to remote project (one-time setup)
supabase link --project-ref your-project-ref
# → HUMAN: Provide project ref and confirm connection
```

#### Vercel CLI Commands

**Investigation & Status:**
```bash
# Check deployment status
vercel ls

# Check current project info
vercel inspect

# View deployment logs
vercel logs [deployment-url]

# Check environment variables
vercel env ls

# Pull environment variables to local
vercel env pull .env.local
```

**Automated Deployments:**
```bash
# Deploy to preview (automated)
vercel

# Deploy to production (automated)
vercel --prod

# Check build logs (automated)
vercel logs --follow
```

**🚨 Human Intervention Required:**
```bash
# Link project to Vercel (one-time setup)
vercel link
# → HUMAN: Select team and project

# Add environment variable (requires value)
vercel env add SUPABASE_URL
# → HUMAN: Provide value for environment variable

# Promote preview to production (confirmation needed)
vercel promote [deployment-url]
# → HUMAN: Confirm promotion to production

# Run UAT on preview deployment
vercel ls
# → HUMAN: Click preview URL and perform UAT manually
```

#### Integration: CI/CD with CLI Tools

**Automated in GitHub Actions (no human intervention):**
- Supabase migrations are automatically applied via `supabase db push` on merge to main
- Vercel deployments trigger automatically on push
- Preview deployments created for PRs
- Tests run before deployment

**Human Steps in Workflow:**

1. **Before merge:**
   - 🚨 HUMAN: Review PR preview deployment
   - 🚨 HUMAN: Perform UAT on preview URL
   - 🚨 HUMAN: Review migration plan if database changes

2. **After merge:**
   - ✅ AUTOMATED: Tests run
   - ✅ AUTOMATED: Deploy to production
   - ✅ AUTOMATED: Migrations applied
   - 🚨 HUMAN: Monitor deployment logs
   - 🚨 HUMAN: Perform smoke test on production

3. **If issues:**
   - 🚨 HUMAN: Rollback via `vercel rollback` or revert commit
   - 🚨 HUMAN: Investigate with `vercel logs` and `supabase functions logs`

### 4. Setup Console Error Test Harness
Create `tests/harness/console-errors.ts` if it doesn't exist:

```typescript
import { test, expect, Page } from '@playwright/test';

export async function setupConsoleErrorTracking(page: Page) {
  const consoleErrors: string[] = [];
  const consoleWarnings: string[] = [];
  
  page.on('console', msg => {
    if (msg.type() === 'error') {
      consoleErrors.push(msg.text());
    }
    if (msg.type() === 'warning') {
      consoleWarnings.push(msg.text());
    }
  });
  
  page.on('pageerror', error => {
    consoleErrors.push(error.message);
  });
  
  return {
    getErrors: () => consoleErrors,
    getWarnings: () => consoleWarnings,
    assertNoErrors: () => {
      if (consoleErrors.length > 0) {
        throw new Error(`Console errors detected:\n${consoleErrors.join('\n')}`);
      }
    }
  };
}

// Use in tests like this:
// const errorTracker = await setupConsoleErrorTracking(page);
// await page.goto('/your-page');
// errorTracker.assertNoErrors();
```

---

## London TDD Coding Loop

### Phase 1: RED - Write Failing Acceptance Test (Playwright)

**Start outside-in with Playwright:**

```typescript
// tests/e2e/feature-name.spec.ts
import { test, expect } from '@playwright/test';
import { setupConsoleErrorTracking } from '../harness/console-errors';

test.describe('Feature Name', () => {
  test('user can [do the thing]', async ({ page }) => {
    const errorTracker = await setupConsoleErrorTracking(page);
    
    // Arrange: Setup test data in Supabase
    // (use direct postgres commands or test helpers)
    
    // Act: User interaction
    await page.goto('/feature-path');
    await page.getByRole('button', { name: 'Action' }).click();
    
    // Assert: Expected outcome
    await expect(page.getByText('Success message')).toBeVisible();
    
    // Assert: No console errors
    errorTracker.assertNoErrors();
  });
});
```

**Run the test (it MUST fail):**
```bash
npx playwright test tests/e2e/feature-name.spec.ts
```

**Update TODO.md:**
```markdown
- [x] Write failing acceptance test for [feature]
- [ ] Implement minimal UI to pass test
```

**Commit immediately:**
```bash
git add tests/e2e/feature-name.spec.ts TODO.md
git commit -m "test: add failing acceptance test for [feature]"
```

### Phase 2: GREEN - Minimal Implementation

**Create components with collaboration tests (mocked dependencies):**

```typescript
// components/FeatureComponent.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { FeatureComponent } from './FeatureComponent';
import { useSupabase } from '@/lib/supabase-client'; // This will be mocked

jest.mock('@/lib/supabase-client');

describe('FeatureComponent', () => {
  it('calls supabase when action clicked', async () => {
    const mockInsert = jest.fn().mockResolvedValue({ data: {}, error: null });
    (useSupabase as jest.Mock).mockReturnValue({
      from: () => ({ insert: mockInsert })
    });
    
    render(<FeatureComponent />);
    
    fireEvent.click(screen.getByRole('button', { name: 'Action' }));
    
    expect(mockInsert).toHaveBeenCalledWith({ /* expected data */ });
  });
});
```

**Implementation (minimal):**
```tsx
// components/FeatureComponent.tsx
export function FeatureComponent() {
  const supabase = useSupabase();
  
  async function handleAction() {
    await supabase.from('table').insert({ data: 'value' });
  }
  
  return (
    <Button onClick={handleAction}>Action</Button>
  );
}
```

**Run unit tests:**
```bash
npm test -- --watch=false
```

**Run Playwright test again:**
```bash
npx playwright test tests/e2e/feature-name.spec.ts
```

**If passing, update TODO and commit:**
```markdown
- [x] Implement minimal UI to pass test
- [ ] Refactor and clean up
```

```bash
git add components/ tests/ TODO.md
git commit -m "feat: implement [feature] to pass acceptance test"
```

### Phase 3: REFACTOR - Clean Up With Confidence

#### 🎯 Primary Trigger: ALL TESTS GREEN

**Golden Rule:** NEVER refactor with failing tests. You need the safety net of passing tests to refactor confidently.

```
RED → GREEN → REFACTOR
        ↑
    Must be here to refactor
```

**Requirements Before Refactoring:**
- ✅ All acceptance tests passing
- ✅ All unit tests passing
- ✅ Zero console errors
- ✅ Zero console warnings (in Playwright tests)

#### 📊 Secondary Metrics (When Tests ARE Green)

##### 1. File Size Threshold
```
Guideline: Files < 500 lines
Warning:   > 400 lines (80% of limit)
Critical:  > 500 lines (refactor immediately)

Example:
  create-story/page.tsx: 468 lines
  Status: ⚠️ Approaching limit (94%)
  Action: Plan refactor after next feature
```

##### 2. Code Duplication
Look for repeated patterns (Rule of Three):

```typescript
// ❌ DUPLICATION DETECTED (appears 3+ times)
<input
  className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2..."
  onChange={...}
/>

// ✅ After refactor: Extract component
<TextField
  value={email}
  onChange={setEmail}
  label="Email"
/>
```

**Trigger:** Same code block appears 3+ times

##### 3. Cyclomatic Complexity
Function has too many decision points:

```typescript
// ❌ HIGH COMPLEXITY
function handleSubmit() {
  if (!email) return
  if (!validateEmail(email)) return
  if (!password) return
  if (password.length < 6) return
  if (!termsAccepted) return
  if (isLoading) return
  // ... 50+ more lines
}

// ✅ After refactor
function handleSubmit() {
  const validation = validateForm()
  if (!validation.isValid) {
    setErrors(validation.errors)
    return
  }

  submitForm()
}
```

**Triggers:**
- Function > 50 lines
- 5+ conditional branches
- 3+ levels of nesting

##### 4. Separation of Concerns
Single file doing too many things:

```typescript
// ❌ MIXED CONCERNS (needs refactoring)
create-story/page.tsx:
  - UI rendering (JSX)
  - Form validation (business logic)
  - State management
  - Database operations
  - Navigation logic
  - Error handling

// ✅ After refactor: Clear separation
components/
  StoryWizard.tsx              (UI only)
  TemplateSelector.tsx         (UI only)
  VideoUpload.tsx              (UI only)

hooks/
  useStoryForm.ts              (State)
  useStoryPublisher.ts         (State + DB)
  useStoryValidation.ts        (Logic)

lib/
  storyService.ts              (Database)
  validation.ts                (Business rules)
```

**Trigger:** File contains 3+ types of concerns

##### 5. Function Length
```
Guideline: Functions < 50 lines
Warning:   > 40 lines
Critical:  > 60 lines

Why:
  - Hard to test
  - Hard to understand
  - Likely doing too much
```

##### 6. Component Prop Count
```
Guideline: < 5 props
Warning:   > 5 props
Critical:  > 8 props

// ❌ Too many props
<StoryForm
  title={title}
  setTitle={setTitle}
  notes={notes}
  setNotes={setNotes}
  ctaLabel={ctaLabel}
  setCtaLabel={setCtaLabel}
  ctaUrl={ctaUrl}
  setCtaUrl={setCtaUrl}
  ctaEnabled={ctaEnabled}
  setCtaEnabled={setCtaEnabled}
/>

// ✅ Use object or context
<StoryForm
  story={story}
  onChange={handleChange}
/>
```

#### 🔔 When to Trigger REFACTOR

##### ✅ Refactor NOW if:

1. **All tests green** ✅ (MANDATORY)
2. **AND any of these:**
   - File > 500 lines
   - 3+ duplicated code blocks
   - Function > 50 lines
   - Component > 8 props
   - Mixed concerns (UI + DB + logic in one file)
   - Before adding new feature to existing file
   - Code review feedback suggests it
   - You copy-paste code more than once

##### ❌ Don't Refactor if:

1. **Tests failing** (Fix tests first!)
2. **Under time pressure for demo** (Tech debt is OK short-term)
3. **No clear code smell** (Don't over-engineer)
4. **Working on spike/prototype** (Throwaway code)
5. **First implementation** (Get it working first)

##### ⚠️ Special Cases:

**When tests are red but you MUST refactor:**
1. Comment out failing test
2. Refactor passing code only
3. Uncomment test
4. Fix test
5. Resume normal flow

**Emergency refactoring (production bug):**
1. Write failing test for bug
2. Make test pass (simplest fix)
3. Refactor AFTER bug is fixed
4. Deploy refactored version

#### 📋 Refactoring Checklist

**Before Starting:**
- [ ] All tests passing (10/10, not 8/10)
- [ ] Committed current working state
- [ ] Identified code smell
- [ ] Planned refactor approach

**During Refactoring:**
- [ ] Run tests after EACH change
- [ ] Keep changes small (<50 lines per step)
- [ ] Commit after each successful step
- [ ] Don't change behavior (only structure)
- [ ] Don't add new features

**After Refactoring:**
- [ ] All tests still passing
- [ ] Zero new console errors
- [ ] Code is more readable
- [ ] File size reduced OR concerns separated
- [ ] Commit with message: `refactor: extract X component`

#### 🎯 Refactoring Priorities

##### Priority 1: Extract Components (UI)
When you see repeated JSX patterns:

```typescript
// Before: 468 lines in one file
create-story/page.tsx

// After: ~150 lines + 4 components
create-story/page.tsx              (150 lines - orchestration)
components/TemplateSelector.tsx     (80 lines)
components/VideoUpload.tsx         (100 lines)
components/StoryForm.tsx           (120 lines)
components/PreviewCard.tsx          (80 lines)
```

##### Priority 2: Extract Hooks (State/Logic)
When state management gets complex:

```typescript
// Before: All in component
const [story, setStory] = useState()
const [error, setError] = useState()
const [loading, setLoading] = useState()
const handleChange = ...
const handleValidation = ...
const handleSubmit = ...

// After: Custom hook
const {
  story,
  error,
  loading,
  updateStory,
  validateStory,
  submitStory
} = useStoryForm()
```

##### Priority 3: Extract Services (Database)
When database logic clutters components:

```typescript
// Before: In component
const handlePublish = async () => {
  const { data, error } = await supabase
    .from('stories')
    .insert({...})
  // ...
}

// After: Service layer
// lib/storyService.ts
export async function publishStory(story: StoryData) {
  return await supabase
    .from('stories')
    .insert(transformStoryData(story))
}

// In component
const handlePublish = async () => {
  await publishStory(story)
}
```

##### Priority 4: Extract Validation (Business Rules)
When validation logic is scattered:

```typescript
// Before: Mixed in component
if (!email.includes('@')) {
  setError('Invalid email')
}
if (password.length < 6) {
  setError('Password too short')
}

// After: Validation module
// lib/validation.ts
export function validateStoryForm(data: StoryData): ValidationResult {
  const errors: string[] = []

  if (!data.title?.trim()) {
    errors.push('Title is required')
  }

  if (data.ctaEnabled && !validateUrl(data.ctaUrl)) {
    errors.push('Invalid URL format')
  }

  return {
    isValid: errors.length === 0,
    errors
  }
}
```

#### 🎓 TDD Cycle Summary

```
Phase 1: RED
  - Write failing acceptance test (Playwright)
  - Write failing unit tests (Jest)
  - Run tests - they MUST fail
  - Commit: "test: add failing test for X"

Phase 2: GREEN
  - Write minimal code to pass tests
  - Don't worry about cleanliness yet
  - Run tests frequently (after each change)
  - Get to green as fast as possible
  - Commit: "feat: implement X to pass tests"

Phase 3: REFACTOR ← We are here
  - ALL tests must be passing first
  - Extract components/hooks/services
  - Improve naming and structure
  - Run tests after EACH refactor
  - Commit after each successful refactor
  - Commit: "refactor: extract X component"
```

**Run ALL tests before proceeding:**
```bash
npm test -- --watch=false
npx playwright test
```

**Update TODO and commit:**
```markdown
- [x] Refactor and clean up
```

```bash
git add . TODO.md
git commit -m "refactor: clean up [feature] implementation"
```

---

## Testing Patterns

### Playwright UI Testing Standards

**Always include console error tracking:**
```typescript
const errorTracker = await setupConsoleErrorTracking(page);
// ... test actions ...
errorTracker.assertNoErrors();
```

**Use semantic selectors:**
```typescript
// ✅ Good
await page.getByRole('button', { name: 'Submit' });
await page.getByLabel('Email address');
await page.getByText('Welcome back');

// ❌ Avoid
await page.locator('.btn-primary');
await page.locator('#email-input');
```

**Test with local Supabase:**
```typescript
test.beforeEach(async () => {
  // Reset and seed local database
  await resetDatabase();
  await seedTestData();
});
```

### Unit Test Mocking Strategy

**Mock external dependencies (Supabase, APIs):**
```typescript
// Always mock Supabase client in unit tests
jest.mock('@/lib/supabase-client');

// Mock specific methods
const mockSupabase = {
  from: jest.fn(() => ({
    select: jest.fn().mockResolvedValue({ data: [], error: null }),
    insert: jest.fn().mockResolvedValue({ data: {}, error: null }),
  })),
  auth: {
    getSession: jest.fn().mockResolvedValue({ data: { session: mockSession }, error: null }),
  }
};
```

**Don't mock what you own:**
- Don't mock your own components
- Don't mock your own utils
- Use real implementations for internal code

---

## Database Work with Supabase

### Direct Postgres Commands

**Always use `psql` for direct database work:**
```bash
# Connect to local Supabase
psql postgresql://postgres:postgres@localhost:54322/postgres

# Common operations
\dt                    # List tables
\d table_name          # Describe table
SELECT * FROM table;   # Query
```

### Migrations

**Use Supabase CLI for all migration operations:**

**Create migration (CLI automated):**
```bash
supabase migration new feature_name
# Generates: supabase/migrations/[timestamp]_feature_name.sql
```

**Write SQL migration:**
```sql
-- supabase/migrations/[timestamp]_feature_name.sql
CREATE TABLE feature (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES auth.users NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE feature ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own data"
  ON feature FOR SELECT
  USING (auth.uid() = user_id);
```

**🚨 HUMAN: Review migration SQL before proceeding**

**Apply locally (CLI automated):**
```bash
supabase db reset  # Resets and applies all migrations
# OR
supabase migration up  # Apply pending migrations only
```

**Generate TypeScript types (CLI automated):**
```bash
# Update types after schema changes
supabase gen types typescript --local > lib/database.types.ts
git add lib/database.types.ts
```

**Check migration status (CLI investigation):**
```bash
# See which migrations are applied
supabase migration list

# See what changed since last migration
supabase db diff
```

**Commit migration:**
```bash
git add supabase/migrations/ lib/database.types.ts TODO.md
git commit -m "db: add feature table migration"
```

**🚨 HUMAN: Before pushing to production:**
1. Review migration in PR
2. Test locally with `supabase db reset`
3. Verify types generated correctly
4. Test with actual data if dropping/altering columns

**Push to remote (requires confirmation):**
```bash
# Push to staging/production
supabase db push
# → 🚨 HUMAN: Review migration plan and confirm
```

---

## Commit Protocol

### When to Commit

**Commit after every:**
1. Failing test added (RED)
2. Test passing (GREEN)
3. Refactor complete (REFACTOR)
4. Database migration created
5. TODO item completed

**Minimum commit frequency:** Every 15-30 minutes of work

### Commit Message Format

```
<type>: <subject>

[optional body]

[optional TODO updates]
```

**Types:**
- `test`: Adding or updating tests
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `db`: Database changes
- `docs`: Documentation
- `chore`: Config, dependencies

**Examples:**
```bash
git commit -m "test: add failing test for user login"
git commit -m "feat: implement login form with Supabase auth"
git commit -m "refactor: extract auth logic to useAuth hook"
git commit -m "db: add user_profiles table migration"
```

---

## Deploy Protocol (Vercel CLI + GitHub Actions)

### Local Preview Deployments (Vercel CLI)

**Before pushing to GitHub, preview locally:**

```bash
# Build and preview locally (automated)
npm run build
npm run start

# Deploy to Vercel preview (automated)
vercel
# Returns preview URL

# Check deployment status (automated)
vercel ls
```

**🚨 HUMAN: Perform UAT on preview deployment**
- Click preview URL
- Test critical user flows
- Verify database connections work
- Check console for errors

### GitHub Actions Workflow

**Ensure `.github/workflows/deploy.yml` exists:**
```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm test
      - run: npx playwright install
      - run: npx playwright test

  deploy-preview:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v3
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
      # 🚨 HUMAN: Check preview deployment in PR comments

  deploy-production:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
      # 🚨 HUMAN: Monitor production deployment

  migrate-database:
    needs: deploy-production
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - run: npx supabase link --project-ref ${{ secrets.SUPABASE_PROJECT_REF }}
      - run: npx supabase db push --dry-run
      # 🚨 HUMAN: Review migration plan in logs
      - run: npx supabase db push
```

### Pre-Push Checklist (Automated + Human)

**✅ Automated checks:**
- [ ] All tests passing locally (`npm test && npx playwright test`)
- [ ] Build succeeds (`npm run build`)
- [ ] TypeScript has no errors (`npm run type-check`)
- [ ] Linting passes (`npm run lint`)

**🚨 Human checks:**
- [ ] TODO.md updated with WHY statements
- [ ] No console errors in Playwright tests (check harness output)
- [ ] Migrations tested locally (`supabase db reset`)
- [ ] Preview deployment tested (`vercel` then manual UAT)
- [ ] Database types regenerated if schema changed (`supabase gen types typescript --local`)

### Post-Deploy Workflow

**After merge to main (automated):**
1. ✅ GitHub Actions runs tests
2. ✅ Vercel deploys to production
3. ✅ Supabase migrations applied (if any)

**🚨 Human intervention required:**

1. **Monitor deployment:**
```bash
# Watch deployment logs in real-time
vercel logs --follow

# Check for errors
vercel logs | grep -i error
```

2. **Verify production:**
- 🚨 HUMAN: Visit production URL
- 🚨 HUMAN: Smoke test critical paths
- 🚨 HUMAN: Check Supabase dashboard for migration status

3. **Check database:**
```bash
# Verify migrations applied
supabase migration list --project-ref your-project-ref

# Check database health
supabase db remote status
```

### Rollback Procedures

**If deployment issues detected:**

```bash
# 🚨 HUMAN: Rollback Vercel deployment
vercel rollback

# OR revert git commit and push
git revert HEAD
git push origin main

# 🚨 HUMAN: If database migration issue, manual fix needed
# Connect to production database and manually rollback
# OR push a new migration that reverses changes
```

### Investigation Commands

**When things go wrong (CLI investigation):**

```bash
# Check deployment logs
vercel logs [deployment-url]

# Check Supabase function logs
supabase functions logs function-name --project-ref your-ref

# Check database slow queries
supabase db inspect slow-queries --project-ref your-ref

# Check environment variables
vercel env ls

# Compare local vs remote database schema
supabase db diff --linked
```

---

## Session End Protocol

### 1. Review TODO.md with WHY Statements

**Move completed items with delivered value:**
```markdown
## Completed This Session
### ✅ Feature: User Authentication
**DELIVERED:** Users can now sign up, log in, and access protected routes. 
Auth foundation enables all user-specific features.
- [x] Create auth schema migration
- [x] Add Supabase auth integration
- [x] Build login form with validation
- [x] Add protected route middleware

### ✅ Feature: Profile Page
**DELIVERED:** Users can view and edit their profile information. 
Includes avatar upload and email change functionality.
- [x] Create profile UI components
- [x] Add avatar upload to Supabase Storage
- [x] Build profile edit form

## Next Session
### Feature: Password Reset Flow
**WHY THIS:** Users who forget passwords are currently locked out, creating 
support burden and user frustration. Critical for production launch.
SO THAT users can recover their accounts without admin intervention.

Tasks:
- [ ] Create password reset email template - WHY: Professional communication SO THAT users trust the reset process
- [ ] Build password reset form - WHY: Secure reset mechanism SO THAT users can set new passwords
- [ ] Add reset token validation - WHY: Prevent token reuse SO THAT resets are secure
- [ ] Test email delivery locally - WHY: Verify SMTP works SO THAT emails aren't lost in production

### Feature: Email Verification
**WHY THIS:** Currently unverified accounts create spam risk and reduce 
email deliverability. Required before email marketing features.
SO THAT only real users can create accounts and we maintain good sender reputation.

Tasks:
- [ ] Block unverified users from critical features - WHY: Incentivize verification SO THAT users complete the flow
```

### 2. Generate CLI Chat History Summary

**Create `session-notes/[date].md` (automated via script):**

```bash
# Optional: Create summary generation script
# save-session.sh
#!/bin/bash

DATE=$(date +%Y-%m-%d)
NOTES_FILE="session-notes/${DATE}.md"

# Get git commits from today
COMMITS=$(git log --since="today" --oneline)

# Create summary template
cat > $NOTES_FILE << EOF
# Session Summary - $DATE

## What We Built
$(git log --since="today" --pretty=format:"- %s" | head -10)

## Key Decisions
- [Add manually with WHY context]

## Blockers/Questions  
- [Add manually with impact assessment]

## Next Actions (Priority Order)
1. [From TODO.md Next Session section]

## Commit History
$COMMITS

## Metrics
- Tests passing: $(npm test -- --watch=false 2>&1 | grep -o "[0-9]* passing" || echo "Check manually")
- Playwright passing: $(npx playwright test 2>&1 | grep -o "[0-9]* passed" || echo "Check manually")
- Files changed: $(git diff --name-only HEAD~5..HEAD | wc -l)
- Commits today: $(git log --since="today" --oneline | wc -l)

## 🚨 Human Review Required
- [ ] Review key decisions section
- [ ] Add blockers/questions
- [ ] Verify next actions match TODO.md
EOF

echo "Session notes created: $NOTES_FILE"
echo "🚨 HUMAN: Review and complete manually filled sections"
```

**Manual template if not using script:**
```markdown
# Session Summary - [Date]

## What We Built
### Feature: [Name]
**DELIVERED:** [What users can now do]
- Technical details: [What was implemented]
- Tests added: [Test coverage]
- WHY: [Context for future]

## Key Decisions
- **Decision:** [What was decided]
  - **WHY:** [Reasoning]
  - **Alternative considered:** [What we didn't do]
  - **SO THAT:** [Expected outcome]

## Blockers/Questions
- **Blocker:** [What's blocked]
  - **Impact:** [How it affects progress]
  - **WHY NOW:** [Why this matters]
  - **Next step:** [How to unblock]

## Next Actions (Priority Order)
1. [Most important next step with WHY]
2. [Second priority with SO THAT]
3. [Third priority with context]

## Commit History
[Automated: git log --since="today" --oneline]

## CLI Commands Used
[Track what worked well for future reference]
```

### 3. Final Commit (automated except review)

```bash
# Add session artifacts
git add TODO.md session-notes/

# Commit with clear message
git commit -m "docs: update session notes and TODO for [date]

- Completed: [feature names]
- Next: [planned features]  
- WHY: End of session checkpoint for context switching"

# 🚨 HUMAN: Review commit before pushing
git log -1 --stat

# Push to remote
git push
```

### 4. Output Next Actions (Clear Handoff)

**Always end with specific, actionable next steps:**

```markdown
## 🎯 Next Actions for [Date]

### Immediate: Pick Up Here
**Context:** [One sentence: where we left off and current state]

1. **[Most important task]**
   - Command: `[exact command to run]`
   - WHY: [Why this first]
   - SO THAT: [What it enables]
   - 🚨 HUMAN: [Any manual step needed]

2. **[Second task]**  
   - Command: `[exact command]`
   - WHY: [Context]
   - SO THAT: [Benefit]

3. **[Third task]**
   - Command: `[exact command]`
   - WHY: [Why now]

### Before Starting (Automated Health Check)
```bash
# Run health check
./scripts/health-check.sh
# OR manually:
supabase status           # ✅ Should be running
npm test -- --watch=false # ✅ Should pass
npx playwright test       # ✅ Should pass
```

### Environment Setup (If Needed)
```bash
# Start services (automated)
supabase start
npm run dev

# Pull latest env vars (automated)
vercel env pull .env.local

# Verify database types current (automated)
supabase gen types typescript --local > lib/database.types.ts

# 🚨 HUMAN: Review any .env changes before proceeding
```

### References
- TODO.md: See "Next Session" section for detailed WHY statements
- Session notes: `session-notes/[last-date].md` for context
- Last commit: `git log -1` for what changed
- Migrations: `supabase migration list` for database state

### If You're Lost (Recovery Commands)
```bash
# Automated investigation
git log --oneline -10           # What happened recently
git diff HEAD~1                 # What changed in last commit  
cat TODO.md                     # What we're working on
supabase status                 # Is database running
npm test -- --watch=false       # Are tests passing

# 🚨 HUMAN: Read session notes and TODO WHY statements for full context
```
```

**Example Output:**
```markdown
## 🎯 Next Actions for 2025-10-21

### Immediate: Pick Up Here
**Context:** User auth is complete (all tests green). Starting password reset flow next.

1. **Create password reset email template**
   - Command: `mkdir -p emails/templates && touch emails/templates/password-reset.html`
   - WHY: Users need professional reset emails SO THAT they trust the process and complete password recovery
   - SO THAT: Users can recover accounts without support tickets
   - 🚨 HUMAN: Design email layout (or use Supabase default template)

2. **Build password reset form**
   - Command: `mkdir -p app/reset-password && touch app/reset-password/page.tsx`
   - WHY: Secure mechanism for users to set new passwords
   - SO THAT: Password resets are user-friendly and secure

3. **Write failing Playwright test for reset flow**
   - Command: `touch tests/e2e/password-reset.spec.ts`
   - WHY: TDD ensures we build the right functionality
   - SO THAT: Reset flow works correctly before production

### Before Starting
```bash
./scripts/health-check.sh  # Automated checks
# ✅ Supabase running
# ✅ Tests passing (12/12)
# ✅ Database types current
```

### References
- TODO.md: See "Password Reset Flow" feature with full WHY statements
- Session notes: `session-notes/2025-10-20.md` for auth implementation context
- Supabase docs: https://supabase.com/docs/guides/auth/passwords
```

---

## Quick Reference Commands

### Supabase CLI

**Daily Development (automated):**
```bash
# Start local Supabase
supabase start

# Check status
supabase status

# Stop local instance
supabase stop

# Reset database (applies all migrations)
supabase db reset
```

**Database Operations (automated):**
```bash
# Connect to local postgres
psql postgresql://postgres:postgres@localhost:54322/postgres

# Create new migration
supabase migration new feature_name

# Apply pending migrations
supabase migration up

# List migration status
supabase migration list

# Generate TypeScript types
supabase gen types typescript --local > lib/database.types.ts

# Check schema differences
supabase db diff
```

**Investigation (automated queries):**
```bash
# Inspect database performance
supabase db inspect

# Check slow queries (remote)
supabase db inspect slow-queries --project-ref your-ref

# View function logs (local)
supabase functions logs function-name

# View function logs (remote)
supabase functions logs function-name --project-ref your-ref

# Check database size
supabase db inspect table-sizes
```

**🚨 Human Intervention:**
```bash
# Link to remote project (one-time)
supabase link --project-ref your-project-ref

# Push migrations to remote (review plan first)
supabase db push

# Pull remote schema to local (overwrites local)
supabase db pull
```

### Vercel CLI

**Development & Preview (automated):**
```bash
# Deploy to preview
vercel

# Deploy to production
vercel --prod

# List deployments
vercel ls

# Check current project
vercel inspect
```

**Environment Management (automated reads, human writes):**
```bash
# List environment variables
vercel env ls

# Pull env vars to local (automated)
vercel env pull .env.local

# Add new env var (🚨 human provides value)
vercel env add VARIABLE_NAME

# Remove env var (🚨 human confirms)
vercel env rm VARIABLE_NAME
```

**Monitoring & Investigation (automated):**
```bash
# View deployment logs
vercel logs [deployment-url]

# Follow logs in real-time
vercel logs --follow

# View logs for specific function
vercel logs --path /api/function-name

# Check deployment status
vercel inspect [deployment-url]
```

**🚨 Human Intervention:**
```bash
# Link project (one-time)
vercel link

# Rollback deployment (confirm required)
vercel rollback

# Promote preview to production (confirm required)
vercel promote [deployment-url]

# Remove deployment (confirm required)
vercel rm [deployment-url]
```

### Testing Commands

**Automated Test Execution:**
```bash
# Run unit tests
npm test -- --watch=false

# Run unit tests in watch mode
npm test

# Run Playwright tests
npx playwright test

# Run specific Playwright test
npx playwright test tests/e2e/feature-name.spec.ts

# Run Playwright with UI (for debugging)
npx playwright test --ui

# Run Playwright headed (see browser)
npx playwright test --headed
```

**🚨 Human Review:**
```bash
# Generate Playwright test report (then review in browser)
npx playwright show-report

# Open Playwright trace viewer (manual investigation)
npx playwright show-trace trace.zip
```

### Git Operations

**Automated:**
```bash
# Stage and commit with TODO update
git add . TODO.md && git commit -m "type: message"

# Push to trigger deploy
git push origin main

# Check last few commits
git log --oneline -10

# Check what changed
git diff
```

**🚨 Human Review:**
```bash
# Review changes before committing
git diff --staged

# Amend last commit (if needed before push)
git commit --amend

# Revert commit (creates new commit)
git revert HEAD
```

### Automation Script Examples

**Create automated health check:**
```bash
#!/bin/bash
# health-check.sh - Run before each work session

echo "🔍 Checking local environment..."

# Check Supabase
if supabase status > /dev/null 2>&1; then
  echo "✅ Supabase running"
else
  echo "❌ Supabase not running - starting..."
  supabase start
fi

# Check database types are current
echo "🔍 Checking database types..."
supabase gen types typescript --local > lib/database.types.ts
if git diff --quiet lib/database.types.ts; then
  echo "✅ Database types current"
else
  echo "⚠️  Database types outdated - regenerated"
fi

# Run tests
echo "🔍 Running tests..."
npm test -- --watch=false && npx playwright test

echo "✅ Environment healthy - ready to code!"
```

**Create deployment verification script:**
```bash
#!/bin/bash
# verify-deploy.sh - Run after deployment

DEPLOY_URL=$1

echo "🔍 Verifying deployment: $DEPLOY_URL"

# Check deployment status
vercel inspect $DEPLOY_URL

# Check for errors in logs
echo "🔍 Checking logs for errors..."
vercel logs $DEPLOY_URL | grep -i error

# 🚨 HUMAN: Manual UAT required
echo "⚠️  HUMAN ACTION REQUIRED:"
echo "1. Open: $DEPLOY_URL"
echo "2. Test critical user flows"
echo "3. Check console for errors"
echo "4. Verify database connections"
```

---

## Common Patterns

### Testing Shadcn Components

```typescript
import { render, screen } from '@testing-library/react';
import { Button } from '@/components/ui/button';

test('button renders with correct variant', () => {
  render(<Button variant="destructive">Delete</Button>);
  expect(screen.getByRole('button')).toHaveClass('bg-destructive');
});
```

### Testing Supabase Auth

```typescript
test.describe('Protected Route', () => {
  test('redirects to login when not authenticated', async ({ page }) => {
    await page.goto('/dashboard');
    await expect(page).toHaveURL('/login');
  });
  
  test('shows dashboard when authenticated', async ({ page, context }) => {
    // Set auth cookie from local Supabase
    await context.addCookies([{
      name: 'sb-access-token',
      value: 'test-token',
      domain: 'localhost',
      path: '/'
    }]);
    
    await page.goto('/dashboard');
    await expect(page.getByText('Welcome')).toBeVisible();
  });
});
```

### Testing Server Actions

```typescript
// Mock server action
jest.mock('@/app/actions/create-post', () => ({
  createPost: jest.fn()
}));

test('form calls server action on submit', async () => {
  const mockCreatePost = require('@/app/actions/create-post').createPost;
  mockCreatePost.mockResolvedValue({ success: true });
  
  render(<PostForm />);
  
  await userEvent.type(screen.getByLabelText('Title'), 'My Post');
  await userEvent.click(screen.getByRole('button', { name: 'Submit' }));
  
  expect(mockCreatePost).toHaveBeenCalledWith({ title: 'My Post' });
});
```

---

## Emergency Procedures

### Tests Failing After Refactor
1. **Don't panic** - This is expected
2. Check console error harness output
3. Run Playwright in UI mode: `npx playwright test --ui`
4. Use `page.pause()` to debug
5. Check if mocks need updating

### Supabase Local Issues
```bash
# Nuclear option - reset everything
supabase stop
rm -rf supabase/.branches
supabase start
supabase db reset
```

### Can't Remember Context
1. Read `TODO.md`
2. Read latest `session-notes/[date].md`
3. Check last few commits: `git log --oneline -10`
4. Run tests to see what's working

---

## Best Practices Summary

### DO:
- ✅ Refactor when all tests are green
- ✅ Make small, incremental changes
- ✅ Run tests after each change
- ✅ Commit frequently
- ✅ Extract reusable components
- ✅ Use descriptive names
- ✅ Keep functions under 50 lines
- ✅ Separate concerns (UI/Logic/Data)

### DON'T:
- ❌ Refactor with failing tests
- ❌ Change behavior during refactoring
- ❌ Add features during refactoring
- ❌ Make multiple changes at once
- ❌ Skip running tests
- ❌ Batch commits
- ❌ Over-engineer simple code
- ❌ Refactor without a clear goal

---

## Success Criteria

**This skill is working when:**
- ✅ Every feature starts with a failing Playwright test
- ✅ All UI tests include console error tracking
- ✅ Commits happen every 15-30 minutes
- ✅ TODO.md is always current
- ✅ No tests are skipped or disabled
- ✅ All database work uses `psql` commands
- ✅ GitHub Actions deploy automatically on push to main
- ✅ Session notes exist for every work session
- ✅ Next actions are always clear
- ✅ Refactoring only happens when all tests are green
- ✅ Files stay under 500 lines
- ✅ Code duplication is caught and extracted

**This skill is failing when:**
- ❌ Writing code before tests
- ❌ Skipping console error checks
- ❌ Large commits (>1 hour of work)
- ❌ TODO.md is stale
- ❌ Tests mocking internal code
- ❌ Using Supabase Studio instead of psql
- ❌ No session notes
- ❌ Refactoring with failing tests
- ❌ Files growing past 500 lines without refactoring

---

**Remember:**
> "Make it work, make it right, make it fast" - Kent Beck

**Current Priority:**
> Follow the RED → GREEN → REFACTOR cycle strictly. Never refactor with failing tests.
