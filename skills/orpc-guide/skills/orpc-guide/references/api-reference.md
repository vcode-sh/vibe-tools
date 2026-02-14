# oRPC Core API Reference

Complete API reference for oRPC procedures, routers, middleware, context, errors, metadata, event iterators, server actions, and file handling.

## Procedures

The `os` builder creates procedures. Chain methods (all optional except `.handler()`):

```ts
import { os, type } from '@orpc/server'
import { z } from 'zod'

const example = os
  .use(aMiddleware)                              // Apply middleware
  .input(z.object({ name: z.string() }))         // Input validation
  .use(aMiddlewareWithInput, input => input.name) // Middleware with typed input
  .output(z.object({ id: z.number() }))          // Output validation
  .handler(async ({ input, context }) => {       // Required
    return { id: 1 }
  })
  .callable()    // Make callable as regular function
  .actionable()  // Server Action compatibility
```

### Built-in `type` Utility

For TypeScript-only types without runtime validation:

```ts
import { os, type } from '@orpc/server'

const example = os
  .input(type<{ value: number }>())
  .output(type<{ value: number }, number>(({ value }) => value))
  .handler(async ({ input }) => input)
```

**When to use**: Type-only validation when you trust the input source or want minimal runtime overhead.

### Initial Configuration

```ts
// Enforce void input (no input allowed)
const base = os.$input(z.void())

// Default route config (for OpenAPI generation)
const base = os.$route({ method: 'GET' })

// Metadata type (for custom metadata)
const base = os.$meta<ORPCMetadata>({})

// Configuration options
const base = os.$config({ dedupeLeadingMiddlewares: false })
```

### Reusability Pattern

Create reusable base procedures with common middleware:

```ts
// Public base (no auth)
const pub = os.use(logMiddleware)

// Authenticated base (requires auth)
const authed = pub.use(authMiddleware)

// Use the bases
const pubExample = pub.handler(async ({ context }) => {
  // No auth required
})

const authedExample = authed.handler(async ({ context }) => {
  // Auth required - context.user available
})
```

**Best Practice**: Define shared bases at the top of your file and use them consistently.

### Server-Side Calling

Call procedures directly without HTTP. Three methods:

**1. Using `.callable`**:

```ts
const getProcedure = os
  .input(z.object({ id: z.string() }))
  .handler(async ({ input }) => ({ id: input.id }))
  .callable({
    context: {} // Provide initial context if needed
  })

const result = await getProcedure({ id: '123' })
```

**2. Using `call` utility**:

```ts
import { call, createRouterClient } from '@orpc/server'

// Single procedure
const result = await call(router.planet.find, { id: 1 }, { context: {} })

// Router client (for multiple procedures)
const client = createRouterClient(router, {
  context: {} // or function: (clientCtx) => ({ ... })
})
const planet = await client.planet.find({ id: 1 })
```

**3. Using `createRouterClient`** (for multiple procedures):

`createRouterClient` supports client context:

```ts
interface ClientContext { cache?: boolean }

const client = createRouterClient(router, {
  context: ({ cache }: ClientContext) => {
    return cache ? { /* cached context */ } : { /* normal context */ }
  }
})

const result = await client.planet.find({ id: 1 }, { context: { cache: true } })
```

If `ClientContext` has a required property, oRPC enforces it when calling.

## Routers

Routers are plain nested objects of procedures:

```ts
const router = {
  ping: os.handler(async () => 'pong'),
  nested: {
    ping: os.handler(async () => 'pong')
  },
}
```

### Extending Router with Middleware

Apply middleware to all procedures in a router:

```ts
const router = os.use(requiredAuth).router({
  ping,
  pong,
  nested: {
    ping,
    pong
  }
})
```

**Pattern**: Middleware is applied to ALL procedures in the router object.

### Lazy Router (Code Splitting)

```ts
// Using os.lazy()
const router = {
  planet: os.lazy(() => import('./planet')),
}

// Standalone lazy (faster type inference)
import { lazy } from '@orpc/server'

const router = {
  planet: lazy(() => import('./planet')),
}
```

