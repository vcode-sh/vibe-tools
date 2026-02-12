---
description: Interactive wizard to create a new Anthropic Agent Skill step-by-step
argument-hint: [skill purpose or leave empty for guided mode]
---

# Create a New Skill (Interactive Wizard)

Guide the user through creating a complete, high-quality Anthropic Agent Skill. Follow each step and validate before moving to the next.

## Step 1: Use Case Definition

Ask the user:
1. "What should this skill do? Describe the main purpose in 1-2 sentences."
2. "Give me 2-3 concrete use cases. What would a user say to trigger this skill?"
3. "Does this skill need external tools (MCP servers)? If yes, which services?"

Based on answers, determine the skill category:
- **Document/Asset Creation** - Produces output (docs, code, designs)
- **Workflow Automation** - Multi-step processes
- **MCP Enhancement** - Adds expertise to MCP tool access

## Step 2: Name and Frontmatter

Generate a skill name:
- kebab-case, descriptive, 2-4 words
- Present 3 options to the user, let them pick or suggest their own
- Verify: no spaces, no capitals, no underscores, no "claude"/"anthropic"

Generate the YAML frontmatter:
- Write a strong `description` following the pattern: `[What it does] + [When to use it] + [Key capabilities]`
- Include at least 3 specific trigger phrases from the user's use cases
- Add optional fields if relevant (license, metadata, allowed-tools, compatibility)

Present the frontmatter to the user for review. Adjust if needed.

## Step 3: SKILL.md Body

Write the SKILL.md body:
- Start with a clear purpose statement
- Structure instructions in imperative form
- Include all workflow steps with validation gates
- Add examples of expected inputs and outputs
- Keep under 3,000 words ideally (5,000 max) - plan references/ files for detailed content
- Add error handling for common failure modes

If the skill needs supporting files:
- Plan what goes in `references/` (detailed docs, API guides)
- Plan what goes in `scripts/` (executable utilities)
- Plan what goes in `assets/` (templates, static resources)

## Step 4: Supporting Files

Create all planned supporting files:
- Write each reference document
- Create any scripts (with shebang lines)
- Add any asset files

## Step 5: Save the Skill

Ask the user where to save:
- "Where should I save this skill? Options:"
  1. Current directory: `./[skill-name]/`
  2. Skills directory: `./skills/[skill-name]/`
  3. Home: `~/skills/[skill-name]/`
  4. Custom path

If no preference, default to current directory.

Create the full directory structure and write all files using the Write tool.

## Step 6: Auto-Validate

After saving, run through the quality checklist:
- Check SKILL.md exists and is properly named
- Validate YAML frontmatter format and required fields
- Assess description quality (triggers, specificity)
- Check body structure (imperative form, under 5k words)
- Verify supporting files are referenced

Present validation results:
```
Validation Results:
- Structure: PASS/FAIL
- Frontmatter: PASS/FAIL
- Description: PASS/FAIL (score: X/10)
- Body Quality: PASS/FAIL
- References: PASS/FAIL
Overall: [Grade A-F]
```

If any issues found, offer to fix them automatically.

## Tips
- Read the skill-maker skill for full best practices
- Consult `references/quality-checklist.md` for the complete checklist
- If the user wants an MCP-enhanced skill, consult `references/mcp-patterns.md`
