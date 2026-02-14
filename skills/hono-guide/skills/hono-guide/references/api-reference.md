# Hono API Reference

Complete reference for Hono's core APIs.

## Context API (c)

The context object passed to handlers and middleware.

### Response Methods

#### c.text()
```typescript
// Return plain text
c.text('Hello World')
c.text('Not Found', 404)
c.text('Created', 201, { 'X-Custom': 'value' })
```

#### c.json()
```typescript
// Return JSON
c.json({ message: 'success' })
c.json({ error: 'not found' }, 404)
c.json({ data: [...] }, 200, { 'X-Total': '100' })
```

#### c.html()
```typescript
// Return HTML
c.html('<h1>Hello</h1>')
c.html('<div>Not Found</div>', 404)
```

#### c.body()
```typescript
// Return with custom body
c.body('Raw body content')
c.body(null, 204)
c.body('Created', 201)
```

#### c.notFound()
```typescript
// Return 404 response
return c.notFound()
```

#### c.redirect()
```typescript
// Redirect (302 by default)
c.redirect('/new-path')
c.redirect('https://example.com', 301)
```

### Headers and Status

#### c.status()
```typescript
// Set status code
c.status(201)
return c.json({ created: true })
```

#### c.header()
```typescript
// Set response header
c.header('X-Custom-Header', 'value')
c.header('X-Rate-Limit', '100')
return c.text('OK')
```

### Variables

#### c.set() / c.get()
```typescript
// Set variable in context
c.set('user', { id: 123 })
c.set('session', sessionData)

// Get variable from context
const user = c.get('user')
const session = c.get('session')
```

#### c.var
```typescript
// Type-safe variable access (with generics)
type Variables = {
  user: User
  token: string
}

app.get('/api', (c) => {
  const user = c.var.user  // Type-safe
  const token = c.var.token
  return c.json({ user })
})
```

### Environment

#### c.env
```typescript
// Access environment variables/bindings
app.get('/api', (c) => {
  const dbUrl = c.env.DATABASE_URL
  const kv = c.env.KV_NAMESPACE
  return c.json({ env: c.env })
})
```

#### c.executionCtx
```typescript
// Cloudflare Workers execution context
c.executionCtx.waitUntil(promise)
c.executionCtx.passThroughOnException()
```

#### c.event
```typescript
// FetchEvent (Cloudflare Workers)
const event = c.event
```

### Rendering

#### c.render()
```typescript
// Render with custom renderer
c.render(<Component />)
c.render('template-name', { data })
```

#### c.setRenderer()
```typescript
// Set custom renderer
c.setRenderer((content) => {
  return c.html(`<layout>${content}</layout>`)
})
```

### Error

#### c.error
```typescript
// Error property (set by error handler)
app.onError((err, c) => {
  console.log(c.error)
  return c.json({ error: err.message }, 500)
})
```

### Response Object

#### c.res
```typescript
// Access/modify current response
app.use(async (c, next) => {
  await next()
  c.res.headers.append('X-Custom', 'value')
})

// Check if response is set
if (c.res) {
  // Response already created
}
```

#### c.newResponse()
```typescript
// Create new Response object
const res = c.newResponse('body', 200, {
  'Content-Type': 'text/plain',
  'X-Custom': 'value'
})
return res
```

## HonoRequest API (c.req)

### Path Parameters

#### param()
```typescript
// Get single path parameter
app.get('/users/:id', (c) => {
  const id = c.req.param('id')
  return c.json({ id })
})

// Get all path parameters
app.get('/posts/:category/:id', (c) => {
  const params = c.req.param()
  // { category: 'tech', id: '123' }
  return c.json(params)
})
```

### Query Parameters

#### query()
```typescript
// Get single query parameter
app.get('/search', (c) => {
  const q = c.req.query('q')
  const page = c.req.query('page')
  return c.json({ q, page })
})

// Get all query parameters
app.get('/filter', (c) => {
  const queries = c.req.query()
  // { name: 'john', age: '25' }
  return c.json(queries)
})
```

#### queries()
```typescript
// Get multiple values for same key
app.get('/tags', (c) => {
  const tags = c.req.queries('tag')
  // ['javascript', 'typescript', 'hono']
  return c.json({ tags })
})
```

### Headers

#### header()
```typescript
// Get single header
app.get('/api', (c) => {
  const auth = c.req.header('Authorization')
  const contentType = c.req.header('content-type')
  return c.json({ auth })
})

// Get all headers
app.get('/headers', (c) => {
  const headers = c.req.header()
  // Returns object with lowercase keys
  return c.json(headers)
})
```

