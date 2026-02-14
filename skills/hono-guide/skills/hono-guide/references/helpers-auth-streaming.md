# Hono Auth & Streaming Helpers

Reference for authentication and real-time streaming helpers.

## Table of Contents

- [Cookie Helper](#cookie-helper)
- [JWT Helper](#jwt-helper)
- [Streaming Helper](#streaming-helper)
- [WebSocket Helper](#websocket-helper)

---

## Cookie Helper

**Import**: `hono/cookie`

Provides utilities for managing HTTP cookies with type-safe options and security features.

### Basic Cookie Functions

#### `getCookie(c, name?, prefix?)`

Get cookie value(s) from the request.

```typescript
import { getCookie } from 'hono/cookie'

// Get specific cookie
const sessionId = getCookie(c, 'session_id')

// Get all cookies
const allCookies = getCookie(c)

// Get cookies with prefix
const secureCookies = getCookie(c, undefined, '__Secure-')
```

#### `setCookie(c, name, value, options?)`

Set a cookie in the response.

```typescript
import { setCookie } from 'hono/cookie'

setCookie(c, 'session_id', 'abc123', {
  path: '/',
  httpOnly: true,
  secure: true,
  maxAge: 86400, // 1 day in seconds
  sameSite: 'Strict'
})
```

#### `deleteCookie(c, name, options?)`

Delete a cookie by setting it to expire immediately.

```typescript
import { deleteCookie } from 'hono/cookie'

deleteCookie(c, 'session_id', {
  path: '/',
  domain: 'example.com'
})
```

### Signed Cookie Functions

Cookies with HMAC signatures for tamper detection.

#### `getSignedCookie(c, secret, name?, prefix?)`

Get and verify signed cookie(s).

```typescript
import { getSignedCookie } from 'hono/cookie'

const secret = 'my-secret-key'

// Get specific signed cookie
const userId = await getSignedCookie(c, secret, 'user_id')

// Get all signed cookies
const signedCookies = await getSignedCookie(c, secret)

// Returns false if signature is invalid
if (userId === false) {
  // Cookie was tampered with
}
```

#### `setSignedCookie(c, name, value, secret, options?)`

Set a signed cookie.

```typescript
import { setSignedCookie } from 'hono/cookie'

await setSignedCookie(c, 'user_id', '12345', 'my-secret-key', {
  path: '/',
  httpOnly: true,
  secure: true,
  maxAge: 86400
})
```

### Cookie Generation Functions

Generate cookie strings without context.

#### `generateCookie(name, value, options?)`

Generate a cookie string.

```typescript
import { generateCookie } from 'hono/cookie'

const cookieString = generateCookie('token', 'xyz789', {
  path: '/',
  httpOnly: true
})
// Returns: "token=xyz789; Path=/; HttpOnly"
```

#### `generateSignedCookie(name, value, secret, options?)`

Generate a signed cookie string.

```typescript
import { generateSignedCookie } from 'hono/cookie'

const signedCookieString = await generateSignedCookie(
  'token',
  'xyz789',
  'my-secret-key',
  { path: '/', httpOnly: true }
)
```

### Cookie Options

All cookie options conform to RFC6265bis-13 and CHIPS specifications.

```typescript
interface CookieOptions {
  domain?: string        // Cookie domain
  expires?: Date         // Expiration date
  httpOnly?: boolean     // Prevent JavaScript access
  maxAge?: number        // Max age in seconds (≤400 days per RFC6265bis-13)
  path?: string          // Cookie path
  secure?: boolean       // HTTPS only
  sameSite?: 'Strict' | 'Lax' | 'None'  // CSRF protection
  priority?: 'Low' | 'Medium' | 'High'  // Priority hint
  prefix?: 'host' | 'secure'            // Cookie prefix type
  partitioned?: boolean  // Partitioned cookie (CHIPS)
}
```

### Cookie Prefixes

Special cookie name prefixes that enforce security requirements.

#### `__Secure-` Prefix

Cookies with this prefix:
- MUST have `secure: true`
- MUST be sent over HTTPS

```typescript
setCookie(c, '__Secure-session', 'value', {
  secure: true,  // Required
  httpOnly: true,
  sameSite: 'Strict'
})
```

#### `__Host-` Prefix

Cookies with this prefix:
- MUST have `secure: true`
- MUST NOT have `domain` attribute
- MUST have `path: '/'`

```typescript
setCookie(c, '__Host-session', 'value', {
  secure: true,   // Required
  path: '/',      // Required
  // domain: NOT allowed
  httpOnly: true,
  sameSite: 'Strict'
})
```

### Best Practices

**MaxAge Limit (RFC6265bis-13)**
```typescript
// Max 400 days (34,560,000 seconds)
setCookie(c, 'long_session', 'value', {
  maxAge: 34560000  // 400 days maximum
})
```

**CHIPS (Partitioned Cookies)**
```typescript
// Partitioned cookie for cross-site contexts
setCookie(c, '__Host-partitioned', 'value', {
  secure: true,
  path: '/',
  sameSite: 'None',
  partitioned: true  // Enable CHIPS
})
```

**Security Best Practices**
```typescript
// Recommended secure cookie configuration
setCookie(c, '__Host-session', sessionId, {
  secure: true,
  httpOnly: true,
  sameSite: 'Strict',
  path: '/',
  maxAge: 86400  // 1 day
})
```

---

## JWT Helper

**Import**: `hono/jwt`

JSON Web Token utilities for authentication and authorization.

### Core Functions

#### `sign(payload, secret, alg?)`

Create a signed JWT token.

```typescript
import { sign } from 'hono/jwt'

const payload = {
  sub: 'user123',
  role: 'admin',
  exp: Math.floor(Date.now() / 1000) + (60 * 60) // 1 hour
}

const token = await sign(payload, 'your-secret-key', 'HS256')
```

#### `verify(token, secret, alg?, issuer?)`

Verify and decode a JWT token.

```typescript
import { verify } from 'hono/jwt'

try {
  const payload = await verify(token, 'your-secret-key', 'HS256')
  console.log(payload.sub) // user123
} catch (e) {
  // Token invalid, expired, or signature mismatch
}
```

#### `decode(token)`

Decode a JWT without verification (unsafe for untrusted tokens).

```typescript
import { decode } from 'hono/jwt'

const { header, payload } = decode(token)
console.log(header.alg)  // Algorithm
console.log(payload.sub) // Subject
```

### Payload Validation

JWT helper automatically validates standard claims:

#### `exp` - Expiration Time

Token is invalid after this Unix timestamp.

```typescript
const payload = {
  sub: 'user123',
  exp: Math.floor(Date.now() / 1000) + (60 * 60) // Expires in 1 hour
}

await sign(payload, secret)
// Will throw JwtTokenExpired when verifying after expiration
```

#### `nbf` - Not Before

Token is invalid before this Unix timestamp.

```typescript
const payload = {
  sub: 'user123',
  nbf: Math.floor(Date.now() / 1000) + 60 // Valid after 1 minute
}

await sign(payload, secret)
// Will throw JwtTokenNotBefore when verifying before nbf time
```

#### `iat` - Issued At

Timestamp when token was issued (informational).

```typescript
const payload = {
  sub: 'user123',
  iat: Math.floor(Date.now() / 1000)
}
```

#### `iss` - Issuer

Validate the token issuer.

```typescript
const payload = {
  sub: 'user123',
  iss: 'https://auth.example.com'
}

await sign(payload, secret)

// Verify with issuer validation
await verify(token, secret, 'HS256', 'https://auth.example.com')
// Throws JwtTokenIssuedAt if issuer doesn't match
```

### Custom Error Types

All JWT errors extend the base Error class:

```typescript
import {
  JwtAlgorithmNotImplemented,
  JwtTokenInvalid,
  JwtTokenNotBefore,
  JwtTokenExpired,
  JwtTokenIssuedAt,
  JwtTokenSignatureMismatched
} from 'hono/jwt'

try {
  await verify(token, secret)
} catch (e) {
  if (e instanceof JwtTokenExpired) {
    // Token has expired
  } else if (e instanceof JwtTokenSignatureMismatched) {
    // Token signature is invalid
  } else if (e instanceof JwtTokenNotBefore) {
    // Token not yet valid
  } else if (e instanceof JwtTokenInvalid) {
    // Token format is invalid
  } else if (e instanceof JwtTokenIssuedAt) {
    // Issuer validation failed
  } else if (e instanceof JwtAlgorithmNotImplemented) {
    // Unsupported algorithm
  }
}
```

### Supported Algorithms

All standard JWT algorithms are supported:

#### HMAC Algorithms (Symmetric)

```typescript
// HS256 - HMAC using SHA-256 (default)
await sign(payload, secret, 'HS256')

// HS384 - HMAC using SHA-384
await sign(payload, secret, 'HS384')

// HS512 - HMAC using SHA-512
await sign(payload, secret, 'HS512')
```

#### RSA Algorithms (Asymmetric)

```typescript
// RS256 - RSASSA-PKCS1-v1_5 using SHA-256
await sign(payload, privateKey, 'RS256')
await verify(token, publicKey, 'RS256')

// RS384 - RSASSA-PKCS1-v1_5 using SHA-384
await sign(payload, privateKey, 'RS384')

// RS512 - RSASSA-PKCS1-v1_5 using SHA-512
await sign(payload, privateKey, 'RS512')
```

#### PSS Algorithms (Asymmetric)

```typescript
// PS256 - RSASSA-PSS using SHA-256
await sign(payload, privateKey, 'PS256')
await verify(token, publicKey, 'PS256')

// PS384 - RSASSA-PSS using SHA-384
await sign(payload, privateKey, 'PS384')

// PS512 - RSASSA-PSS using SHA-512
await sign(payload, privateKey, 'PS512')
```

#### ECDSA Algorithms (Asymmetric)

```typescript
// ES256 - ECDSA using P-256 and SHA-256
await sign(payload, privateKey, 'ES256')
await verify(token, publicKey, 'ES256')

// ES384 - ECDSA using P-384 and SHA-384
await sign(payload, privateKey, 'ES384')

// ES512 - ECDSA using P-521 and SHA-512
await sign(payload, privateKey, 'ES512')
```

#### EdDSA Algorithm (Asymmetric)

```typescript
// EdDSA - Edwards-curve Digital Signature Algorithm
await sign(payload, privateKey, 'EdDSA')
await verify(token, publicKey, 'EdDSA')
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { sign, verify } from 'hono/jwt'

const app = new Hono()

const SECRET = 'your-secret-key'

app.post('/login', async (c) => {
  const { username, password } = await c.req.json()

  // Validate credentials...

  const payload = {
    sub: username,
    role: 'user',
    exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24) // 24 hours
  }

  const token = await sign(payload, SECRET)
  return c.json({ token })
})

app.get('/protected', async (c) => {
  const authHeader = c.req.header('Authorization')
  const token = authHeader?.replace('Bearer ', '')

  if (!token) {
    return c.json({ error: 'No token provided' }, 401)
  }

  try {
    const payload = await verify(token, SECRET)
    return c.json({ user: payload.sub, role: payload.role })
  } catch (e) {
    return c.json({ error: 'Invalid token' }, 401)
  }
})
```

---

## Streaming Helper

**Import**: `hono/streaming`

Utilities for streaming responses, including raw streaming, text streaming, and Server-Sent Events (SSE).

### Raw Streaming

#### `stream(c, callback, errorHandler?)`

Create a raw streaming response.

```typescript
import { stream } from 'hono/streaming'

app.get('/stream', (c) => {
  return stream(c, async (stream) => {
    // Write data
    await stream.write(new Uint8Array([1, 2, 3]))

    // Wait
    await stream.sleep(1000)

    // Write more data
    await stream.write(new Uint8Array([4, 5, 6]))
  })
})
```

### Text Streaming

#### `streamText(c, callback, errorHandler?)`

Stream text/plain content.

```typescript
import { streamText } from 'hono/streaming'

app.get('/text-stream', (c) => {
  return streamText(c, async (stream) => {
    // Write line of text
    await stream.writeln('First line')

    await stream.sleep(500)

    // Write without newline
    await stream.write('Partial ')
    await stream.write('line\n')

    await stream.writeln('Last line')
  })
})
```

### Server-Sent Events (SSE)

#### `streamSSE(c, callback, errorHandler?)`

Stream Server-Sent Events (text/event-stream).

```typescript
import { streamSSE } from 'hono/streaming'

app.get('/sse', (c) => {
  return streamSSE(c, async (stream) => {
    let count = 0

    while (true) {
      // Send SSE event
      await stream.writeSSE({
        data: JSON.stringify({ count }),
        event: 'counter',
        id: String(count)
      })

      count++
      await stream.sleep(1000)

      // Check if client disconnected
      if (stream.aborted) {
        break
      }
    }
  })
})
```

### Stream Methods

All stream types support these methods:

#### `write(data)`

Write data to the stream.

```typescript
// Raw stream: write Uint8Array
await stream.write(new Uint8Array([1, 2, 3]))

// Text stream: write string
await stream.write('Hello')
```

#### `writeln(data)`

Write data followed by a newline (text streams only).

```typescript
await stream.writeln('Line of text')
// Equivalent to: await stream.write('Line of text\n')
```

#### `pipe(readable)`

Pipe a ReadableStream to the output.

```typescript
import { stream } from 'hono/streaming'

app.get('/proxy', async (c) => {
  const response = await fetch('https://example.com/large-file')

  return stream(c, async (stream) => {
    await stream.pipe(response.body!)
  })
})
```

#### `sleep(ms)`

Pause streaming for specified milliseconds.

```typescript
await stream.sleep(1000) // Wait 1 second
```

#### `close()`

Close the stream.

```typescript
await stream.close()
```

#### `onAbort(callback)`

Register a callback for when the client disconnects.

```typescript
stream.onAbort(() => {
  console.log('Client disconnected')
  // Cleanup resources
})

// Or check the aborted property
if (stream.aborted) {
  // Stream was aborted
}
```

### SSE Event Format

#### `writeSSE(event)`

Send a Server-Sent Event.

```typescript
await stream.writeSSE({
  data: 'Event payload',      // Required: event data
  event: 'custom-event',      // Optional: event type
  id: '123'                   // Optional: event ID
})
```

**SSE Message Format:**
```
id: 123
event: custom-event
data: Event payload

```

### Error Handling

Provide an error handler as the third argument.

```typescript
import { streamText } from 'hono/streaming'

app.get('/stream', (c) => {
  return streamText(
    c,
    async (stream) => {
      // Stream logic
      throw new Error('Something went wrong')
    },
    (err, stream) => {
      // Handle error
      console.error('Stream error:', err)
      stream.writeln('Error occurred')
    }
  )
})
```

**Important**: The `onError` middleware is NOT triggered during streaming because the response headers have already been sent.

### Cloudflare Workers Note

Cloudflare Workers requires the `Content-Encoding: Identity` header for streaming.

```typescript
import { stream } from 'hono/streaming'

app.get('/stream', (c) => {
  return stream(c, async (stream) => {
    c.header('Content-Encoding', 'Identity')
    // Stream logic...
  })
})
```

### Complete Examples

**Progress Updates:**
```typescript
app.get('/progress', (c) => {
  return streamSSE(c, async (stream) => {
    const steps = ['Starting', 'Processing', 'Finalizing', 'Complete']

    for (let i = 0; i < steps.length; i++) {
      await stream.writeSSE({
        data: JSON.stringify({
          step: steps[i],
          progress: ((i + 1) / steps.length) * 100
        }),
        id: String(i)
      })

      await stream.sleep(1000)
    }
  })
})
```

**Live Data Feed:**
```typescript
app.get('/live-data', (c) => {
  return streamSSE(c, async (stream) => {
    const interval = setInterval(async () => {
      if (stream.aborted) {
        clearInterval(interval)
        return
      }

      await stream.writeSSE({
        data: JSON.stringify({
          timestamp: Date.now(),
          value: Math.random()
        }),
        event: 'data'
      })
    }, 1000)

    stream.onAbort(() => {
      clearInterval(interval)
    })
  })
})
```

---

## WebSocket Helper

**Import**: Platform-specific

Provides WebSocket support with platform-specific implementations.

### Platform-Specific Imports

Different runtimes require different imports:

```typescript
// Cloudflare Workers
import { upgradeWebSocket } from 'hono/cloudflare-workers'

// Deno
import { upgradeWebSocket } from 'hono/deno'

// Bun
import { createBunWebSocket } from 'hono/bun'

// Node.js (requires @hono/node-ws)
import { upgradeWebSocket } from '@hono/node-ws'
```

### Basic Usage

#### `upgradeWebSocket(callback)`

Creates a WebSocket handler.

```typescript
import { Hono } from 'hono'
import { upgradeWebSocket } from 'hono/cloudflare-workers'

const app = new Hono()

app.get('/ws', upgradeWebSocket(() => ({
  onOpen(evt, ws) {
    console.log('Connection opened')
  },

  onMessage(event, ws) {
    console.log('Message received:', event.data)
    ws.send('Echo: ' + event.data)
  },

  onClose(evt, ws) {
    console.log('Connection closed')
  },

  onError(evt, ws) {
    console.error('Error:', evt)
  }
})))
```

### WebSocket Events

All platforms support these event handlers:

#### `onOpen(event, ws)`

Called when the WebSocket connection is established.

```typescript
onOpen(evt, ws) {
  console.log('Client connected')
  ws.send('Welcome!')
}
```

#### `onMessage(event, ws)`

Called when a message is received.

```typescript
onMessage(event, ws) {
  const message = event.data

  if (typeof message === 'string') {
    // Text message
    console.log('Text:', message)
  } else {
    // Binary message
    console.log('Binary:', message)
  }

  // Send response
  ws.send('Received: ' + message)
}
```

#### `onClose(event, ws)`

Called when the connection is closed.

```typescript
onClose(evt, ws) {
  console.log('Connection closed:', evt.code, evt.reason)
}
```

#### `onError(event, ws)`

Called when an error occurs.

```typescript
onError(evt, ws) {
  console.error('WebSocket error:', evt)
}
```

### Bun-Specific Usage

Bun requires exporting the websocket configuration.

```typescript
import { Hono } from 'hono'
import { createBunWebSocket } from 'hono/bun'

const app = new Hono()

const { upgradeWebSocket, websocket } = createBunWebSocket()

app.get('/ws', upgradeWebSocket(() => ({
  onMessage(evt, ws) {
    ws.send('Echo: ' + evt.data)
  }
})))

// Export websocket config for Bun
export default {
  port: 3000,
  fetch: app.fetch,
  websocket
}
```

### RPC Mode with WebSocket

WebSockets can be used with Hono's RPC mode for type-safe communication.

```typescript
import { Hono } from 'hono'
import { upgradeWebSocket } from 'hono/cloudflare-workers'

const app = new Hono()

const wsRoute = app.get('/ws', upgradeWebSocket(() => ({
  onMessage(event, ws) {
    const data = JSON.parse(event.data)

    // Type-safe message handling
    ws.send(JSON.stringify({
      type: 'response',
      data: processData(data)
    }))
  }
})))

// Export type for client
export type WsRoute = typeof wsRoute
```

**Client:**
```typescript
import { hc } from 'hono/client'
import type { WsRoute } from './server'

const client = hc<WsRoute>('http://localhost:3000')

const ws = new WebSocket('ws://localhost:3000/ws')

ws.onmessage = (event) => {
  const response = JSON.parse(event.data)
  console.log('Type-safe response:', response)
}
```

### Middleware Compatibility Warning

WebSocket upgrade MUST happen before any middleware that modifies response headers.

**BAD - Will fail:**
```typescript
import { cors } from 'hono/cors'

app.use('*', cors()) // Modifies headers

app.get('/ws', upgradeWebSocket(() => ({
  onMessage(evt, ws) {
    ws.send('Echo: ' + evt.data)
  }
})))
```

**GOOD - WebSocket before header middleware:**
```typescript
// Register WebSocket route first
app.get('/ws', upgradeWebSocket(() => ({
  onMessage(evt, ws) {
    ws.send('Echo: ' + evt.data)
  }
})))

// Then apply header-modifying middleware to other routes
app.use('/api/*', cors())
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { upgradeWebSocket } from 'hono/cloudflare-workers'

const app = new Hono()

// Store connected clients
const clients = new Set<any>()

app.get('/ws', upgradeWebSocket(() => ({
  onOpen(evt, ws) {
    clients.add(ws)
    console.log('Client connected. Total:', clients.size)
  },

  onMessage(event, ws) {
    const message = event.data

    // Broadcast to all clients
    for (const client of clients) {
      if (client !== ws && client.readyState === 1) {
        client.send(message)
      }
    }
  },

  onClose(evt, ws) {
    clients.delete(ws)
    console.log('Client disconnected. Total:', clients.size)
  },

  onError(evt, ws) {
    console.error('WebSocket error:', evt)
    clients.delete(ws)
  }
})))

export default app
```

---
