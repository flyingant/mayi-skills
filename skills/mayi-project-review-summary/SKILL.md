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

1. Inspect project using the repo inspection strategy below.
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

## Repo Inspection Strategy

Inspect in this order. Stop going deeper once sufficient evidence is found for each findings key.

1. **Root-level files first**: `README.md`, `package.json`, `Cargo.toml`, `go.mod`, `pom.xml`, `requirements.txt`, `pyproject.toml`, `docker-compose.yml`, `Dockerfile`, `.env.example`, `Makefile`, or equivalent.
2. **Top-level directory listing**: identify major source directories (`src/`, `app/`, `lib/`, `api/`, `infra/`, `deploy/`, etc.).
3. **Config and CI**: `.github/workflows/`, `terraform/`, `k8s/`, `serverless.yml`, `tsconfig.json`, `vite.config.*`, `next.config.*`, or equivalent.
4. **Entry points**: main application entry files (e.g., `main.ts`, `index.ts`, `app.py`, `main.go`).
5. **Key source modules**: sample 3-5 representative source files per major directory to understand patterns, architecture, and conventions.
6. **Tests directory**: check presence, framework, and coverage approach.
7. **Documentation**: `docs/`, `ADR/`, `CHANGELOG.md`, `ARCHITECTURE.md`, or equivalent.

For monorepos, identify workspace/package boundaries first, then apply the above per package for the most active packages (top 3 by file count).

Do not read every file. Prioritize breadth of understanding over exhaustive coverage.

## Output Contract (For Writer Skill)

Produce findings content for these keys. Each key maps to a string (markdown-formatted content ready to render as a section body).

- `project_overview`: 2-4 sentence summary of what the project does and its primary users.
- `how_it_works`: end-to-end flow description in plain language. Use numbered steps or a short paragraph. Include system boundaries.
- `framework_and_stack`: bullet list of technologies grouped by layer (frontend, backend, data, infra, CI/CD).
- `key_design_decisions`: bullet list of notable architectural or design choices, each as a short descriptive sentence.
- `why_these_choices`: for each decision above, the rationale and context. Include constraints that drove the choice.
- `benefits`: bullet list of things that worked well, backed by evidence.
- `tradeoffs_or_gaps`: bullet list of limitations, missing pieces, or known debt.
- `reusable_patterns`: concrete patterns other projects can adopt, each with a one-sentence description and the file/module it's demonstrated in.
- `evidence_log`: structured list (see format below).
- `unknowns_or_missing_evidence`: bullet list of areas where evidence was expected but not found.
- `recommendations_for_future_project_type` (optional): only when `future_project_type` is provided.

`evidence_log` entry format:

```
- claim_type: fact | inference
  statement: <short claim>
  evidence: <file path(s) or config key(s)>
```

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
