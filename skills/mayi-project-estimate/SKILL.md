---
name: mayi-project-estimate
description: Use when estimating implementation effort from a requirement source such as text, Word documents, or slide decks, and producing a structured workday breakdown
---

# Mayi Project Estimate

## Overview

Estimate project implementation effort from a requirement source (short text, Word doc, or PPTX) and output a structured workday-based breakdown with scope items, potential function requirements, implementation notes, integration/setup/deployment tasks, and buffers.

## When to Use

- You need a quick but structured engineering estimate before implementation
- Requirements are available as text, `.docx`, or `.pptx`
- You need itemized implementation tasks (page/feature/function level)

Do not use this skill as a commitment contract; it is an estimation aid.

## Required Inputs

- One source input:
  - `source_text` (few sentences), or
  - `source_file_path` (`.docx` or `.pptx`)
- `project_name`
- `estimation_granularity`: `page` | `feature` | `function`

## Optional Inputs

- `tech_constraints`: stack constraints or required framework
- `team_profile`: choose from `advanced-developer` | `senior-developer` | `mixed-team` (default: `senior-developer`)
- `non_functional_requirements`: performance, security, compliance, localization, accessibility
- `confidence_target`: `rough` | `normal` | `high` (default: `rough`)
- `communication_buffer_percent`: extra coordination/communication time percentage (default: `10`)
- `devops_extra_requirements`: deployment extras such as autoscaling, blue-green, canary, multi-env hardening (optional)
- `output_dir` (default: current workspace)
- `output_date` (default: current date)

## Mandatory Pre-Run Intake

Before starting estimation, ask the user to provide or confirm these items:

1. `team_profile` (`advanced-developer` | `senior-developer` | `mixed-team`)
2. Definition of done scope:
   - code
   - tests
   - documentation
   - deployment baseline
3. `confidence_target` (`rough` by default)
4. `communication_buffer_percent` (10% default, user can override)
5. Any `devops_extra_requirements` for deployment (if none, state `none`)
6. Any reusable existing modules/components (if unknown, state `unknown`)

If any item is missing, pause and request it explicitly before estimating.

## Workflow

1. Run the mandatory pre-run intake and collect missing preparation inputs.
2. Parse requirements from input source and extract explicit scope.
3. Build a draft scope inventory before any estimation:
   - page list (or feature list when page boundaries are unclear)
   - per-page/per-feature core functions
   - cross-page/feature navigation and dependencies
4. Present `Scope Confirmation` to the user and request confirmation/update.
5. If scope is not confirmed, revise scope inventory and repeat confirmation.
6. After scope confirmation, inspect each page/screen carefully and extract function-level potential requirements (not only UI rendering).
7. Identify cross-page connections:
   - page redirections
   - navigation routes
   - state handoff between pages
8. List assumptions for missing details (never hide assumptions).
9. Build implementation breakdown by selected granularity:
   - `page`: page/screen-level tasks
   - `feature`: module/feature-level tasks
   - `function`: endpoint/function-level tasks
10. Use one unified implementation breakdown section and include:
   - page/function implementation
   - API integration
   - framework/project setup
   - cross-cutting tasks
   - deployment/devops tasks
11. Estimate in rough workdays (not hours).
12. Apply risk buffer:
   - `rough`: 30%
   - `normal`: 20%
   - `high`: 10%
13. Apply communication buffer using `communication_buffer_percent` (default 10%).
14. Return total estimate range:
   - optimistic workdays
   - expected workdays
   - conservative workdays
15. Write markdown output file with deterministic naming.

## Output File Rule

`project-estimate-<project-name>-<YYYY-MM-DD>.md`

Slug rule for `<project-name>`:

- lowercase
- replace spaces/underscores with `-`
- remove characters except `a-z`, `0-9`, `-`
- collapse repeated `-`
- trim leading/trailing `-`

## Output Structure

Use this section order exactly:

1. `# Project Estimate: <project_name>`
2. `## Requirement Summary`
3. `## Scope Confirmation`
4. `## Assumptions`
5. `## Estimation Granularity`
6. `## Implementation Breakdown`
7. `## Risk Buffer and Communication Buffer`
8. `## Total Estimate (Optimistic / Expected / Conservative Workdays)`
9. `## Disclaimer`
10. `## Dependencies Required`

`## Requirement Summary` requirements:

- Include a bullet list of potential function-level requirements discovered per page.
- Include cross-page routing/navigation dependencies where visible.

`## Scope Confirmation` requirements:

- List confirmed pages/features with stable names.
- For each item, include core functions and boundary notes.
- Mark confirmation status explicitly: `confirmed` or `pending`.
- Do not estimate any item marked `pending`.

`## Estimation Granularity` requirements:

- Keep page-level breakdown, and explicitly annotate page-to-page redirections/navigation.

## Estimation Rules

- Provide item-level workday values and section subtotals.
- Keep estimates in workdays (no story points).
- Distinguish explicit scope vs assumed scope.
- Never hide unknowns; move them to `Disclaimer` and `Dependencies Required`.
- If requirement quality is poor, increase uncertainty and explain why.
- Use a simple complexity scale:
  - `simple`: straightforward CRUD/configuration
  - `medium`: moderate business logic or integration complexity
  - `complex`: multi-system, high uncertainty, or critical workflows
- Each implementation item must contain:
  - short implementation description
  - potential function list
  - rough workday estimate

## Quality Checks

- All scope items trace back to source content or assumptions.
- Scope confirmation is completed before estimation starts.
- Implementation breakdown matches selected `estimation_granularity`.
- Requirement summary includes function-level requirement bullets.
- Page-level navigation/redirection relationships are identified where present.
- Setup/API/cross-cutting/deployment are included within `Implementation Breakdown`.
- Buffer percentage matches selected confidence target.
- Communication buffer is explicit and not merged silently into feature hours.
- Total equals sum of subtotals plus risk buffer plus communication buffer.

## Minimal Invocation Example

Input:

- `project_name`: `member-portal`
- `source_file_path`: `/path/to/member-portal-requirements.pptx`
- `estimation_granularity`: `page`
- `confidence_target`: `normal`

Output:

- `project-estimate-member-portal-YYYY-MM-DD.md`
