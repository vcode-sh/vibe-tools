# oRPC Plugins Reference

Complete reference for all oRPC plugins across server, client, and contract layers.

All plugins support RPCHandler, OpenAPIHandler, RPCLink, and OpenAPILink where applicable.

## Server Plugins

### CORS Plugin

**Package**: `@orpc/server/plugins`

Enable Cross-Origin Resource Sharing for your API.

```ts
import { CORSPlugin } from '@orpc/server/plugins'

const handler = new RPCHandler(router, {
  plugins: [
    new CORSPlugin({
      origin: (origin, options) => origin,
      allowMethods: ['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH'],
      allowHeaders: ['Content-Type', 'Authorization'],
      exposeHeaders: ['Content-Length'],
      credentials: true,
      maxAge: 86400,
    }),
  ],
})
```

**Configuration Options**:
- `origin`: Function or string to determine allowed origins
- `allowMethods`: HTTP methods to allow (default: GET, HEAD, PUT, POST, DELETE, PATCH)
- `allowHeaders`: Headers that can be used in actual request
- `exposeHeaders`: Headers exposed to the client
- `credentials`: Allow credentials (cookies, authorization headers)
- `maxAge`: How long preflight results can be cached (seconds)

**Example with dynamic origin**:
```ts
new CORSPlugin({
  origin: (origin, options) => {
    const allowedOrigins = ['https://app.example.com', 'https://admin.example.com']
    return allowedOrigins.includes(origin) ? origin : false
  },
  credentials: true,
})
```

### Body Limit Plugin

**Package**: `@orpc/server/fetch` or `@orpc/server/node` (adapter-specific)

Limit the maximum size of request bodies to prevent abuse.

```ts
import { BodyLimitPlugin } from '@orpc/server/fetch' // or '@orpc/server/node'

const handler = new RPCHandler(router, {
  plugins: [
    new BodyLimitPlugin({ maxBodySize: 1024 * 1024 }), // 1MB
  ],
})
```

**Configuration Options**:
- `maxBodySize`: Maximum body size in bytes

**Examples**:
```ts
// 10MB limit for file uploads
new BodyLimitPlugin({ maxBodySize: 10 * 1024 * 1024 })

// 100KB limit for JSON APIs
new BodyLimitPlugin({ maxBodySize: 100 * 1024 })
```

### Compression Plugin

**Package**: `@orpc/server/node` or `@orpc/server/fetch`

Compress responses to reduce bandwidth usage.

```ts
import { CompressionPlugin } from '@orpc/server/node' // or '@orpc/server/fetch'

const handler = new RPCHandler(router, {
  plugins: [new CompressionPlugin()],
})
```

Supports gzip and deflate encoding based on `Accept-Encoding` header.

### Strict GET Method Plugin

**Package**: `@orpc/server/plugins`

**Enabled by default** for RPCHandler HTTP adapters.

Only procedures explicitly marked with `method: 'GET'` can be invoked via GET requests. All other procedures require POST.

```ts
import { StrictGetMethodPlugin } from '@orpc/server/plugins'

// Define GET procedure
const ping = os.route({ method: 'GET' }).handler(() => 'pong')

// Configure handler
const handler = new RPCHandler(router, {
  plugins: [new StrictGetMethodPlugin()],
})
```

**Disable if needed**:
```ts
const handler = new RPCHandler(router, {
  strictGetMethodPluginEnabled: false,
})
```

**When to use**: Beneficial if your application stores sensitive data in Cookie storage using `SameSite=Lax` (default) or `SameSite=None`. You may switch to Simple CSRF Protection Plugin if preferred.

### Simple CSRF Protection Plugin

**Package**: `@orpc/server/plugins` (server), `@orpc/client/plugins` (client)

Protect against Cross-Site Request Forgery attacks. Requires configuration on BOTH server and client sides.

**Server Configuration**:
```ts
import { SimpleCsrfProtectionHandlerPlugin } from '@orpc/server/plugins'

const handler = new RPCHandler(router, {
  strictGetMethodPluginEnabled: false, // Replace Strict Get Method Plugin
  plugins: [new SimpleCsrfProtectionHandlerPlugin()],
})
```

**Client Configuration**:
```ts
import { SimpleCsrfProtectionLinkPlugin } from '@orpc/client/plugins'

const link = new RPCLink({
  url: 'https://api.example.com/rpc',
  plugins: [new SimpleCsrfProtectionLinkPlugin()],
})
```

