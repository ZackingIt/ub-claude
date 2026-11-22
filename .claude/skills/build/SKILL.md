---
name: build
description: Implement one approved user story with ub-mode, applying each part of ub-mode at the moment it fits. Use when the user runs /build US-NN.
argument-hint: US-NN
disable-model-invocation: true
---
Implement story $ARGUMENTS. Its approved acceptance spec is committed under features/ and is locked.

First, invoke the ub-mode skill. ub-mode holds the rules; this skill says when each of its sections applies. Section names below are ub-mode's.

## 1. Plan (once, before any code)
Apply: Outcome-Oriented Execution, Foundational Thinking, Redesign From First Principles, Subtract Before You Add, Architecture, Sequence work into verifiable units.
- The end state you can check: the story's feature file passes and `make check` is green.
- Get the data shape right first. Decide where outside data enters (Boundary Discipline) and how to make illegal states impossible (Model the Domain, Type System Discipline). Add new domain terms to docs/glossary.md.
- If the story doesn't fit the current design, don't bolt it on. Say what you would have built if it had been there from the start, and plan it in pieces.
- List anything to remove before adding.
- Break the story into slices, one scenario or example row each, ordered so each slice can be checked on its own.

Show the human the plan in a few lines. Wait for a go-ahead only if it includes a redesign or removes existing behavior; otherwise continue.

## 2. Each slice (repeat until the story's scenarios pass)
Apply: TDD, Test Behavior Not Implementation, Laziness Protocol, Refactoring, Crapper, Dryer, Commit and Push.
1. Write the failing test: a unit test, or the step definitions for the scenario. Run it and see it fail for the reason you expect.
2. Make the smallest change that makes it pass.
3. With tests green, make it right: refactor (the green tests pin the behavior), then run `crapper --changed` and `dryer --changed`. Fix any function at CRAP 10 or above and any duplication at 0.8 or above.
4. Commit: why, what changed, and how you proved it.

Don't run the mutator during slices. It's slow and belongs at the end.

## 3. Finish (once)
Apply: Mutator, Guard the Context Window, Keep a Log, Commit and Push.
1. Run `mutator --changed`, one file at a time. Cover the uncovered, kill the survivors, delete dead code. If the output is long, run it in a subagent and keep only the summary.
2. Run `make check` and the full acceptance suite.
3. Commit, then push as CLAUDE.md says.
4. Set the story's status to `done` and report your log: each action and why you took it.

## When something goes wrong
- A test fails for a reason you didn't expect, or you find a bug: Fix Root Causes. Reproduce it with a failing test first. A guard that only hides the failure is not a fix.
- Two fixes built on the same assumption fail the same check: Attack the Premise. Stop, write the assumption in one sentence, remove it, and only then try again.
- The work is repetitive and not obvious at a glance: Build the Lever. Do one unit by hand, then write a script that does the rest the same way.
- The approved spec looks wrong or can't be met honestly: stop and ask the human. Never edit it.
