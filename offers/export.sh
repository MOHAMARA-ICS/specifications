#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"

version="${1:-v2.2}"
if [[ $# -gt 1 ]] || [[ "$version" != "--from-word" && ! "$version" =~ ^v[0-9]+\.[0-9]+(-[a-z0-9-]+)?$ ]]; then
  printf 'Usage: bash export.sh [vMAJOR.MINOR[-draft-label]|--from-word]\n' >&2
  exit 2
fi

if [[ "${1:-}" == "--from-word" ]]; then
  version=v2.1
  pandoc 'archive/6 - STBL- NPFS - DALI - Subscriptions Offers - v2.1.docx' \
    --lua-filter=improve-content.lua \
    --lua-filter=normalize-offers.lua \
    --to='markdown-simple_tables-multiline_tables-grid_tables+pipe_tables' \
    --standalone --wrap=none --extract-media=assets \
    --output=subscriptions-offers-v2.1.md
fi

markdown="subscriptions-offers-$version.md"
pdf="subscriptions-offers-$version.pdf"
if [[ ! -f "$markdown" ]]; then
  printf 'Markdown source not found: %s\n' "$markdown" >&2
  exit 1
fi

temporary_directory=$(mktemp -d)
trap 'rm -rf -- "$temporary_directory"' EXIT
repeat_header_filter=()
if [[ "$version" == "v2.2-reorganisee" ]]; then
  repeat_header_filter+=(--lua-filter=repeat-template-header.lua)
fi
for pass in 1 2 3; do
  CONTENTS_DESTINATIONS="$temporary_directory/destinations.txt" \
    pandoc "$markdown" \
      --from=markdown-smart-implicit_figures --standalone --embed-resources \
      --lua-filter=format-contents.lua "${repeat_header_filter[@]}" \
      --number-sections \
      --output="$temporary_directory/specification.html"
  google-chrome --headless --no-pdf-header-footer \
    --user-data-dir="$temporary_directory/chrome" \
    --print-to-pdf="$temporary_directory/specification.pdf" \
    "file://$temporary_directory/specification.html"
  pdfinfo -dests "$temporary_directory/specification.pdf" > "$temporary_directory/next-destinations.txt"
  if [[ -f "$temporary_directory/destinations.txt" ]] && cmp -s "$temporary_directory/destinations.txt" "$temporary_directory/next-destinations.txt"; then
    mv -- "$temporary_directory/specification.pdf" "$PWD/$pdf"
    printf 'PDF: %s/%s\n' "$PWD" "$pdf"
    exit 0
  fi
  mv -- "$temporary_directory/next-destinations.txt" "$temporary_directory/destinations.txt"
done
printf 'PDF export failed: contents pagination did not stabilize.\n' >&2
exit 1