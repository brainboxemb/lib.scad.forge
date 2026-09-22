# lib.scad.forge

Lightweight object-aware OpenSCAD modeling library for readable transforms,
tagged CSG operations and reusable cutters.

Forge is the shared modeling layer for the brainboxemb SCAD portfolio. It stays
deliberately smaller than BOSL2 or Relativity.scad: no attachment framework,
selector language or replacement primitive system.

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
                fg_left(),
                fg_right(),
                fg_back()
            ]
        );
}
```

For a focused dependency, import a sub-entrypoint directly:

```openscad
use <openscad/transform.scad>
use <openscad/csg.scad>
use <openscad/cutter.scad>
```

## Public API families

| Family | Purpose |
| --- | --- |
| `fg_xf_*` | moves, rotations, mirrors, transform objects and coordinate frames |
| `fg_diff()` / role modules | explicit body/remove/keep CSG |
| `fg_cut_*` / cutter objects | overlap-aware box and cylinder cutters |
| `fg_left()`, etc. | readable local cutter-overlap tokens |

Documentation:

- [Forge overview](openscad/forge/manual.md)
- [Transforms](openscad/transform/manual.md)
- [Tagged CSG](openscad/csg/manual.md)
- [Cutters](openscad/cutter/manual.md)

## Scope

Forge owns generic modeling mechanics. It does **not** own mechanical
interfaces, clearances, printer tolerances or product dimensions.

Native OpenSCAD remains appropriate when it is simpler. In particular, general
affine/skew transforms may still use `multmatrix()`.

## Repository layout

```text
openscad/
  forge.scad
  transform.scad
  csg.scad
  cutter.scad

test/
  umbrella.scad
  transform.scad
  csg.scad
  cutter.scad
```
