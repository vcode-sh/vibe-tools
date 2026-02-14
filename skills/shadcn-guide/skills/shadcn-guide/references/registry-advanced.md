# shadcn/ui Registry System — Advanced

Authentication, MCP server, registry examples, Open in v0, contributing blocks, and community registries. See `registry-core.md` for schema and getting started.

---

## Authentication

Authentication enables private components, team-specific resources, access control, usage analytics, and licensing.

### Bearer Token (OAuth 2.0)

```json
{
  "registries": {
    "@private": {
      "url": "https://registry.company.com/{name}.json",
      "headers": {
        "Authorization": "Bearer ${REGISTRY_TOKEN}"
      }
    }
  }
}
```

```bash
# .env.local
REGISTRY_TOKEN=your_secret_token_here
```

### API Key in Headers

```json
{
  "registries": {
    "@company": {
      "url": "https://api.company.com/registry/{name}.json",
      "headers": {
        "X-API-Key": "${API_KEY}",
        "X-Workspace-Id": "${WORKSPACE_ID}"
      }
    }
  }
}
```

### Basic Authentication

```json
{
  "registries": {
    "@internal": {
      "url": "https://registry.company.com/{name}.json",
      "headers": {
        "Authorization": "Basic ${BASE64_CREDENTIALS}"
      }
    }
  }
}
```

### Query Parameter Authentication

```json
{
  "registries": {
    "@secure": {
      "url": "https://registry.example.com/{name}.json",
      "params": {
        "api_key": "${API_KEY}",
        "client_id": "${CLIENT_ID}",
        "signature": "${REQUEST_SIGNATURE}"
      }
    }
  }
}
```

Creates: `https://registry.example.com/button.json?api_key=...&client_id=...&signature=...`

### Multiple Authentication Methods

```json
{
  "registries": {
    "@enterprise": {
      "url": "https://api.enterprise.com/v2/registry/{name}",
      "headers": {
        "Authorization": "Bearer ${ACCESS_TOKEN}",
        "X-API-Key": "${API_KEY}",
        "X-Workspace-Id": "${WORKSPACE_ID}"
      },
      "params": {
        "version": "latest"
      }
    }
  }
}
```

### Multi-Registry Authentication

Mix public and private registries with different auth per namespace:

```json
{
  "registries": {
    "@public": "https://public.company.com/{name}.json",
    "@internal": {
      "url": "https://internal.company.com/{name}.json",
      "headers": {
        "Authorization": "Bearer ${INTERNAL_TOKEN}"
      }
    },
    "@premium": {
      "url": "https://premium.company.com/{name}.json",
      "headers": {
        "X-License-Key": "${LICENSE_KEY}"
      }
    }
  }
}
```

### Server-Side Implementation: Next.js

```typescript
// app/api/registry/[name]/route.ts
import { NextRequest, NextResponse } from "next/server"

export async function GET(
  request: NextRequest,
  { params }: { params: { name: string } }
) {
  // Get token from Authorization header.
  const authHeader = request.headers.get("authorization")
  const token = authHeader?.replace("Bearer ", "")

  // Or from query parameters.
  const queryToken = request.nextUrl.searchParams.get("token")

  // Check if token is valid.
  if (!isValidToken(token || queryToken)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  // Check if token can access this component.
  if (!hasAccessToComponent(token, params.name)) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 })
  }

  // Return the component.
  const component = await getComponent(params.name)
  return NextResponse.json(component)
}

function isValidToken(token: string | null) {
  // Add your token validation logic here.
  // Check against database, JWT validation, etc.
  return token === process.env.VALID_TOKEN
}

function hasAccessToComponent(token: string, componentName: string) {
  // Add role-based access control here.
  // Check if token can access specific component.
  return true // Your logic here.
}
```

### Server-Side Implementation: Express.js

```javascript
// server.js
app.get("/registry/:name.json", (req, res) => {
  const token = req.headers.authorization?.replace("Bearer ", "")

  if (!isValidToken(token)) {
    return res.status(401).json({ error: "Unauthorized" })
  }

  const component = getComponent(req.params.name)
  if (!component) {
    return res.status(404).json({ error: "Component not found" })
  }

  res.json(component)
})
```