**When to use**: Large routers or conditional loading. Standalone `lazy()` is faster for type inference.

### Route Prefixes

Add route prefixes for OpenAPI path generation:

```ts
const router = os.prefix('/planets').router({
  list: listPlanet,   // → /planets/list
  find: findPlanet,   // → /planets/find
})
```

**Usage**: Primarily for OpenAPI spec generation. Does not affect RPC protocol routing.

### Type Utilities

Extract types from routers:

```ts
import type {
  InferRouterInputs,
  InferRouterOutputs,
  InferRouterInitialContexts,
  InferRouterCurrentContexts
} from '@orpc/server'

type Inputs = InferRouterInputs<typeof router>
type Outputs = InferRouterOutputs<typeof router>
type InitialContexts = InferRouterInitialContexts<typeof router>
type CurrentContexts = InferRouterCurrentContexts<typeof router>

// Access specific procedure types
type FindPlanetInput = Inputs['planet']['find']
type FindPlanetOutput = Outputs['planet']['find']
```

**Best Practice**: Use these types for shared type definitions across client and server.

## Middleware

### Basic Middleware

```ts
const authMiddleware = os
  .$context<{ something?: string }>()
  .middleware(async ({ context, next }) => {
    const result = await next({
      context: { user: { id: 1, name: 'John' } }
    })
    return result
  })
```

### Inline Middleware

Define middleware directly in a procedure chain:

```ts
const example = os
  .use(async ({ context, next }) => {
    console.log('Before handler')
    const result = await next()
    console.log('After handler')
    return result
  })
  .handler(async ({ context }) => {
    return 'Hello'
  })
```

### Context Injection/Guard

Inject and validate context:

```ts
const setting = os
  // Inject auth
  .use(async ({ context, next }) => {
    return next({
      context: { auth: await auth() }
    })
  })
  // Guard (throw if invalid)
  .use(async ({ context, next }) => {
    if (!context.auth) throw new ORPCError('UNAUTHORIZED')
    return next({
      context: { auth: context.auth }
    })
  })
  .handler(async ({ context }) => {
    console.log(context.auth) // Always defined here
  })
```

**Pattern**: First middleware injects, second guards. TypeScript narrows the type.

### Middleware with Input

Access input in middleware:

```ts
const canUpdate = os.middleware(async ({ context, next }, input: number) => {
  console.log('Updating ID:', input)
  return next()
})

// Direct use (input shape matches)
const ping = os
  .input(z.number())
  .use(canUpdate)
  .handler(async ({ input }) => {
    return 'Updated'
  })

// Map input if shapes differ
const pong = os
  .input(z.object({ id: z.number() }))
  .use(canUpdate, input => input.id)
  .handler(async ({ input }) => {
    return 'Updated'
  })
```

### mapInput for Middleware

Create a reusable mapped middleware:

```ts
const canUpdate = os.middleware(async ({ context, next }, input: number) => {
  return next()
})

// Map the input once
const mappedCanUpdate = canUpdate.mapInput((input: { id: number }) => input.id)

// Reuse the mapped version
const pong = os
  .input(z.object({ id: z.number() }))
  .use(mappedCanUpdate)
  .handler(async ({ input }) => {
    return 'Updated'
  })
```

### Middleware with Output (Caching)

Access output for caching:

```ts
const cacheMid = os.middleware(async ({ context, next, path }, input, output) => {
  const cacheKey = path.join('/') + JSON.stringify(input)

  // Check cache
  if (db.has(cacheKey)) {
    return output(db.get(cacheKey))
  }

  // Call handler
  const result = await next({})

  // Store in cache
  db.set(cacheKey, result.output)
  return result
})
```

**Pattern**: Use `output()` function to short-circuit with cached data.

### Concatenation

Chain multiple middlewares:

