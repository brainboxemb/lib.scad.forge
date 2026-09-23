# Repository agent guidance

Start with the Forge-local engineering context:

1. read [doc/00-plan.md](doc/00-plan.md);
2. follow its links to the relevant specification, design, detailed design,
   verification and source/API documentation.

For shared BrainboxEmb working conventions, read
[brainboxemb.meta/AGENTS.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md).
That shared entrypoint owns generic Git/commit/PR/CI workflow and routes to the
current SCAD domain conventions.

Do not inherit `AGENTS.md` from pinned tools or libraries as Forge working
instructions. When exact dependency behavior matters, use Forge's committed
configuration/gitlinks together with the pinned dependency's README, docs,
source and tests.

Keep only Forge-specific navigation or exceptions here. Durable Forge
engineering knowledge belongs in the numbered local documents.
