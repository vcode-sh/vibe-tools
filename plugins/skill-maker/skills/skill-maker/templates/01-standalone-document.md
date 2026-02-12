# Template: Standalone Document/Asset Creator

Use this template for skills that produce consistent, high-quality output (documents, code, designs) without external tools.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: {{WHAT_IT_CREATES}} following {{STANDARD/STYLE_GUIDE}}. Use when user asks to "create {{OUTPUT_TYPE}}", "generate {{OUTPUT_TYPE}}", "make {{OUTPUT_TYPE}}", or mentions "{{DOMAIN}} {{OUTPUT_TYPE}}". Supports {{KEY_CAPABILITIES}}.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: document-creation
  tags: [{{TAG1}}, {{TAG2}}]
---
```

```markdown
# {{Skill Title}}

Create {{output type}} following {{standard/style guide}}.

## Output Standards

### Format
- File type: {{format}}
- Structure: {{expected structure}}
- Naming: {{naming convention}}

### Style Guide
- {{Rule 1}}
- {{Rule 2}}
- {{Rule 3}}

## Creation Workflow

### Step 1: Gather Requirements
Ask the user for:
- {{Required input 1}}
- {{Required input 2}}
- {{Optional input}} (default: {{default value}})

### Step 2: Generate Structure
Create the {{output type}} with:
1. {{Section/component 1}}
2. {{Section/component 2}}
3. {{Section/component 3}}

### Step 3: Apply Styling
Follow these rules:
- {{Style rule 1}}
- {{Style rule 2}}

### Step 4: Quality Check
Before delivering, verify:
- [ ] {{Check 1}}
- [ ] {{Check 2}}
- [ ] {{Check 3}}

## Examples

### Input
"{{Example user request}}"

### Output
{{Example output or reference to assets/template}}

## References
- See `references/style-guide.md` for detailed style rules
- See `assets/template.md` for base template
```

## When to Use This Template

- Creating documents, reports, presentations
- Generating code following specific patterns
- Designing UI components with style guides
- Any consistent output without external API calls
