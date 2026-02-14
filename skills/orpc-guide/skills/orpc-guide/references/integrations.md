# oRPC Integrations Reference

Complete reference for integrating oRPC with popular frameworks and tools.

## TanStack Query

Package: `@orpc/tanstack-query`

```sh
npm install @orpc/tanstack-query@latest
```

### Setup
```ts
import { createTanstackQueryUtils } from '@orpc/tanstack-query'

export const orpc = createTanstackQueryUtils(client)
```

### Query Options
```ts
const query = useQuery(orpc.planet.find.queryOptions({
  input: { id: 123 },
  context: { cache: true },
}))
```

### Streamed Query Options (Experimental)
```ts
const query = useQuery(orpc.streamed.experimental_streamedOptions({
  input: { id: 123 },
  queryFnOptions: { refetchMode: 'reset', maxChunks: 3 },
  retry: true,
}))
```

### Live Query Options (Experimental)
```ts
const query = useQuery(orpc.live.experimental_liveOptions({
  input: { id: 123 },
  retry: true,
}))
```

### Infinite Query
```ts
const query = useInfiniteQuery(orpc.planet.list.infiniteOptions({
  input: (pageParam: number | undefined) => ({ limit: 10, offset: pageParam }),
  initialPageParam: undefined,
  getNextPageParam: lastPage => lastPage.nextPageParam,
}))
```

### Mutation
```ts
const mutation = useMutation(orpc.planet.create.mutationOptions({
  context: { cache: true },
}))

mutation.mutate({ name: 'Earth' })
```

### Query/Mutation Keys
```ts
const queryClient = useQueryClient()

// Invalidate all planet queries
queryClient.invalidateQueries({ queryKey: orpc.planet.key() })

// Update specific query data
queryClient.setQueryData(
  orpc.planet.find.queryKey({ input: { id: 123 } }),
  (old) => ({ ...old, id: 123, name: 'Earth' })
)
```

### skipToken
```ts
const query = useQuery(
  orpc.planet.list.queryOptions({
    input: search ? { search } : skipToken,
  })
)
```

### Calling Clients Directly
```ts
const planet = await orpc.planet.find.call({ id: 123 })
```

Alias for the corresponding procedure client call.

### Key Conflict Avoidance

Pass a unique base key to prevent conflicts between multiple utils:

```ts
const userORPC = createTanstackQueryUtils(userClient, { path: ['user'] })
const postORPC = createTanstackQueryUtils(postClient, { path: ['post'] })
```

### Key Types

- `.key()` - Partial matching key for invalidation/status checks
- `.queryKey()` - Full matching key for query options
- `.streamedKey()` - Full matching key for streamed query options
- `.infiniteKey()` - Full matching key for infinite query options
- `.mutationKey()` - Full matching key for mutation options

### Default Options

Configure defaults for all query/mutation utilities:

```ts
const orpc = createTanstackQueryUtils(client, {
  experimental_defaults: {
    planet: {
      find: {
        queryOptions: { staleTime: 60 * 1000, retry: 3 },
      },
      create: {
        mutationOptions: {
          onSuccess: (output, input, _, ctx) => {
            ctx.client.invalidateQueries({ queryKey: orpc.planet.key() })
          },
        },
      },
    },
  },
})

// User-provided options override defaults
const query = useQuery(orpc.planet.find.queryOptions({
  input: { id: 123 },
  staleTime: 0, // overrides default
}))
```

### Operation Context

TanStack Query integration adds operation context to client context:

```ts
import {
  TANSTACK_QUERY_OPERATION_CONTEXT_SYMBOL,
  TanstackQueryOperationContext,
} from '@orpc/tanstack-query'

interface ClientContext extends TanstackQueryOperationContext {}

const GET_OPERATION_TYPE = new Set(['query', 'streamed', 'live', 'infinite'])

const link = new RPCLink<ClientContext>({
  url: 'http://localhost:3000/rpc',
  method: ({ context }) => {
    const type = context[TANSTACK_QUERY_OPERATION_CONTEXT_SYMBOL]?.type
    return type && GET_OPERATION_TYPE.has(type) ? 'GET' : 'POST'
  },
})
```

### Reactive Options (Vue/Solid)

