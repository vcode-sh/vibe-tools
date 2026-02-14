---
name: hono-guide
description: Guide for Hono, an ultrafast web framework built on Web Standards. Use when user asks to "create a Hono app", "build an API with Hono", "add Hono middleware", "deploy Hono to Cloudflare Workers", "use Hono RPC", "add auth to Hono", "validate requests in Hono", "use Hono JSX", or asks about Hono routing, context, streaming, WebSocket, CORS, testing, SSG, or multi-runtime deployment. Do NOT use for Express.js, Fastify, Koa, or Nest.js.
metadata:
  author: skill-maker
  version: 1.0.0
  hono-version: "4.x"
  source: documentation-analysis
  source-docs: source/hono/
  category: web-framework
  tags: [hono, web-framework, api, cloudflare-workers, bun, deno, nodejs, typescript, edge, serverless]
---

# Hono Guide

Hono is a small, simple, and ultrafast web framework built on Web Standards. It works on any JavaScript runtime: Cloudflare Workers, Bun, Deno, Node.js, AWS Lambda, Vercel, Netlify, Fastly Compute, and more. The same code runs on all platforms.

## Quick Start

```bash
npm create hono@latest my-app
```

```ts
import { Hono } from 'hono'
const app = new Hono()

app.get('/', (c) => c.text('Hello Hono!'))

export default app
```

## Core Concepts

### Routing

```ts
// HTTP methods
app.get('/posts', (c) => c.json({ posts }))
app.post('/posts', (c) => c.json({ message: 'Created' }, 201))
app.put('/posts/:id', (c) => c.json({ message: 'Updated' }))
app.delete('/posts/:id', (c) => c.json({ message: 'Deleted' }))

// Path parameters
app.get('/users/:id', (c) => {
  const id = c.req.param('id')  // inferred type
  return c.json({ id })
})

// Optional params
app.get('/api/animal/:type?', (c) => c.text('Animal!'))

// Wildcard
app.get('/wild/*/card', (c) => c.text('Matched!'))

// Regexp
app.get('/post/:date{[0-9]+}/:title{[a-z]+}', (c) => {
  const { date, title } = c.req.param()
  return c.json({ date, title })
})

// Chained routes
app.get('/endpoint', (c) => c.text('GET'))
   .post((c) => c.text('POST'))
   .delete((c) => c.text('DELETE'))
```

### Context API (c)

The `Context` object provides all request/response methods:

```ts
// Response methods
c.text('Hello')                          // text/plain
c.json({ message: 'Hello' })            // application/json
c.html('<h1>Hello</h1>')                // text/html
c.redirect('/new-path')                  // 302 redirect
c.redirect('/new-path', 301)            // 301 redirect
c.notFound()                             // 404
c.body(data, 200, headers)             // raw response

// Status & headers
c.status(201)
c.header('X-Custom', 'value')

// Request data
c.req.param('id')                       // path param
c.req.query('q')                        // query string
c.req.queries('tags')                   // multiple values
c.req.header('Authorization')           // header
const body = await c.req.json()         // JSON body
const form = await c.req.parseBody()    // form data

// Variables (pass data between middleware and handlers)
c.set('user', userObj)
const user = c.get('user')
// or: c.var.user

// Environment (Cloudflare bindings, env vars)
c.env.MY_KV         // KV namespace
c.env.DATABASE_URL   // env variable
```

### Middleware

Middleware runs before/after handlers in onion-layer order:

```ts
import { logger } from 'hono/logger'
import { cors } from 'hono/cors'
import { basicAuth } from 'hono/basic-auth'

// Apply to all routes
app.use(logger())
app.use(cors())

// Apply to specific paths
app.use('/api/*', cors({ origin: 'https://example.com' }))
app.use('/admin/*', basicAuth({ username: 'admin', password: 'secret' }))

// Custom middleware
app.use(async (c, next) => {
  const start = Date.now()
  await next()
  c.header('X-Response-Time', `${Date.now() - start}ms`)
})
```

**Execution order**: middleware 1 start -> middleware 2 start -> handler -> middleware 2 end -> middleware 1 end

### Built-in Middleware (import from `hono/<name>`)

