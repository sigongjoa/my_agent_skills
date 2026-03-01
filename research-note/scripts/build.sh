#!/usr/bin/env bash
# research-note build script
# Usage: build.sh <input.typ> [output.pdf]

set -e

TYP_FILE="$1"
PDF_FILE="${2:-${TYP_FILE%.typ}.pdf}"

if [[ -z "$TYP_FILE" ]]; then
  echo "Usage: build.sh <input.typ> [output.pdf]" >&2
  exit 1
fi

if [[ ! -f "$TYP_FILE" ]]; then
  echo "ERROR: File not found: $TYP_FILE" >&2
  exit 1
fi

echo "Compiling: $TYP_FILE → $PDF_FILE"
typst compile --root / "$TYP_FILE" "$PDF_FILE"

if [[ $? -eq 0 ]]; then
  # /root에 복사 (접근 용이하도록)
  DEST="/root/$(basename "$PDF_FILE")"
  cp "$PDF_FILE" "$DEST"
  echo ""
  echo "✅ PDF 생성 완료"
  echo "   원본: $PDF_FILE"
  echo "   복사본: $DEST"
else
  echo "❌ 컴파일 실패" >&2
  exit 1
fi
