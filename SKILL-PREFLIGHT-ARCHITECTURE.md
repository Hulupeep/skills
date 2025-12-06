---
name: Pre-Flight Architecture Consultation
description: Forces architectural decision-making BEFORE coding. LLM must present options, human chooses, then integration tests prove the choice. Prevents paint-layering and late rewrites. Use this BEFORE writing any feature code.
---

# Pre-Flight Architecture Consultation Skill

## Core Philosophy
**NO CODE WITHOUT ARCHITECTURE DECISION ON RECORD.**

LLMs will always choose the easiest pattern (prop drilling, manual state, no caching). This skill forces LLM to:
1. Analyze feature requirements
2. Present 3+ architectural options with trade-offs
3. Wait for human decision
4. Write integration test that proves the choice works
5. Only then write implementation

**This prevents:**
- ❌ Discovering you need Zustand after building 5 components
- ❌ Realizing you need React Query after manual fetch hell
- ❌ Finding out you need form library after validation nightmare

---

## When to Use This Skill

**ALWAYS use before:**
- Starting any new feature
- Adding state management
- Implementing forms
- Adding data fetching
- Building authentication
- Adding file uploads
- Creating real-time features

**DO NOT skip this. Ever. Even for "simple" features.**

---

## Pre-Flight Protocol

### Step 1: Feature Characteristics Analysis

**LLM must fill this out FIRST:**

```markdown
# Pre-Flight: [Feature Name]

## Feature Description
[What we're building in 2-3 sentences]

## Characteristics Checklist

### State Management
- [ ] Multiple components need same data?
- [ ] Data flows down 3+ component levels?
- [ ] State updates from multiple sources?
- [ ] Need state persistence across navigation?
- [ ] Real-time state synchronization needed?

### Data Fetching
- [ ] Fetching from external API?
- [ ] Need caching?
- [ ] Need optimistic updates?
- [ ] Multiple components fetch same data?
- [ ] Need background refetching?

### Forms
- [ ] More than 5 form fields?
- [ ] Multi-step form?
- [ ] Complex validation (field dependencies)?
- [ ] Need field-level errors?
- [ ] File uploads in form?

### Authentication
- [ ] Protected routes?
- [ ] Role-based access?
- [ ] Session management?
- [ ] Token refresh needed?

### Performance
- [ ] Handling large lists (100+ items)?
- [ ] Need virtualization?
- [ ] Heavy computations?
- [ ] Real-time updates (WebSocket)?

### File Handling
- [ ] File uploads?
- [ ] Image optimization?
- [ ] Large file handling (>10MB)?
- [ ] Multiple file types?
```

---

### Step 2: Architecture Options Menu

**Based on characteristics, LLM must present OPTIONS (not just start coding):**

```markdown
## Architecture Options

### SCENARIO: [Which characteristics triggered this]

---

#### Option A: [Pattern/Library Name]

**When to use:**
- [Specific conditions]

**What it is:**
[1-sentence explanation]

**Libraries needed:**
- `package-name` - [what it does]

**Setup effort:** [Small: <30min | Medium: 30-60min | Large: 1-2hrs]

**Pros:**
- ✅ [Benefit 1]
- ✅ [Benefit 2]
- ✅ [Benefit 3]

**Cons:**
- ❌ [Trade-off 1]
- ❌ [Trade-off 2]

**Code example:**
```typescript
// Minimal example showing the pattern
```
```

**Learning curve:** [Low | Medium | High]

**Recommended for MVP?** [Yes/No - WHY]

---

#### Option B: [Alternative Pattern]

[Same structure as Option A]

---

#### Option C: [Another Alternative]

[Same structure as Option A]

---

## LLM Recommendation

**Based on MVP goals and current stack, I recommend: Option [A/B/C]**

**Reasoning:**
[Why this is best for THIS specific feature and context]

```

---

### Step 3: Human Decision Record

**HUMAN MUST CHOOSE. LLM CANNOT PROCEED WITHOUT THIS.**

```markdown
## ✅ Decision

**Chosen:** Option [A/B/C]

**Why I chose this:**
[Your reasoning]

