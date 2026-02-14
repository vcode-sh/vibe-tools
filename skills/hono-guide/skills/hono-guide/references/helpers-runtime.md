# Hono Runtime & Infrastructure Helpers

Reference for Accepts, Adapter, ConnInfo, Dev, and Route helpers.

## Table of Contents

- [Accepts Helper](#accepts-helper)
- [Adapter Helper](#adapter-helper)
- [ConnInfo Helper](#conninfo-helper)
- [Dev Helper](#dev-helper)
- [Route Helper](#route-helper)

---

## Accepts Helper

**Import**: `hono/accepts`

Utilities for content negotiation based on Accept headers.

### Basic Usage

#### `accepts(c, options)`

Perform content negotiation.

```typescript
import { Hono } from 'hono'
import { accepts } from 'hono/accepts'

const app = new Hono()

app.get('/data', (c) => {
  const accept = accepts(c, {
    header: 'Accept',
    supports: ['text/html', 'application/json', 'application/xml'],
    default: 'text/html'
  })

  if (accept === 'application/json') {
    return c.json({ data: 'value' })
  }

  if (accept === 'application/xml') {
    return c.text('<data>value</data>', 200, {
      'Content-Type': 'application/xml'
    })
  }

  return c.html('<h1>Data: value</h1>')
})
```

### Options

```typescript
interface AcceptsOptions {
  header: AcceptHeader           // Header to check
  supports: string[]             // Supported types
  default: string                // Default type
  match?: (supported: string, accepted: string) => boolean  // Custom matcher
}

type AcceptHeader =
  | 'Accept'
  | 'Accept-Encoding'
  | 'Accept-Language'
  | 'Accept-Charset'
```

### Accept Header Types

#### Accept (Content Type)

```typescript
app.get('/api', (c) => {
  const type = accepts(c, {
    header: 'Accept',
    supports: ['application/json', 'text/xml'],
    default: 'application/json'
  })

  if (type === 'text/xml') {
    return c.text('<response>data</response>', 200, {
      'Content-Type': 'text/xml'
    })
  }

  return c.json({ response: 'data' })
})
```

#### Accept-Encoding (Compression)

```typescript
app.get('/file', (c) => {
  const encoding = accepts(c, {
    header: 'Accept-Encoding',
    supports: ['gzip', 'deflate', 'br', 'identity'],
    default: 'identity'
  })

  // Serve compressed version based on encoding
  if (encoding === 'br') {
    return c.body(brotliCompressedData, 200, {
      'Content-Encoding': 'br'
    })
  }

  if (encoding === 'gzip') {
    return c.body(gzipCompressedData, 200, {
      'Content-Encoding': 'gzip'
    })
  }

  return c.body(rawData)
})
```

#### Accept-Language (Localization)

```typescript
app.get('/welcome', (c) => {
  const lang = accepts(c, {
    header: 'Accept-Language',
    supports: ['en', 'es', 'fr', 'de'],
    default: 'en'
  })

  const messages = {
    en: 'Welcome',
    es: 'Bienvenido',
    fr: 'Bienvenue',
    de: 'Willkommen'
  }

  return c.text(messages[lang])
})
```

#### Accept-Charset (Character Encoding)

```typescript
app.get('/text', (c) => {
  const charset = accepts(c, {
    header: 'Accept-Charset',
    supports: ['utf-8', 'iso-8859-1'],
    default: 'utf-8'
  })

  return c.text('Hello', 200, {
    'Content-Type': `text/plain; charset=${charset}`
  })
})
```

### Custom Matcher

Provide a custom matching function.

```typescript
app.get('/api', (c) => {
  const type = accepts(c, {
    header: 'Accept',
    supports: ['application/json', 'application/vnd.api+json'],
    default: 'application/json',
    match: (supported, accepted) => {
      // Custom matching logic
      if (supported === accepted) return true
      if (accepted.includes('*/*')) return true
      if (accepted.startsWith('application/*') && supported.startsWith('application/')) {
        return true
      }
      return false
    }
  })

  return c.json({ type })
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { accepts } from 'hono/accepts'

const app = new Hono()

const data = {
  users: [
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' }
  ]
}

app.get('/users', (c) => {
  // Content negotiation
  const type = accepts(c, {
    header: 'Accept',
    supports: ['application/json', 'text/html', 'text/xml', 'text/csv'],
    default: 'application/json'
  })

  switch (type) {
    case 'application/json':
      return c.json(data)

    case 'text/html':
      const html = `
        <!DOCTYPE html>
        <html>
          <body>
            <h1>Users</h1>
            <ul>
              ${data.users.map(u => `<li>${u.name}</li>`).join('')}
            </ul>
          </body>
        </html>
      `
      return c.html(html)

    case 'text/xml':
      const xml = `<?xml version="1.0"?>
        <users>
          ${data.users.map(u => `<user><id>${u.id}</id><name>${u.name}</name></user>`).join('')}
        </users>`
      return c.text(xml, 200, { 'Content-Type': 'text/xml' })

    case 'text/csv':
      const csv = 'id,name\n' + data.users.map(u => `${u.id},${u.name}`).join('\n')
      return c.text(csv, 200, { 'Content-Type': 'text/csv' })

    default:
      return c.json(data)
  }
})

// Language negotiation
app.get('/', (c) => {
  const lang = accepts(c, {
    header: 'Accept-Language',
    supports: ['en', 'es', 'fr', 'ja'],
    default: 'en'
  })

  const messages = {
    en: { title: 'Welcome', description: 'Hello, World!' },
    es: { title: 'Bienvenido', description: '¡Hola, Mundo!' },
    fr: { title: 'Bienvenue', description: 'Bonjour, le monde!' },
    ja: { title: 'ようこそ', description: 'こんにちは、世界！' }
  }

  const msg = messages[lang]

  return c.html(`
    <!DOCTYPE html>
    <html lang="${lang}">
      <head><title>${msg.title}</title></head>
      <body><h1>${msg.description}</h1></body>
    </html>
  `)
})

export default app
```

---

## Adapter Helper

**Import**: `hono/adapter`

Cross-runtime utilities for accessing environment variables and detecting the runtime.

### Environment Access

#### `env(c, runtime?)`

Get environment variables across all runtimes.

```typescript
import { Hono } from 'hono'
import { env } from 'hono/adapter'

const app = new Hono()

app.get('/', (c) => {
  // Works on all runtimes
  const { DATABASE_URL, API_KEY } = env(c)

  return c.json({
    databaseUrl: DATABASE_URL,
    apiKey: API_KEY
  })
})
```

**With Runtime Hint:**
```typescript
const variables = env(c, 'cloudflare-workers')
// Type-safe access for Cloudflare Workers env
```

### Runtime Detection

#### `getRuntimeKey()`

Detect the current runtime environment.

```typescript
import { getRuntimeKey } from 'hono/adapter'

const runtime = getRuntimeKey()

console.log(runtime)
// Possible values: 'workerd', 'deno', 'bun', 'node', 'edge-light', 'fastly', 'other'
```

### Runtime Keys

The following runtime keys are supported:

```typescript
type Runtime =
  | 'workerd'      // Cloudflare Workers
  | 'deno'         // Deno runtime
  | 'bun'          // Bun runtime
  | 'node'         // Node.js
  | 'edge-light'   // Vercel Edge Runtime
  | 'fastly'       // Fastly Compute
  | 'other'        // Unknown runtime
```

### Runtime-Specific Code

Execute code based on runtime.

```typescript
import { getRuntimeKey } from 'hono/adapter'

const app = new Hono()

app.get('/info', (c) => {
  const runtime = getRuntimeKey()

  switch (runtime) {
    case 'workerd':
      // Cloudflare Workers specific
      return c.json({
        runtime: 'Cloudflare Workers',
        kv: typeof c.env.KV !== 'undefined'
      })

    case 'deno':
      // Deno specific
      return c.json({
        runtime: 'Deno',
        version: Deno.version
      })

    case 'bun':
      // Bun specific
      return c.json({
        runtime: 'Bun',
        version: Bun.version
      })

    case 'node':
      // Node.js specific
      return c.json({
        runtime: 'Node.js',
        version: process.version
      })

    default:
      return c.json({ runtime })
  }
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { env, getRuntimeKey } from 'hono/adapter'

const app = new Hono()

// Environment variables work across all runtimes
app.get('/config', (c) => {
  const { DATABASE_URL, API_KEY, NODE_ENV } = env(c)

  return c.json({
    database: DATABASE_URL ? 'configured' : 'not configured',
    apiKey: API_KEY ? 'present' : 'missing',
    environment: NODE_ENV || 'development'
  })
})

// Runtime-specific features
app.get('/features', (c) => {
  const runtime = getRuntimeKey()
  const variables = env(c)

  const features: Record<string, boolean> = {}

  switch (runtime) {
    case 'workerd':
      features.kv = typeof variables.KV !== 'undefined'
      features.durable_objects = typeof variables.DO !== 'undefined'
      features.r2 = typeof variables.R2 !== 'undefined'
      break

    case 'deno':
      features.deno_kv = typeof Deno.openKv !== 'undefined'
      features.deno_cron = typeof Deno.cron !== 'undefined'
      break

    case 'node':
      features.filesystem = true
      features.child_process = true
      break
  }

  return c.json({
    runtime,
    features
  })
})

// Cross-runtime database connection
app.get('/db', async (c) => {
  const { DATABASE_URL } = env(c)
  const runtime = getRuntimeKey()

  if (!DATABASE_URL) {
    return c.json({ error: 'DATABASE_URL not configured' }, 500)
  }

  // Use appropriate database client based on runtime
  let result

  if (runtime === 'workerd') {
    // Use Cloudflare D1
    const db = c.env.DB
    result = await db.prepare('SELECT 1').first()
  } else {
    // Use standard SQL client
    const { default: postgres } = await import('postgres')
    const sql = postgres(DATABASE_URL)
    result = await sql`SELECT 1`
  }

  return c.json({ connected: true, result })
})

export default app
```

---

## ConnInfo Helper

**Import**: Platform-specific

Get connection information (remote address, port, etc.) with platform-specific implementations.

### Platform-Specific Imports

Different runtimes require different imports:

```typescript
// Cloudflare Workers
import { getConnInfo } from 'hono/cloudflare-workers'

// Deno
import { getConnInfo } from 'hono/deno'

// Bun
import { getConnInfo } from 'hono/bun'

// Vercel
import { getConnInfo } from 'hono/vercel'

// Lambda@Edge
import { getConnInfo } from 'hono/lambda-edge'

// Node.js (requires @hono/node-server)
import { getConnInfo } from '@hono/node-server/conninfo'
```

### Basic Usage

#### `getConnInfo(c)`

Get connection information.

```typescript
import { Hono } from 'hono'
import { getConnInfo } from 'hono/cloudflare-workers'

const app = new Hono()

app.get('/info', (c) => {
  const info = getConnInfo(c)

  return c.json({
    remoteAddr: info.remote.address,
    remotePort: info.remote.port
  })
})
```

### Connection Info Structure

```typescript
interface ConnInfo {
  remote: {
    address?: string        // IP address
    addressType?: string    // 'IPv4' | 'IPv6'
    port?: number           // Port number
  }
}
```

### Use Cases

#### IP-Based Access Control

```typescript
import { getConnInfo } from 'hono/cloudflare-workers'

const ALLOWED_IPS = ['192.168.1.1', '10.0.0.1']

app.use('/admin/*', (c, next) => {
  const info = getConnInfo(c)
  const ip = info.remote.address

  if (!ip || !ALLOWED_IPS.includes(ip)) {
    return c.json({ error: 'Forbidden' }, 403)
  }

  return next()
})
```

#### Rate Limiting by IP

```typescript
import { getConnInfo } from 'hono/cloudflare-workers'

const rateLimits = new Map<string, number[]>()

app.use('*', async (c, next) => {
  const info = getConnInfo(c)
  const ip = info.remote.address

  if (!ip) {
    return next()
  }

  const now = Date.now()
  const requests = rateLimits.get(ip) || []

  // Keep only requests from last minute
  const recentRequests = requests.filter(time => now - time < 60000)

  if (recentRequests.length >= 100) {
    return c.json({ error: 'Rate limit exceeded' }, 429)
  }

  recentRequests.push(now)
  rateLimits.set(ip, recentRequests)

  return next()
})
```

#### Logging

```typescript
import { getConnInfo } from 'hono/cloudflare-workers'

app.use('*', async (c, next) => {
  const info = getConnInfo(c)
  const startTime = Date.now()

  await next()

  const duration = Date.now() - startTime

  console.log({
    method: c.req.method,
    path: c.req.path,
    ip: info.remote.address,
    port: info.remote.port,
    status: c.res.status,
    duration
  })
})
```

#### Geolocation

```typescript
import { getConnInfo } from 'hono/cloudflare-workers'

app.get('/location', async (c) => {
  const info = getConnInfo(c)
  const ip = info.remote.address

  if (!ip) {
    return c.json({ error: 'Could not determine IP' }, 400)
  }

  // Use geolocation service
  const geoResponse = await fetch(`https://ipapi.co/${ip}/json/`)
  const geoData = await geoResponse.json()

  return c.json({
    ip,
    country: geoData.country_name,
    city: geoData.city,
    timezone: geoData.timezone
  })
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { getConnInfo } from 'hono/cloudflare-workers'

const app = new Hono()

// Rate limiting store
const rateLimits = new Map<string, { count: number; resetAt: number }>()

// IP allowlist for admin
const ADMIN_IPS = ['192.168.1.100', '10.0.0.50']

// Logging middleware
app.use('*', async (c, next) => {
  const info = getConnInfo(c)
  const startTime = Date.now()

  console.log({
    event: 'request_start',
    method: c.req.method,
    path: c.req.path,
    ip: info.remote.address,
    addressType: info.remote.addressType
  })

  await next()

  console.log({
    event: 'request_end',
    method: c.req.method,
    path: c.req.path,
    status: c.res.status,
    duration: Date.now() - startTime
  })
})

// Rate limiting middleware
app.use('/api/*', async (c, next) => {
  const info = getConnInfo(c)
  const ip = info.remote.address

  if (!ip) {
    return next()
  }

  const now = Date.now()
  const limit = rateLimits.get(ip)

  if (limit && now < limit.resetAt) {
    if (limit.count >= 100) {
      return c.json({ error: 'Rate limit exceeded' }, 429)
    }
    limit.count++
  } else {
    rateLimits.set(ip, {
      count: 1,
      resetAt: now + 60000 // Reset after 1 minute
    })
  }

  return next()
})

// Admin access control
app.use('/admin/*', (c, next) => {
  const info = getConnInfo(c)
  const ip = info.remote.address

  if (!ip || !ADMIN_IPS.includes(ip)) {
    return c.json({ error: 'Access denied' }, 403)
  }

  return next()
})

// Public routes
app.get('/api/status', (c) => {
  const info = getConnInfo(c)

  return c.json({
    status: 'ok',
    yourIp: info.remote.address,
    addressType: info.remote.addressType
  })
})

// Admin routes
app.get('/admin/dashboard', (c) => {
  return c.json({ message: 'Admin dashboard' })
})

export default app
```

---

## Dev Helper

**Import**: `hono/dev`

Development utilities for debugging and inspecting Hono applications.

### Router Name

#### `getRouterName(app)`

Get the name of the router being used.

```typescript
import { Hono } from 'hono'
import { getRouterName } from 'hono/dev'

const app = new Hono()

const routerName = getRouterName(app)
console.log(routerName)
// Output: 'SmartRouter', 'RegExpRouter', 'TrieRouter', etc.
```

### Show Routes

#### `showRoutes(app, options?)`

Display all registered routes.

```typescript
import { Hono } from 'hono'
import { showRoutes } from 'hono/dev'

const app = new Hono()

app.get('/', (c) => c.text('Home'))
app.get('/users/:id', (c) => c.text('User'))
app.post('/users', (c) => c.text('Create user'))
app.delete('/users/:id', (c) => c.text('Delete user'))

showRoutes(app)

// Output:
// GET     /
// GET     /users/:id
// POST    /users
// DELETE  /users/:id
```

### Options

```typescript
interface ShowRoutesOptions {
  verbose?: boolean     // Show detailed information
  colorize?: boolean    // Use colors in output (default: true)
}
```

#### Verbose Mode

Show additional route information.

```typescript
showRoutes(app, { verbose: true })

// Output includes handlers and middleware:
// GET     / [middleware1, middleware2, handler]
// GET     /users/:id [authMiddleware, handler]
// POST    /users [authMiddleware, validateMiddleware, handler]
```

#### Disable Colors

Turn off colored output.

```typescript
showRoutes(app, { colorize: false })
```

### Use Cases

#### Development Debugging

```typescript
import { Hono } from 'hono'
import { showRoutes } from 'hono/dev'

const app = new Hono()

// Define routes...

if (process.env.NODE_ENV === 'development') {
  console.log('Registered routes:')
  showRoutes(app, { verbose: true })
}

export default app
```

#### Route Documentation

```typescript
import { showRoutes, getRouterName } from 'hono/dev'
import fs from 'fs/promises'

const app = new Hono()

// Define routes...

// Generate route documentation
const routeInfo = {
  router: getRouterName(app),
  routes: [] as string[]
}

// Capture routes
const originalLog = console.log
const logs: string[] = []
console.log = (msg) => logs.push(msg)

showRoutes(app, { colorize: false })

console.log = originalLog
routeInfo.routes = logs

await fs.writeFile(
  'routes.json',
  JSON.stringify(routeInfo, null, 2)
)
```

#### Testing Route Coverage

```typescript
import { describe, it } from 'vitest'
import { showRoutes } from 'hono/dev'

describe('Route Coverage', () => {
  it('should have all expected routes', () => {
    const expectedRoutes = [
      'GET /',
      'GET /users',
      'POST /users',
      'GET /users/:id',
      'PUT /users/:id',
      'DELETE /users/:id'
    ]

    // Capture route output
    const logs: string[] = []
    const originalLog = console.log
    console.log = (msg) => logs.push(msg)

    showRoutes(app, { colorize: false })

    console.log = originalLog

    for (const route of expectedRoutes) {
      expect(logs).toContain(route)
    }
  })
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { showRoutes, getRouterName } from 'hono/dev'
import { logger } from 'hono/logger'
import { cors } from 'hono/cors'

const app = new Hono()

// Middleware
app.use('*', logger())
app.use('/api/*', cors())

// Auth middleware
const auth = async (c, next) => {
  // Authentication logic...
  await next()
}

// Routes
app.get('/', (c) => c.text('Home'))

app.get('/api/users', auth, (c) => c.json({ users: [] }))
app.post('/api/users', auth, (c) => c.json({ created: true }))
app.get('/api/users/:id', auth, (c) => c.json({ id: c.req.param('id') }))
app.put('/api/users/:id', auth, (c) => c.json({ updated: true }))
app.delete('/api/users/:id', auth, (c) => c.json({ deleted: true }))

app.get('/api/posts', (c) => c.json({ posts: [] }))
app.post('/api/posts', auth, (c) => c.json({ created: true }))

// Development info
if (process.env.NODE_ENV === 'development') {
  console.log('\n=== Development Info ===')
  console.log('Router:', getRouterName(app))
  console.log('\nRegistered Routes:')
  showRoutes(app, { verbose: true })
  console.log('=======================\n')
}

export default app
```

---

## Route Helper

**Import**: `hono/route`

Utilities for inspecting route information from within handlers.

### Matched Routes

#### `matchedRoutes(c)`

Get all matched routes for the current request.

```typescript
import { Hono } from 'hono'
import { matchedRoutes } from 'hono/route'

const app = new Hono()

app.use('*', (c, next) => {
  const routes = matchedRoutes(c)
  console.log('Matched routes:', routes)
  return next()
})

app.get('/users/:id', (c) => {
  const routes = matchedRoutes(c)
  // routes: Array of matched route objects
  return c.json({ routes })
})
```

### Route Path

#### `routePath(c, index?)`

Get the current route path pattern.

```typescript
import { Hono } from 'hono'
import { routePath } from 'hono/route'

const app = new Hono()

app.get('/users/:id', (c) => {
  const path = routePath(c)
  console.log(path) // '/users/:id'

  return c.json({ path })
})
```

**With Index:**
```typescript
app.get('/api/users/:id', (c) => {
  const path0 = routePath(c, 0) // First matched route
  const path1 = routePath(c, 1) // Second matched route (if exists)

  return c.json({ path0, path1 })
})
```

### Base Route Path

#### `baseRoutePath(c, index?)`

Get the base path pattern (without parameters resolved).

```typescript
import { Hono } from 'hono'
import { baseRoutePath } from 'hono/route'

const app = new Hono()

const api = new Hono()
api.get('/users/:id', (c) => {
  const base = baseRoutePath(c)
  console.log(base) // '/api/users/:id'

  return c.json({ base })
})

app.route('/api', api)
```

### Base Path

#### `basePath(c)`

Get the base path with embedded parameters resolved.

```typescript
import { Hono } from 'hono'
import { basePath } from 'hono/route'

const app = new Hono()

const userRouter = new Hono()
userRouter.get('/:id/posts', (c) => {
  const base = basePath(c)
  console.log(base) // '/users/123' (with actual id value)

  const id = c.req.param('id')
  return c.json({ base, id })
})

app.route('/users', userRouter)
```

### Use Cases

#### API Versioning

```typescript
import { routePath } from 'hono/route'

const app = new Hono()

app.use('*', (c, next) => {
  const path = routePath(c)

  if (path?.startsWith('/v1/')) {
    c.set('apiVersion', 'v1')
  } else if (path?.startsWith('/v2/')) {
    c.set('apiVersion', 'v2')
  }

  return next()
})

app.get('/v1/users', (c) => {
  const version = c.get('apiVersion')
  return c.json({ version, data: [] })
})
```

#### Logging

```typescript
import { routePath, matchedRoutes } from 'hono/route'

app.use('*', async (c, next) => {
  const startTime = Date.now()
  const path = routePath(c)

  await next()

  console.log({
    method: c.req.method,
    routePath: path,
    actualPath: c.req.path,
    status: c.res.status,
    duration: Date.now() - startTime
  })
})
```

#### Dynamic Route Documentation

```typescript
import { routePath } from 'hono/route'

app.get('*', (c) => {
  const path = routePath(c)

  if (path) {
    // Route exists
    return c.json({
      route: path,
      method: c.req.method
    })
  }

  // 404 - No route matched
  return c.json({ error: 'Not found' }, 404)
})
```

#### Nested Router Context

```typescript
import { basePath, routePath } from 'hono/route'

const app = new Hono()

const createResourceRouter = (resourceName: string) => {
  const router = new Hono()

  router.get('/', (c) => {
    return c.json({
      resource: resourceName,
      basePath: basePath(c),
      routePath: routePath(c)
    })
  })

  router.get('/:id', (c) => {
    return c.json({
      resource: resourceName,
      id: c.req.param('id'),
      basePath: basePath(c),
      routePath: routePath(c)
    })
  })

  return router
}

app.route('/users', createResourceRouter('users'))
app.route('/posts', createResourceRouter('posts'))

// GET /users → { resource: 'users', basePath: '/users', routePath: '/users/' }
// GET /users/123 → { resource: 'users', id: '123', basePath: '/users/123', routePath: '/users/:id' }
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { matchedRoutes, routePath, baseRoutePath, basePath } from 'hono/route'

const app = new Hono()

// Logging middleware
app.use('*', async (c, next) => {
  const startTime = Date.now()
  const route = routePath(c)

  console.log({
    event: 'request_start',
    method: c.req.method,
    path: c.req.path,
    route
  })

  await next()

  console.log({
    event: 'request_end',
    method: c.req.method,
    path: c.req.path,
    route,
    status: c.res.status,
    duration: Date.now() - startTime
  })
})

// API versioning
app.use('/api/*', (c, next) => {
  const route = routePath(c)

  if (route?.startsWith('/api/v1/')) {
    c.set('apiVersion', 'v1')
  } else if (route?.startsWith('/api/v2/')) {
    c.set('apiVersion', 'v2')
  } else {
    c.set('apiVersion', 'unknown')
  }

  return next()
})

// Routes
app.get('/', (c) => {
  return c.json({
    message: 'Home',
    routePath: routePath(c)
  })
})

// Nested routers
const v1Router = new Hono()
v1Router.get('/users/:id', (c) => {
  return c.json({
    version: 'v1',
    userId: c.req.param('id'),
    routePath: routePath(c),
    baseRoutePath: baseRoutePath(c),
    basePath: basePath(c)
  })
})

const v2Router = new Hono()
v2Router.get('/users/:id', (c) => {
  return c.json({
    version: 'v2',
    userId: c.req.param('id'),
    routePath: routePath(c),
    baseRoutePath: baseRoutePath(c),
    basePath: basePath(c)
  })
})

app.route('/api/v1', v1Router)
app.route('/api/v2', v2Router)

// Debug endpoint
app.get('/debug', (c) => {
  return c.json({
    matchedRoutes: matchedRoutes(c),
    routePath: routePath(c),
    baseRoutePath: baseRoutePath(c),
    basePath: basePath(c),
    actualPath: c.req.path,
    method: c.req.method
  })
})

export default app
```