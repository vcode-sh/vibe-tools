# oRPC Contract-First & Migration Reference

Reference for contract-first development patterns, tRPC migration steps, and feature comparison with alternatives.

## Contract-First Development

### Define Contract

Package: `@orpc/contract`

Install the contract package separately for contract-first development:

```bash
npm install @orpc/contract@latest
```

Define contracts without implementing handlers:

```typescript
import { oc } from '@orpc/contract'
import * as z from 'zod'

const PlanetSchema = z.object({
  id: z.number().int().min(1),
  name: z.string(),
  description: z.string().optional(),
})

export const listPlanetContract = oc
  .input(z.object({
    limit: z.number().int().min(1).max(100).optional(),
    cursor: z.number().int().min(0).default(0),
  }))
  .output(z.array(PlanetSchema))

export const findPlanetContract = oc
  .input(PlanetSchema.pick({ id: true }))
  .output(PlanetSchema)

export const createPlanetContract = oc
  .input(PlanetSchema.omit({ id: true }))
  .output(PlanetSchema)

export const contract = {
  planet: {
    list: listPlanetContract,
    find: findPlanetContract,
    create: createPlanetContract,
  },
}
```

### Type Utilities

Extract types from contracts:

```typescript
import type { InferContractRouterInputs, InferContractRouterOutputs } from '@orpc/contract'

type Inputs = InferContractRouterInputs<typeof contract>
type Outputs = InferContractRouterOutputs<typeof contract>

// Access specific route types
type FindPlanetInput = Inputs['planet']['find']
type FindPlanetOutput = Outputs['planet']['find']
```

### Implement Contract

Package: `@orpc/server`

Implement the contract on the server side:

```typescript
import { implement } from '@orpc/server'

const os = implement(contract)

const listPlanet = os.planet.list.handler(({ input }) => {
  // Implementation with type-safe input
  return []
})

const findPlanet = os.planet.find.handler(({ input }) => {
  // input.id is type-safe
  return { id: 123, name: 'Earth' }
})

const createPlanet = os.planet.create.handler(({ input }) => {
  // input.name and input.description are type-safe
  return { id: 123, name: input.name }
})

const router = os.router({
  planet: {
    list: listPlanet,
    find: findPlanet,
    create: createPlanet
  },
})
```

### Router to Contract (Export for Client)

Convert router to minified contract JSON for client use:

```typescript
import { unlazyRouter } from '@orpc/server'
import { minifyContractRouter } from '@orpc/contract'
import fs from 'node:fs'

const resolvedRouter = await unlazyRouter(router)
const minifiedRouter = minifyContractRouter(router)

// Export contract JSON
fs.writeFileSync('./contract.json', JSON.stringify(minifiedRouter))
```

Import on client:

```typescript
import contract from './contract.json'

const link = new OpenAPILink(contract as typeof router, {
  url: 'http://localhost:3000/api',
})
```

### Populate Contract Router Paths

Add path information to contracts for frameworks requiring explicit paths (like NestJS):

```ts
import { oc, populateContractRouterPaths } from '@orpc/contract'

export const contract = populateContractRouterPaths({
  planet: {
    list: listPlanetContract,
    find: findPlanetContract,
  },
})
```

## Migration from tRPC

### Concept Mapping

| tRPC | oRPC |
|------|------|
| `t.router()` | Plain object `{}` |
| `t.procedure` | `os` |
| `t.context()` | `os.$context()` |
| `t.middleware()` | `os.middleware()` |
| `.input(schema)` | `.input(schema)` |
| `.output(schema)` | `.output(schema)` |
| `TRPCError` | `ORPCError` |
| superjson | Built-in support |

### Install Dependencies

```bash
# Remove tRPC
npm uninstall @trpc/server @trpc/client @trpc/tanstack-react-query

# Install oRPC
npm install @orpc/server@latest @orpc/client@latest @orpc/tanstack-query@latest
```

### Base Setup

Replace tRPC initialization:

```typescript
// Before (tRPC)
import { initTRPC, TRPCError } from '@trpc/server'

const t = initTRPC.context<Context>().create()

export const router = t.router
export const publicProcedure = t.procedure
```

```typescript
// After (oRPC)
import { ORPCError, os } from '@orpc/server'

export async function createRPCContext(opts: { headers: Headers }) {
  const session = await auth()
  return { headers: opts.headers, session }
}

const o = os.$context<Awaited<ReturnType<typeof createRPCContext>>>()

const timingMiddleware = o.middleware(async ({ next, path }) => {
  const start = Date.now()

  try {
    return await next()
  } finally {
    console.log(`[oRPC] ${path} took ${Date.now() - start}ms`)
  }
})

export const publicProcedure = o.use(timingMiddleware)

export const protectedProcedure = publicProcedure.use(({ context, next }) => {
  if (!context.session?.user) {
    throw new ORPCError('UNAUTHORIZED')
  }

  return next({
    context: {
      session: {
        ...context.session,
        user: context.session.user
      }
    },
  })
})
```

### Procedures