```ts
const concatMiddleware = aMiddleware
  .concat(os.middleware(async ({ next }) => next()))
  .concat(anotherMiddleware)
```

### Built-in Lifecycle Middlewares

```ts
import { onError, onFinish, onStart, onSuccess } from '@orpc/server'

const ping = os
  .use(onStart(() => {
    console.log('Before handler')
  }))
  .use(onSuccess(() => {
    console.log('On success')
  }))
  .use(onError(() => {
    console.log('On failure')
  }))
  .use(onFinish(() => {
    console.log('After handler (always runs)')
  }))
  .handler(async () => {
    return 'pong'
  })
```

**Order**: `onStart` → `handler` → `onSuccess`/`onError` → `onFinish`

## Context

### Initial Context (provided explicitly)

Context provided when handling requests:

```ts
const base = os.$context<{
  headers: Headers
  env: { DB_URL: string }
}>()

const handler = new RPCHandler(router)

handler.handle(request, {
  context: {
    headers: request.headers,
    env: { DB_URL: '***' }
  }
})
```

**When to use**: Framework-specific context (headers, env vars, request objects).

### Execution Context (injected by middleware)

Context injected by middleware at runtime:

```ts
const base = os.use(async ({ next }) => {
  return next({
    context: {
      headers: await headers(),
      cookies: await cookies()
    }
  })
})

// No context needed at handler.handle()
handler.handle(request, {
  context: {}
})
```

**When to use**: Shared context across all procedures (auth, database connections).

### Combining Both

Use both initial and execution context:

```ts
// Define initial context
const base = os.$context<{
  headers: Headers
  env: { DB_URL: string }
}>()

// Auth middleware (uses initial context)
const requireAuth = base.middleware(async ({ context, next }) => {
  const user = parseJWT(context.headers.get('authorization')?.split(' ')[1])
  if (user) return next({ context: { user } })
  throw new ORPCError('UNAUTHORIZED')
})

// Database middleware (uses initial context)
const dbProvider = base.middleware(async ({ context, next }) => {
  const client = new Client(context.env.DB_URL)
  try {
    await client.connect()
    return next({ context: { db: client } })
  } finally {
    await client.disconnect()
  }
})

// Combine middlewares
const getting = base
  .use(dbProvider)
  .use(requireAuth)
  .handler(async ({ context }) => {
    console.log(context.db)    // From dbProvider
    console.log(context.user)  // From requireAuth
  })
```

**Pattern**: Initial context → middleware injects → handler receives combined context.

## Error Handling

### Normal Approach

```ts
import { ORPCError } from '@orpc/server'

// Simple error
throw new ORPCError('NOT_FOUND')

// Error with message and data
throw new ORPCError('RATE_LIMITED', {
  message: 'You are being rate limited',
  data: { retryAfter: 60 }
})

// Non-ORPCError exceptions → INTERNAL_SERVER_ERROR
throw new Error('Something went wrong')
```

### Type-Safe Approach

Define errors with schemas:

```ts
const base = os.errors({
  RATE_LIMITED: {
    data: z.object({ retryAfter: z.number() })
  },
  UNAUTHORIZED: {},
})

const rateLimit = base.middleware(async ({ next, errors }) => {
  throw errors.RATE_LIMITED({
    message: 'Rate limited',
    data: { retryAfter: 60 }
  })
  return next()
})

const example = base
  .use(rateLimit)
  .errors({
    NOT_FOUND: {
      message: 'The resource was not found'
    }
  })
  .handler(async ({ input, errors }) => {
    throw errors.NOT_FOUND()
  })
```

**Benefits**: Type-safe error data, autocomplete for error codes, validated error payloads.

### Combining Both Approaches

You can mix both strategies. When you throw an `ORPCError` instance where the `code`, `status`, and `data` match errors defined in `.errors()`, oRPC treats it exactly as if you used the type-safe `errors.[code]()`:

```ts
const base = os.errors({
  RATE_LIMITED: {
    data: z.object({ retryAfter: z.number().int().min(1).default(1) }),
  },
  UNAUTHORIZED: {},
})

const rateLimit = base.middleware(async ({ next, errors }) => {
  // Both are equivalent:
  throw errors.RATE_LIMITED({ message: 'Rate limited', data: { retryAfter: 60 } })
  // OR
  throw new ORPCError('RATE_LIMITED', { message: 'Rate limited', data: { retryAfter: 60 } })
  return next()
})

const example = base.use(rateLimit).handler(async ({ input }) => {
  throw new ORPCError('BAD_REQUEST') // Unknown error (not in .errors())
})
```

### Error Codes and HTTP Status Mapping

| Error Code | HTTP Status |
|-----------|------------|
| `BAD_REQUEST` | 400 |
| `UNAUTHORIZED` | 401 |
| `FORBIDDEN` | 403 |
| `NOT_FOUND` | 404 |
| `METHOD_NOT_ALLOWED` | 405 |
| `NOT_ACCEPTABLE` | 406 |
| `TIMEOUT` | 408 |
| `CONFLICT` | 409 |
| `PRECONDITION_FAILED` | 412 |
| `PAYLOAD_TOO_LARGE` | 413 |
| `UNSUPPORTED_MEDIA_TYPE` | 415 |
| `UNPROCESSABLE_CONTENT` | 422 |
| `TOO_MANY_REQUESTS` | 429 |
| `CLIENT_CLOSED_REQUEST` | 499 |
| `INTERNAL_SERVER_ERROR` | 500 |
| `NOT_IMPLEMENTED` | 501 |
| `BAD_GATEWAY` | 502 |
| `SERVICE_UNAVAILABLE` | 503 |
| `GATEWAY_TIMEOUT` | 504 |

**Warning**: `ORPCError.data` is sent to the client. Never include sensitive information (passwords, tokens, internal details).

## Metadata

Custom metadata for procedures:

```ts
interface ORPCMetadata {
  cache?: boolean
}

const base = os
  .$meta<ORPCMetadata>({})
  .use(async ({ procedure, next, path }, input, output) => {
    // Skip cache if not enabled
    if (!procedure['~orpc'].meta.cache) {
      return await next()
    }

    // Check cache
    const cacheKey = path.join('/') + JSON.stringify(input)
    if (db.has(cacheKey)) {
      return output(db.get(cacheKey))
    }

    // Call handler and cache
    const result = await next()
    db.set(cacheKey, result.output)
    return result
  })

// Enable cache for this procedure
const example = base
  .meta({ cache: true })
  .handler(() => {
    return 'Cached result'
  })
```

**Pattern**: Define metadata type, check in middleware, set per procedure.

**Merging**: `.meta()` can be called multiple times. Each call spread-merges new metadata with existing.

```ts
const example = base
  .meta({ cache: true })
  .meta({ ttl: 60 })  // { cache: true, ttl: 60 }
  .handler(() => 'Hello')
```

## Event Iterator (SSE/Streaming)

### Basic

Return async generator for streaming:

```ts
const example = os.handler(async function* ({ input, lastEventId }) {
  while (true) {
    yield { message: 'Hello, world!' }
    await new Promise(resolve => setTimeout(resolve, 1000))
  }
})
```

**Client**: Receives server-sent events (SSE) or async iterator depending on link.

### With Output Validation

```ts
import { eventIterator } from '@orpc/server'

const example = os
  .output(eventIterator(z.object({ message: z.string() })))
  .handler(async function* () {
    yield { message: 'Hello!' }
    yield { message: 'World!' }
  })
```

**Best Practice**: Always validate event payloads with `eventIterator()`.

### Event Metadata and Last Event ID

```ts
import { withEventMeta } from '@orpc/server'

const example = os.handler(async function* ({ lastEventId }) {
  // Resume from last event if reconnecting
  if (lastEventId) {
    console.log('Resuming from:', lastEventId)
  }

  while (true) {
    yield withEventMeta(
      { message: 'Hello!' },
      {
        id: 'some-id',      // Event ID for reconnection
        retry: 10_000       // Retry interval in ms
      }
    )
    await new Promise(resolve => setTimeout(resolve, 1000))
  }
})
```