```ts
// Vue - computed options
const query = useQuery(computed(
  () => orpc.planet.find.queryOptions({ input: { id: id.value } })
))

// Solid - function options
const query = useQuery(
  () => orpc.planet.find.queryOptions({ input: { id: id() } })
)
```

### Error Handling
```ts
import { isDefinedError } from '@orpc/client'

const mutation = useMutation(orpc.planet.create.mutationOptions({
  onError: (error) => {
    if (isDefinedError(error)) {
      // Handle type-safe error
    }
  }
}))
```

### Client Context Note

oRPC excludes client context from query keys. Manually override query keys if needed:

```ts
const query = useQuery(orpc.planet.find.queryOptions({
  context: { cache: true },
  queryKey: [['planet', 'find'], { context: { cache: true } }],
  retry: true, // Prefer built-in retry over oRPC Client Retry Plugin
}))
```

### Hydration (SSR)
```ts
import { StandardRPCJsonSerializer } from '@orpc/client/standard'

const serializer = new StandardRPCJsonSerializer({ customJsonSerializers: [] })

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      queryKeyHashFn(queryKey) {
        const [json, meta] = serializer.serialize(queryKey)
        return JSON.stringify({ json, meta })
      },
      staleTime: 60 * 1000,
    },
    dehydrate: {
      serializeData(data) {
        const [json, meta] = serializer.serialize(data)
        return { json, meta }
      },
    },
    hydrate: {
      deserializeData(data) {
        return serializer.deserialize(data.json, data.meta)
      },
    },
  },
})
```

### Key Type Filter

Filter keys by operation type:

```ts
// Invalidate only regular queries (not infinite)
queryClient.invalidateQueries({ queryKey: orpc.planet.key({ type: 'query' }) })
```

## React SWR

Package: `@orpc/experimental-react-swr`

```sh
npm install @orpc/experimental-react-swr@latest
```

### Setup
```ts
import { createSWRUtils } from '@orpc/experimental-react-swr'

export const orpc = createSWRUtils(client)
```

### Data Fetching
```ts
import useSWR from 'swr'

const { data, error, isLoading } = useSWR(
  orpc.planet.find.key({ input: { id: 123 } }),
  orpc.planet.find.fetcher({ context: { cache: true } }),
)
```

### Infinite Queries
```ts
import useSWRInfinite from 'swr/infinite'

const { data, size, setSize } = useSWRInfinite(
  (index, previousPageData) => {
    if (previousPageData && !previousPageData.nextCursor) return null
    return orpc.planet.list.key({ input: { cursor: previousPageData?.nextCursor } })
  },
  orpc.planet.list.fetcher({ context: { cache: true } }),
)
```

### Subscriptions
```ts
import useSWRSubscription from 'swr/subscription'

const { data, error } = useSWRSubscription(
  orpc.streamed.key({ input: { id: 3 } }),
  orpc.streamed.subscriber({ context: { cache: true }, maxChunks: 10 }),
)
```

### Mutations
```ts
import useSWRMutation from 'swr/mutation'

const { trigger, isMutating } = useSWRMutation(
  orpc.planet.list.key(),
  orpc.planet.create.mutator({ context: { cache: true } }),
)

trigger({ name: 'New Planet' })
```

### Streamed Subscription (SWR)
```ts
import useSWRSubscription from 'swr/subscription'

const { data } = useSWRSubscription(
  orpc.streamed.key({ input: { id: 3 } }),
  orpc.streamed.subscriber({ context: { cache: true }, maxChunks: 10 }),
)
```

### Live Subscription (SWR)
```ts
const { data } = useSWRSubscription(
  orpc.live.key({ input: { id: 3 } }),
  orpc.live.subscriber(),
)
```

### Keys (SWR)
```ts
import { mutate } from 'swr'

// Revalidate all planet queries
mutate(orpc.planet.key())

// Revalidate specific query
mutate(orpc.planet.find.key({ input: { id: 123 } }))
```

### Manual Revalidation with Matcher

```ts
import { mutate } from 'swr'

// Match all planet queries
mutate(orpc.planet.matcher())

// Match specific with strategy
mutate(orpc.planet.find.matcher({ input: { id: 123 }, strategy: 'exact' }))
```

