# Hono Security & Custom Middleware

Reference for security middleware (CORS, CSRF, Secure Headers, IP Restriction), access control (Combine), custom middleware creation, third-party middleware, and best practices.

## Table of Contents

- [Security](#security)
  - [CORS](#cors)
  - [CSRF](#csrf)
  - [Secure Headers](#secure-headers)
  - [IP Restriction](#ip-restriction)
- [Access Control](#access-control)
  - [Combine](#combine)
    - [`some()` - Logical OR](#some---logical-or)
    - [`every()` - Logical AND](#every---logical-and)
    - [`except()` - Conditional Skip](#except---conditional-skip)
    - [Complex Combinations](#complex-combinations)
- [Custom Middleware](#custom-middleware)
  - [Creating Custom Middleware](#creating-custom-middleware)
- [Third-Party Middleware](#third-party-middleware)
- [Middleware Best Practices](#middleware-best-practices)
  - [Order Matters](#order-matters)
  - [Use Path Matching](#use-path-matching)
  - [Type Safety](#type-safety)

## Security

### CORS

Cross-Origin Resource Sharing middleware.

**Import:**
```typescript
import { cors } from 'hono/cors'
```

**Basic Usage:**
```typescript
// Allow all origins
app.use('/*', cors())

// Specific origin
app.use('/api/*', cors({
  origin: 'https://example.com'
}))
```

**Options:**

```typescript
type CORSOptions = {
  // Allowed origin(s) (optional)
  // Default: "*"
  // Can be: string, string[], function, or regex
  origin?: string | string[] | ((origin: string) => string | undefined)

  // Allowed HTTP methods (optional)
  // Default: ["GET", "HEAD", "PUT", "POST", "DELETE", "PATCH"]
  allowMethods?: string[]

  // Allowed headers (optional)
  // Default: []
  allowHeaders?: string[]

  // Max age for preflight cache in seconds (optional)
  // Default: undefined
  maxAge?: number

  // Allow credentials (optional)
  // Default: false
  credentials?: boolean

  // Expose headers (optional)
  // Default: []
  exposeHeaders?: string[]
}
```

**Multiple Origins:**
```typescript
app.use('/api/*', cors({
  origin: [
    'https://example.com',
    'https://app.example.com',
    'http://localhost:3000'
  ]
}))
```

**Dynamic Origin:**
```typescript
app.use('/api/*', cors({
  origin: (origin) => {
    // Allow subdomains of example.com
    if (origin.endsWith('.example.com') || origin === 'https://example.com') {
      return origin
    }
    return undefined
  }
}))
```

**With Credentials:**
```typescript
app.use('/api/*', cors({
  origin: 'https://example.com',
  credentials: true,
  allowHeaders: ['Content-Type', 'Authorization'],
  exposeHeaders: ['X-Request-Id']
}))
```

**Dynamic Allow Methods:**
```typescript
app.use('/api/*', cors({
  origin: 'https://example.com',
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE']
}))
```

**Important Note for Vite:**
When using Hono's CORS middleware, disable Vite's built-in CORS:

```typescript
// vite.config.ts
export default defineConfig({
  server: {
    cors: false // Disable Vite CORS
  }
})
```

---

### CSRF

Cross-Site Request Forgery protection.

**Import:**
```typescript
import { csrf } from 'hono/csrf'
```

**Basic Usage:**
```typescript
app.use('*', csrf())
```

**Options:**

```typescript
type CSRFOptions = {
  // Allowed origin(s) (optional)
  // Default: Validates against request's host
  origin?: string | string[] | ((origin: string) => boolean)

  // Validate Sec-Fetch-Site header (optional)
  // Default: true
  secFetchSite?: boolean
}
```

**How It Works:**
- Only checks unsafe HTTP methods (POST, PUT, DELETE, PATCH)
- Only applies to form content types (application/x-www-form-urlencoded, multipart/form-data)
- Checks `Origin` header against allowed origins
- Optionally checks `Sec-Fetch-Site` header is "same-origin"
- JSON requests are not checked (rely on CORS)

**Specific Origin:**
```typescript
app.use('*', csrf({
  origin: 'https://example.com'
}))
```

**Multiple Origins:**
```typescript
app.use('*', csrf({
  origin: [
    'https://example.com',
    'https://app.example.com'
  ]
}))
```

**Dynamic Origin:**
```typescript
app.use('*', csrf({
  origin: (origin) => {
    return origin.endsWith('.example.com')
  }
}))
```

**Disable Sec-Fetch-Site:**
```typescript
app.use('*', csrf({
  secFetchSite: false
}))
```

---

### Secure Headers

Security-focused HTTP headers middleware.

**Import:**
```typescript
import { secureHeaders } from 'hono/secure-headers'
```

**Basic Usage:**
```typescript
// Apply secure defaults
app.use('*', secureHeaders())
```

**Options:**

```typescript
type SecureHeadersOptions = {
  // Content Security Policy (optional)
  // Default: "default-src 'self'"
  contentSecurityPolicy?: string | {
    defaultSrc?: string[]
    scriptSrc?: string[]
    styleSrc?: string[]
    imgSrc?: string[]
    connectSrc?: string[]
    fontSrc?: string[]
    objectSrc?: string[]
    mediaSrc?: string[]
    frameSrc?: string[]
    sandbox?: string[]
    reportUri?: string
    childSrc?: string[]
    formAction?: string[]
    frameAncestors?: string[]
    pluginTypes?: string[]
    baseUri?: string[]
    reportTo?: string
    workerSrc?: string[]
    manifestSrc?: string[]
    prefetchSrc?: string[]
    navigateTo?: string[]
  }

  // Cross-Origin-Embedder-Policy (optional)
  // Default: undefined
  crossOriginEmbedderPolicy?: boolean | 'require-corp' | 'credentialless'

  // Cross-Origin-Opener-Policy (optional)
  // Default: undefined
  crossOriginOpenerPolicy?: boolean | 'same-origin' | 'same-origin-allow-popups' | 'unsafe-none'

  // Cross-Origin-Resource-Policy (optional)
  // Default: undefined
  crossOriginResourcePolicy?: boolean | 'same-origin' | 'same-site' | 'cross-origin'

  // Origin-Agent-Cluster (optional)
  // Default: undefined
  originAgentCluster?: boolean | '?1'

  // Referrer-Policy (optional)
  // Default: undefined
  referrerPolicy?: boolean | 'no-referrer' | 'no-referrer-when-downgrade' | 'same-origin' | 'origin' | 'strict-origin' | 'origin-when-cross-origin' | 'strict-origin-when-cross-origin' | 'unsafe-url'

  // Strict-Transport-Security (optional)
  // Default: "max-age=15552000; includeSubDomains"
  strictTransportSecurity?: string | false

  // X-Content-Type-Options (optional)
  // Default: "nosniff"
  xContentTypeOptions?: boolean | 'nosniff'

  // X-DNS-Prefetch-Control (optional)
  // Default: undefined
  xDnsPrefetchControl?: boolean | 'on' | 'off'

  // X-Download-Options (optional)
  // Default: undefined
  xDownloadOptions?: boolean | 'noopen'

  // X-Frame-Options (optional)
  // Default: "SAMEORIGIN"
  xFrameOptions?: boolean | 'DENY' | 'SAMEORIGIN'

  // X-Permitted-Cross-Domain-Policies (optional)
  // Default: undefined
  xPermittedCrossDomainPolicies?: boolean | 'none' | 'master-only' | 'by-content-type' | 'all'

  // X-XSS-Protection (optional)
  // Default: "0"
  xXssProtection?: boolean | '0' | '1' | '1; mode=block'

  // Permissions-Policy (optional)
  // Default: undefined
  permissionsPolicy?: string | {
    accelerometer?: string[]
    ambientLightSensor?: string[]
    autoplay?: string[]
    battery?: string[]
    camera?: string[]
    displayCapture?: string[]
    documentDomain?: string[]
    encryptedMedia?: string[]
    fullscreen?: string[]
    geolocation?: string[]
    gyroscope?: string[]
    magnetometer?: string[]
    microphone?: string[]
    midi?: string[]
    payment?: string[]
    pictureInPicture?: string[]
    publicKeyCredentialsGet?: string[]
    screenWakeLock?: string[]
    syncXhr?: string[]
    usb?: string[]
    webShare?: string[]
    xrSpatialTracking?: string[]
  }

  // Remove default headers (optional)
  // Default: []
  removeDefaultHeaders?: string[]
}
```

**Type Definitions:**

```typescript
type SecureHeadersVariables = {
  secureHeadersNonce?: string
}

const app = new Hono<{ Variables: SecureHeadersVariables }>()
```

**Custom CSP:**
```typescript
app.use('*', secureHeaders({
  contentSecurityPolicy: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", "'unsafe-inline'", 'cdn.example.com'],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", 'data:', 'https:'],
    connectSrc: ["'self'", 'api.example.com']
  }
}))
```

**CSP with NONCE:**
```typescript
app.use('*', secureHeaders({
  contentSecurityPolicy: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", 'NONCE']
  }
}))

app.get('/', (c) => {
  const nonce = c.get('secureHeadersNonce')
  return c.html(`
    <!DOCTYPE html>
    <html>
      <head>
        <script nonce="${nonce}">
          console.log('This script is allowed')
        </script>
      </head>
      <body>Hello</body>
    </html>
  `)
})
```

**Using `nonce` Attribute in JSX:**
```typescript
app.get('/', (c) => {
  return c.html(
    <html>
      <head>
        <script nonce={c.get('secureHeadersNonce')}>
          console.log('Allowed')
        </script>
      </head>
      <body>Hello</body>
    </html>
  )
})
```

**Permissions Policy:**
```typescript
app.use('*', secureHeaders({
  permissionsPolicy: {
    camera: [],
    microphone: [],
    geolocation: ["'self'"],
    payment: ["'self'", 'payment.example.com']
  }
}))
```

**Strict Configuration:**
```typescript
app.use('*', secureHeaders({
  strictTransportSecurity: 'max-age=63072000; includeSubDomains; preload',
  xFrameOptions: 'DENY',
  xContentTypeOptions: 'nosniff',
  referrerPolicy: 'no-referrer',
  crossOriginEmbedderPolicy: 'require-corp',
  crossOriginOpenerPolicy: 'same-origin',
  crossOriginResourcePolicy: 'same-origin'
}))
```

---

### IP Restriction

IP address-based access control.

**Import:**
```typescript
import { ipRestriction } from 'hono/ip-restriction'

// Platform-specific connInfo imports
import { getConnInfo } from 'hono/cloudflare-workers'
import { getConnInfo } from 'hono/bun'
import { getConnInfo } from 'hono/deno'
```

**Basic Usage:**
```typescript
import { getConnInfo } from 'hono/cloudflare-workers'

app.use('/admin/*', ipRestriction(getConnInfo, {
  allowList: ['192.168.1.1', '10.0.0.0/8']
}))
```

**Options:**
```typescript
type IPRestrictionOptions = {
  // List of denied IP addresses/ranges (optional)
  denyList?: string[]

  // List of allowed IP addresses/ranges (optional)
  allowList?: string[]
}

type IPRestrictionFunction = (
  getConnInfo: (c: Context) => ConnInfo,
  options: IPRestrictionOptions,
  errorHandler?: (c: Context) => Response | Promise<Response>
) => MiddlewareHandler
```

**Supported Formats:**
- IPv4: `192.168.1.1`
- IPv6: `2001:db8::1`
- CIDR notation: `192.168.1.0/24`, `2001:db8::/32`

**Deny List:**
```typescript
app.use('/api/*', ipRestriction(getConnInfo, {
  denyList: [
    '192.168.1.100',
    '10.0.0.0/8',
    '2001:db8::/32'
  ]
}))
```

**Allow List:**
```typescript
app.use('/admin/*', ipRestriction(getConnInfo, {
  allowList: [
    '192.168.1.1',
    '192.168.1.2',
    '10.0.0.0/24'
  ]
}))
```

**Custom Error Handler:**
```typescript
app.use('/admin/*', ipRestriction(
  getConnInfo,
  {
    allowList: ['192.168.1.0/24']
  },
  (c) => {
    return c.json({ error: 'Access denied from your IP' }, 403)
  }
))
```

**Platform Examples:**

```typescript
// Cloudflare Workers
import { getConnInfo } from 'hono/cloudflare-workers'
app.use('/api/*', ipRestriction(getConnInfo, { allowList: ['...'] }))

// Bun
import { getConnInfo } from 'hono/bun'
app.use('/api/*', ipRestriction(getConnInfo, { allowList: ['...'] }))

// Deno
import { getConnInfo } from 'hono/deno'
app.use('/api/*', ipRestriction(getConnInfo, { allowList: ['...'] }))
```

---

## Access Control

### Combine

Complex access control middleware composition.

**Import:**
```typescript
import { some, every, except } from 'hono/combine'
```

**Three Functions:**

```typescript
// Runs middlewares until one succeeds (logical OR)
function some(...middleware: MiddlewareHandler[]): MiddlewareHandler

// Runs all middlewares, all must succeed (logical AND)
function every(...middleware: MiddlewareHandler[]): MiddlewareHandler

// Skips middleware if condition is met
function except(
  condition: (c: Context) => boolean | Promise<boolean>,
  ...middleware: MiddlewareHandler[]
): MiddlewareHandler
```

### `some()` - Logical OR

Runs middlewares until the first one succeeds (doesn't throw an error).

```typescript
import { some } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { basicAuth } from 'hono/basic-auth'

// Allow either bearer token OR basic auth
app.use('/api/*', some(
  bearerAuth({ token: 'secret-token' }),
  basicAuth({ username: 'user', password: 'pass' })
))

app.get('/api/data', (c) => {
  // Accessible with either auth method
  return c.json({ data: '...' })
})
```

**Multiple Auth Methods:**
```typescript
app.use('/api/*', some(
  // Try JWT first
  jwt({ secret: 'jwt-secret' }),
  // Then API key
  bearerAuth({ token: 'api-key' }),
  // Finally basic auth
  basicAuth({ username: 'admin', password: 'secret' })
))
```

### `every()` - Logical AND

Runs all middlewares, all must succeed.

```typescript
import { every } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { ipRestriction } from 'hono/ip-restriction'
import { getConnInfo } from 'hono/cloudflare-workers'

// Require both valid token AND allowed IP
app.use('/admin/*', every(
  bearerAuth({ token: 'admin-token' }),
  ipRestriction(getConnInfo, {
    allowList: ['192.168.1.0/24']
  })
))

app.get('/admin/dashboard', (c) => {
  // Only accessible with token from allowed IP
  return c.json({ admin: 'dashboard' })
})
```

**Multiple Requirements:**
```typescript
app.use('/secure/*', every(
  // Must have valid JWT
  jwt({ secret: 'secret' }),
  // Must pass CSRF check
  csrf(),
  // Must be from allowed origin
  cors({ origin: 'https://example.com' }),
  // Custom middleware: must have admin role
  async (c, next) => {
    const payload = c.get('jwtPayload')
    if (payload.role !== 'admin') {
      return c.json({ error: 'Admin required' }, 403)
    }
    await next()
  }
))
```

### `except()` - Conditional Skip

Skips middleware if condition is true.

```typescript
import { except } from 'hono/combine'
import { jwt } from 'hono/jwt'

// Skip JWT auth for public endpoints
app.use('/api/*', except(
  (c) => c.req.path === '/api/public' || c.req.path === '/api/health',
  jwt({ secret: 'secret' })
))

app.get('/api/public', (c) => {
  // No auth required
  return c.json({ public: 'data' })
})

app.get('/api/private', (c) => {
  // Auth required
  const payload = c.get('jwtPayload')
  return c.json({ user: payload.sub })
})
```

**Skip Auth for Specific Methods:**
```typescript
app.use('/api/posts', except(
  (c) => c.req.method === 'GET',
  jwt({ secret: 'secret' })
))

// GET /api/posts - no auth required
// POST /api/posts - auth required
// PUT /api/posts - auth required
// DELETE /api/posts - auth required
```

**Complex Conditions:**
```typescript
app.use('/api/*', except(
  async (c) => {
    // Skip auth for OPTIONS (CORS preflight)
    if (c.req.method === 'OPTIONS') return true

    // Skip auth for health check
    if (c.req.path === '/api/health') return true

    // Skip auth if has valid API key in query
    const apiKey = c.req.query('key')
    if (apiKey) {
      const isValid = await validateApiKey(apiKey)
      return isValid
    }

    return false
  },
  jwt({ secret: 'secret' })
))
```

### Complex Combinations

Combine all three for sophisticated access control:

```typescript
import { some, every, except } from 'hono/combine'
import { jwt } from 'hono/jwt'
import { bearerAuth } from 'hono/bearer-auth'
import { ipRestriction } from 'hono/ip-restriction'
import { getConnInfo } from 'hono/cloudflare-workers'

// Complex rule:
// - Skip auth for public paths
// - Otherwise require (JWT OR bearer token) AND allowed IP
app.use('/api/*',
  except(
    (c) => c.req.path.startsWith('/api/public'),
    every(
      some(
        jwt({ secret: 'jwt-secret' }),
        bearerAuth({ token: 'api-token' })
      ),
      ipRestriction(getConnInfo, {
        allowList: ['192.168.1.0/24', '10.0.0.0/8']
      })
    )
  )
)
```

**Real-World Example:**
```typescript
// Admin routes: require JWT with admin role AND admin IP
app.use('/admin/*', every(
  jwt({ secret: 'secret' }),
  async (c, next) => {
    const payload = c.get('jwtPayload')
    if (payload.role !== 'admin') {
      return c.json({ error: 'Admin required' }, 403)
    }
    await next()
  },
  ipRestriction(getConnInfo, {
    allowList: ['192.168.1.0/24']
  })
))

// API routes: skip auth for GET, require JWT or API key for others
app.use('/api/*', except(
  (c) => c.req.method === 'GET',
  some(
    jwt({ secret: 'secret' }),
    bearerAuth({ token: 'api-key' })
  )
))

// Public routes: no auth
app.use('/public/*', async (c, next) => {
  await next()
})
```

---

## Custom Middleware

### Creating Custom Middleware

Use `createMiddleware` from `hono/factory` for type-safe middleware:

**Import:**
```typescript
import { createMiddleware } from 'hono/factory'
```

**Basic Custom Middleware:**
```typescript
const customLogger = createMiddleware(async (c, next) => {
  console.log(`Incoming: ${c.req.method} ${c.req.path}`)
  await next()
  console.log(`Outgoing: ${c.res.status}`)
})

app.use('*', customLogger)
```

**Middleware with Options:**
```typescript
type LoggerOptions = {
  prefix?: string
  logBody?: boolean
}

const logger = (options: LoggerOptions = {}) => {
  return createMiddleware(async (c, next) => {
    const { prefix = '[LOG]', logBody = false } = options

    console.log(`${prefix} ${c.req.method} ${c.req.path}`)

    if (logBody && c.req.method !== 'GET') {
      const body = await c.req.json()
      console.log(`${prefix} Body:`, body)
    }

    await next()
    console.log(`${prefix} Status: ${c.res.status}`)
  })
}

app.use('*', logger({ prefix: '[API]', logBody: true }))
```

**Middleware with Context Variables:**
```typescript
type Variables = {
  requestTime: number
  userId?: string
}

const app = new Hono<{ Variables: Variables }>()

const addRequestTime = createMiddleware<{ Variables: Variables }>(async (c, next) => {
  c.set('requestTime', Date.now())
  await next()

  const duration = Date.now() - c.get('requestTime')
  console.log(`Request took ${duration}ms`)
})

app.use('*', addRequestTime)
```

**Early Return Middleware:**
```typescript
const checkMaintenance = createMiddleware(async (c, next) => {
  const isMaintenanceMode = process.env.MAINTENANCE === 'true'

  if (isMaintenanceMode) {
    return c.json({ error: 'Under maintenance' }, 503)
  }

  await next()
})

app.use('*', checkMaintenance)
```

**Async Operations:**
```typescript
const loadUser = createMiddleware(async (c, next) => {
  const userId = c.req.header('X-User-Id')

  if (userId) {
    const user = await db.users.findOne({ id: userId })
    c.set('user', user)
  }

  await next()
})

app.use('/api/*', loadUser)
```

**Modify Response:**
```typescript
const addHeaders = createMiddleware(async (c, next) => {
  await next()

  // Add headers to response
  c.res.headers.set('X-Powered-By', 'Hono')
  c.res.headers.set('X-Request-Id', crypto.randomUUID())
})

app.use('*', addHeaders)
```

**Error Handling:**
```typescript
const errorHandler = createMiddleware(async (c, next) => {
  try {
    await next()
  } catch (error) {
    console.error('Error:', error)

    if (error instanceof ValidationError) {
      return c.json({ error: error.message }, 400)
    }

    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.use('*', errorHandler)
```

**Composition:**
```typescript
const authenticate = createMiddleware(async (c, next) => {
  const token = c.req.header('Authorization')?.replace('Bearer ', '')

  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }

  const payload = await verifyToken(token)
  c.set('user', payload)

  await next()
})

const requireAdmin = createMiddleware(async (c, next) => {
  const user = c.get('user')

  if (user?.role !== 'admin') {
    return c.json({ error: 'Admin required' }, 403)
  }

  await next()
})

// Use together
app.use('/admin/*', authenticate, requireAdmin)
```

**Context Access Inside Middleware Arguments:**

You can access the context from within middleware factory arguments:

```typescript
const withAuth = (getToken: (c: Context) => string) => {
  return createMiddleware(async (c, next) => {
    const token = getToken(c)

    if (!token) {
      return c.json({ error: 'No token' }, 401)
    }

    const user = await verifyToken(token)
    c.set('user', user)

    await next()
  })
}

// Use with different token sources
app.use('/api/*', withAuth((c) => c.req.header('Authorization')?.replace('Bearer ', '')))
app.use('/admin/*', withAuth((c) => c.req.cookie('admin_token')))
```

---

## Third-Party Middleware

Hono has a rich ecosystem of third-party middleware. Common categories:

### Authentication & Authorization
- OAuth providers (Google, GitHub, etc.)
- SAML authentication
- Session management
- Role-based access control (RBAC)

### Database & ORM
- Prisma middleware
- Drizzle integration
- Database connection pooling
- Query logging

### Validation
- Zod validation helpers
- JSON schema validation
- Form validation

### API Features
- GraphQL integration
- tRPC adapter
- REST API helpers
- API versioning

### Observability
- OpenTelemetry
- Sentry integration
- Custom metrics
- Request tracing

### Rate Limiting
- Token bucket
- Sliding window
- Redis-based limiting
- IP-based throttling

### File Handling
- File uploads (multipart)
- Image processing
- Cloud storage integration
- Download helpers

### WebSocket
- WebSocket support
- Server-Sent Events (SSE)
- Real-time helpers

### Templating
- Template engines
- Markdown rendering
- Email templates

### Testing
- Test helpers
- Mock middleware
- Assertion utilities

Find third-party middleware:
- [Hono third-party middleware](https://github.com/honojs/middleware)
- [npm search for "hono-"](https://www.npmjs.com/search?q=hono-)
- Community contributions on GitHub

---

## Middleware Best Practices

### Order Matters

Middleware executes in registration order. Place middleware strategically:

```typescript
// 1. Error handling (outermost)
app.use('*', errorHandler)

// 2. Logging
app.use('*', logger())

// 3. Security headers
app.use('*', secureHeaders())

// 4. CORS
app.use('*', cors())

// 5. Body parsing/limits
app.use('*', bodyLimit({ maxSize: 1024 * 1024 }))

// 6. Compression
app.use('*', compress())

// 7. Authentication
app.use('/api/*', jwt({ secret: 'secret' }))

// 8. Authorization
app.use('/admin/*', requireAdmin)

// 9. Route-specific middleware
app.use('/api/users', rateLimit({ max: 100 }))

// 10. Handlers
app.get('/api/users', handleGetUsers)
```

### Use Path Matching

Apply middleware only where needed:

```typescript
// Global
app.use('*', logger())

// Specific path
app.use('/api/*', authenticate)

// Multiple paths
app.use('/api/*', authenticate)
app.use('/admin/*', authenticate)

// Exclude paths with except
import { except } from 'hono/combine'
app.use('*', except(
  (c) => c.req.path.startsWith('/public'),
  authenticate
))
```

### Type Safety

Always extend Variables for custom middleware:

```typescript
type Variables = {
  user: User
  requestId: string
  db: Database
}

const app = new Hono<{ Variables: Variables }>()

// Middleware is now type-safe
app.use('*', async (c, next) => {
  c.set('requestId', crypto.randomUUID())
  await next()
})

app.get('/', (c) => {
  const requestId = c.get('requestId') // Fully typed
  return c.json({ requestId })
})
```

---

This reference covers Hono security middleware, access control, custom middleware creation, third-party middleware, and best practices.
