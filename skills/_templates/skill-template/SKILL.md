---
name: your-skill-name
description: Use when [specific triggering conditions and symptoms]
---

# Your Skill Name

## Overview

Briefly explain the skill and the core result it produces.

## When to Use

- Trigger 1
- Trigger 2
- Trigger 3

When NOT to use:

- Non-goal 1
- Non-goal 2

## Required Inputs

- `input_a`
- `input_b`

## Input Validation

- Describe mutual exclusions or format constraints on required inputs.
- State what to do when validation fails (stop and request clarification).

## Optional Inputs

- `input_c`: default value and meaning

## Workflow

1. Validate inputs (see Input Validation).
2. Gather context from inputs and relevant files/docs/code.
3. Execute core steps.
4. Produce output.
5. Run quality checks before finalizing.

## Output File Rule

`<output-name>-<YYYY-MM-DD>.md`

Generate slug using the shared rule in `skills/_shared/references/slug-rule.md`.

## Output Structure

ALWAYS use this exact section order:

1. Section one
2. Section two
3. Section three

## Error Handling

- Describe common failure modes and expected behavior for each.

## Quality Checks

- Validate completeness
- Distinguish fact vs inference
- Ensure format compliance

## Minimal Invocation Example

Input:

- `input_a`: `...`

Output:

- `<example-file-name>.md`
