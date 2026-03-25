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

- One source input (exactly one of the following):
  - `source_text` (few sentences), or
  - `source_file_path` (`.docx` or `.pptx`)
- `project_name`
- `estimation_granularity`: `page` | `feature` | `function`

## Input Validation

- Exactly one of `source_text` or `source_file_path` must be provided. If both or neither are given, stop and request clarification.
- If `source_file_path` is provided, verify the file exists and has a supported extension (`.docx` or `.pptx`) before proceeding.
- `estimation_granularity` must be one of the three allowed values.

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

1. `estimation_granularity` (`page` | `feature` | `function`)
2. `team_profile` (`advanced-developer` | `senior-developer` | `mixed-team`)
   - `advanced-developer`: experienced engineer comfortable with full-stack and DevOps; fastest pace
   - `senior-developer`: solid engineer, may need minor ramp-up on unfamiliar areas; moderate pace
   - `mixed-team`: team with varied experience; slowest pace, more coordination overhead
3. Definition of done scope (select all that apply; affects which task categories appear in the breakdown):
   - code
   - tests
   - documentation
   - deployment baseline
4. `confidence_target` (`rough` by default)
5. `communication_buffer_percent` (10% default, user can override)
6. Any `devops_extra_requirements` for deployment (if none, state `none`)
7. Any reusable existing modules/components (if unknown, state `unknown`)

If any item is missing, pause and request it explicitly before estimating.

## Source File Parsing

When `source_file_path` is provided:

- `.pptx`: extract text from each slide in order. Treat each slide as a potential scope section. Preserve slide titles as section headers.
- `.docx`: extract full text content preserving heading structure.
- Use available workspace tools or libraries (`python-pptx`, `python-docx`, pandoc, or equivalent) to extract text. If no extraction tool is available, stop and inform the user.
- After extraction, treat the text as the requirement source for all downstream steps.

## Scripts

- `scripts/validate-inputs.sh`
  - Validates required inputs, mutual exclusion of source inputs, enum values, and file existence.
  - Normalizes paths to absolute paths.
  - Fails fast with clear errors when inputs are invalid.
- `../_shared/scripts/convert-md-to-pdf.sh`
  - Converts the output markdown to PDF (optional, on user request).

## Requirement Discovery & Analysis

Before building any scope inventory, perform a deep-dive analysis on the parsed source content to surface the real implementable requirements. Raw inputs (especially slide decks, brief texts, or business-oriented docs) often hide, omit, or vaguely describe what actually needs to be built.

### Discovery Steps

1. **Extract explicit statements** — list every requirement or feature the source directly mentions.
2. **Identify implicit requirements** — for each explicit statement, ask:
   - What data does this feature need? (storage, APIs, models)
   - What user interactions does this imply? (forms, validations, confirmations, error states)
   - What permissions or roles are involved?
   - What happens on failure or edge cases?
3. **Detect vague or ambiguous language** — flag phrases like "easy to use", "fast", "modern design", "seamless integration", "etc." and translate them into concrete, implementable items or mark them as needing clarification.
4. **Derive technical requirements** — infer technical needs from business descriptions:
   - Authentication/authorization if users or roles are mentioned
   - File upload/processing if documents or media are referenced
   - Notifications if workflows or approvals are described
   - Search/filtering if lists or catalogs are involved
   - Real-time updates if collaboration or live data is mentioned
5. **Spot missing requirements** — check for commonly omitted areas:
   - Error handling and validation UX
   - Loading/empty/error states for every data-driven screen
   - Responsive/mobile considerations
   - Pagination, sorting, filtering for any list view
   - Session management, logout, token refresh
   - Audit trail or logging if compliance is relevant
6. **Map dependencies** — identify which discovered requirements depend on each other and which can be built independently.
7. **Classify each requirement**:
   - `explicit` — directly stated in source
   - `implicit` — logically necessary but not stated
   - `ambiguous` — stated but unclear; needs user clarification
   - `missing` — commonly expected but absent from source

### Discovery Output

Present a **Requirement Discovery Report** to the user containing:

- **Confirmed explicit requirements** (extracted verbatim or paraphrased from source)
- **Discovered implicit requirements** (with rationale for why each is needed)
- **Ambiguous items requiring clarification** (with specific questions for the user)
- **Potentially missing requirements** (with recommendation to include or exclude)
- **Dependency map** (which items block or enable others)

Wait for user confirmation or clarification on the discovery report before proceeding to scope inventory. If the user dismisses a discovered requirement, remove it from scope. If the user confirms an implicit or missing requirement, promote it to confirmed scope.

## Workflow

1. Validate inputs via `scripts/validate-inputs.sh` and run the mandatory pre-run intake to collect missing preparation inputs.
2. Parse requirements from input source (see Source File Parsing) and extract raw content.
3. Run **Requirement Discovery & Analysis** on the parsed content to surface explicit, implicit, ambiguous, and missing requirements.
4. Present the Requirement Discovery Report to the user and collect clarifications.
5. Finalize the confirmed requirement list based on user feedback.
6. Build a draft scope inventory before any estimation:
   - page list (or feature list when page boundaries are unclear)
   - per-page/per-feature core functions
   - cross-page/feature navigation and dependencies
