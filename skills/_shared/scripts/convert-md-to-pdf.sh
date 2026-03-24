#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  convert-md-to-pdf.sh --input <file.md> [--output <file.pdf>] [--overwrite true|false] [--pdf-engine <engine>] [--cjk auto|true|false] [--cjk-font <font-name>]
  convert-md-to-pdf.sh --dir <directory> [--recursive true|false] [--overwrite true|false] [--pdf-engine <engine>] [--cjk auto|true|false] [--cjk-font <font-name>]

Description:
  Convert markdown file(s) to PDF using pandoc.

Options:
  --input <file.md>         Convert one markdown file.
  --output <file.pdf>       Optional output path for single-file mode.
  --dir <directory>         Convert all .md files in a directory.
  --recursive true|false    Recursively scan directory (default: false).
  --overwrite true|false    Overwrite existing PDFs (default: false).
  --pdf-engine <engine>     Optional pandoc PDF engine (e.g. xelatex, wkhtmltopdf, weasyprint).
  --cjk auto|true|false     Enable CJK-safe rendering. auto detects CJK chars (default: auto).
  --cjk-font <font-name>    CJK font name for xeCJK (default: PingFang SC).
  -h, --help                Show this help.
USAGE
}

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    fail "Required command not found: $1"
  fi
}

INPUT_FILE=""
OUTPUT_FILE=""
INPUT_DIR=""
RECURSIVE="false"
OVERWRITE="false"
PDF_ENGINE=""
CJK_MODE="auto"
CJK_FONT="PingFang SC"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      INPUT_FILE="${2:-}"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="${2:-}"
      shift 2
      ;;
    --dir)
      INPUT_DIR="${2:-}"
      shift 2
      ;;
    --recursive)
      RECURSIVE="${2:-}"
      shift 2
      ;;
    --overwrite)
      OVERWRITE="${2:-}"
      shift 2
      ;;
    --pdf-engine)
      PDF_ENGINE="${2:-}"
      shift 2
      ;;
    --cjk)
      CJK_MODE="${2:-}"
      shift 2
      ;;
    --cjk-font)
      CJK_FONT="${2:-}"
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

[[ "$OVERWRITE" == "true" || "$OVERWRITE" == "false" ]] || fail "--overwrite must be true or false"
[[ "$RECURSIVE" == "true" || "$RECURSIVE" == "false" ]] || fail "--recursive must be true or false"
[[ "$CJK_MODE" == "auto" || "$CJK_MODE" == "true" || "$CJK_MODE" == "false" ]] || fail "--cjk must be auto, true, or false"

if [[ -n "$INPUT_FILE" && -n "$INPUT_DIR" ]]; then
  fail "Use either --input or --dir, not both"
fi

if [[ -z "$INPUT_FILE" && -z "$INPUT_DIR" ]]; then
  fail "You must provide --input or --dir"
fi

require_cmd pandoc

pandoc_to_pdf() {
  local md_file="$1"
  local pdf_file="$2"
  local use_cjk="false"
  local header_file=""
  local -a cmd

  if [[ "$CJK_MODE" == "true" ]]; then
    use_cjk="true"
  elif [[ "$CJK_MODE" == "auto" ]]; then
    if grep -q '[一-龥]' "$md_file"; then
      use_cjk="true"
    fi
  fi

  if [[ -e "$pdf_file" && "$OVERWRITE" == "false" ]]; then
    echo "SKIP: output already exists: $pdf_file"
    return 2
  fi

  mkdir -p "$(dirname "$pdf_file")"

  cmd=(pandoc "$md_file" -o "$pdf_file")

  if [[ -n "$PDF_ENGINE" ]]; then
    cmd+=(--pdf-engine="$PDF_ENGINE")
  elif [[ "$use_cjk" == "true" ]]; then
    cmd+=(--pdf-engine=tectonic)
  fi

  if [[ "$use_cjk" == "true" ]]; then
    header_file="$(mktemp /tmp/convert-md-cjk-XXXXXX.tex)"
    cat > "$header_file" <<EOF
\usepackage{fontspec}
\usepackage{xeCJK}
\setCJKmainfont{$CJK_FONT}
EOF
    cmd+=(--include-in-header="$header_file")
  fi

  if ! "${cmd[@]}"; then
    if [[ -n "$header_file" ]]; then
      rm -f "$header_file"
    fi
    return 1
  fi

  if [[ -n "$header_file" ]]; then
    rm -f "$header_file"
  fi

  # Some engines may exit 0 but fail to materialize output.
  if [[ ! -s "$pdf_file" ]]; then
    echo "ERROR: PDF was not created or is empty: $pdf_file" >&2
    if [[ "$use_cjk" == "true" ]]; then
      echo "HINT: Try --cjk-font 'PingFang SC' or 'Songti SC' or 'Heiti SC'." >&2
    fi
    return 1
  fi

  echo "OK: $md_file -> $pdf_file"
  return 0
}

converted=0
skipped=0
failed=0

if [[ -n "$INPUT_FILE" ]]; then
  [[ -f "$INPUT_FILE" ]] || fail "Input markdown file does not exist: $INPUT_FILE"

  if [[ -z "$OUTPUT_FILE" ]]; then
    OUTPUT_FILE="${INPUT_FILE%.*}.pdf"
  fi

  if pandoc_to_pdf "$INPUT_FILE" "$OUTPUT_FILE"; then
    converted=$((converted + 1))
  else
    status=$?
    if [[ $status -eq 2 ]]; then
      skipped=$((skipped + 1))
    else
      failed=$((failed + 1))
    fi
  fi
else
  [[ -d "$INPUT_DIR" ]] || fail "Input directory does not exist: $INPUT_DIR"

  find_depth="-maxdepth 1"
  if [[ "$RECURSIVE" == "true" ]]; then
    find_depth=""
  fi

  # shellcheck disable=SC2086
  while IFS= read -r -d '' md_file; do
    pdf_file="${md_file%.*}.pdf"
    if pandoc_to_pdf "$md_file" "$pdf_file"; then
      converted=$((converted + 1))
    else
      status=$?
      if [[ $status -eq 2 ]]; then
        skipped=$((skipped + 1))
      else
        failed=$((failed + 1))
      fi
    fi
  done < <(find "$INPUT_DIR" $find_depth -type f -name '*.md' -print0)
fi

echo "Summary: converted=$converted skipped=$skipped failed=$failed"

if [[ $failed -gt 0 ]]; then
  exit 1
fi
