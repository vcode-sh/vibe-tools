---
description: Quick structural validation of a skill - checks YAML, naming, and file structure
argument-hint: [path to skill folder or SKILL.md]
---

# Quick Skill Validation

Run a fast structural validation check on a skill. Lighter than `/sm:review` - focuses on structure and format, not quality.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Which skill should I validate? Provide the path to the skill folder or SKILL.md file."

## Validation Checks

### 1. File Structure
- [ ] SKILL.md exists (exact name, case-sensitive)
- [ ] Folder name is kebab-case
- [ ] No README.md inside skill folder
- [ ] No unexpected files at root level

### 2. YAML Frontmatter
- [ ] Opens with `---` on line 1
- [ ] Closes with `---`
- [ ] Valid YAML syntax (no tabs, proper quoting)
- [ ] `name` field present
- [ ] `name` is kebab-case
- [ ] `name` matches folder name
- [ ] `description` field present
- [ ] No XML angle brackets (`< >`)
- [ ] No reserved name prefixes ("claude", "anthropic")

### 3. Description Minimum
- [ ] At least 20 words
- [ ] Contains at least 1 trigger phrase (keyword: "use when", "ask to", "asks for")
- [ ] Not obviously generic ("helps with things")

### 4. Body Basics
- [ ] Has content after frontmatter
- [ ] At least 100 words
- [ ] Has at least one heading (`#` or `##`)

### 5. References Integrity
- [ ] All files in `references/` are referenced from SKILL.md
- [ ] All files in `scripts/` are referenced from SKILL.md
- [ ] No broken internal links

## Output

Quick pass/fail report:

```
VALIDATION: [skill-name]
════════════════════════

File Structure:  [PASS/FAIL] [details if fail]
YAML Frontmatter: [PASS/FAIL] [details if fail]
Description:     [PASS/FAIL] [details if fail]
Body:            [PASS/FAIL] [details if fail]
References:      [PASS/FAIL] [details if fail]

Result: [ALL PASS / X ISSUES FOUND]
```

If issues found, list each with the specific fix needed.

If all pass: "Skill structure is valid. Run `/sm:review` for a full quality audit."
