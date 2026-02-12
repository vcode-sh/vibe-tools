# MCP Integration Patterns for Skills

Skills can enhance MCP server access by providing workflow guidance, domain expertise, and best practices on top of raw tool access.

**Analogy**: MCP provides the professional kitchen (tools), skills provide the recipes (workflows).

## Pattern 1: Sequential Workflow Orchestration

**Use when**: Users need multi-step processes in specific order.

```markdown
### Workflow: [Name]

#### Step 1: [Action]
Call MCP tool: `tool_name`
Parameters: param1, param2
Validate: [success criteria]

#### Step 2: [Action]
Call MCP tool: `tool_name`
Wait for: [dependency from Step 1]
Parameters: param1, result_from_step1

#### Step 3: [Action]
Call MCP tool: `tool_name`

#### Error Handling
If Step N fails:
- Log the error
- Attempt rollback of previous steps
- Inform user with specific error details
```

**Key techniques:**
- Explicit step ordering with dependencies
- Validation at each stage
- Rollback instructions for failures
- Clear parameter passing between steps

---

## Pattern 2: Multi-MCP Coordination

**Use when**: Workflows span multiple services (e.g., Figma + Drive + Linear + Slack).

```markdown
### Phase 1: [Service A] (MCP-A)
1. Export/fetch data from Service A
2. Process and validate
3. Create data manifest

### Phase 2: [Service B] (MCP-B)
1. Create target in Service B
2. Transfer data from Phase 1
3. Generate references/links

### Phase 3: [Service C] (MCP-C)
1. Create tasks/items referencing Phase 2
2. Link to Phase 1 outputs
3. Assign to team

### Phase 4: [Notification] (MCP-D)
1. Summarize all phases
2. Post notification with links
```

**Key techniques:**
- Clear phase separation
- Data passing between MCPs
- Validation before moving to next phase
- Centralized error handling

---

## Pattern 3: Iterative Refinement

**Use when**: Output quality improves with iteration.

```markdown
### Initial Pass
1. Fetch data via MCP
2. Generate first draft
3. Save to temporary location

### Quality Check
1. Run validation (script or manual)
2. Identify issues:
   - Missing sections
   - Inconsistent formatting
   - Data errors

### Refinement Loop
1. Address each issue
2. Regenerate affected sections
3. Re-validate
4. Repeat until quality threshold met (max 3 iterations)

### Finalization
1. Apply final formatting
2. Generate summary
3. Save final version
```

**Key techniques:**
- Explicit quality criteria
- Bounded iteration (max attempts)
- Validation scripts where possible
- Clear stopping conditions

---

## Pattern 4: Context-Aware Tool Selection

**Use when**: Same outcome requires different tools depending on context.

```markdown
### Decision Tree
1. Assess input characteristics:
   - File type and size
   - User permissions
   - Target platform

2. Select appropriate path:
   IF [condition A]: Use MCP tool X
   ELIF [condition B]: Use MCP tool Y
   ELSE: Use fallback approach

3. Execute selected path
4. Explain choice to user (transparency)
```

**Key techniques:**
- Clear decision criteria
- Fallback options for each path
- Transparency about why a path was chosen
- Consistent output format regardless of path

---

## Pattern 5: Domain-Specific Intelligence

**Use when**: Skill adds specialized knowledge beyond tool access (compliance, best practices, industry rules).

```markdown
### Pre-Action Validation
1. Fetch context via MCP
2. Apply domain rules:
   - [Rule 1]: Check [condition]
   - [Rule 2]: Verify [requirement]
   - [Rule 3]: Assess [risk level]
3. Document validation decision

### Action
IF validation passed:
  - Execute primary workflow via MCP
  - Apply domain-specific checks
  - Process result
ELSE:
  - Flag for manual review
  - Create case/ticket
  - Notify stakeholders

### Audit Trail
- Log all validation checks
- Record decisions and reasoning
- Generate audit report
```

**Key techniques:**
- Domain expertise embedded in decision logic
- Validation before action (compliance-first)
- Comprehensive documentation/audit trail
- Clear governance model

---

## MCP Skill Template Structure

When creating an MCP-enhanced skill:

```yaml
---
name: service-workflow
description: [Workflow description]. Use when user asks to [triggers]. Requires [MCP server name] MCP connection.
metadata:
  mcp-server: server-name
---
```

```markdown
# [Service] Workflow Skill

## Prerequisites
- [MCP Server Name] connected and authenticated
- Required permissions: [list]

## Workflows

### [Primary Workflow]
[Steps using MCP tools]

### [Secondary Workflow]
[Steps using MCP tools]

## Error Handling
- Connection lost: [recovery steps]
- Auth expired: [re-auth instructions]
- Tool not found: [verification steps]

## Best Practices
- [Domain-specific guidance]
- [Common pitfalls to avoid]
```

---

## Choosing the Right Pattern

Not sure which pattern to use? Follow this decision guide:

| Question | If YES | If NO |
|----------|--------|-------|
| Does the workflow use only ONE MCP server? | Pattern 1 (Sequential) or Pattern 3 (Iterative) | Continue below |
| Does the workflow span 2+ MCP servers? | Pattern 2 (Multi-MCP) | Continue below |
| Does the output require different tools for different inputs? | Pattern 4 (Context-Aware) | Continue below |
| Does the domain have compliance/rules that must be checked? | Pattern 5 (Domain Intelligence) | Pattern 1 |
| Does the output need quality review cycles? | Pattern 3 (Iterative) | Pattern 1 |

**Combining patterns**: Real-world skills often combine 2+ patterns. For example:
- Multi-MCP + Iterative: Coordinate across services, then refine output quality
- Sequential + Domain Intelligence: Follow ordered steps with compliance checks at each stage
- Context-Aware + Sequential: Pick the right tools first, then execute a workflow

**Problem-first vs Tool-first**:
- **Problem-first**: "Users need to onboard customers" → design the ideal workflow → select tools
- **Tool-first**: "We have Linear + Slack MCPs connected" → design workflows that leverage both

---

## Troubleshooting MCP Skills

| Problem | Cause | Solution |
|---------|-------|----------|
| Skill loads but MCP fails | Server disconnected | Verify MCP in Settings > Extensions |
| Wrong tool called | Tool name mismatch | Check MCP server docs for exact names |
| Auth errors | Expired/invalid tokens | Refresh authentication |
| Inconsistent results | Missing context | Add more explicit parameters in skill |
| Slow execution | Too many MCP calls | Batch operations where possible |
