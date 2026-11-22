#!/usr/bin/env bash
# Stop hook from the ub-claude kit. Claude may not finish a turn while code has uncommitted
# changes and the fast quality gate (`make check`) fails.
# Mutation testing is too slow for this hook; /build and /fix run it at the end.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Only code changes trigger the gate. Docs, specs, Markdown and Claude config don't,
# so writing a spec while it waits for your approval isn't blocked.
changed=$(git status --porcelain -- . \
  ':(exclude)docs' ':(exclude).claude' ':(exclude)*.md' ':(exclude)*.feature' 2>/dev/null)
[ -z "$changed" ] && exit 0

# No `check` target means this repo has no gate to run (the ub-claude kit itself, for example).
make -n check >/dev/null 2>&1 || exit 0

if ! out=$(make check 2>&1); then
  echo "Quality gate failed (make check). Fix it before finishing; do not weaken tests or edit approved specs." >&2
  echo "$out" | tail -n 40 >&2
  exit 2
fi
exit 0