**Trade-off accepted:**
[What we're giving up by not choosing other options]

**Success metric:**
[How we'll know this was the right choice]
- Example: "If adding 3 more components is easy"
- Example: "If page load stays under 2s"

**Revisit decision if:**
[Conditions that would make us reconsider]
- Example: "If we add more than 10 components needing this state"
- Example: "If real-time updates become a requirement"

**Date decided:** [YYYY-MM-DD]
```

---

### Step 4: Integration Test Specification

**LLM must write THIS TEST before writing any implementation code:**

```typescript
// tests/architecture/[feature-name]-architecture.spec.ts
import { test, expect } from '@playwright/test';

/**
 * ARCHITECTURE VALIDATION TEST
 * 
 * This test would FAIL if we chose the wrong architecture.
 * 
 * Decision: [Chosen option]
 * Date: [YYYY-MM-DD]
 * Why: [Reason]
 */

test.describe('Architecture: [Feature Name]', () => {
  test('validates architectural choice works end-to-end', async ({ page }) => {
    // This test should exercise the HARDEST part of the architecture
    // Example: If chose Zustand, test 3+ components accessing same state
    // Example: If chose React Query, test caching across components
    
    // [Specific test that proves architecture works]
  });
  
  test('validates trade-off is acceptable', async ({ page }) => {
    // Test that the accepted trade-off doesn't break critical path
    // Example: If chose simple pattern over complex, test it handles scale we need
  });
});
```

**This test must be WRITTEN and PASSING before implementation begins.**

---

## Pattern Library

### State Management Patterns

#### When Multiple Components Need Same Data

**Signals:**
- Prop drilling beyond 2 levels
- Same data needed in unrelated components
- State updates from different parts of component tree

**Options:**

##### Option A: Zustand (Recommended for Most Cases)

**When to use:**
- Need simple global state
- Want minimal boilerplate
- State doesn't need to be in URL

**Setup:**
```bash
npm install zustand
```

**Code example:**
```typescript
// lib/store.ts
import { create } from 'zustand';

interface UserStore {
  user: User | null;
  setUser: (user: User) => void;
}

export const useUserStore = create<UserStore>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
}));

// Any component
import { useUserStore } from '@/lib/store';

function Profile() {
  const user = useUserStore((state) => state.user);
  return <div>{user?.name}</div>;
}
```

**Effort:** Small (15 mins)

**Pros:**
- ✅ No prop drilling
- ✅ Minimal re-renders (components subscribe to slices)
- ✅ DevTools available
- ✅ Easy to test

**Cons:**
- ❌ Another dependency
- ❌ State not in URL (not shareable)

**Learning curve:** Low

**Recommended for MVP?** Yes - if state doesn't need to be in URL

---

##### Option B: URL State (Next.js searchParams)

**When to use:**
- State should be shareable via URL
- Filters, search, pagination
- Need browser back/forward to work

**Code example:**
```typescript
// app/search/page.tsx
export default function SearchPage({
  searchParams,
}: {
  searchParams: { q?: string; filter?: string };
}) {
  const router = useRouter();
  const pathname = usePathname();
  
  const updateSearch = (query: string) => {
    const params = new URLSearchParams(searchParams);
    params.set('q', query);
    router.push(`${pathname}?${params.toString()}`);
  };
  
  return <SearchInput value={searchParams.q} onChange={updateSearch} />;
}
```

**Effort:** Small (10 mins)

**Pros:**
- ✅ Shareable state
- ✅ Browser history works
- ✅ No extra dependency
- ✅ SEO-friendly

**Cons:**
- ❌ Only works for serializable data
- ❌ URL can get messy with complex state

**Learning curve:** Low

**Recommended for MVP?** Yes - for filters/search/pagination

---

##### Option C: React Context

**When to use:**
- Single, isolated state tree
- State scoped to part of app (not global)
- Rarely changes

**Code example:**
```typescript
// components/theme-provider.tsx
const ThemeContext = createContext<{theme: string; setTheme: (t: string) => void}>(null!);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState('light');
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export const useTheme = () => useContext(ThemeContext);
```

**Effort:** Small (15 mins)

**Pros:**
- ✅ No extra dependency
- ✅ Built into React
- ✅ Good for theme, locale, etc.

**Cons:**
- ❌ Re-renders entire context on any change
- ❌ Verbose for complex state
- ❌ Hard to split into smaller contexts

**Learning curve:** Low

**Recommended for MVP?** Only for theme/locale - use Zustand for everything else

---

### Form State Patterns

#### When Building Forms

**Signals:**
- More than 3 fields
- Complex validation
- Multi-step forms
- Field dependencies

**Options:**

##### Option A: React Hook Form (Recommended)

**When to use:**
- Any form with validation
- Multi-step forms
- Need field-level errors

**Setup:**
```bash
npm install react-hook-form zod @hookform/resolvers
```

**Code example:**
```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema),
  });
  
  const onSubmit = (data) => console.log(data);
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      <button type="submit">Submit</button>
    </form>
  );
}
```

**Effort:** Small (20 mins)

**Pros:**
- ✅ Minimal re-renders
- ✅ Built-in validation
- ✅ Field-level errors
- ✅ Easy multi-step forms

**Cons:**
- ❌ Another dependency
- ❌ Learning curve for advanced features

**Learning curve:** Medium

**Recommended for MVP?** Yes - if form has >3 fields or validation

---

##### Option B: Uncontrolled Forms (FormData)

**When to use:**
- Simple forms (1-3 fields)
- No complex validation
- Server-side validation sufficient

**Code example:**
```typescript
async function handleSubmit(formData: FormData) {
  'use server';
  const email = formData.get('email');
  // Validate and process
}

