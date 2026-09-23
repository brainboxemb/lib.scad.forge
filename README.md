# lib.scad.forge

Forge is the small shared OpenSCAD modeling layer for readable resolution
context, transforms, tagged CSG and overlap-aware cutters.

## Start here

- [Plan](doc/00-plan.md) — work method, information sources, current focus and roadmap.
- [Specification](doc/10-specification.md) — why Forge and its functional areas exist.
- [Design](doc/20-design.md) — library architecture and responsibility split.
- [Resolution detailed design](doc/21-resolution-context.md) — how resolution context is implemented.
- [Verification](doc/30-verification.md) — how intent and design are checked.

Public API/reference documentation lives beside the owning `.scad` source in
`openscad/` using the `openscad_docsgen` format. Generate the local reference
with:

```bash
./scripts/build-api-docs.sh
```

For normal use:

```openscad
use <openscad/forge.scad>
```

Generated API documentation belongs under `bld/api/`. Generated verification
evidence belongs under `vrf/out/`.
