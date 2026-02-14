# oRPC OpenAPI Reference

Complete reference for oRPC's OpenAPI integration, including RESTful routing, specification generation, and HTTP handlers.

## Installation

```bash
npm install @orpc/server@latest @orpc/client@latest @orpc/openapi@latest
```

Required peer dependencies:
- `@orpc/contract` - Contract definitions
- Schema library: `zod`, `valibot`, or `arktype`

## Quick Start

### Define OpenAPI Routes

```ts
import { ORPCError, os } from '@orpc/server'
import * as z from 'zod'

const PlanetSchema = z.object({
  id: z.number().int().min(1),
  name: z.string(),
  description: z.string().optional(),
})

// GET /planets - List planets with pagination
const listPlanet = os
  .route({ method: 'GET', path: '/planets' })
  .input(z.object({
    limit: z.number().int().min(1).max(100).optional(),
    cursor: z.number().int().min(0).default(0),
  }))
  .output(z.array(PlanetSchema))
  .handler(async ({ input }) => {
    // Query params: ?limit=10&cursor=0
    return [{ id: 1, name: 'Earth' }]
  })

// GET /planets/{id} - Find planet by ID
const findPlanet = os
  .route({ method: 'GET', path: '/planets/{id}' })
  .input(z.object({ id: z.coerce.number().int().min(1) }))
  .output(PlanetSchema)
  .handler(async ({ input }) => {
    // Path param: /planets/1
    return { id: 1, name: 'Earth' }
  })

// POST /planets - Create new planet
const createPlanet = os
  .route({ method: 'POST', path: '/planets' })
  .input(PlanetSchema.omit({ id: true }))
  .output(PlanetSchema)
  .handler(async ({ input }) => {
    // Request body: { "name": "Mars", "description": "..." }
    return { id: 1, ...input }
  })

// PUT /planets/{id} - Update planet
const updatePlanet = os
  .route({ method: 'PUT', path: '/planets/{id}' })
  .input(PlanetSchema)
  .output(PlanetSchema)
  .handler(async ({ input }) => {
    return input
  })

// DELETE /planets/{id} - Delete planet
const deletePlanet = os
  .route({ method: 'DELETE', path: '/planets/{id}' })
  .input(z.object({ id: z.coerce.number().int().min(1) }))
  .output(z.object({ success: z.boolean() }))
  .handler(async ({ input }) => {
    return { success: true }
  })
```

Key differences from RPC:
- `.route()` defines HTTP method and path
- `.output()` enables OpenAPI spec generation
- `z.coerce` ensures correct parameter parsing from URL strings

### Create Router

```ts
import { os } from '@orpc/server'

const router = os.router({
  planet: {
    list: listPlanet,
    find: findPlanet,
    create: createPlanet,
    update: updatePlanet,
    delete: deletePlanet,
  },
})

export type Router = typeof router
```

### Create HTTP Server

```ts
import { createServer } from 'node:http'
import { OpenAPIHandler } from '@orpc/openapi/node'
import { CORSPlugin } from '@orpc/server/plugins'
import { onError } from '@orpc/server'

const handler = new OpenAPIHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

const server = createServer(async (req, res) => {
  const { matched } = await handler.handle(req, res, {
    prefix: '/api',
    context: { headers: req.headers },
  })

  if (!matched) {
    res.statusCode = 404
    res.end('Not found')
  }
})

server.listen(3000, () => {
  console.log('Server listening on http://localhost:3000')
})
```

### Generate OpenAPI Specification

```ts
import { OpenAPIGenerator } from '@orpc/openapi'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4' // or @orpc/zod for v3

const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
})

const spec = await generator.generate(router, {
  info: {
    title: 'Planet API',
    version: '1.0.0',
    description: 'API for managing planets',
  },
  servers: [
    { url: 'https://api.example.com/v1' },
    { url: 'http://localhost:3000/api' },
  ],
})

// Save or serve the spec
console.log(JSON.stringify(spec, null, 2))
```

Supported schema libraries:
- **Zod v3**: `@orpc/zod`
- **Zod v4**: `@orpc/zod/zod4`
- **Valibot** (experimental): `@orpc/valibot`
- **ArkType** (experimental): `@orpc/arktype`

## OpenAPI Handler

Handles HTTP requests and routes them to oRPC procedures.

### Packages

- `@orpc/openapi/fetch` - Fetch API (Cloudflare Workers, Deno, Bun)
- `@orpc/openapi/node` - Node.js IncomingMessage/ServerResponse

### Basic Usage

```ts
import { OpenAPIHandler } from '@orpc/openapi/fetch'

const handler = new OpenAPIHandler(router, {
  plugins: [new CORSPlugin()],
  interceptors: [onError((error) => console.error(error))],
})

// Fetch API
const response = await handler.handle(request, {
  prefix: '/api',
  context: { user: getCurrentUser() },
})

if (response.matched) {
  return response.response
}

// Node.js
import { OpenAPIHandler } from '@orpc/openapi/node'

const handler = new OpenAPIHandler(router)

await handler.handle(req, res, {
  prefix: '/api',
  context: { headers: req.headers },
})
```

### Constructor Options

```ts
interface OpenAPIHandlerOptions {
  // Filter which procedures to expose
  filter?: (info: {
    contract: ContractProcedure
    path: string[]
  }) => boolean

  // Plugins to apply
  plugins?: PluginList

  // Interceptors to apply
  interceptors?: InterceptorList

  // Custom JSON serializers
  customJsonSerializers?: StandardOpenAPICustomJsonSerializer[]

  // Custom error response encoder
  customErrorResponseBodyEncoder?: (error: ORPCError) => unknown
}
```

### Handle Method Options

```ts
interface HandleOptions {
  // URL prefix (e.g., '/api')
  prefix?: string

  // Context for procedures
  context?: Context
}
```

### Filtering Procedures

Hide internal procedures from OpenAPI:

```ts
const handler = new OpenAPIHandler(router, {
  filter: ({ contract, path }) => {
    const tags = contract['~orpc'].route?.tags
    return !tags?.includes('internal')
  },
})
```

### Supported Data Types

The handler automatically serializes and deserializes:

- **Primitives**: `string`, `number`, `boolean`, `null`, `undefined`
- **Dates**: `Date` (Invalid Date → null)
- **BigInt**: Converted to string
- **RegExp**: Converted to string
- **URL**: Converted to string
- **Collections**: `Record`, `Array`, `Set` (→ array), `Map` (→ array)
- **Binary**: `Blob`, `File`
- **Streaming**: `AsyncIteratorObject` (root level only)

### Platform-Specific Examples

#### Cloudflare Workers

```ts
import { OpenAPIHandler } from '@orpc/openapi/fetch'

const handler = new OpenAPIHandler(router)

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext) {
    const { matched, response } = await handler.handle(request, {
      prefix: '/api',
      context: { env, ctx },
    })

    if (matched) return response
    return new Response('Not found', { status: 404 })
  },
}
```