**Pattern**: Use `lastEventId` to resume streams on reconnect. Use `withEventMeta` to set event IDs.

### Stopping and Cleanup

```ts
const example = os.handler(async function* () {
  try {
    let count = 0
    while (true) {
      if (count >= 10) {
        return  // Stop gracefully
      }

      yield { message: `Count: ${count}` }
      count++
      await new Promise(resolve => setTimeout(resolve, 1000))
    }
  } finally {
    console.log('Cleanup logic here')  // Runs when client disconnects
  }
})
```

**Pattern**: Use `finally` block for cleanup. Client disconnect triggers cleanup automatically.

### EventPublisher (Lightweight, Synchronous)

In-memory pub/sub for real-time events:

```ts
import { EventPublisher } from '@orpc/server'

// Define event types
const publisher = new EventPublisher<{
  'something-updated': { id: string }
}>()

// Subscribe to events
const live = os.handler(async function* ({ signal }) {
  for await (const payload of publisher.subscribe('something-updated', { signal })) {
    yield payload
  }
})

// Publish events
const update = os
  .input(z.object({ id: z.string() }))
  .handler(({ input }) => {
    publisher.publish('something-updated', { id: input.id })
  })
```

**When to use**: In-process pub/sub. For distributed systems, use Redis Pub/Sub or similar.

**EventPublisher vs Publisher Helper**: `EventPublisher` (from `@orpc/server`) is lightweight and synchronous with no resume support. For distributed systems or resume support, use the Publisher Helper (`@orpc/experimental-publisher`) - see `references/helpers.md`.

### Dynamic Events

Subscribe to dynamic channels:

```ts
const publisher = new EventPublisher<Record<string, { message: string }>>()

const onMessage = os
  .input(z.object({ channel: z.string() }))
  .handler(async function* ({ input, signal }) {
    for await (const payload of publisher.subscribe(input.channel, { signal })) {
      yield payload.message
    }
  })

const sendMessage = os
  .input(z.object({
    channel: z.string(),
    message: z.string()
  }))
  .handler(({ input }) => {
    publisher.publish(input.channel, { message: input.message })
  })
```

**Pattern**: User subscribes to specific channel, events published to that channel.

## Server Actions

### Server Side

Package: `@orpc/react`

```sh
npm install @orpc/react@latest
```

```ts
'use server'
import { os } from '@orpc/server'
import { z } from 'zod'
import { redirect } from 'next/navigation'

export const ping = os
  .input(z.object({ name: z.string() }))
  .handler(async ({ input }) => {
    return `Hello, ${input.name}`
  })
  .actionable({
    context: async () => ({
      // Provide context here
    }),
    interceptors: [
      onSuccess(async output => {
        redirect(`/some-where`)
      }),
      onError(async error => {
        console.error(error)
      }),
    ],
  })
```

**Platform**: Only supported in **Next.js** and **TanStack Start**.

**Tip**: Use Execution Context instead of Initial Context for Server Actions.

### Client Side

```tsx
'use client'
import { ping } from './actions'

const [error, data] = await ping({ name: 'World' })

if (error) {
  if (error.defined) {
    console.log(error.data) // Typed error data
  } else {
    console.error(error)    // Unknown error
  }
} else {
  console.log(data)  // "Hello, World"
}
```

**Return Type**: `[error, data]` tuple for type-safe error handling.

### useServerAction Hook

React hook for server actions:

```tsx
import { useServerAction } from '@orpc/react/hooks'
import { isDefinedError, onError } from '@orpc/client'

const { execute, data, error, status } = useServerAction(someAction, {
  interceptors: [
    onError((error) => {
      if (isDefinedError(error)) {
        console.error(error.data)
      }
    }),
  ],
})

// In component
<button onClick={() => execute({ name: 'World' })}>
  {status === 'pending' ? 'Loading...' : 'Submit'}
</button>
```

