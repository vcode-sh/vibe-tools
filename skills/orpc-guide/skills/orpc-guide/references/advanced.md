# oRPC Advanced Reference

Complete reference for advanced oRPC patterns: testing, serialization, TypeScript best practices, publishing clients, body parsing, playgrounds, and ecosystem.

## Testing and Mocking

### Testing Procedures

Test procedures directly using the `call` helper:

```typescript
import { call } from '@orpc/server'

it('lists planets with pagination', async () => {
  await expect(
    call(router.planet.list, { page: 1, size: 10 })
  ).resolves.toEqual([
    { id: '1', name: 'Earth' },
    { id: '2', name: 'Mars' },
  ])
})

it('finds planet by id', async () => {
  const result = await call(router.planet.find, { id: 1 })
  expect(result).toMatchObject({ id: 1, name: 'Earth' })
})

it('throws error for invalid input', async () => {
  await expect(
    call(router.planet.create, { name: '' })
  ).rejects.toThrow()
})
```

### Mocking Procedures

Create mock implementations using `implement`:

```typescript
import { implement, unlazyRouter } from '@orpc/server'

const fakeListPlanet = implement(router.planet.list).handler(() => [
  { id: '1', name: 'Mock Earth' },
  { id: '2', name: 'Mock Mars' },
])

const mockRouter = {
  planet: {
    list: fakeListPlanet,
    find: implement(router.planet.find).handler(({ input }) => ({
      id: input.id,
      name: 'Mock Planet',
    })),
  },
}
```

**Warning**: `implement` does not support lazy routers. Use `unlazyRouter` to convert before implementing.

**Tip**: The `implement` function is also useful for creating mock servers for frontend testing scenarios.

### Integration Testing

Test with actual HTTP requests:

```typescript
import { fetch } from '@orpc/client/fetch'

it('makes actual HTTP requests', async () => {
  const response = await fetch('http://localhost:3000/rpc/planet/list', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ json: { page: 1 }, meta: [] }),
  })

  const data = await response.json()
  expect(data.json).toHaveLength(2)
})
```

## Building Custom Plugins

### Handler Plugin Interface

Create plugins implementing `StandardHandlerPlugin`:

```typescript
export class MyPlugin<T extends Context> implements StandardHandlerPlugin<T> {
  order = 10 // Execution order (should be < 1,000,000)

  init(options: StandardHandlerOptions<T>): void {
    options.rootInterceptors ??= []
    options.clientInterceptors ??= []

    // Root interceptors run for all requests
    options.rootInterceptors.push(async (interceptorOptions) => {
      // Before handling
      console.log('Before:', interceptorOptions.path)

      const result = await interceptorOptions.next({ ...interceptorOptions })

      // After handling
      console.log('After:', interceptorOptions.path)
      return result
    })

    // Client interceptors run only for matched routes
    options.clientInterceptors.push(async ({ next }) => {
      return await next()
    })
  }
}
```

### Plugin Example: Response Headers

Add custom response headers using a plugin:

```typescript
export interface ResponseHeadersPluginContext {
  resHeaders?: Headers
}

export class ResponseHeadersPlugin<T extends ResponseHeadersPluginContext>
  implements StandardHandlerPlugin<T> {

  order = 10

  init(options: StandardHandlerOptions<T>): void {
    options.rootInterceptors ??= []

    options.rootInterceptors.push(async (interceptorOptions) => {
      const resHeaders = interceptorOptions.context.resHeaders ?? new Headers()

      const result = await interceptorOptions.next({
        ...interceptorOptions,
        context: { ...interceptorOptions.context, resHeaders },
      })

      if (!result.matched) return result

      const responseHeaders = clone(result.response.headers)

      // Merge custom headers into response
      for (const [key, value] of resHeaders) {
        if (Array.isArray(responseHeaders[key])) {
          responseHeaders[key].push(value)
        } else if (responseHeaders[key] !== undefined) {
          responseHeaders[key] = [responseHeaders[key], value]
        } else {
          responseHeaders[key] = value
        }
      }

      return {
        ...result,
        response: { ...result.response, headers: responseHeaders }
      }
    })
  }
}

// Usage
const handler = new RPCHandler(router, {
  plugins: [new ResponseHeadersPlugin()],
})
```

Warning: Order value should be less than 1,000,000.

### Plugin Example: Request Logging

Log all requests and responses:

