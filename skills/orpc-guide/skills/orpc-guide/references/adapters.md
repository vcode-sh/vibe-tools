# oRPC Adapters Reference

Complete reference for all oRPC server and client adapters across platforms, frameworks, and transport protocols.

## HTTP Adapters

### Node.js
Package: `@orpc/server/node`

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
    context: {},
  })
  if (!matched) {
    res.statusCode = 404
    res.end('Not found')
  }
})

server.listen(3000)
```

**Note**: Also supports `node:http2`. Replace `import { createServer } from 'node:http'` with `import { createServer } from 'node:http2'`.

### Bun
Package: `@orpc/server/fetch`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { CORSPlugin } from '@orpc/server/plugins'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

Bun.serve({
  async fetch(request: Request) {
    const { matched, response } = await handler.handle(request, {
      prefix: '/rpc',
      context: {},
    })
    if (matched) return response
    return new Response('Not found', { status: 404 })
  }
})
```

### Cloudflare Workers
Package: `@orpc/server/fetch`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { CORSPlugin } from '@orpc/server/plugins'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

export default {
  async fetch(request: Request, env: any, ctx: ExecutionContext): Promise<Response> {
    const { matched, response } = await handler.handle(request, {
      prefix: '/rpc',
      context: {},
    })
    if (matched) return response
    return new Response('Not found', { status: 404 })
  }
}
```

### Deno
Package: `@orpc/server/fetch`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { CORSPlugin } from '@orpc/server/plugins'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

Deno.serve(async (request) => {
  const { matched, response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {},
  })
  if (matched) return response
  return new Response('Not found', { status: 404 })
})
```

### AWS Lambda
Package: `@orpc/server/aws-lambda`

```ts
import { APIGatewayProxyEventV2 } from 'aws-lambda'
import { RPCHandler } from '@orpc/server/aws-lambda'
import { onError } from '@orpc/server'

const rpcHandler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export const handler = awslambda.streamifyResponse<APIGatewayProxyEventV2>(
  async (event, responseStream, context) => {
    const { matched } = await rpcHandler.handle(event, responseStream, {
      prefix: '/rpc',
      context: {},
    })
    if (!matched) {
      awslambda.HttpResponseStream.from(responseStream, { statusCode: 404 })
      responseStream.write('Not found')
      responseStream.end()
    }
  }
)
```

**Important**: oRPC only supports AWS Lambda response streaming.

---

## Framework Adapters

**Note**: The handler can be any supported oRPC handler (`RPCHandler`, `OpenAPIHandler`, or custom).

### Next.js

#### App Router
Package: `@orpc/server/fetch`
File: `app/rpc/[[...rest]]/route.ts`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

async function handleRequest(request: Request) {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {},
  })
  return response ?? new Response('Not found', { status: 404 })
}

export const HEAD = handleRequest
export const GET = handleRequest
export const POST = handleRequest
export const PUT = handleRequest
export const PATCH = handleRequest
export const DELETE = handleRequest
```

#### Pages Router
Package: `@orpc/server/node`
File: `pages/api/rpc/[[...rest]].ts`

```ts
import { RPCHandler } from '@orpc/server/node'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export const config = { api: { bodyParser: false } }

export default async (req, res) => {
  const { matched } = await handler.handle(req, res, {
    prefix: '/api/rpc',
    context: {},
  })
  if (!matched) {
    res.statusCode = 404
    res.end('Not found')
  }
}
```

**Important**: Disable body parser to avoid issues with Bracket Notation and file uploads.

**Server Actions**: oRPC provides out-of-the-box support for Server Actions with no additional configuration required. See the Server Actions section in `references/api-reference.md`.

#### SSR-Compatible Client
File: `lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'

const link = new RPCLink({
  url: `${typeof window !== 'undefined' ? window.location.origin : 'http://localhost:3000'}/rpc`,
  headers: async () => {
    if (typeof window !== 'undefined') return {}
    const { headers } = await import('next/headers')
    return await headers()
  },
})
```

#### Optimize SSR (Recommended for Production)
File: `lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'

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

