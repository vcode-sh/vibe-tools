# shadcn/ui Registry System — Core

Registry schema, getting started, item features, and namespaced registries. See `registry-advanced.md` for authentication, MCP, and contributing.

---

## Registry Overview

A registry consists of a `registry.json` file that defines all items, and individual registry item JSON files that conform to the `registry-item.json` schema. The CLI builds these files from your source code and serves them over HTTP.

### registry.json Schema

The `registry.json` is the entry point for the registry. It contains the registry's name, homepage, and defines all items. Your registry must have this file present at the root of the registry endpoint.

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme",
  "homepage": "https://acme.com",
  "items": [
    {
      "name": "hello-world",
      "type": "registry:block",
      "title": "Hello World",
      "description": "A simple hello world component.",
      "registryDependencies": [
        "button",
        "@acme/input-form",
        "https://example.com/r/foo"
      ],
      "dependencies": ["is-even@3.0.0", "motion"],
      "files": [
        {
          "path": "registry/new-york/hello-world/hello-world.tsx",
          "type": "registry:component"
        }
      ]
    }
  ]
}
```

Schema fields:

- `$schema` -- Points to `https://ui.shadcn.com/schema/registry.json` for validation.
- `name` -- The name of your registry. Used for data attributes and metadata.
- `homepage` -- The homepage URL of your registry.
- `items` -- Array of registry items. Each item must implement the registry-item schema.

### registry-item.json Schema

Each item in the registry conforms to the `registry-item.json` schema.

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "hello-world",
  "type": "registry:block",
  "title": "Hello World",
  "description": "A simple hello world component.",
  "registryDependencies": [
    "button",
    "@acme/input-form",
    "https://example.com/r/editor.json"
  ],
  "dependencies": ["is-even@3.0.0", "motion"],
  "files": [
    {
      "path": "registry/new-york/hello-world/hello-world.tsx",
      "type": "registry:component"
    },
    {
      "path": "registry/new-york/hello-world/use-hello-world.ts",
      "type": "registry:hook"
    }
  ],
  "cssVars": {
    "theme": {
      "font-heading": "Poppins, sans-serif"
    },
    "light": {
      "brand": "20 14.3% 4.1%"
    },
    "dark": {
      "brand": "20 14.3% 4.1%"
    }
  }
}
```

### Registry Item Types

| Type                 | Description                                      |
| -------------------- | ------------------------------------------------ |
| `registry:block`     | Use for complex components with multiple files.  |
| `registry:component` | Use for simple components.                       |
| `registry:lib`       | Use for lib and utils.                           |
| `registry:hook`      | Use for hooks.                                   |
| `registry:ui`        | Use for UI components and single-file primitives.|
| `registry:page`      | Use for page or file-based routes.               |
| `registry:file`      | Use for miscellaneous files.                     |
| `registry:style`     | Use for registry styles (e.g. `new-york`).       |
| `registry:theme`     | Use for themes.                                  |
| `registry:item`      | Use for universal registry items.                |

---

## Getting Started

### Create a registry.json File

Create a `registry.json` file in the root of your project. Your project can be Next.js, Vite, Vue, Svelte, PHP, or any framework that supports serving JSON over HTTP.

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme",
  "homepage": "https://acme.com",
  "items": []
}
```

### Create Your Component

Add your first component following the `registry/[NAME]` directory structure:

```tsx
// registry/new-york/hello-world/hello-world.tsx
import { Button } from "@/components/ui/button"

export function HelloWorld() {
  return <Button>Hello World</Button>
}
```

Directory structure:

```
registry
└── new-york
    └── hello-world
        └── hello-world.tsx
```

### Add the Component to the Registry

Add the component definition to `registry.json`:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme",
  "homepage": "https://acme.com",
  "items": [
    {
      "name": "hello-world",
      "type": "registry:block",
      "title": "Hello World",
      "description": "A simple hello world component.",
      "files": [
        {
          "path": "registry/new-york/hello-world/hello-world.tsx",
          "type": "registry:component"
        }
      ]
    }
  ]
}
```

### Build the Registry

Install the CLI, add a build script, and run it:

```bash
npm install shadcn@latest
```

```json
{
  "scripts": {
    "registry:build": "shadcn build"
  }
}
```

```bash
npm run registry:build
```

By default, the build script generates registry JSON files in `public/r` (e.g. `public/r/hello-world.json`). Change the output directory with the `--output` option.

### Serve the Registry

Start your dev server (e.g. `npm run dev` for Next.js). Files are served at `http://localhost:3000/r/[NAME].json` (e.g. `http://localhost:3000/r/hello-world.json`).