```typescript
export class LoggingPlugin implements StandardHandlerPlugin {
  order = 5

  init(options: StandardHandlerOptions): void {
    options.rootInterceptors ??= []

    options.rootInterceptors.push(async (opts) => {
      const start = Date.now()
      console.log(`[REQUEST] ${opts.path}`, opts.request.input)

      try {
        const result = await opts.next(opts)
        const duration = Date.now() - start
        console.log(`[RESPONSE] ${opts.path} ${duration}ms`, result)
        return result
      } catch (error) {
        const duration = Date.now() - start
        console.error(`[ERROR] ${opts.path} ${duration}ms`, error)
        throw error
      }
    })
  }
}
```

### Link Plugin Interface

Create plugins for client links implementing `StandardLinkPlugin`:

```ts
import type { StandardLinkPlugin } from '@orpc/client/standard'

export class TimingPlugin<T extends Context> implements StandardLinkPlugin<T> {
  order = 10

  init(options: StandardLinkOptions<T>): void {
    options.interceptors ??= []

    options.interceptors.push(async (interceptorOptions) => {
      const start = Date.now()
      try {
        const result = await interceptorOptions.next(interceptorOptions)
        console.log(`Request took ${Date.now() - start}ms`)
        return result
      } catch (error) {
        console.error(`Request failed after ${Date.now() - start}ms`)
        throw error
      }
    })
  }
}
```

## SuperJSON Serializer

Replace the default oRPC RPC serializer with SuperJSON for advanced type support:

```typescript
import {
  createORPCErrorFromJson,
  ErrorEvent,
  isORPCErrorJson,
  mapEventIterator,
  toORPCError
} from '@orpc/client'
import type { StandardRPCSerializer } from '@orpc/client/standard'
import { isAsyncIteratorObject } from '@orpc/shared'
import SuperJSON from 'superjson'

export class SuperJSONSerializer implements Pick<StandardRPCSerializer, keyof StandardRPCSerializer> {
  serialize(data: unknown): object {
    // Handle async iterators (streaming)
    if (isAsyncIteratorObject(data)) {
      return mapEventIterator(data, {
        value: async (value: unknown) => SuperJSON.serialize(value),
        error: async (e) => new ErrorEvent({
          data: SuperJSON.serialize(toORPCError(e).toJSON()),
          cause: e,
        }),
      })
    }

    // Handle regular data
    return SuperJSON.serialize(data)
  }

  deserialize(data: any): unknown {
    // Handle async iterators (streaming)
    if (isAsyncIteratorObject(data)) {
      return mapEventIterator(data, {
        value: async value => SuperJSON.deserialize(value),
        error: async (e) => {
          if (!(e instanceof ErrorEvent)) return e
          const deserialized = SuperJSON.deserialize(e.data as any)

          if (isORPCErrorJson(deserialized)) {
            return createORPCErrorFromJson(deserialized, { cause: e })
          }

          return new ErrorEvent({ data: deserialized, cause: e })
        },
      })
    }

    // Handle regular data
    return SuperJSON.deserialize(data)
  }
}

// Usage on server
const handler = new RPCHandler(router, {
  serializer: new SuperJSONSerializer(),
})

// Usage on client
const link = new RPCLink({
  url: 'https://example.com/rpc',
  serializer: new SuperJSONSerializer(),
})
```

SuperJSON supports: Date, Map, Set, BigInt, RegExp, undefined, and custom classes.

### Full SuperJSON Handler

For complete SuperJSON integration, extend the handler:

```ts
import { FetchHandler, StandardHandler, StrictGetMethodPlugin } from '@orpc/server/fetch'
import { StandardRPCMatcher, StandardRPCCodec } from '@orpc/server/standard'

export class SuperJSONHandler extends FetchHandler {
  constructor(router: any, options: any = {}) {
    const serializer = new SuperJSONSerializer()
    const matcher = new StandardRPCMatcher()
    const codec = new StandardRPCCodec(serializer)

    const standardHandler = new StandardHandler(router, matcher, codec, options)
    super(standardHandler, options)
  }
}
```

### Full SuperJSON Link

```ts
import { StandardLink } from '@orpc/client/standard'
import { LinkFetchClient, StandardRPCLinkCodec } from '@orpc/client/fetch'

export class SuperJSONLink extends StandardLink {
  constructor(options: any) {
    const serializer = new SuperJSONSerializer()
    const linkCodec = new StandardRPCLinkCodec(serializer, options)
    const linkClient = new LinkFetchClient(options)

    super(linkCodec, linkClient, options)
  }
}
```

