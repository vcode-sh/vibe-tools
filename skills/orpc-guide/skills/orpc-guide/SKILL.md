---
name: orpc-guide
description: >-
  Guide for oRPC — a type-safe RPC framework combining end-to-end type safety with OpenAPI compliance.
  Use when user explicitly mentions "oRPC" or asks to "create oRPC procedures", "set up oRPC server",
  "configure oRPC client", "add oRPC middleware", "define oRPC router",
  "use oRPC with Next.js/Express/Hono/Fastify", "generate OpenAPI spec with oRPC",
  "integrate oRPC with TanStack Query", "stream with oRPC", "handle errors in oRPC",
  "set up oRPC contract-first", "migrate from tRPC to oRPC",
  or asks about oRPC procedures, routers, middleware, context, plugins, adapters, or server actions.
  Covers server setup, client creation, middleware chains, error handling, OpenAPI generation,
  file uploads, event iterators (SSE/streaming), server actions, contract-first development,
  and framework adapter integrations.
  Do NOT use for generic RPC/gRPC questions, tRPC-only questions (without migration context),
  or general TypeScript API development without oRPC.
metadata:
  author: skill-maker
  version: 1.1.0
  source: documentation-analysis
  source-docs: source/orpc/
  category: backend-framework
  tags:
    - orpc
    - rpc
    - typescript
    - openapi
    - type-safe
    - api
    - server
    - client
    - middleware
    - streaming
---

# oRPC Guide

oRPC is a type-safe RPC framework that combines end-to-end type safety with OpenAPI compliance. It supports procedures, routers, middleware, context injection, error handling, file uploads, streaming (SSE), server actions, and contract-first development across 20+ framework adapters.

**Scope**: This guide is specifically for the oRPC library (`@orpc/*` packages). It is not a general RPC/gRPC guide, not for tRPC-only projects (unless migrating to oRPC), and not for generic TypeScript API development without oRPC. For tRPC-to-oRPC migration, see `references/contract-first.md`.

## Quick Start

### Install

```sh
npm install @orpc/server@latest @orpc/client@latest
```

For OpenAPI support, also install:

```sh
npm install @orpc/openapi@latest
```

### Prerequisites

- Node.js 18+ (20+ recommended) | Bun | Deno | Cloudflare Workers
- TypeScript project with strict mode recommended
- Supports Zod, Valibot, ArkType, and any Standard Schema library

### Define Procedures and Router

```ts
import { ORPCError, os } from '@orpc/server'
import * as z from 'zod'

const PlanetSchema = z.object({
  id: z.number().int().min(1),
  name: z.string(),
  description: z.string().optional(),
})

export const listPlanet = os
  .input(z.object({
    limit: z.number().int().min(1).max(100).optional(),
    cursor: z.number().int().min(0).default(0),
  }))
  .handler(async ({ input }) => {
    return [{ id: 1, name: 'Earth' }]
  })

export const findPlanet = os
  .input(PlanetSchema.pick({ id: true }))
  .handler(async ({ input }) => {
    return { id: 1, name: 'Earth' }
  })

export const createPlanet = os
  .$context<{ headers: Headers }>()
  .use(({ context, next }) => {
    const user = parseJWT(context.headers.get('authorization')?.split(' ')[1])
    if (user) return next({ context: { user } })
    throw new ORPCError('UNAUTHORIZED')
  })
  .input(PlanetSchema.omit({ id: true }))
  .handler(async ({ input, context }) => {
    return { id: 1, name: input.name }
  })

export const router = {
  planet: { list: listPlanet, find: findPlanet, create: createPlanet },
}
```

### Create Server (Node.js)

```ts
import { createServer } from 'node:http'
import { RPCHandler } from '@orpc/server/node'
import { CORSPlugin } from '@orpc/server/plugins'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

const server = createServer(async (req, res) => {
  const { matched } = await handler.handle(req, res, {
    prefix: '/rpc',
    context: { headers: new Headers(req.headers as Record<string, string>) },
  })
  if (!matched) {
    res.statusCode = 404
    res.end('Not found')
  }
})

server.listen(3000)
```

