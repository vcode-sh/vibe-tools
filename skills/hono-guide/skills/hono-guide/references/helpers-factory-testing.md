# Hono Factory, Testing, Proxy & SSG Helpers

Reference for Factory, Testing, Proxy, and SSG helpers.

## Table of Contents

- [Factory Helper](#factory-helper)
- [Testing Helper](#testing-helper)
- [Proxy Helper](#proxy-helper)
- [SSG Helper](#ssg-helper)

---

## Factory Helper

**Import**: `hono/factory`

Utilities for creating type-safe factories, middleware, and handlers.

### Basic Usage

#### `createFactory(options?)`

Create a type-safe factory for your application.

```typescript
import { createFactory } from 'hono/factory'

interface Env {
  Variables: {
    user: { id: string; name: string }
  }
  Bindings: {
    DB: D1Database
  }
}

const factory = createFactory<Env>()
```

### Creating Middleware

#### `createMiddleware(handler)`

Create type-safe middleware with proper typing.

```typescript
import { createFactory } from 'hono/factory'

interface Env {
  Variables: {
    user: { id: string; name: string }
  }
}

const factory = createFactory<Env>()

const authMiddleware = createMiddleware<Env>(async (c, next) => {
  const token = c.req.header('Authorization')

  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }

  // Validate token and set user
  const user = await validateToken(token)
  c.set('user', user)

  await next()
})

// Use middleware
app.use('*', authMiddleware)

app.get('/profile', (c) => {
  const user = c.get('user') // Typed as { id: string; name: string }
  return c.json(user)
})
```

### Creating Handlers

#### `factory.createHandlers()`

Define handlers separately with proper typing.

```typescript
import { createFactory } from 'hono/factory'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const factory = createFactory()

const userSchema = z.object({
  name: z.string(),
  email: z.string().email()
})

const handlers = factory.createHandlers(
  zValidator('json', userSchema),
  async (c) => {
    const data = c.req.valid('json')

    // Create user...

    return c.json({ success: true, data })
  }
)

// Apply handlers to route
app.post('/users', ...handlers)
```

### Creating App

#### `factory.createApp()`

Create a typed Hono instance.

```typescript
import { createFactory } from 'hono/factory'

interface Env {
  Bindings: {
    DB: D1Database
  }
}

const factory = createFactory<Env>()

const app = factory.createApp()

// App has proper Env typing
app.get('/data', async (c) => {
  const db = c.env.DB // Typed as D1Database
  const result = await db.prepare('SELECT * FROM users').all()
  return c.json(result)
})
```

### Init App Option

Automatically initialize middleware for all routes.

```typescript
import { createFactory } from 'hono/factory'

interface Env {
  Variables: {
    db: D1Database
  }
}

const factory = createFactory<Env>({
  initApp: (app) => {
    // This middleware runs automatically on all routes
    app.use('*', async (c, next) => {
      // Set up database connection
      c.set('db', c.env.DB)
      await next()
    })
  }
})

const app = factory.createApp()

// DB is already available
app.get('/users', async (c) => {
  const db = c.get('db') // Already initialized
  const users = await db.prepare('SELECT * FROM users').all()
  return c.json(users)
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { createFactory } from 'hono/factory'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

// Define environment types
interface Env {
  Variables: {
    user: { id: string; name: string; role: string }
    db: D1Database
  }
  Bindings: {
    DB: D1Database
    JWT_SECRET: string
  }
}

// Create factory
const factory = createFactory<Env>({
  initApp: (app) => {
    // Initialize DB for all routes
    app.use('*', async (c, next) => {
      c.set('db', c.env.DB)
      await next()
    })
  }
})

// Create middleware
const authMiddleware = createMiddleware<Env>(async (c, next) => {
  const token = c.req.header('Authorization')?.replace('Bearer ', '')

  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }

  // Verify token
  const payload = await verifyToken(token, c.env.JWT_SECRET)
  c.set('user', payload)

  await next()
})

const adminMiddleware = createMiddleware<Env>(async (c, next) => {
  const user = c.get('user')

  if (user.role !== 'admin') {
    return c.json({ error: 'Forbidden' }, 403)
  }

  await next()
})

// Create handlers
const userSchema = z.object({
  name: z.string(),
  email: z.string().email()
})

const createUserHandlers = factory.createHandlers(
  authMiddleware,
  adminMiddleware,
  zValidator('json', userSchema),
  async (c) => {
    const data = c.req.valid('json')
    const db = c.get('db')

    // Create user in database
    await db.prepare('INSERT INTO users (name, email) VALUES (?, ?)')
      .bind(data.name, data.email)
      .run()

    return c.json({ success: true, data })
  }
)

// Create app
const app = factory.createApp()

// Public routes
app.get('/', (c) => c.text('Welcome'))

// Protected routes
app.post('/users', ...createUserHandlers)

app.get('/profile', authMiddleware, (c) => {
  const user = c.get('user')
  return c.json(user)
})

export default app
```

---

## Testing Helper

**Import**: `hono/testing`

Utilities for testing Hono applications with type-safe test clients.

### Basic Usage

#### `testClient(app)`

Create a type-safe test client from your Hono app.

```typescript
import { Hono } from 'hono'
import { testClient } from 'hono/testing'

const app = new Hono()
  .get('/hello', (c) => c.json({ message: 'Hello' }))
  .post('/users', async (c) => {
    const data = await c.req.json()
    return c.json({ id: 1, ...data })
  })

const client = testClient(app)

// Make requests
const res = await client.hello.$get()
const data = await res.json()
console.log(data.message) // 'Hello'
```

### Type Inference

**IMPORTANT**: You must chain routes for proper type inference.

**BAD - No type inference:**
```typescript
const app = new Hono()

app.get('/users', (c) => c.json({ users: [] }))
app.post('/users', (c) => c.json({ id: 1 }))

const client = testClient(app) // Types not inferred
```

**GOOD - Types inferred:**
```typescript
const app = new Hono()
  .get('/users', (c) => c.json({ users: [] }))
  .post('/users', (c) => c.json({ id: 1 }))

const client = testClient(app) // Fully typed
```

### Making Requests

#### GET Requests

```typescript
const app = new Hono()
  .get('/users/:id', (c) => {
    const id = c.req.param('id')
    return c.json({ id, name: 'John' })
  })

const client = testClient(app)

const res = await client.users[':id'].$get({
  param: { id: '123' }
})

const data = await res.json()
console.log(data.name) // 'John' (typed)
```

#### POST Requests

```typescript
const app = new Hono()
  .post('/users', async (c) => {
    const { name, email } = await c.req.json()
    return c.json({ id: 1, name, email })
  })

const client = testClient(app)

const res = await client.users.$post({
  json: { name: 'John', email: 'john@example.com' }
})

const data = await res.json()
console.log(data.id) // 1 (typed)
```

#### PUT/PATCH Requests

```typescript
const app = new Hono()
  .put('/users/:id', async (c) => {
    const id = c.req.param('id')
    const updates = await c.req.json()
    return c.json({ id, ...updates })
  })

const client = testClient(app)

const res = await client.users[':id'].$put({
  param: { id: '123' },
  json: { name: 'Jane' }
})
```

#### DELETE Requests

```typescript
const app = new Hono()
  .delete('/users/:id', (c) => {
    const id = c.req.param('id')
    return c.json({ deleted: id })
  })

const client = testClient(app)

const res = await client.users[':id'].$delete({
  param: { id: '123' }
})
```

### Headers

Pass headers via the second parameter.

```typescript
const app = new Hono()
  .get('/protected', (c) => {
    const auth = c.req.header('Authorization')
    if (!auth) {
      return c.json({ error: 'Unauthorized' }, 401)
    }
    return c.json({ data: 'secret' })
  })

const client = testClient(app)

const res = await client.protected.$get(
  {},
  {
    headers: {
      Authorization: 'Bearer token123'
    }
  }
)
```

### Init Property

Use `init` property for custom RequestInit options.

```typescript
const res = await client.api.endpoint.$post(
  {
    json: { data: 'value' }
  },
  {
    init: {
      signal: AbortSignal.timeout(5000), // 5 second timeout
      cache: 'no-cache',
      credentials: 'include'
    }
  }
)
```

### Query Parameters

```typescript
const app = new Hono()
  .get('/search', (c) => {
    const q = c.req.query('q')
    const page = c.req.query('page')
    return c.json({ query: q, page })
  })

const client = testClient(app)

const res = await client.search.$get({
  query: {
    q: 'hono',
    page: '1'
  }
})
```

### Complete Testing Example

```typescript
import { Hono } from 'hono'
import { testClient } from 'hono/testing'
import { describe, it, expect } from 'vitest'

const app = new Hono()
  .get('/users', (c) => c.json({ users: [] }))
  .get('/users/:id', (c) => {
    const id = c.req.param('id')
    return c.json({ id, name: 'John' })
  })
  .post('/users', async (c) => {
    const data = await c.req.json()
    return c.json({ id: 1, ...data }, 201)
  })
  .put('/users/:id', async (c) => {
    const id = c.req.param('id')
    const data = await c.req.json()
    return c.json({ id, ...data })
  })
  .delete('/users/:id', (c) => {
    const id = c.req.param('id')
    return c.json({ deleted: id })
  })

const client = testClient(app)

describe('User API', () => {
  it('should list users', async () => {
    const res = await client.users.$get()
    expect(res.status).toBe(200)

    const data = await res.json()
    expect(data.users).toEqual([])
  })

  it('should get user by id', async () => {
    const res = await client.users[':id'].$get({
      param: { id: '123' }
    })

    const data = await res.json()
    expect(data.id).toBe('123')
    expect(data.name).toBe('John')
  })

  it('should create user', async () => {
    const res = await client.users.$post({
      json: {
        name: 'Jane',
        email: 'jane@example.com'
      }
    })

    expect(res.status).toBe(201)

    const data = await res.json()
    expect(data.id).toBe(1)
    expect(data.name).toBe('Jane')
  })

  it('should update user', async () => {
    const res = await client.users[':id'].$put({
      param: { id: '123' },
      json: { name: 'Updated' }
    })

    const data = await res.json()
    expect(data.name).toBe('Updated')
  })

  it('should delete user', async () => {
    const res = await client.users[':id'].$delete({
      param: { id: '123' }
    })

    const data = await res.json()
    expect(data.deleted).toBe('123')
  })

  it('should handle authentication', async () => {
    const protectedApp = new Hono()
      .get('/protected', (c) => {
        const auth = c.req.header('Authorization')
        if (!auth) return c.json({ error: 'Unauthorized' }, 401)
        return c.json({ data: 'secret' })
      })

    const protectedClient = testClient(protectedApp)

    // Without auth
    const res1 = await protectedClient.protected.$get()
    expect(res1.status).toBe(401)

    // With auth
    const res2 = await protectedClient.protected.$get(
      {},
      {
        headers: { Authorization: 'Bearer token' }
      }
    )
    expect(res2.status).toBe(200)
  })
})
```

---

## Proxy Helper

**Import**: `hono/proxy`

Utilities for proxying requests to other servers.

### Basic Usage

#### `proxy(url, options?)`

Proxy requests to a target URL.

```typescript
import { Hono } from 'hono'
import { proxy } from 'hono/proxy'

const app = new Hono()

// Simple proxy
app.get('/api/*', (c) => {
  return proxy('https://api.example.com')
})

// Dynamic URL
app.get('/proxy/:target', (c) => {
  const target = c.req.param('target')
  return proxy(`https://${target}.example.com`)
})
```

### Forwarding Request Data

Pass `c.req` to forward the original request.

```typescript
app.all('/api/*', (c) => {
  return proxy('https://api.example.com', {
    // Forward original request (method, headers, body)
    fetch: (input, init) => {
      return fetch(input, {
        ...init,
        method: c.req.method,
        headers: c.req.raw.headers,
        body: c.req.raw.body
      })
    }
  })
})
```

### Options

#### `customFetch`

Use a custom fetch function.

```typescript
import { proxy } from 'hono/proxy'

app.get('/api/*', (c) => {
  return proxy('https://api.example.com', {
    fetch: async (input, init) => {
      // Add authentication
      const headers = new Headers(init?.headers)
      headers.set('Authorization', 'Bearer token')

      return fetch(input, {
        ...init,
        headers
      })
    }
  })
})
```

#### `strictConnectionProcessing`

Control connection header processing.

```typescript
app.get('/api/*', (c) => {
  return proxy('https://api.example.com', {
    strictConnectionProcessing: true
  })
})
```

### Automatic Handling

The proxy helper automatically:

1. **Replaces Accept-Encoding**: Prevents compression issues
2. **Cleans response headers**: Removes hop-by-hop headers
3. **Preserves cookies**: Forwards Set-Cookie headers
4. **Handles redirects**: Follows redirect responses

### ProxyRequestInit Type

```typescript
interface ProxyRequestInit extends RequestInit {
  fetch?: typeof fetch
  strictConnectionProcessing?: boolean
}
```

### Complete Examples

**API Proxy with Authentication:**
```typescript
import { Hono } from 'hono'
import { proxy } from 'hono/proxy'

const app = new Hono()

app.use('/api/*', async (c, next) => {
  // Verify user token
  const token = c.req.header('Authorization')
  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }

  await next()
})

app.all('/api/*', (c) => {
  const path = c.req.path.replace('/api', '')

  return proxy(`https://backend.example.com${path}`, {
    fetch: async (input, init) => {
      const headers = new Headers(init?.headers)

      // Add backend API key
      headers.set('X-API-Key', c.env.BACKEND_API_KEY)

      // Forward user's auth
      const userAuth = c.req.header('Authorization')
      if (userAuth) {
        headers.set('Authorization', userAuth)
      }

      return fetch(input, {
        ...init,
        method: c.req.method,
        headers,
        body: c.req.raw.body
      })
    }
  })
})

export default app
```

**Load Balancer:**
```typescript
import { Hono } from 'hono'
import { proxy } from 'hono/proxy'

const app = new Hono()

const backends = [
  'https://backend1.example.com',
  'https://backend2.example.com',
  'https://backend3.example.com'
]

let currentBackend = 0

app.all('*', (c) => {
  // Round-robin load balancing
  const backend = backends[currentBackend]
  currentBackend = (currentBackend + 1) % backends.length

  return proxy(backend, {
    fetch: async (input, init) => {
      return fetch(input, {
        ...init,
        method: c.req.method,
        headers: c.req.raw.headers,
        body: c.req.raw.body
      })
    }
  })
})
```

**Caching Proxy:**
```typescript
import { Hono } from 'hono'
import { proxy } from 'hono/proxy'

const app = new Hono()

const cache = new Map<string, { response: Response; expires: number }>()

app.get('/api/*', async (c) => {
  const cacheKey = c.req.url
  const cached = cache.get(cacheKey)

  if (cached && cached.expires > Date.now()) {
    return cached.response.clone()
  }

  const response = await proxy('https://api.example.com', {
    fetch: async (input, init) => {
      return fetch(input, {
        ...init,
        method: c.req.method,
        headers: c.req.raw.headers
      })
    }
  })

  // Cache for 5 minutes
  cache.set(cacheKey, {
    response: response.clone(),
    expires: Date.now() + (5 * 60 * 1000)
  })

  return response
})
```

---

## SSG Helper

**Import**: `hono/ssg`

Static Site Generation utilities for creating static HTML files from Hono routes.

### Basic Usage

#### `toSSG(app, fs, options?)`

Generate static files from your Hono app.

```typescript
import { Hono } from 'hono'
import { toSSG } from 'hono/ssg'
import fs from 'fs/promises'

const app = new Hono()

app.get('/', (c) => c.html('<h1>Home</h1>'))
app.get('/about', (c) => c.html('<h1>About</h1>'))
app.get('/posts/1', (c) => c.html('<h1>Post 1</h1>'))

// Generate static files
await toSSG(app, fs, {
  dir: './dist'
})

// Creates:
// dist/index.html
// dist/about/index.html
// dist/posts/1/index.html
```

### Platform-Specific Imports

Different runtimes require different imports:

```typescript
// Node.js
import { toSSG } from 'hono/ssg'
import fs from 'fs/promises'
await toSSG(app, fs)

// Deno
import { toSSG } from 'hono/deno'
await toSSG(app)

// Bun
import { toSSG } from 'hono/bun'
await toSSG(app)
```

### Options

```typescript
interface SSGOptions {
  dir?: string              // Output directory (default: './dist')
  concurrency?: number      // Parallel generation (default: 4)
  extensionMap?: Record<string, string>  // File extension mapping
  plugins?: SSGPlugin[]     // Custom plugins
}
```

#### Output Directory

```typescript
await toSSG(app, fs, {
  dir: './public'
})
```

#### Concurrency

Control parallel generation for performance.

```typescript
await toSSG(app, fs, {
  dir: './dist',
  concurrency: 8  // Generate 8 pages at once
})
```

#### Extension Mapping

Map content types to file extensions.

```typescript
await toSSG(app, fs, {
  dir: './dist',
  extensionMap: {
    'text/html': '.html',
    'application/json': '.json',
    'text/xml': '.xml'
  }
})
```

### Dynamic Parameters

#### `ssgParams()`

Define dynamic parameters like Next.js `generateStaticParams`.

```typescript
import { Hono } from 'hono'
import { ssgParams } from 'hono/ssg'

const app = new Hono()

app.get(
  '/posts/:id',
  ssgParams(() => [
    { id: '1' },
    { id: '2' },
    { id: '3' }
  ]),
  (c) => {
    const id = c.req.param('id')
    return c.html(`<h1>Post ${id}</h1>`)
  }
)

// Generates:
// dist/posts/1/index.html
// dist/posts/2/index.html
// dist/posts/3/index.html
```

**Async Parameters:**
```typescript
app.get(
  '/posts/:id',
  ssgParams(async () => {
    const posts = await fetchPostsFromDB()
    return posts.map(post => ({ id: post.id }))
  }),
  (c) => {
    const id = c.req.param('id')
    return c.html(`<h1>Post ${id}</h1>`)
  }
)
```

**Multiple Parameters:**
```typescript
app.get(
  '/blog/:category/:slug',
  ssgParams(() => [
    { category: 'tech', slug: 'hello-world' },
    { category: 'tech', slug: 'hono-guide' },
    { category: 'life', slug: 'about-me' }
  ]),
  (c) => {
    const { category, slug } = c.req.param()
    return c.html(`<h1>${category}: ${slug}</h1>`)
  }
)
```

### Excluding Routes

#### `disableSSG()`

Exclude specific routes from SSG.

```typescript
import { disableSSG } from 'hono/ssg'

app.get('/', (c) => c.html('<h1>Home</h1>'))

// This route won't be generated
app.get('/admin', disableSSG(), (c) => {
  return c.html('<h1>Admin</h1>')
})
```

#### `onlySSG()`

Mark routes that should only work during SSG (will be overridden after generation).

```typescript
import { onlySSG } from 'hono/ssg'

app.get('/build-info', onlySSG(), (c) => {
  return c.json({
    timestamp: Date.now(),
    version: '1.0.0'
  })
})

// After SSG, this route returns the static JSON
// At runtime, attempts to access this route will fail
```

### Plugins

Create custom plugins for SSG lifecycle hooks.

```typescript
interface SSGPlugin {
  beforeRequestHook?: BeforeRequestHook
  afterResponseHook?: AfterResponseHook
  afterGenerateHook?: AfterGenerateHook
}

type BeforeRequestHook = (req: Request) => Request | Promise<Request>
type AfterResponseHook = (res: Response) => Response | Promise<Response>
type AfterGenerateHook = (result: SSGResult) => void | Promise<void>
```

#### BeforeRequestHook

Modify requests before processing.

```typescript
const addBaseURL: SSGPlugin = {
  beforeRequestHook: (req) => {
    const url = new URL(req.url)
    url.searchParams.set('ssg', 'true')
    return new Request(url, req)
  }
}

await toSSG(app, fs, {
  dir: './dist',
  plugins: [addBaseURL]
})
```

#### AfterResponseHook

Modify responses after generation.

```typescript
const minifyHTML: SSGPlugin = {
  afterResponseHook: async (res) => {
    if (res.headers.get('content-type')?.includes('text/html')) {
      const html = await res.text()
      const minified = html
        .replace(/\s+/g, ' ')
        .replace(/>\s+</g, '><')

      return new Response(minified, {
        status: res.status,
        headers: res.headers
      })
    }
    return res
  }
}

await toSSG(app, fs, {
  dir: './dist',
  plugins: [minifyHTML]
})
```

#### AfterGenerateHook

Run code after all files are generated.

```typescript
const generateSitemap: SSGPlugin = {
  afterGenerateHook: async (result) => {
    const urls = result.files.map(file => {
      return `https://example.com${file.path}`
    })

    const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  ${urls.map(url => `<url><loc>${url}</loc></url>`).join('\n  ')}
</urlset>`

    await fs.writeFile('./dist/sitemap.xml', sitemap)
  }
}

await toSSG(app, fs, {
  dir: './dist',
  plugins: [generateSitemap]
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { toSSG, ssgParams, disableSSG } from 'hono/ssg'
import fs from 'fs/promises'

const app = new Hono()

// Static pages
app.get('/', (c) => {
  return c.html(`
    <!DOCTYPE html>
    <html>
      <head><title>Home</title></head>
      <body><h1>Welcome</h1></body>
    </html>
  `)
})

app.get('/about', (c) => {
  return c.html(`
    <!DOCTYPE html>
    <html>
      <head><title>About</title></head>
      <body><h1>About Us</h1></body>
    </html>
  `)
})

// Dynamic pages
app.get(
  '/blog/:slug',
  ssgParams(async () => {
    // Fetch from CMS or database
    const posts = [
      { slug: 'first-post' },
      { slug: 'second-post' },
      { slug: 'third-post' }
    ]
    return posts
  }),
  (c) => {
    const slug = c.req.param('slug')
    return c.html(`
      <!DOCTYPE html>
      <html>
        <head><title>${slug}</title></head>
        <body><h1>${slug}</h1></body>
      </html>
    `)
  }
)

// Excluded from SSG
app.get('/admin', disableSSG(), (c) => {
  return c.html('<h1>Admin Panel</h1>')
})

// Generate with plugins
const minifyHTML: SSGPlugin = {
  afterResponseHook: async (res) => {
    if (res.headers.get('content-type')?.includes('text/html')) {
      const html = await res.text()
      const minified = html.replace(/\s+/g, ' ')
      return new Response(minified, res)
    }
    return res
  }
}

await toSSG(app, fs, {
  dir: './dist',
  concurrency: 4,
  plugins: [minifyHTML]
})

console.log('Static site generated!')
```