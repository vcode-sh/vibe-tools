---
description: Iteratively improve a skill based on real-world usage feedback, test results, or edge cases
argument-hint: [path to skill folder] [optional: description of issues]
---

# Skill Improvement Loop

Take an existing skill and iteratively improve it based on real-world feedback. Follows the Anthropic best practice: "Iterate on a single task until Claude succeeds, then extract the winning approach."

## Input

The user provides: `$ARGUMENTS`

Parse the input:
- Path to the skill folder
- Optional: description of issues, test results, or feedback

If path is missing, ask: "Which skill should I improve? Provide the path to the skill folder."

## Step 1: Understand Current State

Read the skill and gather context:
1. Read SKILL.md and all supporting files
2. Run a quick review (same as `/sm:review`) to establish baseline score
3. Present current state:

```
CURRENT STATE: [skill-name]
═══════════════════════════

Grade: [A-F]
Description quality: [X/10]
Key strengths: [list]
Key weaknesses: [list]
```

## Step 2: Gather Feedback

If the user provided issue descriptions, use those. Otherwise, ask:

"What problems are you experiencing with this skill? Select what applies or describe your own:"

Offer common improvement areas:
1. **Trigger issues** - "Skill doesn't activate when it should" / "Skill activates when it shouldn't"
2. **Output quality** - "Results are inconsistent" / "Claude misses steps" / "Wrong format"
3. **Edge cases** - "Works for simple cases but fails on [specific scenario]"
4. **Scope** - "Too broad - tries to do too much" / "Too narrow - missing capabilities"
5. **Instructions** - "Claude doesn't follow the workflow" / "Skips validation steps"

## Step 3: Diagnose Root Cause

For each reported issue, determine the root cause:

### Trigger Issues
- **Under-triggering**: Description missing trigger phrases or too specific
  - Fix: Add more trigger phrase variations to description
- **Over-triggering**: Description too broad, missing negative triggers
  - Fix: Narrow scope, add "Do NOT use for..." clause
- **Wrong context**: Keywords match but domain is different
  - Fix: Add domain qualifiers to trigger phrases

### Output Quality
- **Inconsistency**: Instructions too vague or ambiguous
  - Fix: Add specific constraints, validation gates, examples
- **Missing steps**: Workflow not explicit enough
  - Fix: Break into numbered steps with explicit validation
- **Wrong format**: Output format not specified
  - Fix: Add output format section with examples

### Edge Cases
- **Unhandled scenario**: Instructions don't cover this case
  - Fix: Add conditional logic or new workflow branch
- **Conflicting rules**: Two instructions contradict for this input
  - Fix: Add priority ordering or decision tree

### Scope Issues
- **Too broad**: Single skill trying to handle too many use cases
  - Fix: Split into multiple focused skills
- **Too narrow**: Valid use cases excluded
  - Fix: Expand description triggers and workflow steps

### Instruction Following
- **Instructions buried**: Critical rules not near the top
  - Fix: Move to top with `## Critical` header
- **Too verbose**: Claude loses focus in long instructions
  - Fix: Move details to references/, keep SKILL.md lean
- **Passive voice**: Instructions read as suggestions, not commands
  - Fix: Convert to imperative form

## Step 4: Apply Improvements

For each diagnosed issue:
1. Show the current state (before)
2. Explain the root cause
3. Show the proposed fix (after)
4. Apply the fix

Track all changes:
```
CHANGES APPLIED:
1. [File]: [What changed] - [Why]
2. [File]: [What changed] - [Why]
3. [File]: [What changed] - [Why]
```

## Step 5: Re-Validate

After all improvements:
1. Run full validation again
2. Compare scores:

```
IMPROVEMENT RESULTS: [skill-name]
══════════════════════════════════

                Before  →  After
Grade:          [X]     →  [Y]
Description:    [X/10]  →  [Y/10]
Structure:      [X/6]   →  [Y/6]
Body Quality:   [X/9]   →  [Y/9]

Changes made: [X] modifications across [Y] files
```

## Step 6: Generate Test Cases

After improving, automatically generate triggering tests for the changed areas:

```
VERIFY THESE IMPROVEMENTS:

If you fixed triggers, test these queries:
1. "[query that previously failed]" → Should now trigger: YES/NO
2. "[query that over-triggered]" → Should now NOT trigger: YES/NO

If you fixed output, test this scenario:
- Input: [the scenario that was failing]
- Expected: [what should now happen]
```

## Step 7: Offer Next Iteration

```
Improvement round complete. Options:
1. Run /sm:test to generate a full test suite
2. Continue improving (provide more feedback)
3. Done - the skill is ready
```

## Iteration Philosophy

- **One task at a time**: Fix the most impactful issue first
- **Test after each change**: Verify the fix doesn't break other things
- **Max 3 rounds**: If still broken after 3 improvement rounds, suggest restructuring
- **Preserve user intent**: Never change the fundamental purpose of the skill
- **Show your reasoning**: Explain WHY each change helps, not just WHAT changed