#### Bun

```ts
import { OpenAPIHandler } from '@orpc/openapi/fetch'

const handler = new OpenAPIHandler(router)

Bun.serve({
  port: 3000,
  async fetch(request) {
    const { matched, response } = await handler.handle(request, {
      prefix: '/api',
    })

    if (matched) return response
    return new Response('Not found', { status: 404 })
  },
})
```

#### Express

```ts
import express from 'express'
import { OpenAPIHandler } from '@orpc/openapi/node'

const app = express()
const handler = new OpenAPIHandler(router)

app.use('/api', async (req, res, next) => {
  const { matched } = await handler.handle(req, res, {
    context: { user: req.user },
  })

  if (!matched) next()
})

app.listen(3000)
```

## Routing

Define RESTful routes for procedures.

### Basic Routing

```ts
// GET request
os.route({ method: 'GET', path: '/example' })

// POST request with 201 status
os.route({ method: 'POST', path: '/example', successStatus: 201 })

// PUT request
os.route({ method: 'PUT', path: '/example/{id}' })

// DELETE request
os.route({ method: 'DELETE', path: '/example/{id}' })

// PATCH request
os.route({ method: 'PATCH', path: '/example/{id}' })
```

Supported methods: `GET`, `POST`, `PUT`, `DELETE`, `PATCH`, `HEAD`, `OPTIONS`

### Path Parameters

Use curly braces for path parameters:

```ts
// Simple parameter
os.route({ path: '/users/{id}' })
  .input(z.object({ id: z.string() }))

// Multiple parameters
os.route({ path: '/users/{userId}/posts/{postId}' })
  .input(z.object({
    userId: z.string(),
    postId: z.string(),
  }))

// Greedy parameter (matches slashes)
os.route({ path: '/files/{+path}' })
  .input(z.object({ path: z.string() }))
```

Example:
- `/files/{+path}` matches `/files/folder/subfolder/file.txt`
- `path` will be `"folder/subfolder/file.txt"`

### Route Prefixes

Group related routes under a prefix:

```ts
const planetRouter = os.prefix('/planets').router({
  list: os.route({ method: 'GET', path: '/' }),
  find: os.route({ method: 'GET', path: '/{id}' }),
  create: os.route({ method: 'POST', path: '/' }),
})

// Results in:
// GET  /planets/
// GET  /planets/{id}
// POST /planets/
```

Nested prefixes:

```ts
const apiRouter = os.prefix('/api').router({
  v1: os.prefix('/v1').router({
    planets: os.prefix('/planets').router({
      list: os.route({ method: 'GET', path: '/' }),
    }),
  }),
})

// Results in:
// GET /api/v1/planets/
```

### Tags

Append tags to all procedures in a router:

```ts
const router = os.tag('planets').router({
  list: listPlanet,
  find: findPlanet,
})
```

**Note**: `.route()` can be called multiple times. Each call spread-merges the new route config with existing config.

**Warning**: `.prefix()` only applies to procedures that specify a `path` in their `.route()`.

### Lazy Loading with Prefix

```ts
const router = {
  planet: os.prefix('/planets').lazy(() => import('./routes/planet')),
  user: os.prefix('/users').lazy(() => import('./routes/user')),
}
```

**Warning**: When combining a Lazy Router with `OpenAPIHandler`, a prefix is required for lazy loading. Without it, the router behaves like a regular router. Use `os.prefix('/...').lazy(...)` — do NOT use the standalone `lazy()` helper from `@orpc/server`, as it cannot apply route prefixes. This restriction does not apply if following the contract-first approach.

### Initial Route Configuration

Set default route config for all procedures:

```ts
const base = os.$route({ method: 'GET' })

const router = base.router({
  list: base.route({ path: '/items' }), // Inherits GET method
  find: base.route({ path: '/items/{id}' }), // Inherits GET method
})
```

## Input/Output Structure

Control how input parameters and output responses are structured.

### Input Structure Modes

#### Compact Mode (Default)

Input fields are automatically distributed:
- **Path parameters**: Extracted from URL path
- **GET method**: Remaining fields in query string
- **Other methods**: Remaining fields in request body

```ts
const example = os
  .route({ path: '/posts/{id}', method: 'POST' })
  .input(z.object({
    id: z.coerce.number(), // From path
    title: z.string(), // From body
    content: z.string(), // From body
  }))
  .handler(({ input }) => {
    // input.id from path: /posts/123
    // input.title and input.content from body
    return { id: input.id, ...input }
  })
```

#### Detailed Mode

Explicit control over parameter sources:

```ts
const example = os
  .route({
    path: '/posts/{id}',
    method: 'POST',
    inputStructure: 'detailed',
  })
  .input(z.object({
    params: z.object({ id: z.coerce.number() }),
    query: z.object({ draft: z.string().optional() }),
    body: z.object({
      title: z.string(),
      content: z.string(),
    }),
    headers: z.object({
      'x-api-key': z.string(),
    }),
  }))
  .handler(({ input }) => {
    // input.params.id from path
    // input.query.draft from query string
    // input.body.title and input.body.content from body
    // input.headers['x-api-key'] from headers
    return { id: input.params.id, ...input.body }
  })
```

Detailed mode fields:
- `params`: Path parameters
- `query`: Query string parameters
- `body`: Request body
- `headers`: Request headers

### Output Structure Modes

#### Compact Mode (Default)

Handler return value becomes the response body:

```ts
const example = os
  .route({ path: '/hello' })
  .output(z.object({ message: z.string() }))
  .handler(() => {
    return { message: 'Hello, world!' } // Direct response body
  })
```

#### Detailed Mode

Control response headers and status codes:

```ts
const example = os
  .route({
    path: '/hello',
    outputStructure: 'detailed',
  })
  .output(z.object({
    headers: z.record(z.string()).optional(),
    body: z.object({ message: z.string() }),
  }))
  .handler(() => {
    return {
      headers: {
        'x-custom-header': 'value',
        'cache-control': 'max-age=3600',
      },
      body: { message: 'Hello, world!' },
    }
  })
```

#### Multiple Status Codes

Return different status codes based on logic:

```ts
const createOrUpdate = os
  .route({
    path: '/items/{id}',
    method: 'PUT',
    outputStructure: 'detailed',
  })
  .output(z.union([
    z.object({
      status: z.literal(201).describe('Item created'),
      body: z.object({ id: z.number(), message: z.string() }),
    }),
    z.object({
      status: z.literal(200).describe('Item updated'),
      body: z.object({ id: z.number(), message: z.string() }),
    }),
  ]))
  .handler(async ({ input }) => {
    const exists = await checkExists(input.id)

    if (!exists) {
      return {
        status: 201,
        body: { id: input.id, message: 'Created' },
      }
    }

    return {
      status: 200,
      body: { id: input.id, message: 'Updated' },
    }
  })
```

### Advanced Input Examples

#### File Upload

