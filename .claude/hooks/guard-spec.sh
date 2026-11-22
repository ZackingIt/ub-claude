#!/usr/bin/env bash
# PreToolUse guard: an acceptance spec becomes "approved" when the human commits it.
# After that, agents may not edit it. Uncommitted (draft) specs stay editable.
command -v jq >/dev/null || { echo "guard-spec.sh needs jq installed" >&2; exit 2; }

file=$(jq -r '.tool_input.file_path // empty')
case "$file" in
  */features/*.feature|features/*.feature) ;;
  *) exit 0 ;;
esac

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
  echo "BLOCKED: $file is an approved acceptance spec (committed by the human)." >&2
  echo "Do not change the spec to make code pass. If the spec is wrong or ambiguous, stop and ask the human." >&2
  exit 2
fi
exit 0
