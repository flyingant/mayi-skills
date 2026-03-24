#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  validate-inputs.sh \
    --project-name <name> \
    --estimation-granularity <page|feature|function> \
    [--source-text <text>] \
    [--source-file-path <path>] \
    [--confidence-target <rough|normal|high>] \
    [--team-profile <advanced-developer|senior-developer|mixed-team>] \
    [--communication-buffer-percent <number>] \
    [--output-dir <path>] \
    [--output-date <YYYY-MM-DD>]

Validates required estimate inputs and prints normalized key=value pairs.
Exits non-zero with a clear error on invalid input.
USAGE
}

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

PROJECT_NAME=""
ESTIMATION_GRANULARITY=""
SOURCE_TEXT=""
SOURCE_FILE_PATH=""
CONFIDENCE_TARGET="rough"
TEAM_PROFILE="senior-developer"
COMMUNICATION_BUFFER_PERCENT="10"
OUTPUT_DIR=""
OUTPUT_DATE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-name)
      PROJECT_NAME="${2:-}"
      shift 2
      ;;
    --estimation-granularity)
      ESTIMATION_GRANULARITY="${2:-}"
      shift 2
      ;;
    --source-text)
      SOURCE_TEXT="${2:-}"
      shift 2
      ;;
    --source-file-path)
      SOURCE_FILE_PATH="${2:-}"
      shift 2
      ;;
    --confidence-target)
      CONFIDENCE_TARGET="${2:-}"
      shift 2
      ;;
    --team-profile)
      TEAM_PROFILE="${2:-}"
      shift 2
      ;;
    --communication-buffer-percent)
      COMMUNICATION_BUFFER_PERCENT="${2:-}"
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
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

# --- Required inputs ---

[[ -n "$PROJECT_NAME" ]] || fail "Missing required --project-name"
[[ -n "$ESTIMATION_GRANULARITY" ]] || fail "Missing required --estimation-granularity"

# --- Mutual exclusion: exactly one source ---

if [[ -n "$SOURCE_TEXT" && -n "$SOURCE_FILE_PATH" ]]; then
  fail "Provide either --source-text or --source-file-path, not both"
fi

if [[ -z "$SOURCE_TEXT" && -z "$SOURCE_FILE_PATH" ]]; then
  fail "Provide either --source-text or --source-file-path"
fi

# --- Source file validation ---

if [[ -n "$SOURCE_FILE_PATH" ]]; then
  if [[ ! -f "$SOURCE_FILE_PATH" ]]; then
    fail "Source file does not exist: $SOURCE_FILE_PATH"
  fi
  ext="${SOURCE_FILE_PATH##*.}"
  ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
  if [[ "$ext_lower" != "docx" && "$ext_lower" != "pptx" ]]; then
    fail "Unsupported file extension: .$ext (supported: .docx, .pptx)"
  fi
fi

# --- Enum validation ---

case "$ESTIMATION_GRANULARITY" in
  page|feature|function) ;;
  *) fail "--estimation-granularity must be page, feature, or function (got: $ESTIMATION_GRANULARITY)" ;;
esac

case "$CONFIDENCE_TARGET" in
  rough|normal|high) ;;
  *) fail "--confidence-target must be rough, normal, or high (got: $CONFIDENCE_TARGET)" ;;
esac

case "$TEAM_PROFILE" in
  advanced-developer|senior-developer|mixed-team) ;;
  *) fail "--team-profile must be advanced-developer, senior-developer, or mixed-team (got: $TEAM_PROFILE)" ;;
esac

# --- Numeric validation ---

if ! [[ "$COMMUNICATION_BUFFER_PERCENT" =~ ^[0-9]+$ ]]; then
  fail "--communication-buffer-percent must be a non-negative integer (got: $COMMUNICATION_BUFFER_PERCENT)"
fi

# --- Date validation ---

if [[ -n "$OUTPUT_DATE" ]]; then
  if ! [[ "$OUTPUT_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    fail "--output-date must be YYYY-MM-DD (got: $OUTPUT_DATE)"
  fi
fi

# --- Normalize paths ---

if [[ -n "$SOURCE_FILE_PATH" ]]; then
  SOURCE_FILE_PATH="$(cd "$(dirname "$SOURCE_FILE_PATH")" && pwd)/$(basename "$SOURCE_FILE_PATH")"
fi

if [[ -n "$OUTPUT_DIR" ]]; then
  if [[ -d "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"
  else
    PARENT_DIR="$(dirname "$OUTPUT_DIR")"
    if [[ ! -d "$PARENT_DIR" ]]; then
      fail "Parent directory for output_dir does not exist: $PARENT_DIR"
    fi
    OUTPUT_DIR="$(cd "$PARENT_DIR" && pwd)/$(basename "$OUTPUT_DIR")"
  fi
fi

# --- Output normalized values ---

printf 'project_name=%s\n' "$PROJECT_NAME"
printf 'estimation_granularity=%s\n' "$ESTIMATION_GRANULARITY"
printf 'confidence_target=%s\n' "$CONFIDENCE_TARGET"
printf 'team_profile=%s\n' "$TEAM_PROFILE"
printf 'communication_buffer_percent=%s\n' "$COMMUNICATION_BUFFER_PERCENT"

if [[ -n "$SOURCE_TEXT" ]]; then
  printf 'source_type=text\n'
elif [[ -n "$SOURCE_FILE_PATH" ]]; then
  printf 'source_type=file\n'
  printf 'source_file_path=%s\n' "$SOURCE_FILE_PATH"
fi

if [[ -n "$OUTPUT_DIR" ]]; then
  printf 'output_dir=%s\n' "$OUTPUT_DIR"
fi

if [[ -n "$OUTPUT_DATE" ]]; then
  printf 'output_date=%s\n' "$OUTPUT_DATE"
fi
