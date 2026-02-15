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

Run quick validation first (same as `/skill-maker:validate`).
If critical issues found, warn the user and offer to fix before packaging.

## Step 2: Choose Target

Ask the user:
```
Package target:
1. Claude.ai (zip file for upload)
2. Claude Code plugin (plugin scaffold)
3. Both
```

## Step 3: Project Scan & Output Location

Before packaging, scan the project to suggest the best output location.

### 3a: Project Discovery

Scan the working directory and surrounding project structure:
- Read `package.json`, `pyproject.toml`, `composer.json`, or similar manifest (if present)
- Glob for existing skill-related directories: `**/skills/`, `**/*-plugin/`, `**/.claude-plugin/`
- Glob for existing zip packages: `**/*.zip` matching skill patterns
- Check for common project structures: `src/`, `dist/`, `build/`, `output/`, `packages/`
- Note the current working directory and the skill source location

### 3b: Suggest Output Location

Present a summary of what was found and suggest locations:

```
PROJECT SCAN: [project name or cwd]
═══════════════════════════════════

[If relevant structures found:]
Detected:
  - Skills directory: ./skills/ (contains X skills)
  - Plugin directory: ./plugins/ (contains Y plugins)
  - Existing packages: ./dist/skill-name.zip

[If nothing specific found:]
No existing skill/plugin directories detected.
```

Then ask where to save the packaged output. Build the options dynamically based on what was found:

**For Claude.ai (zip):**
```
Where should I save the zip package?
1. [Detected path, e.g., ./dist/skill-name.zip] (Recommended — existing packages here)
2. Same directory as source skill: [source-parent]/[skill-name].zip
3. Current directory: ./[skill-name].zip
4. Custom path
```

**For Claude Code (plugin scaffold):**
```
Where should I create the plugin scaffold?
1. [Detected path, e.g., ./plugins/skill-name-plugin/] (Recommended — existing plugins here)
2. Next to source skill: [source-parent]/[skill-name]-plugin/
3. Current directory: ./[skill-name]-plugin/
4. Custom path
```

**Rules for suggestions:**
- If a `plugins/` directory exists with other `.claude-plugin/` manifests, suggest it first as recommended
- If a `skills/` directory exists, suggest the parent of that directory
- If existing `.zip` skill packages are found, suggest the same directory
- If nothing is detected, suggest current directory as recommended
- Always include the custom path option
- For "Both" target, ask once with combined options or ask separately per target

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
3. Save the zip to the location chosen in Step 3
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

1. Create a plugin scaffold at the location chosen in Step 3:
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

Run both packaging processes. Save outputs to the locations chosen in Step 3.

## Pre-Distribution Checklist

Before packaging, verify:
- [ ] Skill passes /skill-maker:validate with no critical issues
- [ ] /skill-maker:test trigger tests show 90%+ accuracy
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

Claude.ai:   [chosen-path]/[skill-name].zip (X KB)
Claude Code:  [chosen-path]/[skill-name]-plugin/ (Y files)

Next steps:
- Test locally before distributing
- Run /skill-maker:test to verify trigger accuracy
- Consider hosting on GitHub for sharing
- Add to a marketplace if available

Distribution tips:
- Write README focusing on outcomes, not features
- Include example usage and screenshots
- Provide a quick-start guide (3 steps max)
- For MCP skills: document required environment and auth setup
```
