# lib.scad.forge

Forge is the small shared OpenSCAD modeling layer for readable resolution
context, transforms, tagged CSG and overlap-aware cutters.

## Start here

- [Plan](doc/00-plan.md) — purpose, scope, working method, information sources
  and current direction.
- [Specification](doc/10-specification.md) — public and semantic contracts.
- [Design](doc/20-design.md) — how those contracts are implemented.
- [Verification](doc/30-verification.md) — how the contracts are proven.

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
evidence belongs under `vrf/out/` and is published through the normal
verification branch.
