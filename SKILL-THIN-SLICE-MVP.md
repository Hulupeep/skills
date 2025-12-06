---
name: Thin-Slice MVP Protocol
description: Forces smallest possible working end-to-end flow first. Hardcode everything, prove value, then expand. Prevents building too much too fast. Use this to scope features and avoid overengineering MVPs.
---

# Thin-Slice MVP Protocol

## Core Philosophy
**ONE WORKING FLOW BEFORE ANYTHING ELSE.**

MVPs fail because we build too much. LLMs will build complete systems. This skill forces:
1. Identify the ONE user journey that proves value
2. Hardcode/fake everything possible
3. Get it working end-to-end in 2-4 hours
4. Put in user's hands
5. Only expand when proven valuable

**This prevents:**
- ❌ Building 10 features when 1 would prove the concept
- ❌ Over-architecting before validating assumptions
- ❌ Spending weeks on something nobody wants
- ❌ Analysis paralysis from too many choices

**Thin Slice ≠ Vertical Slice:**
- Vertical Slice: One feature, fully built (all layers)
- **Thin Slice: One flow, minimally built (hardcoded where possible)**

---

## When to Use This Skill

**ALWAYS use when:**
- Starting a new project/MVP
- Adding a major feature
- Validating an assumption
- Unsure if something will work
- Have limited time to prove value

**DO NOT use when:**
- You've already proven the concept
- Building internal tool with known requirements
- Refactoring existing working code

---

## Thin-Slice Definition

### What Makes a Slice "Thin"?

**A thin slice is:**
- ✅ One complete user journey (login → action → result)
- ✅ Working end-to-end in browser
- ✅ Uses hardcoded data where possible
- ✅ Skips edge cases
- ✅ Ugly but functional
- ✅ Deployable (others can try it)
- ✅ Achievable in 2-4 hours

**A thin slice is NOT:**
- ❌ Complete feature with all variations
- ❌ Polished UI
- ❌ Handling all edge cases
- ❌ Dynamic when static would prove the point
- ❌ Scalable (yet)
- ❌ Production-ready

### The Hardcode-First Rule

**Before building real implementation, ask:**

> "Can I hardcode this to prove the flow works?"

**Examples:**

❌ **Wrong:** Build complete auth system with email verification, password reset, 2FA
✅ **Right:** Hardcode one user, skip password, prove dashboard works

❌ **Wrong:** Build Stripe integration with webhooks, subscription tiers, proration
✅ **Right:** Hardcode "isPaid: true", prove paywalled content works

❌ **Wrong:** Build AI model selection, prompt engineering, streaming responses
✅ **Right:** Hardcode one AI response, prove UI flow works

❌ **Wrong:** Build file upload, image processing, CDN integration
✅ **Right:** Use placeholder image URL, prove image display works

---

## Thin-Slice Protocol

### Step 1: Identify the Core Hypothesis

**What are you trying to prove?**

```markdown
## Hypothesis: [Project/Feature Name]

**What I believe:**
[The assumption you're testing]

**Evidence I need:**
[What would prove you right/wrong]

**Success looks like:**
[Specific observable outcome]

**Failure looks like:**
[What would make you abandon this]

**Time box:** [Hours/Days until decision]

---

### Example:

**What I believe:**
Users will pay $10/month to turn their videos into interactive stories with CTAs

**Evidence I need:**
- 10 people complete signup flow
- 5 people create a story
- 2 people share their story link
- 1 person asks about payment

**Success looks like:**
People creating and sharing stories, asking "when can I pay?"

**Failure looks like:**
Nobody completes signup, or everyone bounces after seeing the editor

**Time box:** 2 weeks before deciding to pivot or continue
```

---

### Step 2: Define The Thinnest Possible Slice

**Use this template:**

