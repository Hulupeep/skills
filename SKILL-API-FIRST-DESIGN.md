---
name: API-First Design & Contract Validation
description: Define API contracts BEFORE implementation. Prevents frontend/backend misalignment, breaking changes, and "works on my machine" API bugs. Use when building any API endpoints or integrating external APIs.
---

# API-First Design & Contract Validation

## Core Philosophy
**CONTRACT BEFORE CODE. TESTS BEFORE ENDPOINTS.**

LLMs will build APIs that work today and break tomorrow. This skill forces:
1. Define the contract (OpenAPI spec)
2. Validate with contract tests
3. Generate types from contract
4. Build implementation that matches contract
5. Catch breaking changes before deploy

**This prevents:**
- ❌ Frontend/backend misalignment ("API changed without telling me")
- ❌ Breaking changes in production
- ❌ Type mismatches between client/server
- ❌ Missing error handling
- ❌ Undocumented endpoints
- ❌ "Works in Postman but not in app"

---

## When to Use This Skill

**ALWAYS use when:**
- Building new API endpoints
- Integrating third-party APIs
- Creating backend for frontend
- Adding to existing API
- Modifying existing endpoints
- Building microservices

**DO NOT skip contract definition. Ever.**

---

## API-First Protocol

### Step 1: Define the Contract (OpenAPI Spec)

**BEFORE writing any endpoint code:**

```yaml
# api/contracts/bill-splitter.yaml
openapi: 3.0.0
info:
  title: Bill Splitter API
  version: 1.0.0
  description: API for splitting bills among friends

paths:
  /api/split:
    post:
      summary: Calculate bill split
      description: Takes bill total and number of people, returns per-person amount
      
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - total
                - people
              properties:
                total:
                  type: number
                  minimum: 0.01
                  example: 125.50
                  description: Total bill amount in dollars
                people:
                  type: integer
                  minimum: 1
                  maximum: 100
                  example: 4
                  description: Number of people to split among
                tip:
                  type: number
                  minimum: 0
                  maximum: 100
                  default: 15
                  example: 18
                  description: Tip percentage
      
      responses:
        '200':
          description: Successfully calculated split
          content:
            application/json:
              schema:
                type: object
                required:
                  - perPerson
                  - totalWithTip
                properties:
                  perPerson:
                    type: number
                    example: 36.88
                    description: Amount each person pays
                  totalWithTip:
                    type: number
                    example: 147.50
                    description: Total including tip
                  breakdown:
                    type: object
                    properties:
                      subtotal:
                        type: number
                        example: 125.50
                      tipAmount:
                        type: number
                        example: 22.00
                      tipPercent:
                        type: number
                        example: 18
        
        '400':
          description: Invalid request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        
        '500':
          description: Server error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    Error:
      type: object
      required:
        - error
        - message
      properties:
        error:
          type: string
          example: "INVALID_INPUT"
        message:
          type: string
          example: "Total must be greater than 0"
        field:
          type: string
          example: "total"
          description: Field that caused the error (if applicable)
```

---

### Step 2: Contract Validation Checklist

**Before proceeding, verify contract has:**

```markdown
## Contract Checklist

### Completeness
- [ ] All endpoints defined
- [ ] All request parameters documented
- [ ] All response shapes documented
- [ ] All error cases defined
- [ ] Examples provided for each field
- [ ] Required vs optional clearly marked

### Types
- [ ] All types specified (string, number, boolean, etc.)
- [ ] Enums defined where applicable
- [ ] Min/max constraints on numbers
- [ ] String formats specified (email, url, date, etc.)
- [ ] Array item types defined
- [ ] Nested object shapes defined

### Validation
- [ ] Required fields marked
- [ ] Validation rules specified (min, max, pattern)
- [ ] Default values defined where applicable
- [ ] Edge cases considered (empty arrays, null values)

### Error Handling
- [ ] 400 (Bad Request) defined
- [ ] 401 (Unauthorized) defined if auth required
- [ ] 403 (Forbidden) defined if authorization required
- [ ] 404 (Not Found) defined for resource endpoints
- [ ] 500 (Server Error) defined
- [ ] Error response shape consistent
- [ ] Error messages helpful

### Documentation
- [ ] Each endpoint has description
- [ ] Each field has description
- [ ] Purpose of endpoint clear
- [ ] Example values realistic
- [ ] Breaking changes noted (if modifying existing)
```

---

### Step 3: Generate Types from Contract

**Use OpenAPI to generate TypeScript types:**

