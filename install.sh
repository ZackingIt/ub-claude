#!/usr/bin/env bash
# Install or update the ub-claude kit in a project repo.
#
#   ./install.sh /path/to/project
#
# Kit-owned files are replaced with this kit's version every time.
# Project-owned files are created from templates/ only if they don't exist yet, and are never overwritten.
# Run it again after improving the kit to update a project, then review the result with `git diff`.
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ $# -eq 1 ] || { echo "usage: $0 /path/to/project" >&2; exit 1; }
DEST="$(cd "$1" && pwd)"

[ "$DEST" != "$KIT" ] || { echo "That's the kit itself. Give the path to a project repo." >&2; exit 1; }
git -C "$DEST" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "$DEST is not a git repository." >&2; exit 1; }
command -v jq >/dev/null || { echo "install.sh needs jq (the hooks use it too)." >&2; exit 1; }

# Kit-owned: the same in every project. Change these in the kit, never inside a project.
KIT_OWNED=(
  .claude/skills/ub-mode
  .claude/skills/spec
  .claude/skills/build
  .claude/skills/fix
  .claude/hooks/guard-spec.sh
  .claude/hooks/gate.sh
  .claude/rules/ub-process.md
  docs/user-stories/README.md
)

# Project-owned: started from templates/, then the project's own.
PROJECT_OWNED=(
  CLAUDE.md
  Makefile
  docs/design.md
  docs/glossary.md
)

for p in "${KIT_OWNED[@]}"; do
  mkdir -p "$DEST/$(dirname "$p")"
  rm -rf "${DEST:?}/$p"
  cp -R "$KIT/$p" "$DEST/$p"
  echo "updated  $p"
done
chmod +x "$DEST"/.claude/hooks/*.sh

kept_claude_md=false
for p in "${PROJECT_OWNED[@]}"; do
  if [ -e "$DEST/$p" ]; then
    echo "kept     $p"
    [ "$p" = CLAUDE.md ] && kept_claude_md=true
  else
    mkdir -p "$DEST/$(dirname "$p")"
    cp "$KIT/templates/$p" "$DEST/$p"
    echo "created  $p"
  fi
done

# Register the kit's hooks in .claude/settings.json, keeping everything already there.
# A hook counts as registered if its script name already appears under that event.
settings="$DEST/.claude/settings.json"
[ -e "$settings" ] || echo '{}' > "$settings"
tmp="$(mktemp)"
jq --slurpfile kit "$KIT/.claude/settings.json" '
  reduce ($kit[0].hooks | to_entries[]) as $event (.;
    reduce $event.value[] as $entry (.;
      ($entry | tostring | capture("hooks/(?<script>[A-Za-z0-9_-]+[.]sh)").script) as $script
      | if ((.hooks[$event.key] // []) | tostring | contains($script)) then .
        else .hooks[$event.key] = ((.hooks[$event.key] // []) + [$entry]) end))
' "$settings" > "$tmp"
if cmp -s "$tmp" "$settings"; then
  rm "$tmp"; echo "kept     .claude/settings.json (kit hooks already registered)"
else
  mv "$tmp" "$settings"; echo "merged   .claude/settings.json (registered the kit's hooks)"
fi

echo
if ! make -C "$DEST" -n check >/dev/null 2>&1; then
  echo "WARNING: there's no 'make check' target, so the quality gate won't run. Add one to the Makefile." >&2
fi
if $kept_claude_md && ! grep -q '^## Commands' "$DEST/CLAUDE.md"; then
  echo "Your CLAUDE.md was kept. Add the sections the kit expects (Commands, Pushing) from the kit's templates/CLAUDE.md."
elif grep -q TODO "$DEST/CLAUDE.md"; then
  echo "Next: fill in the TODOs in CLAUDE.md and the Makefile's check target."
fi
echo "Review the changes:  git -C \"$DEST\" status --short"
