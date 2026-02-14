# Hono Patterns and Best Practices

A comprehensive guide to building production-ready Hono applications with proven patterns and practices.

## Best Practices

### 1. Don't Make Controllers

Inline handlers for type inference. The TypeScript compiler can't infer types when you separate route handlers into controller functions.

```ts
// ❌ Bad - Type inference breaks
function getUser(c: Context) {
  const id = c.req.param('id') // Type: string (generic)
  return c.json({ id })
}
app.get('/users/:id', getUser)

// ✅ Good - Type inference works
app.get('/users/:id', (c) => {
  const id = c.req.param('id') // Type: specific param from route
  return c.json({ id })
})
```

### 2. Use factory.createHandlers() If You Must Separate

When you need to extract handlers for reusability or organization, use `createHandlers()` from `hono/factory` to preserve type inference.

```ts
import { createFactory } from 'hono/factory'

const factory = createFactory()

const handlers = factory.createHandlers((c) => {
  const id = c.req.param('id') // Type inference preserved
  return c.json({ id })
})

app.get('/users/:id', ...handlers)
```

### 3. Build Larger Apps with app.route()

Split your application into sub-files and mount them in your main file. This keeps your codebase organized and maintainable.

```ts
// authors.ts
export const authors = new Hono()
  .get('/', (c) => c.json(['Author 1', 'Author 2']))
  .get('/:id', (c) => c.json({ id: c.req.param('id') }))

// books.ts
export const books = new Hono()
  .get('/', (c) => c.json(['Book 1', 'Book 2']))
  .get('/:id', (c) => c.json({ id: c.req.param('id') }))

// index.ts
import { authors } from './authors'
import { books } from './books'

const app = new Hono()
  .route('/authors', authors)
  .route('/books', books)

export default app
```

### 4. Chain for RPC

For RPC type inference to work with `hono/client`, you must chain route definitions and export the app type.

```ts
// ✅ Good - Type inference works
const app = new Hono()
  .get('/posts', (c) => c.json([]))
  .post('/posts', (c) => c.json({ id: 1 }))

export type AppType = typeof app

// client.ts
import { hc } from 'hono/client'
import type { AppType } from './server'

const client = hc<AppType>('http://localhost:3000')
const res = await client.posts.$get() // Fully typed
```

### 5. RPC with Larger Applications

When using `app.route()` with RPC, chain the `.route()` calls and export the chained result type.

```ts
// authors.ts
export const authors = new Hono()
  .get('/', (c) => c.json('list authors'))
  .post('/', (c) => c.json('create an author', 201))
  .get('/:id', (c) => c.json(`get ${c.req.param('id')}`))

// books.ts
export const books = new Hono()
  .get('/', (c) => c.json('list books'))
  .post('/', (c) => c.json('create a book', 201))
  .get('/:id', (c) => c.json(`get ${c.req.param('id')}`))

// index.ts
import { authors } from './authors'
import { books } from './books'

const app = new Hono()
const routes = app.route('/authors', authors).route('/books', books)

export default app
export type AppType = typeof routes  // Export the chained result, not app
```

### 6. RPC Performance & Troubleshooting

**IDE slowdown with many routes**: RPC type instantiation runs on every change. Mitigations:

**Pre-compile types (recommended)**:
```ts
import { app } from './app'
import { hc } from 'hono/client'

// Pre-compute type at compile time
export type Client = ReturnType<typeof hc<typeof app>>
export const hcWithType = (...args: Parameters<typeof hc>): Client =>
  hc<typeof app>(...args)

// Usage - IDE stays fast
const client = hcWithType('http://localhost:8787/')
```

**Split clients per sub-app**:
```ts
// authors-cli.ts
import { app as authorsApp } from './authors'
import { hc } from 'hono/client'
const authorsClient = hc<typeof authorsApp>('/authors')

// books-cli.ts
import { app as booksApp } from './books'
import { hc } from 'hono/client'
const booksClient = hc<typeof booksApp>('/books')
```

**Version mismatch**: Backend and frontend must use the same Hono version. Mismatched versions cause "Type instantiation is excessively deep and possibly infinite".

**Monorepo**: Use TypeScript project references so frontend can access backend `AppType`. Tools like `turborepo` help manage dependencies between projects.

