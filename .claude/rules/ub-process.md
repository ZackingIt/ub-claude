# ub-claude process

These rules come from the ub-claude kit and are the same in every project.
Don't edit this file inside a project: change it in the ub-claude repo and re-run its install.sh.
Project-specific commands, tool paths, and the push rule are in this project's CLAUDE.md.

## How work flows
- Every code change follows the ub-mode skill (.claude/skills/ub-mode).
  Stories go through `/build`, bugs through `/fix`; those skills say which parts of ub-mode apply when.
- docs/design.md: rules, numbers, non-goals, and decisions that are expensive to change.
  docs/glossary.md: domain terms. docs/user-stories/US-NN-*.md: the backlog.
- One story at a time per session: `/spec US-NN` → the human reviews and commits the spec → `/build US-NN`.
- features/*.feature files are the acceptance contract. Once committed they are approved and locked.
  Never change a spec to make code pass. If a spec is wrong or ambiguous, stop and ask.
- Don't build later stories early "while you're here".

## Quality bars  (ub-mode's, repeated here because rules are always loaded and skills aren't)
- Failing test first; see it fail for the expected reason; smallest change to pass.
- Tests check behavior a user of the code would see. A test that would still pass if every
  function returned nothing gets deleted. If an honest test is impractical, don't write a bad one.
- CRAP under 10 for every function. Duplication at or above 0.8 gets removed.
- Surviving mutants get killed with a test, or the dead code gets deleted.
- Check outside data where it enters; keep business logic in pure functions; dependencies point toward the domain.

## Checks and tools
- `make check` is the fast gate: unit + acceptance + `crapper --changed` + `dryer --changed`.
  A Stop hook runs it whenever code has uncommitted changes, and you can't finish until it passes.
- Mutation testing (`mutator --changed`) is slow: run it at the end of a story or fix, not every slice.
- crapper, dryer and mutator are Martin's tools (github.com/unclebob/<name>). CLAUDE.md says where they're installed.
  If one isn't installed or won't run, say so. Never substitute your own estimate of CRAP, duplication, or mutation results.

## Commits
- Small, ordered commits. Each says why, what changed, and how you proved it. Never use `--no-verify`.
- Push the way this project's CLAUDE.md says.
