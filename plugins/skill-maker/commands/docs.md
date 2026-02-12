---
description: Interactive reference - ask questions about skill best practices and get answers with examples
argument-hint: [your question about skills]
---

# Skill Documentation Reference

Answer questions about Anthropic Agent Skills best practices using the knowledge from the official skills manual.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a question, answer it directly using the skill-maker knowledge base.
If `$ARGUMENTS` is empty, show the topic index.

## Topic Index

If no question provided, show:

```
SKILL REFERENCE TOPICS
══════════════════════

 1. Getting Started       - What is a skill? Structure, requirements
 2. YAML Frontmatter      - Fields, format, rules, examples
 3. Description Writing    - Trigger phrases, good/bad examples, negative triggers
 4. SKILL.md Body          - Structure, writing style, length
 5. Progressive Disclosure - Three levels, when to use each
 6. Templates              - Available templates and when to use them
 7. MCP Integration        - Patterns, choosing the right pattern
 8. Testing                - Triggering, functional, and performance tests
 9. Distribution           - Claude.ai, Claude Code, API, positioning
10. Troubleshooting        - Common issues and fixes
11. Composability          - Making skills work alongside others
12. Design Approach        - Problem-first vs tool-first design
13. Success Criteria       - Quantitative and qualitative metrics
14. Iteration              - Improving skills based on real-world usage
15. When to Split Skills   - Recognizing overly broad scope

Pick a topic number or ask a specific question.
```

## Answering Questions

When answering:

1. **Read relevant reference files** from `${CLAUDE_PLUGIN_ROOT}/skills/skill-maker/`:
   - `references/yaml-reference.md` - for YAML/frontmatter questions
   - `references/quality-checklist.md` - for quality/validation questions
   - `references/mcp-patterns.md` - for MCP integration questions
   - `references/troubleshooting.md` - for debugging/fixing questions
   - `templates/` - for template-related questions

2. **Provide a clear, concise answer** with:
   - Direct answer to the question
   - Code example (if applicable)
   - Good vs bad comparison (if applicable)
   - Reference to the relevant template or document

3. **Keep answers focused**:
   - Answer the specific question asked
   - Include one relevant example
   - Point to deeper references for more detail

## Example Q&A

**Q**: "How do I write a good description?"
**A**: Structure: `[What it does] + [When to use it] + [Key capabilities]`

Good:
```yaml
description: Manages sprint workflows in Linear. Use when user says "plan sprint", "create sprint tasks", or "organize backlog". Handles velocity analysis and task creation.
```

Bad:
```yaml
description: Helps with projects.
```

See `references/yaml-reference.md` for the complete description field reference.

## Additional Topic Guidance

### Topic 11: Composability
Claude can load multiple skills simultaneously. When building a skill:
- Do not assume your skill is the only one active
- Define clear scope boundaries
- Add negative triggers if your domain overlaps with common skill types
- Reference other skills by name if handoff is appropriate

### Topic 12: Design Approach
Two approaches to skill design:
- **Problem-first**: "I need to onboard customers" → design the workflow, then identify which tools (MCP or built-in) are needed
- **Tool-first**: "I have Notion MCP connected" → design workflows that leverage the tools available
Both are valid. Problem-first produces more user-centric skills. Tool-first maximizes existing infrastructure.

### Topic 13: Success Criteria
Measure skill effectiveness with:
- **Quantitative**: 90%+ trigger accuracy, X tool calls per workflow, 0 failed API calls
- **Qualitative**: Users don't need to redirect, consistent results, first-try success for new users
- **How to measure**: Run 10-20 test queries, compare with/without skill, track tokens consumed

### Topic 14: Iteration
The most effective skill creators iterate on a single challenging task until Claude succeeds, then extract the winning approach. Use `/sm:improve` to feed back real-world issues and refine the skill.

### Topic 15: When to Split Skills
Split a skill into multiple focused skills when:
- The description needs 10+ trigger phrases across different domains
- The SKILL.md body exceeds 3,000 words even after moving content to references
- Different user roles need different subsets of the functionality
- Trigger tests show frequent over-triggering on unrelated queries

## Follow-Up

After answering, ask: "Anything else about skills you'd like to know?"