7. Present `Scope Confirmation` to the user and request confirmation/update.
8. If scope is not confirmed, revise scope inventory and repeat confirmation.
9. After scope confirmation, inspect each page/screen carefully and extract function-level potential requirements (not only UI rendering).
10. Identify cross-page connections:
   - page redirections
   - navigation routes
   - state handoff between pages
11. List assumptions for missing details (never hide assumptions).
12. Build implementation breakdown by selected granularity:
    - `page`: page/screen-level tasks
    - `feature`: module/feature-level tasks
    - `function`: endpoint/function-level tasks
12a. **Scope coverage verification** — before finalising the breakdown, cross-check every item in `## Scope Confirmation` against the draft task list:
    - Every confirmed scope item must be covered by at least one breakdown task.
    - For `page` granularity, logically group pages that share a template or content type (e.g., same section of the site), but list the covered page names explicitly in the task description so coverage is visible.
    - If a confirmed page is not yet represented in any task row, add a dedicated row for it rather than leaving it uncovered.
    - Confirmed pages marked as external links must still appear — capture them as routing/redirect configuration tasks, not as full-build tasks.
13. Use one unified implementation breakdown section and include:
    - page/function implementation
    - API integration
    - framework/project setup
    - cross-cutting tasks
    - deployment/devops tasks
14. Estimate in rough workdays (not hours).
15. Apply risk buffer:
    - `rough`: 30%
    - `normal`: 20%
    - `high`: 10%
16. Apply communication buffer using `communication_buffer_percent` (default 10%).
17. Return total estimate range:
    - optimistic workdays
    - expected workdays
    - conservative workdays
18. Write markdown output file with deterministic naming.
19. If the user requests PDF output, convert using `skills/_shared/scripts/convert-md-to-pdf.sh`.

## Output Language Rule

All output — including the Requirement Discovery Report, Requirement Summary, Scope Confirmation, Assumptions, Implementation Breakdown, Disclaimer, and every other section — must be written in the same language as the original source input. Detect the language of the source text (or extracted document content) and use that language consistently throughout the entire output. Do not translate or switch to English unless the source input is in English.

## Output File Rule

`project-estimate-<project-name>-<YYYY-MM-DD>.md`

Generate `<project-name>` slug using the shared slug rule in `skills/_shared/references/slug-rule.md`.

## Output Structure

Use this section order exactly:

1. `# Project Estimate: <project_name>`
2. `## Requirement Discovery Report`
3. `## Requirement Summary`
4. `## Scope Confirmation`
5. `## Assumptions`
6. `## Estimation Granularity`
7. `## Implementation Breakdown`
8. `## Risk Buffer and Communication Buffer`
9. `## Total Estimate (Optimistic / Expected / Conservative Workdays)`
10. `## Disclaimer`
11. `## Dependencies Required`

`## Requirement Discovery Report` requirements:

- Group discovered requirements by classification: `explicit`, `implicit`, `ambiguous`, `missing`.
- For each implicit requirement, include a one-line rationale.
- For each ambiguous item, include the specific clarification question asked and the user's answer.
- For each missing requirement, note whether the user confirmed inclusion or exclusion.
- Include the dependency map as a simple list showing which items depend on others.

`## Requirement Summary` requirements:

- Include a bullet list of all confirmed requirements (explicit + user-confirmed implicit/missing) per page.
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

## Definition of Done Mapping

The user's selected definition-of-done scope controls which task categories appear:

- `code`: include page/feature/function implementation tasks and API integration
- `tests`: include a `Testing` row in the implementation breakdown (unit, integration, e2e as appropriate)
- `documentation`: include a `Documentation` row (README, API docs, inline docs)
- `deployment baseline`: include deployment/devops tasks

Omit categories the user excluded. If the user chose only `code`, do not add testing or deployment rows.

## Error Handling

- Source file not found or unreadable: stop and report the exact path.
- Source file has unsupported extension: stop and list supported formats.
- Extraction produces no text content: stop and ask user to verify the file.
- Scope confirmation rejected more than twice: pause and ask if the user wants to provide a revised requirements source.

## Quality Checks

- Requirement Discovery & Analysis is completed and confirmed by the user before scope inventory.
- All scope items trace back to source content, discovery findings, or assumptions.
- Scope confirmation is completed before estimation starts.
- Implementation breakdown matches selected `estimation_granularity`.
- Every confirmed scope item from `## Scope Confirmation` is traceable to at least one implementation breakdown task; no confirmed page or feature is silently omitted.
- For `page` granularity with grouped tasks, covered page names are visible in the task description or a dedicated note (e.g., parenthetical list of page slugs or names).
- Implementation breakdown includes only the task categories matching the user's definition of done.
- Requirement summary includes function-level requirement bullets.
- Every implicit or missing requirement in the final estimate has user confirmation.
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
