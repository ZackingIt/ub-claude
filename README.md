# Uncle Bob–style workflow for Claude Code (ub-mode only)

One Claude Code session, Robert C. Martin's [`ub-mode`](https://github.com/unclebob/ub-mode) skill, and his three measuring tools. No specialist agents.

**You own intent (the acceptance spec). Claude does the work with ub-mode. Tools and hooks decide when it's done.**

## What's here

| File | What it does |
|---|---|
| `CLAUDE.md` | Project rules and commands. Claude reads it at the start of every session. |
| `.claude/skills/spec/` | `/spec US-NN`: turn one story into a Gherkin spec for you to approve |
| `.claude/skills/build/` | `/build US-NN`: build an approved story, using each part of ub-mode at the right moment |
| `.claude/skills/fix/` | `/fix <bug>`: fix a bug with ub-mode's root-cause rules |
| `.claude/hooks/guard-spec.sh` | Blocks Claude from editing a spec you've committed |
| `.claude/hooks/gate.sh` | Blocks Claude from finishing while `make check` fails |
| `docs/` | `design.md` (rules and numbers), `glossary.md` (domain terms), `user-stories/` (backlog) |
| `later/agents/` | Specialist agents (hardener, architect, qa), **inactive**. Move one into `.claude/agents/` only if you hit the problem it solves. |

## Install

1. Copy `.claude/`, `CLAUDE.md`, and `docs/` into your repo. Run `chmod +x .claude/hooks/*.sh`. The hooks need `jq`.
2. Add ub-mode to the repo and commit it, so everyone on the team runs the same version:
   ```bash
   mkdir -p .claude/skills/ub-mode && curl -fsSL https://raw.githubusercontent.com/unclebob/ub-mode/master/SKILL.md -o .claude/skills/ub-mode/SKILL.md
   ```
3. Install the three tools ub-mode tells Claude to run. The skill only says to use them; it can't measure anything itself:
   [crapper](https://github.com/unclebob/crapper) (complexity × coverage, keep under 10),
   [dryer](https://github.com/unclebob/dryer) (duplication), and
   [mutator](https://github.com/unclebob/mutator) (mutation testing).
   They support Clojure, Java, Go, TypeScript, Rust, and Python, and need Python to run. Clone `crapper` next to `mutator`.
4. Fill in the `TODO`s in `CLAUDE.md`, add a `make check` target, and set `CODE_DIRS` in `gate.sh` to your source and test folders.

## Three ways to use ub-mode

| Work | Type | What happens |
|---|---|---|
| A small change | `/ub-mode add a --dry-run flag to export` | ub-mode's rules apply to that one change |
| A story | `/spec US-03`, review and commit, then `/build US-03` | Plan → test-first slices → mutation pass → log |
| A bug | `/fix totals are wrong when the cart is empty` | Reproduce with a failing test → fix the cause → check |

Start a fresh session for each story. Long sessions get summarized, and the skill's rules can drop out of view.
`CLAUDE.md` repeats the quality bars because it's always loaded.

## Which part of ub-mode applies when

ub-mode is one flat checklist that says "every change: make it work, make it right, follow practice."
`/build` and `/fix` decide when each section runs, so Claude doesn't run the slow mutator after every line or redesign the domain for a typo.

| Moment | ub-mode sections |
|---|---|
| Before coding a story | Outcome-Oriented Execution, Foundational Thinking, Redesign From First Principles, Subtract Before You Add, Architecture, Sequence work into verifiable units |
| Every slice (minutes) | TDD, Test Behavior Not Implementation, Laziness Protocol, Refactoring, Crapper, Dryer, Commit and Push |
| End of a story | Mutator, Guard the Context Window, Keep a Log, Commit and Push |
| A bug | Fix Root Causes, then the slice and end-of-story steps on the changed files |
| Two fixes failed the same way | Attack the Premise |
| Repetitive work | Build the Lever |
| Using git worktrees | Worktree Cleanup |

## Notes
- One feature file per story, so a new story never needs to edit an approved spec.
- To change an approved spec, edit it yourself. Only a human changes the contract.
- The guard blocks Claude's Edit and Write tools, not a shell command that rewrites the file. It's a guardrail, not a sandbox.
- If Claude keeps skipping steps, the next move is a script that runs each stage with `claude -p`, not more agents.
