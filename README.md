# lib.scad.forge

Lightweight object-aware OpenSCAD modeling library for readable transforms,
tagged CSG operations, shared geometry resolution and reusable cutters.

Forge is the shared modeling layer for the brainboxemb SCAD portfolio. It stays
deliberately smaller than BOSL2 or Relativity.scad: no attachment framework,
selector language or replacement primitive system.

## Documentation

Forge API/reference documentation is **source-driven**. The structured comments
next to the public functions and modules are the authority and use the upstream
`openscad_docsgen` format, similar to BOSL2.

Start from the source family that owns the question:

- [Transforms](openscad/transform.scad) — placement, rotations, reflections and coordinate frames;
- [Geometry resolution](openscad/resolution.scad) — low/high/export policy and resolution scope;
- [Tagged CSG](openscad/csg.scad) — body/remove/keep construction roles;
- [Cutters](openscad/cutter.scad) — overlap-aware box and cylinder cutters;
- [Umbrella entrypoint](openscad/forge.scad) — complete Forge import.

The shared SCAD runtime already provides `openscad-docsgen`. Forge's normal
`scad-project docs-lint` / verification path validates the structured source
comments through that upstream parser.

To generate a browseable local Markdown reference, run this inside the shared
SCAD runtime:

```bash
./scripts/build-api-docs.sh
```

Generated documentation is written below `bld/api/` and is intentionally not
committed to the source branch. The generated set includes the per-file
reference plus table of contents, function/module index, topics index and cheat
sheet.

The older `openscad/*/manual.md` paths are retained only as compatibility
pointers; they are no longer independent documentation authorities.

## Quick start

For normal use, import the umbrella entrypoint:

```openscad
use <openscad/forge.scad>

fg_diff() {
    fg_body()
        fg_xf_zmove(5)
            body();

    fg_remove()
        fg_cut_box(
            size_mm = [10, 20, 5],
            overlap = [
                FG_LEFT(),
                FG_RIGHT(),
                FG_BACK()
            ]
        );
}
```

For a focused dependency, import a sub-entrypoint directly:

```openscad
use <openscad/resolution.scad>
use <openscad/transform.scad>
use <openscad/csg.scad>
use <openscad/cutter.scad>
```

## Public API families

| Family | Purpose |
| --- | --- |
| `FG_RES_*()` / `fg_res_apply()` | semantic low/high/export geometry resolution and shared tessellation policy |
| `fg_xf_*` | moves, rotations, mirrors, transform objects and coordinate frames |
| `fg_diff()` / role modules | explicit body/remove/keep CSG |
| `fg_cut_*` / cutter objects | overlap-aware box and cylinder cutters |
| `FG_LEFT()`, etc. | callable constant tokens for local cutter overlap |
| `FG_OVERLAP_MM()` | fixed 0.001 mm Boolean robustness allowance |

## Scope

Forge owns generic modeling mechanics. It does **not** own mechanical
interfaces, clearances, printer tolerances or product dimensions.

Native OpenSCAD remains appropriate when it is simpler. In particular, general
affine/skew transforms may still use `multmatrix()`.

## Repository layout

```text
openscad/
  forge.scad
  resolution.scad
  transform.scad
  csg.scad
  cutter.scad

scripts/
  build-api-docs.sh

test/
  umbrella.scad
  resolution.scad
  transform.scad
  csg.scad
  cutter.scad
```
