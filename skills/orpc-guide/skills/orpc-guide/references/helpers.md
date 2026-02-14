# oRPC Helpers Reference

Complete reference for oRPC built-in helpers, rate limiting, and publisher utilities.

## Helpers

### Cookie Management

Built-in helpers for cookie operations:

```typescript
import {
  deleteCookie,
  getCookie,
  setCookie
} from '@orpc/server/helpers'

// Set cookie with options
setCookie(resHeaders, 'sessionId', 'abc123', {
  secure: true,
  httpOnly: true,
  maxAge: 3600,
  sameSite: 'strict',
})

// Delete cookie
deleteCookie(resHeaders, 'sessionId')

// Get cookie value
const sessionId = getCookie(reqHeaders, 'sessionId')
```

### Cookie Signing

Sign and verify cookies for tamper protection:

```typescript
import {
  sign,
  unsign,
  getSignedValue
} from '@orpc/server/helpers'

// Sign a value
const signed = await sign('abc123', 'secret-key')
// Result: "abc123.signature"

// Verify and unsign
const verified = await unsign(signed, 'secret-key')
// Result: 'abc123' or null if invalid

// Extract value without verification
const extracted = getSignedValue(signed)
// Result: 'abc123'
```

### Encryption

Encrypt and decrypt sensitive data:

```typescript
import { decrypt, encrypt } from '@orpc/server/helpers'

// Encrypt data
const encrypted = await encrypt('sensitive-data', 'encryption-key')

// Decrypt data
const decrypted = await decrypt(encrypted, 'encryption-key')
```

### Base64url Encoding

URL-safe base64 encoding:

```typescript
import {
  decodeBase64url,
  encodeBase64url
} from '@orpc/server/helpers'

// Encode
const encoded = encodeBase64url(
  new TextEncoder().encode('Hello World')
)

// Decode
const decoded = new TextDecoder().decode(
  decodeBase64url(encoded)
)
```

### Form Data Parsing

Parse form data with nested object support:

```typescript
import {
  parseFormData,
  getIssueMessage
} from '@orpc/openapi-client/helpers'

// Convert bracket notation to nested objects
const formData = new FormData()
formData.append('user[name]', 'John')
formData.append('user[email]', 'john@example.com')
formData.append('user[addresses][0][street]', '123 Main St')

const parsed = parseFormData(formData)
// Result: { user: { name: 'John', email: 'john@example.com', addresses: [{ street: '123 Main St' }] } }

// Get validation error messages
const emailError = getIssueMessage(error, 'user[email]')
```

### Edge Runtime Performance

**Warning**: Encryption helpers (`encrypt`/`decrypt`) use AES-GCM with PBKDF2. For edge runtimes like Cloudflare Workers, ensure sufficient CPU time budget (recommend >200ms per request).

**Null safety**: Cookie, signing, and encryption helpers accept `undefined`/`null` as input and return `undefined` when the input is invalid.

### Rate Limiting

Package: `@orpc/experimental-ratelimit`

Memory-based rate limiter:

```typescript
import { MemoryRatelimiter } from '@orpc/experimental-ratelimit/memory'
import { createRatelimitMiddleware } from '@orpc/experimental-ratelimit'

const limiter = new MemoryRatelimiter({
  maxRequests: 10,
  window: 60000 // 1 minute
})

const loginProcedure = os
  .$context<{ ratelimiter: Ratelimiter }>()
  .input(z.object({ email: z.string().email() }))
  .use(createRatelimitMiddleware({
    limiter: ({ context }) => context.ratelimiter,
    key: ({ context }, input) => `login:${input.email}`,
  }))
  .handler(({ input }) => {
    // Rate limited by email
    return { success: true }
  })
```

Redis-based rate limiter:

```typescript
import { RedisRatelimiter } from '@orpc/experimental-ratelimit/redis'
import Redis from 'ioredis'

const redis = new Redis()

const limiter = new RedisRatelimiter({
  eval: async (script, numKeys, ...rest) =>
    redis.eval(script, numKeys, ...rest),
  maxRequests: 100,
  window: 60000,
  prefix: 'orpc:ratelimit:',
})
```

Upstash Redis rate limiter:

```ts
import { UpstashRatelimiter } from '@orpc/experimental-ratelimit/upstash'
import { Redis } from '@upstash/redis'

const limiter = new UpstashRatelimiter({
  redis: new Redis({ url: '...', token: '...' }),
  maxRequests: 100,
  window: 60000,
  prefix: 'orpc:ratelimit:',
})
```

Plugin-based rate limiting (alternative to middleware):

```ts
import { createRatelimitPlugin } from '@orpc/experimental-ratelimit'

const handler = new RPCHandler(router, {
  plugins: [
    createRatelimitPlugin({
      limiter: ({ context }) => context.ratelimiter,
      key: ({ context }) => `user:${context.user?.id ?? 'anonymous'}`,
    }),
  ],
})
```

Cloudflare rate limiter:

```ts
import { CloudflareRatelimiter } from '@orpc/experimental-ratelimit/cloudflare'

const limiter = new CloudflareRatelimiter({
  binding: env.MY_RATE_LIMITER,
})
```

### Blocking Mode

