# Project instructions

The general process rules (test-first, quality bars, locked specs) load from `.claude/rules/ub-process.md`,
which the ub-claude kit installs. This file is for what's specific to this project. Fill in the TODOs.

## Stack
- Language and framework: TODO
- Where code and tests live: TODO

## Commands
- Unit tests: `TODO`
- Acceptance tests: `TODO`
- Fast gate: `make check` (see Makefile). It must run unit + acceptance + `crapper --changed` + `dryer --changed`.
- Mutation testing: `mutator --changed`
- crapper, dryer and mutator are installed at: `TODO`

## Pushing
- TODO: for example "push to main at the end of each story" or "push a branch and open a pull request".

## Project notes
- Anything else Claude should know about this project.
