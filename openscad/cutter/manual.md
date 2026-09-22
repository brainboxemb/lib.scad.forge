# Cutter helpers

`openscad/cutter.scad` owns reusable overlap-aware cutter specifications.

## Boolean overlap

`FG_OVERLAP_MM()` returns the default **0.001 mm** CSG robustness overlap.
This is not fit clearance, printer tolerance or a design dimension.

## Box cutters

```openscad
use <../cutter.scad>

fg_cut_box(
    size_mm = [10, 20, 5],
    pos_mm = [5, 0, 0],
    overlap = [
        FG_LEFT(),
        FG_RIGHT(),
        FG_BACK()
    ]
);
```

Box face tokens are local to the cutter. They are exposed as callable constants: technically zero-argument functions so normal OpenSCAD `use` imports them, but semantically fixed public tokens:

| Token | Local face |
| --- | --- |
| `FG_LEFT()` | X-min |
| `FG_RIGHT()` | X-max |
| `FG_FRONT()` | Y-min |
| `FG_BACK()` | Y-max |
| `FG_BOTTOM()` | Z-min |
| `FG_TOP()` | Z-max |

Opposite faces are independent because overlap is resolved by membership, not
by vector addition.

## Cylinder cutters

```openscad
fg_cut_cylinder(
    diameter_mm = 5,
    height_mm = 12,
    overlap = [
        FG_RADIAL(),
        FG_TOP()
    ]
);
```

`FG_RADIAL()` expands the diameter on both sides. `FG_BOTTOM()` and
`FG_TOP()` extend local Z.

## Object form

Use `fg_box_cutter_create()` or `fg_cylinder_cutter_create()` when the
cutter specification should be stored as data, then emit it with
`fg_cutter_build(obj)`.

Cutter placement is part of the cutter object through `pos_mm` and
`rot_deg`. Cutter helpers are intentionally independently usable and do not
require importing Forge's transform sublayer.
