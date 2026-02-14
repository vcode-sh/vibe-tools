# Hono Core Platforms

Setup and deployment for core runtime platforms: Cloudflare Workers, Cloudflare Pages, Bun, Deno, and Node.js.

## Table of Contents

1. [Cloudflare Workers](#cloudflare-workers)
2. [Cloudflare Pages](#cloudflare-pages)
3. [Bun](#bun)
4. [Deno](#deno)
5. [Node.js](#nodejs)

---

## Cloudflare Workers

**Default Port:** 8787

### Setup

```bash
npm create hono@latest my-app
cd my-app
npm install
```

### Handler Pattern

```typescript
import { Hono } from 'hono'

type Bindings = {
  MY_KV: KVNamespace
  MY_VAR: string
}

const app = new Hono<{ Bindings: Bindings }>()

app.get('/', (c) => {
  return c.text('Hello Cloudflare Workers!')
})

export default app
```

### Typed Bindings

```typescript
type Bindings = {
  MY_KV: KVNamespace
  MY_D1: D1Database
  MY_R2: R2Bucket
  MY_QUEUE: Queue
  API_KEY: string
}

const app = new Hono<{ Bindings: Bindings }>()

app.get('/data', async (c) => {
  const value = await c.env.MY_KV.get('key')
  return c.json({ value })
})
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:8787
```

### Environment Variables

Create `.dev.vars` for local environment variables:

```env
API_KEY=your-secret-key
DATABASE_URL=your-database-url
```

### Deployment

```bash
npm run deploy
# or
npx wrangler deploy
```

### Configuration (wrangler.toml)

```toml
name = "my-worker"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[vars]
ENVIRONMENT = "production"

[[kv_namespaces]]
binding = "MY_KV"
id = "your-kv-id"

[[d1_databases]]
binding = "MY_D1"
database_name = "my-database"
database_id = "your-d1-id"

[[r2_buckets]]
binding = "MY_R2"
bucket_name = "my-bucket"

[site]
bucket = "./assets"
```

### Static Assets

```typescript
import { Hono } from 'hono'
import { serveStatic } from 'hono/cloudflare-workers'

const app = new Hono()

app.use('/static/*', serveStatic({ root: './' }))
app.use('/favicon.ico', serveStatic({ path: './favicon.ico' }))
```

### Module Worker for Additional Event Handlers

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

export default app

// Additional event handlers
export default {
  fetch: app.fetch,
  scheduled: async (event: ScheduledEvent, env: Env, ctx: ExecutionContext) => {
    // Scheduled handler
    console.log('Cron job triggered')
  },
  queue: async (batch: MessageBatch, env: Env) => {
    // Queue consumer
    for (const message of batch.messages) {
      console.log('Processing message:', message.body)
    }
  }
}
```

### GitHub Actions Deployment

```yaml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm run deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
```

### Platform-Specific Features

- **Edge runtime** with global distribution
- **Zero cold starts** for most requests
- **KV, D1, R2, Durable Objects** native bindings
- **1ms CPU time limit** on free tier (10ms+ on paid)
- **Streaming responses** supported
- **WebSocket support** via Durable Objects

### Gotchas

- No access to Node.js APIs
- Limited execution time (CPU time, not wall time)
- Environment variables are set at deploy time
- Use `.dev.vars` for local secrets (never commit)
- Response body must be consumed or discarded

---

## Cloudflare Pages

**Default Port:** 5173 (Vite dev server)

### Setup

```bash
npm create hono@latest my-app -- --template cloudflare-pages
cd my-app
npm install
```

### Handler Pattern

```typescript
import { Hono } from 'hono'

type Bindings = {
  MY_KV: KVNamespace
}

const app = new Hono<{ Bindings: Bindings }>()

app.get('/api/*', (c) => {
  return c.json({ message: 'Hello from API' })
})

export default app
```

### Pages Middleware Integration

```typescript
import { Hono } from 'hono'
import type { EventContext } from '@cloudflare/workers-types'

const app = new Hono()

// Access Pages context
app.use('*', async (c, next) => {
  const eventContext = c.env as EventContext<any, any, any>
  console.log('Request:', eventContext.request.url)
  await next()
})

app.get('/', (c) => c.text('Hello Pages!'))

export default app
```

### With Client-Side Scripts

```typescript
import { Hono } from 'hono'
import { serveStatic } from 'hono/cloudflare-pages'

const app = new Hono()

// Serve static files
app.use('/static/*', serveStatic())
app.use('/favicon.ico', serveStatic({ path: './favicon.ico' }))

// API routes
app.get('/api/hello', (c) => c.json({ message: 'Hello' }))

// Fallback to index.html for client-side routing
app.get('*', serveStatic({ path: './index.html' }))

export default app
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:5173
```

### Configuration (wrangler.toml)

```toml
name = "my-pages-project"
pages_build_output_dir = "./dist"

[env.production]
compatibility_date = "2024-01-01"

[[env.production.kv_namespaces]]
binding = "MY_KV"
id = "your-kv-id"
```

### Deployment

```bash
npm run deploy
# or
npx wrangler pages deploy dist
```

### Platform-Specific Features

- **Vite-based** development with HMR
- **Functions directory** (`/functions`) for file-based routing
- **Automatic preview deployments** for PRs
- **Git integration** for continuous deployment
- **Client + Server** in one project

### Gotchas

- Functions run in `/functions` directory by default
- Must export `onRequest` or HTTP method handlers in Functions
- Static assets served from `public/` or build output
- `_routes.json` controls which routes are handled by Functions
- Pages uses different middleware API (`handleMiddleware`)

---

## Bun

**Default Port:** 3000

### Setup

```bash
npm create hono@latest my-app -- --template bun
cd my-app
bun install
```

### Handler Pattern

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Bun!')
})

export default app
```

### Custom Port Configuration

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello on custom port!'))

export default {
  port: 8080,
  fetch: app.fetch,
}
```

### Static File Serving

```typescript
import { Hono } from 'hono'
import { serveStatic } from 'hono/bun'

const app = new Hono()

// Basic static serving
app.use('/static/*', serveStatic({ root: './' }))
app.use('/favicon.ico', serveStatic({ path: './public/favicon.ico' }))

// With options
app.use(
  '/assets/*',
  serveStatic({
    root: './',
    rewriteRequestPath: (path) => path.replace(/^\/assets/, '/public'),
    mimes: {
      'custom': 'application/x-custom'
    },
    precompressed: true, // Serve .gz or .br if available
  })
)

export default app
```

### Body Size Limit

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.post('/upload', async (c) => {
  const body = await c.req.parseBody()
  return c.json({ received: true })
})

export default {
  port: 3000,
  fetch: app.fetch,
  maxRequestBodySize: 10 * 1024 * 1024, // 10MB
}
```

### Testing with bun:test

```typescript
import { describe, expect, test } from 'bun:test'
import app from './index'

describe('API Tests', () => {
  test('GET /', async () => {
    const res = await app.request('/')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hello Bun!')
  })
})
```

### Local Development

```bash
bun run dev
# or
bun --watch src/index.ts
# Runs on http://localhost:3000
```

### Production

```bash
bun run start
# or
bun src/index.ts
```

### Platform-Specific Features

- **Native TypeScript** support (no compilation)
- **Fast startup** and execution
- **Built-in testing** with `bun:test`
- **Web APIs** compatible
- **Native SQLite** support
- **Fast package manager**

### Gotchas

- Use `hono/bun` for Bun-specific adapters
- Static file serving requires `hono/bun` version
- WebSocket support via Bun's native API
- Not all Node.js modules compatible
- Use `Bun.file()` for efficient file handling

---

## Deno

**Default Port:** 8000

### Setup

```bash
deno init --npm hono my-app
cd my-app
```

### Handler Pattern

```typescript
import { Hono } from 'npm:hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Deno!')
})

Deno.serve(app.fetch)
```

### With Custom Port

```typescript
import { Hono } from 'npm:hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello on custom port!'))

Deno.serve({ port: 8080 }, app.fetch)
```

### Static File Serving

```typescript
import { Hono } from 'npm:hono'
import { serveStatic } from 'npm:hono/deno'

const app = new Hono()

app.use('/static/*', serveStatic({ root: './' }))
app.use('/favicon.ico', serveStatic({ path: './public/favicon.ico' }))

Deno.serve(app.fetch)
```

### Using JSR (JavaScript Registry)

```typescript
import { Hono } from 'jsr:@hono/hono'
import { cors } from 'jsr:@hono/hono/cors'

const app = new Hono()
app.use('/*', cors())

app.get('/', (c) => c.text('Using JSR!'))

Deno.serve(app.fetch)
```

### Middleware Registry Matching

```typescript
import { Hono } from 'npm:hono'

const app = new Hono()

// Deno matches npm: prefix for middleware
app.use('*', async (c, next) => {
  console.log('Middleware works!')
  await next()
})

Deno.serve(app.fetch)
```

### Local Development

```bash
deno run --allow-net --watch main.ts
# Runs on http://localhost:8000
```

### Testing

```typescript
import { assertEquals } from 'https://deno.land/std/assert/mod.ts'
import app from './main.ts'

Deno.test('GET /', async () => {
  const res = await app.request('/')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Hello Deno!')
})
```

### Deployment to Deno Deploy

```bash
# Install deployctl
deno install -A --global --no-check -r -f https://deno.land/x/deploy/deployctl.ts

# Deploy
deployctl deploy --project=my-project main.ts
```

### Platform-Specific Features

- **Native TypeScript** support
- **Web standard APIs** only
- **Secure by default** (explicit permissions)
- **Built-in testing** and formatting
- **JSR and npm** package support
- **Edge runtime** on Deno Deploy

### Gotchas

- Use `npm:hono` or `jsr:@hono/hono` for imports
- Deno Deploy has different limits than local
- Must specify `--allow-net` permission
- Use `deno.json` for configuration
- Static serving needs explicit file system access (`--allow-read`)

---

## Node.js

**Default Port:** 3000

### Setup

```bash
npm create hono@latest my-app -- --template nodejs
cd my-app
npm install
```

### Handler Pattern

```typescript
import { serve } from '@hono/node-server'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Node.js!')
})

serve(app)
```

### Custom Port and Options

```typescript
import { serve } from '@hono/node-server'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

serve({
  fetch: app.fetch,
  port: 8080,
  hostname: '0.0.0.0',
})

console.log('Server running on http://0.0.0.0:8080')
```

### Graceful Shutdown

```typescript
import { serve } from '@hono/node-server'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

const server = serve({
  fetch: app.fetch,
  port: 3000,
})

process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully')
  server.close(() => {
    console.log('Server closed')
    process.exit(0)
  })
})
```

### HTTP/2 Support

```typescript
import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import fs from 'fs'

const app = new Hono()

app.get('/', (c) => c.text('Hello HTTP/2!'))

serve({
  fetch: app.fetch,
  port: 3000,
  createServer: (options, requestListener) => {
    const http2 = require('http2')
    return http2.createSecureServer(
      {
        ...options,
        key: fs.readFileSync('./ssl/key.pem'),
        cert: fs.readFileSync('./ssl/cert.pem'),
      },
      requestListener
    )
  },
})
```

### Access Node.js APIs

```typescript
import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import type { HttpBindings } from '@hono/node-server'

type Bindings = {
  /* other bindings */
} & HttpBindings

const app = new Hono<{ Bindings: Bindings }>()

app.get('/', (c) => {
  const nodeRequest = c.env.incoming
  const nodeResponse = c.env.outgoing
  return c.text(`Method: ${nodeRequest.method}`)
})

serve(app)
```

### Static File Serving

```typescript
import { serve } from '@hono/node-server'
import { serveStatic } from '@hono/node-server/serve-static'
import { Hono } from 'hono'

const app = new Hono()

app.use('/static/*', serveStatic({ root: './' }))
app.use('/favicon.ico', serveStatic({ path: './public/favicon.ico' }))

// With options
app.use(
  '/files/*',
  serveStatic({
    root: './uploads',
    rewriteRequestPath: (path) => path.replace(/^\/files/, ''),
  })
)

serve(app)
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:3000
```

### Dockerfile Example

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["node", "dist/index.js"]
```

### Platform-Specific Features

- **Full Node.js API** access
- **HTTP/2** support
- **Streaming** support
- **Wide ecosystem** compatibility
- **Mature tooling**

### Gotchas

- Requires `@hono/node-server` package
- Use Node.js 18+ for Web API support
- Static serving needs `@hono/node-server/serve-static`
- Access raw req/res via `HttpBindings`
- May need polyfills for some Web APIs in older Node versions