### Create Client

```ts
import type { RouterClient } from '@orpc/server'
import { createORPCClient } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'

const link = new RPCLink({
  url: 'http://127.0.0.1:3000/rpc',
  headers: { Authorization: 'Bearer token' },
})

const client: RouterClient<typeof router> = createORPCClient(link)

// Fully typed calls
const planets = await client.planet.list({ limit: 10 })
const planet = await client.planet.find({ id: 1 })
```

### Server-Side Client (No HTTP)

Call procedures directly without HTTP overhead — essential for SSR in Next.js, Nuxt, SvelteKit, etc.

```ts
import { call, createRouterClient } from '@orpc/server'

// Single procedure call
const result = await call(router.planet.find, { id: 1 }, { context: {} })

// Router client (multiple procedures)
const serverClient = createRouterClient(router, {
  context: async () => ({ headers: await headers() }),
})
const planets = await serverClient.planet.list({ limit: 10 })
```

Use `.callable()` for individual procedures:

```ts
const getPlanet = os
  .input(z.object({ id: z.string() }))
  .handler(async ({ input }) => ({ id: input.id }))
  .callable({ context: {} })

const result = await getPlanet({ id: '123' })
```

See `references/api-reference.md` for full server-side calling patterns.

## Core Concepts

### Procedure Chain

```ts
const example = os
  .use(middleware)              // Apply middleware
  .input(z.object({...}))      // Validate input (Zod/Valibot/ArkType)
  .output(z.object({...}))     // Validate output (recommended for perf)
  .handler(async ({ input, context }) => { ... })  // Required
  .callable()                  // Make callable as regular function
  .actionable()                // Server Action compatibility
```

Only `.handler()` is required. All other chain methods are optional.

### Router

Routers are plain objects of procedures. They can be nested and support lazy loading:

```ts
const router = {
  ping: os.handler(async () => 'pong'),
  planet: os.lazy(() => import('./planet')),  // Code splitting
}
```

Apply middleware to all procedures in a router:

```ts
const router = os.use(authMiddleware).router({ ping, pong })
```

### Middleware

```ts
const authMiddleware = os
  .$context<{ headers: Headers }>()
  .middleware(async ({ context, next }) => {
    const user = await getUser(context.headers)
    if (!user) throw new ORPCError('UNAUTHORIZED')
    return next({ context: { user } })
  })
```

Built-in lifecycle middlewares: `onStart`, `onSuccess`, `onError`, `onFinish`.

### Context

Two types: **Initial Context** (provided at handler creation) and **Execution Context** (injected by middleware at runtime). See `references/api-reference.md`.

### Error Handling

```ts
// Normal approach
throw new ORPCError('NOT_FOUND', { message: 'Planet not found' })

// Type-safe approach
const base = os.errors({
  NOT_FOUND: { message: 'Not found' },
  RATE_LIMITED: { data: z.object({ retryAfter: z.number() }) },
})
```

**Warning**: `ORPCError.data` is sent to the client. Never include sensitive information.

### Event Iterator (SSE/Streaming)

```ts
const streaming = os
  .output(eventIterator(z.object({ message: z.string() })))
  .handler(async function* ({ input, lastEventId }) {
    while (true) {
      yield { message: 'Hello!' }
      await new Promise(r => setTimeout(r, 1000))
    }
  })
```

### File Upload/Download

```ts
const upload = os
  .input(z.file())
  .handler(async ({ input }) => {
    console.log(input.name)  // File name
    return { success: true }
  })
```

For uploads >100MB, use a dedicated upload solution or extend the body parser.

### Built-in Helpers

oRPC provides built-in helpers for common server tasks:

