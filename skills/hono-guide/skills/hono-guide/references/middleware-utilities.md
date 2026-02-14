# Hono Utility & Rendering Middleware

Reference for utility middleware (Context Storage, Logger, Request ID, Server Timing, Timeout), rendering middleware (JSX Renderer), and i18n middleware (Language).

## Table of Contents

- [Utilities](#utilities)
  - [Context Storage](#context-storage)
  - [Logger](#logger)
  - [Request ID](#request-id)
  - [Server Timing](#server-timing)
  - [Timeout](#timeout)
- [Rendering](#rendering)
  - [JSX Renderer](#jsx-renderer)
- [Internationalization](#internationalization)
  - [Language](#language)

## Utilities

### Context Storage

Access context from anywhere using AsyncLocalStorage.

**Import:**
```typescript
import { contextStorage, getContext, tryGetContext } from 'hono/context-storage'
```

**Basic Usage:**
```typescript
app.use('*', contextStorage())

app.get('/', async (c) => {
  await processRequest()
  return c.text('Done')
})

async function processRequest() {
  const c = getContext()
  console.log(c.req.url)

  // Can access all context methods
  const user = c.get('user')
  c.set('processed', true)
}
```

**Functions:**

```typescript
// Enable context storage (middleware)
function contextStorage(): MiddlewareHandler

// Get context (throws if not available)
function getContext<T = Context>(): T

// Try to get context (returns undefined if not available)
function tryGetContext<T = Context>(): T | undefined
```

**Cloudflare Workers Requirements:**
Add the `nodejs_compat` compatibility flag:

```toml
# wrangler.toml
compatibility_flags = ["nodejs_compat"]
```

**Type-Safe Context:**
```typescript
type Variables = {
  user: { id: string; name: string }
}

const app = new Hono<{ Variables: Variables }>()

app.use('*', contextStorage())

function getCurrentUser() {
  const c = getContext<Context<{ Variables: Variables }>>()
  return c.get('user')
}
```

**Error Handling:**
```typescript
function maybeDoSomething() {
  const c = tryGetContext()
  if (!c) {
    console.log('No context available')
    return
  }

  console.log('Request URL:', c.req.url)
}
```

**Use Cases:**
- Accessing context in utility functions
- Logging from deep in the call stack
- Passing context to external libraries
- Avoiding prop drilling

**Example with Logging:**
```typescript
app.use('*', contextStorage())

function log(message: string) {
  const c = getContext()
  const requestId = c.get('requestId')
  console.log(`[${requestId}] ${message}`)
}

app.get('/api/data', async (c) => {
  c.set('requestId', crypto.randomUUID())

  log('Fetching data') // Accesses context internally
  const data = await fetchData()

  log('Data fetched')
  return c.json(data)
})
```

---

### Logger

Request logging middleware.

**Import:**
```typescript
import { logger } from 'hono/logger'
```

**Basic Usage:**
```typescript
app.use('*', logger())

// Logs:
// <-- GET /api/users
// --> GET /api/users 200 45ms
```

**Custom Print Function:**

```typescript
type PrintFunc = (str: string, ...rest: string[]) => void

function logger(printFunc?: PrintFunc): MiddlewareHandler
```

**Custom Logger:**
```typescript
app.use('*', logger((str, ...args) => {
  console.log('[APP]', str, ...args)
}))
```

**Structured Logging:**
```typescript
app.use('*', logger((str) => {
  // Parse the log string and create structured logs
  const match = str.match(/(GET|POST|PUT|DELETE|PATCH) (.*?) (\d+) (\d+)ms/)
  if (match) {
    const [, method, path, status, duration] = match
    console.log(JSON.stringify({
      timestamp: new Date().toISOString(),
      method,
      path,
      status: parseInt(status),
      duration: parseInt(duration)
    }))
  } else {
    console.log(str)
  }
}))
```

**Integration with External Logger:**
```typescript
import pino from 'pino'

const log = pino()

app.use('*', logger((str) => {
  log.info(str)
}))
```

**Conditional Logging:**
```typescript
// Only log in development
if (process.env.NODE_ENV === 'development') {
  app.use('*', logger())
}
```

**Log Format:**
- Incoming: `<-- [METHOD] [PATH]`
- Outgoing: `--> [METHOD] [PATH] [STATUS] [DURATION]ms`

---

### Request ID

Generate and attach unique request IDs.

**Import:**
```typescript
import { requestId } from 'hono/request-id'
```

**Basic Usage:**
```typescript
app.use('*', requestId())

app.get('/', (c) => {
  const reqId = c.get('requestId')
  return c.json({ requestId: reqId })
})
```

**Options:**

```typescript
type RequestIdOptions = {
  // Limit ID length (optional)
  // Default: 255
  limitLength?: number

  // Header name to read/write (optional)
  // Default: "X-Request-Id"
  headerName?: string

  // Custom ID generator (optional)
  // Default: crypto.randomUUID()
  generator?: (c: Context) => string
}
```

**Type Definitions:**

```typescript
type RequestIdVariables = {
  requestId: string
}

const app = new Hono<{ Variables: RequestIdVariables }>()
```

**Custom Header Name:**
```typescript
app.use('*', requestId({
  headerName: 'X-Correlation-Id'
}))
```

**Custom Generator:**
```typescript
import { ulid } from 'ulid'

app.use('*', requestId({
  generator: () => ulid()
}))
```

**Platform-Specific IDs:**
```typescript
// Cloudflare Workers - use CF request ID
app.use('*', requestId({
  generator: (c) => c.req.raw.cf?.requestId || crypto.randomUUID()
}))

// Use timestamp + random
app.use('*', requestId({
  generator: () => `${Date.now()}-${Math.random().toString(36).slice(2)}`
}))
```

**Limit Length:**
```typescript
app.use('*', requestId({
  limitLength: 32
}))
```

**How It Works:**
1. Checks if `X-Request-Id` header exists in request
2. If exists, uses that value
3. If not, generates new ID
4. Sets ID in response header and context variable

**Usage with Logging:**
```typescript
app.use('*', requestId())

app.use('*', async (c, next) => {
  const reqId = c.get('requestId')
  console.log(`[${reqId}] ${c.req.method} ${c.req.path}`)
  await next()
})

app.get('/api/data', (c) => {
  const reqId = c.get('requestId')
  // Use in error tracking, logs, etc.
  return c.json({ data: '...', requestId: reqId })
})
```

---

### Server Timing

Server-Timing header for performance measurement.

**Import:**
```typescript
import { timing, setMetric, startTime, endTime } from 'hono/timing'
```

**Basic Usage:**
```typescript
app.use('*', timing())

app.get('/api/data', async (c) => {
  // Manually set metric
  setMetric(c, 'db', 'Database Query', 123.45)

  return c.json({ data: '...' })
})

// Response headers:
// Server-Timing: db;desc="Database Query";dur=123.45, total;dur=150.0
```

**Type Definitions:**

```typescript
type TimingVariables = {
  metric: {
    headers: string[]
    timers: Map<string, Timer>
  }
}

const app = new Hono<{ Variables: TimingVariables }>()
```

**Functions:**

```typescript
// Enable timing middleware
function timing(config?: TimingConfig): MiddlewareHandler

// Set a metric manually
function setMetric(c: Context, name: string, description: string | number, value?: number): void

// Start a timer
function startTime(c: Context, name: string, description?: string): void

// End a timer
function endTime(c: Context, name: string): void

// Wrap function with timing (async)
async function wrapTime<T>(
  c: Context,
  name: string,
  description: string,
  fn: () => Promise<T>
): Promise<T>
```

**Start/End Timing:**
```typescript
app.use('*', timing())

app.get('/api/users', async (c) => {
  startTime(c, 'db', 'Database Query')
  const users = await db.users.findMany()
  endTime(c, 'db')

  startTime(c, 'transform', 'Data Transformation')
  const result = transform(users)
  endTime(c, 'transform')

  return c.json(result)
})

// Response:
// Server-Timing: db;desc="Database Query";dur=45.2, transform;desc="Data Transformation";dur=12.3, total;dur=150.0
```

**Wrap Function:**
```typescript
app.use('*', timing())

app.get('/api/data', async (c) => {
  const users = await wrapTime(c, 'fetch-users', 'Fetch Users', async () => {
    return await db.users.findMany()
  })

  const posts = await wrapTime(c, 'fetch-posts', 'Fetch Posts', async () => {
    return await db.posts.findMany()
  })

  return c.json({ users, posts })
})

// Response:
// Server-Timing: fetch-users;desc="Fetch Users";dur=45.2, fetch-posts;desc="Fetch Posts";dur=23.1, total;dur=150.0
```

**Custom Configuration:**
```typescript
app.use('*', timing({
  // Custom config options
  enabled: process.env.NODE_ENV === 'development'
}))
```

**Real-World Example:**
```typescript
app.use('*', timing())

app.get('/api/dashboard', async (c) => {
  const userId = c.get('userId')

  const [user, stats, notifications] = await Promise.all([
    wrapTime(c, 'user', 'Get User', () => db.users.findOne(userId)),
    wrapTime(c, 'stats', 'Get Stats', () => db.stats.findOne(userId)),
    wrapTime(c, 'notif', 'Get Notifications', () => db.notifications.find(userId))
  ])

  startTime(c, 'render', 'Render Dashboard')
  const html = renderDashboard(user, stats, notifications)
  endTime(c, 'render')

  return c.html(html)
})

// Response:
// Server-Timing: user;desc="Get User";dur=12.3, stats;desc="Get Stats";dur=15.6, notif;desc="Get Notifications";dur=8.2, render;desc="Render Dashboard";dur=5.1, total;dur=200.0
```

---

### Timeout

Request timeout middleware.

**Import:**
```typescript
import { timeout } from 'hono/timeout'
```

**Basic Usage:**
```typescript
// Timeout after 5 seconds
app.use('/api/*', timeout(5000))

app.get('/api/slow', async (c) => {
  await slowOperation()
  return c.json({ done: true })
})
```

**Signature:**

```typescript
function timeout(
  duration: number,
  exception?: () => Response | Promise<Response>
): MiddlewareHandler
```

**Custom Exception:**
```typescript
app.use('/api/*', timeout(
  5000,
  () => new Response('Request timeout', { status: 504 })
))
```

**Using Context in Exception:**
```typescript
app.use('/api/*', timeout(5000, async () => {
  return c.json({ error: 'Request timed out after 5 seconds' }, 504)
}))
```

**Route-Specific Timeouts:**
```typescript
// Short timeout for quick endpoints
app.use('/api/ping', timeout(1000))

// Longer timeout for complex operations
app.use('/api/report', timeout(30000))

// Default timeout for everything else
app.use('/api/*', timeout(10000))
```

**Important Limitations:**
- **Cannot be used with streaming responses**
- Does not work with `c.streamText()`, `c.stream()`, etc.
- Timer starts when request enters middleware

**Example with Error Tracking:**
```typescript
app.use('/api/*', timeout(
  5000,
  () => {
    // Log timeout for monitoring
    console.error('Request timeout:', Date.now())
    return new Response('Gateway Timeout', { status: 504 })
  }
))
```

**Nested Timeouts:**
```typescript
// Global timeout: 30 seconds
app.use('*', timeout(30000))

// Stricter timeout for specific routes: 5 seconds
app.use('/api/quick/*', timeout(5000))

app.get('/api/quick/status', (c) => {
  // Must complete within 5 seconds
  return c.json({ status: 'ok' })
})
```

---

## Rendering

### JSX Renderer

JSX rendering middleware with layout support.

**Import:**
```typescript
import { jsxRenderer, useRequestContext } from 'hono/jsx-renderer'
```

**Basic Usage:**
```typescript
app.use('*', jsxRenderer(({ children }) => {
  return (
    <html>
      <head>
        <title>My App</title>
      </head>
      <body>{children}</body>
    </html>
  )
}))

app.get('/', (c) => {
  return c.render(<h1>Hello</h1>)
})

// Renders:
// <html><head><title>My App</title></head><body><h1>Hello</h1></body></html>
```

**Options:**

```typescript
type JSXRendererOptions = {
  // DOCTYPE string (optional)
  // Default: "<!DOCTYPE html>"
  docType?: string | boolean

  // Enable streaming (optional)
  // Default: false
  stream?: boolean
}

function jsxRenderer(
  component: (props: { children?: any; Layout?: any }) => JSX.Element,
  options?: JSXRendererOptions
): MiddlewareHandler
```

**Custom DOCTYPE:**
```typescript
app.use('*', jsxRenderer(
  ({ children }) => (
    <html>
      <body>{children}</body>
    </html>
  ),
  { docType: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN">' }
))
```

**Disable DOCTYPE:**
```typescript
app.use('*', jsxRenderer(
  ({ children }) => <fragment>{children}</fragment>,
  { docType: false }
))
```

**Streaming:**
```typescript
app.use('*', jsxRenderer(
  ({ children }) => (
    <html>
      <body>{children}</body>
    </html>
  ),
  { stream: true }
))
```

**Accessing Context:**

```typescript
function useRequestContext<T = Context>(): T
```

```typescript
const Layout = ({ children }) => {
  const c = useRequestContext()
  const title = c.req.query('title') || 'Default Title'

  return (
    <html>
      <head>
        <title>{title}</title>
      </head>
      <body>
        <header>
          <a href="/">Home</a>
        </header>
        {children}
      </body>
    </html>
  )
}

app.use('*', jsxRenderer(Layout))

app.get('/', (c) => {
  return c.render(
    <div>
      <h1>Welcome</h1>
    </div>
  )
})
```

**Nested Layouts:**

```typescript
// Base layout
const Layout = ({ children }) => (
  <html>
    <head>
      <meta charset="utf-8" />
    </head>
    <body>{children}</body>
  </html>
)

app.use('*', jsxRenderer(Layout))

// Admin layout (nested)
const AdminLayout = ({ children }) => {
  const c = useRequestContext()
  return c.render(
    <div class="admin">
      <nav>Admin Navigation</nav>
      <main>{children}</main>
    </div>
  )
}

app.use('/admin/*', jsxRenderer(AdminLayout))

app.get('/admin/dashboard', (c) => {
  return c.render(<h1>Dashboard</h1>)
})

// Renders:
// <html>
//   <head><meta charset="utf-8" /></head>
//   <body>
//     <div class="admin">
//       <nav>Admin Navigation</nav>
//       <main><h1>Dashboard</h1></main>
//     </div>
//   </body>
// </html>
```

**Using Layout Prop:**

```typescript
const Layout = ({ children }) => (
  <html>
    <body>{children}</body>
  </html>
)

const SubLayout = ({ children, Layout }) => {
  return (
    <Layout>
      <div class="sub-layout">
        {children}
      </div>
    </Layout>
  )
}

app.use('*', jsxRenderer(Layout))
app.use('/sub/*', jsxRenderer(SubLayout))
```

**Extending ContextRenderer:**

```typescript
declare module 'hono' {
  interface ContextRenderer {
    (content: string | Promise<string>, props?: { title?: string }): Response
  }
}

const Layout = ({ children, title }) => (
  <html>
    <head>
      <title>{title || 'Default'}</title>
    </head>
    <body>{children}</body>
  </html>
)

app.use('*', jsxRenderer(Layout))

app.get('/', (c) => {
  return c.render(<h1>Home</h1>, { title: 'Home Page' })
})
```

**Full Example:**
```typescript
const Layout = ({ children }) => {
  const c = useRequestContext()
  const user = c.get('user')

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>My App</title>
        <link rel="stylesheet" href="/styles.css" />
      </head>
      <body>
        <header>
          <nav>
            <a href="/">Home</a>
            {user ? (
              <a href="/profile">{user.name}</a>
            ) : (
              <a href="/login">Login</a>
            )}
          </nav>
        </header>
        <main>{children}</main>
        <footer>
          <p>&copy; 2026 My App</p>
        </footer>
      </body>
    </html>
  )
}

app.use('*', jsxRenderer(Layout))

app.get('/', (c) => {
  return c.render(
    <>
      <h1>Welcome to My App</h1>
      <p>This is the homepage.</p>
    </>
  )
})
```

---

## Internationalization

### Language

Language detection and negotiation middleware.

**Import:**
```typescript
import { languageDetector } from 'hono/language'
```

**Basic Usage:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en'
}))

app.get('/', (c) => {
  const lang = c.get('language')
  return c.json({ language: lang })
})
```

**Options:**

```typescript
type LanguageDetectorOptions = {
  // Supported language codes (required)
  supportedLanguages: string[]

  // Fallback language (required)
  fallbackLanguage: string

  // Detection order (optional)
  // Default: ['query', 'cookie', 'header']
  order?: Array<'query' | 'cookie' | 'header' | 'path'>

  // Query parameter name (optional)
  // Default: "lang"
  lookupQueryString?: string

  // Cookie name (optional)
  // Default: "language"
  lookupCookie?: string

  // Header to check (optional)
  // Default: "Accept-Language"
  lookupFromHeaderKey?: string

  // Path segment index for language (optional)
  // Default: undefined
  lookupFromPathIndex?: number

  // Where to cache detected language (optional)
  // Default: ['cookie']
  caches?: Array<'cookie'>

  // Case-insensitive matching (optional)
  // Default: false
  ignoreCase?: boolean

  // Cookie options (optional)
  cookieOptions?: {
    maxAge?: number
    path?: string
    domain?: string
    secure?: boolean
    httpOnly?: boolean
    sameSite?: 'Strict' | 'Lax' | 'None'
  }

  // Debug mode (optional)
  // Default: false
  debug?: boolean

  // Convert detected language (optional)
  // Example: convert 'en-US' to 'en'
  convertDetectedLanguage?: (lang: string) => string
}
```

**Detection Order:**

The middleware checks sources in the specified order:
1. **query** - URL query parameter (`?lang=es`)
2. **cookie** - Cookie value
3. **header** - Accept-Language header
4. **path** - URL path segment (`/es/page`)

**Custom Detection Order:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  order: ['path', 'cookie', 'header', 'query']
}))
```

**Custom Parameter Names:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  lookupQueryString: 'locale', // ?locale=es
  lookupCookie: 'user_lang'
}))
```

**Path-Based Detection:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  lookupFromPathIndex: 0, // /es/page -> 'es'
  order: ['path', 'cookie', 'header']
}))

// /en/about -> language: 'en'
// /es/about -> language: 'es'
// /about -> language: 'en' (fallback)
```

**Cookie Caching:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  caches: ['cookie'],
  cookieOptions: {
    maxAge: 365 * 24 * 60 * 60, // 1 year
    path: '/',
    httpOnly: true,
    secure: true,
    sameSite: 'Lax'
  }
}))
```

**Case-Insensitive:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  ignoreCase: true // 'EN', 'en', 'En' all match 'en'
}))
```

**Convert Detected Language:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  convertDetectedLanguage: (lang) => {
    // Convert 'en-US', 'en-GB' to 'en'
    return lang.split('-')[0]
  }
}))
```

**Debug Mode:**
```typescript
app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  debug: true // Logs detection process
}))
```

**Full Example:**
```typescript
const translations = {
  en: {
    welcome: 'Welcome',
    hello: 'Hello'
  },
  es: {
    welcome: 'Bienvenido',
    hello: 'Hola'
  },
  fr: {
    welcome: 'Bienvenue',
    hello: 'Bonjour'
  }
}

app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en',
  order: ['query', 'cookie', 'header'],
  caches: ['cookie'],
  cookieOptions: {
    maxAge: 365 * 24 * 60 * 60,
    path: '/',
    httpOnly: true
  }
}))

app.get('/', (c) => {
  const lang = c.get('language')
  const t = translations[lang]

  return c.json({
    language: lang,
    message: t.welcome
  })
})

app.get('/hello', (c) => {
  const lang = c.get('language')
  const name = c.req.query('name') || 'World'
  const t = translations[lang]

  return c.text(`${t.hello}, ${name}!`)
})
```

**Type-Safe Variables:**
```typescript
type Variables = {
  language: string
}

const app = new Hono<{ Variables: Variables }>()

app.use('*', languageDetector({
  supportedLanguages: ['en', 'es', 'fr'],
  fallbackLanguage: 'en'
}))

app.get('/', (c) => {
  const lang = c.get('language') // Typed as string
  return c.json({ language: lang })
})
```

---