**When to use**: Beneficial if your app stores sensitive data in Cookie storage using `SameSite=Lax` (default) or `SameSite=None`. Not needed if:
- Using `SameSite=Strict` cookies
- Using Bearer tokens for authentication
- API and client on same domain

### Request Headers Plugin

**Package**: `@orpc/server/plugins`

Injects `reqHeaders` (Headers object) into procedure context for reading request headers.

```ts
import { RequestHeadersPlugin, RequestHeadersPluginContext } from '@orpc/server/plugins'
import { getCookie } from '@orpc/server/helpers'

interface ORPCContext extends RequestHeadersPluginContext {}

const base = os.$context<ORPCContext>()

// Access headers in middleware
const authenticated = base.use(({ context, next }) => {
  const authorization = context.reqHeaders?.get('authorization')
  if (!authorization) {
    throw new ORPCError('UNAUTHORIZED')
  }
  return next({ user: verifyToken(authorization) })
})

// Access cookies
const withSession = base.use(({ context, next }) => {
  const sessionId = getCookie(context.reqHeaders, 'session_id')
  if (!sessionId) {
    throw new ORPCError('UNAUTHORIZED')
  }
  return next({ sessionId })
})

// Access in handler
const getUserAgent = base.handler(({ context }) => {
  const userAgent = context.reqHeaders?.get('user-agent')
  return { userAgent }
})

// Configure handler
const handler = new RPCHandler(router, {
  plugins: [new RequestHeadersPlugin()],
})
```

**Note**: `reqHeaders` can be `undefined` for direct calls without the plugin.

**Common use cases**:
```ts
// Read authorization header
const token = context.reqHeaders?.get('authorization')

// Read custom headers
const apiKey = context.reqHeaders?.get('x-api-key')

// Read accept-language
const language = context.reqHeaders?.get('accept-language')

// Read cookies
import { getCookie } from '@orpc/server/helpers'
const sessionId = getCookie(context.reqHeaders, 'session_id')
```

### Response Headers Plugin

**Package**: `@orpc/server/plugins`

Injects `resHeaders` (Headers object) into procedure context for setting response headers.

```ts
import { ResponseHeadersPlugin, ResponseHeadersPluginContext } from '@orpc/server/plugins'
import { setCookie } from '@orpc/server/helpers'

interface ORPCContext extends ResponseHeadersPluginContext {}

const base = os.$context<ORPCContext>()

// Set custom headers in middleware
const withCustomHeaders = base.use(({ context, next }) => {
  context.resHeaders?.set('x-custom-header', 'value')
  context.resHeaders?.set('x-request-id', crypto.randomUUID())
  return next()
})

// Set cookies in handler
const login = base.input(z.object({
  email: z.string().email(),
  password: z.string(),
})).handler(({ input, context }) => {
  const user = authenticateUser(input.email, input.password)

  setCookie(context.resHeaders, 'session_id', user.sessionId, {
    secure: true,
    httpOnly: true,
    maxAge: 3600,
    sameSite: 'lax',
  })

  return { user }
})

// Configure handler
const handler = new RPCHandler(router, {
  plugins: [new ResponseHeadersPlugin()],
})
```

**Common use cases**:
```ts
// Set cache headers
context.resHeaders?.set('cache-control', 'public, max-age=3600')

// Set CORS headers (if not using CORS plugin)
context.resHeaders?.set('access-control-allow-origin', '*')

// Set content type
context.resHeaders?.set('content-type', 'application/json')

// Set cookies with helpers
import { setCookie } from '@orpc/server/helpers'

setCookie(context.resHeaders, 'token', 'abc123', {
  secure: true,
  httpOnly: true,
  maxAge: 86400,
  sameSite: 'strict',
  path: '/',
  domain: '.example.com',
})
```

### Rethrow Handler Plugin (Experimental)

**Package**: `@orpc/server/plugins`

Catch and rethrow specific errors during request handling, allowing framework-level error handling to take over.

```ts
import { experimental_RethrowHandlerPlugin as RethrowHandlerPlugin } from '@orpc/server/plugins'

const handler = new RPCHandler(router, {
  plugins: [
    new RethrowHandlerPlugin({
      filter: (error) => !(error instanceof ORPCError),
    }),
  ],
})
```

