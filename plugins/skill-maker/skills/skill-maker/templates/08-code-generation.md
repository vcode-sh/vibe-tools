# Template: Code Generation & Analysis

Use this template for skills that generate, analyze, or transform code following specific patterns and standards.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Generates {{CODE_TYPE}} following {{STANDARD/FRAMEWORK}} patterns. Use when user asks to "create {{COMPONENT}}", "generate {{CODE_TYPE}}", "build {{ELEMENT}}", or asks about "{{FRAMEWORK}} {{PATTERN}}". Supports {{KEY_FEATURES}}.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  category: code-generation
  tags: [{{FRAMEWORK}}, code-gen, {{TAG1}}]
---
```

```markdown
# {{Framework/Standard}} Code Generator

Generate {{code type}} following {{framework}} conventions and best practices.

## Output Format

### File Structure
Generated code follows this pattern:
```
{{typical file/component structure}}
```

### Naming Conventions
- Files: {{convention}} (e.g., kebab-case, PascalCase)
- Functions: {{convention}}
- Variables: {{convention}}
- Classes: {{convention}}

### Code Style
- {{Style rule 1}}
- {{Style rule 2}}
- {{Style rule 3}}

## Generation Rules

### Critical
- {{Rule 1 - must always follow}}
- {{Rule 2 - must always follow}}
- {{Rule 3 - must always follow}}

### Important
- {{Rule 4}}
- {{Rule 5}}

### Recommended
- {{Rule 6}}
- {{Rule 7}}

## Component Types

### Type 1: {{Name}}
**When**: User asks for {{description}}
**Structure**:
```{{language}}
{{code pattern/skeleton}}
```
**Customize**: {{what to fill in}}

### Type 2: {{Name}}
**When**: User asks for {{description}}
**Structure**:
```{{language}}
{{code pattern/skeleton}}
```
**Customize**: {{what to fill in}}

### Type 3: {{Name}}
**When**: User asks for {{description}}
**Structure**:
```{{language}}
{{code pattern/skeleton}}
```

## Validation

Before delivering generated code, verify:
- [ ] Follows naming conventions
- [ ] No inline styles/hardcoded values (if applicable)
- [ ] Proper imports/dependencies
- [ ] Error handling included
- [ ] Responsive/accessible (if UI code)
- [ ] No security vulnerabilities (XSS, injection, etc.)
- [ ] Comments for non-obvious logic only

## Common Patterns

### Pattern: {{Name}}
```{{language}}
{{reusable code pattern}}
```

### Pattern: {{Name}}
```{{language}}
{{reusable code pattern}}
```

## Anti-Patterns (Never Do)
- {{Anti-pattern 1}}: {{Why it's bad}} → {{Correct approach}}
- {{Anti-pattern 2}}: {{Why it's bad}} → {{Correct approach}}

## Output

1. Generate the code following all rules above
2. Ask user for preferred file name/path
3. Save using the Write tool
4. If validation reveals issues, fix before saving

## References
- See `references/patterns.md` for all code patterns
- See `references/examples.md` for complete examples
- See `templates/` for starter templates
```

## When to Use This Template

- React/Vue/Angular component generators
- API endpoint scaffolding
- Database schema generators
- WordPress block generators (like greenshift-blocks)
- Any framework-specific code generation