### Request Body

#### parseBody()
```typescript
// Parse form data (including files)
app.post('/upload', async (c) => {
  const body = await c.req.parseBody()
  const file = body.file  // File object
  const name = body.name  // string
  return c.json({ name })
})

// Parse with options
const body = await c.req.parseBody({ all: true })
// Returns arrays for all values

const body = await c.req.parseBody({ dot: true })
// Supports dot notation: user.name, user.email
```

#### json()
```typescript
// Parse JSON body
app.post('/api/users', async (c) => {
  const data = await c.req.json()
  // { name: 'John', email: 'john@example.com' }
  return c.json(data)
})
```

#### text()
```typescript
// Parse text body
app.post('/webhook', async (c) => {
  const text = await c.req.text()
  return c.text(`Received: ${text}`)
})
```

#### arrayBuffer()
```typescript
// Parse binary data
app.post('/binary', async (c) => {
  const buffer = await c.req.arrayBuffer()
  return c.body(null, 200)
})
```

#### blob()
```typescript
// Parse as Blob
app.post('/blob', async (c) => {
  const blob = await c.req.blob()
  return c.json({ size: blob.size })
})
```

#### formData()
```typescript
// Parse as FormData
app.post('/form', async (c) => {
  const formData = await c.req.formData()
  const name = formData.get('name')
  return c.json({ name })
})
```

### Validation

#### valid()
```typescript
// Get validated data (after validator middleware)
app.post('/api/users',
  validator('json', (value, c) => {
    // Validation logic
    return { name: value.name }
  }),
  async (c) => {
    const data = c.req.valid('json')
    // Or: 'form', 'query', 'header', 'param', 'cookie'
    return c.json(data)
  }
)
```

### Request Properties

#### path
```typescript
// Get pathname
app.get('/api/*', (c) => {
  const path = c.req.path
  // '/api/users/123'
  return c.json({ path })
})
```

#### url
```typescript
// Get full URL
app.get('/api', (c) => {
  const url = c.req.url
  // 'https://example.com/api?foo=bar'
  return c.json({ url })
})
```

#### method
```typescript
// Get HTTP method
app.all('/api', (c) => {
  const method = c.req.method
  // 'GET', 'POST', etc.
  return c.json({ method })
})
```

#### raw
```typescript
// Get raw Request object
app.get('/api', (c) => {
  const rawRequest = c.req.raw
  // Standard Request object
  return c.json({ url: rawRequest.url })
})
```

#### cloneRawRequest()
```typescript
import { cloneRawRequest } from 'hono/request'

app.post('/api', async (c) => {
  const cloned = cloneRawRequest(c.req.raw)
  // Clone the raw request (useful for reading body multiple times)
  return c.json({ ok: true })
})
```

## App (Hono) API

### Constructor

```typescript
import { Hono } from 'hono'

// Basic
const app = new Hono()

// With options
const app = new Hono({
  strict: true,  // Strict trailing slash matching
  router: customRouter,  // Custom router implementation
  getPath: (req) => {
    // Custom path extraction (for hostname routing)
    return req.url.replace(/^https?:\/\/[^/]+/, '')
  }
})
```

### HTTP Methods

```typescript
// GET
app.get('/api/users', (c) => c.json([]))

// POST
app.post('/api/users', async (c) => {
  const data = await c.req.json()
  return c.json(data, 201)
})

// PUT
app.put('/api/users/:id', async (c) => {
  const id = c.req.param('id')
  return c.json({ id })
})

// DELETE
app.delete('/api/users/:id', (c) => {
  return c.body(null, 204)
})

// PATCH
app.patch('/api/users/:id', async (c) => {
  return c.json({ updated: true })
})

// Multiple methods
app.on(['GET', 'POST'], '/api/users', (c) => {
  return c.json({ method: c.req.method })
})

// All methods
app.all('/api/*', (c) => {
  return c.json({ path: c.req.path })
})

// Custom method
app.on('CUSTOM', '/api/custom', (c) => {
  return c.text('Custom method')
})
```

### Middleware

```typescript
// Global middleware
app.use('*', async (c, next) => {
  console.log('Before')
  await next()
  console.log('After')
})

// Path-specific middleware
app.use('/api/*', async (c, next) => {
  // Auth logic
  await next()
})

// Multiple handlers
app.use('/api/*', middleware1, middleware2)
```

### Routing

