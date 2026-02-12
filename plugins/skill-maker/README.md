# skill-maker

Create, review, test, and package high-quality Anthropic Agent Skills for Claude.ai and Claude Code.

## Features

- **Beginner tutorial** (`/sm:learn`) - Hands-on guide to build your first skill with explanations at every step
- **Interactive wizard** (`/sm:create`) - Step-by-step guided skill creation with validation at each stage
- **Quick generation** (`/sm:quick`) - Describe what you want, get a complete skill generated at once
- **Quality audit** (`/sm:review`) - Comprehensive review with scoring for description quality, triggers, structure
- **Auto-fix** (`/sm:fix`) - Automatically fix quality issues found during review
- **Trigger testing** (`/sm:test`) - Generate triggering tests, functional tests, and performance baselines
- **Iterative improvement** (`/sm:improve`) - Refine skills based on real-world feedback and test results
- **Template browser** (`/sm:template`) - 8 pre-built templates covering all skill categories
- **Structural validation** (`/sm:validate`) - Quick pass/fail check for YAML, naming, file structure
- **Distribution packaging** (`/sm:package`) - Package as zip for Claude.ai or scaffold a Claude Code plugin
- **Interactive reference** (`/sm:docs`) - Ask questions about skill best practices, get answers with examples
- **Skill builder agent** - Autonomous agent for complex multi-file skill creation

## Commands

| Command | Description | Best For |
|---------|-------------|----------|
| `/sm:learn` | Beginner tutorial - build your first skill hands-on | New users |
| `/sm:create` | Interactive wizard - guided creation step-by-step | Most users |
| `/sm:quick` | Quick generation from a brief description | Power users |
| `/sm:template` | Browse and apply 8 pre-built templates | All users |
| `/sm:review` | Full quality audit of an existing skill | Quality check |
| `/sm:test` | Generate trigger, functional, and performance tests | Testing |
| `/sm:fix` | Auto-fix issues found in review | Quick fixes |
| `/sm:improve` | Iterative improvement from real-world feedback | Refinement |
| `/sm:validate` | Quick structural validation check | Fast check |
| `/sm:package` | Package for Claude.ai or Claude Code distribution | Distribution |
| `/sm:docs` | Interactive reference - 15 topics with examples | Learning |

## Getting Started

**New to skills?** Start with the beginner tutorial:
```
/sm:learn
```

**Know what you want?** Jump straight to creating:
```
/sm:create
```

**Have an idea, want it fast?** Use quick generation:
```
/sm:quick Generate changelog entries from git commits
```

## Recommended Workflow

```
1. /sm:learn     → Learn the basics (first time only)
2. /sm:create    → Build your skill with guidance
   or /sm:template → Start from a pre-built template
3. /sm:validate  → Quick structural check
4. /sm:test      → Generate and verify test cases
5. /sm:review    → Full quality audit
6. /sm:fix       → Auto-fix any issues
7. /sm:improve   → Refine based on real-world usage
8. /sm:package   → Package for distribution
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
