# Engineering rules

## Commands  (fill these in for your stack)
- Unit tests: `TODO`
- Acceptance tests: `TODO`
- Fast gate, run by the Stop hook: `make check` = unit + acceptance + `crapper --changed` + `dryer --changed`
- Mutation testing (slow; at the end of a story or fix, not every slice): `mutator --changed`
- crapper, dryer and mutator are Martin's tools (github.com/unclebob/<name>). Installed at: `TODO`
  If one isn't installed or won't run, say so. Never substitute your own estimate of CRAP, duplication, or mutation results.

## How work flows
- Every code change follows the ub-mode skill (.claude/skills/ub-mode).
  Stories go through `/build`, bugs through `/fix`; those skills say which parts of ub-mode apply when.
- docs/design.md: rules, numbers, non-goals. docs/glossary.md: domain terms. docs/user-stories/US-NN-*.md: backlog.
- One story at a time: `/spec US-NN` → the human reviews and commits the spec → `/build US-NN`.
- features/*.feature files are the acceptance contract. Once committed they are approved and locked.
  Never change a spec to make code pass. If a spec is wrong or ambiguous, stop and ask.
- Don't build later stories early "while you're here".

## Quality bars  (ub-mode's, repeated here because this file is always loaded and skills aren't)
- Failing test first; see it fail for the expected reason; smallest change to pass.
- Tests check behavior a user of the code would see. A test that would still pass if every
  function returned nothing gets deleted. If an honest test is impractical, don't write a bad one.
- CRAP under 10 for every function. Duplication at or above 0.8 gets removed.
- Surviving mutants get killed with a test, or the dead code gets deleted.
- Check outside data where it enters; keep business logic in pure functions; dependencies point toward the domain.

## Commits
- Small, ordered commits. Each says why, what changed, and how you proved it. Never use `--no-verify`.
- Push: `TODO` (ub-mode says push to the main line at the end; replace with your team's rule, e.g. a PR branch)