## Application Structure Patterns

### Recommended Project Structure

```
src/
├── index.ts          # Main app entry point, routes mounted here
├── routes/
│   ├── authors.ts    # Sub-app for /authors
│   ├── books.ts      # Sub-app for /books
│   └── api.ts        # API version sub-app
├── middleware/
│   ├── auth.ts       # Authentication middleware
│   ├── logger.ts     # Custom logger
│   └── cors.ts       # CORS configuration
├── lib/
│   ├── db.ts         # Database utilities
│   └── validation.ts # Validation schemas
└── types/
    └── env.ts        # Environment type definitions
```

### Example Implementation

```ts
// index.ts
import { Hono } from 'hono'
import { logger } from 'hono/logger'
import { authors } from './routes/authors'
import { books } from './routes/books'
import { api } from './routes/api'

const app = new Hono()

// Global middleware
app.use('*', logger())

// Mount sub-apps
app.route('/authors', authors)
app.route('/books', books)
app.route('/api/v1', api)

// Root route
app.get('/', (c) => c.json({ message: 'Welcome to the API' }))

export default app
```

## Middleware Patterns

### 1. Custom Middleware with createMiddleware

Create type-safe, reusable middleware using `createMiddleware` from `hono/factory`.

```ts
import { createMiddleware } from 'hono/factory'

const logger = createMiddleware(async (c, next) => {
  console.log(`[${c.req.method}] ${c.req.url}`)
  await next()
})

app.use('*', logger)
```

### 2. Parameterized Middleware

Return `createMiddleware` from a function to create configurable middleware.

```ts
import { createMiddleware } from 'hono/factory'

const customLogger = (prefix: string) => {
  return createMiddleware(async (c, next) => {
    console.log(`${prefix}: [${c.req.method}] ${c.req.url}`)
    await next()
  })
}

app.use('*', customLogger('API'))
```

### 3. Environment-Dependent Configuration

Access `c.env` inside middleware to use environment-specific configuration.

```ts
import { jwt } from 'hono/jwt'

app.use('/api/*', async (c, next) => {
  const jwtMiddleware = jwt({
    secret: c.env.JWT_SECRET,  // Access env at runtime
    alg: 'HS256'
  })
  return jwtMiddleware(c, next)
})
```

### 4. Extending Context with Variables

Use type-safe context variables with `createMiddleware` and generics.

```ts
import { createMiddleware } from 'hono/factory'
import type { MiddlewareHandler } from 'hono'

type Env = {
  Variables: {
    user: { id: string; name: string }
  }
}

const authMiddleware: MiddlewareHandler<Env> = createMiddleware(async (c, next) => {
  const user = { id: '123', name: 'John' }
  c.set('user', user) // Type-safe
  await next()
})

app.use('*', authMiddleware)

app.get('/profile', (c) => {
  const user = c.get('user') // Type-safe access
  return c.json(user)
})
```

### 5. Combine Middleware

Use `some()`, `every()`, and `except()` for complex access control patterns.

```ts
import { some, every, except } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { ipRestriction } from 'hono/ip-restriction'

// Allow if either bearer auth OR IP restriction passes
app.use('/api/*', some(
  bearerAuth({ token: 'secret' }),
  ipRestriction({ allowList: ['192.168.1.0/24'] })
))

// Require both bearer auth AND IP restriction
app.use('/admin/*', every(
  bearerAuth({ token: 'admin-secret' }),
  ipRestriction({ allowList: ['192.168.1.100'] })
))

// Apply to all routes except public ones
app.use('*', except(
  '/public/*',
  bearerAuth({ token: 'secret' })
))
```

## Testing Patterns

### 1. app.request() - Main Testing Method

The primary way to test your Hono application is using `app.request()`.