**Status**: `'idle' | 'pending' | 'success' | 'error'`

### useOptimisticServerAction Hook

Optimistic UI updates while a server action executes:

```tsx
import { useOptimisticServerAction } from '@orpc/react/hooks'
import { onSuccessDeferred } from '@orpc/react'

export function MyComponent() {
  const [todos, setTodos] = useState<Todo[]>([])
  const { execute, optimisticState } = useOptimisticServerAction(someAction, {
    optimisticPassthrough: todos,
    optimisticReducer: (currentState, newTodo) => [...currentState, newTodo],
    interceptors: [
      onSuccessDeferred(({ data }) => {
        setTodos(prevTodos => [...prevTodos, data])
      }),
    ],
  })

  return (
    <div>
      <ul>
        {optimisticState.map(todo => <li key={todo.todo}>{todo.todo}</li>)}
      </ul>
      <form action={(form) => execute({ todo: form.get('todo') as string })}>
        <input type="text" name="todo" required />
        <button type="submit">Add Todo</button>
      </form>
    </div>
  )
}
```

**`onSuccessDeferred`**: Defers execution until after the optimistic update resolves. Import from `@orpc/react`.

### createFormAction Utility

Create form actions from procedures:

```tsx
import { createFormAction } from '@orpc/react'
import { redirect } from 'next/navigation'

export const myFormAction = createFormAction(procedure, {
  interceptors: [
    onSuccess(async () => redirect('/done'))
  ],
})

// In JSX
<form action={myFormAction}>
  <input type="text" name="user[name]" required />
  <input type="number" name="user[age]" required />
  <button type="submit">Submit</button>
</form>
```

**Pattern**: Nested field names use bracket notation: `user[name]`.

**Auto-conversion**: `createFormAction` automatically converts `ORPCError` with status 401, 403, or 404 into corresponding Next.js error responses (`unauthorized`, `forbidden`, `notFound`).

### Form Data Utilities

Handle form validation errors:

```tsx
import { getIssueMessage, parseFormData } from '@orpc/react'

<form action={(form) => { execute(parseFormData(form)) }}>
  <input name="user[name]" type="text" />
  <span>{getIssueMessage(error, 'user[name]')}</span>

  <input name="user[age]" type="number" />
  <span>{getIssueMessage(error, 'user[age]')}</span>

  <button type="submit">Submit</button>
</form>
```

**Pattern**: `parseFormData()` converts FormData to object. `getIssueMessage()` extracts field-specific errors.

**Import paths**: `parseFormData` and `getIssueMessage` are available from both `@orpc/openapi-client/helpers` (original) and `@orpc/react` (re-export).

## File Upload and Download

### Upload

```ts
import { z } from 'zod'

const upload = os
  .input(z.file())
  .handler(async ({ input }) => {
    console.log(input.name)      // File name
    console.log(input.size)      // File size
    console.log(input.type)      // MIME type

    const content = await input.text()  // Read as text
    const buffer = await input.arrayBuffer()  // Read as buffer

    return { success: true }
  })
```

**Supported**: Single files, multiple files in object/array, nested structures.

### Download

```ts
const download = os
  .output(z.object({
    file: z.instanceof(File)
  }))
  .handler(async ({ input }) => {
    return {
      file: new File(
        ['Hello World'],
        'hello.txt',
        { type: 'text/plain' }
      )
    }
  })
```

**Best Practice**: For large files, use lazy file libraries (`@mjackson/lazy-file` or `Bun.file`) to reduce memory usage.

### Limitations

- For uploads >100MB: Use dedicated upload solution (Uploadthing, S3 presigned URLs) or extend body parser
- oRPC does NOT support chunked or resumable uploads
- File/Blob unsupported in AsyncIteratorObject (streaming)

## RPC Handler

### Basic Setup