```ts
// Zod v4
import * as z from 'zod'

const uploadFile = os
  .route({ path: '/upload', method: 'POST' })
  .input(z.object({
    file: z.file(),
    description: z.string().optional(),
  }))
  .handler(async ({ input }) => {
    // input.file is a File object
    return { filename: input.file.name, size: input.file.size }
  })

// Zod v3
import { oz } from '@orpc/zod'
import * as z from 'zod'

const uploadFile = os
  .route({ path: '/upload', method: 'POST' })
  .input(z.object({
    file: oz.file().type('image/*'),
    description: z.string().optional(),
  }))
  .handler(async ({ input }) => {
    return { filename: input.file.name, size: input.file.size }
  })
```

#### Optional Request Body

```ts
const example = os
  .route({
    path: '/search',
    method: 'POST',
    inputStructure: 'detailed',
  })
  .input(z.object({
    query: z.object({ q: z.string() }),
    body: z.object({ filters: z.record(z.string()) }).optional(),
  }))
  .handler(({ input }) => {
    // Body is optional
    return { query: input.query.q, filters: input.body?.filters }
  })
```

### Advanced Output Examples

#### Redirect Response

```ts
const redirect = os
  .route({
    method: 'GET',
    path: '/redirect',
    successStatus: 307,
    outputStructure: 'detailed',
  })
  .handler(() => {
    return {
      headers: { location: 'https://orpc.dev' },
    }
  })
```

**Warning**: When invoking a redirect procedure with `OpenAPILink`, oRPC treats the redirect as a normal response rather than following it. Browser environments may restrict access to the redirect response, potentially causing errors. Server environments like Node.js handle this without issue.

#### Download Response

```ts
const download = os
  .route({ path: '/download/{id}' })
  .output(z.instanceof(Blob))
  .handler(async ({ input }) => {
    const file = await getFile(input.id)
    return new Blob([file.content], { type: file.mimeType })
  })
```

#### Streaming Response

```ts
const stream = os
  .route({ path: '/stream' })
  .output(z.custom<AsyncIterableIterator<string>>())
  .handler(async function* () {
    yield 'Line 1\n'
    await new Promise(resolve => setTimeout(resolve, 1000))
    yield 'Line 2\n'
    await new Promise(resolve => setTimeout(resolve, 1000))
    yield 'Line 3\n'
  })
```

## OpenAPI Specification Generation

Generate OpenAPI 3.0/3.1 specifications from your router.

### Basic Generation

```ts
import { OpenAPIGenerator } from '@orpc/openapi'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
})

const spec = await generator.generate(router, {
  info: {
    title: 'My API',
    version: '1.0.0',
    description: 'API description',
    contact: {
      name: 'API Support',
      email: 'support@example.com',
      url: 'https://example.com/support',
    },
    license: {
      name: 'MIT',
      url: 'https://opensource.org/licenses/MIT',
    },
  },
  servers: [
    { url: 'https://api.example.com/v1', description: 'Production' },
    { url: 'http://localhost:3000/api', description: 'Development' },
  ],
  openapi: '3.1.0', // or '3.0.0'
})
```

### Schema Converters

Different converters for different schema libraries:

```ts
// Zod v4
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'
const converter = new ZodToJsonSchemaConverter()

// Zod v3
import { ZodToJsonSchemaConverter } from '@orpc/zod'
const converter = new ZodToJsonSchemaConverter()

// Valibot (experimental)
import { ValibotToJsonSchemaConverter } from '@orpc/valibot'
const converter = new ValibotToJsonSchemaConverter()

// ArkType (experimental)
import { ArkTypeToJsonSchemaConverter } from '@orpc/arktype'
const converter = new ArkTypeToJsonSchemaConverter()

const generator = new OpenAPIGenerator({
  schemaConverters: [converter],
})
```

### Custom Schema Converter

Create a custom converter for any schema library implementing `ConditionalSchemaConverter`:

```ts
import type { ConditionalSchemaConverter } from '@orpc/openapi'

class CustomConverter implements ConditionalSchemaConverter {
  condition(schema: unknown): boolean {
    return schema['~standard']?.vendor === 'my-library'
  }
  convert(schema: unknown, options: unknown): [boolean, object] {
    return [true, { type: 'string' }] // [required, jsonSchema]
  }
}
```

### JSON Schema Customization

#### Zod v4

`description` and `examples` metadata are supported out of the box via `.meta()`:

```ts
const InputSchema = z.object({
  name: z.string(),
}).meta({
  description: 'User schema',
  examples: [{ name: 'John' }],
})
```

For further customization, use `JSON_SCHEMA_REGISTRY`, `JSON_SCHEMA_INPUT_REGISTRY`, and `JSON_SCHEMA_OUTPUT_REGISTRY`:

```ts
import { JSON_SCHEMA_REGISTRY, JSON_SCHEMA_INPUT_REGISTRY, JSON_SCHEMA_OUTPUT_REGISTRY } from '@orpc/zod/zod4'

JSON_SCHEMA_REGISTRY.add(InputSchema, {
  description: 'User schema',
  examples: [{ name: 'John' }],
})

JSON_SCHEMA_INPUT_REGISTRY.add(InputSchema, {
  // only for .input
})

JSON_SCHEMA_OUTPUT_REGISTRY.add(InputSchema, {
  // only for .output
})
```

#### Zod v3

Use `oz.file()` for file schemas (instead of `z.instanceof`) and `oz.openapi()` for JSON Schema customization:

```ts
import { oz } from '@orpc/zod'

// File schema
const InputSchema = z.object({
  file: oz.file(),
  image: oz.file().type('image/*'),
})

// JSON Schema customization
const Schema = oz.openapi(
  z.object({ name: z.string() }),
  {
    examples: [{ name: 'Earth' }],
  }
)
```

### Common Schemas

Define reusable schemas in the specification:

```ts
const UserSchema = z.object({
  id: z.number(),
  name: z.string(),
  email: z.string().email(),
})

const PetSchema = z.object({
  id: z.number(),
  name: z.string(),
  species: z.string(),
})

const spec = await generator.generate(router, {
  info: { title: 'My API', version: '1.0.0' },
  commonSchemas: {
    // Basic schema
    User: { schema: UserSchema },

    // Input-specific schema
    CreateUserInput: { strategy: 'input', schema: UserSchema.omit({ id: true }) },

    // Output-specific schema
    UserOutput: { strategy: 'output', schema: UserSchema },

    // Both input and output
    Pet: { strategy: 'both', schema: PetSchema },

    // Error schema
    UndefinedError: { error: 'UNDEFINED_ERROR' },
  },
})

// Results in:
// components:
//   schemas:
//     User: { ... }
//     CreateUserInput: { ... }
//     UserOutput: { ... }
//     Pet: { ... }
//     UndefinedError: { ... }
```

**Notes**:
- `strategy` option defaults to `'input'` when input and output types differ
- Use `UndefinedError` for type-safe error handling in the spec
- Features prefixed with `experimental_` are unstable and may lack some functionality

