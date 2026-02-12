---
description: Guided beginner tutorial - build your first skill from scratch with explanations at every step
argument-hint: [leave empty to start the tutorial]
---

# Learn to Build Skills - Interactive Tutorial

Walk a beginner through creating their first Anthropic Agent Skill from scratch. Explain every concept as it comes up, show good/bad examples, and build a working skill by the end.

## Introduction

Start with this message:

```
SKILL MAKER - BEGINNER TUTORIAL
════════════════════════════════

Welcome! In the next few minutes, you'll build a working Anthropic Agent Skill
from scratch. By the end, you'll understand:

  1. What a skill IS and how it works
  2. How to write a killer description (the most important part!)
  3. How to structure instructions Claude will follow
  4. How to test and validate your skill

Let's start with the basics.
```

## Lesson 1: What is a Skill?

Explain:

```
LESSON 1: WHAT IS A SKILL?
───────────────────────────

A skill is a folder that teaches Claude how to do something specific.
Instead of explaining your workflow every time, you teach Claude ONCE.

A skill folder looks like this:

  my-skill/
  └── SKILL.md    ← This is the only required file!

That's it. Just one file in a folder. The file has two parts:

  1. FRONTMATTER (YAML) - Tells Claude WHEN to use this skill
  2. BODY (Markdown) - Tells Claude HOW to do the task

Think of it like a recipe card:
  - The title tells you when to use the recipe (frontmatter)
  - The instructions tell you how to cook (body)
```

Then ask: "Ready for Lesson 2? First, let's pick what your skill will do. What's a task you do repeatedly that you'd like Claude to handle? (Example: 'Write meeting notes', 'Generate API docs', 'Create test cases')"

## Lesson 2: The Description (Most Important Part!)

After the user describes their task:

```
LESSON 2: THE DESCRIPTION
──────────────────────────

The description is the MOST important part of your skill.
It determines WHEN Claude loads your skill. If it's too vague,
the skill won't activate. If it's too broad, it activates on everything.

A good description has THREE parts:

  1. WHAT it does    → "Generates meeting notes from discussions"
  2. WHEN to use it  → "Use when user says 'meeting notes', 'summarize meeting'"
  3. KEY capabilities → "Supports action items, decisions, and follow-ups"

Let me show you good vs bad:

  BAD:  "Helps with meetings."
        → Too vague! Claude won't know when to load this.

  BAD:  "Processes text documents for organizational purposes."
        → Too technical! No trigger phrases a human would say.

  GOOD: "Generates structured meeting notes from discussions.
         Use when user says 'meeting notes', 'summarize meeting',
         'write up the meeting', or 'capture action items'.
         Supports action items, decisions, and follow-ups."
        → Clear what, when, and capabilities!
```

Now generate a description for the user's skill:
- Present it
- Explain why you chose those specific trigger phrases
- Ask if they want to adjust anything
- Point out the 3-part structure in the result

## Lesson 3: The Name

```
LESSON 3: NAMING YOUR SKILL
────────────────────────────

Skill names follow strict rules:
  ✓ lowercase only       → meeting-notes
  ✓ hyphens for spaces   → api-doc-generator
  ✓ matches folder name  → the folder MUST be named the same

  ✗ no spaces           → "Meeting Notes" won't work
  ✗ no underscores      → "meeting_notes" won't work
  ✗ no capitals         → "MeetingNotes" won't work
  ✗ no "claude"         → "claude-helper" is reserved
```

Generate 3 name suggestions and let the user pick.

## Lesson 4: Writing Instructions

```
LESSON 4: WRITING THE INSTRUCTIONS
───────────────────────────────────

Now for the body - the actual instructions. Key rules:

  1. USE COMMANDS, NOT SUGGESTIONS
     ✗ "The output should include a summary"
     ✓ "Include a summary section at the top"

  2. BE SPECIFIC, NOT VAGUE
     ✗ "Make sure to format things properly"
     ✓ "Format as markdown with h2 headings for each topic"

  3. PUT CRITICAL RULES FIRST
     The most important instructions go at the top.
     Claude pays more attention to things near the beginning.

  4. KEEP IT FOCUSED
     Aim for under 3,000 words. If you need more,
     put details in a references/ subfolder.
```

Generate the SKILL.md body for the user's skill:
- Purpose statement (1 paragraph)
- Core workflow (3-5 steps)
- Key rules (3-5 bullet points)
- One example

Show the user and explain each section.

## Lesson 5: Putting It Together

```
LESSON 5: YOUR COMPLETE SKILL
──────────────────────────────

Here's your complete SKILL.md! Let me explain the structure:

  ---                          ← Opens the frontmatter
  name: [skill-name]           ← Matches the folder name
  description: [...]           ← When Claude loads this skill
  ---                          ← Closes the frontmatter

  # [Title]                    ← Start of the body

  [Purpose statement]          ← What this skill does

  ## Workflow                  ← Step-by-step instructions
  1. ...
  2. ...

  ## Rules                     ← Critical constraints
  - ...

  ## Example                   ← Expected input/output
  ...
```

Present the complete SKILL.md with annotations.

## Lesson 6: Save and Validate

Ask the user where to save:
- Explain the folder structure requirement
- Create the skill
- Run validation automatically

```
LESSON 6: SAVE AND VALIDATE
────────────────────────────

Let me save your skill and check it passes all quality checks...

  [Creating folder structure...]
  [Writing SKILL.md...]
  [Running validation...]

Results:
  Structure:    PASS ✓
  Frontmatter:  PASS ✓
  Description:  [Score]/10
  Body:         PASS ✓

Your first skill is ready!
```

## Lesson 7: What's Next

```
CONGRATULATIONS! 🎉
═══════════════════

You've built your first Anthropic Agent Skill! Here's what to do next:

  TEST IT:
    /sm:test [path]    → Generate test cases for your skill

  REVIEW IT:
    /sm:review [path]  → Get a detailed quality audit

  IMPROVE IT:
    /sm:improve [path] → Refine based on real-world usage

  PACKAGE IT:
    /sm:package [path] → Prepare for Claude.ai or Claude Code

  LEARN MORE:
    /sm:docs           → Browse the full reference manual

CONCEPTS YOU LEARNED:
  ✓ What a skill is (folder + SKILL.md)
  ✓ Progressive disclosure (frontmatter → body → linked files)
  ✓ Description writing (What + When + Capabilities)
  ✓ Skill naming rules (kebab-case, match folder)
  ✓ Instruction writing (imperative, specific, critical-first)
  ✓ Quality validation
```

## Teaching Style

Throughout the tutorial:
- Use clear, simple language
- Show before/after comparisons
- Explain the "why" behind every rule
- Let the user make choices (name, description wording)
- Celebrate progress at each step
- Keep explanations concise - teach by doing