**Caveat**: `SuperJsonSerializer` supports only SuperJSON-compatible types plus `AsyncIteratorObject` at root level. It does NOT support all RPC supported types.

## RPC JSON Serializer

Extend or override the standard RPC JSON serializer for custom types:

```typescript
import type { StandardRPCCustomJsonSerializer } from '@orpc/client/standard'

// Define custom class
export class User {
  constructor(
    public readonly id: string,
    public readonly name: string
  ) {}

  toJSON() {
    return { id: this.id, name: this.name }
  }
}

// Define custom serializer
export const userSerializer: StandardRPCCustomJsonSerializer = {
  type: 21, // Unique type ID (avoid 0-7, reserved for built-ins)
  condition: data => data instanceof User,
  serialize: data => data.toJSON(),
  deserialize: data => new User(data.id, data.name),
}

// Server side
const handler = new RPCHandler(router, {
  customJsonSerializers: [userSerializer]
})

// Client side
const link = new RPCLink({
  url: 'https://example.com/rpc',
  customJsonSerializers: [userSerializer],
})
```

Built-in type IDs:
- 0: BigInt
- 1: Date
- 2: NaN
- 3: undefined
- 4: URL
- 5: RegExp
- 6: Set
- 7: Map

Use type IDs greater than `20` to avoid conflicts with built-in types in the future.

### Overriding Built-in Types

Override default behavior for built-in types by reusing their type IDs:

```ts
// Override undefined behavior (type ID 3)
const customUndefined: StandardRPCCustomJsonSerializer = {
  type: 3,
  condition: data => data === undefined,
  serialize: () => 'custom_undefined',
  deserialize: () => undefined,
}
```

## Validation Errors

### Customize with Client Interceptors

Transform validation errors globally:

```typescript
import { onError, ORPCError, ValidationError } from '@orpc/server'
import { z } from 'zod'

const handler = new RPCHandler(router, {
  clientInterceptors: [
    onError((error) => {
      // Handle input validation errors
      if (
        error instanceof ORPCError
        && error.code === 'BAD_REQUEST'
        && error.cause instanceof ValidationError
      ) {
        const zodError = new z.ZodError(error.cause.issues as z.ZodIssue[])

        throw new ORPCError('INPUT_VALIDATION_FAILED', {
          status: 422,
          message: z.prettifyError(zodError),
          data: z.flattenError(zodError),
          cause: error.cause,
        })
      }

      // Handle output validation errors
      if (
        error instanceof ORPCError
        && error.code === 'INTERNAL_SERVER_ERROR'
        && error.cause instanceof ValidationError
      ) {
        throw new ORPCError('OUTPUT_VALIDATION_FAILED', {
          cause: error.cause
        })
      }
    }),
  ],
})
```

### Customize with Middleware

Transform validation errors per procedure:

```typescript
const base = os.use(onError((error) => {
  if (
    error instanceof ORPCError
    && error.code === 'BAD_REQUEST'
    && error.cause instanceof ValidationError
  ) {
    const zodError = new z.ZodError(error.cause.issues as z.ZodIssue[])

    throw new ORPCError('INPUT_VALIDATION_FAILED', {
      status: 422,
      message: 'Validation failed: ' + z.prettifyError(zodError),
      data: z.flattenError(zodError),
      cause: error.cause,
    })
  }
}))

// Use enhanced base for procedures
const createPlanet = base
  .input(z.object({ name: z.string() }))
  .handler(({ input }) => {
    // Validation errors are now customized
  })
```

### Type-Safe Validation Errors

Combine `.errors()` with validation error customization for fully type-safe validation errors on the client:

```ts
const base = os
  .errors({
    INPUT_VALIDATION_FAILED: {
      status: 422,
      data: z.object({
        formErrors: z.array(z.string()),
        fieldErrors: z.record(z.array(z.string())),
      }),
    },
  })
  .use(onError((error) => {
    if (
      error instanceof ORPCError
      && error.code === 'BAD_REQUEST'
      && error.cause instanceof ValidationError
    ) {
      const zodError = new z.ZodError(error.cause.issues as z.core.$ZodIssue[])

      throw errors.INPUT_VALIDATION_FAILED({
        message: z.prettifyError(zodError),
        data: z.flattenError(zodError),
        cause: error.cause,
      })
    }
  }))
```

This enables type-safe validation errors on the client using `isDefinedError`.

**Note**: Middleware applied before `.input()`/`.output()` catches validation errors by default. This behavior is configurable via `initialInputValidationIndex`.