```ts
import { RPCHandler } from '@orpc/server/fetch' // or /node

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [
    onError((error) => console.error(error))
  ],
})

const { matched, response } = await handler.handle(request, {
  prefix: '/rpc',
  context: {},
})
```

**matched**: `true` if route matched, `false` if no matching procedure.

**response**: Response object (or `undefined` if not matched).

### Supported Data Types (RPC Protocol)

The RPC protocol (used by RPCLink) supports:

- **Primitives**: `string`, `number` (including `NaN`), `boolean`, `null`, `undefined`
- **Dates**: `Date` (including Invalid Date)
- **BigInt**: `BigInt`
- **RegExp**: `RegExp`
- **URL**: `URL`
- **Collections**: `Record`, `Array`, `Set`, `Map`
- **Binary**: `Blob`, `File`
- **Streaming**: `AsyncIteratorObject` (root level only)

**Limitation**: AsyncIteratorObject only supported at root level. Cannot nest in objects/arrays.

### Filtering Procedures

Filter which procedures are exposed:

```ts
const handler = new RPCHandler(router, {
  filter: ({ contract, path }) => {
    // Hide internal procedures
    return !contract['~orpc'].route.tags?.includes('internal')
  }
})
```

**When to use**: Expose different procedures to different clients (public API vs internal).

### Default Plugin

**StrictGetMethodPlugin** is enabled by default for HTTP adapters:

```ts
const handler = new RPCHandler(router, {
  strictGetMethodPluginEnabled: true  // Default
})
```

**Behavior**: Enforces GET method for procedures with `$route({ method: 'GET' })`.

### Handler Options

```ts
const handler = new RPCHandler(router, {
  plugins: [],             // List of plugins
  interceptors: [],        // List of interceptors
  filter: () => true,      // Filter procedures
  strictGetMethodPluginEnabled: true,  // Default plugin
})
```

### Handle Options

```ts
const { matched, response } = await handler.handle(request, {
  prefix: '/rpc',          // Route prefix
  context: {},             // Initial context
})
```

**Pattern**: Use `prefix` to mount at specific path. Use `context` to provide framework-specific data.

## Additional Notes

### TypeScript Performance

For large routers, explicitly specify output schemas:

```ts
const example = os
  .input(z.object({ id: z.number() }))
  .output(z.object({ name: z.string() }))  // Recommended
  .handler(async ({ input }) => {
    return { name: 'World' }
  })
```

**Why**: TypeScript infers output from handler return type, which can be slow for complex types.

### Middleware Deduplication

Leading middlewares are auto-deduplicated:

```ts
const base = os.use(middleware1).use(middleware2)
const proc1 = base.use(middleware3).handler(...)
const proc2 = base.use(middleware3).handler(...)

// middleware3 runs once per request, not twice
```

**Override**: Set `$config({ dedupeLeadingMiddlewares: false })` to disable.

### Context Type Merging

Context types merge through middleware chains:

```ts
const base = os.$context<{ headers: Headers }>()

const withDb = base.use(async ({ next }) => {
  return next({ context: { db: client } })
})

const withAuth = withDb.use(async ({ next }) => {
  return next({ context: { user: user } })
})

// Handler sees all context:
const proc = withAuth.handler(async ({ context }) => {
  context.headers  // From initial
  context.db       // From withDb
  context.user     // From withAuth
})
```

**Pattern**: Each middleware adds to context. TypeScript merges types automatically.

### Middleware Validation Order

Control when middlewares run relative to validation:

```ts
// All middlewares run AFTER input validation and BEFORE output validation
const base = os.$config({
  initialInputValidationIndex: Number.NEGATIVE_INFINITY,
  initialOutputValidationIndex: Number.NEGATIVE_INFINITY,
})
```

By default, middlewares registered before `.input()` run before input validation, and those after `.output()` run before output validation.

## Client Utilities

### Creating Clients

