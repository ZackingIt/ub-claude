---
name: fix
description: Fix a bug with ub-mode's root-cause rules. Use when the user runs /fix followed by a description of the bug.
argument-hint: <what's wrong>
disable-model-invocation: true
---
Bug: $ARGUMENTS

First, invoke the ub-mode skill. This skill says which of its sections apply to a bug fix.

1. Reproduce it (Fix Root Causes, TDD). Write a test that fails because of the bug, checking what the user of the code would see (Test Behavior, Not Implementation). See it fail for the reason you expect. If you can't reproduce it, stop and report what you tried.
2. Find the cause, not the symptom. A guard, retry, or try/catch that only hides the failure is not a fix.
3. Make the smallest change that fixes the cause (Laziness Protocol). If the real fix is a design change, say so before making it (Redesign From First Principles).
4. If two fixes built on the same assumption fail, stop (Attack the Premise). Write the assumption in one sentence, remove it, then continue.
5. Make it right: refactor, run `crapper --changed` and `dryer --changed`, then `mutator --changed` on the files you touched.
6. If the bug shows an approved acceptance spec is wrong or missing a case, stop and tell the human. The spec may need a new scenario, and only the human changes specs.
7. Commit (why, what changed, how you proved it) and report your log.
