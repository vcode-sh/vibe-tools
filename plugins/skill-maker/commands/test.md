---
description: Generate and run trigger tests, functional tests, and performance baselines for a skill
argument-hint: [path to skill folder or SKILL.md]
---

# Skill Testing Suite

Generate comprehensive test cases for a skill and help the user verify it works correctly. Covers three test areas from the Anthropic testing methodology: triggering, functional, and performance.

## Input

The user provides: `$ARGUMENTS`

If `$ARGUMENTS` is a path, use it directly.
If `$ARGUMENTS` is empty, ask: "Which skill should I test? Provide the path to the skill folder or SKILL.md file."

## Step 1: Read and Analyze the Skill

Read SKILL.md and all supporting files. Extract:
- Skill name and description
- Trigger phrases from the description
- Workflow steps from the body
- Tool dependencies (MCP, built-in)
- Domain and scope

## Step 2: Generate Triggering Tests

**Goal**: Ensure the skill loads at the right times and ONLY the right times.

Generate 3 categories of test queries:

### Should Trigger (5-8 queries)
Generate queries that SHOULD activate this skill:
- Direct trigger phrases from the description (exact)
- Paraphrased versions of trigger phrases
- Indirect requests that imply the skill's domain
- Questions about the skill's domain expertise

```
TRIGGERING TESTS - Should Activate:
1. "[exact trigger phrase from description]"
2. "[paraphrased version]"
3. "[indirect request]"
4. "[question about domain]"
5. "[alternative wording]"
```

### Should NOT Trigger (5-8 queries)
Generate queries that should NOT activate this skill:
- Clearly unrelated topics
- Adjacent but out-of-scope topics
- Similar keywords in different contexts
- Generic requests that overlap superficially

```
TRIGGERING TESTS - Should NOT Activate:
1. "[unrelated topic]"
2. "[adjacent domain]"
3. "[keyword in different context]"
4. "[generic overlap]"
5. "[out of scope]"
```

### Edge Cases (3-5 queries)
Generate ambiguous queries where triggering is debatable:
- Partial domain overlap
- Multi-domain requests
- Requests that could go either way

```
TRIGGERING TESTS - Edge Cases (may or may not trigger):
1. "[ambiguous request]" - Expected: [trigger/no-trigger] because [reason]
2. "[multi-domain]" - Expected: [trigger/no-trigger] because [reason]
3. "[partial overlap]" - Expected: [trigger/no-trigger] because [reason]
```

## Step 3: Generate Functional Tests

**Goal**: Verify the skill produces correct outputs.

For each major workflow in the skill, generate a test case:

```
FUNCTIONAL TEST: [Workflow Name]
Given: [Input description and prerequisites]
When: User says "[trigger query]"
Then:
  - [ ] [Expected output 1]
  - [ ] [Expected output 2]
  - [ ] [Expected behavior]
  - [ ] No errors or failed tool calls
```

Generate 2-4 functional test cases covering:
- Primary use case (happy path)
- Secondary use case
- Edge case / minimal input
- Error case (what happens with bad input)

## Step 4: Generate Performance Baseline

**Goal**: Establish metrics for measuring skill effectiveness.

```
PERFORMANCE BASELINE
═══════════════════

Target metrics:
- Trigger accuracy: 90%+ of relevant queries should activate
- False positive rate: <10% of unrelated queries should activate
- Workflow completion: X tool calls expected
- User corrections needed: 0-1 per workflow
- Token estimate: ~[X] tokens per workflow

Comparison (without skill):
- User would need to: [describe manual steps]
- Estimated messages: [X]
- Estimated errors: [X]
- Estimated tokens: [X]
```

## Step 5: Present Test Plan

Format all tests as a complete test plan:

```
SKILL TEST PLAN: [skill-name]
══════════════════════════════

TRIGGERING TESTS (13-21 queries)
├── Should Trigger: [X] queries
├── Should NOT Trigger: [X] queries
└── Edge Cases: [X] queries

FUNCTIONAL TESTS ([X] test cases)
├── Happy path: [description]
├── Secondary: [description]
├── Edge case: [description]
└── Error case: [description]

PERFORMANCE BASELINE
├── Target trigger accuracy: 90%+
├── Expected tool calls: [X]
└── Expected token savings: [X]%

HOW TO RUN THESE TESTS:
1. Enable the skill in Claude.ai or Claude Code
2. For each triggering test, send the query and note if skill loaded
3. For each functional test, run the scenario and check all conditions
4. Track metrics against the performance baseline
5. If trigger accuracy <90%, run /skill-maker:improve with the results
```

## Step 6: Offer to Run Trigger Tests

Ask the user: "Would you like me to evaluate the triggering tests now? I can analyze the description and predict which queries would trigger the skill."

If yes, analyze each test query against the skill's description and predict:
- PASS: Description is specific enough to trigger/not-trigger correctly
- RISK: Description might over/under-trigger on this query
- FAIL: Description will definitely trigger incorrectly

Present results with specific description improvements to fix any RISK/FAIL cases.

## Tips
- Run tests BEFORE distributing the skill
- Re-run tests after any description changes
- Track trigger accuracy over time to catch regressions
- Use /skill-maker:improve to fix issues found during testing
