# RPC and Validation

Comprehensive guide to Hono's type-safe RPC client and validation features.

## RPC (Type-Safe Client)

Hono's RPC feature provides end-to-end type safety between server and client code, enabling TypeScript to infer request and response types automatically.

### 1. Server Setup

Export your route as a type to enable type inference on the client side. Chain routes together for proper type composition.

```ts
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const app = new Hono()

const route = app.post(
  '/posts',
  zValidator('form', z.object({
    title: z.string(),
    body: z.string()
  })),
  (c) => c.json({ ok: true, message: 'Created!' }, 201)
)

export type AppType = typeof route
```

**Key points:**
- Export `typeof route` as your `AppType`
- Use validators (like `zValidator`) for runtime validation and type inference
- Return typed responses with `c.json(data, statusCode)`

### 2. Client Setup

Import the `hc` (Hono Client) function and create a typed client using your exported `AppType`.

```ts
import { hc } from 'hono/client'
import type { AppType } from './server'

const client = hc<AppType>('http://localhost:8787/')

const res = await client.posts.$post({
  form: {
    title: 'Hi',
    body: 'World'
  }
})

if (res.ok) {
  const data = await res.json()
  console.log(data.message) // TypeScript knows this is a string
}
```

**Key points:**
- Import `hc` from `'hono/client'`
- Pass your `AppType` as a type parameter
- Use `$get`, `$post`, `$put`, `$delete`, etc. for HTTP methods
- Responses are fully typed

### 3. Path Parameters

Use bracket notation to specify dynamic path parameters.

```ts
// Server
const route = app.get('/posts/:id', (c) => {
  const id = c.req.param('id')
  return c.json({ id, title: 'Post Title' })
})

// Client
const res = await client.posts[':id'].$get({
  param: { id: '123' }
})
```

**Key points:**
- Use bracket notation: `client.posts[':id']`
- Pass params in the `param` object
- Parameter names must match the route definition

### 4. Multiple Parameters

Chain multiple bracket notations for routes with multiple parameters.

```ts
// Server
const route = app.get('/posts/:postId/authors/:authorId', (c) => {
  const postId = c.req.param('postId')
  const authorId = c.req.param('authorId')
  return c.json({ postId, authorId })
})

// Client
const res = await client.posts[':postId'][':authorId'].$get({
  param: {
    postId: '123',
    authorId: '456'
  }
})
```

### 5. Query Parameters

Pass query parameters using the `query` object. All query values are strings.

```ts
// Client
const res = await client.posts.$get({
  query: {
    page: '1',
    limit: '10',
    sort: 'desc'
  }
})
```

**Important:** Query parameters are always strings, even for numbers. Convert on the server side as needed.

### 6. Headers

Pass headers as a second argument or configure global headers in `hc()`.

```ts
// Per-request headers
const res = await client.posts.$get(
  {},
  {
    headers: {
      'Authorization': 'Bearer token123'
    }
  }
)

// Global headers
const client = hc<AppType>('http://localhost:8787/', {
  headers: {
    'Authorization': 'Bearer token123'
  }
})
```

### 7. Cookies

Enable cookie support by setting `credentials: 'include'` in the init options.

```ts
const res = await client.posts.$get(
  {},
  {
    init: {
      credentials: 'include'
    }
  }
)

// Or globally
const client = hc<AppType>('http://localhost:8787/', {
  init: {
    credentials: 'include'
  }
})
```

### 8. Init Option

Pass standard `RequestInit` options for advanced configuration like abort signals.

```ts
const controller = new AbortController()

const res = await client.posts.$get(
  {},
  {
    init: {
      signal: controller.signal
    }
  }
)

// Later: controller.abort()
```

**Common RequestInit options:**
- `signal`: AbortSignal for cancellation
- `credentials`: Cookie handling
- `mode`: CORS mode
- `cache`: Cache control

### 9. $url() Method

Get a URL object for the endpoint. Requires an absolute base URL.

```ts
const client = hc<AppType>('http://localhost:8787/')

const url = client.posts[':id'].$url({
  param: { id: '123' },
  query: { format: 'json' }
})

console.log(url.href) // http://localhost:8787/posts/123?format=json
```

**Key points:**
- Returns a URL object, not a string
- Must use an absolute URL as the base
- Useful for generating links without making requests

### 10. Typed URL

Pass the base URL as a second type parameter for stricter type checking.

```ts
const client = hc<AppType, 'http://localhost:8787/'>('http://localhost:8787/')

// TypeScript will enforce the correct base URL
```