```ts
import { createORPCClient, onError } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'
import type { RouterClient } from '@orpc/server'
import type { ContractRouterClient } from '@orpc/contract'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  headers: () => ({ authorization: 'Bearer token' }),
  interceptors: [onError((error) => console.error(error))],
})

// From router type
const client: RouterClient<typeof router> = createORPCClient(link)
// From contract type
const client: ContractRouterClient<typeof contract> = createORPCClient(link)
```

### Merge Clients

Combine multiple clients into a single object:

```ts
const clientA: RouterClient<typeof routerA> = createORPCClient(linkA)
const clientB: RouterClient<typeof routerB> = createORPCClient(linkB)

export const orpc = { a: clientA, b: clientB }
```

### Type Inference Utilities

Extract types from any client:

```ts
import type {
  InferClientInputs,
  InferClientOutputs,
  InferClientBodyInputs,
  InferClientBodyOutputs,
  InferClientErrors,
  InferClientErrorUnion,
  InferClientContext,
} from '@orpc/client'

type Inputs = InferClientInputs<typeof client>
type Outputs = InferClientOutputs<typeof client>
type BodyInputs = InferClientBodyInputs<typeof client>
type BodyOutputs = InferClientBodyOutputs<typeof client>
type Errors = InferClientErrors<typeof client>
type AllErrors = InferClientErrorUnion<typeof client>
type Context = InferClientContext<typeof client>

// Access specific procedure types
type FindInput = Inputs['planet']['find']
type FindOutput = Outputs['planet']['find']
```

- `InferClientBodyInputs` / `InferClientBodyOutputs` extract only the `body` portion when using detailed input/output structure
- `InferClientErrorUnion` returns a union of all error types across all endpoints

### Safe Error Handling (Client)

Type-safe error handling with `safe` and `isDefinedError`:

```ts
import { isDefinedError, safe } from '@orpc/client'

const [error, data, isDefined] = await safe(client.planet.find({ id: 1 }))
// or: const { error, data, isDefined } = await safe(client.planet.find({ id: 1 }))

if (isDefinedError(error)) {
  console.log(error.code)  // Type-safe error code
  console.log(error.data)  // Type-safe error data
} else if (error) {
  console.error(error)  // Unknown error
} else {
  console.log(data)  // Success
}
```

- `safe` works like try/catch but infers error types
- Supports both tuple `[error, data, isDefined]` and object `{ error, data, isDefined }` styles
- `isDefined` can replace `isDefinedError`

### Safe Client

Wrap all procedure calls with `safe` automatically:

```ts
import { createSafeClient } from '@orpc/client'

const safeClient = createSafeClient(client)
const [error, data] = await safeClient.planet.find({ id: 1 })
```

### consumeEventIterator

Consume event iterators with lifecycle callbacks:

```ts
import { consumeEventIterator } from '@orpc/client'

const cancel = consumeEventIterator(client.streaming(), {
  onEvent: (event) => console.log(event.message),
  onError: (error) => console.error(error),
  onSuccess: (value) => console.log(value),
  onFinish: (state) => console.log(state),
})

// Stop after 1 second
setTimeout(() => cancel(), 1000)
```

Accepts both promises and event iterators. Passing a promise directly lets it infer correct error types.

### Client Event Iterator

```ts
const iterator = await client.streaming()

for await (const event of iterator) {
  console.log(event.message)
}

// Stop manually with signal
const controller = new AbortController()
const iterator = await client.streaming(undefined, { signal: controller.signal })
setTimeout(() => controller.abort(), 1000)

// Or stop with .return()
await iterator.return()
```

**Error Handling**: Unlike traditional SSE, Event Iterator does NOT auto-retry. Use Client Retry Plugin for auto-retry.

## See Also

- Core concepts and quick start in SKILL.md
- Framework adapters: `references/adapters.md`
- Built-in plugins (CORS, batch, retry, etc.): `references/plugins.md`
- OpenAPI integration: `references/openapi.md`
- Helpers (cookies, encryption, rate limiting): `references/helpers.md`
