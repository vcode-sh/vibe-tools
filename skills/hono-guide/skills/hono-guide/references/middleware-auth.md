# Hono Auth Middleware

Reference for middleware concepts, execution order, and authentication middleware: Basic Auth, Bearer Auth, JWT Auth, JWK Auth.

## Table of Contents

- [Middleware Concepts](#middleware-concepts)
- [Authentication & Authorization](#authentication--authorization)
  - [Basic Auth](#basic-auth)
  - [Bearer Auth](#bearer-auth)
  - [JWT Auth](#jwt-auth)
  - [JWK Auth](#jwk-auth)

## Middleware Concepts

### Execution Order (Onion Model)

Hono middleware follows the onion model where middleware wraps around handlers:

```typescript
app.use('*', async (c, next) => {
  console.log('Before handler') // Outer layer going in
  await next()
  console.log('After handler')  // Outer layer going out
})

app.get('/', (c) => {
  console.log('Handler')
  return c.text('Hello')
})

// Output:
// Before handler
// Handler
// After handler
```

Middleware execution order:
1. Global middleware (registered with `app.use('*', ...)`)
2. Route-specific middleware (registered before the handler)
3. Handler
4. Middleware cleanup (in reverse order)

### Extending Context with Variables

Add custom properties to the context using `Variables`:

```typescript
type Variables = {
  user: { id: string; name: string }
  requestId: string
}

const app = new Hono<{ Variables: Variables }>()

app.use('*', async (c, next) => {
  c.set('requestId', crypto.randomUUID())
  await next()
})

app.get('/', (c) => {
  const requestId = c.get('requestId') // Fully typed
  return c.json({ requestId })
})
```

---

## Authentication & Authorization

### Basic Auth

HTTP Basic Authentication middleware.

**Import:**
```typescript
import { basicAuth } from 'hono/basic-auth'
```

**Basic Usage:**
```typescript
app.use('/admin/*', basicAuth({
  username: 'admin',
  password: 'secret'
}))
```

**Options:**

```typescript
type BasicAuthOptions = {
  // Single user credentials
  username: string
  password: string

  // Custom verification function (optional)
  verifyUser?: (username: string, password: string, c: Context) => boolean | Promise<boolean>

  // Realm for WWW-Authenticate header (optional)
  // Default: "Secure Area"
  realm?: string

  // Hash function for secure password comparison (optional)
  // Default: Timing-safe comparison
  hashFunction?: (password: string) => string | Promise<string>

  // Custom error message (optional)
  // Default: "Unauthorized"
  invalidUserMessage?: string
}
```

**Multiple Users (Rest Parameters):**
```typescript
app.use(
  '/admin/*',
  basicAuth({
    username: 'admin',
    password: 'adminpass'
  }),
  basicAuth({
    username: 'user',
    password: 'userpass'
  })
)
```

**Custom Verification:**
```typescript
app.use('/api/*', basicAuth({
  verifyUser: async (username, password, c) => {
    const user = await db.users.findOne({ username })
    return user && await bcrypt.compare(password, user.passwordHash)
  }
}))
```

**Using Hash Function:**
```typescript
import { sha256 } from 'hono/utils/crypto'

app.use('/secure/*', basicAuth({
  username: 'admin',
  password: await sha256('mysecret'),
  hashFunction: sha256
}))
```

---

### Bearer Auth

Bearer token authentication middleware.

**Import:**
```typescript
import { bearerAuth } from 'hono/bearer-auth'
```

**Basic Usage:**
```typescript
app.use('/api/*', bearerAuth({
  token: 'your-secret-token'
}))
```

**Options:**

```typescript
type BearerAuthOptions = {
  // Token or array of tokens
  token: string | string[]

  // Custom verification function (optional)
  verifyToken?: (token: string, c: Context) => boolean | Promise<boolean>

  // Realm for WWW-Authenticate header (optional)
  // Default: ""
  realm?: string

  // Token prefix (optional)
  // Default: "Bearer"
  prefix?: string

  // Header name to check (optional)
  // Default: "Authorization"
  headerName?: string

  // Hash function for secure token comparison (optional)
  hashFunction?: (token: string) => string | Promise<string>

  // Custom message when no auth header (optional)
  // Default: "Unauthorized"
  noAuthenticationHeader?: string

  // Custom message for invalid auth header format (optional)
  // Default: "Unauthorized"
  invalidAuthenticationHeader?: string

  // Custom message for invalid token (optional)
  // Default: "Unauthorized"
  invalidToken?: string
}
```

**Multiple Tokens:**
```typescript
app.use('/api/*', bearerAuth({
  token: [
    'token-for-service-a',
    'token-for-service-b',
    'token-for-admin'
  ]
}))
```

**Custom Verification:**
```typescript
app.use('/api/*', bearerAuth({
  verifyToken: async (token, c) => {
    const isValid = await redis.get(`token:${token}`)
    return isValid === 'true'
  }
}))
```

**Custom Prefix:**
```typescript
// For API keys: "ApiKey your-key"
app.use('/api/*', bearerAuth({
  token: 'your-api-key',
  prefix: 'ApiKey'
}))
```

---

### JWT Auth

JSON Web Token authentication middleware.

**Import:**
```typescript
import { jwt } from 'hono/jwt'
```

**Basic Usage:**
```typescript
app.use('/api/*', jwt({
  secret: 'your-secret-key'
}))

app.get('/api/user', (c) => {
  const payload = c.get('jwtPayload')
  return c.json({ userId: payload.sub })
})
```

**Options:**

```typescript
type JWTOptions = {
  // Secret key for verification (required)
  secret: string

  // Algorithm (optional)
  // Default: "HS256"
  alg?: AlgorithmTypes // "HS256" | "HS384" | "HS512" | "RS256" | "RS384" | "RS512" | etc.

  // Cookie name for JWT (optional)
  // If set, checks cookie instead of Authorization header
  cookie?: string

  // Header name to check (optional)
  // Default: "Authorization"
  headerName?: string

  // JWT verification options (optional)
  verifyOptions?: {
    issuer?: string
    audience?: string
    clockTolerance?: number
    // ... standard JWT verify options
  }
}
```

**Type Definitions:**

```typescript
type JwtVariables = {
  jwtPayload: JWTPayload
}

const app = new Hono<{ Variables: JwtVariables }>()
```

**Using Environment Variables:**
```typescript
// Capture secret from env using closure
app.use('/api/*', async (c, next) => {
  return jwt({
    secret: c.env.JWT_SECRET
  })(c, next)
})
```

**Cookie-based JWT:**
```typescript
app.use('/api/*', jwt({
  secret: 'your-secret',
  cookie: 'jwt_token'
}))
```

**With Verification Options:**
```typescript
app.use('/api/*', jwt({
  secret: 'your-secret',
  verifyOptions: {
    issuer: 'your-app',
    audience: 'your-api',
    clockTolerance: 60 // 60 seconds
  }
}))
```

**Accessing Payload:**
```typescript
app.get('/api/profile', (c) => {
  const payload = c.get('jwtPayload')
  return c.json({
    userId: payload.sub,
    email: payload.email,
    exp: payload.exp
  })
})
```

---

### JWK Auth

JSON Web Key authentication with JWK Sets.

**Import:**
```typescript
import { jwk } from 'hono/jwk'
import { verifyWithJwks } from 'hono/jwk'
```

**Basic Usage:**
```typescript
app.use('/api/*', jwk({
  alg: 'RS256',
  jwks_uri: 'https://example.com/.well-known/jwks.json'
}))
```

**Options:**

```typescript
type JWKOptions = {
  // Algorithm (required)
  alg: AlgorithmTypes

  // JSON Web Key Set as object (optional)
  keys?: JWKSet

  // URL to fetch JWKS (optional)
  jwks_uri?: string

  // Allow anonymous requests (optional)
  // Default: false
  allow_anon?: boolean

  // Cookie name for JWT (optional)
  cookie?: string

  // Header name to check (optional)
  // Default: "Authorization"
  headerName?: string

  // JWT verification options (optional)
  verification?: {
    issuer?: string
    audience?: string
    clockTolerance?: number
  }
}
```

**Using Static Keys:**
```typescript
app.use('/api/*', jwk({
  alg: 'RS256',
  keys: {
    keys: [
      {
        kty: 'RSA',
        use: 'sig',
        kid: 'key-1',
        n: '...',
        e: 'AQAB'
      }
    ]
  }
}))
```

**Using JWKS URI:**
```typescript
app.use('/api/*', jwk({
  alg: 'RS256',
  jwks_uri: 'https://auth.example.com/.well-known/jwks.json'
}))
```

**Allow Anonymous:**
```typescript
app.use('/api/*', jwk({
  alg: 'RS256',
  jwks_uri: 'https://auth.example.com/.well-known/jwks.json',
  allow_anon: true
}))

app.get('/api/data', (c) => {
  const payload = c.get('jwtPayload')
  if (!payload) {
    return c.json({ public: 'data' })
  }
  return c.json({ user: 'data', userId: payload.sub })
})
```

**Utility Function:**
```typescript
import { verifyWithJwks } from 'hono/jwk'

const token = 'eyJhbGc...'
const jwks = await fetch('https://example.com/.well-known/jwks.json').then(r => r.json())

const payload = await verifyWithJwks(token, jwks, {
  issuer: 'your-app',
  audience: 'your-api'
})
```

---

This reference covers Hono middleware concepts, execution order, and authentication middleware including Basic Auth, Bearer Auth, JWT Auth, and JWK Auth.