File: `lib/orpc.server.ts`

```ts
import 'server-only'
import { headers } from 'next/headers'
import { createRouterClient } from '@orpc/server'

globalThis.$client = createRouterClient(router, {
  context: async () => ({ headers: await headers() }),
})
```

File: `instrumentation.ts`

```ts
export async function register() {
  await import('./lib/orpc.server')
}
```

File: `app/layout.tsx`

```ts
import '../lib/orpc.server' // for pre-rendering
```

### Express.js
Package: `@orpc/server/node`

```ts
import express from 'express'
import cors from 'cors'
import { RPCHandler } from '@orpc/server/node'
import { onError } from '@orpc/server'

const app = express()
app.use(cors())

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

app.use('/rpc{/*path}', async (req, res, next) => {
  const { matched } = await handler.handle(req, res, {
    prefix: '/rpc',
    context: {},
  })
  if (!matched) next()
})

app.listen(3000)
```

**Important**: Register body-parsing middleware AFTER oRPC middleware or only on non-oRPC routes. Express's body-parser doesn't support Bracket Notation, and file uploads with `application/json` content type may be parsed as plain JSON instead of `File`.

### Hono
Package: `@orpc/server/fetch`

```ts
import { Hono } from 'hono'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const app = new Hono()

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

app.use('/rpc/*', async (c, next) => {
  const { matched, response } = await handler.handle(c.req.raw, {
    prefix: '/rpc',
    context: {},
  })
  if (matched) return c.newResponse(response.body, response)
  await next()
})

export default app
```

#### Fix "Body Already Used" Error
If Hono middleware reads the body first, use a Proxy:

```ts
const BODY_PARSER_METHODS = new Set([
  'arrayBuffer',
  'blob',
  'formData',
  'json',
  'text'
] as const)

type BodyParserMethod = typeof BODY_PARSER_METHODS extends Set<infer T> ? T : never

app.use('/rpc/*', async (c, next) => {
  const request = new Proxy(c.req.raw, {
    get(target, prop) {
      if (BODY_PARSER_METHODS.has(prop as BodyParserMethod)) {
        return () => c.req[prop as BodyParserMethod]()
      }
      return Reflect.get(target, prop, target)
    }
  })

  const { matched, response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })

  if (matched) return c.newResponse(response.body, response)
  await next()
})
```

### Fastify
Package: `@orpc/server/fastify`

```ts
import Fastify from 'fastify'
import { RPCHandler } from '@orpc/server/fastify'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

const fastify = Fastify()

fastify.addContentTypeParser('*', (request, payload, done) => {
  done(null, undefined) // Let oRPC parse the body
})

fastify.all('/rpc/*', async (req, reply) => {
  const { matched } = await handler.handle(req, reply, {
    prefix: '/rpc',
    context: {}
  })
  if (!matched) reply.status(404).send('Not found')
})

fastify.listen({ port: 3000 })
```

**Important**: Use custom content type parser to let oRPC handle all body parsing.

### H3
Package: `@orpc/server/fetch`

```ts
import { H3, serve } from 'h3'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const app = new H3()

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

app.use('/rpc/**', async (event) => {
  const { matched, response } = await handler.handle(event.req, {
    prefix: '/rpc',
    context: {}
  })
  if (matched) return response
})

serve(app, { port: 3000 })
```

### Elysia
Package: `@orpc/server/fetch`

```ts
import { Elysia } from 'elysia'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

const app = new Elysia()
  .all('/rpc*', async ({ request }) => {
    const { response } = await handler.handle(request, {
      prefix: '/rpc'
    })
    return response ?? new Response('Not Found', { status: 404 })
  }, { parse: 'none' }) // Disable Elysia body parser
  .listen(3000)
```

**Important**: Set `parse: 'none'` to disable Elysia's body parser.