```ts
import { describe, it, expect } from 'vitest'

describe('API Tests', () => {
  // GET request
  it('should get users', async () => {
    const res = await app.request('/users')
    expect(res.status).toBe(200)
    const data = await res.json()
    expect(data).toEqual(['User 1', 'User 2'])
  })

  // POST with JSON
  it('should create user', async () => {
    const res = await app.request('/users', {
      method: 'POST',
      body: JSON.stringify({ name: 'John' }),
      headers: { 'Content-Type': 'application/json' }
    })
    expect(res.status).toBe(201)
  })

  // POST with FormData
  it('should upload file', async () => {
    const formData = new FormData()
    formData.append('file', new Blob(['content']), 'test.txt')

    const res = await app.request('/upload', {
      method: 'POST',
      body: formData
    })
    expect(res.status).toBe(200)
  })

  // With Request object
  it('should handle Request object', async () => {
    const req = new Request('http://localhost/users', {
      method: 'POST',
      headers: { 'Authorization': 'Bearer token' }
    })
    const res = await app.request(req)
    expect(res.status).toBe(200)
  })
})
```

### 2. Mock Environment

Pass a mock environment as the third argument to `app.request()`.

```ts
import { describe, it, expect } from 'vitest'

const mockEnv = {
  API_KEY: 'test-key',
  DB: mockDatabase,
  JWT_SECRET: 'test-secret'
}

describe('Environment Tests', () => {
  it('should use mock environment', async () => {
    const res = await app.request('/protected', {}, mockEnv)
    expect(res.status).toBe(200)
  })

  it('should access mock DB', async () => {
    const res = await app.request('/users/1', {}, mockEnv)
    const data = await res.json()
    expect(data.id).toBe('1')
  })
})
```

### 3. testClient() - Typed Test Client

Use `testClient()` from `hono/testing` for fully typed test clients.

```ts
import { testClient } from 'hono/testing'

const app = new Hono()
  .get('/search', (c) => {
    const query = c.req.query('q')
    return c.json({ results: [query] })
  })
  .post('/posts', (c) => c.json({ id: 1 }))

const client = testClient(app)

describe('Typed Client Tests', () => {
  it('should perform typed GET', async () => {
    const res = await client.search.$get({ query: { q: 'hono' } })
    expect(res.status).toBe(200)
    const data = await res.json()
    expect(data.results).toContain('hono')
  })

  it('should perform typed POST', async () => {
    const res = await client.posts.$post({ json: { title: 'Hello' } })
    const data = await res.json()
    expect(data.id).toBe(1)
  })
})
```

### 4. Vitest Recommended

For testing, Vitest is the recommended framework. For Cloudflare Workers, use `@cloudflare/vitest-pool-workers`.

```bash
npm install -D vitest @cloudflare/vitest-pool-workers
```

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    poolOptions: {
      workers: {
        wrangler: { configPath: './wrangler.toml' },
      },
    },
  },
})
```

## Error Handling Patterns

### 1. HTTPException

Throw `HTTPException` for HTTP errors with custom messages.

```ts
import { HTTPException } from 'hono/http-exception'

app.get('/users/:id', async (c) => {
  const id = c.req.param('id')
  const user = await db.getUser(id)

  if (!user) {
    throw new HTTPException(404, { message: 'User not found' })
  }

  return c.json(user)
})

app.post('/login', async (c) => {
  const { username, password } = await c.req.json()
  const valid = await verifyCredentials(username, password)

  if (!valid) {
    throw new HTTPException(401, {
      message: 'Invalid credentials',
      res: c.json({ error: 'Authentication failed' }, 401)
    })
  }

  return c.json({ token: 'xyz' })
})
```

### 2. Global Error Handler

Handle all errors in one place with `app.onError()`.

```ts
app.onError((err, c) => {
  // Handle HTTPException
  if (err instanceof HTTPException) {
    return err.getResponse()
  }

  // Log unexpected errors
  console.error(`Unexpected error: ${err.message}`, err.stack)

  // Return generic error response
  return c.json(
    {
      error: 'Internal Server Error',
      message: 'Something went wrong'
    },
    500
  )
})
```

### 3. Custom Not Found Handler

Customize the 404 response with `app.notFound()`.

```ts
app.notFound((c) => {
  return c.json(
    {
      message: 'Not Found',
      path: c.req.path
    },
    404
  )
})
```

### 4. Middleware Error Handling

The `next()` function never throws. Hono catches all errors and routes them to `app.onError()`.

```ts
import { createMiddleware } from 'hono/factory'

const errorMiddleware = createMiddleware(async (c, next) => {
  try {
    await next() // Errors caught by Hono
  } catch (err) {
    // This block is rarely needed
    // Hono automatically catches and handles errors
    console.error('Error in middleware:', err)
    throw err // Re-throw to let Hono handle it
  }
})
```

## Authentication Patterns

### 1. JWT with Environment Secret

Use environment variables for JWT secrets to keep them secure.

```ts
import { jwt } from 'hono/jwt'