- **Cookies**: `getCookie`, `setCookie`, `deleteCookie` from `@orpc/server/helpers`
- **Cookie signing**: `sign`, `unsign` for tamper-proof cookies
- **Encryption**: `encrypt`, `decrypt` for sensitive data (AES-GCM with PBKDF2)
- **Rate limiting**: `@orpc/experimental-ratelimit` with Memory, Redis, Upstash, and Cloudflare adapters
- **Event publishing**: `@orpc/experimental-publisher` for distributed pub/sub with resume support

See `references/helpers.md` for full API and examples.

## Key Rules and Constraints

1. **Handler is required** - `.handler()` is the only required method on a procedure
2. **Output schema recommended** - Explicitly specify `.output()` for better TypeScript performance
3. **Middleware deduplication** - oRPC auto-deduplicates leading middleware; use context guards for manual dedup
4. **Error data is public** - Never put sensitive info in `ORPCError.data`
5. **Body parser conflicts** - Register framework body parsers AFTER oRPC middleware (Express, Fastify, Elysia)
6. **RPCHandler vs OpenAPIHandler** - RPCHandler uses proprietary protocol (for RPCLink only); OpenAPIHandler is REST/OpenAPI-compatible
7. **Lazy routers** - Use `os.lazy(() => import('./module'))` for code splitting; use standalone `lazy()` for faster type inference
8. **SSE auto-reconnect** - Standard SSE clients auto-reconnect; use `lastEventId` to resume streams
9. **File limitations** - No chunked/resumable uploads; File/Blob unsupported in AsyncIteratorObject
10. **React Native** - Fetch API has limitations (no File/Blob, no Event Iterator); use `expo/fetch` or RPC JSON Serializer workarounds

## Handler Setup Pattern

All adapters follow this pattern:

```ts
import { RPCHandler } from '@orpc/server/fetch' // or /node, /fastify, etc.

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

// Handle request with prefix and context
const { matched, response } = await handler.handle(request, {
  prefix: '/rpc',
  context: {},
})
```

## Client Setup Pattern

```ts
import { RPCLink } from '@orpc/client/fetch'        // HTTP
import { RPCLink } from '@orpc/client/websocket'     // WebSocket
import { RPCLink } from '@orpc/client/message-port'  // Message Port
```

## Common Errors

| Error Code | HTTP Status | When |
|-----------|------------|------|
| `BAD_REQUEST` | 400 | Input validation failure |
| `UNAUTHORIZED` | 401 | Missing/invalid auth |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `TIMEOUT` | 408 | Request timeout |
| `TOO_MANY_REQUESTS` | 429 | Rate limited |
| `INTERNAL_SERVER_ERROR` | 500 | Unhandled errors |

Non-ORPCError exceptions are automatically converted to `INTERNAL_SERVER_ERROR`.

## Reference Files

- **[API Reference](references/api-reference.md)** - Procedures, routers, middleware, context, errors, metadata, event iterators, server actions, file handling
- **[Adapters](references/adapters.md)** - All 20+ framework adapters with setup code (Next.js, Express, Hono, Fastify, WebSocket, Electron, etc.)
- **[Plugins](references/plugins.md)** - All built-in plugins (CORS, batch, retry, compression, CSRF, validation, etc.)
- **[OpenAPI](references/openapi.md)** - OpenAPI spec generation, handler, routing, input/output structure, Scalar UI, OpenAPILink
- **[Integrations](references/integrations.md)** - TanStack Query, React SWR, Pinia Colada, Better Auth, AI SDK, Sentry, Pino, OpenTelemetry
- **[Advanced](references/advanced.md)** - Testing, serialization, TypeScript best practices, publishing clients, body parsing, playgrounds, ecosystem
- **[Contract-First](references/contract-first.md)** - Contract-first development, tRPC migration guide, comparison with alternatives
- **[Helpers](references/helpers.md)** - Cookie management, signing, encryption, rate limiting, publisher with event resume
- **[NestJS](references/nestjs.md)** - NestJS integration with decorators, dependency injection, contract-first