### Nuxt.js
Package: `@orpc/server/fetch`
Files: `server/routes/rpc/[...].ts` and `server/routes/rpc/index.ts`

File: `server/routes/rpc/[...].ts`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export default defineEventHandler(async (event) => {
  const request = toWebRequest(event)
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })
  if (response) return response
  setResponseStatus(event, 404, 'Not Found')
  return 'Not found'
})
```

File: `server/routes/rpc/index.ts`

```ts
export { default } from './[...]'
```

#### Client Plugin
File: `app/plugins/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import type { RouterClient } from '@orpc/server'

export default defineNuxtPlugin(() => {
  const event = useRequestEvent()

  const link = new RPCLink({
    url: `${typeof window !== 'undefined' ? window.location.origin : 'http://localhost:3000'}/rpc`,
    headers: event?.headers,
  })

  const client: RouterClient<typeof router> = createORPCClient(link)

  return {
    provide: { client }
  }
})
```

#### Optimize SSR
File: `app/plugins/orpc.client.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import { createORPCClient } from '@orpc/client'
import type { RouterClient } from '@orpc/server'

export default defineNuxtPlugin(() => {
  const link = new RPCLink({
    url: `${window.location.origin}/rpc`,
  })

  const client: RouterClient<typeof router> = createORPCClient(link)

  return { provide: { client } }
})
```

File: `app/plugins/orpc.server.ts`

```ts
import { createRouterClient } from '@orpc/server'
import type { RouterClient } from '@orpc/server'

export default defineNuxtPlugin(() => {
  const event = useRequestEvent()

  const client: RouterClient<typeof router> = createRouterClient(router, {
    context: { headers: event?.headers },
  })

  return { provide: { client } }
})
```

### SvelteKit
Package: `@orpc/server/fetch`
File: `src/routes/rpc/[...rest]/+server.ts`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'
import type { RequestHandler } from './$types'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

const handle: RequestHandler = async ({ request }) => {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })
  return response ?? new Response('Not Found', { status: 404 })
}

export const GET = handle
export const POST = handle
export const PUT = handle
export const PATCH = handle
export const DELETE = handle
```

#### Optimize SSR
File: `src/lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import { createORPCClient } from '@orpc/client'
import type { RouterClient } from '@orpc/server'

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

File: `src/lib/orpc.server.ts`

```ts
import type { RouterClient } from '@orpc/server'
import { createORPCClient } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'
import { getRequestEvent } from '$app/server'

if (typeof window !== 'undefined') {
  throw new Error('This file should only be imported on the server')
}

const link = new RPCLink({
  url: async () => {
    return `${getRequestEvent().url.origin}/rpc`
  },
  async fetch(request, init) {
    return getRequestEvent().fetch(request, init)
  },
})

const serverClient: RouterClient<typeof router> = createORPCClient(link)
globalThis.$client = serverClient
```

File: `src/hooks.server.ts`

```ts
import './lib/orpc.server'
```

### Astro
Package: `@orpc/server/fetch`
File: `pages/rpc/[...rest].ts`

```ts
import type { APIRoute } from 'astro'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export const prerender = false

export const ALL: APIRoute = async ({ request }) => {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })
  return response ?? new Response('Not found', { status: 404 })
}
```

**Important**: Set `prerender = false` for this route.

### Remix
Package: `@orpc/server/fetch`
File: `app/routes/rpc.$.ts`

```ts
import type { LoaderFunctionArgs } from '@remix-run/node'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export async function loader({ request }: LoaderFunctionArgs) {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })
  return response ?? new Response('Not Found', { status: 404 })
}
```

### Solid Start
Package: `@orpc/server/fetch`
Files: `src/routes/rpc/[...rest].ts` and `src/routes/rpc/index.ts`

File: `src/routes/rpc/[...rest].ts`

```ts
import type { APIEvent } from '@solidjs/start/server'
import { RPCHandler } from '@orpc/server/fetch'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