### 11. File Uploads

Upload files using the `form` object with `File` instances.

```ts
// Client
const file = new File(['content'], 'example.txt', { type: 'text/plain' })

const res = await client.upload.$post({
  form: {
    file: file,
    description: 'My file'
  }
})

// Server
const route = app.post('/upload', async (c) => {
  const body = await c.req.parseBody()
  const file = body.file as File
  return c.json({
    name: file.name,
    size: file.size
  })
})
```

### 12. Custom Fetch

Provide a custom fetch implementation for specific environments or middleware.

```ts
const customFetch = async (input: RequestInfo, init?: RequestInit) => {
  console.log('Fetching:', input)
  return fetch(input, init)
}

const client = hc<AppType>('http://localhost:8787/', {
  fetch: customFetch
})
```

**Use cases:**
- Logging/debugging
- Request/response transformation
- Testing with mock fetch
- Edge runtime compatibility

### 13. Custom Query Serializer

Override the default query string serialization with `buildSearchParams`.

```ts
const client = hc<AppType>('http://localhost:8787/', {
  buildSearchParams: (params) => {
    // Custom serialization logic
    return new URLSearchParams(params)
  }
})
```

### 14. Status Code Typing

Specify status codes in `c.json()` for typed response unions based on HTTP status.

```ts
// Server
const route = app.get('/posts/:id', (c) => {
  const id = c.req.param('id')

  if (id === 'not-found') {
    return c.json({ error: 'Post not found' }, 404)
  }

  return c.json({ id, title: 'Post Title' }, 200)
})

// Client - Get union of all possible responses
import type { InferResponseType } from 'hono/client'

type ResponseType = InferResponseType<typeof client.posts[':id'].$get>
// ResponseType = { id: string, title: string } | { error: string }

// Get specific status code response
type SuccessResponse = InferResponseType<typeof client.posts[':id'].$get, 200>
// SuccessResponse = { id: string, title: string }

type ErrorResponse = InferResponseType<typeof client.posts[':id'].$get, 404>
// ErrorResponse = { error: string }
```

**Key points:**
- Always specify status codes: `c.json(data, 200)`
- Use `InferResponseType` for type extraction
- Second parameter filters by status code
- Creates discriminated unions for error handling

### 15. Not Found Handling

Don't use `c.notFound()` with RPC as it breaks type inference. Use `c.json()` with 404 status instead.

```ts
// ❌ Bad - breaks RPC typing
app.get('/posts/:id', (c) => {
  return c.notFound() // Type information lost
})

// ✅ Good - maintains type safety
app.get('/posts/:id', (c) => {
  return c.json({ error: 'Not found' }, 404)
})

// Alternative: Augment NotFoundResponse type
declare module 'hono' {
  interface NotFoundResponse {
    error: string
  }
}
```

### 16. InferRequestType / InferResponseType

Utility types for extracting request and response types from your API endpoints.

```ts
import type { InferRequestType, InferResponseType } from 'hono/client'

// Infer request type
type RequestType = InferRequestType<typeof client.posts.$post>
// RequestType = { form: { title: string, body: string } }

// Infer response type
type ResponseType = InferResponseType<typeof client.posts.$post>
// ResponseType = { ok: boolean, message: string }

// Use in functions
async function createPost(data: RequestType['form']) {
  const res = await client.posts.$post({ form: data })
  const json: ResponseType = await res.json()
  return json
}
```

### 17. parseResponse()

Automatically parse responses with enhanced type safety and error handling.

```ts
import { parseResponse } from 'hono/client'

try {
  const res = await client.posts.$get()
  const data = await parseResponse(res)
  // data is fully typed
  console.log(data)
} catch (error) {
  if (error instanceof DetailedError) {
    console.error('Status:', error.status)
    console.error('Body:', error.body)
  }
}
```

**Key points:**
- Automatically handles JSON parsing
- Throws `DetailedError` for non-ok responses
- `DetailedError` includes status code and response body
- Maintains full type safety

### 18. Using with SWR

Integrate with SWR (React Hooks for Data Fetching) using a typed fetcher pattern.