Convert tRPC procedures to oRPC:

```typescript
// Before (tRPC)
const planetRouter = router({
  list: publicProcedure
    .input(z.object({ cursor: z.number().int().default(0) }))
    .query(({ input }) => ({
      planets: [{ name: 'Earth', distanceFromSun: 149.6 }],
      nextCursor: input.cursor + 1,
    })),

  create: protectedProcedure
    .input(z.object({ name: z.string().min(1) }))
    .mutation(async ({ ctx, input }) => {
      // ...
    }),
})
```

```typescript
// After (oRPC)
export const planetRouter = {
  list: publicProcedure
    .input(z.object({ cursor: z.number().int().default(0) }))
    .handler(({ input }) => ({
      planets: [{ name: 'Earth', distanceFromSun: 149.6 }],
      nextCursor: input.cursor + 1,
    })),

  create: protectedProcedure
    .input(z.object({
      name: z.string().min(1),
      distanceFromSun: z.number().positive()
    }))
    .handler(async ({ context, input }) => {
      // context has session.user typed
      // ...
    }),
}
```

### Router

Replace tRPC router:

```typescript
// Before (tRPC)
import { router } from './trpc'
import { planetRouter } from './routers/planet'

export const appRouter = router({
  planet: planetRouter,
})

export type AppRouter = typeof appRouter
```

```typescript
// After (oRPC)
import { planetRouter } from './routers/planet'

export const appRouter = {
  planet: planetRouter,
}

export type AppRouter = typeof appRouter
```

### Server Setup (Next.js)

```ts
// Before (tRPC) — pages/api/trpc/[trpc].ts
import { createNextApiHandler } from '@trpc/server/adapters/next'
export default createNextApiHandler({ router: appRouter, createContext })
```

```ts
// After (oRPC) — app/rpc/[[...rest]]/route.ts
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(appRouter, {
  interceptors: [onError((error) => console.error(error))],
})

async function handleRequest(request: Request) {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: await createRPCContext({ headers: request.headers }),
  })
  return response ?? new Response('Not found', { status: 404 })
}

export const GET = handleRequest
export const POST = handleRequest
```

### Client Setup

```ts
// Before (tRPC)
import { createTRPCClient, httpBatchLink } from '@trpc/client'
const trpc = createTRPCClient({ links: [httpBatchLink({ url: '/api/trpc' })] })
```

```ts
// After (oRPC)
import { createORPCClient } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'
import type { RouterClient } from '@orpc/server'

const link = new RPCLink({
  url: `${window.location.origin}/rpc`,
  interceptors: [onError((error) => console.error(error))],
})

const client: RouterClient<typeof appRouter> = createORPCClient(link)
```

### TanStack Query

```ts
// Before (tRPC)
import { createTRPCReact } from '@trpc/react-query'
const trpc = createTRPCReact<AppRouter>()

// After (oRPC)
import { createTanstackQueryUtils } from '@orpc/tanstack-query'
const orpc = createTanstackQueryUtils(client)
```

**Note**: In oRPC, there are no separate `.query`, `.mutation`, or `.subscription` methods. Use `.handler` for all.

**Tip**: For a quick way to enhance your existing tRPC app with oRPC features without fully migrating, see the tRPC Integration in `references/openapi.md`.

## Comparison with Alternatives

| Feature | oRPC | tRPC | ts-rest | Hono |
|---------|------|------|---------|------|
| End-to-end Type-safe I/O | Yes | Yes | Yes | Yes |
| End-to-end Type-safe Errors | Yes | Partial | Yes | Yes |
| End-to-end Type-safe File/Blob | Yes | Partial | No | No |
| End-to-end Type-safe Streaming | Yes | Yes | No | No |
| TanStack Query (React/Vue/Solid/Svelte/Angular) | Yes | React only | Partial | No |
| Contract-First Approach | Yes | No | Yes | Yes |
| Without Contract-First | Yes | Yes | No | Yes |
| OpenAPI Support | Yes | Partial | Partial | Yes |
| OpenAPI Multiple Schema Support | Yes | No | No | Yes |
| Bracket Notation Support | Yes | No | No | No |
| Server Actions | Yes | Yes | No | No |
| Lazy Router | Yes | Yes | No | No |
| Native Types (Date, URL, Set, Map) | Yes | Partial | No | No |
| Standard Schema (Zod, Valibot, ArkType) | Yes | Yes | No | Partial |
| Built-in Plugins (CORS, CSRF, Retry) | Yes | No | No | Yes |
| Batch Requests | Yes | Yes | No | No |
| WebSockets | Yes | Yes | No | No |
| Cloudflare WebSocket Hibernation | Yes | No | No | No |
| NestJS Integration | Yes | Partial | Yes | No |
| Message Port (Electron, Workers, Extensions) | Yes | Partial | No | No |

## See Also

- Core API (procedures, middleware, context, errors): `references/api-reference.md`
- OpenAPI integration: `references/openapi.md`
- NestJS integration (contract-first with decorators): `references/nestjs.md`
- Framework adapters: `references/adapters.md`