async function handle({ request }: APIEvent) {
  const { response } = await handler.handle(request, {
    prefix: '/rpc',
    context: {}
  })
  return response ?? new Response('Not Found', { status: 404 })
}

export const HEAD = handle
export const GET = handle
export const POST = handle
export const PUT = handle
export const PATCH = handle
export const DELETE = handle
```

File: `src/routes/rpc/index.ts`

```ts
import { POST as handle } from './[...rest]'
export { handle as HEAD, handle as GET, handle as POST, handle as PUT, handle as PATCH, handle as DELETE }
```

#### Client
File: `src/lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import { getRequestEvent } from 'solid-js/web'

const link = new RPCLink({
  url: `${typeof window !== 'undefined' ? window.location.origin : 'http://localhost:3000'}/rpc`,
  headers: () => getRequestEvent()?.request.headers ?? {},
})
```

#### Optimize SSR
File: `src/lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import { createORPCClient } from '@orpc/client'
import type { RouterClient } from '@orpc/server'

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

File: `src/lib/orpc.server.ts`

```ts
import { createRouterClient } from '@orpc/server'
import { getRequestEvent } from 'solid-js/web'

globalThis.$client = createRouterClient(router, {
  context: async () => ({
    headers: getRequestEvent()?.request.headers,
  }),
})
```

### TanStack Start
Package: `@orpc/server/fetch`
File: `src/routes/api/rpc.$.ts`

```ts
import { RPCHandler } from '@orpc/server/fetch'
import { createFileRoute } from '@tanstack/react-router'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export const Route = createFileRoute('/api/rpc/$')({
  server: {
    handlers: {
      ANY: async ({ request }) => {
        const { response } = await handler.handle(request, {
          prefix: '/api/rpc',
          context: {}
        })
        return response ?? new Response('Not Found', { status: 404 })
      },
    },
  },
})
```

#### Client
File: `src/lib/orpc.ts`

```ts
import { RPCLink } from '@orpc/client/fetch'
import { createIsomorphicFn } from '@tanstack/react-start'
import { getRequestHeaders } from '@tanstack/react-start/server'

const getClientLink = createIsomorphicFn()
  .client(() => new RPCLink({
    url: `${window.location.origin}/api/rpc`
  }))
  .server(() => new RPCLink({
    url: 'http://localhost:3000/api/rpc',
    headers: () => getRequestHeaders(),
  }))

export const link = getClientLink()
```

#### Optimize SSR
File: `src/lib/orpc.ts`

```ts
import { createIsomorphicFn } from '@tanstack/react-start'
import { getRequestHeaders } from '@tanstack/react-start/server'
import { createRouterClient, type RouterClient } from '@orpc/server'
import { createORPCClient } from '@orpc/client'
import { RPCLink } from '@orpc/client/fetch'

const getORPCClient = createIsomorphicFn()
  .server(() => createRouterClient(router, {
    context: async () => ({
      headers: getRequestHeaders(),
    }),
  }))
  .client((): RouterClient<typeof router> => {
    const link = new RPCLink({
      url: `${window.location.origin}/api/rpc`,
    })
    return createORPCClient(link)
  })

export const client: RouterClient<typeof router> = getORPCClient()
```

---

## WebSocket Adapters

### WebSocket (Deno/Cloudflare)
Package: `@orpc/server/websocket`

```ts
import { RPCHandler } from '@orpc/server/websocket'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

Deno.serve((req) => {
  if (req.headers.get('upgrade') !== 'websocket') {
    return new Response(null, { status: 501 })
  }

  const { socket, response } = Deno.upgradeWebSocket(req)
  handler.upgrade(socket, { context: {} })

  return response
})
```

### WS (Node.js)
Package: `@orpc/server/ws`

```ts
import { WebSocketServer } from 'ws'
import { RPCHandler } from '@orpc/server/ws'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

const wss = new WebSocketServer({ port: 8080 })

wss.on('connection', (ws) => {
  handler.upgrade(ws, { context: {} })
})
```