**Use case**: When your framework has its own error handling system (NestJS, Express, etc.).

**Example with NestJS**:
```ts
// Rethrow non-ORPC errors to let NestJS handle them
new RethrowHandlerPlugin({
  filter: (error) => {
    // Let NestJS handle HTTP exceptions
    if (error instanceof HttpException) return true
    // Handle ORPC errors normally
    if (error instanceof ORPCError) return false
    // Rethrow unknown errors
    return true
  },
})
```

**Example with custom errors**:
```ts
class DatabaseError extends Error {}
class ValidationError extends Error {}

new RethrowHandlerPlugin({
  filter: (error) => {
    // Rethrow database errors for centralized logging
    if (error instanceof DatabaseError) return true
    // Handle validation errors in ORPC
    return false
  },
})
```

### Hibernation Plugin

**Package**: `@orpc/server/hibernation`

Enable Cloudflare WebSocket Hibernation API support for efficient long-lived WebSocket connections.

```ts
import {
  HibernationPlugin,
  HibernationEventIterator,
  encodeHibernationRPCEvent
} from '@orpc/server/hibernation'

const handler = new RPCHandler(router, {
  plugins: [new HibernationPlugin()],
})
```

**Handler returning HibernationEventIterator**:
```ts
const onMessage = os
  .input(z.object({ roomId: z.string() }))
  .handler(async ({ input, context }) => {
    return new HibernationEventIterator<{ message: string }>((id) => {
      // Serialize attachment with iterator ID
      context.ws.serializeAttachment({
        id,
        roomId: input.roomId,
      })
    })
  })
```

**Sending events**:
```ts
const sendMessage = os
  .input(z.object({
    roomId: z.string(),
    message: z.string(),
  }))
  .handler(async ({ input, context }) => {
    const websockets = context.getWebSockets()

    for (const ws of websockets) {
      const attachment = ws.deserializeAttachment()

      // Only send to matching room
      if (attachment.roomId === input.roomId) {
        // Send regular event
        ws.send(encodeHibernationRPCEvent(attachment.id, {
          message: input.message
        }))
      }
    }
  })
```

**Complete example with event types**:
```ts
// Return and stop iterator
ws.send(encodeHibernationRPCEvent(id, data, { event: 'done' }))

// Send error and stop
ws.send(encodeHibernationRPCEvent(id, new ORPCError('INTERNAL_SERVER_ERROR'), { event: 'error' }))

// Send regular data event (continues iterator)
ws.send(encodeHibernationRPCEvent(id, { message: 'Hello' }))
```

**Custom serializers**: Pass custom JSON serializers to `encodeHibernationRPCEvent`:

```ts
ws.send(encodeHibernationRPCEvent(id, { message: 'Hello' }, {
  customJsonSerializers: [/* custom serializers */],
}))
```

**Imports**: Use `RPCHandler` from `@orpc/server/websocket` and `RPCLink` from `@orpc/client/websocket` for Hibernation setups.

**Full chat room example**:
```ts
interface Attachment {
  id: string
  userId: string
  roomId: string
}

const joinRoom = os
  .input(z.object({ roomId: z.string() }))
  .handler(async ({ input, context }) => {
    const userId = context.user.id

    return new HibernationEventIterator<{
      type: 'message' | 'join' | 'leave'
      userId: string
      text?: string
    }>((id) => {
      context.ws.serializeAttachment<Attachment>({
        id,
        userId,
        roomId: input.roomId,
      })

      // Notify others user joined
      const websockets = context.getWebSockets()
      for (const ws of websockets) {
        const att = ws.deserializeAttachment<Attachment>()
        if (att.roomId === input.roomId && att.userId !== userId) {
          ws.send(encodeHibernationRPCEvent(att.id, {
            type: 'join',
            userId,
          }))
        }
      }
    })
  })

const sendMessage = os
  .input(z.object({
    roomId: z.string(),
    text: z.string(),
  }))
  .handler(async ({ input, context }) => {
    const userId = context.user.id
    const websockets = context.getWebSockets()

    for (const ws of websockets) {
      const att = ws.deserializeAttachment<Attachment>()
      if (att.roomId === input.roomId) {
        ws.send(encodeHibernationRPCEvent(att.id, {
          type: 'message',
          userId,
          text: input.text,
        }))
      }
    }
  })
```

## Client Plugins