type Env = {
  Bindings: {
    JWT_SECRET: string
  }
}

const app = new Hono<Env>()

// JWT middleware with env secret
app.use('/api/*', async (c, next) => {
  const jwtMiddleware = jwt({
    secret: c.env.JWT_SECRET,
    alg: 'HS256'
  })
  return jwtMiddleware(c, next)
})

app.get('/api/profile', (c) => {
  const payload = c.get('jwtPayload')
  return c.json({ user: payload })
})

// Login endpoint
app.post('/login', async (c) => {
  const { username, password } = await c.req.json()

  // Verify credentials
  if (await verifyUser(username, password)) {
    const token = await sign(
      { sub: username, exp: Math.floor(Date.now() / 1000) + 60 * 60 },
      c.env.JWT_SECRET
    )
    return c.json({ token })
  }

  throw new HTTPException(401, { message: 'Invalid credentials' })
})
```

### 2. Bearer Token with Multiple Tokens

Use `readToken` for custom token validation and multiple token support.

```ts
import { bearerAuth } from 'hono/bearer-auth'

const tokens = {
  'user-token': { role: 'user' },
  'admin-token': { role: 'admin' }
}

app.use('/api/*', bearerAuth({
  verifyToken: async (token, c) => {
    const tokenData = tokens[token]
    if (tokenData) {
      c.set('tokenData', tokenData)
      return true
    }
    return false
  }
}))

app.get('/api/admin', (c) => {
  const { role } = c.get('tokenData')
  if (role !== 'admin') {
    throw new HTTPException(403, { message: 'Forbidden' })
  }
  return c.json({ message: 'Admin access granted' })
})
```

### 3. IP Restriction + Bearer Auth

Combine multiple authentication methods using `some()` or `every()`.

```ts
import { some, every } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { ipRestriction } from 'hono/ip-restriction'

// Allow access if either condition is met
app.use('/api/*', some(
  bearerAuth({ token: 'secret-token' }),
  ipRestriction({
    allowList: ['192.168.1.0/24', '10.0.0.0/8']
  })
))

// Require both conditions
app.use('/admin/*', every(
  bearerAuth({ token: 'admin-token' }),
  ipRestriction({
    allowList: ['192.168.1.100']
  })
))
```

## Validation Patterns

### 1. Multiple Validators

Validate different parts of a request by chaining validators:

```ts
app.post(
  '/posts/:id',
  validator('param', (value, c) => {
    if (!value.id) return c.text('Missing id', 400)
    return { id: value.id }
  }),
  validator('query', (value, c) => {
    return { draft: value.draft === 'true' }
  }),
  validator('json', (value, c) => {
    if (!value.title) return c.text('Missing title', 400)
    return { title: value.title, body: value.body }
  }),
  (c) => {
    const { id } = c.req.valid('param')
    const { draft } = c.req.valid('query')
    const { title, body } = c.req.valid('json')
    return c.json({ id, draft, title, body })
  }
)
```

Validation targets: `json`, `form`, `query`, `header`, `param`, `cookie`.

### 2. Zod Validator Middleware

The recommended approach for validation with RPC type inference:

```bash
npm i @hono/zod-validator zod
```

```ts
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const route = app.post(
  '/posts',
  zValidator('form', z.object({
    title: z.string().min(1),
    body: z.string(),
  })),
  (c) => {
    const validated = c.req.valid('form')
    return c.json({ ok: true, title: validated.title }, 201)
  }
)

export type AppType = typeof route  // Types flow to RPC client
```

### 3. Standard Schema Validator

Use `@hono/standard-validator` with any Standard Schema-compatible library (Zod, Valibot, ArkType):

```bash
npm i @hono/standard-validator
```

**With Zod:**
```ts
import * as z from 'zod'
import { sValidator } from '@hono/standard-validator'

app.post('/author', sValidator('json', z.object({
  name: z.string(),
  age: z.number(),
})), (c) => {
  const data = c.req.valid('json')
  return c.json({ success: true, message: `${data.name} is ${data.age}` })
})
```

**With Valibot** (lighter alternative):
```ts
import * as v from 'valibot'
import { sValidator } from '@hono/standard-validator'

