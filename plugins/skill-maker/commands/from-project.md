---
description: Create a skill by analyzing your project's codebase - code patterns, APIs, dependencies, conventions
argument-hint: [path to project] [optional: focus topic like "websocket" or "auth"] [optional: --full for complete scan]
---

# Create Skill from Project Analysis

Analyze a user's project codebase and create a skill that teaches Claude the project's conventions, patterns, and implementation details. Future conversations with this skill loaded will have Claude work consistently with the project's established patterns.

## Input

The user provides: `$ARGUMENTS`

Parse the input:
- **Path**: Project directory (default: current directory `.`)
- **Focus topic** (optional): Specific implementation to focus on (e.g., "websocket", "auth", "api", "database", "resend", "stripe")
- **`--full` flag** (optional): Scan the entire project comprehensively instead of focusing on one topic

**Examples:**
- `/sm:from-project ./my-app websocket` → Focused scan of WebSocket implementation
- `/sm:from-project ./my-app --full` → Full project scan
- `/sm:from-project` → Scan current directory, ask for focus topic

If no focus topic and no `--full` flag, ask:
"What should the skill focus on? Options:
1. A specific implementation (type a keyword: websocket, auth, api, etc.)
2. Full project scan (all conventions and patterns)"

## Mode 1: Focused Scan (Default)

Analyze a specific implementation within the project.

### Step 1: Project Context

Read essential project files first:
- `package.json` / `requirements.txt` / `go.mod` / `Cargo.toml` / `composer.json` (dependencies)
- `tsconfig.json` / `pyproject.toml` / config files (project settings)
- `.env.example` / `.env.local` (environment variables, NOT .env itself)
- `README.md` (project description)
- Directory structure overview (Glob for top-level + key subdirectories)

Present project overview:
```
PROJECT CONTEXT: [project name]
════════════════════════════════

Language: [detected]
Framework: [detected]
Key dependencies: [top 10 relevant]
Structure: [brief tree]
```

### Step 2: Focused Discovery

Use Grep and Glob to find all files related to the focus topic:

**For "websocket":**
- Grep for: `WebSocket`, `ws://`, `wss://`, `socket.io`, `onmessage`, `onopen`, `onclose`, `useWebSocket`
- Glob for: `**/ws/**`, `**/socket/**`, `**/websocket/**`

**For "auth":**
- Grep for: `auth`, `login`, `session`, `jwt`, `token`, `middleware`, `passport`, `clerk`, `nextauth`, `lucia`
- Glob for: `**/auth/**`, `**/middleware/**`, `**/session/**`

**For "api":**
- Grep for: `router`, `endpoint`, `handler`, `controller`, `route`, `fetch(`, `axios`
- Glob for: `**/api/**`, `**/routes/**`, `**/controllers/**`

**For "database"/"db":**
- Grep for: `prisma`, `drizzle`, `mongoose`, `sequelize`, `knex`, `sql`, `query`, `schema`, `migration`
- Glob for: `**/db/**`, `**/models/**`, `**/schema/**`, `**/migrations/**`

**For any package name** (e.g., "resend", "stripe"):
- Grep for the package name across all files
- Read the package's entry in dependencies
- Find all import/require statements for it
- Read every file that imports it

Present discovery results:
```
FOCUSED SCAN: [topic] in [project]
═══════════════════════════════════

Files found: [X] files matching [topic]
Key files:
  - [path/to/main-file.ts] (primary implementation)
  - [path/to/config.ts] (configuration)
  - [path/to/types.ts] (types/interfaces)
  - [path/to/tests/] ([X] test files)
```

### Step 3: Deep Code Analysis

Read every discovered file and extract:

**Architecture Patterns:**
- File/folder organization for this feature
- Module structure and exports
- Dependency injection patterns
- Error boundary placement

**Code Patterns:**
- Naming conventions (camelCase, snake_case, prefixes)
- Function signatures and parameter patterns
- Return types and response formats
- Async/await patterns
- State management approach

**API Integration:**
- How external APIs are called
- Authentication/header patterns
- Request/response handling
- Retry and timeout patterns
- Rate limiting approach

**Error Handling:**
- Try/catch patterns used
- Error types and custom errors
- Error propagation (throw vs return)
- Logging patterns
- User-facing error messages

**Configuration:**
- Environment variables used
- Config file patterns
- Feature flags
- Default values

**Testing Patterns:**
- Test framework and conventions
- Test file naming and location
- Mock/stub patterns
- Test data patterns
- Coverage expectations

**Type System** (if TypeScript/typed language):
- Interface/type definitions
- Generic patterns
- Enum usage
- Utility types

## Mode 2: Full Project Scan (`--full`)

Analyze the entire project comprehensively.

### Step 1: Project Overview
Same as Focused Step 1, but also:
- Read ALL config files
- Map the complete directory tree
- Identify ALL major features/modules
- Detect CI/CD configuration
- Read linting/formatting configs

