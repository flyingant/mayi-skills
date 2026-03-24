# Skill Test Cases

Run these cases before using skills on real projects. Each case defines inputs and expected behaviors to verify.

---

## mayi-project-estimate

### TC-EST-1: Minimal text input

- **Input**: `source_text`: "Build a single-page contact form with name, email, and message fields. Submit via REST API.", `project_name`: `contact-form`, `estimation_granularity`: `page`
- **Verify**:
  - Pre-run intake is triggered and all 7 items are asked
  - Scope confirmation is presented before estimation
  - Output file: `project-estimate-contact-form-YYYY-MM-DD.md`
  - All 10 output sections present and non-empty
  - Risk buffer matches selected confidence target
  - Total = sum of subtotals + risk buffer + communication buffer

### TC-EST-2: Missing required input

- **Input**: `source_text`: "Build a dashboard.", `project_name`: (not provided)
- **Verify**: Skill stops and requests the missing `project_name`

### TC-EST-3: Both source inputs provided

- **Input**: `source_text`: "Some text", `source_file_path`: `/path/to/file.pptx`
- **Verify**: Skill stops and asks user to provide only one

### TC-EST-4: Definition of done — code only

- **Input**: standard inputs, definition of done: `code` only
- **Verify**: No testing, documentation, or deployment rows in the breakdown

---

## mayi-project-review-summary

### TC-SUM-1: Standard repo analysis

- **Input**: `project_name`: `test-project`, `project_repo_path`: (any real repo with README, package.json, src/)
- **Verify**:
  - All 10 required findings keys are present
  - `evidence_log` entries have `claim_type`, `statement`, `evidence`
  - No invented details — missing info marked as `unknown`
  - Facts vs inferences are clearly separated

### TC-SUM-2: Focus area filtering

- **Input**: same repo, `focus_area`: `frontend`
- **Verify**: Frontend analysis is detailed; other areas are kept short

### TC-SUM-3: Empty or minimal repo

- **Input**: a repo with only a README
- **Verify**: `unknowns_or_missing_evidence` lists expected but missing evidence areas

---

## mayi-project-review-writer

### TC-WRT-1: Standard file generation

- **Input**: `project_name`: `test-project`, `review_findings`: (complete findings from TC-SUM-1), `output_dir`: `/tmp/test-output`
- **Verify**:
  - Output file: `project-reference-test-project-YYYY-MM-DD.md`
  - All 11 sections present in correct order
  - Evidence log entries rendered with claim_type, statement, evidence

### TC-WRT-2: Overwrite conflict

- **Input**: same as TC-WRT-1 but file already exists, `overwrite`: `false`
- **Verify**: Skill stops with conflict note

### TC-WRT-3: Missing findings key

- **Input**: `review_findings` missing `benefits` key
- **Verify**: Section populated with "No evidence found. Review source data."

---

## mayi-project-review-orchestrator

### TC-ORC-1: End-to-end run

- **Input**: `project_name`: `test-project`, `project_repo_path`: (real repo), `output_dir`: `/tmp/test-output`
- **Verify**:
  - Validation script runs without error
  - Summary phase completes with all required keys
  - Progress message reported between phases
  - Writer phase produces correctly named markdown file
  - Return includes `final_report_path`, `generation_summary`, `warnings`

### TC-ORC-2: Invalid repo path

- **Input**: `project_repo_path`: `/nonexistent/path`
- **Verify**: Validation script fails with clear error message
