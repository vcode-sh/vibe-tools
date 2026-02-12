---
description: Quickly generate a complete skill from a brief description
argument-hint: [describe what the skill should do]
---

# Quick Skill Generation

Generate a complete, ready-to-use skill from the user's description with minimal interaction. This is the power-user mode.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask: "Describe what the skill should do in 1-2 sentences."

## Generation Process

From the description, infer:
1. **Skill name**: kebab-case, 2-4 words, descriptive
2. **Category**: Document/Asset, Workflow, or MCP Enhancement
3. **Trigger phrases**: 3-5 phrases users would say
4. **Key capabilities**: What the skill enables
5. **Workflow steps**: The main process
6. **Supporting files needed**: references, scripts, assets

## Output

Generate the complete skill in one pass:

### 1. Create YAML Frontmatter
- `name`: inferred from description
- `description`: `[What] + [When/Triggers] + [Capabilities]`
- Add relevant metadata (category, tags)

### 2. Write SKILL.md Body
- Purpose statement
- Core workflow (3-5 steps with validation)
- Rules and constraints
- Examples
- Error handling
- Reference links (if supporting files created)

### 3. Create Supporting Files (if needed)
- `references/` for detailed documentation
- `scripts/` for utilities
- `assets/` for templates

## Save Location

Ask the user where to save. If no preference, offer:
1. `./[skill-name]/` (current directory)
2. `./skills/[skill-name]/` (skills directory)

## Auto-Validate

After saving, run quick validation:
- Structure check (SKILL.md, folder name)
- Frontmatter check (YAML valid, fields present)
- Description quality (triggers present, specific enough)
- Body check (imperative form, reasonable length)

Present results in compact format:
```
[skill-name] created at [path]
Structure: OK | Frontmatter: OK | Description: 8/10 | Body: OK
Grade: [A-F]
```

If issues found, fix automatically and report.

## Quality Standards
- Frontmatter description MUST include 3+ trigger phrases
- SKILL.md body MUST be in imperative form
- Keep under 3,000 words ideally (5,000 max)
- Include at least one example
