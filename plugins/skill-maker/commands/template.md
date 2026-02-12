---
description: Browse and apply pre-built skill templates for different categories
argument-hint: [template name or category, or leave empty to browse]
---

# Skill Template Browser

Browse 8 pre-built skill templates and generate a new skill from a chosen template.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` matches a template name or number, load that template directly.
If `$ARGUMENTS` is empty, show the template catalog.

## Template Catalog

Present this table to the user:

```
SKILL TEMPLATES
═══════════════

# │ Template                    │ Category          │ Best For
──┼─────────────────────────────┼───────────────────┼──────────────────────────
1 │ Standalone Document/Asset   │ Document Creation │ Reports, code, designs
2 │ Workflow Automation         │ Workflow          │ Multi-step processes
3 │ MCP Basic                   │ MCP Enhancement   │ Single MCP server
4 │ Multi-MCP Coordination      │ MCP Enhancement   │ Cross-service workflows
5 │ Iterative Refinement        │ Quality           │ Review-and-refine loops
6 │ Context-Aware Selection     │ Smart Routing     │ Dynamic tool/path choice
7 │ Domain Intelligence         │ Domain Expertise  │ Compliance, industry rules
8 │ Code Generation             │ Code Generation   │ Framework-specific code
```

Ask: "Pick a template number (1-8) or describe what you need and I'll recommend one."

## Template Loading

Read the selected template from `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/templates/`:
- `01-standalone-document.md`
- `02-workflow-automation.md`
- `03-mcp-basic.md`
- `04-multi-mcp-coordination.md`
- `05-iterative-refinement.md`
- `06-context-aware-selection.md`
- `07-domain-intelligence.md`
- `08-code-generation.md`

## Customization

After loading the template, guide the user through filling in placeholders:

1. Ask for the skill's specific purpose and domain
2. Replace all `{{PLACEHOLDER}}` values with user's input
3. Adjust workflow steps to match their needs
4. Add/remove sections as appropriate
5. Generate proper trigger phrases for the description

## Save

Follow the same save process as `/sm:create`:
1. Ask user for save location
2. Create directory structure
3. Write all files
4. Run auto-validation
5. Report results

## Template Recommendation

If the user describes their need instead of picking a number:
- Analyze the description
- Match to the most appropriate template
- Explain why that template fits
- Offer alternatives if the match isn't clear
