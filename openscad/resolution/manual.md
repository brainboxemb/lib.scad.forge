# Geometry resolution

Forge provides semantic geometry-resolution levels so public CAD interfaces do
not have to expose OpenSCAD tessellation details such as `$fn`.

## Public levels

```openscad
FG_RES_LOW()
FG_RES_HIGH()
FG_RES_EXPORT()
```

Use the level that describes the caller's intent:

- `FG_RES_LOW()` — fast interactive preview and development;
- `FG_RES_HIGH()` — normal design inspection and render work;
- `FG_RES_EXPORT()` — production mesh generation such as STL/3MF export.

`export` is deliberately not called `print`. Print resolution belongs to the
manufacturing/slicer process (layer height, line width, nozzle choice, and
similar settings), while these Forge levels control only CAD tessellation.

## Applying the policy

```openscad
use <../resolution.scad>

fg_res_apply(FG_RES_HIGH())
    my_part();
```

`fg_res_apply()` resets `$fn` to automatic mode and applies Forge's shared
`$fa` / `$fs` policy:

| Level | `$fa` | `$fs` |
| --- | ---: | ---: |
| low | 12° | 2.0 mm |
| high | 6° | 1.0 mm |
| export | 3° | 0.5 mm |

The policy changes tessellation only. It must not change nominal dimensions,
fit, clearance, feature semantics or object data.

## Interface pattern

Prefer passing the semantic level through a build/render interface:

```openscad
module part_build(
    obj,
    resolution = FG_RES_HIGH()
) {
    fg_res_apply(resolution)
        _part_build(obj);
}
```

Keep resolution out of the design object itself. The same design object should
be buildable at low, high or export resolution without becoming a different
design.