### Batch Requests Plugin

**Package**: `@orpc/server/plugins` (server), `@orpc/client/plugins` (client)

Batch multiple procedure calls into a single HTTP request for better performance.

**Server Configuration**:
```ts
import { BatchHandlerPlugin } from '@orpc/server/plugins'

const handler = new RPCHandler(router, {
  plugins: [new BatchHandlerPlugin()],
})
```

**Server response headers**:
```ts
new BatchHandlerPlugin({
  headers: (responses) => ({
    'x-batch-id': crypto.randomUUID(),
  }),
})
```

**Default**: oRPC uses the headers that appear in all requests in the batch.

**Client Configuration**:
```ts
import { BatchLinkPlugin } from '@orpc/client/plugins'

const link = new RPCLink({
  url: 'https://api.example.com/rpc',
  plugins: [
    new BatchLinkPlugin({
      groups: [{ condition: options => true, context: {} }],
    }),
  ],
})
```

**Advanced Configuration**:
```ts
new BatchLinkPlugin({
  // Mode: 'streaming' (default) or 'buffered'
  mode: typeof window === 'undefined' ? 'buffered' : 'streaming',

  // Batching groups
  groups: [
    { condition: () => true, context: {} }
  ],

  // Exclude specific procedures
  exclude: ({ path }) => {
    const fullPath = path.join('/')
    // Don't batch Event Iterator procedures
    if (fullPath === 'chat/messages') return true
    // Don't batch file uploads
    if (fullPath === 'files/upload') return true
    return false
  },

  // Custom headers for batch requests
  headers: () => ({
    authorization: `Bearer ${getToken()}`,
  }),
})
```

**Configuration Options**:
- `mode`:
  - `'streaming'` (default): Use streaming responses (better for browser)
  - `'buffered'`: Buffer entire response (needed for some environments)
- `groups`: Define batching groups with conditions
- `exclude`: Filter out procedures that shouldn't be batched
- `headers`: Custom headers for batch request

**Example with multiple groups**:
```ts
new BatchLinkPlugin({
  groups: [
    // High-priority batch group
    {
      condition: ({ priority }) => priority === 'high',
      context: { priority: 'high' },
    },
    // Default batch group
    {
      condition: () => true,
      context: {},
    },
  ],
})
```

**Limitations**:
- Does not support AsyncIteratorObject in responses
- Does not support File or Blob in responses
- Event Iterator procedures should be excluded

**Note**: HTTP/2 and HTTP/3 already support multiplexing, so this plugin may be less beneficial in modern scenarios. Consider using it primarily for HTTP/1.1 connections.

### Client Retry Plugin

**Package**: `@orpc/client/plugins`

Automatically retry failed requests with configurable strategies.

```ts
import { ClientRetryPlugin, ClientRetryPluginContext } from '@orpc/client/plugins'

interface ORPCClientContext extends ClientRetryPluginContext {}

const link = new RPCLink<ORPCClientContext>({
  url: 'http://localhost:3000/rpc',
  plugins: [
    new ClientRetryPlugin({
      default: {
        retry: ({ path }) => {
          const fullPath = path.join('.')
          // Retry read operations
          if (fullPath === 'planet.list') return 2
          if (fullPath === 'planet.get') return 2
          // Don't retry mutations
          return 0
        },
        retryDelay: 1000,
        shouldRetry: ({ error }) => {
          // Retry network errors
          if (error.code === 'NETWORK_ERROR') return true
          // Retry timeouts
          if (error.code === 'TIMEOUT') return true
          // Don't retry client errors
          return false
        },
      },
    }),
  ],
})
```

**Per-call configuration**:
```ts
const planets = await client.planet.list(
  { limit: 10 },
  {
    context: {
      retry: 3,
      retryDelay: 2000,
      shouldRetry: ({ error, attempt, path }) => {
        console.log(`Retry attempt ${attempt} for ${path.join('.')}`)
        return error.code === 'NETWORK_ERROR'
      },
      onRetry: ({ error, attempt }) => {
        console.log(`Retrying after error: ${error.message}`)
        return (isSuccess) => {
          if (isSuccess) {
            console.log(`Retry ${attempt} succeeded`)
          } else {
            console.log(`Retry ${attempt} failed`)
          }
        }
      },
    },
  }
)
```

