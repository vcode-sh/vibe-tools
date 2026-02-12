# Template: Multi-MCP Coordination

Use this template for skills that coordinate workflows spanning multiple MCP servers/services.

## SKILL.md Template

```yaml
---
name: {{SKILL_NAME}}
description: Coordinates {{WORKFLOW}} across {{SERVICE_1}}, {{SERVICE_2}}, and {{SERVICE_3}}. Use when user says "{{TRIGGER_1}}", "{{TRIGGER_2}}", or asks to "{{TRIGGER_3}}". Requires {{SERVICE_1}}, {{SERVICE_2}}, and {{SERVICE_3}} MCP connections.
metadata:
  author: {{AUTHOR}}
  version: 1.0.0
  mcp-server: "{{SERVER_1}}, {{SERVER_2}}, {{SERVER_3}}"
  category: integration
  tags: [multi-mcp, coordination, {{TAG1}}]
---
```

```markdown
# {{Workflow Name}}

Coordinate {{workflow}} across multiple services with data passing and validation.

## Prerequisites
- [ ] {{Service 1}} MCP connected and authenticated
- [ ] {{Service 2}} MCP connected and authenticated
- [ ] {{Service 3}} MCP connected and authenticated
- [ ] Required permissions: {{list per service}}

Verify all connections before starting:
1. "List my {{service 1}} items"
2. "Show my {{service 2}} projects"
3. "Check {{service 3}} status"

## Coordination Workflow

### Phase 1: {{Source Service}} ({{MCP-1}})

**Goal**: {{What to extract/create}}

1. Call `{{mcp1_tool_1}}` to {{action}}
   - Parameters: {{params}}
   - Expected: {{result}}

2. Call `{{mcp1_tool_2}}` to {{action}}
   - Parameters: {{params}}
   - Store result as: `phase1_data`

**Checkpoint**: Verify `phase1_data` contains:
- {{Required field 1}}
- {{Required field 2}}

---

### Phase 2: {{Processing Service}} ({{MCP-2}})

**Goal**: {{What to create/transform}}
**Input**: `phase1_data` from Phase 1

1. Call `{{mcp2_tool_1}}` to {{action}}
   - Parameters: {{params using phase1_data}}
   - Expected: {{result}}

2. Call `{{mcp2_tool_2}}` to {{action}}
   - Store result as: `phase2_data`

**Checkpoint**: Verify `phase2_data` contains:
- {{Required field}}
- References to Phase 1 items

---

### Phase 3: {{Destination Service}} ({{MCP-3}})

**Goal**: {{What to create/notify}}
**Input**: `phase1_data` + `phase2_data`

1. Call `{{mcp3_tool_1}}` to {{action}}
   - Include references from both phases

2. Call `{{mcp3_tool_2}}` to {{action}}

---

### Summary
Present to user:
- Phase 1: {{what was done}} in {{Service 1}}
- Phase 2: {{what was done}} in {{Service 2}}
- Phase 3: {{what was done}} in {{Service 3}}
- Links: {{all created items}}

## Error Handling

### Phase Failure Recovery
| Failed Phase | Recovery Action |
|-------------|-----------------|
| Phase 1 fails | Stop workflow, inform user |
| Phase 2 fails | Phase 1 items exist, inform user, offer retry |
| Phase 3 fails | Phases 1-2 complete, offer manual completion |

### Cross-Service Issues
- **Data mismatch**: Validate data format between phases
- **Rate limiting**: Add delays between rapid MCP calls
- **Partial completion**: Track which phases completed for resume

## Data Flow Diagram

```
[Service 1] --phase1_data--> [Service 2] --phase2_data--> [Service 3]
     |                            |                            |
     v                            v                            v
  Extract                     Transform                    Deliver
```
```

## When to Use This Template

- Design handoff (Figma -> Drive -> Linear -> Slack)
- Release management (GitHub -> Docs -> Slack)
- Content pipeline (CMS -> Review -> Publish -> Notify)
- Any workflow touching 2+ external services