## RPC Protocol

### Routing

RPC endpoints are structured as path segments:

```bash
curl https://example.com/rpc/planet/create
curl https://example.com/rpc/user/profile/update
```

### Input in URL Query (GET)

For GET requests, input is URL-encoded:

```typescript
const url = new URL('https://example.com/rpc/planet/create')
url.searchParams.append('data', JSON.stringify({
  json: {
    name: 'Earth',
    detached_at: '2022-01-01T00:00:00.000Z'
  },
  meta: [[1, 'detached_at']], // Type metadata
}))

fetch(url)
```

### Input in Body (POST)

For POST requests, input is in request body:

```bash
curl -X POST https://example.com/rpc/planet/create \
  -H 'Content-Type: application/json' \
  -d '{
    "json": {
      "name": "Earth",
      "detached_at": "2022-01-01T00:00:00.000Z"
    },
    "meta": [[1, "detached_at"]]
  }'
```

### Input with File

File uploads use FormData with a `maps` field linking Blob positions to input paths:

```bash
curl -X POST https://example.com/rpc/upload \
  -F 'json={"name":"photo.jpg"}' \
  -F 'meta=[]' \
  -F 'maps=[["file"]]' \
  -F '0=@/path/to/photo.jpg'
```

**Meta format**: `[type: number, ...path: (string | number)[]]` where type is the built-in type ID.

**Maps format**: Array of paths, each corresponding to a FormData file entry by index.

### HTTP Status Codes

- Success responses: `200-299`
- Error responses: `400-599`
- Any HTTP method can be used

**Note**: `StrictGetMethodPlugin` (enabled by default) blocks GET requests except for procedures explicitly marked with `$route({ method: 'GET' })`.

### Success Response

Successful responses include data and type metadata:

```json
{
  "json": {
    "id": "1",
    "name": "Earth",
    "detached_at": "2022-01-01T00:00:00.000Z"
  },
  "meta": [
    [0, "id"],
    [1, "detached_at"]
  ]
}
```

### Error Response

Error responses follow ORPCError structure:

```json
{
  "json": {
    "defined": false,
    "code": "INTERNAL_SERVER_ERROR",
    "status": 500,
    "message": "Internal server error",
    "data": {}
  },
  "meta": []
}
```

## Best Practices

### Monorepo Setup

Configure TypeScript for monorepos with project references:

```json
// client/tsconfig.json
{
  "compilerOptions": {
    "composite": true
  },
  "references": [
    { "path": "../server" }
  ]
}

// server/tsconfig.json
{
  "compilerOptions": {
    "composite": true,
    "declaration": true
  }
}
```

Recommended monorepo structure:

```text
apps/
├── api/          # Server application
├── web/          # Web client
packages/
├── core-contract/  # Shared contracts
├── core-service/   # Shared business logic
```

**Monorepo variants**: Three common approaches:
1. **Contract First**: Shared contracts package, separate server/client packages
2. **Service First**: Server defines contracts, client imports types
3. **Hybrid**: Mix of both approaches

**Warning**: Avoid alias imports inside server components. Use linked workspace packages instead.

### No Throw Literal

Enforce throwing only Error instances via the Registry:

```typescript
declare module '@orpc/server' { // or '@orpc/contract', or '@orpc/client'
  interface Registry {
    throwableError: Error
  }
}
```

**Warning**: Avoid `any` or `unknown` for `throwableError` - it prevents client type-safe error inference. Use `null | undefined | {}` (equivalent to `unknown`) instead.

When using `null | undefined | {}`, check `isSuccess` instead of `error`:

```typescript
const { error, data, isSuccess } = await safe(client('input'))

if (!isSuccess) {
  if (isDefinedError(error)) {
    // handle type-safe error
  }
  // handle other errors
} else {
  // handle success
}
```