**Event Iterator (SSE) retry**:
```ts
const streaming = await client.streaming('input', {
  context: {
    retry: Number.POSITIVE_INFINITY, // Retry indefinitely
    retryDelay: 5000,
  },
})

for await (const message of streaming) {
  console.log(message)
}
```

**Configuration Options**:
- `retry`: Number of retry attempts or function (default: `0`)
- `retryDelay`: Delay between retries (default: `(o) => o.lastEventRetry ?? 2000`). For SSE/Event Iterators, respects the server's `retry` field via `lastEventRetry`.
- `shouldRetry`: Function to determine if error should trigger retry (default: `true`)
- `onRetry`: Callback before retry (can return callback for after retry)

**Advanced retry strategies**:
```ts
// Exponential backoff
new ClientRetryPlugin({
  default: {
    retry: 3,
    retryDelay: ({ attempt }) => Math.pow(2, attempt) * 1000,
  },
})

// Conditional retry by error type
new ClientRetryPlugin({
  default: {
    retry: 3,
    shouldRetry: ({ error }) => {
      const retryableCodes = ['NETWORK_ERROR', 'TIMEOUT', 'SERVICE_UNAVAILABLE']
      return retryableCodes.includes(error.code)
    },
  },
})

// Retry with logging
new ClientRetryPlugin({
  default: {
    retry: 2,
    onRetry: ({ error, attempt, path }) => {
      logger.warn(`Retrying ${path.join('.')} (attempt ${attempt})`, { error })
      return (isSuccess) => {
        if (isSuccess) {
          logger.info(`Retry succeeded for ${path.join('.')}`)
        }
      }
    },
  },
})
```

### Dedupe Requests Plugin

**Package**: `@orpc/client/plugins`

Deduplicate identical in-flight requests to prevent redundant network calls.

```ts
import { DedupeRequestsPlugin } from '@orpc/client/plugins'

const link = new RPCLink({
  url: 'https://api.example.com/rpc',
  plugins: [
    new DedupeRequestsPlugin({
      // Only dedupe GET requests by default
      filter: ({ request }) => request.method === 'GET',
      groups: [{ condition: () => true, context: {} }],
    }),
  ],
})
```

**Advanced Configuration**:
```ts
new DedupeRequestsPlugin({
  // Custom deduplication logic
  filter: ({ request, path }) => {
    // Dedupe all read operations
    if (request.method === 'GET') return true
    // Dedupe specific procedures
    const fullPath = path.join('.')
    if (fullPath === 'user.getProfile') return true
    return false
  },

  // Multiple deduplication groups
  groups: [
    {
      condition: ({ cache }) => cache === 'user',
      context: { cache: 'user' },
    },
    {
      condition: () => true,
      context: {},
    },
  ],
})
```

**Example usage**:
```ts
// These concurrent calls will be deduped into one request
const [user1, user2, user3] = await Promise.all([
  client.user.get({ id: '123' }),
  client.user.get({ id: '123' }),
  client.user.get({ id: '123' }),
])
// Only one network request is made
```

**When to use**:
- Prevent duplicate requests when components mount simultaneously
- Optimize React Suspense scenarios
- Reduce load on servers during burst traffic

**Default behavior**: Only GET requests are deduplicated.

**Tip**: If your application does not rely on running multiple mutation requests in parallel (in the same call stack), expand the filter to deduplicate ALL request types. This prevents issues from users clicking actions too quickly:

```ts
new DedupeRequestsPlugin({
  filter: () => true, // Dedupe all requests
  groups: [{ condition: () => true, context: {} }],
})
```

### Retry After Plugin

**Package**: `@orpc/client/plugins`

Automatically respect `Retry-After` headers for rate limiting and service unavailability.

```ts
import { RetryAfterPlugin } from '@orpc/client/plugins'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  plugins: [
    new RetryAfterPlugin({
      condition: (response) =>
        response.status === 429 || // Rate limited
        response.status === 503,   // Service unavailable
      maxAttempts: 5,       // default: 3
      timeout: 5 * 60 * 1000, // default: 5 minutes
    }),
  ],
})
```

**Configuration Options**:
- `condition`: Function to determine if retry should happen
- `maxAttempts`: Maximum number of retry attempts (default: 3)
- `timeout`: Maximum total time to retry in milliseconds (default: 5 minutes)

**Defaults**: Retries on `429` (Too Many Requests) and `503` (Service Unavailable) status codes.

