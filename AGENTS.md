# Repository agent guidance

Use the repository documents as navigation rather than reconstructing Forge
intent from source or chat history:

1. [doc/00-plan.md](doc/00-plan.md) for work context;
2. [doc/10-specification.md](doc/10-specification.md) for why the affected
   capability exists;
3. [doc/20-design.md](doc/20-design.md) for library architecture;
4. follow the relevant detailed-design link when one exists;
5. [doc/30-verification.md](doc/30-verification.md) before changing tests or
   evidence.

Public API usage/deprecation documentation is source-driven in `openscad/*.scad`.
For branch, CI, publication or release mechanics, read the pinned
`tools/tool.scad-project/AGENTS.md`.

Keep durable engineering facts in the owning document and do not duplicate
them here.