```ts
import useSWR from 'swr'
import type { InferRequestType, InferResponseType } from 'hono/client'
import { hc } from 'hono/client'
import type { AppType } from './server'

const client = hc<AppType>('http://localhost:8787/')

// Define fetcher
const fetcher = async (
  endpoint: typeof client.posts.$get,
  args: InferRequestType<typeof client.posts.$get>
) => {
  const res = await endpoint(args)
  return await res.json()
}

// Use in component
function PostList() {
  const { data, error } = useSWR(
    [client.posts.$get, { query: { page: '1' } }],
    ([endpoint, args]) => fetcher(endpoint, args)
  )

  if (error) return <div>Failed to load</div>
  if (!data) return <div>Loading...</div>

  return <div>{/* render posts */}</div>
}
```

### 19. Using with React Query (TanStack Query)

Integrate with `@tanstack/react-query` for type-safe data fetching and mutations using Hono RPC.

```tsx
import {
  useQuery,
  useMutation,
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query'
import { AppType } from '../functions/api/[[route]]'
import { hc, InferResponseType, InferRequestType } from 'hono/client'

const queryClient = new QueryClient()
const client = hc<AppType>('/api')

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Todos />
    </QueryClientProvider>
  )
}

const Todos = () => {
  // Type-safe query
  const query = useQuery({
    queryKey: ['todos'],
    queryFn: async () => {
      const res = await client.todo.$get()
      return await res.json()
    },
  })

  // Type-safe mutation with InferResponseType/InferRequestType
  const $post = client.todo.$post

  const mutation = useMutation<
    InferResponseType<typeof $post>,
    Error,
    InferRequestType<typeof $post>['form']
  >({
    mutationFn: async (todo) => {
      const res = await $post({ form: todo })
      return await res.json()
    },
    onSuccess: async () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] })
    },
    onError: (error) => {
      console.log(error)
    },
  })

  return (
    <div>
      <button onClick={() => mutation.mutate({ id: Date.now().toString(), title: 'Write code' })}>
        Add Todo
      </button>
      <ul>
        {query.data?.todos.map((todo) => (
          <li key={todo.id}>{todo.title}</li>
        ))}
      </ul>
    </div>
  )
}
```

**Key points:**
- Use `InferResponseType` and `InferRequestType` to extract types from RPC endpoints
- `InferRequestType<typeof $post>['form']` extracts the form data type for mutations
- Invalidate queries on mutation success for automatic refetching

### 20. Larger Applications

Chain multiple sub-routers together and export a combined type for the entire application.

```ts
// routes/posts.ts
const posts = new Hono()
  .get('/', (c) => c.json({ posts: [] }))
  .post('/', (c) => c.json({ created: true }))

// routes/users.ts
const users = new Hono()
  .get('/', (c) => c.json({ users: [] }))
  .post('/', (c) => c.json({ created: true }))

// index.ts
import { posts } from './routes/posts'
import { users } from './routes/users'

const app = new Hono()

const routes = app
  .route('/posts', posts)
  .route('/users', users)

export type AppType = typeof routes

// Client usage
const client = hc<AppType>('http://localhost:8787/')
await client.posts.$get()
await client.users.$get()
```

**Key points:**
- Organize routes into separate modules
- Use `.route()` to mount sub-routers
- Export the combined routes as `AppType`
- Maintains full type inference across all routes

### 21. IDE Performance Issues

If you experience slow IDE performance with RPC, try these solutions:

#### Problem: Hono Version Mismatch
**Solution:** Ensure server and client use the exact same Hono version.

```json
// package.json
{
  "dependencies": {
    "hono": "^4.0.0" // Same version everywhere
  }
}
```

#### Problem: TypeScript Project References
**Solution:** Use TypeScript project references to separate server and client builds.

```json
// tsconfig.json
{
  "references": [
    { "path": "./server" },
    { "path": "./client" }
  ]
}
```

#### Problem: Large Combined Types (Recommended Fix)
**Solution:** Pre-compile types using the `hcWithType` wrapper pattern. This lets `tsc` do heavy type instantiation at compile time so `tsserver` doesn't repeat it on every keystroke.

```ts
// client.ts - define once, compile with tsc
import { app } from './app'
import { hc } from 'hono/client'

// This trick calculates the type at compile time
export type Client = ReturnType<typeof hc<typeof app>>

export const hcWithType = (...args: Parameters<typeof hc>): Client =>
  hc<typeof app>(...args)
```

```ts
// usage.ts - use the pre-compiled client
import { hcWithType } from './client'

const client = hcWithType('http://localhost:8787/')
const res = await client.posts.$post({
  form: { title: 'Hello', body: 'World' },
})
```

This works especially well in monorepos with tools like `turborepo` to separate server and client builds.

#### Problem: Complex Inference
**Solution:** Manually specify type arguments.