### Install Using the CLI

Install a registry item using the `shadcn` CLI with the `add` command and the URL:

```bash
npx shadcn@latest add http://localhost:3000/r/hello-world.json
```

---

## Registry Item Features

### Files and Targets

Each file in a registry item has a `path`, `type`, and optional `target` property. The `target` is required for `registry:page` and `registry:file` types.

```json
{
  "files": [
    {
      "path": "registry/new-york/hello-world/page.tsx",
      "type": "registry:page",
      "target": "app/hello/page.tsx"
    },
    {
      "path": "registry/new-york/hello-world/hello-world.tsx",
      "type": "registry:component"
    },
    {
      "path": "registry/new-york/hello-world/use-hello-world.ts",
      "type": "registry:hook"
    },
    {
      "path": "registry/new-york/hello-world/.env",
      "type": "registry:file",
      "target": "~/.env"
    }
  ]
}
```

- `path` -- Relative path to the file from the project root. Used by the build script to parse and build the registry JSON payload.
- `type` -- The type of file (see Registry Item Types table above).
- `target` -- Where the file should be placed in the consuming project. Use `~` to refer to the project root (e.g. `~/foo.config.js`). By default the CLI reads `components.json` to determine target paths.

### Dependencies

Use `dependencies` for npm packages. Use `@version` to pin versions:

```json
{
  "dependencies": [
    "@radix-ui/react-accordion",
    "zod",
    "lucide-react",
    "name@1.0.2"
  ]
}
```

### Registry Dependencies

Use `registryDependencies` for dependencies on other registry items. Supports names, namespaced items, and URLs:

```json
{
  "registryDependencies": [
    "button",
    "@acme/input-form",
    "https://example.com/r/editor.json"
  ]
}
```

- For shadcn/ui items: use the name (e.g. `"button"`, `"input"`, `"select"`).
- For namespaced items: use `@namespace/name` (e.g. `"@acme/input-form"`).
- For custom items: use the full URL (e.g. `"https://example.com/r/editor.json"`).

The CLI automatically resolves remote registry dependencies.

### tailwind (DEPRECATED)

**DEPRECATED:** Use `cssVars.theme` instead for Tailwind v4 projects. The `tailwind` property was used for Tailwind v3 configuration (theme extensions, plugins, content). It still works for backward compatibility:

```json
{
  "tailwind": {
    "config": {
      "theme": {
        "extend": {
          "colors": { "brand": "hsl(var(--brand))" },
          "keyframes": {
            "wiggle": {
              "0%, 100%": { "transform": "rotate(-3deg)" },
              "50%": { "transform": "rotate(3deg)" }
            }
          },
          "animation": { "wiggle": "wiggle 1s ease-in-out infinite" }
        }
      }
    }
  }
}
```

### CSS Variables

Use `cssVars` to define CSS variables. Supports `theme` (Tailwind v4 theme variables), `light`, and `dark` scopes:

```json
{
  "cssVars": {
    "theme": {
      "font-heading": "Poppins, sans-serif"
    },
    "light": {
      "brand": "20 14.3% 4.1%",
      "radius": "0.5rem"
    },
    "dark": {
      "brand": "20 14.3% 4.1%"
    }
  }
}
```

Override Tailwind CSS variables via `theme`:

```json
{
  "cssVars": {
    "theme": {
      "spacing": "0.2rem",
      "breakpoint-sm": "640px",
      "breakpoint-md": "768px",
      "breakpoint-lg": "1024px",
      "breakpoint-xl": "1280px",
      "breakpoint-2xl": "1536px"
    }
  }
}
```

### CSS Layers, Keyframes, Utilities, and Plugins

Use the `css` field to add rules to the project's CSS file -- `@layer base`, `@layer components`, `@utility`, `@keyframes`, `@plugin`, and `@import`:

```json
{
  "css": {
    "@plugin @tailwindcss/typography": {},
    "@plugin foo": {},
    "@layer base": {
      "body": {
        "font-size": "var(--text-base)",
        "line-height": "1.5"
      }
    },
    "@layer components": {
      "button": {
        "background-color": "var(--color-primary)",
        "color": "var(--color-white)"
      }
    },
    "@utility text-magic": {
      "font-size": "var(--text-base)",
      "line-height": "1.5"
    },
    "@keyframes wiggle": {
      "0%, 100%": {
        "transform": "rotate(-3deg)"
      },
      "50%": {
        "transform": "rotate(3deg)"
      }
    }
  }
}
```