### Step 2: Architecture Analysis

Analyze the full project structure:
- **Layer architecture**: API routes → services → repositories → models
- **Module boundaries**: How features are organized
- **Shared code**: Utilities, helpers, common patterns
- **Entry points**: Main files, route handlers, event handlers

### Step 3: Cross-Cutting Concerns

Analyze patterns that span the entire project:
- **Authentication & Authorization** across all routes
- **Error handling** consistency
- **Logging** patterns and levels
- **Validation** approach (Zod, Joi, manual)
- **Database access** patterns
- **Caching** strategy
- **Environment configuration**
- **Testing** conventions

### Step 4: Dependency Analysis

For each significant dependency:
- How it's configured
- How it's used across the project
- Version constraints
- Custom wrappers or abstractions built on top

## Skill Generation (Both Modes)

### Naming
- Focused: `[project]-[topic]-patterns` (e.g., `myapp-websocket-patterns`)
- Full: `[project]-conventions` (e.g., `myapp-conventions`)
- Present 3 options, let user choose

### YAML Frontmatter

```yaml
---
name: [skill-name]
description: [Project] [topic] implementation patterns and conventions. Use when working on [project] [topic] code, creating new [topic] features, or debugging [topic] issues. Covers [pattern 1], [pattern 2], [pattern 3] following established project conventions.
metadata:
  author: [user]
  version: 1.0.0
  source: project-analysis
  source-project: [project path]
  framework: [detected framework]
  language: [detected language]
  category: project-conventions
  tags: [project, topic, framework, language]
---
```

### SKILL.md Body Structure

**For Focused Scan:**
1. **Overview** - What this implementation does in the project
2. **Architecture** - How files are organized for this feature
3. **Core Patterns** - The main code patterns to follow (with code examples from the actual project)
4. **API/Integration** - How external services are called
5. **Configuration** - Environment vars and config needed
6. **Error Handling** - How errors are handled in this area
7. **Testing** - How to test this feature (patterns from existing tests)
8. **Rules** - Critical conventions that MUST be followed
9. **Anti-Patterns** - What NOT to do (from code review observations)

**For Full Scan:**
1. **Project Overview** - Architecture, stack, key decisions
2. **Directory Convention** - Where files go and why
3. **Code Style** - Naming, formatting, import ordering
4. **Core Patterns** - Common patterns across the codebase
5. **API Patterns** - Route handling, middleware, responses
6. **Database Patterns** - Query patterns, migrations, schemas
7. **Error Handling** - Project-wide error handling approach
8. **Testing Conventions** - Test structure, mocking, assertions
9. **Configuration** - Env vars, feature flags, secrets
10. **Rules** - Non-negotiable project conventions

### Reference Files

**Focused:**
- `references/code-examples.md` - All extracted code patterns with file paths
- `references/api-reference.md` - API surface for this feature (if applicable)
- `references/testing-patterns.md` - Test examples from the project

**Full:**
- `references/architecture.md` - Detailed architecture documentation
- `references/patterns.md` - All code patterns with examples
- `references/api-reference.md` - Full API documentation
- `references/testing.md` - Testing conventions and examples
- `references/configuration.md` - All config options and env vars

## Code Examples Rule

When including code examples from the project:
- Use ACTUAL code from the project (not invented examples)
- Include the file path as reference: `// From: src/lib/websocket.ts`
- Show the pattern, not the entire file
- Highlight the convention being demonstrated
- If code has issues, note them but show the actual pattern used

## Save and Validate

1. Ask user for save location
2. Create directory structure and write all files
3. Run auto-validation
4. Present results:

```
SKILL CREATED FROM PROJECT ANALYSIS
════════════════════════════════════

Source: [project path]
Mode: [Focused: topic] / [Full scan]
Skill: [skill-name]/

Analysis summary:
  - [X] files analyzed
  - [X] code patterns extracted
  - [X] API endpoints documented
  - [X] test patterns captured
  - [X] configuration items documented

Files created:
  SKILL.md                      [X] words
  references/code-examples.md   [X] words
  references/api-reference.md   [X] words
  references/testing-patterns.md [X] words

Validation: [Grade]

How this skill helps:
  - New [topic] features will follow established patterns
  - Error handling stays consistent with project conventions
  - Tests follow the existing testing approach
  - Configuration and env vars are documented

Next steps:
  /sm:test [skill-path]    → Verify triggers
  /sm:review [skill-path]  → Quality audit
```

## Important Rules

- NEVER include secrets, API keys, tokens, or .env contents in the skill
- Use .env.example or document env var NAMES only (not values)
- Include file paths for all code examples (traceability)
- If the project has inconsistent patterns, document the dominant pattern and note the inconsistency
- If critical security issues are found during analysis, warn the user
- For very large projects (1000+ files), recommend focused scans over full scans