### Bun WebSocket
Package: `@orpc/server/bun-ws`

```ts
import { RPCHandler } from '@orpc/server/bun-ws'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

Bun.serve({
  fetch(req, server) {
    if (server.upgrade(req)) return
    return new Response('Upgrade failed', { status: 500 })
  },
  websocket: {
    message(ws, message) {
      handler.message(ws, message, { context: {} })
    },
    close(ws) {
      handler.close(ws)
    },
  },
})
```

### CrossWS (Node, Bun, Deno) - Experimental
Package: `@orpc/server/crossws`

```ts
import { experimental_RPCHandler as RPCHandler } from '@orpc/server/crossws'
import { onError } from '@orpc/server'
import crossws from 'crossws/adapters/node'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

const ws = crossws({
  hooks: {
    message: (peer, message) => {
      handler.message(peer, message, { context: {} })
    },
    close: (peer) => {
      handler.close(peer)
    },
  },
})
```

### WebSocket Hibernation (Cloudflare Durable Objects)

```ts
import { RPCHandler } from '@orpc/server/websocket'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

export class ChatRoom extends DurableObject {
  async fetch(): Promise<Response> {
    const { '0': client, '1': server } = new WebSocketPair()
    this.ctx.acceptWebSocket(server)
    return new Response(null, { status: 101, webSocket: client })
  }

  async webSocketMessage(ws: WebSocket, message: string | ArrayBuffer): Promise<void> {
    await handler.message(ws, message, { context: {} })
  }

  async webSocketClose(ws: WebSocket): Promise<void> {
    handler.close(ws)
  }
}
```

**Tip**: Use the Hibernation Plugin to fully leverage Hibernation APIs for long-lived WebSocket connections. See `references/plugins.md`.

### WebSocket Client
Package: `@orpc/client/websocket`

```ts
import { RPCLink } from '@orpc/client/websocket'

const websocket = new WebSocket('ws://localhost:3000')
const link = new RPCLink({ websocket })
```

**Tip**: Use `partysocket` for automatic reconnection:

```ts
import PartySocket from 'partysocket'

const websocket = new PartySocket('ws://localhost:3000', {
  startClosed: false,
})
const link = new RPCLink({ websocket })
```

---

## Message Port Adapters

### Basic Usage

```ts
// Server side
import { RPCHandler } from '@orpc/server/message-port'

const { port1: clientPort, port2: serverPort } = new MessageChannel()

const handler = new RPCHandler(router)
handler.upgrade(serverPort, { context: {} })
serverPort.start()

// Client side
import { RPCLink } from '@orpc/client/message-port'

const link = new RPCLink({ port: clientPort })
clientPort.start()
```

### Experimental Transfer

Enable transferring ownership of objects (e.g., `OffscreenCanvas`) via `MessagePort.postMessage()`:

```ts
// Server
const handler = new RPCHandler(router, {
  experimental_transfer: (message, port) => {
    const transfer = deepFindTransferableObjects(message)
    return transfer.length ? transfer : null
  },
})

// Client
const link = new RPCLink({
  port: clientPort,
  experimental_transfer: (message) => {
    const transfer = deepFindTransferableObjects(message)
    return transfer.length ? transfer : null
  },
})
```

**Warning**: When `transfer` returns an array, messages use the structured clone algorithm which doesn't support all data types (e.g., Event Iterator Metadata). Only enable when needed.

**Tip**: The `transfer` option runs after RPC JSON Serializer, so you can combine them to support more data types.

### Web Workers
Package: `@orpc/server/message-port` (worker), `@orpc/client/message-port` (main)

Worker file:

```ts
import { RPCHandler } from '@orpc/server/message-port'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

handler.upgrade(self, { context: {} })
```

Main thread:

```ts
import { RPCLink } from '@orpc/client/message-port'

export const link = new RPCLink({
  port: new Worker('some-worker.ts')
})
```

**Vite integration**: Use Vite's `?worker` import for simpler setup:

