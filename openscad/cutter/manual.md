# Cutter helpers

`openscad/cutter.scad` owns reusable overlap-aware cutter specifications.

## Boolean overlap

`fg_overlap_mm()` returns the default **0.001 mm** CSG robustness overlap.
This is not fit clearance, printer tolerance or a design dimension.

## Box cutters

```openscad
use <../cutter.scad>

fg_cut_box(
    size_mm = [10, 20, 5],
    pos_mm = [5, 0, 0],
    overlap = [
        fg_left(),
        fg_right(),
        fg_back()
    ]
);
```

Box face tokens are local to the cutter:

| Token | Local face |
| --- | --- |
| `fg_left()` | X-min |
| `fg_right()` | X-max |
| `fg_front()` | Y-min |
| `fg_back()` | Y-max |
| `fg_bottom()` | Z-min |
| `fg_top()` | Z-max |

Opposite faces are independent because overlap is resolved by membership, not
by vector addition.

## Cylinder cutters

```openscad
fg_cut_cylinder(
    diameter_mm = 5,
    height_mm = 12,
    overlap = [
        fg_radial(),
        fg_top()
    ]
);
```

`fg_radial()` expands the diameter on both sides. `fg_bottom()` and
`fg_top()` extend local Z.

## Object form

Use `fg_box_cutter_create()` or `fg_cylinder_cutter_create()` when the
cutter specification should be stored as data, then emit it with
`fg_cutter_build(obj)`.

Cutter placement is part of the cutter object through `pos_mm` and
`rot_deg`. Cutter helpers are intentionally independently usable and do not
require importing Forge's transform sublayer.
