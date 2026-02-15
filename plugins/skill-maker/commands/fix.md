---
description: Automatically fix quality issues in an existing skill
argument-hint: [path to skill folder or SKILL.md]
---

# Auto-Fix Skill Issues

Automatically review and fix quality issues in an existing skill. Runs a full review first, then applies fixes.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Which skill should I fix? Provide the path to the skill folder or SKILL.md file."

## Process

### 1. Run Review

Perform the same comprehensive review as `/skill-maker:review`:
- Read SKILL.md and all supporting files
- Assess structure, frontmatter, description, body, triggering

### 2. Identify Fixable Issues

Categorize findings:

**Auto-fixable:**
- Missing `---` delimiters in frontmatter
- Name field doesn't match folder name
- Description missing trigger phrases (can add based on body content)
- Passive voice in instructions (can convert to imperative)
- Missing error handling sections
- Files not referenced from SKILL.md

**Requires user input:**
- Skill purpose unclear
- Wrong category/approach
- Missing use cases
- Fundamental restructuring needed

### 3. Apply Fixes

For each auto-fixable issue:
1. Show the current state (before)
2. Show the proposed fix (after)
3. Apply the fix using Edit tool

For issues requiring user input:
- Explain the issue
- Ask the user for guidance
- Apply their decision

### 4. Report

After all fixes applied, show:
```
FIXES APPLIED: [skill-name]
═══════════════════════════

Fixed:
- [Fix 1]: [what was changed]
- [Fix 2]: [what was changed]
- [Fix 3]: [what was changed]

Skipped (needs user input):
- [Issue 1]: [why it needs input]

Before: Grade [X] → After: Grade [Y]
```

### 5. Re-Validate

Run the full validation again to confirm all fixes worked.
Present the updated scores.

## Fix Categories

### Frontmatter Fixes
- Add missing `---` delimiters
- Convert name to kebab-case
- Strengthen description with trigger phrases
- Add missing metadata fields
- Remove XML angle brackets

### Body Fixes
- Convert passive voice to imperative form
- Add missing purpose statement
- Add error handling section
- Add example section if missing
- Link unreferenced supporting files
- Split over-long content to references/

### Structure Fixes
- Rename folder to kebab-case
- Remove README.md if present inside skill folder
- Create missing referenced files (empty templates)

## Rules
- Never delete user content, only modify/enhance
- Always show before/after for each change
- Ask before making structural changes (moving files, splitting content)
- Preserve the user's original intent and workflow