### Calling Clients Directly
```ts
const planet = await orpc.planet.find.call({ id: 123 })
```

### Operation Context

Access SWR operation context in links for method selection:

```ts
import {
  SWR_OPERATION_CONTEXT_SYMBOL,
  SWROperationContext,
} from '@orpc/experimental-react-swr'

interface ClientContext extends SWROperationContext {}

const GET_OPERATION_TYPE = new Set(['fetcher', 'subscriber', 'liveSubscriber'])

const link = new RPCLink<ClientContext>({
  url: 'http://localhost:3000/rpc',
  method: ({ context }) => {
    const type = context[SWR_OPERATION_CONTEXT_SYMBOL]?.type
    return type && GET_OPERATION_TYPE.has(type) ? 'GET' : 'POST'
  },
})
```

## Pinia Colada (Vue)

Package: `@orpc/vue-colada`

```sh
npm install @orpc/vue-colada@latest @pinia/colada@latest
```

### Setup
```ts
import { createORPCVueColadaUtils } from '@orpc/vue-colada'

export const orpc = createORPCVueColadaUtils(client)
```

### Query
```ts
import { useQuery } from '@pinia/colada'

const query = useQuery(orpc.planet.find.queryOptions({
  input: { id: 123 },
  context: { cache: true },
}))
```

### Mutation
```ts
import { useMutation } from '@pinia/colada'

const mutation = useMutation(orpc.planet.create.mutationOptions({
  context: { cache: true },
}))

mutation.mutate({ name: 'Earth' })
```

### Infinite Query (Pinia Colada)
```ts
import { useInfiniteQuery } from '@pinia/colada'

const query = useInfiniteQuery(orpc.planet.list.infiniteOptions({
  input: (pageParam) => ({ limit: 10, offset: pageParam }),
  initialPageParam: undefined,
  getNextPageParam: lastPage => lastPage.nextPageParam,
}))
```

### Streamed Query (Pinia Colada)
```ts
const query = useQuery(orpc.streamed.experimental_streamedOptions({
  input: { id: 123 },
  queryFnOptions: { refetchMode: 'reset', maxChunks: 3 },
}))
```

### Keys (Pinia Colada)
```ts
const queryClient = useQueryCache()

// Invalidate all planet queries
queryClient.invalidateQueries({ key: orpc.planet.key() })

// Update specific query
queryClient.setQueryData(
  orpc.planet.find.queryKey({ input: { id: 123 } }),
  (old) => ({ ...old, name: 'Updated' })
)
```

### Error Handling
```ts
import { isDefinedError } from '@orpc/client'

const mutation = useMutation(orpc.planet.create.mutationOptions())

// In template
if (isDefinedError(mutation.error.value)) {
  console.log(mutation.error.value.data)
}
```

**Warning**: Pinia Colada is still in an unstable stage. This integration may introduce breaking changes.

## Better Auth

### Define Context Headers
```ts
import { os } from '@orpc/server'

export const base = os.$context<{ headers: Headers }>()
```

### Create Auth Middleware
```ts
import { auth } from './auth'
import { base } from './context'
import { ORPCError } from '@orpc/server'

export const authMiddleware = base.middleware(async ({ context, next }) => {
  const sessionData = await auth.api.getSession({
    headers: context.headers,
  })

  if (!sessionData?.session || !sessionData?.user) {
    throw new ORPCError('UNAUTHORIZED')
  }

  return next({
    context: {
      session: sessionData.session,
      user: sessionData.user,
    },
  })
})
```

### Usage
```ts
export const authorized = base.use(authMiddleware)

export const getMessages = authorized.handler(({ context }) => {
  // context.session and context.user guaranteed to be defined
})
```

### Alternative: Request Headers Plugin

Instead of manual context definition, use the Request Headers Plugin:

```ts
import { RequestHeadersPlugin, RequestHeadersPluginContext } from '@orpc/server/plugins'

interface ORPCContext extends RequestHeadersPluginContext {}

const base = os.$context<ORPCContext>()

export const authMiddleware = base.middleware(async ({ context, next }) => {
  const sessionData = await auth.api.getSession({
    headers: context.reqHeaders,
  })

  if (!sessionData?.session || !sessionData?.user) {
    throw new ORPCError('UNAUTHORIZED')
  }

  return next({
    context: { session: sessionData.session, user: sessionData.user },
  })
})

const handler = new RPCHandler(router, {
  plugins: [new RequestHeadersPlugin()],
})
```

