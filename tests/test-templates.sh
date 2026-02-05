#!/usr/bin/env bash
# Validate chezmoi templates can parse without errors
# Skips 1Password calls by checking template syntax only

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
SKIP=0

check_template() {
  local file="$1"
  local relative="${file#$REPO_ROOT/}"

  # Skip templates that require 1Password (contain onepasswordRead)
  if grep -q 'onepasswordRead' "$file"; then
    echo "  SKIP $relative (requires 1Password)"
    ((SKIP++))
    return 0
  fi

  # Check balanced template delimiters
  local opens closes
  opens=$(grep -o '{{' "$file" 2>/dev/null | wc -l | tr -d ' ')
  closes=$(grep -o '}}' "$file" 2>/dev/null | wc -l | tr -d ' ')

  if [[ "$opens" -ne "$closes" ]]; then
    echo "  FAIL $relative (unbalanced delimiters: {{ = $opens, }} = $closes)"
    ((FAIL++))
    return 1
  fi

  echo "  PASS $relative"
  ((PASS++))
  return 0
}

echo "Validating chezmoi templates..."
echo ""

while IFS= read -r -d '' file; do
  check_template "$file" || true
done < <(find "$REPO_ROOT" -name '*.tmpl' ! -path '*/.git/*' -print0)

echo ""
echo "Results: $PASS passed, $FAIL failed, $SKIP skipped"

if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
