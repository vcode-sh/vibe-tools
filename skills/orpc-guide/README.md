# oRPC Guide Plugin

Build type-safe APIs with Claude. This plugin teaches Claude everything about oRPC — from procedures and middleware to OpenAPI spec generation, SSE streaming, server actions, and deploying across 20+ framework adapters including Next.js, Express, Hono, Fastify, Cloudflare Workers, and more.

## What it does

Instead of switching between docs and code, just describe what you need. Claude will generate correct oRPC code with proper procedure chains, middleware patterns, type-safe client setup, error handling, OpenAPI integration, and framework-specific adapter configuration.

Covers end-to-end type safety, contract-first development, and seamless integration with TanStack Query, SWR, Better Auth, AI SDK, and more.

## Installation

```bash
claude install-plugin /path/to/orpc-guide-plugin
```

Or add the plugin directory to your Claude Code configuration.

## Usage

Once installed, Claude automatically activates this guide when you:

- "Create oRPC procedures"
- "Set up oRPC server"
- "Configure oRPC client"
- "Add oRPC middleware"
- "Define oRPC router"
- "Use oRPC with Next.js/Express/Hono/Fastify"
- "Generate OpenAPI spec with oRPC"
- "Integrate oRPC with TanStack Query"
- "Stream with oRPC"
- "Handle errors in oRPC"
- "Set up oRPC contract-first"
- "Migrate from tRPC to oRPC"

## What's included

| Reference | Coverage |
|-----------|----------|
| API Reference | Procedures, routers, middleware, context, errors, metadata, event iterators, server actions, file handling |
| Adapters | Next.js, Express, Hono, Fastify, Node.js, Bun, Deno, Cloudflare Workers, WebSocket, Electron, and 10+ more |
| Plugins | CORS, batch, retry, compression, CSRF, validation, client retry, deduplication, simple CSRF |
| OpenAPI | Spec generation, OpenAPIHandler, routing, input/output structure, Scalar UI, OpenAPILink |
| Integrations | TanStack Query, React SWR, Pinia Colada, Better Auth, AI SDK, Sentry, Pino, OpenTelemetry |
| Contract-First | Contract-first development, tRPC migration guide, comparison with alternatives |
| Helpers | Cookie management, signing, encryption, rate limiting, publisher with event resume |
| NestJS | NestJS integration with decorators, dependency injection, contract-first |
| Advanced | Testing, serialization, TypeScript best practices, publishing clients, body parsing |

## License

MIT