### Custom Animations

Define both `@keyframes` in `css` and the animation variable in `cssVars.theme`:

```json
{
  "cssVars": {
    "theme": {
      "--animate-wiggle": "wiggle 1s ease-in-out infinite"
    }
  },
  "css": {
    "@keyframes wiggle": {
      "0%, 100%": {
        "transform": "rotate(-3deg)"
      },
      "50%": {
        "transform": "rotate(3deg)"
      }
    }
  }
}
```

### CSS Imports

Use `@import` in `css` to add CSS imports (placed at the top of the CSS file):

```json
{
  "css": {
    "@import \"tailwindcss\"": {},
    "@import \"./styles/base.css\"": {},
    "@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap\")": {}
  }
}
```

Import with media queries:

```json
{
  "css": {
    "@import \"print-styles.css\" print": {},
    "@import url(\"mobile.css\") screen and (max-width: 768px)": {}
  }
}
```

### Plugins

Use `@plugin` in `css` for Tailwind plugins. When using npm packages, also add them to `dependencies`:

```json
{
  "dependencies": ["@tailwindcss/typography", "@tailwindcss/forms", "tw-animate-css"],
  "css": {
    "@plugin \"@tailwindcss/typography\"": {},
    "@plugin \"@tailwindcss/forms\"": {},
    "@plugin \"tw-animate-css\"": {}
  }
}
```

Plugins are automatically grouped, deduplicated, and ordered (imports first, then plugins, then other CSS content).

### Combined Imports and Plugins

```json
{
  "dependencies": ["@tailwindcss/typography", "tw-animate-css"],
  "css": {
    "@import \"tailwindcss\"": {},
    "@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap\")": {},
    "@plugin \"@tailwindcss/typography\"": {},
    "@plugin \"tw-animate-css\"": {},
    "@layer base": {
      "body": {
        "font-family": "Inter, sans-serif"
      }
    },
    "@utility content-auto": {
      "content-visibility": "auto"
    }
  }
}
```

### Environment Variables

Use `envVars` to add environment variables. They are written to `.env.local` or `.env`. Existing variables are not overwritten.

```json
{
  "envVars": {
    "NEXT_PUBLIC_APP_URL": "http://localhost:4000",
    "DATABASE_URL": "postgresql://postgres:postgres@localhost:5432/postgres",
    "OPENAI_API_KEY": ""
  }
}
```

IMPORTANT: Use `envVars` for development or example variables only. Do NOT use it for production variables.

### Docs

Use `docs` to show a custom message when installing via the CLI:

```json
{
  "docs": "To get an OPENAI_API_KEY, sign up for an account at https://platform.openai.com."
}
```

### Categories and Meta

```json
{
  "categories": ["sidebar", "dashboard"],
  "meta": { "foo": "bar" }
}
```

### Author

```json
{
  "author": "John Doe <john@doe.com>"
}
```

### Universal Items

As of v2.9.0, create universal items that install without framework detection or `components.json`. All files in the item must have an explicit `target`.

Cursor rules example:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "python-rules",
  "type": "registry:item",
  "files": [
    {
      "path": "/path/to/your/registry/default/custom-python.mdc",
      "type": "registry:file",
      "target": "~/.cursor/rules/custom-python.mdc",
      "content": "..."
    }
  ]
}
```

ESLint config example:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "my-eslint-config",
  "type": "registry:item",
  "files": [
    {
      "path": "/path/to/your/registry/default/custom-eslint.json",
      "type": "registry:file",
      "target": "~/.eslintrc.json",
      "content": "..."
    }
  ]
}
```

Multi-file universal item:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "my-custom-start-template",
  "type": "registry:item",
  "dependencies": ["better-auth"],
  "files": [
    {
      "path": "/path/to/file-01.json",
      "type": "registry:file",
      "target": "~/file-01.json",
      "content": "..."
    },
    {
      "path": "/path/to/file-02.vue",
      "type": "registry:file",
      "target": "~/pages/file-02.vue",
      "content": "..."
    }
  ]
}
```

---

## Namespaced Registries

Namespaced registries let you configure multiple resource sources in one project. Install components, libraries, utilities, AI prompts, configuration files, and other resources from various registries. Namespaces are prefixed with `@`.

Examples:
- `@shadcn/button` -- UI component from the shadcn registry
- `@v0/dashboard` -- Dashboard component from the v0 registry
- `@acme/auth-utils` -- Authentication utilities from a private registry

The namespace system is intentionally decentralized. There is a central open source registry index for open source namespaces, but you are free to create and use any namespace.

### Basic Configuration

Add registries to `components.json` using URL template strings:

```json
{
  "registries": {
    "@v0": "https://v0.dev/chat/b/{name}",
    "@acme": "https://registry.acme.com/resources/{name}.json",
    "@lib": "https://lib.company.com/utilities/{name}",
    "@ai": "https://ai-resources.com/r/{name}.json"
  }
}
```

The `{name}` placeholder is replaced with the resource name when you run `npx shadcn@latest add @namespace/resource-name`. For example, `@acme/button` becomes `https://registry.acme.com/resources/button.json`.