### Operation Metadata

Add metadata to individual operations:

```ts
const getPlanet = os
  .route({
    method: 'GET',
    path: '/planets/{id}',
    operationId: 'getPlanetById',
    summary: 'Get a planet by ID',
    description: 'Returns a single planet identified by its ID',
    deprecated: false,
    tags: ['planets', 'public'],
    successDescription: 'Successfully retrieved planet',
  })
  .input(z.object({ id: z.coerce.number() }))
  .output(PlanetSchema)
  .handler(({ input }) => ({ id: input.id, name: 'Earth' }))
```

### oo.spec Helper

Attach OpenAPI operation metadata to errors and middleware:

```ts
import { oo } from '@orpc/openapi'

// Attach security spec to errors
const base = os.errors({
  UNAUTHORIZED: oo.spec(
    { data: z.any() },
    { security: [{ 'api-key': [] }] }
  ),
})

// Attach security spec to middleware
const requireAuth = oo.spec(
  os.middleware(async ({ next, errors }) => {
    // auth logic
    return next()
  }),
  { security: [{ 'api-key': [] }] }
)
```

**Pattern**: Use `oo.spec(target, openAPIOperationSpec)` to attach OpenAPI metadata to any middleware or error definition.

### Customizing Operation Objects

Advanced customization of OpenAPI operation objects:

```ts
const secureEndpoint = os
  .route({
    path: '/secure',
    spec: (spec) => ({
      ...spec,
      security: [{ bearerAuth: [] }],
      responses: {
        ...spec.responses,
        '401': {
          description: 'Unauthorized',
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  error: { type: 'string' },
                },
              },
            },
          },
        },
      },
    }),
  })
  .handler(() => 'Secure data')
```

### Security Schemes

Define security schemes in the specification:

```ts
const spec = await generator.generate(router, {
  info: { title: 'My API', version: '1.0.0' },
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
      apiKey: {
        type: 'apiKey',
        in: 'header',
        name: 'X-API-Key',
      },
      oauth2: {
        type: 'oauth2',
        flows: {
          authorizationCode: {
            authorizationUrl: 'https://example.com/oauth/authorize',
            tokenUrl: 'https://example.com/oauth/token',
            scopes: {
              read: 'Read access',
              write: 'Write access',
            },
          },
        },
      },
    },
  },
})
```

### Filtering Procedures

Hide specific procedures from the OpenAPI spec:

```ts
const spec = await generator.generate(router, {
  info: { title: 'My API', version: '1.0.0' },
  filter: ({ contract, path }) => {
    // Hide internal procedures
    const tags = contract['~orpc'].route?.tags
    if (tags?.includes('internal')) return false

    // Hide deprecated procedures
    if (contract['~orpc'].route?.deprecated) return false

    return true
  },
})
```

### File Upload Schemas

#### Zod v4

```ts
import * as z from 'zod'

const uploadSchema = z.object({
  file: z.file(),
  image: z.file().mime(['image/png', 'image/jpeg']),
  document: z.file().size({ max: 10 * 1024 * 1024 }), // 10MB
})
```

#### Zod v3

```ts
import { oz } from '@orpc/zod'
import * as z from 'zod'

const uploadSchema = z.object({
  file: oz.file(),
  image: oz.file().type('image/*'),
  document: oz.file().maxSize(10 * 1024 * 1024), // 10MB
  blob: oz.blob(),
})
```

### Custom JSON Serializers

Extend or override default JSON serialization:

```ts
import type { StandardOpenAPICustomJsonSerializer } from '@orpc/openapi-client/standard'

class User {
  constructor(public id: number, public name: string) {}
  toJSON() {
    return { id: this.id, name: this.name }
  }
}

const userSerializer: StandardOpenAPICustomJsonSerializer = {
  condition: (data) => data instanceof User,
  serialize: (data) => data.toJSON(),
}

const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
  customJsonSerializers: [userSerializer],
})
```

## Error Handling

Define and handle errors with proper HTTP status codes.

### Default Error Mappings

oRPC maps error codes to HTTP status codes:

| Error Code | HTTP Status | Description |
|-----------|------------|-------------|
| `BAD_REQUEST` | 400 | Invalid request |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Permission denied |
| `NOT_FOUND` | 404 | Resource not found |
| `TIMEOUT` | 408 | Request timeout |
| `CONFLICT` | 409 | Resource conflict |
| `PRECONDITION_FAILED` | 412 | Precondition failed |
| `PAYLOAD_TOO_LARGE` | 413 | Payload too large |
| `UNSUPPORTED_MEDIA_TYPE` | 415 | Unsupported media type |
| `UNPROCESSABLE_CONTENT` | 422 | Validation failed |
| `TOO_MANY_REQUESTS` | 429 | Rate limit exceeded |
| `METHOD_NOT_ALLOWED` | 405 | Method not allowed |
| `NOT_ACCEPTABLE` | 406 | Not acceptable |
| `CLIENT_CLOSED_REQUEST` | 499 | Client closed request |
| `INTERNAL_SERVER_ERROR` | 500 | Internal server error |
| `NOT_IMPLEMENTED` | 501 | Not implemented |
| `BAD_GATEWAY` | 502 | Bad gateway |
| `SERVICE_UNAVAILABLE` | 503 | Service unavailable |
| `GATEWAY_TIMEOUT` | 504 | Gateway timeout |

Any error not defined above defaults to HTTP status `500` with the error code used as the message.

### Throwing Errors

```ts
import { ORPCError } from '@orpc/server'

const findUser = os
  .route({ path: '/users/{id}' })
  .handler(async ({ input }) => {
    const user = await db.users.find(input.id)

    if (!user) {
      throw new ORPCError('NOT_FOUND', { message: 'User not found' })
    }

    return user
  })
```

### Custom Error Definitions

Define custom error codes with specific status codes:

```ts
const procedure = os
  .errors({
    CUSTOM_ERROR: {
      status: 503,
      message: 'Custom error message',
    },
    RATE_LIMITED: {
      status: 429,
      message: 'Too many requests',
    },
  })
  .handler(() => {
    throw new ORPCError('CUSTOM_ERROR', { message: 'Service temporarily unavailable' })
  })
```

### Override Error Status

Override status code when throwing:

```ts
const procedure = os
  .errors({
    RANDOM_ERROR: { status: 503 },
  })
  .handler(() => {
    throw new ORPCError('RANDOM_ERROR', {
      status: 502,
      message: 'Custom message',
      data: { additional: 'info' },
    })
  })
```

### Custom Error Response Body

#### Handler Side

```ts
const handler = new OpenAPIHandler(router, {
  customErrorResponseBodyEncoder(error) {
    return {
      error: {
        code: error.code,
        message: error.message,
        status: error.status,
        data: error.data,
      },
      timestamp: new Date().toISOString(),
    }
  },
})
```

#### Generator Side