```bash
# Install generator
npm install -D openapi-typescript

# Generate types
npx openapi-typescript api/contracts/bill-splitter.yaml -o lib/api-types.ts
```

**Generated types example:**

```typescript
// lib/api-types.ts (auto-generated)
export interface paths {
  '/api/split': {
    post: {
      requestBody: {
        content: {
          'application/json': {
            total: number;
            people: number;
            tip?: number;
          };
        };
      };
      responses: {
        200: {
          content: {
            'application/json': {
              perPerson: number;
              totalWithTip: number;
              breakdown?: {
                subtotal: number;
                tipAmount: number;
                tipPercent: number;
              };
            };
          };
        };
        400: {
          content: {
            'application/json': {
              error: string;
              message: string;
              field?: string;
            };
          };
        };
      };
    };
  };
}
```

---

### Step 4: Write Contract Tests BEFORE Implementation

**Test that validates the contract:**

```typescript
// tests/api/split-contract.test.ts
import { describe, it, expect } from 'vitest';
import type { paths } from '@/lib/api-types';

type SplitRequest = paths['/api/split']['post']['requestBody']['content']['application/json'];
type SplitResponse = paths['/api/split']['post']['responses']['200']['content']['application/json'];
type ErrorResponse = paths['/api/split']['post']['responses']['400']['content']['application/json'];

describe('POST /api/split - Contract Validation', () => {
  
  describe('Request Validation', () => {
    it('accepts valid request', async () => {
      const request: SplitRequest = {
        total: 125.50,
        people: 4,
        tip: 18,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(200);
    });
    
    it('rejects request without required total', async () => {
      const request = {
        people: 4,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(400);
      const error: ErrorResponse = await response.json();
      expect(error.field).toBe('total');
    });
    
    it('rejects request with negative total', async () => {
      const request: SplitRequest = {
        total: -10,
        people: 4,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(400);
    });
    
    it('rejects request with zero people', async () => {
      const request: SplitRequest = {
        total: 100,
        people: 0,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(400);
    });
    
    it('uses default tip when not provided', async () => {
      const request = {
        total: 100,
        people: 2,
        // tip not provided, should use default 15%
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(200);
      const data: SplitResponse = await response.json();
      expect(data.breakdown?.tipPercent).toBe(15);
    });
  });
  
  describe('Response Validation', () => {
    it('returns all required fields', async () => {
      const request: SplitRequest = {
        total: 100,
        people: 4,
        tip: 20,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      const data: SplitResponse = await response.json();
      
      // Required fields
      expect(data.perPerson).toBeDefined();
      expect(data.totalWithTip).toBeDefined();
      
      // Types
      expect(typeof data.perPerson).toBe('number');
      expect(typeof data.totalWithTip).toBe('number');
      
      // Optional breakdown
      if (data.breakdown) {
        expect(typeof data.breakdown.subtotal).toBe('number');
        expect(typeof data.breakdown.tipAmount).toBe('number');
        expect(typeof data.breakdown.tipPercent).toBe('number');
      }
    });
    
    it('calculates correctly', async () => {
      const request: SplitRequest = {
        total: 100,
        people: 4,
        tip: 20,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      const data: SplitResponse = await response.json();
      
      // 100 + 20% = 120
      expect(data.totalWithTip).toBe(120);
      // 120 / 4 = 30
      expect(data.perPerson).toBe(30);
    });
  });
  
  describe('Error Handling', () => {
    it('returns proper error structure', async () => {
      const request = {
        total: 'not a number', // Invalid type
        people: 4,
      };
      
      const response = await fetch('/api/split', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      
      expect(response.status).toBe(400);
      const error: ErrorResponse = await response.json();
      
      // Required error fields
      expect(error.error).toBeDefined();
      expect(error.message).toBeDefined();
      
      // Types
      expect(typeof error.error).toBe('string');
      expect(typeof error.message).toBe('string');
    });
  });
});
```

**These tests should FAIL until endpoint is implemented correctly.**

---

### Step 5: Implement Endpoint to Match Contract

**Now build the endpoint using your TDD skill:**

