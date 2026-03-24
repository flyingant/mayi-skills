# Skill Output Rubric

Score each criterion 0–2: **0** = missing/wrong, **1** = partially met, **2** = fully met.

---

## General (all skills)

| # | Criterion | Score |
| --- | --------- | ----- |
| G1 | Required inputs validated before proceeding | /2 |
| G2 | Output file name follows deterministic naming rule | /2 |
| G3 | All required output sections present and non-empty | /2 |
| G4 | Section order matches the skill's output structure exactly | /2 |
| G5 | No hallucinated content — every claim traceable to source or marked as assumption | /2 |

---

## mayi-project-estimate

| # | Criterion | Score |
| --- | --------- | ----- |
| E1 | Pre-run intake covers all 7 items and pauses for missing answers | /2 |
| E2 | Scope confirmation presented and confirmed before estimation | /2 |
| E3 | Estimation granularity matches user selection throughout | /2 |
| E4 | Definition of done controls which task categories appear | /2 |
| E5 | Risk buffer % matches confidence target (rough=30%, normal=20%, high=10%) | /2 |
| E6 | Communication buffer is explicit, not merged into feature estimates | /2 |
| E7 | Total = subtotals + risk buffer + communication buffer (math is correct) | /2 |
| E8 | Each implementation item has description, function list, workday estimate | /2 |
| E9 | Assumptions section lists all inferred items | /2 |

---

## mayi-project-review-summary

| # | Criterion | Score |
| --- | --------- | ----- |
| S1 | All 10 required findings keys populated | /2 |
| S2 | evidence_log entries have claim_type, statement, evidence | /2 |
| S3 | Facts and inferences clearly distinguished | /2 |
| S4 | Missing evidence marked as unknown, not invented | /2 |
| S5 | Recommendations are practical and implementation-ready | /2 |
| S6 | Focus area filtering applied correctly when specified | /2 |

---

## mayi-project-review-writer

| # | Criterion | Score |
| --- | --------- | ----- |
| W1 | File slug generated correctly from project name | /2 |
| W2 | Output path is inside output_dir | /2 |
| W3 | Overwrite rule respected (stops on conflict when false) | /2 |
| W4 | Evidence log rendered with claim_type, statement, evidence per entry | /2 |
| W5 | Empty sections handled with placeholder text | /2 |

---

## mayi-project-review-orchestrator

| # | Criterion | Score |
| --- | --------- | ----- |
| O1 | Validation script runs before analysis | /2 |
| O2 | All 10 required findings keys verified after summary phase | /2 |
| O3 | Progress reported to user between phases | /2 |
| O4 | Incomplete summary triggers validation error, not silent write | /2 |
| O5 | Final output includes file path, summary, and warnings | /2 |
