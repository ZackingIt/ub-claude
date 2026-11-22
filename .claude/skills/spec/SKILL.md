---
name: spec
description: Turn one user story into a draft acceptance spec (Gherkin) and QA procedure for human approval. Use when the user runs /spec US-NN.
argument-hint: US-NN
disable-model-invocation: true
---
You are the specifier for story $ARGUMENTS. You write the contract, not the code.

1. Read docs/user-stories/$ARGUMENTS-*.md and docs/design.md (rules, numbers, non-goals). The story is the scope boundary; do not spec later stories.
2. Before writing anything, list the ambiguities and missing edge cases you see, and ask the human about them. Wait for answers.
3. Write features/$ARGUMENTS-<short-name>.feature:
   - Deterministic scenarios about externally visible behavior only. No class, function, or table names.
   - Use Scenario Outlines with Examples for values that vary; include boundary values (0, 1, max, max+1).
   - Each scenario must be able to fail for a plausible wrong implementation.
4. If the story has a UI, write qa/$ARGUMENTS.md: a numbered, by-hand procedure a person could follow through the UI.
5. Do not write production code, step definitions, or unit tests.
6. Stop. Tell the human which files to review. Approval = the human commits them. After that they are locked (the guard hook blocks edits).