#### route()
```typescript
// Group routes with sub-app
const api = new Hono()
api.get('/users', (c) => c.json([]))
api.get('/posts', (c) => c.json([]))

app.route('/api', api)
// Routes: /api/users, /api/posts
```

#### basePath()
```typescript
// Set base path for all routes
const api = new Hono().basePath('/api/v1')
api.get('/users', (c) => c.json([]))
// Route: /api/v1/users

app.route('/', api)
```

#### mount()
```typescript
// Mount external handler
app.mount('/static', staticHandler)
```

### Request Handling

#### fetch()
```typescript
// Handle request
const response = await app.fetch(request, env, executionContext)
```

#### request()
```typescript
// Testing helper
const res = await app.request('/api/users')
const json = await res.json()

const res = await app.request('/api/users', {
  method: 'POST',
  body: JSON.stringify({ name: 'John' }),
  headers: { 'Content-Type': 'application/json' }
})

// With env
const res = await app.request('/api', {}, { DATABASE_URL: 'url' })
```

### Error Handling

#### notFound()
```typescript
// Custom 404 handler
app.notFound((c) => {
  return c.json({ error: 'Not Found' }, 404)
})
```

#### onError()
```typescript
// Custom error handler
app.onError((err, c) => {
  console.error(err)
  return c.json({
    error: err.message
  }, 500)
})
```

### Generics

```typescript
// Type-safe environment and variables
type Bindings = {
  DATABASE_URL: string
  KV: KVNamespace
}

type Variables = {
  user: User
  session: Session
}

const app = new Hono<{
  Bindings: Bindings
  Variables: Variables
}>()

app.get('/api', (c) => {
  const db = c.env.DATABASE_URL  // Type-safe
  const user = c.var.user  // Type-safe
  return c.json({ user })
})
```

## HTTPException

### Import

```typescript
import { HTTPException } from 'hono/http-exception'
```

### Constructor

```typescript
// Basic usage
throw new HTTPException(404)

// With message
throw new HTTPException(401, {
  message: 'Unauthorized'
})

// With custom response
throw new HTTPException(400, {
  res: new Response('Bad Request', { status: 400 })
})

// With cause
throw new HTTPException(500, {
  message: 'Database error',
  cause: originalError
})
```

### Usage Example

```typescript
app.get('/api/users/:id', async (c) => {
  const user = await findUser(c.req.param('id'))

  if (!user) {
    throw new HTTPException(404, {
      message: 'User not found'
    })
  }

  return c.json(user)
})

app.onError((err, c) => {
  if (err instanceof HTTPException) {
    // Get custom response if provided
    return err.getResponse()
  }
  return c.json({ error: 'Internal Server Error' }, 500)
})
```

### Methods

#### getResponse()
```typescript
// Get the HTTP response
const exception = new HTTPException(404, {
  message: 'Not found'
})
const response = exception.getResponse()
```

## Routing

### Basic Routing

```typescript
// Exact match
app.get('/api/users', (c) => c.json([]))

// Wildcard
app.get('/api/*', (c) => c.json({ wildcard: true }))

// All methods
app.all('/webhook', (c) => c.json({ method: c.req.method }))

// Custom method
app.on('PURGE', '/cache', (c) => c.text('Purged'))

// Multiple methods
app.on(['GET', 'POST'], '/api', (c) => c.json({ ok: true }))

// Multiple paths
app.get(['/api/v1/users', '/api/v2/users'], (c) => c.json([]))
```

### Path Parameters

```typescript
// Named parameter
app.get('/users/:id', (c) => {
  return c.json({ id: c.req.param('id') })
})

// Multiple parameters
app.get('/posts/:category/:id', (c) => {
  const { category, id } = c.req.param()
  return c.json({ category, id })
})

// Optional parameter
app.get('/api/users/:id?', (c) => {
  const id = c.req.param('id')
  return c.json({ id: id || 'all' })
})

// Regexp pattern
app.get('/posts/:id{[0-9]+}', (c) => {
  // Only matches numeric IDs
  return c.json({ id: c.req.param('id') })
})

app.get('/users/:name{[a-z]+}', (c) => {
  // Only matches lowercase letters
  return c.json({ name: c.req.param('name') })
})
```

### Chained Routes

```typescript
app
  .get('/api/users', (c) => c.json([]))
  .post('/api/users', async (c) => {
    const data = await c.req.json()
    return c.json(data, 201)
  })
  .delete('/api/users/:id', (c) => c.body(null, 204))
```