```ts
const spec = await generator.generate(router, {
  customErrorResponseBodySchema: (definedErrorDefinitions, status) => ({
    type: 'object',
    properties: {
      error: {
        type: 'object',
        properties: {
          code: { type: 'string' },
          message: { type: 'string' },
          status: { type: 'number' },
          data: {},
        },
        required: ['code', 'message', 'status'],
      },
      timestamp: { type: 'string', format: 'date-time' },
    },
    required: ['error', 'timestamp'],
  }),
})
```

#### Client Side

```ts
import { OpenAPILink } from '@orpc/openapi-client/fetch'
import { isORPCErrorJson, createORPCErrorFromJson } from '@orpc/client'

const link = new OpenAPILink(contract, {
  url: 'http://localhost:3000/api',
  customErrorResponseBodyDecoder: (body, response) => {
    if (body.error && isORPCErrorJson(body.error)) {
      return createORPCErrorFromJson(body.error)
    }
    return null
  },
})
```

## OpenAPI Client

Create type-safe clients from OpenAPI contracts.

### Installation

```bash
npm install @orpc/openapi-client
```

### Basic Usage

```ts
import { createORPCClient } from '@orpc/client'
import { OpenAPILink } from '@orpc/openapi-client/fetch'
import type { JsonifiedClient } from '@orpc/openapi-client'
import type { ContractRouterClient } from '@orpc/contract'

// Import contract from server
import type { contract } from './server'

const link = new OpenAPILink(contract, {
  url: 'http://localhost:3000/api',
})

const client: JsonifiedClient<ContractRouterClient<typeof contract>> =
  createORPCClient(link)

// Use the client
const planets = await client.planet.list({ limit: 10 })
const planet = await client.planet.find({ id: 1 })
```

### Link Options

```ts
const link = new OpenAPILink(contract, {
  // Base URL for all requests
  url: 'http://localhost:3000/api',

  // Custom headers (static or dynamic)
  headers: () => ({
    'x-api-key': process.env.API_KEY,
    'authorization': `Bearer ${getToken()}`,
  }),

  // Custom fetch implementation
  fetch: (request, init) => {
    return globalThis.fetch(request, {
      ...init,
      credentials: 'include',
      signal: AbortSignal.timeout(5000),
    })
  },

  // Interceptors
  interceptors: [
    onError((error) => console.error(error)),
  ],

  // Plugins
  plugins: [
    new ResponseValidationPlugin(contract),
  ],
})
```

### Client Context

```ts
interface ClientContext { something?: string }

const link = new OpenAPILink<ClientContext>(contract, {
  url: 'http://localhost:3000/api',
  headers: async ({ context }) => ({
    'x-api-key': context?.something ?? '',
  }),
})

const result = await client.planet.list(
  { limit: 10 },
  { context: { something: 'value' } }
)
```

### Lazy URL

```ts
const link = new OpenAPILink(contract, {
  url: () => {
    if (typeof window === 'undefined') throw new Error('Not allowed on server')
    return `${window.location.origin}/api`
  },
})
```

**Note**: A normal router works as a contract router as long as it does not include a lazy router.

### CORS Configuration

For file downloads, expose `Content-Disposition` header:

```ts
// Server side
const handler = new OpenAPIHandler(router, {
  plugins: [
    new CORSPlugin({
      exposeHeaders: ['Content-Disposition'],
    }),
  ],
})
```

### Response Validation

Validate responses against the contract:

```ts
import { ResponseValidationPlugin } from '@orpc/contract/plugins'

const link = new OpenAPILink(contract, {
  url: 'http://localhost:3000/api',
  plugins: [new ResponseValidationPlugin(contract)],
})
```

This enables proper type handling for:
- `Date` objects
- `BigInt` values
- `RegExp` objects
- `URL` objects
- `Set` and `Map` collections

### Error Handling

```ts
import { ORPCError } from '@orpc/client'

try {
  const planet = await client.planet.find({ id: 999 })
} catch (error) {
  if (error instanceof ORPCError) {
    console.error('Code:', error.code)
    console.error('Message:', error.message)
    console.error('Status:', error.status)
    console.error('Data:', error.data)
  }
}
```

### File Upload

```ts
// Client side
const file = new File(['content'], 'example.txt', { type: 'text/plain' })

await client.files.upload({
  file,
  description: 'Example file',
})
```

### File Download

```ts
// Client side
const blob = await client.files.download({ id: 1 })

// Save to disk (Node.js)
const buffer = Buffer.from(await blob.arrayBuffer())
fs.writeFileSync('downloaded.txt', buffer)

// Download in browser
const url = URL.createObjectURL(blob)
const a = document.createElement('a')
a.href = url
a.download = 'file.txt'
a.click()
URL.revokeObjectURL(url)
```

### Limitations

The OpenAPI client has some limitations:

1. **Multipart form data**: Payloads with `Blob`/`File` outside root must use `multipart/form-data`
2. **GET requests**: Must use `URLSearchParams` serialization
3. **Bracket notation**: Subject to bracket notation limitations (see Bracket Notation section)
4. **Binary data**: May not work correctly without proper plugins
5. **`Content-Disposition` header**: OpenAPILink requires access to `Content-Disposition` to distinguish file responses from other responses with common MIME types (e.g., `application/json`, `text/plain`). Expose via CORS: `CORSPlugin({ exposeHeaders: ['Content-Disposition'] })`

Use plugins to work around these limitations.

## Bracket Notation

oRPC uses bracket notation to represent structured data in URL queries and form data.

### Rules

1. **Same name (2+ occurrences)** → Array
   ```
   color=red&color=blue
   → { color: ["red", "blue"] }
   ```

2. **Append `[]`** → Single-item array
   ```
   color[]=red
   → { color: ["red"] }
   ```

3. **Append `[number]`** → Indexed array
   ```
   color[0]=red&color[2]=blue
   → { color: ["red", <empty>, "blue"] }
   ```

4. **Append `[key]`** → Object
   ```
   color[red]=true&color[blue]=false
   → { color: { red: true, blue: false } }
   ```

### URL Query Examples

```bash
# Simple object
curl "http://example.com/api?name[first]=John&name[last]=Doe"
# → { name: { first: "John", last: "Doe" } }

# Nested object
curl "http://example.com/api?user[name][first]=John&user[name][last]=Doe"
# → { user: { name: { first: "John", last: "Doe" } } }

# Array
curl "http://example.com/api?colors[]=red&colors[]=blue"
# → { colors: ["red", "blue"] }

# Indexed array
curl "http://example.com/api?items[0]=a&items[2]=c"
# → { items: ["a", <empty>, "c"] }

# Array of objects
curl "http://example.com/api?users[0][name]=John&users[1][name]=Jane"
# → { users: [{ name: "John" }, { name: "Jane" }] }
```

### Form Data Examples

