# Hono Serverless Platforms

Setup and deployment for serverless platforms: AWS Lambda, Lambda@Edge, Vercel, Next.js, and Netlify.

## Table of Contents

1. [AWS Lambda](#aws-lambda)
2. [Lambda@Edge](#lambdaedge)
3. [Vercel](#vercel)
4. [Next.js](#nextjs)
5. [Netlify](#netlify)

---

## AWS Lambda

**Default Port:** N/A (serverless)

### Setup with CDK

```bash
npm install hono
npm install -D @aws-cdk/aws-lambda
```

### Handler Pattern

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello AWS Lambda!')
})

export const handler = handle(app)
```

### With Lambda Types

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'
import type { LambdaEvent, LambdaContext } from 'hono/aws-lambda'

const app = new Hono()

app.get('/context', (c) => {
  const event = c.env.event as LambdaEvent
  const lambdaContext = c.env.lambdaContext as LambdaContext

  return c.json({
    requestId: lambdaContext.requestId,
    functionName: lambdaContext.functionName,
    sourceIp: event.requestContext.identity.sourceIp,
  })
})

export const handler = handle(app)
```

### Binary Response Handling

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'

const app = new Hono()

app.get('/image', async (c) => {
  const imageBuffer = await fetch('https://example.com/image.png')
    .then(res => res.arrayBuffer())

  // Automatically base64 encoded for Lambda
  return c.body(imageBuffer, 200, {
    'Content-Type': 'image/png',
  })
})

export const handler = handle(app)
```

### Response Streaming

```typescript
import { Hono } from 'hono'
import { streamHandle } from 'hono/aws-lambda'

const app = new Hono()

app.get('/stream', (c) => {
  return c.streamText(async (stream) => {
    for (let i = 0; i < 10; i++) {
      await stream.write(`Chunk ${i}\n`)
      await stream.sleep(1000)
    }
  })
})

export const streamHandler = streamHandle(app)
```

### Access Request Context

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'

const app = new Hono()

app.get('/info', (c) => {
  const event = c.env.event
  const context = c.env.lambdaContext

  return c.json({
    stage: event.requestContext.stage,
    requestId: event.requestContext.requestId,
    apiId: event.requestContext.apiId,
    functionVersion: context.functionVersion,
    memoryLimit: context.memoryLimitInMB,
  })
})

export const handler = handle(app)
```

### CDK Deployment

```typescript
import * as cdk from 'aws-cdk-lib'
import * as lambda from 'aws-cdk-lib/aws-lambda'
import * as apigateway from 'aws-cdk-lib/aws-apigateway'

export class HonoLambdaStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    const honoLambda = new lambda.Function(this, 'HonoFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromAsset('dist'),
      memorySize: 256,
      timeout: cdk.Duration.seconds(30),
    })

    new apigateway.LambdaRestApi(this, 'HonoApi', {
      handler: honoLambda,
    })
  }
}
```

### Local Testing with SAM

```yaml
# template.yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  HonoFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: dist/
      Handler: index.handler
      Runtime: nodejs20.x
      Events:
        Api:
          Type: Api
          Properties:
            Path: /{proxy+}
            Method: ANY
```

```bash
sam local start-api
# Runs on http://localhost:3000
```

### Platform-Specific Features

- **Auto-scaling** and pay-per-use
- **Binary response** auto-encoding
- **Response streaming** support (Lambda URLs)
- **VPC** integration available
- **Environment variables** from Lambda config
- **CloudWatch Logs** integration

### Gotchas

- Cold start latency (use provisioned concurrency if needed)
- 6MB response size limit (29MB with streaming)
- Binary responses must be base64 encoded
- Set `binaryMediaTypes` in API Gateway
- Use Lambda URLs for simpler setup without API Gateway
- Streaming requires Lambda Function URLs with InvokeMode: RESPONSE_STREAM

---

## Lambda@Edge

**Default Port:** N/A (serverless, CloudFront edge)

### Setup with CDK

```bash
npm install hono
```

### Handler Pattern

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/lambda-edge'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Lambda@Edge!')
})

export const handler = handle(app)
```

### CDK Deployment (us-east-1 Required)

```typescript
import * as cdk from 'aws-cdk-lib'
import * as lambda from 'aws-cdk-lib/aws-lambda'
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront'
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins'

export class LambdaEdgeStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, {
      ...props,
      env: { region: 'us-east-1' }, // REQUIRED for Lambda@Edge
    })

    const edgeFunction = new lambda.Function(this, 'HonoEdgeFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromAsset('dist'),
      memorySize: 128,
    })

    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      defaultBehavior: {
        origin: new origins.HttpOrigin('example.com'),
        edgeLambdas: [
          {
            functionVersion: edgeFunction.currentVersion,
            eventType: cloudfront.LambdaEdgeEventType.ORIGIN_REQUEST,
          },
        ],
      },
    })
  }
}
```

### Callback Feature

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/lambda-edge'

const app = new Hono()

app.get('/', (c) => c.text('Hello!'))

export const handler = handle(app, {
  callback: async (event, context, response) => {
    // Modify response before returning
    response.headers['x-custom-header'] = [{ key: 'X-Custom-Header', value: 'Value' }]
    return response
  },
})
```

### Platform-Specific Features