```ts
// Instead of letting TypeScript infer everything
const res = await client.posts.$get()

// Specify types explicitly
const res: Response = await client.posts.$get()
const data: PostType = await res.json()
```

#### Problem: Monolithic Client
**Solution:** Split into multiple smaller clients.

```ts
// Instead of one huge client
const client = hc<AppType>('http://localhost:8787/')

// Create focused clients
const postsClient = hc<PostsType>('http://localhost:8787/posts')
const usersClient = hc<UsersType>('http://localhost:8787/users')
```

## Validation

Hono provides flexible validation through manual validators and integration with popular validation libraries.

### 1. Manual Validator

Use the built-in `validator` middleware for custom validation logic.

```ts
import { validator } from 'hono/validator'

// Basic usage
app.post(
  '/posts',
  validator('json', (value, c) => {
    const parsed = {
      title: value.title,
      body: value.body
    }

    if (!parsed.title || typeof parsed.title !== 'string') {
      return c.json({ error: 'Invalid title' }, 400)
    }

    return parsed
  }),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ success: true, data })
  }
)
```

**Available targets:**
- `'json'` - Request body as JSON
- `'form'` - Form data (multipart/form-data or application/x-www-form-urlencoded)
- `'query'` - Query string parameters
- `'header'` - Request headers
- `'param'` - Path parameters
- `'cookie'` - Cookies

**Important notes:**
- `json` requires `Content-Type: application/json` header
- `form` requires `Content-Type: multipart/form-data` or `application/x-www-form-urlencoded`
- `header` validation uses lowercase keys (e.g., `'content-type'`, not `'Content-Type'`)
- Return validated data for success
- Return a `Response` object for validation errors
- Access validated data with `c.req.valid(target)`

**Header validation example:**

```ts
app.get(
  '/api/data',
  validator('header', (value, c) => {
    const authHeader = value['authorization'] // Note: lowercase

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return c.json({ error: 'Unauthorized' }, 401)
    }

    return { token: authHeader.slice(7) }
  }),
  (c) => {
    const { token } = c.req.valid('header')
    return c.json({ data: 'secure data', token })
  }
)
```

### 2. Multiple Validators

Chain multiple `validator()` calls to validate different parts of the request.

```ts
app.post(
  '/posts/:id/comments',
  validator('param', (value, c) => {
    const id = parseInt(value.id)
    if (isNaN(id)) {
      return c.json({ error: 'Invalid post ID' }, 400)
    }
    return { id }
  }),
  validator('json', (value, c) => {
    if (!value.comment || typeof value.comment !== 'string') {
      return c.json({ error: 'Invalid comment' }, 400)
    }
    return { comment: value.comment }
  }),
  validator('header', (value, c) => {
    const auth = value['authorization']
    if (!auth) {
      return c.json({ error: 'Unauthorized' }, 401)
    }
    return { auth }
  }),
  (c) => {
    const { id } = c.req.valid('param')
    const { comment } = c.req.valid('json')
    const { auth } = c.req.valid('header')

    return c.json({
      postId: id,
      comment,
      authorized: true
    })
  }
)
```

### 3. Zod Validator

Official Zod integration for schema-based validation with excellent TypeScript support.

**Installation:**

```bash
npm i @hono/zod-validator zod
```

**Basic usage:**

```ts
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const postSchema = z.object({
  title: z.string().min(1).max(100),
  body: z.string().min(1),
  published: z.boolean().default(false),
  tags: z.array(z.string()).optional()
})

app.post(
  '/posts',
  zValidator('json', postSchema),
  (c) => {
    const data = c.req.valid('json')
    // data is fully typed: { title: string, body: string, published: boolean, tags?: string[] }
    return c.json({ created: true, post: data })
  }
)
```

**With custom error handling (hook):**

```ts
app.post(
  '/posts',
  zValidator('json', postSchema, (result, c) => {
    if (!result.success) {
      return c.json({
        error: 'Validation failed',
        details: result.error.flatten()
      }, 400)
    }
  }),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

**Multiple targets:**

```ts
app.post(
  '/posts/:id/comments',
  zValidator('param', z.object({
    id: z.string().regex(/^\d+$/).transform(Number)
  })),
  zValidator('json', z.object({
    comment: z.string().min(1).max(500)
  })),
  (c) => {
    const { id } = c.req.valid('param')
    const { comment } = c.req.valid('json')

    return c.json({ postId: id, comment })
  }
)
```

### 4. Standard Schema Validator

Works with any validation library that implements the Standard Schema specification.

**Installation:**

```bash
npm i @hono/standard-validator
```

**With Zod:**

```ts
import { sValidator } from '@hono/standard-validator'
import { z } from 'zod'

