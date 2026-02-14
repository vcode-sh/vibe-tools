# Hono Request & Response Middleware

Reference for request processing middleware (Body Limit, Compress, Method Override, Trailing Slash) and response processing middleware (Cache, ETag, Pretty JSON).

## Table of Contents

- [Request Processing](#request-processing)
  - [Body Limit](#body-limit)
  - [Compress](#compress)
  - [Method Override](#method-override)
  - [Trailing Slash](#trailing-slash)
- [Response Processing](#response-processing)
  - [Cache](#cache)
  - [ETag](#etag)
  - [Pretty JSON](#pretty-json)

## Request Processing

### Body Limit

Request body size limiting middleware.

**Import:**
```typescript
import { bodyLimit } from 'hono/body-limit'
```

**Basic Usage:**
```typescript
app.use('*', bodyLimit({
  maxSize: 50 * 1024 // 50kb
}))
```

**Options:**

```typescript
type BodyLimitOptions = {
  // Maximum body size in bytes (required)
  // Default: 100 * 1024 (100kb)
  maxSize: number

  // Custom error handler (optional)
  onError?: (c: Context) => Response | Promise<Response>
}
```

**Default Behavior:**
```typescript
// Default is 100kb
app.use('*', bodyLimit({
  maxSize: 100 * 1024
}))
```

**Custom Error Handler:**
```typescript
app.use('*', bodyLimit({
  maxSize: 1024 * 1024, // 1MB
  onError: (c) => {
    return c.json({ error: 'Request body too large. Max 1MB.' }, 413)
  }
}))
```

**Route-Specific Limits:**
```typescript
// 10MB for file uploads
app.use('/upload/*', bodyLimit({
  maxSize: 10 * 1024 * 1024
}))

// 1MB for API
app.use('/api/*', bodyLimit({
  maxSize: 1024 * 1024
}))
```

**Bun-Specific Note:**
When using Bun, also configure `maxRequestBodySize` in `Bun.serve`:

```typescript
Bun.serve({
  port: 3000,
  maxRequestBodySize: 1024 * 1024, // 1MB
  fetch: app.fetch
})
```

---

### Compress

Response compression middleware.

**Import:**
```typescript
import { compress } from 'hono/compress'
```

**Basic Usage:**
```typescript
app.use('*', compress())
```

**Options:**

```typescript
type CompressOptions = {
  // Encoding preference (optional)
  // Default: Uses client's Accept-Encoding header
  encoding?: 'gzip' | 'deflate' | 'br'

  // Minimum response size to compress in bytes (optional)
  // Default: 1024
  threshold?: number
}
```

**Custom Threshold:**
```typescript
// Only compress responses larger than 2KB
app.use('*', compress({
  threshold: 2048
}))
```

**Force Encoding:**
```typescript
// Always use gzip
app.use('*', compress({
  encoding: 'gzip'
}))
```

**Important Notes:**
- **Not needed on Cloudflare Workers** - automatic compression is enabled
- **Not needed on Deno Deploy** - automatic compression is enabled
- Respects `Content-Encoding` if already set
- Skips compression for streaming responses
- Only compresses text-based content types

**Platform-Specific:**
```typescript
// Only use on Node.js, Bun (not Workers/Deno Deploy)
if (process.env.NODE_ENV !== 'production') {
  app.use('*', compress())
}
```

---

### Method Override

HTTP method override middleware.

**Import:**
```typescript
import { methodOverride } from 'hono/method-override'
```

**Basic Usage:**
```typescript
app.use('*', methodOverride({ app }))
```

**Options:**

```typescript
type MethodOverrideOptions = {
  // Hono app instance (required)
  app: Hono

  // Form field name (optional)
  // Default: "_method"
  form?: string

  // Header name (optional)
  // Default: undefined
  header?: string

  // Query parameter name (optional)
  // Default: undefined
  query?: string
}
```

**How It Works:**
Allows clients to override the HTTP method (useful for HTML forms that only support GET/POST):
- Checks form field, header, or query parameter
- Only works with POST requests
- Changes the method for routing purposes

**Form Field Override:**
```typescript
app.use('*', methodOverride({
  app,
  form: '_method'
}))

// HTML form
// <form method="POST" action="/items/123">
//   <input type="hidden" name="_method" value="DELETE">
//   <button>Delete</button>
// </form>
```

**Header Override:**
```typescript
app.use('*', methodOverride({
  app,
  header: 'X-HTTP-Method-Override'
}))

// Client sends:
// POST /items/123
// X-HTTP-Method-Override: DELETE
```

**Query Parameter Override:**
```typescript
app.use('*', methodOverride({
  app,
  query: '_method'
}))

// POST /items/123?_method=DELETE
```

**Multiple Methods:**
```typescript
app.use('*', methodOverride({
  app,
  form: '_method',
  header: 'X-HTTP-Method-Override',
  query: '_method'
}))
```

**Full Example:**
```typescript
const app = new Hono()

app.use('*', methodOverride({ app }))

app.delete('/items/:id', (c) => {
  const id = c.req.param('id')
  return c.text(`Deleted item ${id}`)
})

// HTML form can trigger DELETE:
// <form method="POST" action="/items/123">
//   <input type="hidden" name="_method" value="DELETE">
//   <button>Delete</button>
// </form>
```

---

### Trailing Slash

Trailing slash redirect middleware.

**Import:**
```typescript
import { appendTrailingSlash, trimTrailingSlash } from 'hono/trailing-slash'
```

**Basic Usage:**
```typescript
// Add trailing slash: /path -> /path/
app.use('*', appendTrailingSlash())

// Remove trailing slash: /path/ -> /path
app.use('*', trimTrailingSlash())
```

**How It Works:**
- Only affects GET requests
- Only triggers on 404 (not found)
- Returns 301 redirect to the modified URL
- Does not affect URLs that already have the desired format

**Append Trailing Slash:**
```typescript
app.use('*', appendTrailingSlash())

// GET /about -> 301 redirect to /about/
// GET /about/ -> no redirect (already has trailing slash)
app.get('/about/', (c) => c.text('About page'))
```

**Trim Trailing Slash:**
```typescript
app.use('*', trimTrailingSlash())

// GET /about/ -> 301 redirect to /about
// GET /about -> no redirect (no trailing slash)
app.get('/about', (c) => c.text('About page'))
```

**Important Notes:**
- Place before route definitions
- Only one should be used (append OR trim, not both)
- Helps maintain consistent URL patterns
- Good for SEO (avoids duplicate content)

**Example with Route Patterns:**
```typescript
app.use('*', trimTrailingSlash())

app.get('/users', (c) => c.text('Users list'))
app.get('/users/:id', (c) => c.text(`User ${c.req.param('id')}`))

// GET /users/ -> redirects to /users
// GET /users/123/ -> redirects to /users/123
```

---

## Response Processing

### Cache

HTTP caching middleware for Cloudflare Workers and Deno.

**Import:**
```typescript
import { cache } from 'hono/cache'
```

**Basic Usage:**
```typescript
// Cloudflare Workers
app.get('/api/data', cache({ cacheName: 'my-api' }), async (c) => {
  const data = await fetchData()
  return c.json(data)
})

// Deno (requires wait: true)
app.get('/api/data', cache({
  cacheName: 'my-api',
  wait: true
}), async (c) => {
  const data = await fetchData()
  return c.json(data)
})
```

**Options:**

```typescript
type CacheOptions = {
  // Cache name (required)
  cacheName: string

  // Wait for cache operations to complete (optional)
  // Default: false
  // Required: true for Deno
  wait?: boolean

  // Cache-Control header value (optional)
  // Default: "public, max-age=3600" (1 hour)
  cacheControl?: string

  // Vary header value (optional)
  // Default: undefined
  vary?: string | string[]

  // Custom cache key generator (optional)
  keyGenerator?: (c: Context) => string

  // Cacheable status codes (optional)
  // Default: [200]
  cacheableStatusCodes?: number[]
}
```

**Platform Support:**
- **Cloudflare Workers**: Full support
- **Deno**: Requires `wait: true`
- **Other platforms**: Not supported (middleware will no-op)

**Custom Cache Duration:**
```typescript
app.get('/api/data', cache({
  cacheName: 'api-cache',
  cacheControl: 'public, max-age=7200' // 2 hours
}))
```

**With Vary Header:**
```typescript
app.get('/api/data', cache({
  cacheName: 'api-cache',
  vary: ['Accept-Language', 'Accept-Encoding']
}))
```

**Custom Key Generator:**
```typescript
app.get('/api/data', cache({
  cacheName: 'api-cache',
  keyGenerator: (c) => {
    const userId = c.req.header('X-User-Id')
    return `${c.req.url}-${userId}`
  }
}))
```

**Cache Multiple Status Codes:**
```typescript
app.get('/api/data', cache({
  cacheName: 'api-cache',
  cacheableStatusCodes: [200, 201, 204]
}))
```

**Cloudflare Workers Example:**
```typescript
const app = new Hono()

app.get('/api/posts', cache({
  cacheName: 'posts-cache',
  cacheControl: 'public, max-age=3600'
}), async (c) => {
  const posts = await db.posts.findMany()
  return c.json(posts)
})
```

**Deno Example:**
```typescript
app.get('/api/data', cache({
  cacheName: 'my-cache',
  wait: true, // Required for Deno
  cacheControl: 'public, max-age=1800'
}), async (c) => {
  const data = await fetchData()
  return c.json(data)
})
```

---

### ETag

ETag header generation for caching.

**Import:**
```typescript
import { etag } from 'hono/etag'
```

**Basic Usage:**
```typescript
app.use('*', etag())
```

**Options:**

```typescript
type ETagOptions = {
  // Use weak ETags (optional)
  // Default: false
  weak?: boolean

  // Headers to retain for 304 responses (optional)
  // Default: RETAINED_304_HEADERS
  retainedHeaders?: string[]

  // Custom digest generator (optional)
  // Default: Uses built-in hash function
  generateDigest?: (body: string) => string | Promise<string>
}

// Default retained headers for 304 Not Modified
const RETAINED_304_HEADERS = [
  'cache-control',
  'content-location',
  'date',
  'etag',
  'expires',
  'vary'
]
```

**How It Works:**
- Generates ETag from response body
- Compares with `If-None-Match` request header
- Returns 304 Not Modified if match
- Retains specific headers on 304 response

**Weak ETags:**
```typescript
app.use('*', etag({ weak: true }))

// Generates: ETag: W/"abc123"
// Instead of: ETag: "abc123"
```

**Custom Retained Headers:**
```typescript
app.use('*', etag({
  retainedHeaders: [
    'cache-control',
    'etag',
    'x-custom-header'
  ]
}))
```

**Custom Digest Function:**
```typescript
import { createHash } from 'crypto'

app.use('*', etag({
  generateDigest: (body) => {
    return createHash('sha256').update(body).digest('hex')
  }
}))
```

**Full Example:**
```typescript
app.use('*', etag())

app.get('/api/data', async (c) => {
  const data = await fetchData()
  return c.json(data)
})

// First request:
// Response: 200, ETag: "abc123"

// Second request with If-None-Match: "abc123":
// Response: 304 Not Modified (no body)
```

**With Cache-Control:**
```typescript
app.use('*', etag())

app.get('/api/data', async (c) => {
  const data = await fetchData()
  return c.json(data, {
    headers: {
      'Cache-Control': 'public, max-age=3600'
    }
  })
})
```

---

### Pretty JSON

Pretty-print JSON responses.

**Import:**
```typescript
import { prettyJSON } from 'hono/pretty-json'
```

**Basic Usage:**
```typescript
app.use('*', prettyJSON())

app.get('/api/data', (c) => {
  return c.json({ message: 'Hello', items: [1, 2, 3] })
})

// GET /api/data?pretty
// Response:
// {
//   "message": "Hello",
//   "items": [
//     1,
//     2,
//     3
//   ]
// }
```

**Options:**

```typescript
type PrettyJSONOptions = {
  // Number of spaces for indentation (optional)
  // Default: 2
  space?: number

  // Query parameter name (optional)
  // Default: "pretty"
  query?: string

  // Force pretty printing for all responses (optional)
  // Default: false
  force?: boolean
}
```

**Custom Indentation:**
```typescript
app.use('*', prettyJSON({
  space: 4
}))
```

**Custom Query Parameter:**
```typescript
app.use('*', prettyJSON({
  query: 'format'
}))

// GET /api/data?format
// Pretty prints the response
```

**Force Pretty Print:**
```typescript
// Always pretty print (development mode)
app.use('*', prettyJSON({
  force: true
}))
```

**Conditional Usage:**
```typescript
// Only in development
if (process.env.NODE_ENV === 'development') {
  app.use('*', prettyJSON())
}
```

**Full Example:**
```typescript
const app = new Hono()

app.use('*', prettyJSON())

app.get('/api/users', async (c) => {
  const users = await db.users.findMany()
  return c.json(users)
})

// GET /api/users -> compact JSON
// GET /api/users?pretty -> formatted JSON
```

---
