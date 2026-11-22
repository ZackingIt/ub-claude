# User stories

Adapted from the story rules in Robert C. Martin's missile-command repo
(github.com/unclebob/missile-command, docs/user-stories/README.md).

- Each story is one externally visible behavior slice: something a user could see change.
- Stories stay ignorant of code structure. No "add module X" or "create table Y".
- Point the specifier at docs/design.md for numbers, constants, and non-goals.
  The story is the scope boundary for its cycle.
- Don't implement later stories early unless the current story's acceptance criteria require it.
- Status: `backlog` → `in-spec` → `in-build` → `done`.

File name: `US-NN-short-title.md`

```markdown
# US-03 Fire a missile
Status: backlog
Depends on: US-02

## Story
As a player, I want to fire from a battery so that I can intercept incoming missiles.

## Acceptance criteria
- The selected battery loses exactly one missile; the others keep theirs.
- An empty or destroyed battery cannot fire.

## Out of scope
- Scoring, sound.

## Notes for specifier
- Use Gherkin parameters for ammo counts.
```
