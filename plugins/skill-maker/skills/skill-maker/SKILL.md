---
name: skill-maker
description: Create, review, test, and package Anthropic Agent Skills for Claude.ai and Claude Code. Use when user asks to "create a skill", "build a skill", "generate SKILL.md", "review my skill", "test my skill", "improve my skill", "create skill from documentation", "create skill from project", "analyze docs and make a skill", "scan my project for patterns", "package skill for distribution", "learn about skills", or asks about skill best practices, trigger phrases, or MCP-enhanced skills. Key capabilities: create skills from documentation folders, create skills from project codebases, interactive wizard, beginner tutorial, quick generation, 8 templates, quality auditing, trigger testing, iterative improvement, and distribution packaging. Do NOT use for general YAML editing, resume skills, or non-Anthropic skill systems.
---

# Skill Maker

Create high-quality Anthropic Agent Skills following official best practices. Generate properly structured SKILL.md files with YAML frontmatter, supporting references, scripts, and assets.

## Core Concepts

### What is a Skill?

A skill is a folder containing instructions that teach Claude to handle specific tasks. Structure:

```
skill-name/
├── SKILL.md              # Required - main skill file
├── scripts/              # Optional - executable code
├── references/           # Optional - documentation
└── assets/               # Optional - templates, icons
```

### Progressive Disclosure (Three Levels)

1. **YAML frontmatter** - Always in system prompt. Determines WHEN skill loads.
2. **SKILL.md body** - Loaded when relevant. Contains full instructions.
3. **Linked files** - Loaded on demand. Detailed references, scripts, assets.

### Composability

Claude can load multiple skills simultaneously. Design skills to:
- Work alongside other skills without conflict
- Not assume they are the only loaded capability
- Have clearly bounded scope with negative triggers if needed
- Reference other skills by name when handoff is appropriate

### Design Approach

Choose your starting point:
- **Problem-first**: "Users need to onboard customers" → design the ideal workflow → select tools
- **Tool-first**: "We have Linear MCP connected" → design workflows that leverage the tools

Problem-first produces more user-centric skills. Tool-first maximizes existing infrastructure.

## Skill Creation Workflow

### Step 1: Define Use Cases

Identify 2-3 concrete use cases before writing anything:

```
Use Case: [Name]
Trigger: User says "[phrase 1]" or "[phrase 2]"
Steps: 1. ... 2. ... 3. ...
Result: [Expected outcome]
```

### Step 2: Write YAML Frontmatter

Required fields:

```yaml
---
name: skill-name-in-kebab-case
description: What it does. Use when user asks to [triggers]. Key capabilities: [list].
---
```

Rules:
- `name`: kebab-case only, must match folder name, no "claude" or "anthropic"
- `description`: MUST include WHAT it does + WHEN to use (trigger phrases) + KEY capabilities
- No XML angle brackets (`< >`) in frontmatter
- Use `---` delimiters (both opening and closing)

Optional fields:

```yaml
license: MIT
allowed-tools: "Bash(python:*) WebFetch"
compatibility: "Requires Python 3.10+"
metadata:
  author: Your Name
  version: 1.0.0
  mcp-server: server-name
  category: productivity
  tags: [tag1, tag2]
```

### Step 3: Write SKILL.md Body

Structure the body with clear sections:

1. **Purpose statement** - One paragraph explaining what the skill does
2. **Core instructions** - Step-by-step workflow in imperative form
3. **Rules and constraints** - Critical requirements, validation rules
4. **Examples** - Show expected inputs and outputs
5. **References** - Link to files in references/ for detailed content

Writing guidelines:
- Use imperative form ("Generate the report", not "The report should be generated")
- Keep under 3,000 words ideally. Absolute maximum 5,000 words - move details to references/
- Put critical instructions at the top with `## Important` or `## Critical` headers
- Use bullet points and numbered lists for clarity
- Be specific and actionable ("Validate name is non-empty" instead of "validate things properly")

### Step 4: Create Supporting Files