**Tip**: Enable the ESLint [no-throw-literal](https://eslint.org/docs/rules/no-throw-literal) rule.

### Optimize SSR

Avoid unnecessary network calls in server-side rendering:

```typescript
// lib/orpc.ts
declare global {
  var $client: RouterClient<typeof router> | undefined
}

const link = new RPCLink({
  url: () => {
    if (typeof window === 'undefined') {
      throw new Error('RPCLink is not allowed on the server side.')
    }
    return `${window.location.origin}/rpc`
  },
})

export const client: RouterClient<typeof router> =
  globalThis.$client ?? createORPCClient(link)
```

Server-side optimized client:

```typescript
// lib/orpc.server.ts
import 'server-only'
import { createRouterClient } from '@orpc/server'
import { headers } from 'next/headers'

globalThis.$client = createRouterClient(router, {
  context: async () => ({
    headers: await headers()
  }),
})
```

Usage:

```typescript
// Server component
import { client } from '@/lib/orpc.server'

export async function ServerComponent() {
  const planets = await client.planet.list() // Direct call, no HTTP
  return <div>{planets.map(p => p.name)}</div>
}

// Client component
import { client } from '@/lib/orpc'

export function ClientComponent() {
  const { data } = client.planet.list.useQuery() // HTTP call
  return <div>{data?.map(p => p.name)}</div>
}
```

### Dedupe Middleware

oRPC automatically deduplicates leading middleware:

```typescript
const dbProvider = os
  .$context<{ db?: Awaited<ReturnType<typeof connectDb>> }>()
  .middleware(async ({ context, next }) => {
    // This middleware runs once even if applied multiple times
    const db = context.db ?? await connectDb()
    return next({ context: { db } })
  })

const procedure1 = dbProvider.handler(() => {})
const procedure2 = dbProvider.handler(() => {})

// DB connection happens once per request, not twice
```

Disable deduplication if needed:

```typescript
const base = os.$config({
  dedupeLeadingMiddlewares: false
})
```

### Exceeds Maximum Length Problem

If TypeScript reports "exceeds maximum length" errors:

**Why it happens**: All three conditions must be met: `declaration: true` in tsconfig, large project with many procedures, and a single large router export. TypeScript generates excessively long declaration strings for complex inferred types.

**Solution 1**: Disable declaration files (fastest):

```json
{
  "compilerOptions": {
    "declaration": false
  }
}
```

**Solution 2**: Define explicit output types:

```typescript
const listPlanets = os
  .input(z.object({ cursor: z.number() }))
  .output(z.object({
    planets: z.array(PlanetSchema),
    nextCursor: z.number(),
  }))
  .handler(({ input }) => {
    // Output type is now explicit
  })
```

**Solution 3**: Export router in parts:

```typescript
// Don't
export const router = { user, planet, star, galaxy }

// Do
export const userRouter = user
export const planetRouter = planet
export const starRouter = star
export const galaxyRouter = galaxy
```

**Client-side router merging** when exporting in parts:

```ts
interface Router {
  user: typeof userRouter
  planet: typeof planetRouter
}

export const client: RouterClient<Router> = createORPCClient(link)
```

## Publish Client to NPM

Create a standalone client package for your API:

```typescript
// src/index.ts
import { createORPCClient } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'
import type { ContractRouterClient } from '@orpc/contract'
import type { contract } from './contract'

export function createMyApi(apiKey: string): ContractRouterClient<typeof contract> {
  const link = new RPCLink({
    url: 'https://api.example.com/rpc',
    headers: {
      'x-api-key': apiKey,
      'content-type': 'application/json',
    },
  })

  return createORPCClient(link)
}

// Re-export types
export type { contract }
```

Package.json configuration:

```json
{
  "name": "@myorg/api-client",
  "version": "1.0.0",
  "type": "module",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    }
  },
  "files": ["dist"],
  "publishConfig": { "access": "public" },
  "scripts": {
    "build": "tsdown --dts src/index.ts",
    "release": "pnpm build && pnpm publish"
  },
  "dependencies": {
    "@orpc/client": "latest",
    "@orpc/contract": "latest"
  }
}
```

**Prerequisites**: Contract-First development is the preferred approach for publishable clients.

Usage by consumers:

```typescript
import { createMyApi } from '@myorg/api-client'

const api = createMyApi(process.env.API_KEY!)

const planets = await api.planet.list({ page: 1 })
```

## Extend Body Parser

Handle larger payloads or additional content types:

```typescript
const OVERRIDE_BODY_CONTEXT = Symbol('OVERRIDE_BODY_CONTEXT')

const handler = new RPCHandler(router, {
  adapterInterceptors: [
    (options) => options.next({
      ...options,
      context: {
        ...options.context,
        [OVERRIDE_BODY_CONTEXT]: {
          fetchRequest: options.request
        },
      },
    }),
  ],
  rootInterceptors: [
    async (options) => {
      const { fetchRequest } = options.context[OVERRIDE_BODY_CONTEXT]

      return options.next({
        ...options,
        request: {
          ...options.request,
          async body() {
            const contentType = fetchRequest.headers.get('content-type')

            // Handle multipart form data
            // Tip: use @mjackson/form-data-parser for streaming parsing
            if (contentType?.startsWith('multipart/form-data')) {
              return fetchRequest.formData()
            }

            // Handle large JSON payloads
            if (contentType?.startsWith('application/json')) {
              const text = await fetchRequest.text()
              return JSON.parse(text)
            }

            // Default behavior
            return options.request.body()
          },
        },
      })
    },
  ],
})
```

### Handler Interceptor Levels

RPCHandler supports three interceptor levels:

```ts
const handler = new RPCHandler(router, {
  // Adapter-level: closest to raw HTTP request
  adapterInterceptors: [],
  // Root-level: after adapter, runs for all requests
  rootInterceptors: [],
  // Client-level: only runs for matched procedures
  clientInterceptors: [],
  // Top-level shorthand (same as rootInterceptors)
  interceptors: [],
})
```

## Playgrounds

Interactive examples available via StackBlitz or local clone with `npx degit`:

| Environment | Local Clone |
|-------------|------------|
| Next.js | `npx degit middleapi/orpc/playgrounds/next` |
| TanStack Start | `npx degit middleapi/orpc/playgrounds/tanstack-start` |
| Nuxt | `npx degit middleapi/orpc/playgrounds/nuxt` |
| Solid Start | `npx degit middleapi/orpc/playgrounds/solid-start` |
| SvelteKit | `npx degit middleapi/orpc/playgrounds/svelte-kit` |
| Astro | `npx degit middleapi/orpc/playgrounds/astro` |
| Contract-First | `npx degit middleapi/orpc/playgrounds/contract-first` |
| NestJS | `npx degit middleapi/orpc/playgrounds/nest` |
| Cloudflare Worker | `npx degit middleapi/orpc/playgrounds/cloudflare-worker` |
| Bun WebSocket + OpenTelemetry | `npx degit middleapi/orpc/playgrounds/bun-websocket-otel` |
| Electron | `npx degit middleapi/orpc/playgrounds/electron` |
| Browser Extension | `npx degit middleapi/orpc/playgrounds/browser-extension` |
| Multiservice Monorepo | `npx degit middleapi/orpc-multiservice-monorepo-playground` |

After cloning: `npm install && npm run dev` → `http://localhost:3000`

## Ecosystem

### Starter Kits

**Zap.ts**
- Next.js App Router boilerplate
- GitHub: github.com/zaptify/zap.ts

**Better-T-Stack**
- CLI for generating type-safe TypeScript projects
- Includes oRPC, Drizzle, and more

**create-start-app**
- React + TanStack Router + oRPC
- Full-stack type-safe starter

**create-o3-app**
- oRPC + Drizzle ORM + ArkType
- Optimized for type safety

**RT Stack**
- React + Vite + oRPC + Valibot + Better Auth
- Modern full-stack template

**Start UI**
- TanStack Start + shadcn/ui + oRPC + Prisma + Better Auth
- Production-ready starter

**ShipFullStack**
- React + TanStack Start + Hono + oRPC + Expo
- Mobile and web support

**WXT Starter**
- Browser extension template based on WXT

### Tools

**orpc-file-based-router**
- Automatically creates routers based on file structure
- Convention over configuration

**Prisma oRPC Generator**
- Generates oRPC routers from Prisma schema
- Automatic CRUD operations

**DRZL**
- Zero-friction codegen for Drizzle ORM
- Type-safe database queries

**orpc-msw**
- Type-safe API mocking with Mock Service Worker
- Test without backend

**Vertrag**
- Spec-first API development tool (oRPC contract + any backend language)

### Libraries

**Permix**
- Type-safe permissions management
- Role-based access control for oRPC

**trpc-cli**
- Turn oRPC router into command-line interface
- Build CLIs from your API

**oRPC Shield**
- Type-safe authorization layer
- Fine-grained access control

**orpc-json-diff**
- JSON patches for event iterators
- Efficient real-time updates

**@reliverse/rempts**
- Type-safe CLI toolkit with file-based commands

**Every Plugin**
- Composable plugin runtime for loading, initializing, and executing remote plugins

**effect-orpc**
- Effect-TS integration for oRPC
- Functional error handling

## See Also

- Contract-first development, tRPC migration, and comparison: `references/contract-first.md`
- Helpers (cookies, signing, encryption, rate limiting, publishers): `references/helpers.md`
