# Template: MCP-Enhanced Basic

Use this template for skills that provide workflow guidance on top of a single MCP server connection.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: {{WORKFLOW_DESCRIPTION}} using {{SERVICE_NAME}}. Use when user asks to "{{TRIGGER_1}}", "{{TRIGGER_2}}", or mentions "{{SERVICE_NAME}} {{ACTION}}". Requires {{SERVICE_NAME}} MCP server connected.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  mcp-server: {{MCP_SERVER_NAME}}
  category: integration
  tags: [{{SERVICE}}, mcp, {{TAG1}}]
---
```

```markdown
# {{Service Name}} Workflows

Enhance {{Service Name}} MCP access with guided workflows and best practices.

## Prerequisites
- {{Service Name}} MCP server connected and authenticated
- Required permissions: {{list permissions}}
- Verify connection: Ask Claude to "list my {{service}} projects"

## Primary Workflow: {{Name}}

### Step 1: {{Gather Context}}
Call MCP tool: `{{tool_name}}`
Parameters:
- {{param1}}: {{description}}
- {{param2}}: {{description}}

Validate response contains: {{expected data}}

### Step 2: {{Process}}
Using data from Step 1:
- {{Action 1}}
- {{Action 2}}

Call MCP tool: `{{tool_name}}`
Parameters:
- {{param1}}: {{from Step 1}}
- {{param2}}: {{user input}}

### Step 3: {{Deliver}}
Call MCP tool: `{{tool_name}}`
Present results to user with:
- {{Summary point 1}}
- {{Summary point 2}}
- Link/reference to created item

## Secondary Workflow: {{Name}}

### Steps
1. {{Step 1 with MCP tool call}}
2. {{Step 2 with validation}}
3. {{Step 3 with delivery}}

## Best Practices
- {{Domain-specific guidance 1}}
- {{Domain-specific guidance 2}}
- {{Common pitfall to avoid}}

## Error Handling
- **Connection lost**: Verify MCP in Settings > Extensions. Re-authenticate if needed.
- **Auth expired**: {{Service-specific re-auth instructions}}
- **Permission denied**: Verify required scopes: {{list scopes}}
- **Tool not found**: Check MCP server version matches skill requirements

## MCP Tool Reference
| Tool Name | Purpose | Key Parameters |
|-----------|---------|----------------|
| `{{tool_1}}` | {{purpose}} | {{params}} |
| `{{tool_2}}` | {{purpose}} | {{params}} |
| `{{tool_3}}` | {{purpose}} | {{params}} |
```

## When to Use This Template

- Single MCP server workflows (Linear, Notion, Slack, etc.)
- Guided processes on top of existing tool access
- Best practices for specific service operations