## AI SDK

**Requires**: AI SDK v5.0.0 or later.

### Server
```ts
import { os, streamToEventIterator, type } from '@orpc/server'
import { convertToModelMessages, streamText, UIMessage } from 'ai'
import { google } from '@ai-sdk/google'

export const chat = os
  .input(type<{ chatId: string, messages: UIMessage[] }>())
  .handler(async ({ input }) => {
    const result = streamText({
      model: google('gemini-1.5-flash'),
      system: 'You are a helpful assistant.',
      messages: await convertToModelMessages(input.messages),
    })
    return streamToEventIterator(result.toUIMessageStream())
  })
```

### Client
```tsx
import { useChat } from '@ai-sdk/react'
import { eventIteratorToUnproxiedDataStream } from '@orpc/client'

export function ChatComponent() {
  const { messages, sendMessage, status } = useChat({
    transport: {
      async sendMessages(options) {
        return eventIteratorToUnproxiedDataStream(await client.chat({
          chatId: options.chatId,
          messages: options.messages,
        }, { signal: options.abortSignal }))
      },
      reconnectToStream(options) {
        throw new Error('Unsupported')
      },
    },
  })

  return (
    <div>
      {messages.map(message => (
        <div key={message.id}>
          <strong>{message.role}:</strong> {message.content}
        </div>
      ))}
      <form onSubmit={e => { e.preventDefault(); sendMessage(e) }}>
        <input name="message" placeholder="Type a message..." />
        <button type="submit" disabled={status !== 'ready'}>Send</button>
      </form>
    </div>
  )
}
```

**Important**: Prefer `eventIteratorToUnproxiedDataStream` over `eventIteratorToStream`. AI SDK internally uses `structuredClone`, which doesn't support proxied data.

**Note**: The `reconnectToStream` function is not supported by default.

### implementTool Helper
```ts
import { implementTool } from '@orpc/ai-sdk'

const getWeatherTool = implementTool(getWeatherContract, {
  execute: async ({ location }) => ({
    location,
    temperature: 72 + Math.floor(Math.random() * 21) - 10,
  }),
})
```

### createTool Helper
```ts
import { createTool } from '@orpc/ai-sdk'

const getWeatherTool = createTool(getWeatherProcedure, { context: {} })
```

### AI Tool Metadata

Attach AI SDK metadata using `AiSdkToolMeta`:

```ts
import { AI_SDK_TOOL_META_SYMBOL, AiSdkToolMeta } from '@orpc/ai-sdk'

const base = os.$meta<AiSdkToolMeta>({})

const getWeather = base
  .meta({ [AI_SDK_TOOL_META_SYMBOL]: { title: 'Get Weather' } })
  .route({ summary: 'Get weather for a location' })
  .input(z.object({
    location: z.string().describe('The location to get weather for'),
  }))
  .handler(({ input }) => ({
    location: input.location,
    temperature: 72,
  }))
```

## Sentry

Package: `@orpc/otel`

```sh
npm install @orpc/otel@latest
```

### Setup
```ts
import * as Sentry from '@sentry/node'
import { ORPCInstrumentation } from '@orpc/otel'

Sentry.init({
  dsn: '...',
  sendDefaultPii: true,
  tracesSampleRate: 1.0,
  openTelemetryInstrumentations: [new ORPCInstrumentation()],
})
```

### Error Capture Middleware
```ts
import * as Sentry from '@sentry/node'
import { os } from '@orpc/server'

export const sentryMiddleware = os.middleware(async ({ next }) => {
  try {
    return await next()
  } catch (error) {
    Sentry.captureException(error)
    throw error
  }
})

export const base = os.use(sentryMiddleware)
```

## Pino (Logging)

Package: `@orpc/experimental-pino`

```sh
npm install @orpc/experimental-pino@latest pino@latest
```