```ts
import SomeWorker from './some-worker.ts?worker'
import { RPCLink } from '@orpc/client/message-port'

export const link = new RPCLink({ port: new SomeWorker() })
```

### Worker Threads (Node.js)
Worker file:

```ts
import { parentPort } from 'node:worker_threads'
import { RPCHandler } from '@orpc/server/message-port'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((e) => console.error(e))]
})

parentPort.on('message', (message) => {
  if (message instanceof MessagePort) {
    handler.upgrade(message, { context: {} })
    message.start()
  }
})
```

Main thread:

```ts
import { MessageChannel, Worker } from 'node:worker_threads'
import { RPCLink } from '@orpc/client/message-port'

const { port1: clientPort, port2: serverPort } = new MessageChannel()
const worker = new Worker('some-worker.js')

worker.postMessage(serverPort, [serverPort])

const link = new RPCLink({ port: clientPort })
clientPort.start()
```

### Electron
Main process:

```ts
import { ipcMain } from 'electron'
import { RPCHandler } from '@orpc/server/message-port'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((e) => console.error(e))]
})

app.whenReady().then(() => {
  ipcMain.on('start-orpc-server', async (event) => {
    const [serverPort] = event.ports
    handler.upgrade(serverPort)
    serverPort.start()
  })
})
```

Preload process:

```ts
const { ipcRenderer } = require('electron')

window.addEventListener('message', (event) => {
  if (event.data === 'start-orpc-client') {
    const [serverPort] = event.ports
    ipcRenderer.postMessage('start-orpc-server', null, [serverPort])
  }
})
```

Renderer process:

```ts
import { RPCLink } from '@orpc/client/message-port'

const { port1: clientPort, port2: serverPort } = new MessageChannel()
window.postMessage('start-orpc-client', '*', [serverPort])

const link = new RPCLink({ port: clientPort })
clientPort.start()
```

### Browser Extensions
Background script (server):

```ts
import { RPCHandler } from '@orpc/server/message-port'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((e) => console.error(e))]
})

browser.runtime.onConnect.addListener((port) => {
  handler.upgrade(port, { context: {} })
})
```

Content/popup script (client):

```ts
import { RPCLink } from '@orpc/client/message-port'

const port = browser.runtime.connect()
const link = new RPCLink({ port })
```

**Warning**: Browser extension Message Passing API doesn't support binary data. Use RPC JSON Serializer to encode as Base64.

### Window to Window
Communication between two window contexts (parent and popup):

Opener:
```ts
import { RPCHandler } from '@orpc/server/message-port'
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [onError((error) => console.error(error))],
})

window.addEventListener('message', (event) => {
  if (event.data instanceof MessagePort) {
    handler.upgrade(event.data, { context: {} })
    event.data.start()
  }
})

window.open('/popup', 'popup', 'width=680,height=520')
```

Popup:
```ts
import { RPCLink } from '@orpc/client/message-port'

const { port1: serverPort, port2: clientPort } = new MessageChannel()
window.opener.postMessage(serverPort, '*', [serverPort])

const link = new RPCLink({ port: clientPort })
clientPort.start()
```

### Extension Relay Pattern

When a content script in the MAIN world cannot access `browser.runtime` APIs, use a relay script in the ISOLATED world:

Relay (ISOLATED world content script):
```ts
window.addEventListener('message', (event) => {
  if (event.data instanceof MessagePort) {
    const port = browser.runtime.connect()

    event.data.addEventListener('message', (e) => port.postMessage(e.data))
    event.data.addEventListener('close', () => port.disconnect())
    port.onMessage.addListener((msg) => event.data.postMessage(msg))
    port.onDisconnect.addListener(() => event.data.close())

    event.data.start()
  }
})
```

Client (MAIN world):
```ts
import { RPCLink } from '@orpc/client/message-port'

const { port1: serverPort, port2: clientPort } = new MessageChannel()
window.postMessage(serverPort, '*', [serverPort])

const link = new RPCLink({ port: clientPort })
clientPort.start()
```