### Custom Error Messages

Return context-specific error messages from your server:

```typescript
if (!token) {
  return NextResponse.json(
    {
      error: "Unauthorized",
      message:
        "Authentication required. Set REGISTRY_TOKEN in your .env.local file",
    },
    { status: 401 }
  )
}

if (isExpiredToken(token)) {
  return NextResponse.json(
    {
      error: "Unauthorized",
      message: "Token expired. Request a new token at company.com/tokens",
    },
    { status: 401 }
  )
}

if (!hasTeamAccess(token, component)) {
  return NextResponse.json(
    {
      error: "Forbidden",
      message: `Component '${component}' is restricted to the Design team`,
    },
    { status: 403 }
  )
}
```

### Testing Authentication

```bash
# Test with curl.
curl -H "Authorization: Bearer your_token" \
  https://registry.company.com/button.json

# Test with the CLI.
REGISTRY_TOKEN=your_token npx shadcn@latest add @private/button
```

### Security Best Practices

- Never commit tokens to version control. Always use `.env.local`.
- Always use HTTPS for registry URLs to protect tokens in transit.
- Rotate tokens regularly.
- Implement rate limiting on your registry server.
- Log access for security and analytics.
- Environment variables are never logged by the CLI, expanded only at runtime, and isolated per registry.

---

## MCP Server

The shadcn MCP (Model Context Protocol) Server allows AI assistants to browse, search, and install components from registries using natural language. It works out of the box with any shadcn-compatible registry.

### What is MCP?

