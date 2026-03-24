# Regression Checklist

Run after any SKILL.md edit. Check each item passes before committing.

## Quick Validation

- [ ] Frontmatter `name` matches folder name
- [ ] Frontmatter `description` starts with "Use when"
- [ ] All sections from skill template are present (or intentionally omitted with reason)
- [ ] Required inputs list is complete — no required input missing
- [ ] Optional inputs have defaults documented
- [ ] Workflow steps are numbered sequentially with no gaps
- [ ] Output file naming rule is explicit and includes slug rule
- [ ] Quality checks section exists and is non-empty

## Cross-Skill Consistency

- [ ] Slug rule is identical across skills that generate files (estimate, writer)
- [ ] Output contract keys in summary skill match input contract keys in writer skill
- [ ] Orchestrator's required findings key list matches writer's input contract
- [ ] Shared scripts referenced by path are correct and scripts exist

## Behavioral

- [ ] Skill stops on missing required input (not guesses)
- [ ] Skill handles file conflicts per overwrite flag
- [ ] Skill distinguishes facts from inferences where applicable
- [ ] Quality checks are verifiable (not vague like "ensure quality")