### React Native
Package: `@orpc/client/fetch`

```ts
import { RPCLink } from '@orpc/client/fetch'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  headers: async ({ context }) => ({
    'x-api-key': context?.something ?? ''
  }),
})
```

**Warning**: React Native Fetch doesn't support File/Blob and Event Iterator. Use RPC JSON Serializer or `expo/fetch`:

```ts
import { RPCLink } from '@orpc/client/fetch'

export const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  async fetch(request, init) {
    const { fetch } = await import('expo/fetch')
    return fetch(request.url, {
      body: await request.blob(),
      headers: request.headers,
      method: request.method,
      signal: request.signal,
      ...init,
    })
  },
})
```

---

## Client Configuration

### HTTP (Fetch) Client
Package: `@orpc/client/fetch`

```ts
import { RPCLink } from '@orpc/client/fetch'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  headers: () => ({
    'x-api-key': 'my-api-key'
  }),
  fetch: (request, init) => globalThis.fetch(request, {
    ...init,
    credentials: 'include'
  }),
})
```

### Client Context
Define custom context passed with each request:

```ts
interface ClientContext {
  something?: string
}

const link = new RPCLink<ClientContext>({
  url: 'http://localhost:3000/rpc',
  headers: async ({ context }) => ({
    'x-api-key': context?.something ?? ''
  }),
})

const client: RouterClient<typeof router, ClientContext> = createORPCClient(link)

const result = await client.planet.list(
  { limit: 10 },
  { context: { something: 'value' } }
)
```

### Dynamic Link
Switch between links based on context:

```ts
import { DynamicLink } from '@orpc/client'

const link = new DynamicLink<ClientContext>((options, path, input) => {
  if (options.context?.cache) return cacheLink
  return defaultLink
})
```

### Custom Request Method
Control whether requests use GET or POST:

```ts
const link = new RPCLink<ClientContext>({
  url: 'http://localhost:3000/rpc',
  method: ({ context }, path) => {
    if (context?.cache) return 'GET'

    // Use GET for read-only operations
    if (path.at(-1)?.match(/^(?:get|find|list|search)(?:[A-Z].*)?$/)) {
      return 'GET'
    }

    return 'POST'
  },
})
```

### Infer Method from Contract

Automatically use the HTTP method specified in the contract:

```ts
import { inferRPCMethodFromContractRouter } from '@orpc/contract'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  method: inferRPCMethodFromContractRouter(contract),
})
```

A normal router works as a contract router unless it includes lazy routers.

### Lazy URL

Define URL as a function for environment compatibility:

```ts
const link = new RPCLink({
  url: () => {
    if (typeof window === 'undefined') {
      throw new Error('RPCLink is not allowed on the server side.')
    }
    return `${window.location.origin}/rpc`
  },
})
```

### Link Interceptor Levels

RPCLink supports three interceptor levels:

```ts
const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  // Top-level: encode/decode input/output/errors
  interceptors: [onError((e) => console.error(e))],
  // Client-level: after encoding, before sending
  clientInterceptors: [],
  // Adapter-level: closest to the actual HTTP request
  adapterInterceptors: [],
})
```

---

## Event Iterator Options

Configure server-sent event behavior for streaming responses:

```ts
const handler = new RPCHandler(router, {
  eventIteratorInitialCommentEnabled: true,   // default: true
  eventIteratorInitialComment: '',            // custom initial comment
  eventIteratorKeepAliveEnabled: true,        // default: true
  eventIteratorKeepAliveInterval: 5000,       // default: 5000ms
  eventIteratorKeepAliveComment: '',          // custom keep-alive comment
})
```

Same options available on client links:

```ts
const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  eventIteratorInitialCommentEnabled: true,
  eventIteratorKeepAliveEnabled: true,
  eventIteratorKeepAliveInterval: 5000,
})
```

---

## Adapter Selection Guide