function SimpleForm() {
  return (
    <form action={handleSubmit}>
      <input name="email" type="email" required />
      <button type="submit">Submit</button>
    </form>
  );
}
```

**Effort:** Small (5 mins)

**Pros:**
- ✅ No dependencies
- ✅ Native HTML validation
- ✅ Works without JS

**Cons:**
- ❌ No client-side validation control
- ❌ Hard to show field-level errors
- ❌ No multi-step support

**Learning curve:** Low

**Recommended for MVP?** Yes - only for simple forms

---

### Server State Patterns

#### When Fetching Data from API

**Signals:**
- Fetching from external API
- Need caching
- Multiple components need same data
- Need loading/error states

**Options:**

##### Option A: TanStack Query (React Query) (Recommended)

**When to use:**
- Any API fetching beyond simple cases
- Need caching
- Need background refetching
- Multiple components fetch same data

**Setup:**
```bash
npm install @tanstack/react-query
```

**Code example:**
```typescript
// app/providers.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient();

export function Providers({ children }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
}

// Any component
import { useQuery } from '@tanstack/react-query';

function UserProfile() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetch(`/api/users/${userId}`).then(r => r.json()),
  });
  
  if (isLoading) return <Spinner />;
  if (error) return <Error />;
  return <div>{data.name}</div>;
}
```

**Effort:** Medium (30 mins)

**Pros:**
- ✅ Automatic caching
- ✅ Background refetching
- ✅ Optimistic updates
- ✅ Deduplicates requests
- ✅ DevTools available

**Cons:**
- ❌ Another dependency
- ❌ Learning curve

**Learning curve:** Medium

**Recommended for MVP?** Yes - if you have >3 API endpoints

---

##### Option B: SWR

**When to use:**
- Simpler alternative to React Query
- Need basic caching
- Vercel ecosystem preference

**Code example:**
```typescript
import useSWR from 'swr';

const fetcher = (url: string) => fetch(url).then(r => r.json());

