# Hono Additional Platforms

Setup and deployment for additional platforms: Azure, Google Cloud Run, Fastly, Supabase, Alibaba Cloud, Service Worker, WebAssembly, and platform comparison.

## Table of Contents

1. [Azure Functions](#azure-functions)
2. [Google Cloud Run](#google-cloud-run)
3. [Fastly Compute](#fastly-compute)
4. [Supabase Edge Functions](#supabase-edge-functions)
5. [Alibaba Cloud Function Compute](#alibaba-cloud-function-compute)
6. [Service Worker](#service-worker)
7. [WebAssembly (WASI)](#webassembly-wasi)
8. [Platform Comparison](#platform-comparison)

---

## Azure Functions

**Default Port:** 7071 (local Azure Functions runtime)

### Setup

```bash
npm install hono
npm install @marplex/hono-azurefunc-adapter
```

### Handler Pattern (V4)

```typescript
import { Hono } from 'hono'
import { azureHonoHandler } from '@marplex/hono-azurefunc-adapter'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Azure Functions!')
})

export default azureHonoHandler(app.fetch)
```

### Configuration (host.json)

```json
{
  "version": "2.0",
  "logging": {
    "applicationInsights": {
      "samplingSettings": {
        "isEnabled": true,
        "maxTelemetryItemsPerSecond": 5
      }
    }
  },
  "extensionBundle": {
    "id": "Microsoft.Azure.Functions.ExtensionBundle",
    "version": "[4.*, 5.0.0)"
  },
  "extensions": {
    "http": {
      "routePrefix": ""
    }
  }
}
```

### Function Configuration (function.json)

```json
{
  "bindings": [
    {
      "authLevel": "anonymous",
      "type": "httpTrigger",
      "direction": "in",
      "name": "req",
      "methods": ["get", "post", "put", "delete"],
      "route": "{*segments}"
    },
    {
      "type": "http",
      "direction": "out",
      "name": "res"
    }
  ]
}
```

### Local Development

```bash
func start
# Runs on http://localhost:7071
```

### Deployment

```bash
func azure functionapp publish <APP_NAME>
```

### Platform-Specific Features

- **Azure ecosystem** integration
- **Bindings** for various Azure services
- **Durable Functions** for workflows
- **Application Insights** monitoring
- **Consumption** or Premium plans

### Gotchas

- **V4 runtime only** supported
- Requires **Node.js 18+**
- Set `routePrefix: ""` in host.json for clean URLs
- Use `@marplex/hono-azurefunc-adapter` package
- Different binding model than AWS Lambda
- Azure Functions Core Tools required for local dev

---

## Google Cloud Run

**Default Port:** 8080 (required by Cloud Run)

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
  return c.text('Hello Cloud Run!')
})

const port = parseInt(process.env.PORT || '8080')

serve({
  fetch: app.fetch,
  port,
  hostname: '0.0.0.0',
})

console.log(`Server running on port ${port}`)
```

### Dockerfile

```dockerfile
FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

ENV PORT=8080
EXPOSE 8080

CMD ["node", "src/index.js"]
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:8080
```

### Deployment

```bash
gcloud run deploy my-service \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### With Cloud Build

```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/hono-app', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/hono-app']
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - 'run'
      - 'deploy'
      - 'hono-app'
      - '--image=gcr.io/$PROJECT_ID/hono-app'
      - '--region=us-central1'
      - '--platform=managed'
      - '--allow-unauthenticated'
```

### Platform-Specific Features

- **Container-based** (any runtime)
- **Auto-scaling** including to zero
- **HTTPS** automatic
- **Cloud SQL** integration
- **VPC** connectivity
- **Global load balancing**

### Gotchas

- MUST listen on port `8080` or use `PORT` env var
- MUST bind to `0.0.0.0` not `localhost`
- Container must respond to health checks within 4 seconds
- Use `@hono/node-server` for Node.js runtime
- Cold start times depend on container size
- Max request timeout: 60 minutes

---

## Fastly Compute

**Default Port:** 7676

### Setup

```bash
npm create hono@latest my-app -- --template fastly
cd my-app
npm install
```

### Handler Pattern

```typescript
import { Hono } from 'hono'
import { fire } from '@fastly/hono-fastly-compute'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Fastly Compute!')
})

fire(app)
```

### KV Store Access

```typescript
import { Hono } from 'hono'
import { fire, buildFire } from '@fastly/hono-fastly-compute'
import { KVStore } from 'fastly:kv-store'

const app = new Hono()

app.get('/data/:key', async (c) => {
  const key = c.req.param('key')
  const store = new KVStore('my_store')
  const value = await store.get(key)

  return c.json({ key, value })
})

fire(app)
```

### Config and Secret Stores

```typescript
import { Hono } from 'hono'
import { fire } from '@fastly/hono-fastly-compute'
import { ConfigStore } from 'fastly:config-store'
import { SecretStore } from 'fastly:secret-store'

const app = new Hono()

app.get('/config', async (c) => {
  const config = new ConfigStore('my_config')
  const apiUrl = config.get('api_url')

  const secrets = new SecretStore('my_secrets')
  const apiKey = await secrets.get('api_key')

  return c.json({ apiUrl, hasKey: !!apiKey })
})

fire(app)
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:7676
```

### Deployment

```bash
fastly compute publish
```

### Platform-Specific Features

- **Edge compute** at Fastly POPs
- **WebAssembly** based
- **KV Store** for edge data
- **Config Store** for configuration
- **Secret Store** for credentials
- **Backend** requests to origins
- **Extremely fast** cold starts (<1ms)

### Gotchas

- Must use `@fastly/hono-fastly-compute` package
- Compiles to WebAssembly (WASM)
- Limited execution time per request
- No persistent state beyond KV/Config stores
- Must configure backends in `fastly.toml`
- Different APIs than standard Web APIs
- Use `buildFire` for custom bindings

---

## Supabase Edge Functions

**Default Port:** 8000 (Deno runtime)

### Setup

```bash
supabase functions new my-function
cd my-function
```

### Handler Pattern

```typescript
import { Hono } from 'https://deno.land/x/hono/mod.ts'

const app = new Hono()

app.get('/', (c) => {
  return c.json({ message: 'Hello from Supabase Edge Functions!' })
})

Deno.serve(app.fetch)
```

### With Base Path

```typescript
import { Hono } from 'https://deno.land/x/hono/mod.ts'

const functionName = 'my-function'
const app = new Hono().basePath(`/${functionName}`)

app.get('/', (c) => {
  return c.json({ message: 'Hello!' })
})

app.get('/users', (c) => {
  return c.json({ users: [] })
})

Deno.serve(app.fetch)
```

### Access Supabase Client

```typescript
import { Hono } from 'https://deno.land/x/hono/mod.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const app = new Hono()

app.get('/data', async (c) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? ''
  )

  const { data, error } = await supabase
    .from('users')
    .select('*')
    .limit(10)

  if (error) {
    return c.json({ error: error.message }, 500)
  }

  return c.json({ data })
})

Deno.serve(app.fetch)
```

### Local Development

```bash
supabase functions serve my-function
# Runs on http://localhost:8000
```

### Deployment

```bash
supabase functions deploy my-function
```

### Platform-Specific Features

- **Deno runtime** on edge
- **Supabase ecosystem** integration
- **Database** access via client
- **Auth** integration
- **Storage** access
- **Global distribution**

### Gotchas

- Uses Deno runtime (not Node.js)
- Import from `https://deno.land/x/hono`
- Use `basePath` matching function name
- Environment variables via Supabase CLI
- Functions deployed individually
- Auth token passed in request headers

---

## Alibaba Cloud Function Compute

**Default Port:** N/A (serverless)

### Setup

```bash
npm install hono
npm install hono-alibaba-cloud-fc3-adapter
```

### Handler Pattern

```typescript
import { Hono } from 'hono'
import { adapter } from 'hono-alibaba-cloud-fc3-adapter'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Alibaba Cloud!')
})

export const handler = adapter(app)
```

### Configuration (s.yaml)

```yaml
edition: 3.0.0
name: hono-app
access: default

resources:
  hono-function:
    component: fc3
    props:
      region: cn-hangzhou
      runtime: nodejs18
      handler: index.handler
      timeout: 60
      memorySize: 512
      code: ./dist
      triggers:
        - triggerType: http
          triggerConfig:
            methods:
              - GET
              - POST
              - PUT
              - DELETE
            authType: anonymous
```

### Local Development with Serverless Devs

```bash
npm install -g @serverless-devs/s
s deploy
```

### Deployment

```bash
s deploy --use-local
```

### Platform-Specific Features

- **Alibaba Cloud** ecosystem integration
- **HTTP triggers** for web apps
- **OSS** (Object Storage) integration
- **Table Store** access
- **Log Service** integration

### Gotchas

- Requires `hono-alibaba-cloud-fc3-adapter` package
- Use Serverless Devs CLI for deployment
- Configure access credentials first
- China region requires ICP license for domains
- Different pricing model than AWS/GCP

---

## Service Worker

**Default Port:** N/A (browser-based)

### Setup

```bash
npm install hono
```

### Handler Pattern (Method 1: handle)

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/service-worker'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello from Service Worker!')
})

app.get('/cache', async (c) => {
  const cache = await caches.open('my-cache')
  const response = await cache.match(c.req.url)

  if (response) {
    return response
  }

  return c.text('Not in cache')
})

self.addEventListener('fetch', handle(app))
```

### Handler Pattern (Method 2: fire)

```typescript
import { Hono } from 'hono'
import { fire } from 'hono/service-worker'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

fire(app)
```

### Caching Strategy

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/service-worker'

const app = new Hono()

app.get('/api/*', async (c) => {
  // Network first, cache fallback
  try {
    const response = await fetch(c.req.raw)
    const cache = await caches.open('api-cache')
    await cache.put(c.req.url, response.clone())
    return response
  } catch (error) {
    const cached = await caches.match(c.req.url)
    if (cached) return cached
    return c.text('Offline', 503)
  }
})

self.addEventListener('fetch', handle(app))
```

### Installation and Activation

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/service-worker'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

self.addEventListener('fetch', handle(app))

self.addEventListener('install', (event) => {
  console.log('Service Worker installed')
  self.skipWaiting()
})

self.addEventListener('activate', (event) => {
  console.log('Service Worker activated')
  event.waitUntil(self.clients.claim())
})
```

### Registration (in main app)

```html
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js')
      .then((registration) => {
        console.log('Service Worker registered:', registration)
      })
      .catch((error) => {
        console.error('Service Worker registration failed:', error)
      })
  }
</script>
```

### Platform-Specific Features

- **Browser-based** execution
- **Cache API** access
- **Offline capabilities**
- **Background sync**
- **Push notifications**
- **Network interception**

### Gotchas

- Runs in browser (client-side)
- HTTPS required (except localhost)
- Limited scope to registration path
- Must be registered from main thread
- Cache management is manual
- No access to DOM
- Different security model than server

---

## WebAssembly (WASI)

**Default Port:** 8000

### Setup

```bash
npm install hono
npm install @bytecodealliance/jco-std
```

### Handler Pattern

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello from WebAssembly!')
})

export default app
```

### WIT Interface Definition

**File:** `wit/world.wit`

```wit
package example:hono-app;

world hono-app {
  import wasi:http/incoming-handler@0.2.0;
  export wasi:http/outgoing-handler@0.2.0;
}
```

### Build Configuration (package.json)

```json
{
  "name": "hono-wasm-app",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "build": "node build.js",
    "preview": "node preview.js"
  },
  "dependencies": {
    "hono": "^4.0.0"
  },
  "devDependencies": {
    "@bytecodealliance/jco": "^1.0.0",
    "@bytecodealliance/jco-std": "^1.0.0"
  }
}
```

### Build Script (build.js)

```javascript
import { componentize } from '@bytecodealliance/jco'
import { writeFile } from 'fs/promises'
import { resolve } from 'path'

const source = await readFile('./src/index.ts', 'utf8')

const component = await componentize(source, {
  wit: './wit/world.wit',
  worldName: 'hono-app',
})

await writeFile('./dist/app.wasm', component)
console.log('Built WebAssembly component')
```

### Preview Script (preview.js)

```javascript
import { serve } from '@bytecodealliance/jco-std'
import { readFile } from 'fs/promises'

const wasm = await readFile('./dist/app.wasm')

serve(wasm, {
  port: 8000,
})

console.log('Server running on http://localhost:8000')
```

### Local Development

```bash
npm run build
npm run preview
# Runs on http://localhost:8000
```

### Platform-Specific Features

- **WebAssembly** based
- **WASI** (WebAssembly System Interface)
- **Portable** across runtimes
- **Sandboxed** execution
- **Component model**
- **Language agnostic**

### Gotchas

- Requires **bundling** the entire app
- WIT interface must be defined
- Limited ecosystem compared to Node.js
- Needs WASI-compatible runtime
- Component model still evolving
- Not all Hono features may work
- Larger bundle size than typical JS

---

## Platform Comparison

### Default Ports Reference

| Platform | Port | Runtime |
|----------|------|---------|
| Bun | 3000 | Bun |
| Cloudflare Workers | 8787 | V8 |
| Cloudflare Pages | 5173 | Vite/V8 |
| Deno | 8000 | Deno |
| Fastly Compute | 7676 | WASM |
| Google Cloud Run | 8080 | Container |
| Node.js | 3000 | Node.js |
| Next.js | 3000 | Node.js/Edge |
| Netlify | 8888 | Node.js/Deno |
| Vercel | 3000 | Node.js/Edge |
| WebAssembly | 8000 | WASI |
| AWS Lambda | N/A | Node.js |
| Lambda@Edge | N/A | Node.js |
| Azure Functions | 7071 | Node.js |
| Supabase | 8000 | Deno |
| Alibaba Cloud | N/A | Node.js |
| Service Worker | N/A | Browser |

### Runtime Environments

- **V8 Isolate**: Cloudflare Workers/Pages, Vercel Edge, Netlify Edge
- **Node.js**: Node.js, AWS Lambda, Azure Functions, Google Cloud Run, Vercel, Alibaba Cloud
- **Deno**: Deno, Netlify Edge Functions, Supabase Edge Functions
- **Bun**: Bun
- **WebAssembly**: Fastly Compute, WASI
- **Browser**: Service Worker

### Choosing a Platform

**For low latency and global distribution:**
- Cloudflare Workers/Pages
- Vercel Edge Functions
- Netlify Edge Functions
- Fastly Compute

**For Node.js compatibility:**
- Node.js
- Google Cloud Run
- AWS Lambda
- Vercel
- Azure Functions

**For edge + database:**
- Cloudflare Workers + D1
- Supabase Edge Functions
- Vercel + Serverless SQL

**For modern runtimes:**
- Deno
- Bun

**For maximum control:**
- Node.js on VPS
- Google Cloud Run
- Container platforms
