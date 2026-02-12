# Template: Context-Aware Tool Selection

Use this template for skills that choose different tools or approaches based on input characteristics.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Intelligently {{ACTION}} based on {{CONTEXT_FACTORS}}. Use when user asks to "{{TRIGGER_1}}", "{{TRIGGER_2}}", or needs "{{OUTCOME}}". Automatically selects the best approach for {{DOMAIN}}.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: smart-routing
  tags: [context-aware, {{TAG1}}, {{TAG2}}]
---
```

```markdown
# {{Skill Title}}

Automatically select the best approach based on context, input characteristics, and user requirements.

## Decision Framework

### Input Analysis

When triggered, first assess:
1. **{{Factor 1}}**: {{What to check}} → determines {{what}}
2. **{{Factor 2}}**: {{What to check}} → determines {{what}}
3. **{{Factor 3}}**: {{What to check}} → determines {{what}}

### Decision Tree

```
Input received
├── {{Condition A}}?
│   ├── YES → Path A: {{approach}}
│   └── NO ──┐
│             ├── {{Condition B}}?
│             │   ├── YES → Path B: {{approach}}
│             │   └── NO → Path C: {{approach/fallback}}
```

### Path A: {{Approach Name}}

**When**: {{Condition A is true}}
**Tool/Method**: {{specific tool or approach}}

Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

### Path B: {{Approach Name}}

**When**: {{Condition B is true}}
**Tool/Method**: {{specific tool or approach}}

Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

### Path C: {{Fallback Approach}}

**When**: No other conditions match
**Tool/Method**: {{fallback tool or approach}}

Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

## Transparency

After selecting a path, explain to the user:
- Which path was chosen
- Why (what conditions were detected)
- What alternative paths were available

Example:
"I'm using {{Path A}} because {{reason}}. If you'd prefer {{Path B}}, let me know."

## Fallback Handling

If the selected path fails:
1. Inform user of the failure
2. Suggest the next best path
3. If user agrees, switch to alternative path
4. If all paths fail, provide manual instructions

## Path Summary

| Path | Condition | Tool/Method | Best For |
|------|-----------|-------------|----------|
| A | {{condition}} | {{tool}} | {{use case}} |
| B | {{condition}} | {{tool}} | {{use case}} |
| C | Fallback | {{tool}} | {{use case}} |
```

## When to Use This Template

- File processing (different handlers per file type)
- Storage routing (local vs cloud vs CDN)
- Communication (email vs Slack vs ticket based on urgency)
- Any "smart router" that picks the best approach