function UserProfile() {
  const { data, error, isLoading } = useSWR(`/api/users/${userId}`, fetcher);
  
  if (isLoading) return <Spinner />;
  if (error) return <Error />;
  return <div>{data.name}</div>;
}
```

**Effort:** Small (20 mins)

**Pros:**
- ✅ Simpler than React Query
- ✅ Automatic caching
- ✅ Revalidation on focus

**Cons:**
- ❌ Less features than React Query
- ❌ Another dependency

**Learning curve:** Low

**Recommended for MVP?** Yes - if React Query feels too heavy

---

##### Option C: Manual Fetch + useState

**When to use:**
- Single API call
- No caching needed
- Simplest possible case

**Code example:**
```typescript
function UserProfile() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(r => r.json())
      .then(data => {
        setUser(data);
        setLoading(false);
      });
  }, [userId]);
  
  if (loading) return <Spinner />;
  return <div>{user.name}</div>;
}
```

**Effort:** Small (10 mins)

**Pros:**
- ✅ No dependencies
- ✅ Full control

**Cons:**
- ❌ No caching
- ❌ Must handle loading/error manually
- ❌ Duplicate requests
- ❌ Boilerplate for each component

**Learning curve:** Low

**Recommended for MVP?** Only for 1-2 simple API calls

---

### File Upload Patterns

#### When Handling File Uploads

**Signals:**
- User needs to upload files
- Multiple file types
- Large files (>5MB)
- Need upload progress

**Options:**

##### Option A: Direct Upload to Storage + Supabase

**When to use:**
- Already using Supabase
- Need storage management
- Files associated with DB records

**Code example:**
```typescript
import { createClient } from '@/lib/supabase/client';

async function uploadFile(file: File) {
  const supabase = createClient();
  
  const { data, error } = await supabase.storage
    .from('uploads')
    .upload(`${userId}/${file.name}`, file);
    
  if (error) throw error;
  
  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from('uploads')
    .getPublicUrl(data.path);
    
  return publicUrl;
}
```

**Effort:** Small (20 mins)

**Pros:**
- ✅ Integrated with Supabase
- ✅ CDN hosting
- ✅ RLS policies

**Cons:**
- ❌ Tied to Supabase
- ❌ Storage limits on free tier

**Recommended for MVP?** Yes - if using Supabase

---

##### Option B: Next.js API Route + Local Storage

**When to use:**
- MVP with minimal dependencies
- Small files
- Temporary storage

**Code example:**
```typescript
// app/api/upload/route.ts
import { writeFile } from 'fs/promises';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  const formData = await request.formData();
  const file = formData.get('file') as File;
  
  const bytes = await file.arrayBuffer();
  const buffer = Buffer.from(bytes);
  
  const path = `/tmp/${file.name}`;
  await writeFile(path, buffer);
  
  return NextResponse.json({ path });
}
```

**Effort:** Small (15 mins)

**Pros:**
- ✅ No external service
- ✅ Full control

**Cons:**
- ❌ Not scalable
- ❌ Lost on redeploy (Vercel)
- ❌ No CDN

**Recommended for MVP?** Only for testing - use storage service for production

---

## Integration Test Templates

### State Management Test

```typescript
// tests/architecture/state-management.spec.ts
import { test, expect } from '@playwright/test';

test('multiple components access shared state without prop drilling', async ({ page }) => {
  await page.goto('/dashboard');
  
  // Component A updates state
  await page.getByRole('button', { name: 'Update User' }).click();
  await page.getByLabel('Name').fill('New Name');
  await page.getByRole('button', { name: 'Save' }).click();
  
  // Component B (unrelated) should reflect update
  await expect(page.getByTestId('user-badge')).toContainText('New Name');
  
  // Component C (in different part of tree) should also reflect update
  await page.getByRole('link', { name: 'Profile' }).click();
  await expect(page.getByRole('heading')).toContainText('New Name');
});
```

### Form State Test

```typescript
// tests/architecture/form-validation.spec.ts
import { test, expect } from '@playwright/test';

