---
name: mayi-project-review-summary
description: Use when reviewing a completed project to create an evidence-based technical reference for reuse in future projects
---

# Mayi Project Review Summary

## Overview

Analyze an existing project and produce structured review findings, including how it works, technologies used, key design decisions, reasons behind those decisions, and practical outcomes for reuse later.

This skill is the analysis phase. Use `mayi-project-review-writer` to generate the final markdown file.

## When to Use

- After completing a project and wanting a technical retrospective
- Before starting a similar project and needing proven patterns
- When building a personal project knowledge base for future reuse

Do not use this skill for active incident debugging or release runbooks.

## Required Inputs

- `project_name`
- `project_repo_path`

## Optional Inputs

- `focus_area`: `architecture` | `frontend` | `backend` | `infra` | `all` (default: `all`)
- `future_project_type`: planned next project type for tailored recommendations

## Workflow

1. Inspect project docs, structure, and major source directories.
2. Identify framework(s), libraries, runtime, data/storage, and deployment tools.
3. Apply `focus_area` filtering:
   - `all`: include all major areas.
   - specific area: prioritize that area and keep other areas short.
4. Explain end-to-end project flow in plain language.
5. Extract specific design choices (if present) and classify them by area.
6. For each choice, document rationale and tradeoffs with explicit claim typing:
   - `fact`: directly supported by repository evidence.
   - `inference`: reasoned conclusion based on evidence.
7. Record practical outcomes:
   - What works well
   - Any specific design strengths
   - Known limitations or gaps
8. If evidence is missing, do not invent details. Mark as `unknown` and list where evidence was expected.
9. Derive reusable patterns for future projects.
10. If `future_project_type` is provided, add targeted recommendations.
11. Return a structured findings object for `mayi-project-review-writer`.

## Output Contract (For Writer Skill)

Produce findings content for these keys:

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
- `recommendations_for_future_project_type` (optional)

`evidence_log` rules:

- Include bullet items formatted as:
  - `claim_type`: `fact` | `inference`
  - `statement`: short claim
  - `evidence`: file path(s) or config key(s)

## Quality Checks

- Ensure all statements are grounded in repository evidence (code/docs/config)
- Separate facts from inferred reasoning
- Keep recommendations practical and implementation-ready
- Avoid vague claims such as "better performance" without concrete context
- Confirm every non-trivial claim appears in `evidence_log`
- Confirm output is ready to hand off to `mayi-project-review-writer`

## Minimal Invocation Example

Input:

- `project_name`: `billing-platform`
- `project_repo_path`: `/path/to/billing-platform`
- `future_project_type`: `multi-tenant SaaS web app`

Output:

- structured findings object with required keys