[Model Context Protocol (MCP)](https://modelcontextprotocol.io) is an open protocol that enables AI assistants to securely connect to external data sources and tools. With the shadcn MCP server, your AI assistant gains direct access to:

- **Browse Components** — List all available components, blocks, and templates from any configured registry
- **Search Across Registries** — Find specific components by name or functionality across multiple sources
- **Install with Natural Language** — Add components using simple conversational prompts like "add a login form"
- **Support for Multiple Registries** — Access public registries, private company libraries, and third-party sources

### How It Works

The MCP server acts as a bridge between your AI assistant, component registries, and the shadcn CLI:

1. **Registry Connection** — MCP connects to configured registries (shadcn/ui, private registries, third-party sources)
2. **Natural Language** — You describe what you need in plain English
3. **AI Processing** — The assistant translates your request into registry commands
4. **Component Delivery** — Resources are fetched and installed in your project

### Quick Setup per Client

#### Claude Code

Run in your project:

```bash
npx shadcn@latest mcp init --client claude
```

Or manually add to `.mcp.json`:

```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

Restart Claude Code. Use `/mcp` command to debug.

#### Cursor

Run in your project:

```bash
npx shadcn@latest mcp init --client cursor
```

Or manually add to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

Open Cursor Settings and enable the MCP server for shadcn.

#### VS Code

Run in your project:

```bash
npx shadcn@latest mcp init --client vscode
```

Or manually add to `.vscode/mcp.json`:

```json
{
  "servers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

Open `.vscode/mcp.json` and click Start next to the shadcn server.

#### Codex

The CLI cannot automatically update `~/.codex/config.toml`. Add manually:

```bash
npx shadcn@latest mcp init --client codex
```

Then add to `~/.codex/config.toml`:

```toml
[mcp_servers.shadcn]
command = "npx"
args = ["shadcn@latest", "mcp"]
```

Restart Codex.

#### OpenCode

```bash
npx shadcn@latest mcp init --client opencode
```

Restart OpenCode.

### Configuring Registries for MCP

The MCP server reads from `components.json`. No configuration is needed for the standard shadcn/ui registry. Add custom registries:

```json
{
  "registries": {
    "@acme": "https://registry.acme.com/{name}.json",
    "@internal": {
      "url": "https://internal.company.com/{name}.json",
      "headers": {
        "Authorization": "Bearer ${REGISTRY_TOKEN}"
      }
    }
  }
}
```

### MCP Prerequisites for Registry Developers

The MCP server requests your registry index. Make sure you have a registry item file named `registry` at the root of your registry endpoint. For example, if hosted at `https://acme.com/r/[name].json`, serve `https://acme.com/r/registry.json`. This file must conform to the registry schema.

### Best Practices for MCP-Compatible Registries

1. Add concise, informative descriptions that help AI assistants understand what each item is for.
2. List all `dependencies` accurately so MCP can install them automatically.
3. Use `registryDependencies` to indicate relationships between items.
4. Use kebab-case for component names and maintain consistency.

### Troubleshooting

**MCP Not Responding:**
1. Verify the MCP server is properly configured and enabled.
2. Restart your MCP client after configuration changes.
3. Ensure `shadcn` is installed in your project.
4. Confirm network access to configured registries.

**No Tools or Prompts:**
1. Clear the npx cache: `npx clear-npx-cache`.
2. Re-enable the MCP server in your client.
3. In Cursor, check logs under View -> Output -> `MCP: project-*`.

**Registry Access Issues:**
1. Verify registry URLs in `components.json`.
2. Ensure environment variables are set for private registries.
3. Confirm the registry is online and accessible.
4. Ensure namespace syntax is correct (`@namespace/component`).

**Installation Failures:**
1. Check Project Setup — Ensure you have a valid `components.json` file.
2. Verify Paths — Confirm the target directories exist.
3. Check Permissions — Ensure write permissions for component directories.
4. Review Dependencies — Check that required dependencies are installed.

### Example Prompts

Once configured, use natural language to interact with registries:

**Browse & Search:**
- "Show me all available components in the shadcn registry"
- "Find me a login form from the shadcn registry"

**Install Items:**
- "Add the button component to my project"
- "Create a login form using shadcn components"
- "Install the Cursor rules from the acme registry"

**Work with Namespaces:**
- "Show me components from the acme registry"
- "Install @internal/auth-form"
- "Build me a landing page using hero, features and testimonials sections from the acme registry"

---

## Registry Examples

### registry:style — Extending shadcn/ui

A custom style that extends shadcn/ui. On `npx shadcn init`, it installs dependencies, adds blocks/components, sets theme variables, and installs custom colors:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "example-style",
  "type": "registry:style",
  "dependencies": ["@tabler/icons-react"],
  "registryDependencies": [
    "login-01",
    "calendar",
    "https://example.com/r/editor.json"
  ],
  "cssVars": {
    "theme": { "font-sans": "Inter, sans-serif" },
    "light": { "brand": "20 14.3% 4.1%" },
    "dark": { "brand": "20 14.3% 4.1%" }
  }
}
```

### registry:style — From Scratch

A custom style that doesn't extend shadcn/ui. Use `"extends": "none"` to create entirely new component sets:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "extends": "none",
  "name": "new-style",
  "type": "registry:style",
  "dependencies": ["tailwind-merge", "clsx"],
  "registryDependencies": [
    "utils",
    "https://example.com/r/button.json",
    "https://example.com/r/input.json"
  ],
  "cssVars": {
    "theme": { "font-sans": "Inter, sans-serif" },
    "light": { "main": "#88aaee", "bg": "#dfe5f2", "border": "#000", "text": "#000" },
    "dark": { "main": "#88aaee", "bg": "#272933", "border": "#000", "text": "#e6e6e6" }
  }
}
```

### registry:theme — Custom Theme

Override the default color scheme for your registry:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "custom-theme",
  "type": "registry:theme",
  "cssVars": {
    "light": {
      "background": "oklch(1 0 0)",
      "foreground": "oklch(0.141 0.005 285.823)",
      "primary": "oklch(0.546 0.245 262.881)",
      "primary-foreground": "oklch(0.97 0.014 254.604)",
      "ring": "oklch(0.746 0.16 232.661)"
    },
    "dark": {
      "background": "oklch(1 0 0)",
      "foreground": "oklch(0.141 0.005 285.823)",
      "primary": "oklch(0.707 0.165 254.624)",
      "primary-foreground": "oklch(0.97 0.014 254.604)",
      "ring": "oklch(0.707 0.165 254.624)"
    }
  }
}
```

### Install a Block and Override Primitives

Install a block from the shadcn/ui registry and override its primitives with custom ones:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "custom-login",
  "type": "registry:block",
  "registryDependencies": [
    "login-01",
    "https://example.com/r/button.json",
    "https://example.com/r/input.json",
    "https://example.com/r/label.json"
  ]
}
```