```markdown
## Thin Slice: [Name]

### User Journey (One Flow Only)
1. User [does thing 1]
2. System [responds]
3. User [does thing 2]
4. System [shows result]
5. User [sees value]

### What's REAL (must build)
- [Thing 1] - because [can't fake this]
- [Thing 2] - because [critical to hypothesis]

### What's FAKE (hardcoded/skipped)
- [Thing 3] - hardcode: [specific fake data]
- [Thing 4] - skip: [why not needed for proof]
- [Thing 5] - mock: [what the mock returns]

### What's MISSING (intentionally omitted)
- [Feature X] - will add if proven valuable
- [Edge case Y] - will handle if users hit it
- [Polish Z] - will add if people use it

### Success Metric
- [ ] User can complete journey without errors
- [ ] Journey takes less than [X seconds]
- [ ] User reaches [specific outcome]

### Time Budget
**Total:** [2-4 hours]
- Setup: [30 mins]
- Implementation: [2 hours]
- Testing: [30 mins]
- Deploy: [30 mins]

### Next Slice (IF this proves valuable)
[What you'll build next to expand]

---

### Example:

## Thin Slice: Video Story Creation

### User Journey
1. User uploads video file
2. System shows video preview
3. User adds title and CTA button
4. System generates shareable link
5. User sees their story live

### What's REAL
- Video upload - because that's the core interaction
- Video preview - because users need to see what they uploaded
- Shareable link - because that's the value prop

### What's FAKE
- User auth - hardcode userId: "test-user"
- Video processing - just show uploaded video, no compression
- Analytics - skip, not needed to prove value
- Templates - one hardcoded template only
- Payment - everyone is "pro" user

### What's MISSING
- Multiple templates (will add if people use the one template)
- Video editing/trimming (will add if people request it)
- Custom branding (will add if people pay)
- Analytics dashboard (will add if people share links)

### Success Metric
- [ ] User uploads video and sees preview
- [ ] User adds title/CTA in under 2 minutes
- [ ] Generated link works and shows story
- [ ] Story is actually shareable

### Time Budget
**Total:** 4 hours
- Setup Supabase storage: 30 mins
- Upload component: 1 hour
- Story form: 1 hour
- Preview page: 1 hour
- Deploy: 30 mins

### Next Slice
IF 5 people create stories → Add template selection
IF people share links → Add view tracking
IF people ask about editing → Add trim feature
```

---

### Step 3: Pre-Slice Checklist

**Before writing ANY code, LLM must verify:**

```markdown
## Pre-Slice Checklist

- [ ] Have I identified the ONE user journey?
- [ ] Have I listed what's REAL vs FAKE vs MISSING?
- [ ] Is this achievable in 2-4 hours?
- [ ] Will this prove/disprove my hypothesis?
- [ ] Have I run pre-flight for architectural decisions? (Skill #1)
- [ ] Do I have hardcoded test data ready?
- [ ] Can I deploy this when done?
- [ ] Do I know what I'll measure?

### IF ANY "NO":
🚨 Stop. Slice is too big. Make it thinner.

### Signs slice is too big:
- Need more than 4 hours
- Building multiple user journeys
- Can't identify what's hardcoded
- Unclear success metric
- Dependencies on other features
- "Need to set up infrastructure first"

### How to make thinner:
1. Pick ONE journey (not 3)
2. Hardcode more (even if it feels fake)
3. Skip edge cases entirely
4. Use ugly UI (skip polish)
5. Manual operations OK (automation comes later)
```

---

### Step 4: Implementation Gates

**You CANNOT move to next phase until current phase is DONE:**

```markdown
## Gate 1: Hardcoded Version Working

**Must have:**
- [ ] User journey works with fake data
- [ ] No crashes/errors
- [ ] Deployed somewhere (localhost OK)
- [ ] You've walked through it yourself

**Cannot proceed until:**
- All checkboxes ticked
- Someone else has tried it (friend, colleague, you in incognito)

**Time limit:** 2 hours MAX
- If not done in 2 hours, slice is too thick

---

## Gate 2: Real Data Connected

**Must have:**
- [ ] Real data flowing through system
- [ ] User journey still works
- [ ] Tests passing
- [ ] Deployed to public URL

**Cannot proceed until:**
- Real users can access it
- You've tested with 3+ different inputs

**Time limit:** 1 hour MAX
- If connecting real data takes >1 hour, you're building too much

---

## Gate 3: User Validation

**Must have:**
- [ ] 3+ real users tried it
- [ ] Collected feedback
- [ ] Measured success metric
- [ ] Decided: expand or pivot or kill

**Cannot proceed until:**
- You have evidence (not opinions)
- You know what to build next OR what to stop building

**Time limit:** 3-7 days
- Don't build next slice until users validate this one

---

## Gate 4: Expansion Decision

**IF users love it:**
- Proceed to next slice
- Expand ONLY what users asked for
- Keep gates in place

**IF users are lukewarm:**
- Don't add features yet
- Fix the core flow first
- Re-validate

**IF users don't use it:**
- Kill the feature
- Don't waste time polishing
- Move to next hypothesis
```

---

## Hardcoding Patterns

### Auth & Users

