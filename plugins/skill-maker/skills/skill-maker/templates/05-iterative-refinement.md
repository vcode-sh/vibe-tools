# Template: Iterative Refinement

Use this template for skills where output quality improves through review-and-refine cycles.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Creates and iteratively refines {{OUTPUT_TYPE}} until quality threshold is met. Use when user asks to "{{TRIGGER_1}}", "{{TRIGGER_2}}", or needs "high-quality {{OUTPUT_TYPE}}". Supports {{MAX_ITERATIONS}} refinement rounds.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: quality
  tags: [refinement, quality, {{TAG1}}]
---
```

```markdown
# {{Skill Title}}

Create {{output type}} through iterative refinement with explicit quality criteria.

## Quality Criteria

Define what "good enough" means:
- [ ] {{Criterion 1}} (required)
- [ ] {{Criterion 2}} (required)
- [ ] {{Criterion 3}} (recommended)
- [ ] {{Criterion 4}} (recommended)

Minimum passing: All required criteria met.
Target quality: All criteria met.

## Workflow

### Initial Generation

1. Gather requirements from user:
   - {{Input 1}}
   - {{Input 2}}
   - {{Input 3}}

2. Generate first draft:
   - {{Generation step 1}}
   - {{Generation step 2}}
   - {{Generation step 3}}

3. Save draft (do not present to user yet)

### Quality Assessment

Evaluate draft against criteria:

```
Assessment:
- Criterion 1: PASS/FAIL - [details]
- Criterion 2: PASS/FAIL - [details]
- Criterion 3: PASS/FAIL - [details]
- Criterion 4: PASS/FAIL - [details]
Overall: X/Y criteria met
```

If all required criteria pass AND iteration count < {{MAX}}, proceed to delivery.
Otherwise, proceed to refinement.

### Refinement Round (max {{MAX_ITERATIONS}} iterations)

For each failing criterion:
1. Identify the specific issue
2. Determine the fix
3. Apply the fix
4. Re-assess that criterion only

After all fixes applied:
- Run full assessment again
- If still failing after {{MAX_ITERATIONS}} rounds, deliver with notes

### Delivery

Present final output with:
- The {{output type}} itself
- Quality score: X/Y criteria met
- Refinement rounds completed: N
- Any remaining issues (if not all criteria met)
- Suggestions for manual improvement (if applicable)

## Refinement Rules

- Maximum {{MAX_ITERATIONS}} refinement rounds
- Each round addresses the most impactful issues first
- Never regress on already-passing criteria
- Track what changed in each round
- Stop early if all criteria met

## Quality Scoring

| Score | Meaning |
|-------|---------|
| All criteria met | Excellent - deliver as-is |
| Required met, some recommended missed | Good - deliver with notes |
| Some required missed | Needs work - explain gaps |
| Multiple required missed | Significant issues - offer restart |
```

## When to Use This Template

- Report generation with quality standards
- Code generation requiring lint/test passes
- Content creation with style requirements
- Any output where "first draft" is rarely good enough
