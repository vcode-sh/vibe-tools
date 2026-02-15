# skill-maker

Create, review, test, and package high-quality Anthropic Agent Skills for Claude.ai and Claude Code.

## Features

- **From documentation** (`/skill-maker:from-docs`) - Analyze a folder of docs and auto-generate a comprehensive skill
- **From project** (`/skill-maker:from-project`) - Scan your codebase and create a skill from code patterns and conventions
- **Beginner tutorial** (`/skill-maker:learn`) - Hands-on guide to build your first skill with explanations at every step
- **Interactive wizard** (`/skill-maker:create`) - Step-by-step guided skill creation with validation at each stage
- **Quick generation** (`/skill-maker:quick`) - Describe what you want, get a complete skill generated at once
- **Quality audit** (`/skill-maker:review`) - Comprehensive review with scoring for description quality, triggers, structure
- **Auto-fix** (`/skill-maker:fix`) - Automatically fix quality issues found during review
- **Trigger testing** (`/skill-maker:test`) - Generate triggering tests, functional tests, and performance baselines
- **Iterative improvement** (`/skill-maker:improve`) - Refine skills based on real-world feedback and test results
- **Template browser** (`/skill-maker:template`) - 8 pre-built templates covering all skill categories
- **Structural validation** (`/skill-maker:validate`) - Quick pass/fail check for YAML, naming, file structure
- **Distribution packaging** (`/skill-maker:package`) - Package as zip for Claude.ai or scaffold a Claude Code plugin
- **Interactive reference** (`/skill-maker:docs`) - Ask questions about skill best practices, get answers with examples
- **Skill builder agent** - Autonomous agent for complex multi-file skill creation

## Commands

| Command | Description | Best For |
|---------|-------------|----------|
| `/skill-maker:from-docs` | Create skill from a documentation folder | Package/API docs |
| `/skill-maker:from-project` | Create skill from project codebase analysis | Project conventions |
| `/skill-maker:learn` | Beginner tutorial - build your first skill hands-on | New users |
| `/skill-maker:create` | Interactive wizard - guided creation step-by-step | Most users |
| `/skill-maker:quick` | Quick generation from a brief description | Power users |
| `/skill-maker:template` | Browse and apply 8 pre-built templates | All users |
| `/skill-maker:review` | Full quality audit of an existing skill | Quality check |
| `/skill-maker:test` | Generate trigger, functional, and performance tests | Testing |
| `/skill-maker:fix` | Auto-fix issues found in review | Quick fixes |
| `/skill-maker:improve` | Iterative improvement from real-world feedback | Refinement |
| `/skill-maker:validate` | Quick structural validation check | Fast check |
| `/skill-maker:package` | Package for Claude.ai or Claude Code distribution | Distribution |
| `/skill-maker:docs` | Interactive reference - 15 topics with examples | Learning |

## Getting Started

**Have documentation?** Create a skill from it:
```
/skill-maker:from-docs ./path/to/docs/
```

**Have a project?** Create a skill from your code patterns:
```
/skill-maker:from-project ./my-app websocket
/skill-maker:from-project ./my-app --full
```

**New to skills?** Start with the beginner tutorial:
```
/skill-maker:learn
```

**Know what you want?** Jump straight to creating:
```
/skill-maker:create
```

## Recommended Workflow

```
1. /skill-maker:learn        → Learn the basics (first time only)
2. /skill-maker:from-docs    → Create skill from existing documentation
   or /skill-maker:from-project → Create skill from your codebase
   or /skill-maker:create    → Build your skill with guidance
   or /skill-maker:template  → Start from a pre-built template
3. /skill-maker:validate     → Quick structural check
4. /skill-maker:test         → Generate and verify test cases
5. /skill-maker:review       → Full quality audit
6. /skill-maker:fix          → Auto-fix any issues
7. /skill-maker:improve      → Refine based on real-world usage
8. /skill-maker:package      → Package for distribution
```

## Templates

8 pre-built templates covering the major skill categories:

1. **Standalone Document/Asset** - Reports, code, designs without external tools
2. **Workflow Automation** - Multi-step processes with validation gates
3. **MCP Basic** - Single MCP server workflow enhancement
4. **Multi-MCP Coordination** - Cross-service orchestration
5. **Iterative Refinement** - Review-and-refine quality loops
6. **Context-Aware Selection** - Smart routing based on input characteristics
7. **Domain Intelligence** - Compliance, industry rules, expert knowledge
8. **Code Generation** - Framework-specific code patterns

## Installation

### As a Claude Code plugin

```bash
claude --plugin-dir /path/to/skill-maker
```

### From the vibe-tools marketplace

The plugin is available in the [vibe-tools marketplace](https://github.com/vcode-sh/vibe-tools).

## License

MIT