**Don't build:**
- Signup flow
- Email verification
- Password reset
- OAuth providers
- Session management

**Instead hardcode:**
```typescript
// lib/hardcoded-auth.ts
export const DEMO_USER = {
  id: 'demo-user-123',
  email: 'demo@example.com',
  name: 'Demo User',
  isPro: true, // Hardcode everyone as pro
};

// Use in components
import { DEMO_USER } from '@/lib/hardcoded-auth';

function Dashboard() {
  const user = DEMO_USER; // No auth check
  return <div>Welcome {user.name}</div>;
}
```

**When to make real:**
- After 10+ people try the demo
- When they ask "how do I save my work?"

---

### Payments

**Don't build:**
- Stripe integration
- Subscription tiers
- Billing pages
- Webhooks
- Trial logic

**Instead hardcode:**
```typescript
// lib/hardcoded-payment.ts
export function checkAccess(userId: string) {
  return true; // Everyone has access
}

export function getSubscriptionStatus(userId: string) {
  return {
    isPro: true,
    plan: 'professional',
    trialEndsAt: null, // No trial logic
  };
}
```

**When to make real:**
- After people ask "how do I pay?"
- When you have 20+ active users

---

### Data/Content

**Don't build:**
- Admin panel to manage content
- CMS integration
- Dynamic data fetching

**Instead hardcode:**
```typescript
// lib/hardcoded-data.ts
export const DEMO_STORIES = [
  {
    id: '1',
    title: 'Example Story',
    videoUrl: 'https://example.com/video.mp4',
    ctaText: 'Learn More',
    ctaUrl: 'https://example.com',
  },
  // Add 2-3 more examples
];

// Use in components
import { DEMO_STORIES } from '@/lib/hardcoded-data';

function StoryList() {
  const stories = DEMO_STORIES; // No API call
  return <div>{stories.map(s => <StoryCard {...s} />)}</div>;
}
```

**When to make real:**
- After users create 50+ items
- When demo data is confusing

---

### Email/Notifications

**Don't build:**
- Email service integration
- Email templates
- Notification system
- Delivery tracking

**Instead:**
```typescript
// lib/hardcoded-email.ts
export async function sendEmail(to: string, subject: string, body: string) {
  console.log('📧 Would send email:', { to, subject, body });
  // Just log it, don't actually send
  return { success: true };
}
```

**When to make real:**
- After users ask "did you send me an email?"
- When you need to re-engage inactive users

---

### AI/ML Features

**Don't build:**
- Model training
- Prompt optimization
- Multiple AI providers
- Streaming responses
- Token management

**Instead hardcode:**
```typescript
// lib/hardcoded-ai.ts
export async function generateStoryIdeas(topic: string) {
  // Return fixed responses based on topic
  const responses = {
    'travel': ['10 Hidden Gems in Europe', 'Budget Travel Tips'],
    'tech': ['AI Tools for Developers', 'Cloud Cost Optimization'],
    'default': ['How to Get Started', 'Best Practices Guide'],
  };
  
  await sleep(1000); // Fake API delay
  return responses[topic] || responses['default'];
}
```

**When to make real:**
- After users generate 100+ items
- When they notice repetition

---

### File Processing

**Don't build:**
- Video transcoding
- Image optimization
- File validation
- Progress tracking

**Instead:**
```typescript
// lib/hardcoded-files.ts
export async function uploadAndProcess(file: File) {
  // Just upload, don't process
  const url = await uploadToStorage(file);
  
  return {
    url,
    thumbnail: url, // Use original as thumbnail
    processed: true, // Lie about processing
    duration: 60, // Hardcoded duration
  };
}
```

**When to make real:**
- After users upload 50+ files
- When file sizes cause problems

---

## Anti-Patterns (What NOT To Do)

### ❌ "Let me set up infrastructure first"

**Wrong:**
```
Week 1: Set up CI/CD, monitoring, error tracking
Week 2: Set up database, migrations, backups
Week 3: Start building feature
```

**Right:**
```
Day 1: Hardcode feature, deploy to Vercel
Day 2: Get users trying it
Week 2: Add infrastructure if people use it
```

---

### ❌ "I need to build foundation first"

**Wrong:**
```markdown
Before building story creator:
- Auth system (2 days)
- Payment system (3 days)
- Email system (1 day)
- Admin panel (2 days)
Then build story creator (3 days)
Total: 11 days
```

**Right:**
```markdown
Day 1: Hardcode everything, build story creator
Day 2: Deploy, get users
If users love it: Add auth
If users pay: Add payment
Total: 2 days to proof
```

