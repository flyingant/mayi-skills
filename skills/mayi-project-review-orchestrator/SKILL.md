---
name: mayi-project-review-orchestrator
description: Use when running an end-to-end project review workflow from repository analysis to final markdown file generation in one flow
---

# Mayi Project Review Orchestrator

## Overview

Run the full review pipeline in one flow by coordinating:

1. `mayi-project-review-summary` for evidence-based analysis
2. `mayi-project-review-writer` for markdown file generation

Use this skill when you want one command-style process instead of manually running each phase.

## When to Use

- You want end-to-end execution from repo path to final markdown file
- You want consistent output without manually passing intermediate findings
- You are doing regular project retrospectives and want a repeatable workflow

Do not use this skill when you only need analysis findings or only need file rendering.

## Required Inputs

- `project_name`
- `project_repo_path`
- `output_dir`

## Optional Inputs

- `focus_area`: `architecture` | `frontend` | `backend` | `infra` | `all` (default: `all`)
- `future_project_type`: planned next project type for tailored recommendations
- `output_date`: date for file naming (default: current date)
- `overwrite`: `true` | `false` (default: `false`)

## Workflow

1. Validate all required inputs via:
   - `scripts/validate-inputs.sh --project-name ... --project-repo-path ... --output-dir ... [--focus-area ...] [--future-project-type ...] [--output-date ...] [--overwrite ...]`
2. Run `mayi-project-review-summary` with:
   - `project_name`
   - `project_repo_path`
   - `focus_area` (if provided)
   - `future_project_type` (if provided)
3. Verify summary output includes all required findings keys:
   - `project_overview`
   - `how_it_works`
   - `framework_and_stack`
   - `major_features`
   - `basic_user_flow`
   - `special_logic`
   - `key_design_decisions`
   - `why_these_choices`
   - `benefits`
   - `tradeoffs_or_gaps`
   - `reusable_patterns`
   - `evidence_log`
   - `unknowns_or_missing_evidence`
4. Report progress to the user: "Analysis complete (features, user flow, and special logic extracted). Writing report..."
5. Run `mayi-project-review-writer` with:
   - `project_name`
   - `review_findings` from step 2
   - `output_dir`
   - `output_date` (if provided)
   - `future_project_type` (if provided)
   - `overwrite` (if provided)
6. Return:
   - final file path
   - short generation summary
   - any warnings about unknown/missing evidence
7. If the user requests PDF, convert using `../_shared/scripts/convert-md-to-pdf.sh`.

## Delegation Rules

- Never bypass `mayi-project-review-summary` when evidence-based analysis is required.
- Never write the final markdown directly in this skill; always route through `mayi-project-review-writer`.
- If summary output is incomplete, stop and return a validation error before writing any file.

## Scripts

- `scripts/validate-inputs.sh`
  - Validates required inputs and common option formats (`focus_area`, `overwrite`, optional `future_project_type`, `output_date`).
  - Normalizes repo and output paths to absolute paths.
  - Prints normalized `key=value` lines for downstream steps (including `focus_area`, always; `future_project_type` only when set).
  - Fails fast with clear errors when inputs are invalid.
- `../_shared/scripts/convert-md-to-pdf.sh`
  - Converts one markdown file or a directory of markdown files to PDF.
  - Uses `pandoc` and supports optional `--pdf-engine`.
  - Supports `--overwrite` and recursive directory conversion.

## Output

- `final_report_path`: absolute path to generated markdown file
- `generation_summary`: one short paragraph
- `warnings`: optional list (unknowns, missing evidence, partial sections)

## Failure Handling

- Missing required input: stop with explicit missing keys.
- Missing repo evidence: continue only with `unknown` entries from summary output.
- Existing target file with `overwrite=false`: stop and return conflict.
- Invalid output path: stop with path validation error.

## When to Use Which Skill

- Use `mayi-project-review-summary` when you only need analysis findings.
- Use `mayi-project-review-writer` when findings already exist and you only need markdown output.
- Use `mayi-project-review-orchestrator` when you want both phases in one run.

## Minimal Invocation Example

Input:

- `project_name`: `billing-platform`
- `project_repo_path`: `/path/to/billing-platform`
- `output_dir`: `/path/to/billing-platform/docs/project-reviews`
- `future_project_type`: `multi-tenant SaaS web app`

Output:

- `final_report_path`: `/path/to/billing-platform/docs/project-reviews/project-reference-billing-platform-YYYY-MM-DD.md`