```bash
# Object in form data
curl -X POST http://example.com/api \
  -F 'name[first]=John' \
  -F 'name[last]=Doe'
# → { name: { first: "John", last: "Doe" } }

# File upload with metadata
curl -X POST http://example.com/api \
  -F 'file=@/path/to/file.txt' \
  -F 'metadata[filename]=custom.txt' \
  -F 'metadata[size]=1024'
# → { file: File, metadata: { filename: "custom.txt", size: "1024" } }

# Array of files
curl -X POST http://example.com/api \
  -F 'files[]=@/path/file1.txt' \
  -F 'files[]=@/path/file2.txt'
# → { files: [File, File] }

# Complex nested structure
curl -X POST http://example.com/api \
  -F 'data[names][0][first]=John1' \
  -F 'data[names][0][last]=Doe1' \
  -F 'data[files][]=@/path/file.txt'
# → { data: { names: [{ first: "John1", last: "Doe1" }], files: [File] } }
```

### Limitations

Bracket notation cannot represent:
- Empty arrays: `[]`
- Empty objects: `{}`
- `null` values (distinguishable from missing values)
- `undefined` values

**Security**: Array indexes must be less than 10,000 by default to prevent memory exhaustion attacks. Configure with `maxBracketNotationArrayIndex` option on `OpenAPIHandler`:

```ts
const handler = new OpenAPIHandler(router, {
  maxBracketNotationArrayIndex: 5000, // default: 10000
})
```

Workarounds:
- Use JSON in request body for complex structures
- Use detailed input structure mode
- Use custom serializers

## Smart Coercion Plugins

Automatically coerce string values to correct types from URL parameters.

### Why Coercion is Needed

URL parameters and form data are always strings:
```text
/api/users/123  →  { id: "123" }  # Not a number!
?active=true    →  { active: "true" }  # Not a boolean!
```

Smart coercion plugins automatically convert these strings to the expected types based on your schema.

### ZodSmartCoercionPlugin (Recommended)

Zod-specific plugin with optimized performance.

#### Installation

```bash
# For Zod v3
npm install @orpc/zod

# For Zod v4
npm install @orpc/zod@latest
```

#### Usage

```ts
// Zod v3
import { ZodSmartCoercionPlugin } from '@orpc/zod'

// Zod v4
import { experimental_ZodSmartCoercionPlugin as ZodSmartCoercionPlugin } from '@orpc/zod/zod4'

const handler = new OpenAPIHandler(router, {
  plugins: [new ZodSmartCoercionPlugin()],
})
```

**Limitations**:
- **Zod v4**: Only supports discriminated unions. Regular (non-discriminated) unions are NOT coerced automatically.
- **Do NOT use with RPCHandler**: May negatively impact performance.
- Additional boolean values: `'t'` → `true`, `'f'` → `false`
- If the schema accepts both boolean and string, `'true'` will NOT be coerced to a boolean (safe, predictable behavior).

#### Conversion Rules

```ts
// String → Boolean
'true' → true
'on' → true
'false' → false
'off' → false

// String → Number
'123' → 123
'3.14' → 3.14
'-42' → -42

// String → BigInt
'12345678901234567890' → 12345678901234567890n

// String → Date
'2023-10-01' → new Date('2023-10-01')
'2023-10-01T12:00:00Z' → new Date('2023-10-01T12:00:00Z')

// String → RegExp
'/^\\d+$/i' → new RegExp('^\\d+$', 'i')

// String → URL
'https://example.com' → new URL('https://example.com')

// Array → Set
['a', 'b', 'c'] → new Set(['a', 'b', 'c'])

// Array → Map
[['key1', 'value1'], ['key2', 'value2']] → new Map([...])

// Array → Object (useful for Bracket Notation)
['apple', 'banana'] → { 0: 'apple', 1: 'banana' }
```

**Native types**: JavaScript types like BigInt, Date, RegExp, URL, Set, and Map are not natively supported by JSON Schema. oRPC uses `x-native-type` metadata (e.g., `x-native-type: 'bigint'`, `x-native-type: 'date'`) in schemas to enable correct coercion. Built-in JSON Schema Converters handle this automatically. Custom converters may need to add `x-native-type` metadata manually.

#### Example

```ts
const findUser = os
  .route({ method: 'GET', path: '/users/{id}' })
  .input(z.object({
    id: z.number().int(), // No need for z.coerce
    active: z.boolean().optional(),
    createdAfter: z.date().optional(),
  }))
  .handler(({ input }) => {
    // GET /users/123?active=true&createdAfter=2023-10-01
    // input.id → 123 (number)
    // input.active → true (boolean)
    // input.createdAfter → Date object
    return { id: input.id, active: input.active }
  })
```

### SmartCoercionPlugin (Schema-agnostic)

Works with any schema library (Zod, Valibot, ArkType).

#### Installation

```bash
npm install @orpc/json-schema
```

#### Usage

```ts
import { SmartCoercionPlugin } from '@orpc/json-schema'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const handler = new OpenAPIHandler(router, {
  plugins: [
    new SmartCoercionPlugin({
      schemaConverters: [new ZodToJsonSchemaConverter()],
    }),
  ],
})
```

The schema-agnostic plugin:
- Converts schema to JSON Schema
- Applies coercion based on JSON Schema types
- Works with any schema library
- Slightly slower than Zod-specific plugin

### Performance Considerations

Smart coercion plugins impact performance because they:
1. Traverse the entire input object
2. Convert schemas to JSON Schema (for schema-agnostic plugin)
3. Apply type coercion to every field

For high-performance applications:
- Use manual coercion with `z.coerce`
- Use `z.coerce.number()`, `z.coerce.boolean()`, etc.
- Only enable plugins for development/testing

```ts
// Manual coercion (better performance)
const schema = z.object({
  id: z.coerce.number(),
  active: z.coerce.boolean(),
})

// Smart coercion (convenience)
const schema = z.object({
  id: z.number(),
  active: z.boolean(),
})
```

## Interactive API Documentation

Serve interactive API documentation with Swagger UI or Scalar.

### Swagger UI

```ts
import { createServer } from 'node:http'
import { OpenAPIGenerator } from '@orpc/openapi'
import { OpenAPIHandler } from '@orpc/openapi/node'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const handler = new OpenAPIHandler(router)
const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
})

const server = createServer(async (req, res) => {
  // Handle API requests
  const { matched } = await handler.handle(req, res, { prefix: '/api' })
  if (matched) return

  // Serve OpenAPI spec
  if (req.url === '/spec.json') {
    const spec = await generator.generate(router, {
      info: { title: 'My API', version: '1.0.0' },
      servers: [{ url: '/api' }],
    })
    res.writeHead(200, { 'Content-Type': 'application/json' })
    res.end(JSON.stringify(spec))
    return
  }

  // Serve Swagger UI
  const html = `
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>API Documentation</title>
        <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@latest/swagger-ui.css" />
      </head>
      <body>
        <div id="swagger-ui"></div>
        <script src="https://unpkg.com/swagger-ui-dist@latest/swagger-ui-bundle.js"></script>
        <script>
          window.onload = () => {
            SwaggerUIBundle({
              url: '/spec.json',
              dom_id: '#swagger-ui',
            })
          }
        </script>
      </body>
    </html>
  `
  res.writeHead(200, { 'Content-Type': 'text/html' })
  res.end(html)
})

server.listen(3000)
```