---

### ❌ "Let me handle all edge cases"

**Wrong:**
```typescript
function uploadVideo(file: File) {
  // Validate file type
  if (!['mp4', 'mov', 'avi'].includes(file.type)) throw new Error();
  
  // Check file size
  if (file.size > 100MB) throw new Error();
  
  // Scan for viruses
  await virusScan(file);
  
  // Validate duration
  if (duration > 300) throw new Error();
  
  // Check aspect ratio
  if (aspectRatio !== '16:9') throw new Error();
}
```

**Right:**
```typescript
function uploadVideo(file: File) {
  // Just upload, handle errors when users hit them
  return uploadToStorage(file);
}
```

**Add validation ONLY when:**
- Users hit the error
- Error causes actual problems
- Not theoretical edge cases

---

### ❌ "I should make it scalable now"

**Wrong thinking:** "What if 10,000 users sign up tomorrow?"

**Right thinking:** "I don't have 10 users yet. Worry about scale at 100."

**Examples:**

❌ Database: Optimize queries, add indexes, read replicas
✅ Database: Use Supabase free tier, optimize if slow

❌ API: Rate limiting, caching layers, load balancing  
✅ API: Ship it, add rate limiting if abused

❌ Storage: CDN, image optimization, lazy loading
✅ Storage: Direct upload, optimize if users complain

---

## Integration with TDD Skill

### How These Skills Work Together

**Order of operations:**

