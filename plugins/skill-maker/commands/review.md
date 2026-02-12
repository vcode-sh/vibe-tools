---
description: Review and audit an existing skill for quality, triggers, and best practices
argument-hint: [path to skill folder or SKILL.md]
---

# Skill Quality Review

Perform a comprehensive audit of an existing skill and provide actionable improvement recommendations.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Which skill should I review? Provide the path to the skill folder or SKILL.md file."

## Review Process

### 1. Read the Skill

Read SKILL.md and all supporting files:
- `SKILL.md` - main file
- `references/` - all files
- `scripts/` - all files
- `assets/` - list files

### 2. Structure Assessment

Check:
- [ ] SKILL.md exists (exact name, case-sensitive)
- [ ] Folder name is kebab-case
- [ ] Folder name matches `name` field
- [ ] No README.md inside skill folder
- [ ] No XML angle brackets in any file
- [ ] Supporting files are referenced from SKILL.md

Score: X/6

### 3. Frontmatter Assessment

Check:
- [ ] Has `---` delimiters (opening and closing)
- [ ] `name` field present and valid kebab-case
- [ ] `description` field present
- [ ] Description includes WHAT (purpose)
- [ ] Description includes WHEN (trigger phrases)
- [ ] Description has 3+ specific trigger phrases
- [ ] No reserved name prefixes
- [ ] Optional fields properly formatted

Score: X/8

### 4. Description Quality Assessment

Evaluate the description on a 1-10 scale:

| Criteria | Score | Notes |
|----------|-------|-------|
| Clarity (what it does) | /3 | |
| Trigger accuracy (when to load) | /3 | |
| Specificity (not too broad/narrow) | /2 | |
| Negative triggers (if needed) | /1 | |
| Completeness | /1 | |
| **Total** | **/10** | |

### 5. Body Quality Assessment

Check:
- [ ] Has clear purpose statement at top
- [ ] Instructions in imperative form
- [ ] Under 3,000 words ideally (5,000 max)
- [ ] Critical instructions near the top
- [ ] Uses bullet/numbered lists
- [ ] Specific, actionable instructions
- [ ] Error handling included
- [ ] Examples provided
- [ ] References linked where appropriate

Score: X/9

### 6. Triggering Assessment

Analyze the description and predict:
- **Should trigger on**: List 5 queries that should trigger this skill
- **Should NOT trigger on**: List 3 queries that should not trigger
- **Risk of over-triggering**: Low/Medium/High
- **Risk of under-triggering**: Low/Medium/High

### 7. MCP Assessment (if applicable)

If the skill references MCP tools:
- [ ] MCP server documented in prerequisites
- [ ] Tool names are specific (not generic)
- [ ] Error handling for MCP failures
- [ ] Authentication guidance included

## Output: Review Report

Present a formatted review report:

```
SKILL REVIEW: [skill-name]
═══════════════════════════

Structure:    [X/6]  [██████████░░] [PASS/FAIL]
Frontmatter:  [X/8]  [████████░░░░] [PASS/FAIL]
Description:  [X/10] [██████████░░] [Grade]
Body Quality: [X/9]  [████████░░░░] [PASS/FAIL]
Triggering:   [Assessment]

OVERALL GRADE: [A-F]

TOP 3 IMPROVEMENTS:
1. [Most impactful improvement]
2. [Second improvement]
3. [Third improvement]

DETAILED FINDINGS:
[Section-by-section details with specific line references]
```

## Tips
- Reference `references/quality-checklist.md` for the full checklist
- Compare against the quality standards from the skills manual
- Be specific in recommendations - include exact text suggestions
