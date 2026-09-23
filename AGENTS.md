# Repository agent guidance

Start locally:

1. read [doc/00-plan.md](doc/00-plan.md);
2. follow its links to the relevant Forge specification, architecture,
   detailed design, verification and API/source documentation.

Then load the shared BrainboxEmb agent guidance from
[brainboxemb.meta/AGENTS.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md).
That is the entrypoint for generic engineering workflow, Git/commit/PR rules and
shared SCAD conventions.

For tool-specific build, verification, publication or release behavior, read the
pinned `tools/tool.scad-project/AGENTS.md`.

Keep only Forge-specific routing or exceptions here. Durable shared rules belong
in `brainboxemb.meta`; durable Forge engineering knowledge belongs in the
numbered local documents.