### By Runtime
- **Node.js**: `@orpc/server/node` or `@orpc/server/fetch`
- **Bun**: `@orpc/server/fetch` or `@orpc/server/bun-ws` (WebSocket)
- **Deno**: `@orpc/server/fetch` or `@orpc/server/websocket`
- **Cloudflare Workers**: `@orpc/server/fetch`
- **AWS Lambda**: `@orpc/server/aws-lambda`

### By Framework
- **Next.js**: `@orpc/server/fetch` (App Router) or `@orpc/server/node` (Pages Router)
- **Express**: `@orpc/server/node`
- **Fastify**: `@orpc/server/fastify`
- **Hono**: `@orpc/server/fetch`
- **Nuxt**: `@orpc/server/fetch`
- **SvelteKit**: `@orpc/server/fetch`
- **Remix**: `@orpc/server/fetch`
- **Astro**: `@orpc/server/fetch`

### By Transport
- **HTTP**: `@orpc/server/fetch` or `@orpc/server/node`
- **WebSocket**: `@orpc/server/websocket`, `@orpc/server/ws`, or `@orpc/server/bun-ws`
- **Message Port**: `@orpc/server/message-port`

---

## Common Patterns

### CORS Configuration
Use `CORSPlugin` for HTTP adapters:

```ts
import { CORSPlugin } from '@orpc/server/plugins'

const handler = new RPCHandler(router, {
  plugins: [new CORSPlugin({
    origin: 'https://example.com',
    credentials: true,
  })],
})
```

### Error Handling
Use `onError` interceptor:

```ts
import { onError } from '@orpc/server'

const handler = new RPCHandler(router, {
  interceptors: [
    onError((error, context) => {
      console.error('RPC Error:', error)
      // Log to monitoring service
    })
  ],
})
```

### Context Injection
Pass request-specific context to procedures:

```ts
const { matched, response } = await handler.handle(request, {
  prefix: '/rpc',
  context: {
    user: await getUser(request),
    db: database,
  },
})
```

### SSR Optimization
For framework integrations, prefer `createRouterClient` on server:

```ts
import { createRouterClient } from '@orpc/server'

const serverClient = createRouterClient(router, {
  context: async () => ({ headers: await headers() }),
})
```

This bypasses HTTP and calls procedures directly.

#### OpenAPILink SSR Support

When using OpenAPILink, types differ because `JsonifiedClient` converts native values (Date, URL) to JSON. Use `createJsonifiedRouterClient`:

```ts
import { createJsonifiedRouterClient } from '@orpc/openapi'
import type { JsonifiedClient } from '@orpc/openapi-client'

declare global {
  var $client: JsonifiedClient<RouterClient<typeof router>> | undefined
}

globalThis.$client = createJsonifiedRouterClient(router, {
  context: async () => ({ headers: await headers() }),
})
```

#### Alternative: Fetch Adapter Approach

Use a fetch adapter for SSR with plugin support (e.g., `DedupeRequestsPlugin`):

```ts
import 'server-only'
import { RPCLink } from '@orpc/client/fetch'
import { DedupeRequestsPlugin } from '@orpc/client/plugins'

const link = new RPCLink({
  url: 'http://placeholder',
  method: inferRPCMethodFromRouter(router),
  plugins: [
    new DedupeRequestsPlugin({
      groups: [{ condition: () => true, context: {} }],
    }),
  ],
  fetch: async (request) => {
    const { response } = await handler.handle(request, {
      context: { headers: await headers() },
    })
    return response ?? new Response('Not Found', { status: 404 })
  },
})

globalThis.$client = createORPCClient(link)
```

## See Also

- Core API (procedures, middleware, context): `references/api-reference.md`
- Built-in plugins (CORS, batch, compression): `references/plugins.md`
- OpenAPI handler and routing: `references/openapi.md`
- Integrations (TanStack Query, SWR, etc.): `references/integrations.md`
- NestJS integration (decorators, DI, contract-first): `references/nestjs.md`
