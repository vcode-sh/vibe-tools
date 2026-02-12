# Skill Quality Checklist

Use this checklist to validate any skill before publishing.

## Structure

- [ ] Folder named in kebab-case (no spaces, underscores, capitals)
- [ ] `SKILL.md` file exists (exact spelling, case-sensitive)
- [ ] No `README.md` inside skill folder
- [ ] No XML angle brackets (`< >`) anywhere in files
- [ ] Folder name matches `name` field in frontmatter

## YAML Frontmatter

- [ ] Has `---` opening delimiter
- [ ] Has `---` closing delimiter
- [ ] `name` field present and in kebab-case
- [ ] `description` field present
- [ ] Description includes WHAT (purpose)
- [ ] Description includes WHEN (trigger phrases/conditions)
- [ ] Description includes KEY capabilities
- [ ] No reserved names ("claude" or "anthropic" prefix)
- [ ] No XML angle brackets in any field
- [ ] Optional fields properly formatted (license, metadata, etc.)

## Description Quality

- [ ] At least 20 words long
- [ ] Contains 3+ specific trigger phrases users would actually say
- [ ] Covers paraphrased versions of triggers (not just one exact phrase)
- [ ] Not too generic ("Helps with projects" - BAD)
- [ ] Not too technical (includes user-facing language)
- [ ] Includes negative triggers if scope could be confused with other skills

## SKILL.md Body

- [ ] Has clear purpose statement at the top
- [ ] Instructions in imperative form ("Generate", "Create", "Validate")
- [ ] Under 3,000 words ideally, 5,000 max (move detailed content to references/)
- [ ] Critical instructions near the top
- [ ] Uses bullet points and numbered lists
- [ ] Specific, actionable instructions (not vague)
- [ ] Includes error handling guidance
- [ ] Has examples of expected inputs/outputs
- [ ] References linked files where appropriate

## Supporting Files

- [ ] references/ contains only necessary documentation
- [ ] scripts/ files have proper shebang lines
- [ ] scripts/ files are executable (chmod +x)
- [ ] assets/ files are referenced from SKILL.md
- [ ] No unused files in the skill folder

## Triggering Tests

- [ ] Triggers on 3+ obvious queries
- [ ] Triggers on paraphrased/indirect queries
- [ ] Does NOT trigger on clearly unrelated queries
- [ ] Does NOT over-trigger on vaguely related queries

## Functional Tests

- [ ] Produces correct output for primary use case
- [ ] Handles edge cases gracefully
- [ ] Tool calls succeed (if MCP-enhanced)
- [ ] Consistent results across multiple runs

## Composability

- [ ] Skill works alongside other skills without conflict
- [ ] Does not assume it is the only loaded skill
- [ ] Scope is clearly bounded (does not overlap with common skill domains)
- [ ] Negative triggers added if scope could be confused with adjacent skills

## Success Criteria

Define measurable goals for your skill:

### Quantitative Metrics
- [ ] Trigger accuracy: 90%+ of relevant queries activate the skill
- [ ] False positive rate: Under 10% of unrelated queries activate incorrectly
- [ ] Workflow completion: Completes in expected number of tool calls
- [ ] Zero failed API/MCP calls per workflow run

### Qualitative Metrics
- [ ] Users don't need to prompt Claude about next steps
- [ ] Workflows complete without user correction
- [ ] Consistent results across multiple sessions
- [ ] New users can accomplish the task on first try

### How to Measure
- Run 10-20 test queries that should trigger → track activation rate
- Run 10 unrelated queries → verify skill stays dormant
- Compare task completion with/without skill → count messages and tokens
- Run same request 3-5 times → compare output consistency

## Scoring Guide

| Score | Criteria |
|-------|----------|
| A (Excellent) | All checks pass, strong triggers, clear instructions, success criteria met |
| B (Good) | Minor issues, 1-2 missing optional items, 80%+ trigger accuracy |
| C (Needs Work) | Description weak, missing triggers, vague instructions |
| D (Poor) | Structure issues, frontmatter errors, won't trigger reliably |
| F (Broken) | Missing SKILL.md, invalid YAML, won't upload |

### How to improve from each grade
- **F → D**: Fix SKILL.md naming, add YAML delimiters, fix frontmatter syntax
- **D → C**: Add trigger phrases to description, fix structure issues
- **C → B**: Strengthen triggers (3+ phrases), add examples, write in imperative form
- **B → A**: Add negative triggers, success criteria, full test suite, consistent outputs