test('form validation works with field dependencies', async ({ page }) => {
  await page.goto('/signup');
  
  // Test field-level validation
  await page.getByLabel('Email').fill('invalid');
  await page.getByLabel('Password').click(); // Blur email field
  await expect(page.getByText('Invalid email')).toBeVisible();
  
  // Test field dependencies
  await page.getByLabel('Password').fill('pass123');
  await page.getByLabel('Confirm Password').fill('different');
  await expect(page.getByText('Passwords must match')).toBeVisible();
  
  // Test successful submission
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Confirm Password').fill('pass123');
  await page.getByRole('button', { name: 'Sign Up' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

### Server State Test

```typescript
// tests/architecture/data-caching.spec.ts
import { test, expect } from '@playwright/test';

test('data fetching is cached across components', async ({ page }) => {
  // Track network requests
  const requests: string[] = [];
  page.on('request', req => {
    if (req.url().includes('/api/')) {
      requests.push(req.url());
    }
  });
  
  await page.goto('/dashboard');
  
  // First component loads data
  await expect(page.getByTestId('user-list')).toBeVisible();
  const firstRequestCount = requests.length;
  
  // Second component needs same data - should NOT make new request
  await page.getByRole('link', { name: 'Analytics' }).click();
  await expect(page.getByTestId('user-analytics')).toBeVisible();
  
  // Verify no duplicate request
  expect(requests.length).toBe(firstRequestCount);
});
```

---

## 2-Hour Checkpoint (Smell Detection)

**Every 2 hours, LLM must run this checklist:**

```markdown
## Architecture Smell Check

**Time since last check:** [X hours]

### Smell Detection

- [ ] **Prop drilling >2 levels?**
  - If YES: Should have chosen Zustand/Context
  - Action: Refactor to global state NOW

- [ ] **Same API call in >2 components?**
  - If YES: Should have chosen React Query/SWR
  - Action: Add query library NOW

- [ ] **Manual loading/error states everywhere?**
  - If YES: Should have chosen React Query/SWR
  - Action: Add query library NOW

- [ ] **Form validation getting messy?**
  - If YES: Should have chosen React Hook Form
  - Action: Add form library NOW

- [ ] **Hard to test current architecture?**
  - If YES: Architecture choice was wrong
  - Action: Stop and re-evaluate

- [ ] **Would adding one more component be painful?**
  - If YES: Architecture choice was wrong
  - Action: Refactor before it gets worse

### If ANY smell detected:

🚨 **STOP CODING**
🚨 **Run pre-flight protocol again**
🚨 **Choose better architecture**
🚨 **Refactor before continuing**

**Cost of refactor now:** 30-60 mins
**Cost of refactor later:** 4-8 hours (like Zustand rewrite)
```

---

## Success Criteria

**This skill is working when:**
- ✅ No feature starts without architecture decision on record
- ✅ LLM presents 3+ options with trade-offs before coding
- ✅ Integration tests validate architecture before implementation
- ✅ No rewrites due to wrong pattern choice
- ✅ 2-hour smell checks catch drift early
- ✅ Architecture decisions are documented with WHY

**This skill is failing when:**
- ❌ LLM jumps straight to coding
- ❌ Discover need for library after building half the feature
- ❌ Prop drilling hell
- ❌ No documented reason for architecture choice
- ❌ Integration tests written after implementation
- ❌ Major refactors due to wrong initial pattern

---

## Common Failure Modes

### "But it's just a simple feature"

**Wrong thinking:** "I don't need Zustand for one button"

**Right thinking:** "Will I need more components accessing this state in next 2 weeks?"
- If YES: Use Zustand now
- If NO: Use useState, revisit at 2-hour checkpoint

### "I'll refactor later when I need it"

**Wrong thinking:** "I'll add React Query when caching becomes a problem"

**Right thinking:** "Adding React Query later means rewriting all fetch calls. Adding it now takes 30 mins."

**Rule:** If you'll need it in next sprint, add it now.

### "Let me just try this approach"

**Wrong thinking:** Starting to code without comparing options

**Right thinking:** Run pre-flight, see ALL options, choose intentionally

**Rule:** No code without documented decision.

---

## Emergency Procedures

### Smell Detected Mid-Feature

1. **Stop coding immediately**
2. Run architecture smell check (above)
3. Document current state: "Works but [smell detected]"
4. Run pre-flight protocol again
5. Choose correct architecture
6. Refactor (tests must stay green)
7. Update decision record with: "Changed from [X] to [Y] because [smell]"

### Wrong Architecture Chosen

**Symptoms:**
- Feature is hard to test
- Adding new requirement is painful
- Code feels brittle

**Action:**
1. Don't panic - this is why we have tests
2. Write down what's wrong: "[Architecture] doesn't handle [requirement]"
3. Re-run pre-flight with new requirement as characteristic
4. Choose better architecture
5. Refactor with tests as safety net
6. Document: "Initially chose [X], switched to [Y] because [new requirement]"

### Can't Decide Between Options

**If stuck choosing:**
1. Default to simpler option for MVP
2. Document trade-off: "Chose [simple] over [complex] for speed"
3. Add revisit condition: "If [requirement X] emerges, switch to [complex]"
4. Move forward - perfect is enemy of done

---

## Example: Full Pre-Flight Session

```markdown
# Pre-Flight: User Dashboard with Live Notifications

## Feature Description
Dashboard showing user stats with real-time notifications when new data arrives.
Multiple widgets need to access user data and notification state.

## Characteristics

### State Management
- [x] Multiple components need same data (notifications, user info)
- [x] Data flows down 3+ component levels
- [x] State updates from multiple sources (API, WebSocket)
- [x] Real-time state synchronization needed

### Data Fetching
- [x] Fetching from external API
- [x] Need background refetching
- [x] Multiple components fetch same data

## Architecture Options

### State Management

#### Option A: Zustand
- When: Need simple global state with real-time updates
- Pros: Minimal re-renders, easy WebSocket integration, DevTools
- Cons: Another dependency
- Effort: 15 mins
- Recommended: YES - perfect for this use case

#### Option B: React Context
- When: Single isolated state tree
- Pros: No dependency
- Cons: Re-renders entire context, bad for real-time
- Effort: 15 mins
- Recommended: NO - performance issues with real-time

### Server State

#### Option A: TanStack Query
- When: Need caching and background refetch
- Pros: Handles caching, deduplication, auto-refetch
- Cons: Learning curve
- Effort: 30 mins
- Recommended: YES - handles API + cache layer

#### Option B: Manual fetch
- When: Simple case
- Pros: No dependency
- Cons: Must handle caching manually
- Effort: 20 mins
- Recommended: NO - will need caching

## LLM Recommendation

Use Zustand for notifications/user state + TanStack Query for API caching.

Reasoning: Notifications need real-time updates across components (Zustand perfect).
Dashboard stats need caching (React Query perfect). Clean separation of concerns.

## ✅ Decision

**Chosen:** Zustand + TanStack Query

**Why:**
- Zustand handles real-time state across components
- React Query handles API caching and refetching
- Clean separation: Zustand for app state, React Query for server state

**Trade-off:**
- Two dependencies vs one Context solution
- But Context would cause re-render hell with real-time updates

**Success metric:**
- Adding 5 more dashboard widgets is easy (<1 hour each)
- No duplicate API calls
- Real-time updates reflect instantly across all components

**Revisit if:**
- Need server-side state management (might switch to Next.js server state)
- Performance issues (unlikely with Zustand's selector optimization)

**Date decided:** 2025-01-15

## Integration Test

```typescript
test('dashboard architecture supports real-time + caching', async ({ page }) => {
  await page.goto('/dashboard');
  
  // Test 1: Multiple widgets access user data without prop drilling
  await expect(page.getByTestId('user-badge')).toContainText('John');
  await expect(page.getByTestId('user-stats')).toContainText('John');
  
  // Test 2: Notification updates reflect in all components
  // Simulate WebSocket update
  await page.evaluate(() => {
    window.mockWebSocket.send({ type: 'notification', message: 'New alert' });
  });
  await expect(page.getByTestId('notification-bell')).toContainText('1');
  await expect(page.getByTestId('notification-list')).toContainText('New alert');
  
  // Test 3: API calls are cached (no duplicate requests)
  const requestCount = await page.evaluate(() => window.mockAPICallCount);
  await page.reload();
  const newRequestCount = await page.evaluate(() => window.mockAPICallCount);
  expect(newRequestCount).toBe(requestCount); // Cached, no new request
});
```
```

---

## Next Actions

1. **Integrate with TDD skill:** Add pre-flight as Phase 0 (before RED phase)
2. **Build pattern library incrementally:** Add patterns as you discover them
3. **Track prevented rewrites:** Document each time this caught a problem early
4. **Update every sprint:** Add new patterns learned

---

**Remember:**
> "Choose explicitly. Document why. Test the choice. Only then code."

**Current Priority:**
> Run pre-flight BEFORE every feature. No exceptions. 30 mins now saves 8 hours later.