### Setup
```ts
import { LoggingHandlerPlugin } from '@orpc/experimental-pino'
import pino from 'pino'

const logger = pino()

const handler = new RPCHandler(router, {
  plugins: [
    new LoggingHandlerPlugin({
      logger,
      generateId: ({ request }) => crypto.randomUUID(),
      logRequestResponse: true,
      logRequestAbort: true,
    }),
  ],
})
```

### Using Logger in Procedures
```ts
import { getLogger, LoggerContext } from '@orpc/experimental-pino'

interface ORPCContext extends LoggerContext {}

const procedure = os
  .$context<ORPCContext>()
  .handler(({ context }) => {
    const logger = getLogger(context)
    logger?.info('Processing request')
    logger?.debug({ userId: 123 }, 'User data')
    return { success: true }
  })
```

### Custom Logger per Request

Integrate with `pino-http` for per-request loggers:

```ts
import pinoHttp from 'pino-http'
import { CONTEXT_LOGGER_SYMBOL } from '@orpc/experimental-pino'

const httpLogger = pinoHttp()

const server = createServer(async (req, res) => {
  httpLogger(req, res)

  const { matched } = await handler.handle(req, res, {
    prefix: '/rpc',
    context: { [CONTEXT_LOGGER_SYMBOL]: req.log },
  })

  if (!matched) {
    res.statusCode = 404
    res.end('Not found')
  }
})
```

**Tip**: Use `npm run dev | npx pino-pretty` for development log formatting.

## OpenTelemetry

Package: `@orpc/otel`

```sh
npm install @orpc/otel@latest
```

### Server Setup
```ts
import { NodeSDK } from '@opentelemetry/sdk-node'
import { ORPCInstrumentation } from '@orpc/otel'

const sdk = new NodeSDK({
  instrumentations: [new ORPCInstrumentation()],
})
sdk.start()
```

### Client Setup
```ts
import { WebTracerProvider } from '@opentelemetry/sdk-trace-web'
import { registerInstrumentations } from '@opentelemetry/instrumentation'
import { ORPCInstrumentation } from '@orpc/otel'

const provider = new WebTracerProvider()
provider.register()

registerInstrumentations({
  instrumentations: [new ORPCInstrumentation()],
})
```

### Custom Middleware Span
```ts
import { trace } from '@opentelemetry/api'

export const someMiddleware = os.middleware(async (ctx, next) => {
  const span = trace.getActiveSpan()
  span?.setAttribute('someAttribute', 'someValue')
  span?.addEvent('someEvent')
  return next()
})

Object.defineProperty(someMiddleware, 'name', { value: 'someName' })
```

### Handling Uncaught Exceptions

```ts
import { SpanStatusCode, trace } from '@opentelemetry/api'

function recordError(error: unknown): void {
  const span = trace.getActiveSpan()
  if (span) {
    span.recordException(error as Error)
    span.setStatus({ code: SpanStatusCode.ERROR, message: String(error) })
  }
}

process.on('uncaughtException', (error) => recordError(error))
process.on('unhandledRejection', (error) => recordError(error))
```

### Capture Abort Signals

Track abort events for streaming/Event Iterator procedures:

```ts
const handler = new RPCHandler(router, {
  interceptors: [
    async (options) => {
      options.request.signal?.addEventListener('abort', () => {
        const span = trace.getActiveSpan()
        span?.addEvent('aborted', {
          reason: String(options.request.signal?.reason),
        })
      })
      return options.next(options)
    },
  ],
})
```

### Context Propagation

For cross-service tracing, add HTTP instrumentation:

```ts
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node'

const sdk = new NodeSDK({
  instrumentations: [
    ...getNodeAutoInstrumentations(),
    new ORPCInstrumentation(),
  ],
})
```

**Tips**:
- Define the `name` property on middleware to improve span naming
- Using OpenTelemetry on the server only is sufficient in most cases

## Hey API

Package: `@orpc/hey-api`

```sh
npm install @orpc/hey-api@latest

# Generate client
npx @hey-api/openapi-ts -i https://get.heyapi.dev/hey-api/backend -o src/client
```

### Convert to oRPC Client
```ts
import { experimental_toORPCClient } from '@orpc/hey-api'
import * as sdk from 'src/client/sdk.gen'

export const client = experimental_toORPCClient(sdk)

const { body } = await client.listPlanets()
```