### Advanced Configuration

For registries requiring authentication or additional parameters, use the object format:

```json
{
  "registries": {
    "@private": {
      "url": "https://api.company.com/registry/{name}.json",
      "headers": {
        "Authorization": "Bearer ${REGISTRY_TOKEN}",
        "X-API-Key": "${API_KEY}"
      },
      "params": {
        "version": "latest",
        "format": "json"
      }
    }
  }
}
```

Environment variables in the format `${VAR_NAME}` are automatically expanded from `process.env` at runtime. This works in URLs, headers, and params.

### URL Placeholders

**`{name}` (required)** -- Replaced with the resource name:

```json
{
  "@acme": "https://registry.acme.com/{name}.json"
}
```

`@acme/button` resolves to `https://registry.acme.com/button.json`.

**`{style}` (optional)** -- Replaced with the current style configuration:

```json
{
  "@themes": "https://registry.example.com/{style}/{name}.json"
}
```

With style set to `new-york`, `@themes/card` resolves to `https://registry.example.com/new-york/card.json`.

### Organization Patterns

By resource type:

```json
{
  "@components": "https://cdn.company.com/components/{name}.json",
  "@hooks": "https://cdn.company.com/hooks/{name}.json",
  "@utils": "https://cdn.company.com/utils/{name}.json",
  "@prompts": "https://cdn.company.com/ai-prompts/{name}.json"
}
```

By team:

```json
{
  "@design": "https://create.company.com/registry/{name}.json",
  "@engineering": "https://eng.company.com/registry/{name}.json",
  "@marketing": "https://marketing.company.com/registry/{name}.json"
}
```

By stability:

```json
{
  "@stable": "https://registry.company.com/stable/{name}.json",
  "@latest": "https://registry.company.com/beta/{name}.json",
  "@experimental": "https://registry.company.com/experimental/{name}.json"
}
```

### Naming Convention

Registry names must:
- Start with `@`
- Contain only alphanumeric characters, hyphens, and underscores
- Follow the pattern `@namespace/resource-name`

Valid examples: `@v0`, `@acme-ui`, `@my_company`.

### CLI Commands

```bash
# Install from a specific registry
npx shadcn@latest add @v0/dashboard

# Install multiple resources
npx shadcn@latest add @acme/button @lib/utils @ai/prompt

# Install from URL directly
npx shadcn@latest add https://registry.example.com/button.json

# Install from local file
npx shadcn@latest add ./local-registry/button.json

# Inspect a resource before installing
npx shadcn@latest view @acme/button

# Search a registry
npx shadcn@latest search @v0

# Search with query
npx shadcn@latest search @acme --query "auth"

# List all items
npx shadcn@latest list @acme
```

### Dependency Resolution

Resources can have cross-registry dependencies:

```json
{
  "name": "dashboard",
  "type": "registry:block",
  "registryDependencies": [
    "@shadcn/card",
    "@v0/chart",
    "@acme/data-table",
    "@lib/data-fetcher"
  ]
}
```

Resolution process:
1. Clear registry context to start fresh.
2. Fetch the main resource from the specified registry.
3. Recursively resolve dependencies from their respective registries.
4. Apply topological sorting for proper installation order.
5. Deduplicate files based on target paths (last one wins).
6. Deep merge configurations (tailwind, cssVars, css, envVars).

### Versioning

Implement versioning using query parameters:

```json
{
  "@versioned": {
    "url": "https://registry.example.com/{name}",
    "params": {
      "version": "v2"
    }
  }
}
```

Resolves `@versioned/button` to `https://registry.example.com/button?version=v2`.

Use environment variables for dynamic versions:

```json
{
  "@stable": {
    "url": "https://registry.company.com/{name}",
    "params": {
      "version": "${REGISTRY_VERSION}"
    }
  }
}
```

---
