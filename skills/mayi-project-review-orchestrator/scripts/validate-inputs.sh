#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  validate-inputs.sh \
    --project-name <name> \
    --project-repo-path <path> \
    --output-dir <path> \
    [--output-date <YYYY-MM-DD>] \
    [--overwrite <true|false>]

Validates required orchestrator inputs and prints normalized key=value pairs.
USAGE
}

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

PROJECT_NAME=""
PROJECT_REPO_PATH=""
OUTPUT_DIR=""
OUTPUT_DATE=""
OVERWRITE="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-name)
      PROJECT_NAME="${2:-}"
      shift 2
      ;;
    --project-repo-path)
      PROJECT_REPO_PATH="${2:-}"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --output-date)
      OUTPUT_DATE="${2:-}"
      shift 2
      ;;
    --overwrite)
      OVERWRITE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

[[ -n "$PROJECT_NAME" ]] || fail "Missing required --project-name"
[[ -n "$PROJECT_REPO_PATH" ]] || fail "Missing required --project-repo-path"
[[ -n "$OUTPUT_DIR" ]] || fail "Missing required --output-dir"

if [[ ! -d "$PROJECT_REPO_PATH" ]]; then
  fail "project_repo_path does not exist or is not a directory: $PROJECT_REPO_PATH"
fi

if [[ "$OVERWRITE" != "true" && "$OVERWRITE" != "false" ]]; then
  fail "--overwrite must be true or false"
fi

if [[ -n "$OUTPUT_DATE" ]]; then
  if ! [[ "$OUTPUT_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    fail "--output-date must be YYYY-MM-DD"
  fi
fi

# Normalize to absolute paths.
PROJECT_REPO_PATH="$(cd "$PROJECT_REPO_PATH" && pwd)"
if [[ -d "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"
else
  PARENT_DIR="$(dirname "$OUTPUT_DIR")"
  if [[ ! -d "$PARENT_DIR" ]]; then
    fail "Parent directory for output_dir does not exist: $PARENT_DIR"
  fi
  OUTPUT_DIR="$(cd "$PARENT_DIR" && pwd)/$(basename "$OUTPUT_DIR")"
fi

printf 'project_name=%s\n' "$PROJECT_NAME"
printf 'project_repo_path=%s\n' "$PROJECT_REPO_PATH"
printf 'output_dir=%s\n' "$OUTPUT_DIR"
printf 'overwrite=%s\n' "$OVERWRITE"
if [[ -n "$OUTPUT_DATE" ]]; then
  printf 'output_date=%s\n' "$OUTPUT_DATE"
fi