**Error handling**: oRPC passes the `throwOnError` option to the Hey API client. If the original Hey API client throws an error, oRPC forwards it as-is without modification.

**Warning**: Hey API is still in an unstable stage.

## Durable Iterator (Cloudflare)

Package: `@orpc/experimental-durable-iterator`

```sh
npm install @orpc/experimental-durable-iterator@latest
```

### Durable Object
```ts
import { DurableIteratorObject } from '@orpc/experimental-durable-iterator/durable-object'

export class ChatRoom extends DurableIteratorObject<{ message: string }> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env, {
      signingKey: 'secret-key',
      interceptors: [onError(e => console.error(e))],
      onSubscribed: (websocket, lastEventId) => {
        console.log(`WebSocket Ready id=${websocket['~orpc'].deserializeId()}`)
      },
    })
  }

  someMethod() {
    this.publishEvent({ message: 'Hello, world!' })
  }
}
```

### Server
```ts
import { DurableIterator } from '@orpc/experimental-durable-iterator'

export const router = {
  onMessage: base.handler(({ context }) => {
    return new DurableIterator<ChatRoom>('some-room', {
      tags: ['tag1'],
      signingKey: 'secret-key',
    })
  }),

  sendMessage: base
    .input(z.object({ message: z.string() }))
    .handler(async ({ context, input }) => {
      const id = context.env.CHAT_ROOM.idFromName('some-room')
      const stub = context.env.CHAT_ROOM.get(id)
      await stub.publishEvent(input)
    }),
}
```

### Client
```ts
import { DurableIteratorLinkPlugin } from '@orpc/experimental-durable-iterator/client'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  plugins: [
    new DurableIteratorLinkPlugin({
      url: 'ws://localhost:3000/chat-room',
      interceptors: [onError(e => console.error(e))],
    }),
  ],
})
```

### Usage
```ts
const iterator = await client.onMessage()
for await (const { message } of iterator) {
  console.log('Received:', message)
}

await client.sendMessage({ message: 'Hello!' })
```

### WebSocket Request Handler

Export a `fetch` handler for WebSocket upgrades:

```ts
import { upgradeDurableIteratorRequest } from '@orpc/experimental-durable-iterator'

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    return upgradeDurableIteratorRequest(request, {
      signingKey: 'secret-key',
      namespace: env.CHAT_ROOM,
    })
  },
}
```

### DurableIteratorHandlerPlugin

Add to the server handler:

```ts
import { DurableIteratorHandlerPlugin } from '@orpc/experimental-durable-iterator'

const handler = new RPCHandler(router, {
  plugins: [new DurableIteratorHandlerPlugin()],
})
```

### Publishing with Filters

Filter which subscribers receive events:

```ts
const sendMessage = base.handler(async ({ context, input }) => {
  const id = context.env.CHAT_ROOM.idFromName('room')
  const stub = context.env.CHAT_ROOM.get(id)

  // Filter by tags
  await stub.publishEvent(input, { tags: ['vip'] })

  // Filter by callback
  await stub.publishEvent(input, {
    targets: (ws) => {
      const att = ws.deserializeAttachment()
      return att.roomId === input.roomId
    },
  })
})
```

**Security**: Prefer `tags` or `targets` over `exclude` for filtering.

### Resume Events After Connection Loss

```ts
export class ChatRoom extends DurableIteratorObject<{ message: string }> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env, {
      signingKey: 'secret-key',
      resume: {
        retentionSeconds: 300, // Keep events for 5 minutes
      },
    })
  }
}
```

Use `withEventMeta` for custom event IDs:

```ts
import { withEventMeta } from '@orpc/server'

yield withEventMeta({ message: 'Hello' }, { id: 'custom-id' })
```

**Note**: When resume is enabled, the publisher auto-manages event IDs. User-provided IDs are ignored.

### CORS Configuration

Expose the required header:

```ts
new CORSPlugin({
  exposeHeaders: ['x-orpc-durable-iterator'],
})
```

### Auto Refresh Token

```ts
new DurableIteratorLinkPlugin({
  url: 'ws://localhost:3000/chat-room',
  refreshTokenBeforeExpireInSeconds: 60, // Refresh 60s before expiration
})
```

