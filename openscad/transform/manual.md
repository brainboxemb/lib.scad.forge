# Transform helpers

`openscad/transform.scad` is Forge's focused readability layer over native OpenSCAD
transforms. It keeps the underlying coordinate model visible while avoiding
repeated low-level `translate()`, `rotate()`, `mirror()` and axis-remapping
matrix boilerplate in consumer code.

Forge uses the `fg_xf_*` subnamespace so transform operations stay visibly
grouped inside the wider `fg_*` modeling API.

## Choosing the right transform

| Intent | Prefer |
| --- | --- |
| Move by a normal XY or XYZ vector | `fg_xf_move()` |
| Move a 2D profile whose local axes represent project XZ | `fg_xf_xzmove()` |
| Move a 2D profile whose local axes represent project YZ | `fg_xf_yzmove()` |
| Move on one axis | `fg_xf_xmove()`, `fg_xf_ymove()`, `fg_xf_zmove()` |
| Rotate by Euler angles | `fg_xf_rot()` |
| Rotate on one axis | `fg_xf_xrot()`, `fg_xf_yrot()`, `fg_xf_zrot()` |
| Mirror geometry | `fg_xf_flip()` or an axis-specific `fg_xf_*flip()` |
| Store position + rotation as data | `fg_xf_create()` + `fg_xf_apply()` |
| Remap local coordinate axes | `fg_xf_frame()` |
| Store an axis remap as data | `fg_xf_frame_create()` + `fg_xf_apply()` |
| General affine/skew transform | native `multmatrix()` |

The library does not try to replace every native OpenSCAD transform. Use the
smallest helper that makes the design intent clearer.

## Simple placement

For normal 2D XY geometry, use a two-value move:

```openscad
fg_xf_move([10, 5])
    profile_2d();
```

For 3D geometry, use the normal three-value XYZ move:

```openscad
fg_xf_move([10, 0, 5])
    fg_xf_yrot(90)
        part();
```

When only one axis changes, use the axis-specific form:

```openscad
fg_xf_zmove(12)
    part();
```

These helpers intentionally have the same transform ordering as their nested
native OpenSCAD equivalents.

## 2D profiles on remapped project planes

OpenSCAD 2D geometry always uses a local X/Y coordinate pair. In CAD code that
pair can semantically represent another project plane, such as X/Z or Y/Z.

Do not hide that distinction in an unexplained two-value `translate()`.

For a normal XY profile, keep the ordinary move:

```openscad
fg_xf_move([x_mm, y_mm])
    profile_2d();
```

When local 2D X/Y represents project X/Z, write:

```openscad
fg_xf_xzmove([x_mm, z_mm])
    profile_2d();
```

When local 2D X/Y represents project Y/Z, write:

```openscad
fg_xf_yzmove([y_mm, z_mm])
    profile_2d();
```

The plane-aware helpers deliberately still perform a normal two-dimensional
OpenSCAD translation. Their value is semantic: the call site tells the reader
which project axes the two profile coordinates represent.

They are intended for 2D profile geometry. Use `fg_xf_move([x, y, z])` for a
normal 3D placement and `fg_xf_frame()` when child axes themselves must be
remapped.

## Transform objects

Use `fg_xf_create()` when the transform itself is meaningful data that should be
created once and reused:

```openscad
_mount_xf =
    fg_xf_create(
        pos_mm = [10, 0, 5],
        rot_deg = [0, 90, 0]
    );

fg_xf_apply(_mount_xf)
    mount();
```

A pose object contains a position in millimetres and Euler rotation in degrees.
`fg_xf_apply()` also accepts frame objects created by `fg_xf_frame_create()`.

The object form is useful when an owning object needs to carry placement state,
or when several pieces of geometry must share exactly the same transform. For a
single obvious operation, the direct `fg_xf_move()` / `fg_xf_*rot()` modules are
usually easier to read.

## Coordinate frames

A coordinate frame describes where the **local axes** of child geometry should
point.

Use `fg_xf_frame()` when the intent is axis remapping rather than an ordinary
Euler rotation. Supply any two orthogonal destination axes; the third is
derived so the result remains right-handed.

For example:

```openscad
fg_xf_frame(
    pos_mm = [20, 0, 0],
    x_axis = [0, 1, 0],
    y_axis = [0, 0, 1]
)
    linear_extrude(height = 16)
        profile();
```

This says:

```text
local +X -> global +Y
local +Y -> global +Z
local +Z -> global +X
origin   -> [20, 0, 0]
```

The equivalent raw matrix is harder to inspect:

```openscad
multmatrix([
    [0, 0, 1, 20],
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 0, 1]
])
    linear_extrude(height = 16)
        profile();
```

The frame form communicates the CAD intent without asking the reader to decode
matrix coefficients.

### Frame rules

- at least two of `x_axis`, `y_axis`, `z_axis` must be supplied;
- supplied axes must be non-zero vectors;
- the resolved axes must be mutually orthogonal;
- the frame must be right-handed;
- axis vector length is ignored: directions are normalized;
- `pos_mm` is the destination origin.

Forge transform helpers deliberately reject a non-orthogonal frame rather than
silently introducing skew.

## Reflected frames

A reflection changes handedness, so it is kept separate from `fg_xf_frame()`.

If an axis remap also needs a reflection, write that explicitly:

```openscad
fg_xf_frame(
    x_axis = [1, 0, 0],
    y_axis = [0, 0, 1]
)
    fg_xf_zflip()
        part();
```

That is easier to review than hiding the reflection inside a matrix.

Axis-specific mirrors are:

```openscad
fg_xf_xflip(); // mirror across YZ
fg_xf_yflip(); // mirror across XZ
fg_xf_zflip(); // mirror across XY
```

Use `fg_xf_flip(normal)` when the mirror-plane normal is not aligned to a primary
axis.

## What stays native

Keep native OpenSCAD when the native operation already expresses the intent
best. In particular:

- `scale()` remains native;
- `multmatrix()` remains appropriate for a genuine general affine transform
  or skew that `fg_xf_frame()` cannot represent;
- geometry-generating operations such as `linear_extrude()` and
  `rotate_extrude()` are not wrapped merely for naming consistency.

The goal is readable CAD, not hiding OpenSCAD.