app.post('/author', sValidator('json', v.object({
  name: v.string(),
  age: v.number(),
})), (c) => {
  const data = c.req.valid('json')
  return c.json({ success: true, message: `${data.name} is ${data.age}` })
})
```

**With ArkType** (TypeScript-native syntax):
```ts
import { type } from 'arktype'
import { sValidator } from '@hono/standard-validator'

app.post('/author', sValidator('json', type({
  name: 'string',
  age: 'number',
})), (c) => {
  const data = c.req.valid('json')
  return c.json({ success: true, message: `${data.name} is ${data.age}` })
})
```

## Streaming Patterns

### 1. SSE (Server-Sent Events)

Stream real-time updates to clients using Server-Sent Events.

```ts
import { streamSSE } from 'hono/streaming'

app.get('/sse', (c) => {
  let id = 0

  return streamSSE(c, async (stream) => {
    while (true) {
      const message = {
        data: JSON.stringify({
          time: new Date().toISOString(),
          value: Math.random()
        }),
        event: 'update',
        id: String(id++)
      }

      await stream.writeSSE(message)
      await stream.sleep(1000)
    }
  })
})

// Client-side
const eventSource = new EventSource('/sse')
eventSource.addEventListener('update', (e) => {
  const data = JSON.parse(e.data)
  console.log('Received:', data)
})
```

### 2. Streaming with Cleanup

Handle stream cleanup and error cases properly.

```ts
import { streamSSE } from 'hono/streaming'

app.get('/sse-with-cleanup', (c) => {
  return streamSSE(c, async (stream) => {
    const interval = setInterval(async () => {
      try {
        await stream.writeSSE({
          data: new Date().toISOString()
        })
      } catch (err) {
        console.error('Stream error:', err)
        clearInterval(interval)
      }
    }, 1000)

    // Cleanup on connection close
    stream.onAbort(() => {
      clearInterval(interval)
      console.log('Stream aborted')
    })
  })
})
```

### 3. Timeout with Streams

You cannot use timeout middleware with streams. Use `setTimeout` and `stream.close()` instead.

```ts
import { stream } from 'hono/streaming'

app.get('/stream-with-timeout', (c) => {
  return stream(c, async (stream) => {
    const timeoutId = setTimeout(() => {
      stream.close()
    }, 30000) // 30 second timeout

    try {
      for (let i = 0; i < 100; i++) {
        await stream.write(new TextEncoder().encode(`Chunk ${i}\n`))
        await stream.sleep(500)
      }
    } finally {
      clearTimeout(timeoutId)
    }
  })
})
```

## TypeScript Patterns

### 1. Environment Generics

Define types for bindings and variables using generics.

```ts
type Bindings = {
  API_KEY: string
  DB: D1Database
  JWT_SECRET: string
}

type Variables = {
  user: { id: string; name: string }
  requestId: string
}

const app = new Hono<{
  Bindings: Bindings
  Variables: Variables
}>()

app.use('*', async (c, next) => {
  c.set('requestId', crypto.randomUUID()) // Type-safe
  await next()
})

app.get('/data', async (c) => {
  const db = c.env.DB // Type: D1Database
  const requestId = c.get('requestId') // Type: string
  return c.json({ requestId })
})
```

### 2. ContextVariableMap - Module Augmentation

Globally extend context variables for middleware that sets variables.

```ts
// types/env.ts
import 'hono'

declare module 'hono' {
  interface ContextVariableMap {
    user: { id: string; name: string }
    requestId: string
  }
}

// Now available in all handlers without generics
app.get('/profile', (c) => {
  const user = c.get('user') // Type-safe globally
  return c.json(user)
})
```

### 3. ContextRenderer - Module Augmentation

Define custom render function types.

```ts
// types/renderer.ts
import 'hono'

declare module 'hono' {
  interface ContextRenderer {
    (content: string, props: { title: string }): Response
  }
}

// middleware/renderer.ts
app.use('*', async (c, next) => {
  c.setRenderer((content, props) => {
    return c.html(`
      <!DOCTYPE html>
      <html>
        <head><title>${props.title}</title></head>
        <body>${content}</body>
      </html>
    `)
  })
  await next()
})

