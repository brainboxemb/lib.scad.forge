# Repository agent guidance

Start with the repository documentation instead of reconstructing Forge intent
from source or chat history:

1. read [doc/00-plan.md](doc/00-plan.md);
2. read [doc/10-specification.md](doc/10-specification.md) for affected public
   contracts;
3. read [doc/20-design.md](doc/20-design.md) before changing implementation;
4. read [doc/30-verification.md](doc/30-verification.md) before changing tests
   or verification evidence.

Public API usage documentation is source-driven in `openscad/*.scad`.

For branch, CI, publication or release mechanics, read the pinned
`tools/tool.scad-project/AGENTS.md`.

Keep durable engineering facts in the owning numbered document. Do not duplicate
the plan, contracts, design rationale or verification strategy in this file.

When changing a public Forge contract, update the owning specification/API
documentation and its verification in the same coherent change. Preserve
released API compatibility unless the change explicitly plans a breaking
release.
