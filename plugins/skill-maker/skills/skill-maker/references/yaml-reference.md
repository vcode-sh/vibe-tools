# YAML Frontmatter Reference

Complete reference for all YAML frontmatter fields in SKILL.md.

## Required Fields

### name
- **Type**: string
- **Format**: kebab-case only
- **Rules**:
  - Lowercase letters, numbers, hyphens only
  - Must match the skill folder name
  - No spaces, underscores, or capitals
  - Cannot start with "claude" or "anthropic" (reserved)
  - Maximum recommended: 30 characters

**Valid examples:**
```yaml
name: project-planner
name: code-review-helper
name: sentry-integration
```

**Invalid examples:**
```yaml
name: My Cool Skill        # spaces and capitals
name: project_planner      # underscores
name: claude-helper         # reserved prefix
name: REVIEW               # all caps
```

### description
- **Type**: string
- **Format**: One or more sentences
- **Rules**:
  - Must include WHAT the skill does
  - Must include WHEN to use it (trigger conditions)
  - Should include KEY capabilities
  - No XML angle brackets (`< >`)
  - Recommended: 30-100 words

**Structure**: `[What it does] + [When to use it] + [Key capabilities]`

**Good example:**
```yaml
description: Analyzes Figma design files and generates developer handoff documentation. Use when user uploads .fig files, asks for "design specs", "component documentation", or "design-to-code handoff". Supports multiple export formats and responsive breakpoints.
```

## Optional Fields

### license
- **Type**: string
- **Values**: Any SPDX identifier (MIT, Apache-2.0, GPL-3.0, etc.)
```yaml
license: MIT
```

### allowed-tools
- **Type**: string (space-separated)
- **Purpose**: Restrict which tools the skill can use
- **Format**: Tool names with optional patterns
```yaml
allowed-tools: "Bash(python:*) Bash(npm:*) WebFetch Read Write"
```

### compatibility
- **Type**: string
- **Limit**: 1-500 characters
- **Purpose**: Indicate environment requirements
```yaml
compatibility: "Requires Python 3.10+ and Node.js 18+"
```

### metadata
- **Type**: object (key-value pairs)
- **Purpose**: Custom fields for categorization, authorship, etc.
```yaml
metadata:
  author: Your Name
  version: 1.0.0
  mcp-server: linear-mcp
  category: productivity
  tags: [project-management, automation, linear]
  documentation: https://example.com/docs
  support: support@example.com
```

## Security Rules

| Rule | Details |
|------|---------|
| No XML brackets | `< >` forbidden in all frontmatter fields |
| No code execution | YAML values must be static strings/numbers/lists |
| Reserved names | "claude" and "anthropic" prefixes forbidden in name |
| No secrets | Never include API keys, tokens, or passwords |

## Complete Example

```yaml
---
name: sprint-planner
description: Plans and manages sprint workflows in Linear. Use when user says "plan sprint", "create sprint tasks", "sprint planning", or "organize backlog". Handles velocity analysis, task prioritization, and automatic task creation.
license: MIT
allowed-tools: "Read Write WebFetch"
compatibility: "Requires Linear MCP server connected"
metadata:
  author: Dev Team
  version: 2.1.0
  mcp-server: linear
  category: project-management
  tags: [linear, sprint, agile, planning]
---
```

## Validation Rules

1. Frontmatter MUST start with `---` on line 1
2. Frontmatter MUST end with `---` on its own line
3. All fields must be valid YAML
4. No tabs for indentation (use spaces)
5. Strings with special characters should be quoted
6. Lists can use `[item1, item2]` or multi-line `- item` format