**How it works**:
1. Server responds with 429 or 503 status
2. Plugin reads `Retry-After` header (seconds or HTTP date)
3. Waits specified duration before retrying
4. Respects `maxAttempts` and `timeout` limits

**Example with logging**:
```ts
new RetryAfterPlugin({
  condition: (response) => {
    if (response.status === 429) {
      console.log('Rate limited, will retry after delay')
      return true
    }
    if (response.status === 503) {
      console.log('Service unavailable, will retry after delay')
      return true
    }
    return false
  },
  maxAttempts: 10,
  timeout: 10 * 60 * 1000, // 10 minutes
})
```

**Server-side example**:
```ts
const rateLimited = os.handler(({ context }) => {
  if (isRateLimited(context.user)) {
    context.resHeaders?.set('Retry-After', '60') // 60 seconds
    throw new ORPCError('TOO_MANY_REQUESTS', {
      message: 'Rate limit exceeded',
    })
  }
  return { success: true }
})
```

## Contract Plugins

### Request Validation Plugin

**Package**: `@orpc/contract/plugins`

Validate requests against contract schema on the client-side, blocking invalid requests before they reach the server.

```ts
import { RequestValidationPlugin } from '@orpc/contract/plugins'
import { contract } from './contract'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  plugins: [new RequestValidationPlugin(contract)],
})
```

**Benefits**:
- Catch validation errors immediately on client
- Reduce unnecessary network requests
- Faster feedback during development
- Type-safe validation matching server

**Example with error handling**:
```ts
try {
  await client.user.create({
    email: 'invalid-email', // Validation error caught immediately
    name: 'John',
  })
} catch (error) {
  if (error instanceof ORPCError && error.code === 'VALIDATION_ERROR') {
    console.log('Client-side validation failed:', error.message)
    // No network request was made
  }
}
```

**Best suited for**: Contract-First Development workflow where contract is the source of truth.

**Limitation**: Minified Contract is NOT supported. Use full contract with schemas.

### Form Validation

Use with form data for field-level error display:

```tsx
import { getIssueMessage, parseFormData } from '@orpc/openapi-client/helpers'

function ContactForm() {
  const [error, setError] = useState(null)

  return (
    <form action={(form) => {
      const [err] = await someAction(parseFormData(form))
      if (err) setError(err)
    }}>
      <input name="user[name]" type="text" />
      <span>{getIssueMessage(error, 'user[name]')}</span>

      <input name="user[email]" type="email" />
      <span>{getIssueMessage(error, 'user[email]')}</span>

      <button type="submit">Submit</button>
    </form>
  )
}
```

### Response Validation Plugin

**Package**: `@orpc/contract/plugins`

Validate server responses against contract schema on the client-side, ensuring type safety at runtime.

```ts
import { ResponseValidationPlugin } from '@orpc/contract/plugins'
import { contract } from './contract'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  plugins: [new ResponseValidationPlugin(contract)],
})
```

**Benefits**:
- Catch server contract violations immediately
- Ensure type safety at runtime
- Detect API version mismatches
- Safer integration with untrusted servers

**Example with error handling**:
```ts
try {
  const user = await client.user.get({ id: '123' })
  // Response validated against contract
  console.log(user.email) // Type-safe
} catch (error) {
  if (error instanceof ORPCError && error.code === 'VALIDATION_ERROR') {
    console.log('Server response does not match contract:', error.message)
    // Server returned unexpected data
  }
}
```

**Limitation**: Schemas that transform data into different types are NOT supported.

**Example of unsupported schema**:
```ts
// This will NOT work with ResponseValidationPlugin:
const unsupported = z.number().transform(value => value.toString())

// Server returns: 123 (number)
// After transform: "123" (string)
// Plugin validates original response (number), not transformed (string)
```

**Best suited for**: Contract-First Development workflow where contract is the source of truth.

**Limitation**: Minified Contract is NOT supported. Use full contract with schemas.

## Plugin Composition

### Multiple Plugins Example

