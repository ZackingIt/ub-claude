#!/usr/bin/env bash
# Stop hook: Claude may not finish a turn while implementation work is in progress
# and the fast quality gate (unit + acceptance + CRAP + DRY) is failing.
# Mutation testing is too slow for this hook; /build and /fix run it at the end.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Only gate when production or test code has uncommitted changes.
# (Writing specs in features/ or qa/ while waiting for your approval is not gated.)
CODE_DIRS="src test spec"   # <- adjust to your layout
[ -z "$(git status --porcelain -- $CODE_DIRS 2>/dev/null)" ] && exit 0

if ! out=$(make check 2>&1); then
  echo "Quality gate failed (make check). Fix it before finishing; do not weaken tests or edit approved specs." >&2
  echo "$out" | tail -n 40 >&2
  exit 2
fi
exit 0