| Middleware | Import | Purpose |
|---|---|---|
| `basicAuth` | `hono/basic-auth` | HTTP Basic authentication |
| `bearerAuth` | `hono/bearer-auth` | Bearer token authentication |
| `jwt` | `hono/jwt` | JWT authentication |
| `cors` | `hono/cors` | CORS headers |
| `csrf` | `hono/csrf` | CSRF protection |
| `logger` | `hono/logger` | Request logging |
| `secureHeaders` | `hono/secure-headers` | Security headers (Helmet-like) |
| `etag` | `hono/etag` | ETag caching |
| `cache` | `hono/cache` | Cache API (CF Workers, Deno) |
| `compress` | `hono/compress` | Response compression |
| `bodyLimit` | `hono/body-limit` | Request body size limit |
| `timeout` | `hono/timeout` | Request timeout |
| `prettyJSON` | `hono/pretty-json` | Pretty-print JSON with `?pretty` |
| `requestId` | `hono/request-id` | Unique request ID per request |
| `ipRestriction` | `hono/ip-restriction` | IP allow/deny lists |
| `languageDetector` | `hono/language` | i18n language detection |
| `jsxRenderer` | `hono/jsx-renderer` | JSX layout renderer |
| `contextStorage` | `hono/context-storage` | AsyncLocalStorage for Context |
| `methodOverride` | `hono/method-override` | HTTP method override |
| `timing` | `hono/timing` | Server-Timing header |

### Helpers (import from `hono/<name>`)

| Helper | Import | Purpose |
|---|---|---|
| Cookie | `hono/cookie` | get/set/delete cookies |
| JWT | `hono/jwt` | sign/verify/decode JWT |
| Streaming | `hono/streaming` | stream, streamText, streamSSE |
| WebSocket | Platform-specific | upgradeWebSocket handler |
| HTML | `hono/html` | html template literals |
| CSS | `hono/css` | CSS-in-JS(X) |
| Factory | `hono/factory` | createMiddleware, createHandlers |
| Testing | `hono/testing` | testClient for typed testing |
| Proxy | `hono/proxy` | Reverse proxy helper |
| SSG | `hono/ssg` | Static site generation |
| Accepts | `hono/accepts` | Content negotiation (Accept-*) |
| Adapter | `hono/adapter` | env(), getRuntimeKey() |
| ConnInfo | Platform-specific | Client remote address, connection info |
| Dev | `hono/dev` | showRoutes(), getRouterName() |
| Route | `hono/route` | matchedRoutes(), routePath() |

### Larger Applications

Use `app.route()` to split into sub-apps:

```ts
// authors.ts
const authors = new Hono()
  .get('/', (c) => c.json('list authors'))
  .post('/', (c) => c.json('create author', 201))
  .get('/:id', (c) => c.json(`get ${c.req.param('id')}`))
export default authors

// index.ts
import authors from './authors'
import books from './books'

const app = new Hono()
app.route('/authors', authors)
app.route('/books', books)
export default app
```

### Type-Safe RPC

Share API types between server and client:

```ts
// server.ts
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const route = app.post('/posts',
  zValidator('form', z.object({ title: z.string(), body: z.string() })),
  (c) => c.json({ ok: true, message: 'Created!' }, 201)
)
export type AppType = typeof route

// client.ts
import { hc } from 'hono/client'
import type { AppType } from './server'

const client = hc<AppType>('http://localhost:8787/')
const res = await client.posts.$post({
  form: { title: 'Hello', body: 'World' }
})
```

**Key RPC rule**: chain route definitions for type inference to work.

### Validation

```ts
import { validator } from 'hono/validator'

app.post('/posts',
  validator('json', (value, c) => {
    if (!value.title) return c.text('Invalid!', 400)
    return { title: value.title }
  }),
  (c) => {
    const { title } = c.req.valid('json')
    return c.json({ title }, 201)
  }
)
```

Validation targets: `json`, `form`, `query`, `header`, `param`, `cookie`.

### Presets

| Preset | Import | Use Case |
|---|---|---|
| `hono` (default) | `import { Hono } from 'hono'` | Most cases, long-lived servers |
| `hono/quick` | `import { Hono } from 'hono/quick'` | Per-request initialization |
| `hono/tiny` | `import { Hono } from 'hono/tiny'` | Under 14KB, resource-limited |

### Platform Handler Patterns