```typescript
// app/api/split/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

// Define validation schema matching contract
const SplitRequestSchema = z.object({
  total: z.number().min(0.01),
  people: z.number().int().min(1).max(100),
  tip: z.number().min(0).max(100).default(15),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request matches contract
    const parsed = SplitRequestSchema.safeParse(body);
    
    if (!parsed.success) {
      const firstError = parsed.error.errors[0];
      return NextResponse.json(
        {
          error: 'INVALID_INPUT',
          message: firstError.message,
          field: firstError.path[0],
        },
        { status: 400 }
      );
    }
    
    const { total, people, tip } = parsed.data;
    
    // Calculate
    const tipAmount = total * (tip / 100);
    const totalWithTip = total + tipAmount;
    const perPerson = totalWithTip / people;
    
    // Return response matching contract
    return NextResponse.json({
      perPerson: Number(perPerson.toFixed(2)),
      totalWithTip: Number(totalWithTip.toFixed(2)),
      breakdown: {
        subtotal: total,
        tipAmount: Number(tipAmount.toFixed(2)),
        tipPercent: tip,
      },
    });
    
  } catch (error) {
    return NextResponse.json(
      {
        error: 'SERVER_ERROR',
        message: 'An unexpected error occurred',
      },
      { status: 500 }
    );
  }
}
```

---

### Step 6: Breaking Change Detection

**Before modifying existing endpoints:**

```markdown
## Breaking Change Checklist

### Is this a breaking change?

**Breaking changes include:**
- [ ] Removing a field from response
- [ ] Renaming a field
- [ ] Changing field type (string → number)
- [ ] Making optional field required
- [ ] Removing an endpoint
- [ ] Changing HTTP method
- [ ] Changing URL path
- [ ] Adding required request field
- [ ] Changing error codes
- [ ] Changing authentication requirements

**Non-breaking changes include:**
- [ ] Adding optional field to response
- [ ] Adding new endpoint
- [ ] Adding optional request field
- [ ] Improving error messages
- [ ] Adding new error codes (keeping old ones)
- [ ] Performance improvements
- [ ] Bug fixes that don't change contract

### If breaking change detected:

**Option A: Version the API**
```yaml
# Old version (keep working)
/api/v1/split

# New version
/api/v2/split
```

**Option B: Add new fields, deprecate old**
```yaml
properties:
  total:  # Old field
    deprecated: true
    description: "Use 'amount' instead"
  amount:  # New field
    type: number
```

**Option C: Feature flag the change**
```typescript
if (featureFlags.newSplitAPI) {
  // New behavior
} else {
  // Old behavior
}
```

**NEVER: Just change the contract and hope for the best**
```

---

## Integration with TDD Skill

### How API-First Works with London TDD

```markdown
## Workflow Integration

1. **Define Contract (API-First)**
   - Write OpenAPI spec
   - Generate types
   - Validate contract completeness

2. **Write Contract Tests (API-First)**
   - Tests that validate contract adherence
   - Must FAIL until implementation exists

3. **RED Phase (London TDD)**
   - Write failing Playwright test for user flow
   - Write failing contract tests
   - Tests verify both UX and API contract

4. **GREEN Phase (London TDD)**
   - Implement endpoint to match contract
   - All contract tests pass
   - All Playwright tests pass

5. **REFACTOR Phase (London TDD)**
   - Clean up implementation
   - Contract tests ensure no breaking changes
   - Types from contract prevent type errors
```

---

## Type Safety Patterns

### Frontend API Client

**Generate type-safe client:**

```typescript
// lib/api-client.ts
import type { paths } from './api-types';

type SplitRequest = paths['/api/split']['post']['requestBody']['content']['application/json'];
type SplitResponse = paths['/api/split']['post']['responses']['200']['content']['application/json'];
type ErrorResponse = paths['/api/split']['post']['responses']['400']['content']['application/json'];

export async function splitBill(
  request: SplitRequest
): Promise<SplitResponse> {
  const response = await fetch('/api/split', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(request),
  });
  
  if (!response.ok) {
    const error: ErrorResponse = await response.json();
    throw new Error(error.message);
  }
  
  return response.json();
}

// Usage in components - fully typed!
const result = await splitBill({
  total: 125.50,
  people: 4,
  tip: 18,
});

console.log(result.perPerson); // TypeScript knows this exists
console.log(result.invalid); // TypeScript error - field doesn't exist
```

### React Query Integration

```typescript
// hooks/use-split-bill.ts
import { useMutation } from '@tanstack/react-query';
import { splitBill } from '@/lib/api-client';
import type { paths } from '@/lib/api-types';

type SplitRequest = paths['/api/split']['post']['requestBody']['content']['application/json'];

export function useSplitBill() {
  return useMutation({
    mutationFn: (request: SplitRequest) => splitBill(request),
    onError: (error) => {
      console.error('Failed to split bill:', error);
    },
  });
}

// Usage in component - fully typed
function BillForm() {
  const { mutate, data, isLoading, error } = useSplitBill();
  
  const handleSubmit = (formData: FormData) => {
    mutate({
      total: Number(formData.get('total')),
      people: Number(formData.get('people')),
      tip: Number(formData.get('tip')),
    });
  };
  
  // TypeScript knows data shape
  if (data) {
    console.log(data.perPerson); // ✅ Valid
    console.log(data.invalid); // ❌ TypeScript error
  }
}
```

