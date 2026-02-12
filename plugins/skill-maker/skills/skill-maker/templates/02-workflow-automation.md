# Template: Workflow Automation

Use this template for skills that guide users through multi-step processes with validation at each stage.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Guides {{WORKFLOW_NAME}} workflow from {{START}} to {{END}}. Use when user says "{{TRIGGER_1}}", "{{TRIGGER_2}}", or asks to "{{TRIGGER_3}}". Handles {{CAPABILITY_1}}, {{CAPABILITY_2}}, and {{CAPABILITY_3}}.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: workflow
  tags: [{{TAG1}}, {{TAG2}}, automation]
---
```

```markdown
# {{Workflow Name}}

Guide the user through {{workflow description}} with validation at each stage.

## Prerequisites
- {{Prerequisite 1}}
- {{Prerequisite 2}}

## Workflow Steps

### Step 1: {{Action Name}}

**Goal**: {{What this step achieves}}

**Actions**:
1. {{Action 1}}
2. {{Action 2}}
3. {{Action 3}}

**Validation**: Before proceeding, verify:
- [ ] {{Condition 1}}
- [ ] {{Condition 2}}

**If validation fails**: {{Recovery action}}

---

### Step 2: {{Action Name}}

**Goal**: {{What this step achieves}}

**Depends on**: Step 1 completion

**Actions**:
1. {{Action 1}}
2. {{Action 2}}

**Validation**: Before proceeding, verify:
- [ ] {{Condition 1}}

---

### Step 3: {{Action Name}}

**Goal**: {{What this step achieves}}

**Actions**:
1. {{Action 1}}
2. {{Action 2}}
3. {{Action 3}}

---

### Final Step: Review & Deliver

1. Summarize what was accomplished
2. Present results to user
3. Ask if adjustments are needed
4. If adjustments requested, return to relevant step

## Error Handling

| Error | Cause | Recovery |
|-------|-------|----------|
| {{Error 1}} | {{Cause}} | {{Recovery action}} |
| {{Error 2}} | {{Cause}} | {{Recovery action}} |

## Templates
- See `references/templates.md` for step templates
- See `references/examples.md` for workflow examples
```

## When to Use This Template

- Onboarding processes
- Setup/configuration wizards
- Multi-step data processing
- Deployment pipelines
- Any ordered sequence of actions with validation