Wait for rate limit reset instead of rejecting:

```ts
const limiter = new MemoryRatelimiter({
  maxRequests: 10,
  window: 60000,
  blockingUntilReady: { enabled: true, timeout: 5000 },
})
```

### Rate Limit Handler Plugin

Add HTTP rate-limiting headers (`RateLimit-*` and `Retry-After`) to responses:

```ts
import { RatelimitHandlerPlugin } from '@orpc/experimental-ratelimit'

const handler = new RPCHandler(router, {
  plugins: [
    createRatelimitPlugin({
      limiter: ({ context }) => context.ratelimiter,
      key: ({ context }) => `user:${context.user?.id ?? 'anonymous'}`,
    }),
  ],
})
```

### Automatic Deduplication

`createRatelimitMiddleware` auto-deduplicates rate limit checks when the same limiter+key combination is used. Disable with `dedupe: false`:

```ts
.use(createRatelimitMiddleware({
  limiter: ({ context }) => context.ratelimiter,
  key: ({ context }, input) => `login:${input.email}`,
  dedupe: false,
}))
```

### Conditional Limiter

Select different limiters dynamically:

```ts
.use(createRatelimitMiddleware({
  limiter: ({ context }) => {
    return context.user?.isPremium ? premiumLimiter : standardLimiter
  },
  key: ({ context }) => context.user?.id ?? 'anonymous',
}))
```

### Publisher (Event Resume Support)

Package: `@orpc/experimental-publisher`

Memory-based event publisher with resumable streams:

```typescript
import { MemoryPublisher } from '@orpc/experimental-publisher/memory'

// Define event types
type Events = {
  'updated': { id: string; timestamp: number }
  'deleted': { id: string }
}

const publisher = new MemoryPublisher<Events>()
```

**Resume support**: Configure event retention:

```ts
const publisher = new MemoryPublisher<Events>({
  resumeRetentionSeconds: 300, // Keep events for 5 minutes
})
```

```typescript
// Subscribe to events
const live = os.handler(async function* ({ signal, lastEventId }) {
  const iterator = publisher.subscribe('updated', {
    signal,
    lastEventId // Resume from last event
  })

  for await (const payload of iterator) {
    yield payload
  }
})

// Publish events
const publish = os
  .input(z.object({ id: z.string() }))
  .handler(async ({ input }) => {
    await publisher.publish('updated', {
      id: input.id,
      timestamp: Date.now(),
    })
  })
```

Available adapters:
- `MemoryPublisher` - In-memory (single server)
- `IORedisPublisher` - Redis-based (multi-server)
- `UpstashRedisPublisher` - Upstash Redis
- `PublisherDurableObject` - Cloudflare Durable Objects

Redis-based publisher (requires TWO Redis instances):

```ts
import { IORedisPublisher } from '@orpc/experimental-publisher/ioredis'
import Redis from 'ioredis'

const publisher = new IORedisPublisher<Events>({
  commander: new Redis(),    // For commands
  subscriber: new Redis(),   // For subscribing (dedicated connection)
  prefix: 'orpc:events:',
  resumeRetentionSeconds: 3600,
  customJsonSerializers: [],
})
```

Upstash Redis publisher:

```ts
import { UpstashRedisPublisher } from '@orpc/experimental-publisher/upstash-redis'
import { Redis } from '@upstash/redis'

const publisher = new UpstashRedisPublisher<Events>(
  Redis.fromEnv(),
  {
    prefix: 'orpc:events:',
    resumeRetentionSeconds: 3600,
  }
)
```

Cloudflare Durable Objects publisher:

```ts
import { PublisherDurableObject } from '@orpc/experimental-publisher/durable-object'

export class MyPublisher extends PublisherDurableObject<Events> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env, {
      signingKey: 'secret',
      resume: {
        retentionSeconds: 300,
        cleanupIntervalSeconds: 60,
      },
    })
  }
}
```

**Warning (Cloudflare)**: Requires `enable_request_signal` compatibility flag in `wrangler.toml`.

### Resume Feature Details

When resume is enabled, the publisher auto-manages event IDs. User-provided IDs are ignored.

Server-side: Forward `lastEventId` and use `getEventMeta`/`withEventMeta`:

```ts
const live = os.handler(async function* ({ signal, lastEventId }) {
  const iterator = publisher.subscribe('updated', { signal, lastEventId })

  for await (const payload of iterator) {
    yield payload
  }
})
```

Client-side: Use Client Retry Plugin for automatic `lastEventId` management, or manage manually:

```ts
let lastEventId: string | undefined

while (true) {
  try {
    const iterator = await client.live(undefined, {
      lastEventId,
    })
    for await (const event of iterator) {
      lastEventId = getEventMeta(event)?.id
      console.log(event)
    }
  } catch {
    await new Promise(r => setTimeout(r, 5000))
  }
}
```

Available adapters: `MemoryPublisher`, `IORedisPublisher`, `UpstashRedisPublisher`, `PublisherDurableObject`.

## See Also

- Core API (procedures, middleware, event iterators): `references/api-reference.md`
- Built-in plugins (rate limit plugin alternative): `references/plugins.md`
- Advanced patterns (testing, serialization, body parsing): `references/advanced.md`