---

## Common Patterns

### Pattern 1: Pagination

```yaml
paths:
  /api/users:
    get:
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
      
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                required:
                  - data
                  - pagination
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    type: object
                    required:
                      - page
                      - limit
                      - total
                      - hasMore
                    properties:
                      page:
                        type: integer
                      limit:
                        type: integer
                      total:
                        type: integer
                      hasMore:
                        type: boolean
```

### Pattern 2: Filtering

```yaml
parameters:
  - name: status
    in: query
    schema:
      type: string
      enum: [active, inactive, pending]
  - name: search
    in: query
    schema:
      type: string
      minLength: 2
  - name: createdAfter
    in: query
    schema:
      type: string
      format: date-time
```

### Pattern 3: Bulk Operations

```yaml
paths:
  /api/users/bulk:
    post:
      requestBody:
        content:
          application/json:
            schema:
              type: object
              required:
                - action
                - userIds
              properties:
                action:
                  type: string
                  enum: [delete, archive, activate]
                userIds:
                  type: array
                  items:
                    type: string
                  minItems: 1
                  maxItems: 100
      
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: array
                    items:
                      type: string
                  failed:
                    type: array
                    items:
                      type: object
                      properties:
                        userId:
                          type: string
                        error:
                          type: string
```

### Pattern 4: File Upload

```yaml
paths:
  /api/upload:
    post:
      requestBody:
        content:
          multipart/form-data:
            schema:
              type: object
              required:
                - file
              properties:
                file:
                  type: string
                  format: binary
                description:
                  type: string
      
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                properties:
                  url:
                    type: string
                    format: uri
                  filename:
                    type: string
                  size:
                    type: integer
                  mimeType:
                    type: string
```

---

## Third-Party API Integration

### When Integrating External APIs

**Create contract that matches their API:**

```yaml
# api/contracts/stripe.yaml
openapi: 3.0.0
info:
  title: Stripe API (Subset)
  version: 1.0.0
  description: Contract for Stripe endpoints we use

paths:
  /v1/payment_intents:
    post:
      summary: Create payment intent
      requestBody:
        content:
          application/json:
            schema:
              type: object
              required:
                - amount
                - currency
              properties:
                amount:
                  type: integer
                  description: Amount in cents
                currency:
                  type: string
                  enum: [usd, eur, gbp]
      
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  client_secret:
                    type: string
                  status:
                    type: string
                    enum: [requires_payment_method, requires_confirmation, succeeded]
```

**Generate types:**

```bash
npx openapi-typescript api/contracts/stripe.yaml -o lib/stripe-types.ts
```

**Create type-safe wrapper:**

```typescript
// lib/stripe-client.ts
import type { paths } from './stripe-types';
import Stripe from 'stripe';

type CreatePaymentIntentRequest = 
  paths['/v1/payment_intents']['post']['requestBody']['content']['application/json'];

type CreatePaymentIntentResponse = 
  paths['/v1/payment_intents']['post']['responses']['200']['content']['application/json'];

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function createPaymentIntent(
  request: CreatePaymentIntentRequest
): Promise<CreatePaymentIntentResponse> {
  const intent = await stripe.paymentIntents.create({
    amount: request.amount,
    currency: request.currency,
  });
  
  // Map Stripe response to our contract
  return {
    id: intent.id,
    client_secret: intent.client_secret!,
    status: intent.status as any, // Cast to our enum
  };
}
```

**Benefits:**
- ✅ Type safety for external API
- ✅ Single source of truth (contract)
- ✅ Easy to mock for tests
- ✅ Catches API changes early

---

## Error Handling Patterns

### Standard Error Response

```yaml
components:
  schemas:
    Error:
      type: object
      required:
        - error
        - message
      properties:
        error:
          type: string
          enum:
            - INVALID_INPUT
            - NOT_FOUND
            - UNAUTHORIZED
            - FORBIDDEN
            - RATE_LIMITED
            - SERVER_ERROR
          description: Machine-readable error code
        message:
          type: string
          description: Human-readable error message
        field:
          type: string
          description: Field that caused error (for validation errors)
        details:
          type: object
          description: Additional error context
        requestId:
          type: string
          description: Request ID for debugging
```

