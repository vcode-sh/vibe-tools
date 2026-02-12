---
description: Package a skill for distribution - Claude.ai zip or Claude Code plugin scaffold
argument-hint: [path to skill folder]
---

# Package Skill for Distribution

Package an existing skill for distribution on Claude.ai, Claude Code, or both.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Which skill should I package? Provide the path to the skill folder."

## Step 1: Pre-Package Validation

Run quick validation first (same as `/sm:validate`).
If critical issues found, warn the user and offer to fix before packaging.

## Step 2: Choose Target

Ask the user:
```
Package target:
1. Claude.ai (zip file for upload)
2. Claude Code plugin (plugin scaffold)
3. Both
```

## Option 1: Claude.ai Package

1. Verify the skill folder structure is correct
2. Create a zip file containing the skill folder:
   ```
   skill-name/
   ├── SKILL.md
   ├── references/
   ├── scripts/
   └── assets/
   ```
3. Save as `[skill-name].zip` in the current directory
4. Provide upload instructions:
   ```
   Upload to Claude.ai:
   1. Go to Settings > Capabilities > Skills
   2. Click "Upload skill"
   3. Select [skill-name].zip
   4. Toggle the skill ON
   5. Test: Ask Claude "[trigger phrase]"
   ```

## Option 2: Claude Code Plugin

1. Create a plugin scaffold around the skill:
   ```
   skill-name-plugin/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── skills/
   │   └── skill-name/
   │       ├── SKILL.md
   │       ├── references/
   │       ├── scripts/
   │       └── assets/
   └── README.md
   ```

2. Generate plugin.json:
   ```json
   {
     "name": "[skill-name]",
     "version": "1.0.0",
     "description": "[from SKILL.md description]",
     "author": { "name": "[ask user]" },
     "keywords": ["[from metadata tags]"],
     "license": "[from SKILL.md or MIT]"
   }
   ```

3. Generate README.md with:
   - Plugin description
   - Installation instructions
   - Usage examples
   - Trigger phrases

4. Provide installation instructions:
   ```
   Install in Claude Code:
   claude --plugin-dir /path/to/skill-name-plugin
   ```

## Option 3: Both

Run both packaging processes. Save outputs to:
- `./[skill-name].zip` (Claude.ai)
- `./[skill-name]-plugin/` (Claude Code)

## Pre-Distribution Checklist

Before packaging, verify:
- [ ] Skill passes /sm:validate with no critical issues
- [ ] /sm:test trigger tests show 90%+ accuracy
- [ ] At least one functional test passes
- [ ] Description focuses on OUTCOMES, not implementation details
- [ ] Version number set in metadata (if applicable)

## Positioning Guidance

When writing the README or marketplace description, focus on outcomes:

**Good**: "Set up complete project workspaces in seconds - including pages, databases, and templates - instead of spending 30 minutes on manual setup."

**Bad**: "A folder containing YAML frontmatter and Markdown instructions that calls MCP server tools."

If the skill enhances an MCP server, highlight both:
"Our MCP server gives Claude access to your [Service]. This skill teaches Claude your team's [workflow]. Together, they enable [outcome]."

## Post-Package

Present summary:
```
PACKAGED: [skill-name]
═══════════════════════

Claude.ai:   [skill-name].zip (X KB)
Claude Code:  [skill-name]-plugin/ (Y files)

Next steps:
- Test locally before distributing
- Run /sm:test to verify trigger accuracy
- Consider hosting on GitHub for sharing
- Add to a marketplace if available

Distribution tips:
- Write README focusing on outcomes, not features
- Include example usage and screenshots
- Provide a quick-start guide (3 steps max)
- For MCP skills: document required environment and auth setup
```