### Scalar

```ts
import { createServer } from 'node:http'
import { OpenAPIGenerator } from '@orpc/openapi'
import { OpenAPIHandler } from '@orpc/openapi/node'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const handler = new OpenAPIHandler(router)
const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
})

const server = createServer(async (req, res) => {
  // Handle API requests
  const { matched } = await handler.handle(req, res, { prefix: '/api' })
  if (matched) return

  // Serve OpenAPI spec
  if (req.url === '/spec.json') {
    const spec = await generator.generate(router, {
      info: { title: 'My API', version: '1.0.0' },
      servers: [{ url: '/api' }],
    })
    res.writeHead(200, { 'Content-Type': 'application/json' })
    res.end(JSON.stringify(spec))
    return
  }

  // Serve Scalar
  const html = `
    <!doctype html>
    <html>
      <head>
        <title>API Reference</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body>
        <div id="app"></div>
        <script src="https://cdn.jsdelivr.net/npm/@scalar/api-reference"></script>
        <script>
          Scalar.createApiReference('#app', {
            url: '/spec.json',
            theme: 'purple',
          })
        </script>
      </body>
    </html>
  `
  res.writeHead(200, { 'Content-Type': 'text/html' })
  res.end(html)
})

server.listen(3000)
```

### OpenAPIReferencePlugin (Simplified)

Use the plugin for automatic documentation serving:

```ts
import { OpenAPIReferencePlugin } from '@orpc/openapi/plugins'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const handler = new OpenAPIHandler(router, {
  plugins: [
    new OpenAPIReferencePlugin({
      // Choose documentation provider
      docsProvider: 'scalar', // or 'swagger'

      // Schema converters
      schemaConverters: [new ZodToJsonSchemaConverter()],

      // OpenAPI spec options
      specGenerateOptions: {
        info: {
          title: 'ORPC Playground',
          version: '1.0.0',
          description: 'Interactive API documentation',
        },
        servers: [
          { url: 'https://api.example.com/v1' },
        ],
      },

      // Custom paths (optional)
      docsPath: '/docs',
      specPath: '/openapi.json',
    }),
  ],
})
```

Default paths:
- API reference: `/` (root)
- OpenAPI spec: `/spec.json`

The plugin automatically:
- Generates OpenAPI specification
- Serves interactive documentation
- Updates documentation on router changes

## Advanced OpenAPI Features

### Disabling Output Validation

Skip output validation for better performance:

```ts
const base = os.$config({
  initialOutputValidationIndex: Number.NaN,
})

const router = base.router({
  // Procedures won't validate output
})
```

Warning: This won't work if your schema transforms data during validation (e.g., `.transform()`, `.default()`).

**Caveat**: When disabled, schemas with `.transform()` may cause type mismatches. For example, `z.number().transform(val => String(val))` causes the client to expect `string` but receive `number`.

### Expanding Type Support for OpenAPILink

OpenAPI responses only carry JSON-native types. Use `z.coerce` in output schemas + ResponseValidationPlugin to get proper types (Date, BigInt, etc.) on the client:

```ts
// Contract with coercion
const contract = oc.output(z.object({
  date: z.coerce.date<Date>(),
  bigint: z.coerce.bigint<bigint>(),
}))

// Client setup - remove JsonifiedClient wrapper
import { ResponseValidationPlugin } from '@orpc/contract/plugins'

const link = new OpenAPILink(contract, {
  url: 'http://localhost:3000/api',
  plugins: [new ResponseValidationPlugin(contract)],
})

// No JsonifiedClient needed - types are properly coerced
const client: ContractRouterClient<typeof contract> = createORPCClient(link)
```

The server sends `{ date: "2025-09-01T...", bigint: "123" }`. The ResponseValidationPlugin runs the schema coercion, converting to `{ date: Date, bigint: 123n }`.

**Requirement**: To support types beyond OpenAPI Handler's defaults, extend the OpenAPI JSON Serializer first.

### Custom Response Status Codes

Define custom success status codes:

```ts
// 201 Created
const create = os
  .route({ method: 'POST', path: '/items', successStatus: 201 })
  .handler(() => ({ id: 1 }))

// 204 No Content
const delete = os
  .route({ method: 'DELETE', path: '/items/{id}', successStatus: 204 })
  .handler(() => {})

// 202 Accepted
const async = os
  .route({ method: 'POST', path: '/jobs', successStatus: 202 })
  .handler(() => ({ jobId: '123' }))
```

### Range Responses

```ts
const downloadRange = os
  .route({
    path: '/files/{id}',
    outputStructure: 'detailed',
  })
  .output(z.union([
    z.object({
      status: z.literal(200),
      body: z.instanceof(Blob),
    }),
    z.object({
      status: z.literal(206),
      headers: z.object({
        'content-range': z.string(),
      }),
      body: z.instanceof(Blob),
    }),
  ]))
  .handler(async ({ input, context }) => {
    const range = context.headers.range
    const file = await getFile(input.id)

    if (range) {
      const [start, end] = parseRange(range)
      const chunk = file.slice(start, end)
      return {
        status: 206,
        headers: {
          'content-range': `bytes ${start}-${end}/${file.size}`,
        },
        body: chunk,
      }
    }

    return {
      status: 200,
      body: file,
    }
  })
```

### Content Negotiation

```ts
const getData = os
  .route({
    path: '/data',
    outputStructure: 'detailed',
  })
  .handler(async ({ context }) => {
    const accept = context.headers.accept

    if (accept?.includes('application/json')) {
      return {
        headers: { 'content-type': 'application/json' },
        body: { data: 'value' },
      }
    }

    if (accept?.includes('text/csv')) {
      return {
        headers: { 'content-type': 'text/csv' },
        body: 'column1,column2\nvalue1,value2',
      }
    }

    return {
      status: 406,
      body: { error: 'Not Acceptable' },
    }
  })
```

### Conditional Requests

```ts
const getResource = os
  .route({
    path: '/resources/{id}',
    outputStructure: 'detailed',
  })
  .handler(async ({ input, context }) => {
    const resource = await getResource(input.id)
    const etag = generateETag(resource)

    if (context.headers['if-none-match'] === etag) {
      return { status: 304 } // Not Modified
    }

    return {
      headers: {
        'etag': etag,
        'cache-control': 'max-age=3600',
      },
      body: resource,
    }
  })
```

## tRPC Integration

Integrate existing tRPC routers with oRPC's OpenAPI features.

### Installation

```bash
npm install @orpc/trpc
```

### Setup

