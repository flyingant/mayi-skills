# Skills Workspace

This directory stores reusable skills.

## Structure

- `skills/<skill-name>/SKILL.md`: One skill per folder (required)
- `skills/<skill-name>/scripts/`: Executable helpers (optional)
- `skills/<skill-name>/references/`: Large docs loaded as needed (optional)
- `skills/<skill-name>/assets/`: Templates or static resources (optional)
- `skills/_shared/scripts/`: Reusable scripts shared across skills
- `skills/_templates/skill-template/SKILL.md`: Starter template for new skills

## Naming Rules

- Folder names: lowercase with hyphens (example: `mayi-project-review-summary`)
- Skill `name` in frontmatter: same as folder name
- Keep each skill focused on one job

## Create a New Skill

1. Copy `skills/_templates/skill-template` to `skills/<new-skill-name>`
2. Update frontmatter (`name`, `description`)
3. Fill required sections in `SKILL.md`
4. Keep trigger conditions specific in `description` (start with `Use when...`)

## Current Skills

- `mayi-project-review-summary`
- `mayi-project-review-writer`
- `mayi-project-review-orchestrator`
- `mayi-project-estimate`

## Recommended Sequence

1. Run `mayi-project-review-summary` to produce evidence-based findings.
2. Run `mayi-project-review-writer` to generate the final markdown file.

## Which Skill to Use

- `mayi-project-review-summary`: use when you only need analysis findings.
- `mayi-project-review-writer`: use when findings already exist and you only need the markdown file.
- `mayi-project-review-orchestrator`: use when you want end-to-end execution in one run.
- `mayi-project-estimate`: use when you need a structured hour estimate from text/docx/pptx requirements.

## Quick Commands

Estimate markdown generation (from a PPTX source):

```bash
# 1) Run your estimate skill flow and write markdown output
# Example output file:
# /Users/mayi/Projects/mayi-skills/project-estimate-<project-name>-<YYYY-MM-DD>.md
```

CJK-safe PDF conversion (from estimate markdown):

```bash
bash /Users/mayi/Projects/mayi-skills/skills/_shared/scripts/convert-md-to-pdf.sh \
  --input /Users/mayi/Projects/mayi-skills/project-estimate-lilly-wechat-service-zone-2026-03-24.md \
  --cjk true \
  --cjk-font "PingFang SC" \
  --pdf-engine tectonic
```
