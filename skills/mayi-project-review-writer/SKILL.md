---
name: mayi-project-review-writer
description: Use when turning project review findings into a standardized markdown reference file with deterministic naming and output path
---

# Mayi Project Review Writer

## Overview

Generate the final project reference markdown file from prepared review findings. This skill is responsible for file creation, naming, formatting, and write safety.

## When to Use

- After review findings are prepared (preferably from `mayi-project-review-summary`)
- When you need consistent markdown output files for future project references
- When report format and output location must be deterministic

Do not use this skill to discover framework/tech/design decisions from scratch.

## Required Inputs

- `project_name`
- `review_findings`: structured findings content ready to render
- `output_dir`

## Optional Inputs

- `output_date`: date for file naming (default: current date)
- `future_project_type`: enables recommendations section
- `overwrite`: `true` | `false` (default: `false`)

## Input Contract

`review_findings` must provide content for:

- `project_overview`
- `how_it_works`
- `framework_and_stack`
- `key_design_decisions`
- `why_these_choices`
- `benefits`
- `tradeoffs_or_gaps`
- `reusable_patterns`
- `evidence_log`
- `unknowns_or_missing_evidence`

## Workflow

1. Validate required inputs and section completeness.
2. Generate file slug from `project_name` using the shared slug rule in `skills/_shared/references/slug-rule.md`.
3. Build file name: `project-reference-<slug>-<YYYY-MM-DD>.md`.
4. Ensure `output_dir` exists.
5. If target file exists and `overwrite=false`, stop and return a conflict note.
6. Render markdown using the exact output structure.
7. For `Evidence Log`, render each entry as a bullet list:
   ```
   - **[fact]** <statement> — _evidence: <file path(s) or config key(s)>_
   ```
8. If any required section has no content from findings, write: `No evidence found. Review source data.` — do not leave the section empty.
9. Write file to `output_dir`.
10. Return written file path and short write summary.
11. If the user requests PDF output, convert using `skills/_shared/scripts/convert-md-to-pdf.sh`.

## Output File Rule

`project-reference-<project-name>-<YYYY-MM-DD>.md`

Example:

`project-reference-order-service-2026-03-24.md`

## Output Structure

Use this section order exactly:

1. `# Project Reference: <project_name>`
2. `## Project Overview`
3. `## How It Works`
4. `## Framework & Tech Stack`
5. `## Key Design Decisions`
6. `## Why These Choices`
7. `## Benefits`
8. `## Tradeoffs / Gaps`
9. `## Reusable Patterns for Future Projects`
10. `## Recommendations for <future_project_type>` (only if provided)
11. `## Evidence Log`
12. `## Unknowns / Missing Evidence`

## Quality Checks

- All required sections are present and non-empty
- Section order exactly matches output structure
- Filename and slug follow rule
- Output path is inside `output_dir`
- `Evidence Log` entries include `claim_type`, `statement`, `evidence`

## Minimal Invocation Example

Input:

- `project_name`: `billing-platform`
- `output_dir`: `/path/to/billing-platform/docs/project-reviews`
- `review_findings`: structured content from summary step

Output:

- `/path/to/billing-platform/docs/project-reviews/project-reference-billing-platform-YYYY-MM-DD.md`