// Now type-safe in routes
app.get('/', (c) => {
  return c.render('<h1>Hello</h1>', { title: 'Home' })
})
```

### 4. Built-in Variable Types

Import and use built-in variable types from Hono middleware.

```ts
import type { JwtVariables } from 'hono/jwt'
import type { TimingVariables } from 'hono/timing'
import type { RequestIdVariables } from 'hono/request-id'

type Variables = JwtVariables & TimingVariables & RequestIdVariables

const app = new Hono<{ Variables: Variables }>()

app.get('/api/data', (c) => {
  const payload = c.get('jwtPayload') // From JwtVariables
  const timing = c.get('timing') // From TimingVariables
  const requestId = c.get('requestId') // From RequestIdVariables
  return c.json({ payload, timing, requestId })
})
```

## Third-Party Middleware Ecosystem

Hono has a rich ecosystem of third-party middleware. Here are the main categories:

### Authentication
- **Auth.js** - Next-generation authentication
- **Clerk** - Complete user management
- **Casbin** - Authorization library
- **Firebase Auth** - Firebase authentication
- **OAuth Providers** - Google, GitHub, etc.
- **OIDC** - OpenID Connect
- **Stytch** - Passwordless auth

### Validators
- **Zod** - TypeScript-first schema validation
- **Valibot** - Lightweight validation
- **ArkType** - Runtime type validation
- **TypeBox** - JSON Schema validator
- **Typia** - Ultra-fast validator
- **Ajv** - JSON Schema validator
- **Class Validator** - Decorator-based validation
- **Conform** - Progressive form validation
- **Effect Schema** - Schema definition and validation

### OpenAPI
- **Zod OpenAPI** - Generate OpenAPI from Zod schemas
- **Swagger UI** - Interactive API documentation
- **Swagger Editor** - Design APIs
- **Scalar** - Beautiful API references
- **Hono OpenAPI** - OpenAPI integration

### Monitoring
- **OpenTelemetry** - Observability framework
- **Prometheus** - Metrics and monitoring
- **Sentry** - Error tracking
- **Highlight.io** - Session replay
- **LogTape** - Structured logging
- **Apitally** - API monitoring

### Server
- **GraphQL Server** - GraphQL API support
- **tRPC Server** - End-to-end type safety
- **Node WebSocket** - WebSocket support

### UI
- **React Renderer** - Render React components
- **React Compat** - React compatibility layer
- **Qwik City** - Qwik framework integration

### Utilities
- **Rate Limiter** - Rate limiting
- **Session** - Session management
- **Event Emitter** - Event-driven patterns
- **Geo** - Geolocation utilities
- **MCP** - Model Context Protocol
- **RONIN** - Database toolkit
- **UA Blocker** - User agent blocking

## create-hono CLI

Quickly scaffold new Hono projects using the official CLI.

### Basic Usage

```bash
# Interactive prompt
npm create hono@latest my-app

# With template
npm create hono@latest my-app -- --template cloudflare-workers

# With automatic install
npm create hono@latest my-app -- --install

# With specific package manager
npm create hono@latest my-app -- --pm pnpm

# Offline mode (use local cache)
npm create hono@latest my-app -- --offline

# Combine options
npm create hono@latest my-app -- --template deno --install --pm bun
```

### Available Templates

- **bun** - Bun runtime
- **cloudflare-workers** - Cloudflare Workers
- **cloudflare-pages** - Cloudflare Pages
- **deno** - Deno runtime
- **fastly** - Fastly Compute
- **netlify** - Netlify Functions
- **nextjs** - Next.js integration
- **nodejs** - Node.js server
- **vercel** - Vercel Functions

### Template Features

Each template includes:
- Pre-configured build setup
- Platform-specific optimizations
- Example routes and middleware
- TypeScript configuration
- Testing setup (where applicable)
- Deployment instructions

### Example: Quick Start with Cloudflare Workers

```bash
npm create hono@latest my-api -- --template cloudflare-workers --install
cd my-api
npm run dev  # Start development server
npm run deploy  # Deploy to Cloudflare
```

## View Transitions (Client Components)

Use the View Transitions API with Hono's client-side JSX for smooth animated transitions.

### 1. Basic View Transition

```tsx
import { useState, startViewTransition } from 'hono/jsx'