```ts
// Cloudflare Workers / Bun - export default
export default app

// Node.js
import { serve } from '@hono/node-server'
serve(app)

// AWS Lambda
import { handle } from 'hono/aws-lambda'
export const handler = handle(app)

// Deno
Deno.serve(app.fetch)

// Vercel / Next.js
import { handle } from 'hono/vercel'
export const GET = handle(app)
export const POST = handle(app)

// Netlify
import { handle } from 'hono/netlify'
export default handle(app)
```

### Testing

```ts
// Use app.request() for testing
const res = await app.request('/posts')
expect(res.status).toBe(200)
expect(await res.json()).toEqual({ posts: [] })

// POST with JSON
const res = await app.request('/posts', {
  method: 'POST',
  body: JSON.stringify({ title: 'Hello' }),
  headers: { 'Content-Type': 'application/json' },
})

// Mock env (3rd argument)
const res = await app.request('/posts', {}, { API_KEY: 'test' })
```

## Key Rules

1. **Don't create RoR-like controllers** - define handlers inline for type inference
2. **Chain routes** for RPC type inference to work: `const app = new Hono().get(...).post(...)`
3. **Middleware order matters** - registered first runs first (before next), last (after next)
4. **Export `typeof route`** not `typeof app` for RPC
5. **For RPC with `app.route()`**: chain the `.route()` calls and export the chained result: `const routes = app.route('/a', a).route('/b', b); export type AppType = typeof routes`
6. **Use lowercase header names** when validating headers
7. **Set Content-Type header** when testing `json` or `form` validators
8. **`next()` never throws** - Hono catches errors and passes to `app.onError()`
9. **Route registration order** matters - register sub-routes before mounting with `app.route()`

## Common Errors

1. **Empty body in validator**: Missing `Content-Type` header in request
2. **RPC types not working**: Routes not chained, or Hono version mismatch between client/server
3. **404 on sub-routes**: Routes registered after `app.route()` call (wrong order)
4. **Streaming not working on CF Workers**: Add `c.header('Content-Encoding', 'Identity')`
5. **WebSocket + CORS conflict**: `upgradeWebSocket()` modifies headers internally, conflicts with header-modifying middleware
6. **Slow IDE with RPC**: Too many routes cause excessive type instantiation. Fix: ensure matching Hono versions, split clients per sub-app, or pre-compile types with `hcWithType` pattern (see `references/rpc-validation.md` Section 21)

## Reference Files

- `references/api-reference.md` - Context, HonoRequest, App, HTTPException, Routing
- `references/middleware-auth.md` - Middleware concepts, Auth (Basic, Bearer, JWT, JWK)
- `references/middleware-security.md` - Security (CORS, CSRF, Secure Headers, IP Restriction), Access Control (Combine), Custom Middleware, Best Practices
- `references/middleware-request-response.md` - Request Processing (BodyLimit, Compress, MethodOverride, TrailingSlash), Response Processing (Cache, ETag, PrettyJSON)
- `references/middleware-utilities.md` - Utilities (ContextStorage, Logger, RequestID, Timing, Timeout), Rendering (JSXRenderer), i18n (Language)
- `references/helpers-auth-streaming.md` - Cookie, JWT (sign/verify/decode, all algorithms), Streaming (stream, streamText, streamSSE), WebSocket
- `references/helpers-rendering.md` - HTML (tagged templates, raw, XSS protection), CSS (scoped styles, keyframes, cx, global styles, CSP nonce)
- `references/helpers-factory-testing.md` - Factory, Testing (testClient), Proxy, SSG
- `references/helpers-runtime.md` - Accepts (content negotiation), Adapter (env, getRuntimeKey), ConnInfo, Dev (showRoutes), Route
- `references/platforms-core.md` - Cloudflare Workers, Cloudflare Pages, Bun, Deno, Node.js
- `references/platforms-serverless.md` - AWS Lambda, Lambda@Edge, Vercel, Next.js, Netlify
- `references/platforms-other.md` - Azure, GCR, Fastly, Supabase, Alibaba, Service Worker, WebAssembly, Platform Comparison
- `references/rpc-validation.md` - RPC client, validators, Zod, Standard Schema
- `references/jsx.md` - JSX, Client Components, JSX Renderer, Suspense, streaming
- `references/patterns.md` - Best practices, testing, error handling, validation patterns, RPC troubleshooting (hcWithType), View Transitions, Service Worker