```ts
import { initTRPC } from '@trpc/server'
import { ORPCMeta, toORPCRouter } from '@orpc/trpc'

// Initialize tRPC with ORPCMeta
export const t = initTRPC
  .context<Context>()
  .meta<ORPCMeta>()
  .create()

// Create tRPC router
const trpcRouter = t.router({
  hello: t.procedure
    .meta({
      route: {
        method: 'GET',
        path: '/hello',
      },
    })
    .input(z.object({ name: z.string() }))
    .output(z.object({ message: z.string() }))
    .query(({ input }) => {
      return { message: `Hello, ${input.name}!` }
    }),
})

// Convert to oRPC router
const orpcRouter = toORPCRouter(trpcRouter)
```

### Generate OpenAPI Spec

```ts
import { OpenAPIGenerator } from '@orpc/openapi'
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4'

const generator = new OpenAPIGenerator({
  schemaConverters: [new ZodToJsonSchemaConverter()],
})

const spec = await generator.generate(orpcRouter, {
  info: { title: 'My App', version: '0.0.0' },
})
```

### Handle HTTP Requests

```ts
import { OpenAPIHandler } from '@orpc/openapi/node'
import { CORSPlugin } from '@orpc/server/plugins'

const handler = new OpenAPIHandler(orpcRouter, {
  plugins: [new CORSPlugin()],
})

const server = createServer(async (req, res) => {
  await handler.handle(req, res)
})
```

### Error Formatting

`toORPCRouter` does not support tRPC Error Formatting. Catch errors and format them manually using interceptors:

```ts
const handler = new OpenAPIHandler(orpcRouter, {
  clientInterceptors: [
    onError((error) => {
      if (
        error instanceof ORPCError
        && error.code === 'BAD_REQUEST'
        && error.cause instanceof TRPCError
        && error.cause.cause instanceof ZodError
      ) {
        throw new ORPCError('INPUT_VALIDATION_FAILED', {
          status: 422,
          data: error.cause.cause.flatten(),
        })
      }
    }),
  ],
})
```

### tRPC Procedure Metadata

Add OpenAPI metadata to tRPC procedures:

```ts
const trpcRouter = t.router({
  getPlanet: t.procedure
    .meta({
      route: {
        method: 'GET',
        path: '/planets/{id}',
        operationId: 'getPlanet',
        summary: 'Get a planet by ID',
        tags: ['planets'],
      },
    })
    .input(z.object({ id: z.coerce.number() }))
    .output(PlanetSchema)
    .query(({ input }) => getPlanet(input.id)),
})
```

## NestJS Integration

For NestJS integration with oRPC (decorators, dependency injection, contract-first development), see `references/nestjs.md`.

## Best Practices

### API Versioning

```ts
// Version in URL
const v1Router = os.prefix('/v1').router({
  planets: planetRouter,
})

const v2Router = os.prefix('/v2').router({
  planets: planetRouterV2,
})

const router = os.router({
  v1: v1Router,
  v2: v2Router,
})

// Version in header
const versionedProcedure = os
  .route({ path: '/planets' })
  .handler(({ context }) => {
    const version = context.headers['api-version']
    if (version === '2') {
      return getPlanetsV2()
    }
    return getPlanetsV1()
  })
```

### Rate Limiting

```ts
import { RateLimitPlugin } from './plugins/rate-limit'

const handler = new OpenAPIHandler(router, {
  plugins: [
    new RateLimitPlugin({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100, // Limit each IP to 100 requests per windowMs
    }),
  ],
})
```

### Request Logging

```ts
import { onBefore, onAfter } from '@orpc/server'

const handler = new OpenAPIHandler(router, {
  interceptors: [
    onBefore(({ input, context }) => {
      console.log('Request:', {
        path: context.path,
        input,
        timestamp: new Date().toISOString(),
      })
    }),
    onAfter(({ output }) => {
      console.log('Response:', {
        output,
        timestamp: new Date().toISOString(),
      })
    }),
  ],
})
```

### Pagination

```ts
const listItems = os
  .route({ method: 'GET', path: '/items' })
  .input(z.object({
    limit: z.number().int().min(1).max(100).default(20),
    offset: z.number().int().min(0).default(0),
  }))
  .output(z.object({
    items: z.array(ItemSchema),
    total: z.number(),
    hasMore: z.boolean(),
  }))
  .handler(async ({ input }) => {
    const items = await db.items.findMany({
      take: input.limit,
      skip: input.offset,
    })
    const total = await db.items.count()

    return {
      items,
      total,
      hasMore: input.offset + input.limit < total,
    }
  })
```

### Cursor-Based Pagination

```ts
const listItems = os
  .route({ method: 'GET', path: '/items' })
  .input(z.object({
    limit: z.number().int().min(1).max(100).default(20),
    cursor: z.string().optional(),
  }))
  .output(z.object({
    items: z.array(ItemSchema),
    nextCursor: z.string().optional(),
  }))
  .handler(async ({ input }) => {
    const items = await db.items.findMany({
      take: input.limit + 1,
      cursor: input.cursor ? { id: input.cursor } : undefined,
    })

    let nextCursor: string | undefined
    if (items.length > input.limit) {
      const nextItem = items.pop()
      nextCursor = nextItem!.id
    }

    return { items, nextCursor }
  })
```

### Health Checks

```ts
const healthCheck = os
  .route({ method: 'GET', path: '/health' })
  .output(z.object({
    status: z.enum(['healthy', 'unhealthy']),
    timestamp: z.string(),
    services: z.record(z.boolean()),
  }))
  .handler(async () => {
    const dbHealthy = await checkDatabase()
    const cacheHealthy = await checkCache()

    return {
      status: dbHealthy && cacheHealthy ? 'healthy' : 'unhealthy',
      timestamp: new Date().toISOString(),
      services: {
        database: dbHealthy,
        cache: cacheHealthy,
      },
    }
  })
```

### Testing

```ts
import { describe, it, expect } from 'vitest'
import { OpenAPIHandler } from '@orpc/openapi/fetch'

describe('Planet API', () => {
  const handler = new OpenAPIHandler(router)

  it('should list planets', async () => {
    const request = new Request('http://localhost/planets')
    const { response } = await handler.handle(request)

    expect(response.status).toBe(200)
    const data = await response.json()
    expect(Array.isArray(data)).toBe(true)
  })

  it('should find planet by id', async () => {
    const request = new Request('http://localhost/planets/1')
    const { response } = await handler.handle(request)

    expect(response.status).toBe(200)
    const data = await response.json()
    expect(data.id).toBe(1)
  })

  it('should return 404 for non-existent planet', async () => {
    const request = new Request('http://localhost/planets/999')
    const { response } = await handler.handle(request)

    expect(response.status).toBe(404)
  })
})
```

## See Also

- Core API (procedures, middleware, context, errors): `references/api-reference.md`
- Framework adapters: `references/adapters.md`
- Built-in plugins: `references/plugins.md`
- Contract-first development: `references/contract-first.md`