### Error Response Implementation

```typescript
// lib/api-errors.ts
export class APIError extends Error {
  constructor(
    public code: string,
    message: string,
    public status: number,
    public field?: string,
    public details?: Record<string, any>
  ) {
    super(message);
  }
  
  toJSON() {
    return {
      error: this.code,
      message: this.message,
      field: this.field,
      details: this.details,
    };
  }
}

export const Errors = {
  InvalidInput: (message: string, field?: string) =>
    new APIError('INVALID_INPUT', message, 400, field),
  
  NotFound: (message: string) =>
    new APIError('NOT_FOUND', message, 404),
  
  Unauthorized: (message: string = 'Authentication required') =>
    new APIError('UNAUTHORIZED', message, 401),
  
  Forbidden: (message: string = 'Access denied') =>
    new APIError('FORBIDDEN', message, 403),
  
  RateLimited: (message: string = 'Too many requests') =>
    new APIError('RATE_LIMITED', message, 429),
  
  ServerError: (message: string = 'Internal server error') =>
    new APIError('SERVER_ERROR', message, 500),
};

// Usage
throw Errors.InvalidInput('Total must be positive', 'total');
```

---

## Documentation Generation

### Auto-Generate API Docs

```bash
# Install Redoc
npm install -D redoc-cli

# Generate HTML docs
npx redoc-cli bundle api/contracts/bill-splitter.yaml -o docs/api.html

# Serve docs locally
npx redoc-cli serve api/contracts/bill-splitter.yaml
```

**Add to your project:**

```typescript
// app/api/docs/route.ts
import fs from 'fs';
import path from 'path';

export async function GET() {
  const html = fs.readFileSync(
    path.join(process.cwd(), 'docs/api.html'),
    'utf-8'
  );
  
  return new Response(html, {
    headers: { 'Content-Type': 'text/html' },
  });
}
```

**Now your API is self-documenting at `/api/docs`**

---

## Success Criteria

**This skill is working when:**
- ✅ Every endpoint has OpenAPI contract BEFORE code
- ✅ Types generated from contract (not hand-written)
- ✅ Contract tests validate adherence
- ✅ No type mismatches between client/server
- ✅ Breaking changes caught before deploy
- ✅ API documented automatically
- ✅ Frontend/backend never out of sync

**This skill is failing when:**
- ❌ Building endpoint without contract
- ❌ Hand-writing types instead of generating
- ❌ No contract tests
- ❌ "API changed without telling me"
- ❌ Type errors in production
- ❌ Undocumented endpoints
- ❌ Breaking changes shipped

---

## Integration Checklist

**For each new API endpoint:**

```markdown
## API Endpoint Checklist

- [ ] OpenAPI contract written
- [ ] Contract validated (completeness checklist)
- [ ] Types generated: `npx openapi-typescript ...`
- [ ] Contract tests written (failing)
- [ ] Pre-flight architecture decision made
- [ ] Endpoint implemented (London TDD)
- [ ] Contract tests passing
- [ ] Breaking change check performed
- [ ] Documentation generated
- [ ] Frontend client created
- [ ] Integration tests passing (Playwright)
```

---

## Quick Reference

```
╔════════════════════════════════════════╗
║     API-FIRST QUICK REFERENCE         ║
╚════════════════════════════════════════╝

BEFORE ANY ENDPOINT CODE:
1. Write OpenAPI contract
2. Validate contract completeness
3. Generate types
4. Write contract tests (failing)

DURING IMPLEMENTATION:
5. Use London TDD to build endpoint
6. Ensure contract tests pass
7. Use generated types (never any)

BEFORE MODIFYING ENDPOINT:
8. Check for breaking changes
9. Version API if breaking
10. Update contract first, then code

TOOLS:
- openapi-typescript (type generation)
- redoc-cli (docs generation)
- zod (runtime validation)
- React Query (type-safe client)

REMEMBER:
Contract → Types → Tests → Implementation
```

---

## Next Actions

1. **Add to your workflow:** Use before building any API endpoint
2. **Create contracts folder:** `mkdir -p api/contracts`
3. **Install tools:** `npm install -D openapi-typescript redoc-cli`
4. **Test in Penny project:** If adding API endpoints
5. **Generate first contract:** For existing endpoints (retroactive)

---

**Remember:**
> "The contract is the truth. The code is just one implementation of that truth."

**Current Priority:**
> Define contract before implementation. Always. No exceptions.
