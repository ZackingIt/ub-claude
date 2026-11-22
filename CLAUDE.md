# ub-claude kit

This repo is the master copy of the ub-claude process, not a software project.
`install.sh` copies it into project repos; README.md explains how.

- Kit-owned files (the KIT_OWNED list in install.sh) are overwritten in projects on every install.
  Keep them free of anything project-specific.
- `templates/` holds starting points for project-owned files. install.sh creates those only when they're missing.
- `.claude/skills/ub-mode/` is Robert C. Martin's skill (MIT). Update it from github.com/unclebob/ub-mode; don't edit it here.
- After changing install.sh or a hook, test it against a scratch git repo before committing.