### Method RPC

Call methods on the Durable Object directly over WebSocket:

```ts
// Server: define callable methods
const chatRoom = os
  .handler(async ({ context }) => {
    return new DurableIterator<ChatRoom>('room', {
      signingKey: 'secret-key',
    })
  })
  .rpc('singleClient', 'routerClient')

// Client: call methods via the iterator
const iterator = await client.chatRoom()
const result = await iterator.singleClient({ message: 'Hello' })
const pong = await iterator.routerClient.ping()
```

### Stopping

```ts
// Via AbortController
const controller = new AbortController()
const iterator = await client.onMessage(undefined, { signal: controller.signal })
controller.abort()

// Via .return()
await iterator.return()
```

### Contract First

Define an interface extending `DurableIteratorObject` for type-safe contract-first usage:

```ts
import type { ContractRouterClient } from '@orpc/contract'
import { oc, type } from '@orpc/contract'
import type { ClientDurableIterator } from '@orpc/experimental-durable-iterator/client'
import type { DurableIteratorObject } from '@orpc/experimental-durable-iterator'

export const publishMessageContract = oc.input(z.object({ message: z.string() }))

export interface ChatRoom extends DurableIteratorObject<{ message: string }> {
  publishMessage(...args: any[]): ContractRouterClient<typeof publishMessageContract>
}

export const contract = {
  onMessage: oc.output(type<ClientDurableIterator<ChatRoom, 'publishMessage'>>()),
}
```

### Advanced Customization

Durable Iterator is built on top of the Hibernation Plugin, providing full access to the oRPC ecosystem:

**Server-side**:
```ts
export class YourDurableObject extends DurableIteratorObject<{ message: string }> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env, {
      signingKey: 'secret-key',
      customJsonSerializers: [],
      interceptors: [],
      plugins: [],
    })
  }
}
```

**Client-side**:
```ts
declare module '@orpc/experimental-durable-iterator/client' {
  interface ClientDurableIteratorRpcContext {
    // Custom client context
  }
}

new DurableIteratorLinkPlugin({
  url: 'ws://localhost:3000/chat-room',
  customJsonSerializers: [],
  interceptors: [],
  plugins: [],
})
```

## Integration Patterns

### Auth Middleware Pattern
Most auth integrations follow this pattern:

```ts
export const authMiddleware = base.middleware(async ({ context, next }) => {
  // 1. Extract auth data from context (headers, cookies, etc.)
  const authData = await authService.validate(context.headers)

  // 2. Throw error if unauthorized
  if (!authData) {
    throw new ORPCError('UNAUTHORIZED')
  }

  // 3. Pass auth data to next handler
  return next({
    context: {
      ...authData,
    },
  })
})
```

### Observability Pattern
Sentry and OpenTelemetry follow this pattern:

```ts
// 1. Initialize SDK/provider at app startup
// 2. Add instrumentation or middleware
// 3. Optionally enhance spans/events in procedures

export const observabilityMiddleware = os.middleware(async (ctx, next) => {
  const span = trace.getActiveSpan()
  span?.setAttribute('custom.attribute', 'value')

  try {
    return await next()
  } catch (error) {
    span?.recordException(error)
    throw error
  }
})
```

### Data Fetching Utils Pattern
TanStack Query, SWR, and Pinia Colada follow this pattern:

```ts
// 1. Create utils from client
const orpc = createUtils(client)

// 2. Use utils to generate framework-specific options
const options = orpc.procedure.queryOptions({ input: {} })

// 3. Pass options to framework hooks
const query = useQuery(options)
```

## OpenAI Streaming Example

Integrate oRPC with OpenAI for streaming chat completions:

```ts
import OpenAI from 'openai'

const openai = new OpenAI()

const complete = os
  .input(z.object({ content: z.string() }))
  .handler(async function* ({ input }) {
    const stream = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [{ role: 'user', content: input.content }],
      stream: true,
    })

    yield* stream
  })

// Client
const stream = await client.complete({ content: 'Hello, world!' })

for await (const chunk of stream) {
  console.log(chunk.choices[0]?.delta?.content || '')
}
```

## See Also

- Core concepts in SKILL.md
- Advanced patterns in references/advanced.md
