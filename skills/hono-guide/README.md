# Hono Guide Plugin

Build ultrafast web APIs with Claude. This plugin teaches Claude everything about Hono — from routing and middleware to type-safe RPC, streaming, WebSocket, and deploying the same code across Cloudflare Workers, Bun, Deno, Node.js, AWS Lambda, Vercel, Netlify, and more.

## What it does

Instead of switching between docs and code, just describe what you need. Claude will generate correct Hono code with proper routing patterns, middleware configuration, type-safe RPC setup, validation, and platform-specific deployment configuration.

Covers 25+ built-in middleware, 15+ helpers, and 12+ deployment platforms.

## Installation

```bash
claude install-plugin /path/to/hono-guide-plugin
```

Or add the plugin directory to your Claude Code configuration.

## Usage

Once installed, Claude automatically activates this guide when you:

- "Create a Hono app"
- "Build an API with Hono"
- "Add middleware to my Hono app"
- "Deploy Hono to Cloudflare Workers"
- "Set up Hono RPC client"
- "Add JWT auth to Hono"
- "Validate requests with Zod in Hono"
- "Use Hono JSX for server-side rendering"
- "Stream responses with Hono SSE"
- "Add WebSocket support to Hono"
- "Set up CORS in Hono"
- "Test my Hono API"

## What's included

| Reference | Coverage |
|-----------|----------|
| API Reference | Context, HonoRequest, App, HTTPException, Routing |
| Middleware - Auth | Basic Auth, Bearer Auth, JWT, JWK verification |
| Middleware - Security | CORS, CSRF, Secure Headers, IP Restriction, Combine (access control) |
| Middleware - Request/Response | Body Limit, Compress, Method Override, Trailing Slash, Cache, ETag, Pretty JSON |
| Middleware - Utilities | Context Storage, Logger, Request ID, Timing, Timeout, JSX Renderer, Language Detection |
| Helpers - Auth & Streaming | Cookie, JWT (sign/verify/decode), Streaming (stream, streamText, streamSSE), WebSocket |
| Helpers - Rendering | HTML (tagged templates, raw, XSS protection), CSS (scoped styles, keyframes, CSP nonce) |
| Helpers - Factory & Testing | Factory (createMiddleware, createHandlers), Testing (testClient), Proxy, SSG |
| Helpers - Runtime | Accepts (content negotiation), Adapter (env, getRuntimeKey), ConnInfo, Dev, Route |
| Platforms - Core | Cloudflare Workers, Cloudflare Pages, Bun, Deno, Node.js |
| Platforms - Serverless | AWS Lambda, Lambda@Edge, Vercel, Next.js, Netlify |
| Platforms - Other | Azure, GCR, Fastly, Supabase, Alibaba, Service Worker, WebAssembly |
| RPC & Validation | RPC client (hc), type inference, Zod validator, Standard Schema |
| JSX | JSX rendering, Client Components, Suspense, streaming |
| Patterns | Best practices, testing, error handling, validation patterns, RPC troubleshooting |

## License

MIT
