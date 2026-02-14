# oRPC NestJS Integration Reference

Integrate oRPC with NestJS using decorators, dependency injection, and contract-first development.

## Requirements

- Node.js 22+
- ESM-only

## Installation

```bash
npm install @orpc/nest
```

## Setup

```ts
import { Module } from '@nestjs/common'
import { ORPCModule } from '@orpc/nest'
import { REQUEST } from '@nestjs/core'
import { onError } from '@orpc/server'
import { ORPCError } from '@orpc/server'
import { RethrowHandlerPlugin } from '@orpc/nest'

@Module({
  imports: [
    ORPCModule.forRootAsync({
      useFactory: (request: Request) => ({
        interceptors: [onError((error) => console.error(error))],
        context: { request },
        plugins: [
          new RethrowHandlerPlugin({
            filter: (error) => !(error instanceof ORPCError),
          }),
        ],
      }),
      inject: [REQUEST],
    }),
  ],
  controllers: [PlanetController],
})
export class AppModule {}
```

Important: Disable NestJS body parser:

```ts
import { NestFactory } from '@nestjs/core'

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bodyParser: false, // Required!
  })
  await app.listen(3000)
}
```

## Controller Implementation

```ts
import { Controller } from '@nestjs/common'
import { Implement, implement } from '@orpc/nest'
import { contract } from './contract'

@Controller()
export class PlanetController {
  // Single procedure
  @Implement(contract.planet.list)
  list() {
    return implement(contract.planet.list).handler(({ input }) => {
      return []
    })
  }

  // Router implementation
  @Implement(contract.planet)
  planet() {
    return {
      list: implement(contract.planet.list).handler(({ input }) => []),
      find: implement(contract.planet.find).handler(({ input }) => {
        return { id: 1, name: 'Earth' }
      }),
      create: implement(contract.planet.create).handler(({ input }) => {
        return { id: 1, ...input }
      }),
    }
  }
}
```

## Dependency Injection

```ts
import { Injectable } from '@nestjs/common'
import { Controller } from '@nestjs/common'
import { Implement, implement } from '@orpc/nest'

@Injectable()
export class PlanetService {
  findAll() {
    return []
  }

  findOne(id: number) {
    return { id, name: 'Earth' }
  }
}

@Controller()
export class PlanetController {
  constructor(private readonly planetService: PlanetService) {}

  @Implement(contract.planet.list)
  list() {
    return implement(contract.planet.list).handler(({ input }) => {
      return this.planetService.findAll()
    })
  }

  @Implement(contract.planet.find)
  find() {
    return implement(contract.planet.find).handler(({ input }) => {
      return this.planetService.findOne(input.id)
    })
  }
}
```

## Contract Path Requirement

Each NestJS contract **must** define a `path` in its `.route()`. Omitting it will cause a build-time error.

## Populate Contract Router Paths

Auto-populate missing paths using router keys:

```ts
import { oc, populateContractRouterPaths } from '@orpc/contract'

export const contract = populateContractRouterPaths({
  planet: {
    list: oc.route({ method: 'GET', path: '/planets' }).output(z.array(PlanetSchema)),
    find: oc.route({ method: 'GET', path: '/planets/{id}' }).output(PlanetSchema),
  },
})
```

## Global Context Type

Declare global context type for NestJS:

```ts
declare module '@orpc/nest' {
  interface ORPCGlobalContext {
    request: Request
  }
}
```

## Custom Send Response

Use `sendResponseInterceptors` to modify how responses are sent:

```ts
ORPCModule.forRootAsync({
  useFactory: () => ({
    sendResponseInterceptors: [
      async (options) => {
        const result = await options.next(options)
        if (result.response.status >= 400) {
          console.error('Error response:', result.response.status)
        }
        return result
      },
    ],
  }),
})
```

## Limitations

- **Fastify platform**: Path parameter matching with slashes (`/`) does not work on NestJS Fastify, because Fastify does not allow wildcard (`*`) aliasing in path parameters.
- **Body parser**: Disable NestJS body parser because its `urlencoded` parser doesn't support Bracket Notation. oRPC uses NestJS parsed body when available, and falls back to its own parser otherwise.
- **Node.js 22+ recommended**: Allows `require()` of ESM modules natively.
- **Bundler config**: NestJS bundler (Webpack/SWC) might not compile `node_modules`. You may need to adjust configs to include `@orpc/nest` for compilation.

## Middleware and Plugins

Use the `RethrowHandlerPlugin` to integrate with NestJS exception handling:

```ts
import { RethrowHandlerPlugin } from '@orpc/nest'
import { ORPCError } from '@orpc/server'

ORPCModule.forRootAsync({
  useFactory: () => ({
    plugins: [
      // Rethrow non-ORPC errors to NestJS
      new RethrowHandlerPlugin({
        filter: (error) => !(error instanceof ORPCError),
      }),
    ],
  }),
})
```

## See Also

- OpenAPI integration: `references/openapi.md`
- Contract-first development: `references/contract-first.md`
- Framework adapters: `references/adapters.md`
- Built-in plugins: `references/plugins.md`