1. **Thin-Slice (this skill):** Define what to build
2. **Pre-Flight (Skill #1):** Choose architecture for the slice
3. **TDD (your existing skill):** Build the slice test-first

**Example workflow:**

```markdown
## Thin Slice: User can create story

### What's REAL
- Video upload
- Story form
- Preview page

### What's FAKE
- Auth (hardcoded user)
- Templates (one hardcoded option)
- Analytics (skip)

---

## Pre-Flight: Video Upload

**Characteristics:**
- File upload needed
- Large files (videos)

**Options:**
- A: Supabase Storage (recommended)
- B: Next.js API + local (MVP only)

**Decision:** Supabase Storage
**Why:** Handles large files, integrated with our stack

---

## TDD: Build Video Upload

**RED:** Write failing test
```typescript
test('user uploads video and sees preview', async ({ page }) => {
  await page.goto('/create');
  await page.setInputFiles('input[type="file"]', 'test.mp4');
  await expect(page.getByTestId('preview')).toBeVisible();
});
```

**GREEN:** Make it pass (hardcode where possible)

**REFACTOR:** Clean up (only if tests green)
```

---

## Slice Expansion Strategy

### When to Expand to Next Slice

**Evidence needed (pick 2+):**
- [ ] 10+ users completed current slice
- [ ] Users asking for specific next feature
- [ ] Retention: 30%+ users return next day
- [ ] Engagement: 5+ actions per user
- [ ] Someone offers to pay

**DO NOT expand based on:**
- ❌ "I think users would like this"
- ❌ "This would be cool to build"
- ❌ "Competitor has this feature"
- ❌ "I already started building it"

### Priority Framework

**Always expand in this order:**

1. **Fix the Core** (if completion rate <70%)
   - Before adding features, fix why users don't complete journey
   - Example: Users drop off at upload → fix upload UX

2. **Remove Friction** (if users complain about specific pain)
   - What's annoying users?
   - Example: "Login every time is annoying" → add auth

3. **Add Asked-For Features** (if 3+ users request)
   - What are users asking for?
   - Example: "Can I edit my video?" → add edit feature

4. **Expand Happy Path** (only if core is working well)
   - Add variations/alternatives
   - Example: Add more templates

5. **Polish** (only after everything else works)
   - Make it pretty
   - Add animations
   - Improve copy

**Never skip 1-3 to do 4-5.**

---

## Measuring Success

### For Each Slice, Track:

```markdown
## Slice Metrics: [Name]

**Completion Rate:**
- Started: [X users]
- Completed: [Y users]
- Rate: [Y/X %]
- Goal: >70%

**Time to Complete:**
- Median: [X seconds]
- Goal: <[Y seconds]

**User Feedback:**
- "This is awesome": [count]
- "This is confusing": [count]
- "I wish it had [feature]": [feature → count]

**Technical:**
- Errors: [count]
- Load time: [X seconds]
- Uptime: [X%]

**Decision:**
- [ ] Expand (metrics good, users asking for more)
- [ ] Fix (completion rate low, users confused)
- [ ] Pivot (users not using it)
- [ ] Kill (no engagement after fixes)
```

---

## 2-Hour Checkpoint (Scope Creep Check)

**Every 2 hours during slice implementation:**

```markdown
## Scope Creep Check

**Original slice:**
[Copy of what you defined in Step 2]

**What I've built so far:**
[List what's done]

**Am I still on track?**
- [ ] Building only what's in slice definition
- [ ] Not adding "nice to haves"
- [ ] Still using hardcoded data where planned
- [ ] Still skipping edge cases as planned

### Red Flags (STOP if true):
- [ ] Added features not in original slice
- [ ] Building "real" version of something I said I'd hardcode
- [ ] Handling edge cases I said I'd skip
- [ ] Spent >30 mins on UI polish
- [ ] "Just one more thing" syndrome

### IF RED FLAG DETECTED:
🚨 STOP CODING
🚨 Revert to last checkpoint
🚨 Stick to original slice definition

**Reminder:** You can add features AFTER users validate this slice.

**Time in slice:** [X hours]
**Time remaining:** [4 - X hours]

**If >4 hours spent:**
🚨 HARD STOP. Slice was too big.
- Ship what works
- Mark rest as "Next Slice"
- Get user feedback on what's done
```

---

## Emergency Procedures

### Slice Taking Too Long (>4 hours)

**Symptoms:**
- 4+ hours in, still not done
- Keep finding "one more thing" to build
- Feature creeping during implementation

**Action:**
1. Stop coding immediately
2. Commit what works (even if incomplete)
3. Deploy what you have
4. Mark remaining items as "Next Slice"
5. Get feedback on what's done before continuing

**Remember:** Incomplete but deployed > Complete but not deployed

---

### Users Not Using Slice

**Symptoms:**
- Deployed 3+ days ago
- <5 users tried it
- No feedback
- No engagement

**Action:**
1. Don't build more features
2. Figure out why: Distribution? Value prop? UX?
3. Fix the "why" before expanding
4. Consider: Pivot or kill

**Remember:** More features won't fix a distribution problem

---

### Analysis Paralysis

**Symptoms:**
- Can't decide what slice to build
- Everything seems equally important
- Overthinking the definition

**Action:**
1. Flip a coin if needed
2. Pick the slice that proves value FASTEST
3. Build it TODAY
4. Learn from user feedback
5. Adjust next slice based on learning

**Remember:** Wrong slice shipped > Right slice planned

---

## Success Criteria

**This skill is working when:**
- ✅ First deployment happens in <4 hours
- ✅ Users validate each slice before next is built
- ✅ No features built without user request
- ✅ Hardcoded data used strategically
- ✅ Core journey works before expansion
- ✅ Scope creep caught at 2-hour checkpoints

**This skill is failing when:**
- ❌ Week 1 and nothing deployed
- ❌ Building features without user validation
- ❌ "Setting up infrastructure" before proving value
- ❌ Handling edge cases before core works
- ❌ "Just one more feature" syndrome
- ❌ Users asking for feature you already built (they don't know it exists)

---

## Common Questions

### "When do I stop hardcoding?"

**Answer:** When the hardcoded version causes actual problems.

**Examples:**
- Hardcoded user → Stop when people want to save their own data
- Hardcoded responses → Stop when people notice repetition
- Hardcoded payment → Stop when people ask how to pay

**Not:**
- "It feels unprofessional" (users don't see the code)
- "What if it doesn't scale?" (you don't have scale yet)
- "Best practices say..." (best practices assume proven value)

### "What if users expect more?"

**Answer:** Set expectations.

**Examples:**
- Add banner: "Early preview - limited features"
- In onboarding: "This is an MVP to test the concept"
- In feedback: "What would make this more useful?"

**Most users understand MVPs. The ones who don't aren't your early adopters.**

### "How do I know if slice is thin enough?"

**Answer:** Can you build and deploy it in one 2-4 hour hyperfocus session?

- YES → Probably thin enough
- NO → Make it thinner

**Also ask:** "If this fails, how quickly do I know?"
- <1 week → Thin enough
- >1 week → Too thick

### "What if I hardcode the wrong thing?"

**Answer:** You'll learn from users and fix it.

**Cost of wrong hardcode:** 1-2 hours to fix
**Cost of building full system users don't want:** Weeks wasted

**Take the bet on hardcoding.**

---

## Example: Full Slice Definition

```markdown
# Thin Slice: Penny Project - Bill Splitting

## Hypothesis
**What I believe:**
Friends will use a simple bill splitting app if it's faster than calculator + Venmo

**Evidence I need:**
- 10 people use it to split a bill
- 5 people use it twice
- Someone shares the link with friends

**Success looks like:**
People using it at restaurants, sharing results

**Failure looks like:**
Nobody uses it, or uses calculator anyway

**Time box:** 1 week

---

## Thin Slice: Split Bill & Request Payment

### User Journey
1. User enters bill amount
2. User enters friend names
3. System calculates split
4. User copies payment request message
5. User sends to friends via existing messaging app

### What's REAL
- Bill calculation
- Friend names input
- Shareable result

### What's FAKE
- Auth - no login, anyone can use
- Saving bills - no persistence, one-time use
- Payment integration - just copy text, no Venmo API
- Tips calculation - simple percentage dropdown
- Currency - USD only hardcoded

### What's MISSING
- Bill history (will add if people want to review old bills)
- Photo bill splitting (will add if requested)
- Multiple currencies (will add if international users)
- Group profiles (will add if same group splits repeatedly)
- Unequal splits (will add if people request)

### Success Metric
- [ ] User enters bill and gets split in <30 seconds
- [ ] Generated message is copyable
- [ ] Works on mobile (where people actually split bills)

### Time Budget
**Total:** 3 hours
- Setup Next.js: 15 mins
- Bill form: 45 mins
- Calculation logic: 30 mins
- Result display: 45 mins
- Deploy to Vercel: 15 mins

### Next Slice (IF validated)
IF people use it 2+ times → Add bill history
IF people split bills with same group → Add group profiles
IF people request → Add unequal splits

---

## Pre-Flight: State Management

**Characteristics:**
- Simple form with calculations
- No persistence needed
- Single page app

**Decision:** useState only
**Why:** Simple form, no need for Zustand/Context
**Trade-off:** Can't access state across pages (but only one page for MVP)

---

## Implementation

**What I'll build:**

```typescript
// app/page.tsx - The entire MVP
'use client';
import { useState } from 'react';

export default function BillSplitter() {
  const [total, setTotal] = useState('');
  const [people, setPeople] = useState(['']);
  const [tip, setTip] = useState(15);
  
  const calculate = () => {
    const amount = parseFloat(total);
    const withTip = amount * (1 + tip / 100);
    const perPerson = withTip / people.length;
    return perPerson.toFixed(2);
  };
  
  const generateMessage = () => {
    const amount = calculate();
    return `Hey! Your share of the bill is $${amount}. 
Thanks for a great meal! 🎉`;
  };
  
  return (
    <div className="max-w-md mx-auto p-4">
      <h1>Split Bill</h1>
      
      <label>Total Amount</label>
      <input 
        type="number" 
        value={total}
        onChange={e => setTotal(e.target.value)}
      />
      
      <label>Tip %</label>
      <select value={tip} onChange={e => setTip(Number(e.target.value))}>
        <option>15</option>
        <option>18</option>
        <option>20</option>
      </select>
      
      <label>People</label>
      {people.map((name, i) => (
        <input
          key={i}
          value={name}
          onChange={e => {
            const newPeople = [...people];
            newPeople[i] = e.target.value;
            setPeople(newPeople);
          }}
        />
      ))}
      <button onClick={() => setPeople([...people, ''])}>
        + Add Person
      </button>
      
      <div className="result">
        <h2>Each person pays: ${calculate()}</h2>
        <button onClick={() => {
          navigator.clipboard.writeText(generateMessage());
          alert('Copied!');
        }}>
          Copy Message
        </button>
      </div>
    </div>
  );
}
```

**What I'm NOT building:**
- Login/signup
- Database
- Bill history
- Complex split logic
- Design system
- Error handling for edge cases
- Mobile app
- Analytics

**Total time:** 2 hours
**Deploy:** Immediately after
**Test:** Use at next restaurant visit
```

---

## Next Actions

1. **Create TODO.md with thin slice definition** (15 mins)
2. **Run pre-flight for architectural decisions** (30 mins)
3. **Build slice following TDD** (2-3 hours)
4. **Deploy and test yourself** (30 mins)
5. **Get 3 real users to try it** (3-7 days)
6. **Decide next slice based on feedback** (30 mins)

---

**Remember:**
> "Make it work, make it right, make it fast" - Kent Beck  
> But first: **Make it THIN.**

**Current Priority:**
> Ship one working flow in 4 hours. Everything else is scope creep.