```ts
import { RPCHandler } from '@orpc/server/fetch'
import {
  CORSPlugin,
  BatchHandlerPlugin,
  SimpleCsrfProtectionHandlerPlugin,
  RequestHeadersPlugin,
  ResponseHeadersPlugin,
} from '@orpc/server/plugins'
import { BodyLimitPlugin, CompressionPlugin } from '@orpc/server/fetch'

const handler = new RPCHandler(router, {
  strictGetMethodPluginEnabled: false,
  plugins: [
    new CORSPlugin({
      origin: (origin) => origin,
      credentials: true,
    }),
    new BodyLimitPlugin({ maxBodySize: 10 * 1024 * 1024 }),
    new CompressionPlugin(),
    new BatchHandlerPlugin(),
    new SimpleCsrfProtectionHandlerPlugin(),
    new RequestHeadersPlugin(),
    new ResponseHeadersPlugin(),
  ],
})
```

### Client Plugins Composition

```ts
import { RPCLink } from '@orpc/client/fetch'
import {
  BatchLinkPlugin,
  ClientRetryPlugin,
  DedupeRequestsPlugin,
  RetryAfterPlugin,
  SimpleCsrfProtectionLinkPlugin,
} from '@orpc/client/plugins'
import { RequestValidationPlugin, ResponseValidationPlugin } from '@orpc/contract/plugins'

const link = new RPCLink({
  url: 'http://localhost:3000/rpc',
  plugins: [
    new SimpleCsrfProtectionLinkPlugin(),
    new DedupeRequestsPlugin(),
    new RetryAfterPlugin({ maxAttempts: 5 }),
    new ClientRetryPlugin({
      default: {
        retry: 2,
        retryDelay: 1000,
      },
    }),
    new BatchLinkPlugin({
      exclude: ({ path }) => path.join('.').startsWith('stream'),
    }),
    new RequestValidationPlugin(contract),
    new ResponseValidationPlugin(contract),
  ],
})
```

## Plugin Order

Plugin execution order matters. Plugins execute in the order they are added:

**Server plugins execute in this order**:
1. CORS (should be first to handle preflight)
2. Body Limit (validate size early)
3. Compression (compress final response)
4. Request Headers (inject headers for other plugins)
5. Response Headers (allow setting headers in handlers)
6. CSRF Protection (security check)
7. Batch Handler (handle batch requests)

**Client plugins execute in this order**:
1. Request Validation (validate before sending)
2. Dedupe (avoid duplicate requests)
3. Retry After (handle rate limiting)
4. Client Retry (handle failures)
5. CSRF Protection (add CSRF headers)
6. Batch (combine requests)
7. Response Validation (validate after receiving)

## Custom Plugin Development

oRPC allows creating custom plugins for both handlers and links.

**Server Plugin Structure**:
```ts
import type { Plugin } from '@orpc/server'

class CustomServerPlugin implements Plugin {
  async execute(input: unknown, options: unknown, next: Function) {
    // Before request
    console.log('Request:', input)

    try {
      const result = await next(input, options)
      // After successful response
      console.log('Response:', result)
      return result
    } catch (error) {
      // After error
      console.error('Error:', error)
      throw error
    }
  }
}
```

**Client Plugin Structure**:
```ts
import type { Plugin } from '@orpc/client'

class CustomClientPlugin implements Plugin {
  async execute(input: unknown, options: unknown, next: Function) {
    // Before request
    const startTime = Date.now()

    try {
      const result = await next(input, options)
      // After response
      const duration = Date.now() - startTime
      console.log(`Request took ${duration}ms`)
      return result
    } catch (error) {
      // Handle error
      throw error
    }
  }
}
```

### Communication Between Interceptors

Use unique symbols to share data between `rootInterceptors` and `clientInterceptors`:

```ts
const MY_PLUGIN_DATA = Symbol('MY_PLUGIN_DATA')

options.rootInterceptors.push(async (opts) => {
  return opts.next({
    ...opts,
    context: { ...opts.context, [MY_PLUGIN_DATA]: { startTime: Date.now() } },
  })
})

options.clientInterceptors.push(async (opts) => {
  const data = opts.context[MY_PLUGIN_DATA]
  // Access shared data from root interceptor
})
```

**Note**: The `order` property controls plugin loading order, not interceptor execution order. To ensure your interceptor runs earlier, set a higher order value and use `.unshift` instead of `.push`.

See the main SKILL.md for more details on custom plugin development.

## See Also

- Core API (procedures, middleware, context, errors): `references/api-reference.md`
- Framework adapters: `references/adapters.md`
- OpenAPI integration: `references/openapi.md`
- Helpers (rate limiting as middleware alternative): `references/helpers.md`