**references/** - Detailed documentation too long for SKILL.md:
- API guides, configuration references, pattern libraries
- Name descriptively: `api-guide.md`, `examples.md`, `patterns.md`

**scripts/** - Executable code:
- Validation scripts, data processing, utilities
- Include shebang lines and make executable

**assets/** - Static resources (templates, fonts, icons):
- Use `assets/` for static resources consumed by output
- Use `templates/` as an alternative when providing fill-in-the-blank starting points

### Step 5: Validate

Run through the quality checklist (see `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/references/quality-checklist.md`).

## Error Handling

When creating skills, handle these common issues:
- **Ambiguous user request**: Ask clarifying questions about purpose, target audience, and trigger phrases before generating
- **File write failures**: Verify the target directory exists and is writable before creating files
- **Invalid user-provided YAML**: Validate YAML syntax before writing. Common issues: tabs instead of spaces, unclosed quotes, missing delimiters
- **Overly broad scope**: If the user's description covers too many use cases, suggest splitting into multiple focused skills

## Description Writing Guide

The description field is the MOST important part. It determines when the skill loads.

**Structure**: `[What it does] + [When to use it] + [Key capabilities]`

**Good examples:**

```
Analyzes Figma design files and generates developer handoff documentation. Use when user uploads .fig files, asks for "design specs", "component documentation", or "design-to-code handoff".
```

```
Manages Linear project workflows including sprint planning, task creation, and status tracking. Use when user mentions "sprint", "Linear tasks", "project planning", or asks to "create tickets".
```

**Bad examples:**

```
# Too vague - won't trigger correctly
Helps with projects.

# Missing triggers - Claude won't know WHEN to load
Creates sophisticated multi-page documentation systems.

# Too technical - no user-facing triggers
Implements the Project entity model with hierarchical relationships.
```

**Anti-over-triggering**: Add negative triggers if needed:

```
Advanced data analysis for CSV files. Use for statistical modeling, regression. Do NOT use for simple data exploration (use data-viz skill instead).
```

## Skill Categories

### Category 1: Document & Asset Creation

Skills that produce consistent, high-quality output (documents, code, designs).

Key techniques:
- Embedded style guides and brand standards
- Template structures for consistent output
- Quality checklists before finalizing
- No external tools required

### Category 2: Workflow Automation

Multi-step processes benefiting from consistent methodology.

Key techniques:
- Step-by-step workflow with validation gates
- Templates for common structures
- Built-in review and improvement suggestions
- Iterative refinement loops

### Category 3: MCP Enhancement

Workflow guidance enhancing MCP tool access.

Key techniques:
- Coordinates multiple MCP calls in sequence
- Embeds domain expertise
- Provides context users would otherwise need to specify
- Error handling for common MCP issues

For detailed MCP patterns, see references/mcp-patterns.md.

## File Structure Rules

- **SKILL.md**: Must be exactly `SKILL.md` (case-sensitive)
- **Folder naming**: kebab-case only (e.g., `my-cool-skill`)
- **No README.md** inside skill folder
- **No spaces, underscores, or capitals** in folder name

## Output Location

When generating a skill:
1. Ask the user where to save it
2. If no preference given, offer options:
   - Current directory: `./skill-name/`
   - Dedicated skills directory: `./skills/skill-name/`
   - Home directory: `~/skills/skill-name/`
3. Create the directory structure and write all files

## Packaging for Distribution

### For Claude.ai

1. Create the skill folder with SKILL.md and supporting files
2. Zip the folder
3. User uploads via Settings > Capabilities > Skills

### For Claude Code

1. Create skill within a plugin structure:
   ```
   plugin-name/
   ├── .claude-plugin/plugin.json
   └── skills/skill-name/SKILL.md
   ```
2. Optionally add commands, agents, hooks

### For API

Skills require the Code Execution Tool beta. Include `compatibility` field noting this.

## Example: Complete Skill Creation

**User says:** "Create a skill that generates changelog entries from git commits"

**Resulting structure:**
```
changelog-generator/
├── SKILL.md
└── references/
    └── commit-patterns.md
```

**Resulting frontmatter:**
```yaml
---
name: changelog-generator
description: Generates formatted changelog entries from git commit history. Use when user asks to "generate changelog", "create release notes", "summarize commits", or "write changelog entry". Supports conventional commits, semantic versioning, and grouped entries by type.
---
```

**Resulting body structure:**
- Purpose statement about changelog generation
- Workflow: analyze commits, categorize changes, format entries
- Rules: conventional commit parsing, version grouping, date formatting
- Examples: sample input commits and output changelog
- Error handling: non-standard commit messages, empty ranges

## Reference Files

- `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/references/quality-checklist.md` - Complete validation checklist
- `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/references/mcp-patterns.md` - MCP integration patterns with examples
- `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/references/yaml-reference.md` - Full YAML frontmatter field reference
- `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/references/troubleshooting.md` - Common issues and solutions
- `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/templates/` - 8 pre-built skill templates (stored as `templates/` since they are fill-in-the-blank starting points, not static resources)