app.post(
  '/posts',
  sValidator('json', z.object({
    title: z.string(),
    body: z.string()
  })),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

**With Valibot:**

```ts
import * as v from 'valibot'
import { sValidator } from '@hono/standard-validator'

app.post(
  '/posts',
  sValidator('json', v.object({
    title: v.string(),
    body: v.string()
  })),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

**With ArkType:**

```ts
import { type } from 'arktype'
import { sValidator } from '@hono/standard-validator'

const postSchema = type({
  title: 'string',
  body: 'string',
  published: 'boolean'
})

app.post(
  '/posts',
  sValidator('json', postSchema),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

### 5. Third-Party Validators

Hono supports a wide range of validation libraries through official and community packages:

#### Available Validators:

1. **Ajv** - JSON Schema validator
   - Package: `@hono/ajv-validator`
   - High performance, JSON Schema standard

2. **ArkType** - TypeScript-first validation
   - Package: `@hono/arktype-validator`
   - Runtime type validation with excellent DX

3. **Class Validator** - Decorator-based validation
   - Package: `@hono/class-validator`
   - Popular in NestJS ecosystem

4. **Conform** - Form validation for React
   - Package: `@hono/conform-validator`
   - Progressive enhancement support

5. **Effect Schema** - Functional validation
   - Package: `@hono/effect-validator`
   - Part of the Effect ecosystem

6. **TypeBox** - JSON Schema Type Builder
   - Package: `@hono/typebox-validator`
   - Fast and lightweight

7. **Typia** - Super-fast validation
   - Package: `@hono/typia-validator`
   - Compile-time validation generation

8. **unknownutil** - Unknown type utilities
   - Package: `@hono/unknownutil-validator`
   - Minimalist validation

9. **Valibot** - Modern schema validation
   - Package: `@hono/valibot-validator`
   - Small bundle size, great performance

10. **Zod** - TypeScript-first schemas
    - Package: `@hono/zod-validator`
    - Most popular, excellent TypeScript support

**Example with TypeBox:**

```ts
import { Type } from '@sinclair/typebox'
import { tbValidator } from '@hono/typebox-validator'

const PostSchema = Type.Object({
  title: Type.String({ minLength: 1, maxLength: 100 }),
  body: Type.String({ minLength: 1 }),
  published: Type.Boolean({ default: false })
})

app.post(
  '/posts',
  tbValidator('json', PostSchema),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

**Example with Valibot:**

```ts
import * as v from 'valibot'
import { vValidator } from '@hono/valibot-validator'

const PostSchema = v.object({
  title: v.pipe(v.string(), v.minLength(1), v.maxLength(100)),
  body: v.pipe(v.string(), v.minLength(1)),
  published: v.optional(v.boolean(), false)
})

app.post(
  '/posts',
  vValidator('json', PostSchema),
  (c) => {
    const data = c.req.valid('json')
    return c.json({ created: true, post: data })
  }
)
```

## Best Practices

### RPC Best Practices

1. **Always specify status codes** - Use `c.json(data, 200)` instead of `c.json(data)`
2. **Use descriptive error responses** - Return typed error objects instead of `c.notFound()`
3. **Organize large applications** - Split routes into modules and use `.route()` to compose
4. **Version your API types** - Export versioned types when making breaking changes
5. **Handle errors consistently** - Use `InferResponseType` unions for error handling
6. **Use absolute URLs** - Required for `$url()` method to work correctly

### Validation Best Practices

1. **Choose the right validator** - Use Zod for most cases, consider alternatives for specific needs
2. **Validate all inputs** - Never trust client data, validate params, query, body, headers
3. **Use schema composition** - Build reusable schemas for common patterns
4. **Provide clear error messages** - Use custom hooks for user-friendly validation errors
5. **Transform data** - Use validators to transform types (e.g., string to number)
6. **Remember Content-Type requirements** - Ensure correct headers for json/form validation

### Performance Considerations

1. **Use Standard Schema** - If you need library flexibility without lock-in
2. **Consider Typia** - For maximum validation performance with compile-time generation
3. **Avoid over-validation** - Only validate what you need to use
4. **Cache validator instances** - Reuse schema objects across requests
5. **Split large clients** - Break monolithic RPC clients into focused modules
