# ub-claude

A Claude Code setup for building software the way Robert C. Martin describes: his
[`ub-mode`](https://github.com/unclebob/ub-mode) skill, his three measuring tools, and two hooks that enforce the checks.
One Claude session per story, no specialist agents.

**You own intent (the acceptance spec). Claude does the work with ub-mode. Tools and hooks decide when it's done.**

This repo is the master copy. You don't build software in it: `install.sh` copies it into each project repo,
and running it again later updates that project.

## Kit files and project files

| Owned by the kit: replaced on every install | Owned by the project: created once, then yours |
|---|---|
| `.claude/skills/ub-mode/`: Martin's skill (MIT) | `CLAUDE.md`: stack, commands, tool paths, push rule |
| `.claude/skills/spec/`: `/spec US-NN` turns one story into a Gherkin spec for you to approve | `Makefile`: the `make check` quality gate |
| `.claude/skills/build/`: `/build US-NN` builds an approved story with ub-mode | `docs/design.md`: rules, numbers, non-goals, big decisions |
| `.claude/skills/fix/`: `/fix <bug>` fixes a bug from its root cause | `docs/glossary.md`: domain terms |
| `.claude/rules/ub-process.md`: the general rules, loaded every session | `docs/user-stories/US-NN-*.md`, `features/`, `qa/`, your code and tests |
| `.claude/hooks/guard-spec.sh`: blocks Claude from editing a spec you've committed | `.claude/settings.json`: yours; install adds the kit's two hooks to it |
| `.claude/hooks/gate.sh`: blocks Claude from finishing while `make check` fails | |
| `docs/user-stories/README.md`: how to write a story | |

The starting versions of the project files are in `templates/`.
To change how you work in every project, edit the kit and reinstall. Don't edit kit-owned files inside a project: the next install overwrites them.

`later/agents/` holds optional specialist agents (hardener, architect, qa). install.sh doesn't copy them.
Add one to a project's `.claude/agents/` only if you hit the problem it solves.

## Set up a project

1. Clone this repo next to your project. (In a Claude Code cloud session, attach both repos to the session and ask Claude to run step 2.)
2. Run the installer against the project. It needs `git` and `jq`:
   ```bash
   ./install.sh /path/to/your-project
   ```
3. Install the three tools ub-mode tells Claude to run. The skill only says to use them; it can't measure anything itself:
   [crapper](https://github.com/unclebob/crapper) (complexity × coverage, keep under 10),
   [dryer](https://github.com/unclebob/dryer) (duplication), and
   [mutator](https://github.com/unclebob/mutator) (mutation testing).
   They support Clojure, Java, Go, TypeScript, Rust, and Python, and need Python to run. Clone `crapper` next to `mutator`.
4. Fill in the `TODO`s in the project's `CLAUDE.md` and its `make check` target.
   Until `make check` is real, the gate blocks Claude from finishing any code change, so set it up first.
   A good first story does exactly that: project layout, test pipeline, and the gate.
5. Commit the installed files in the project.

## Update a project

When you improve the kit, run `./install.sh /path/to/your-project` again, review with `git diff` in the project, and commit.
Your project files aren't touched. If the kit stops shipping a file, delete it from the project by hand.

To move ub-mode to Martin's latest version, update it here in the kit, then reinstall:
```bash
curl -fsSL https://raw.githubusercontent.com/unclebob/ub-mode/master/SKILL.md -o .claude/skills/ub-mode/SKILL.md
```

## Using it

| Work | Type | What happens |
|---|---|---|
| A small change | `/ub-mode add a --dry-run flag to export` | ub-mode's rules apply to that change |
| A story | `/spec US-03`, review and commit, then `/build US-03` | Plan → test-first slices → mutation pass → log |
| A bug | `/fix totals are wrong when the cart is empty` | Reproduce with a failing test → fix the cause → check |

Start a fresh session for each story. The rules in `.claude/rules/ub-process.md` load in every session,
so the core quality bars hold even when you haven't typed `/ub-mode`.

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
- The gate only runs for code changes. Edits to `docs/`, `.claude/`, Markdown files and `.feature` files don't trigger it,
  so Claude can write a spec and stop to wait for your approval.
- The guard blocks Claude's Edit and Write tools, not a shell command that rewrites the file. It's a guardrail, not a sandbox.
- If Claude keeps skipping steps, the next move is a script that runs each stage with `claude -p`, not more agents.
