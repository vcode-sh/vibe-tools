---
description: Create a skill by analyzing a folder of documentation - package docs, API references, guides
argument-hint: [path to documentation folder]
---

# Create Skill from Documentation

Analyze an entire documentation folder and generate a comprehensive skill that teaches Claude how to use the documented package, service, or framework.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Provide the path to the documentation folder you want to turn into a skill."

## Supported Formats

Scan for these file types (in priority order):
- `.md`, `.mdx` - Markdown documentation (primary)
- `.txt` - Plain text documentation
- `.rst` - reStructuredText (Python docs)
- `.json` - OpenAPI/Swagger specifications, configuration schemas
- `.yaml`, `.yml` - API specs, configuration references

## Phase 1: Discovery Scan

Use Glob to map the entire documentation structure:

```
1. Glob for all supported file types recursively
2. Count total files and estimate total content size
3. Build a hierarchy map:
   docs/
   ├── getting-started/     → Onboarding content
   ├── api/                  → API reference
   ├── guides/               → Tutorials and how-tos
   ├── examples/             → Code examples
   └── reference/            → Configuration/spec reference
```

Present the scan results to the user:
```
DOCUMENTATION SCAN: [folder name]
══════════════════════════════════

Files found: [X] files across [Y] directories
Formats: [list detected formats]
Estimated size: [X] words / [Y] pages

Structure:
[hierarchy map]

Detected topics:
- [Topic 1] ([X] files)
- [Topic 2] ([X] files)
- [Topic 3] ([X] files)
```

Ask: "I found [X] documentation files. Should I analyze all of them, or focus on specific sections?"

## Phase 2: Deep Analysis

Read every documentation file systematically. For each file, extract:

### Package/Service Identity
- Name, version, purpose
- Target audience
- Platform/language requirements

### API Surface
- Endpoints / methods / functions
- Parameters and types
- Authentication requirements
- Rate limits and quotas
- Response formats

### Workflows and Patterns
- Getting started / setup flow
- Common usage patterns (ordered by frequency in docs)
- Integration patterns
- Migration guides (if present)

### Configuration
- Environment variables
- Configuration files and their schemas
- Default values and required vs optional settings

### Code Examples
- Extract all code blocks with their context
- Identify the language/framework
- Note which examples are most referenced

### Best Practices
- Explicitly stated best practices
- Anti-patterns and warnings
- Performance tips
- Security considerations

### Error Handling
- Common errors and their causes
- Error codes and messages
- Troubleshooting steps
- FAQ items

### Dependencies and Prerequisites
- Required packages/tools
- Version constraints
- Platform requirements

## Phase 3: Skill Architecture

Based on the analysis, determine the skill structure:

### Naming
- Derive skill name from package/service name
- Format: `[package]-guide` or `[service]-workflow`
- Present 3 options to the user

### Content Distribution (Progressive Disclosure)

Decide what goes where:

**SKILL.md (Level 2)** - under 3,000 words:
- Purpose and scope
- Core workflow (most common use case from docs)
- Essential API/configuration reference
- Quick-start pattern
- Key rules and constraints
- Most common error handling

**references/ (Level 3)** - detailed content:
- `api-reference.md` - Full API surface extracted from docs
- `configuration.md` - All configuration options
- `patterns.md` - All usage patterns and code examples
- `troubleshooting.md` - All errors, FAQs, debugging
- `advanced.md` - Advanced topics, migrations, performance (if applicable)

### Description Construction

Build trigger phrases from:
- The package/service name itself
- Action verbs from the docs ("deploy", "configure", "create")
- Domain keywords from the docs
- Common user questions the docs answer

## Phase 4: Generate the Skill

### Write YAML Frontmatter

```yaml
---
name: [package]-guide
description: [Purpose from docs]. Use when user asks to "[action 1] with [package]", "[action 2] [package]", "configure [package]", "[package] [common task]", or asks about [package] [domain keywords]. Covers [key capability 1], [key capability 2], and [key capability 3].
metadata:
  author: [user or default]
  version: 1.0.0
  source: documentation-analysis
  source-docs: [original docs path]
  category: [inferred category]
  tags: [extracted tags]
---
```

### Write SKILL.md Body

Structure:
1. **Purpose** - What this package/service does (from docs intro)
2. **Quick Start** - Fastest path to first use (from getting-started docs)
3. **Core Workflow** - Most common usage pattern
4. **Essential API** - Most-used endpoints/methods (top 5-10)
5. **Configuration** - Required settings and common options
6. **Key Rules** - Critical constraints, gotchas, and warnings from docs
7. **Common Errors** - Top 3-5 errors and their fixes
8. **Reference Files** - Links to detailed references/

### Write Reference Files

For each reference file:
- Extract relevant content from analyzed docs
- Organize by topic, not by source file
- Include all code examples with context
- Add cross-references between files

## Phase 5: Validate and Save

1. Ask user for save location (default: `./{skill-name}/`)
2. Create directory structure
3. Write all files
4. Run auto-validation
5. Present results:

```
SKILL CREATED FROM DOCUMENTATION
═════════════════════════════════

Source: [docs folder] ([X] files analyzed)
Skill: [skill-name]/

Files created:
  SKILL.md               [X] words (core skill)
  references/api.md      [X] words (API reference)
  references/config.md   [X] words (configuration)
  references/patterns.md [X] words (usage patterns)
  references/errors.md   [X] words (troubleshooting)

Validation: [Grade]
Trigger phrases: [list key triggers]

Key coverage:
  - [X] API endpoints/methods documented
  - [X] code examples preserved
  - [X] configuration options captured
  - [X] error patterns documented

Next steps:
  /skill-maker:test [skill-path]    → Verify triggers work
  /skill-maker:review [skill-path]  → Full quality audit
```

## Quality Rules

- Never invent information not in the original docs
- Preserve all code examples exactly as written
- Attribute patterns to their source (e.g., "from the Authentication guide")
- If docs are incomplete or unclear, note it in the skill with TODO markers
- If docs are very large (100+ files), suggest splitting into multiple focused skills
- Always include the source docs path in metadata for traceability

## Special Handling

### OpenAPI/Swagger (.json/.yaml)
- Parse the API specification
- Extract endpoints, parameters, response schemas
- Generate human-readable API reference in references/api.md
- Create workflow examples from common endpoint combinations

### Code-Heavy Documentation
- Extract code examples and group by language
- Identify patterns across examples
- Create a references/examples.md with all code blocks organized by topic