### Grouping Routes

```typescript
// Create sub-app
const apiV1 = new Hono()
apiV1.get('/users', (c) => c.json([]))
apiV1.get('/posts', (c) => c.json([]))

// Mount it
app.route('/api/v1', apiV1)

// Using basePath
const api = new Hono().basePath('/api')
api.get('/users', (c) => c.json([]))
app.route('/', api)
// Route: /api/users
```

### Routing Priority

```typescript
// Routes are matched in registration order
app.get('/api/special', (c) => c.text('Special'))
app.get('/api/:id', (c) => c.text('Dynamic'))

// GET /api/special -> 'Special'
// GET /api/123 -> 'Dynamic'

// Wrong order causes issues
app.get('/api/:id', (c) => c.text('Dynamic'))
app.get('/api/special', (c) => c.text('Special'))
// GET /api/special -> 'Dynamic' (matched first!)
```

### Hostname-based Routing

```typescript
const app = new Hono({
  getPath: (req) => {
    // Extract hostname and path
    const url = new URL(req.url)
    return url.hostname + url.pathname
  }
})

app.get('example.com/', (c) => c.text('example.com'))
app.get('api.example.com/users', (c) => c.json([]))
```

### Wrong Grouping Order

```typescript
// WRONG - causes 404
const app = new Hono()
const api = new Hono()

app.route('/api', api)  // Mounted before routes defined
api.get('/users', (c) => c.json([]))  // Won't work!

// CORRECT
const app = new Hono()
const api = new Hono()

api.get('/users', (c) => c.json([]))  // Define first
app.route('/api', api)  // Then mount
```

## Presets

Hono provides different presets optimized for various use cases.

### Default Preset (hono)

```typescript
import { Hono } from 'hono'

const app = new Hono()
```

**Features:**
- SmartRouter with RegExpRouter + TrieRouter fallback
- Best balance of performance and features
- Suitable for most applications
- Bundle size: ~18-20KB

### Quick Preset (hono/quick)

```typescript
import { Hono } from 'hono/quick'

const app = new Hono()
```

**Features:**
- SmartRouter with LinearRouter + TrieRouter fallback
- Faster startup time
- Good for applications with many routes
- Slightly larger bundle size: ~22-24KB

### Tiny Preset (hono/tiny)

```typescript
import { Hono } from 'hono/tiny'

const app = new Hono()
```

**Features:**
- PatternRouter only
- Minimal bundle size: ~14KB
- No RegExp support in routes
- Best for simple applications with few routes
- Limited to basic path patterns

### Choosing a Preset

```typescript
// Most apps - balanced performance
import { Hono } from 'hono'

// Many routes - faster startup
import { Hono } from 'hono/quick'

// Size-critical - minimal footprint
import { Hono } from 'hono/tiny'
```

## Additional Notes

### Deprecated APIs

#### app.fire()
```typescript
// DEPRECATED - use 'hono/service-worker' instead
// app.fire()  // Don't use

// Use this instead:
import { Hono } from 'hono'
import { handleEvent } from 'hono/service-worker'

const app = new Hono()
addEventListener('fetch', (event) => {
  event.respondWith(handleEvent(event, app))
})
```

### Type Safety

```typescript
// Use generics for full type safety
type Env = {
  Bindings: {
    DB: D1Database
    BUCKET: R2Bucket
  }
  Variables: {
    user: User
    requestId: string
  }
}

const app = new Hono<Env>()

// Fully typed context
app.use('*', async (c, next) => {
  c.set('requestId', crypto.randomUUID())
  await next()
})

app.get('/api', (c) => {
  const db = c.env.DB  // D1Database (typed)
  const requestId = c.var.requestId  // string (typed)
  return c.json({ requestId })
})
```

### Common Patterns

#### Returning Responses

```typescript
// All equivalent
return c.json({ ok: true })
c.json({ ok: true })  // Implicit return in arrow functions

// Setting status then returning
c.status(201)
return c.json({ created: true })

// One-line with status
return c.json({ created: true }, 201)
```

#### Middleware Pattern

```typescript
app.use('*', async (c, next) => {
  // Before request
  const start = Date.now()

  await next()

  // After response
  const duration = Date.now() - start
  c.res.headers.set('X-Response-Time', `${duration}ms`)
})
```

#### Error Handling Pattern

```typescript
app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return err.getResponse()
  }

  console.error('Unexpected error:', err)

  return c.json({
    error: 'Internal Server Error',
    message: err.message
  }, 500)
})
```