---

## Open in v0

If your registry is publicly accessible, open any registry item in v0 for AI-powered customization:

```
https://v0.dev/chat/api/open?url=[REGISTRY_ITEM_URL]
```

Example: `https://v0.dev/chat/api/open?url=https://ui.shadcn.com/r/styles/new-york/login-01.json`

**Limitations:** Open in v0 does NOT support `cssVars`, `css`, `envVars`, namespaced registries, or advanced authentication methods (Bearer tokens, API keys in headers).

### Open in v0 Authentication

Only query parameter authentication is supported:

```
https://registry.company.com/r/hello-world.json?token=your_secure_token_here
```

Server-side: check for `token` query parameter, validate it, return `401 Unauthorized` if invalid. Both the CLI and Open in v0 handle 401 responses gracefully.

### Open in v0 Button

```tsx
import { Button } from "@/components/ui/button"

export function OpenInV0Button({ url }: { url: string }) {
  return (
    <Button aria-label="Open in v0" asChild>
      <a href={`https://v0.dev/chat/api/open?url=${url}`} target="_blank" rel="noreferrer">
        Open in v0
      </a>
    </Button>
  )
}
```

---

## Registry FAQ

### Complex Component Structure

A complex component can install a page, multiple components, hooks, utils, and config files:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "hello-world",
  "type": "registry:block",
  "files": [
    { "path": "registry/new-york/hello-world/page.tsx", "type": "registry:page", "target": "app/hello/page.tsx" },
    { "path": "registry/new-york/hello-world/components/hello-world.tsx", "type": "registry:component" },
    { "path": "registry/new-york/hello-world/components/formatted-message.tsx", "type": "registry:component" },
    { "path": "registry/new-york/hello-world/hooks/use-hello.ts", "type": "registry:hook" },
    { "path": "registry/new-york/hello-world/lib/format-date.ts", "type": "registry:utils" },
    { "path": "registry/new-york/hello-world/hello.config.ts", "type": "registry:file", "target": "~/hello.config.ts" }
  ]
}
```

### Adding Tailwind Colors via Registry

Add colors to `cssVars` under `light` and `dark` keys. The CLI updates the project CSS file automatically:

```json
{
  "cssVars": {
    "light": { "brand-background": "20 14.3% 4.1%", "brand-accent": "20 14.3% 4.1%" },
    "dark": { "brand-background": "20 14.3% 4.1%", "brand-accent": "20 14.3% 4.1%" }
  }
}
```

Result: `bg-brand-background` and `text-brand-accent` become available as utility classes.

### Overriding Tailwind Theme Variables

Add or override theme variables via `cssVars.theme`:

```json
{
  "cssVars": {
    "theme": {
      "text-base": "3rem",
      "ease-in-out": "cubic-bezier(0.4, 0, 0.2, 1)",
      "font-heading": "Poppins, sans-serif"
    }
  }
}
```

---

## Community Registries (Directory)

Community registries are built into the CLI with no additional configuration. Install components with `npx shadcn add @<registry>/<component>`.

**Security warning:** Community registries are maintained by third-party developers. Always review code on installation to ensure it meets your security and quality standards.

Browse the full directory at `https://ui.shadcn.com/docs/registry`.

### Adding Your Registry to the Directory

1. Add your registry to `apps/v4/registry/directory.json` in the shadcn/ui repo.
2. Run `pnpm registry:build` to update `registries.json`.
3. Submit a pull request to `https://github.com/shadcn-ui/ui`.

Requirements:
- Must be open source and publicly accessible.
- Must be a valid JSON file conforming to the registry schema.
- Must be a flat registry (no nested items) — `/registry.json` and `/component-name.json` at the root.
- The `files` array must NOT include a `content` property.

---

## Contributing Blocks

Contribute components to the shadcn/ui blocks library by submitting pull requests.

### Workspace Setup

1. Fork and clone the repository:

```bash
git clone https://github.com/shadcn-ui/ui.git
```

2. Create a new branch:

```bash
git checkout -b username/my-new-block
```

3. Install dependencies:

```bash
pnpm install
```

4. Start the dev server:

```bash
pnpm www:dev
```

### Adding Blocks

1. Create a new folder in `apps/www/registry/new-york/blocks` using kebab-case:

```
apps
└── www
    └── registry
        └── new-york
            └── blocks
                └── dashboard-01
```

The build script handles building for the `default` style.

2. Add your block files:

```
dashboard-01
└── page.tsx
└── components
    └── hello-world.tsx
    └── example-card.tsx
└── hooks
    └── use-hello-world.ts
└── lib
    └── format-date.ts
```

3. Add the block definition to `registry-blocks.ts`:

```tsx
// apps/www/registry/registry-blocks.tsx
export const blocks = [
  {
    name: "dashboard-01",
    author: "shadcn (https://ui.shadcn.com)",
    title: "Dashboard",
    description: "A simple dashboard with a hello world component.",
    type: "registry:block",
    registryDependencies: ["input", "button", "card"],
    dependencies: ["zod"],
    files: [
      {
        path: "blocks/dashboard-01/page.tsx",
        type: "registry:page",
        target: "app/dashboard/page.tsx",
      },
      {
        path: "blocks/dashboard-01/components/hello-world.tsx",
        type: "registry:component",
      },
      {
        path: "blocks/dashboard-01/components/example-card.tsx",
        type: "registry:component",
      },
      {
        path: "blocks/dashboard-01/hooks/use-hello-world.ts",
        type: "registry:hook",
      },
      {
        path: "blocks/dashboard-01/lib/format-date.ts",
        type: "registry:lib",
      },
    ],
    categories: ["dashboard"],
  },
]
```

4. Run the build script:

```bash
pnpm registry:build
```

5. View your block at `http://localhost:3333/blocks/[CATEGORY]` or full-screen preview at `http://localhost:3333/view/styles/new-york/dashboard-01`.

### Adding a Category

Add new categories to `apps/www/registry/registry-categories.ts`:

```tsx
export const registryCategories = [
  {
    name: "Input",
    slug: "input",
    hidden: false,
  },
]
```

### Build and Publish

1. Run the build:

```bash
pnpm registry:build
```

2. Capture screenshots:

```bash
pnpm registry:capture
```

If screenshots already exist, delete existing screenshots (light and dark) at `apps/www/public/r/styles/new-york` and run again.

3. Commit and submit a pull request to the main repository.

### Guidelines

- Required properties: `name`, `description`, `type`, `files`, and `categories`.
- List all registry dependencies in `registryDependencies` (e.g. `input`, `button`, `card`).
- List all npm dependencies in `dependencies` (e.g. `zod`, `sonner`).
- If the block has a page, place it first in the `files` array with a `target` property for file-based routing.
- Imports must always use the `@/registry` path (e.g. `import { Input } from "@/registry/new-york/input"`).
- Add proper name and description to help LLMs understand the component.

---

## Open Source Registry Index

The open source registry index lists all public registries available out of the box. When running `shadcn add` or `shadcn search`, the CLI automatically checks this index.

View the full list at `https://ui.shadcn.com/r/registries.json`.

### Adding Your Registry to the Index

1. Add your registry to `apps/v4/registry/directory.json` in the shadcn/ui repo.
2. Run `pnpm registry:build` to update `registries.json`.
3. Submit a pull request to `https://github.com/shadcn-ui/ui`.

Requirements:
- The registry must be open source and publicly accessible.
- Must be a valid JSON file conforming to the registry schema.
- Must be a flat registry (no nested items) -- `/registry.json` and `/component-name.json` at the root.
- The `files` array must NOT include a `content` property.

Example valid registry for the index:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme",
  "homepage": "https://acme.com",
  "items": [
    {
      "name": "login-form",
      "type": "registry:component",
      "title": "Login Form",
      "description": "A login form component.",
      "files": [
        {
          "path": "registry/new-york/auth/login-form.tsx",
          "type": "registry:component"
        }
      ]
    }
  ]
}
```