- **Edge locations** worldwide
- **Low latency** responses
- **CloudFront integration**
- **Request/response** manipulation
- **Geographic routing**

### Gotchas

- MUST deploy to **us-east-1** region
- Stricter limits than regular Lambda (1MB code size, 128MB memory max)
- No environment variables support
- Longer deployment time (replication to edges)
- Limited to Node.js runtime
- Response body size limit (1MB for viewer response, 8MB for origin)
- Use viewer-request/response for earliest interception
- Use origin-request/response for origin communication

---

## Vercel

**Default Port:** 3000

### Setup

```bash
npm create hono@latest my-app -- --template vercel
cd my-app
npm install
```

### Handler Pattern

```typescript
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Vercel!')
})

export default app
```

### Local Development

```bash
vercel dev
# Runs on http://localhost:3000
```

### Deployment

```bash
vercel
# or for production
vercel --prod
```

### Zero Configuration

Vercel automatically detects Hono apps and configures them correctly. No `vercel.json` required for basic setup.

### Optional vercel.json

```json
{
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": null,
  "outputDirectory": "dist"
}
```

### Platform-Specific Features

- **Zero config** deployment
- **Automatic HTTPS**
- **Edge Network** global distribution
- **Preview deployments** for branches
- **Environment variables** via dashboard
- **Serverless Functions** under the hood

### Gotchas

- Export `default app` (not named exports)
- Functions timeout after 10s (hobby), 60s (pro)
- 4.5MB response limit
- Static files served from `public/` directory
- Edge Functions require explicit configuration

---

## Next.js

**Default Port:** 3000

### Setup (App Router)

```bash
npx create-next-app@latest my-app
cd my-app
npm install hono
```

### Handler Pattern (App Router)

**File:** `app/api/[[...route]]/route.ts`

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/vercel'

export const runtime = 'edge' // or 'nodejs'

const app = new Hono().basePath('/api')

app.get('/hello', (c) => {
  return c.json({
    message: 'Hello Next.js!',
  })
})

export const GET = handle(app)
export const POST = handle(app)
export const PUT = handle(app)
export const DELETE = handle(app)
export const PATCH = handle(app)
```

### Multiple HTTP Methods

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/vercel'

const app = new Hono().basePath('/api')

app.get('/users', (c) => c.json({ users: [] }))
app.post('/users', async (c) => {
  const body = await c.req.json()
  return c.json({ created: body }, 201)
})

// Export all methods you use
export const GET = handle(app)
export const POST = handle(app)
```

### Pages Router Alternative

**File:** `pages/api/[...route].ts`

```typescript
import { Hono } from 'hono'
import { serve } from '@hono/node-server'

const app = new Hono()

app.get('/api/hello', (c) => {
  return c.json({ message: 'Hello from Pages Router!' })
})

export default function handler(req: any, res: any) {
  return serve({
    fetch: app.fetch,
    req,
    res,
  })
}
```

### Local Development

```bash
npm run dev
# Runs on http://localhost:3000
```

### Platform-Specific Features

- **App Router** catch-all routes
- **Edge Runtime** support
- **Middleware** integration
- **TypeScript** built-in
- **API Routes** alongside pages

### Gotchas

- Must use `basePath('/api')` for App Router
- Export HTTP method handlers (`GET`, `POST`, etc.)
- Use `[[...route]]` for catch-all optional segments
- Edge runtime has Node.js API limitations
- Static files in `public/` directory

---

## Netlify

**Default Port:** 8888

### Setup

```bash
npm create hono@latest my-app -- --template netlify
cd my-app
npm install
```

### Handler Pattern (Functions)

**File:** `netlify/functions/api.ts`

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/netlify'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Netlify!')
})

export default handle(app)
```

### Edge Functions (Deno Runtime)

**File:** `netlify/edge-functions/api.ts`

```typescript
import { Hono } from 'https://deno.land/x/hono/mod.ts'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello from Edge!')
})

export default app.fetch
```

### Access Netlify Context

```typescript
import { Hono } from 'hono'
import { handle } from 'hono/netlify'
import type { Context as NetlifyContext } from '@netlify/functions'

const app = new Hono()

app.get('/geo', (c) => {
  const netlifyContext = c.env as NetlifyContext

  return c.json({
    country: netlifyContext.geo?.country,
    city: netlifyContext.geo?.city,
    timezone: netlifyContext.geo?.timezone,
  })
})

export default handle(app)
```

### Local Development

```bash
netlify dev
# Runs on http://localhost:8888
```

### Configuration (netlify.toml)

```toml
[build]
  command = "npm run build"
  publish = "dist"
  functions = "netlify/functions"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/api/:splat"
  status = 200

[dev]
  command = "npm run dev"
  port = 8888
```

### Deployment

```bash
netlify deploy
# or for production
netlify deploy --prod
```

### Platform-Specific Features

- **Edge Functions** with Deno runtime
- **Geo location** data in context
- **Split testing** support
- **Preview deployments**
- **Identity** authentication
- **Forms** handling

### Gotchas

- Functions in `netlify/functions/` directory
- Edge Functions use Deno runtime (different imports)
- Must configure redirects for clean URLs
- Functions timeout after 10s (background functions: 15min)
- Edge Functions globally distributed