export default function App() {
  const [expanded, setExpanded] = useState(false)
  return (
    <button
      onClick={() =>
        startViewTransition(() => setExpanded((s) => !s))
      }
    >
      {expanded ? <LargeView /> : <SmallView />}
    </button>
  )
}
```

### 2. Custom Animations with viewTransition()

Use `viewTransition()` from `hono/jsx/dom/css` to get a unique `view-transition-name` and apply custom keyframes:

```tsx
import { useState, startViewTransition } from 'hono/jsx'
import { viewTransition } from 'hono/jsx/dom/css'
import { css, keyframes, Style } from 'hono/css'

const rotate = keyframes`
  from { rotate: 0deg; }
  to { rotate: 360deg; }
`

export default function App() {
  const [show, setShow] = useState(false)
  const [transitionClass] = useState(() =>
    viewTransition(css`
      ::view-transition-old() { animation-name: ${rotate}; }
      ::view-transition-new() { animation-name: ${rotate}; }
    `)
  )
  return (
    <>
      <Style />
      <button onClick={() => startViewTransition(() => setShow((s) => !s))}>
        Toggle
      </button>
      {show && <div class={css`${transitionClass} width: 600px; height: 600px;`} />}
    </>
  )
}
```

### 3. useViewTransition Hook

Track transition state for conditional styling during animation:

```tsx
import { useState, useViewTransition } from 'hono/jsx'

export default function App() {
  const [isUpdating, startViewTransition] = useViewTransition()
  const [show, setShow] = useState(false)

  return (
    <div>
      <button onClick={() => startViewTransition(() => setShow((s) => !s))}>
        Toggle
      </button>
      {isUpdating && <span>Transitioning...</span>}
      {show && <div>Content</div>}
    </div>
  )
}
```

## Service Worker Pattern

Run Hono applications in the browser as a Service Worker to intercept fetch requests.

### Setup

```ts
// sw.ts - Service Worker
declare const self: ServiceWorkerGlobalScope

import { Hono } from 'hono'
import { handle } from 'hono/service-worker'

const app = new Hono().basePath('/sw')
app.get('/', (c) => c.text('Hello from Service Worker'))
app.get('/api/data', (c) => c.json({ source: 'service-worker' }))

self.addEventListener('fetch', handle(app))
```

Or use the shorter `fire()` helper:

```ts
import { Hono } from 'hono'
import { fire } from 'hono/service-worker'

const app = new Hono().basePath('/sw')
app.get('/', (c) => c.text('Hello World'))

fire(app)
```

### Registration

```ts
// main.ts - Register the service worker
navigator.serviceWorker
  .register('/sw.ts', { scope: '/sw', type: 'module' })
  .then(() => console.log('Service Worker registered'))
  .catch((err) => console.error('Registration failed:', err))
```

### Use Cases

- Offline-first applications
- Client-side API mocking during development
- Request interception and caching
- Progressive Web Apps (PWA)

## Additional Best Practices

### Performance
1. **Chain route definitions** - Enables better tree-shaking
2. **Use RegExpRouter** - Fastest router for production
3. **Minimize middleware** - Only apply where needed
4. **Cache responses** - Use Cloudflare Cache API or similar
5. **Stream large responses** - Don't buffer in memory

### Security
1. **Validate all inputs** - Use Zod or similar validators
2. **Sanitize HTML output** - Use `c.html()` with proper escaping
3. **Set security headers** - Use `secureHeaders` middleware
4. **Rate limit endpoints** - Protect against abuse
5. **Use CORS properly** - Configure allowed origins

### Code Organization
1. **Separate concerns** - Routes, middleware, business logic
2. **Use TypeScript** - Full type safety throughout
3. **Keep routes flat** - Avoid deep nesting
4. **Extract reusable logic** - DRY principle
5. **Document complex logic** - JSDoc comments for clarity

### Development Workflow
1. **Use hot reload** - Fast iteration during development
2. **Write tests early** - Test-driven development
3. **Use linting** - ESLint + Prettier
4. **Type-check regularly** - `tsc --noEmit`
5. **Profile performance** - Use timing middleware

This guide covers the essential patterns for building production-ready Hono applications. Refer to the official Hono documentation for detailed API references and updates.
