# Skill Troubleshooting Guide

Common problems and solutions when building and deploying skills.

## Upload Issues

### "Could not find SKILL.md in uploaded folder"

**Cause**: File not named exactly `SKILL.md` (case-sensitive).

**Fix**:
- Rename to `SKILL.md` (not skill.md, Skill.md, or SKILL.MD)
- Verify: the file must be at `skill-folder/SKILL.md`, not nested deeper

### "Invalid frontmatter"

**Cause**: YAML formatting error.

**Common mistakes:**
```yaml
# WRONG - missing delimiters
name: my-skill
description: Does things

# WRONG - unclosed quotes
---
name: my-skill
description: "Does things
---

# WRONG - tabs instead of spaces
---
name: my-skill
description:
	- First item
---

# CORRECT
---
name: my-skill
description: Does things
---
```

### "Invalid skill name"

**Cause**: Name has spaces, capitals, or underscores.

```yaml
# WRONG
name: My Cool Skill
name: my_cool_skill
name: MyCoolSkill

# CORRECT
name: my-cool-skill
```

### "Skill name is reserved"

**Cause**: Name starts with "claude" or "anthropic".

```yaml
# WRONG
name: claude-helper
name: anthropic-tools

# CORRECT
name: ai-helper
name: code-tools
```

---

## Triggering Issues

### Skill never loads automatically

**Diagnosis**: Description is too vague or missing trigger phrases.

**Fix**:
1. Ask Claude: "When would you use the [skill-name] skill?"
2. Claude will quote the description - check what's missing
3. Add specific trigger phrases users would actually say

**Before:**
```yaml
description: Helps with projects.
```

**After:**
```yaml
description: Manages project setup and configuration. Use when user says "create project", "set up workspace", "initialize project", or asks about "project structure". Handles directory creation, config files, and dependency setup.
```

### Skill triggers too often (over-triggering)

**Fix**: Add negative triggers and narrow scope.

```yaml
description: Advanced data analysis for CSV files. Use for statistical modeling, regression, and clustering. Do NOT use for simple data exploration or visualization (use data-viz skill instead).
```

### Skill triggers for wrong queries

**Fix**: Be more specific about the domain.

```yaml
# Too broad
description: Processes documents

# Specific
description: Processes PDF legal documents for contract review and clause extraction
```

---

## Instruction Issues

### Claude doesn't follow skill instructions

**Common causes and fixes:**

1. **Instructions too verbose** - Keep SKILL.md under 5,000 words. Move details to references/
2. **Critical rules buried** - Put important rules at the TOP with `## Critical` headers
3. **Ambiguous language** - Be specific:

```markdown
# BAD
Make sure to validate things properly

# GOOD
CRITICAL: Before creating the project, verify:
- Project name is non-empty and kebab-case
- At least one team member is assigned
- Start date is not in the past
```

4. **Instructions too passive** - Use imperative form:

```markdown
# BAD
The report should be generated with a summary section

# GOOD
Generate the report. Include a summary section at the top.
```

### Claude skips steps in workflow

**Fix**: Add explicit validation gates between steps.

```markdown
#### Step 1: Fetch Data
- Call the API to get project data
- VERIFY: Response contains at least 1 project. If empty, inform user and stop.

#### Step 2: Process (only after Step 1 verified)
- Transform the data...
```

### Claude uses wrong tool

**Fix**: Specify exact tool names in instructions.

```markdown
# BAD
Save the file

# GOOD
Use the Write tool to save the output to `./output/report.md`
```

---

## Performance Issues

### Skill seems slow or responses degraded

**Causes**:
- SKILL.md too large (over 5,000 words)
- Too many skills enabled simultaneously
- All content inline instead of in references/

**Solutions**:
1. Move detailed docs to `references/` and link from SKILL.md
2. Disable unneeded skills
3. Keep SKILL.md focused on core workflow

### Skill consumes too many tokens

**Fix**: Apply progressive disclosure:
- Level 1 (frontmatter): Minimal trigger info
- Level 2 (SKILL.md body): Core workflow only
- Level 3 (references/): Detailed specs, loaded only when needed

---

## MCP-Related Issues

### MCP tools fail when called from skill

**Checklist**:
1. MCP server connected (Settings > Extensions)
2. Authentication valid and not expired
3. Tool names match exactly (check MCP docs)
4. Required permissions/scopes granted

**Test**: Try calling MCP directly without skill:
"Use [Service] MCP to fetch my projects"

### Inconsistent MCP results

**Fix**: Add explicit parameter instructions:

```markdown
# BAD
Fetch the project data

# GOOD
Call `get_project` with parameters:
- project_id: [from user or previous step]
- include_tasks: true
- status_filter: "active"
```

---

## Quick Diagnostic Flowchart

```
Problem?
├── Won't upload → Check SKILL.md name, YAML format, folder name
├── Won't trigger → Check description triggers, specificity
├── Triggers too much → Add negative triggers, narrow scope
├── Instructions ignored → Check verbosity, placement, clarity
├── MCP fails → Check connection, auth, tool names
└── Slow/degraded → Move content to references/, reduce scope
```
