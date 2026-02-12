# Template: Domain-Specific Intelligence

Use this template for skills that embed specialized domain knowledge (compliance, industry rules, expert workflows).

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Applies {{DOMAIN}} expertise to {{ACTION}}. Use when user asks about "{{TRIGGER_1}}", "{{TRIGGER_2}}", or needs "{{DOMAIN}} {{OUTCOME}}". Embeds {{KNOWLEDGE_TYPE}} rules and best practices.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: domain-expertise
  tags: [{{DOMAIN}}, expert, {{TAG1}}]
---
```

```markdown
# {{Domain}} Expert Skill

Apply {{domain}} expertise, rules, and best practices to {{action/workflow}}.

## Domain Knowledge

### Core Rules
1. **{{Rule 1}}**: {{Explanation}}
2. **{{Rule 2}}**: {{Explanation}}
3. **{{Rule 3}}**: {{Explanation}}

### Industry Standards
- {{Standard 1}}: {{What it requires}}
- {{Standard 2}}: {{What it requires}}

### Common Mistakes
- {{Mistake 1}}: {{Why it's wrong}} → {{Correct approach}}
- {{Mistake 2}}: {{Why it's wrong}} → {{Correct approach}}

## Workflow with Domain Validation

### Step 1: Pre-Action Assessment

Before taking any action, evaluate:

**Required checks:**
- [ ] {{Compliance check 1}}
- [ ] {{Compliance check 2}}
- [ ] {{Risk assessment}}

**Decision:**
- ALL checks pass → Proceed to Step 2
- ANY check fails → Flag for review (Step 1b)

### Step 1b: Flagged Review

If pre-action checks fail:
1. Document which checks failed and why
2. Inform user of the specific issue
3. Provide remediation options:
   - {{Option A}}: {{description}}
   - {{Option B}}: {{description}}
4. Wait for user decision before proceeding

### Step 2: Execute with Domain Guardrails

Perform the action while applying domain rules:
1. {{Action step 1}} - apply {{rule}}
2. {{Action step 2}} - verify {{standard}}
3. {{Action step 3}} - check {{compliance}}

### Step 3: Post-Action Audit

After completion:
1. Log all decisions made and their justification
2. Verify output meets all domain standards
3. Generate audit summary:
   ```
   Action: {{what was done}}
   Rules applied: {{list}}
   Checks passed: {{X/Y}}
   Exceptions: {{any}}
   Timestamp: {{auto}}
   ```

## Decision Matrix

| Scenario | Risk Level | Action | Requires Approval |
|----------|-----------|--------|-------------------|
| {{Scenario 1}} | Low | {{Proceed}} | No |
| {{Scenario 2}} | Medium | {{Proceed with note}} | No |
| {{Scenario 3}} | High | {{Flag for review}} | Yes |
| {{Scenario 4}} | Critical | {{Block and escalate}} | Yes |

## References
- See `references/rules-database.md` for complete rule set
- See `references/standards.md` for industry standard details
- See `references/examples.md` for case studies
```

## When to Use This Template

- Legal/compliance workflows
- Financial processing with regulations
- Healthcare data handling (HIPAA, etc.)
- Security review processes
- Any domain requiring expert knowledge embedded in workflows
