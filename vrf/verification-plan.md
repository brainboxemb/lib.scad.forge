# Forge verification plan

This document is the source plan for verification of `lib.scad.forge`. It
records **what needs to be proven, why it matters, and which evidence is
appropriate**. Generated output under `vrf/out/` is evidence from this plan;
it is not the plan itself.

## Verification model

Forge verification has two deliberately separate layers.

### Machine verification

Machine checks answer questions that can be decided exactly or mechanically:

- does every public entrypoint parse and generate the expected geometry type;
- do semantic resolution tokens select the exact shared tessellation policy;
- do transform families, including 2D plane-aware moves, execute successfully;
- do tagged CSG and cutter object/direct forms survive a real OpenSCAD render;
- do overlap token sets retain all requested faces/regions;
- does the umbrella entrypoint expose the combined API without hidden
  sub-entrypoint coupling.

Where a real CGAL build is useful, verification may render temporary STL files.
Those files are **test intermediates** and are not publication evidence.

2D-only transform checks render temporary SVG instead of forcing 2D geometry
through an STL export.

### Human verification

Human evidence answers questions where visual inspection is useful:

- are ordinary transform effects and orientation semantics visually plausible;
- is a coordinate frame visibly different from using a simple one-axis
  rotation as a generic substitute;
- does tagged CSG communicate the expected body/remove/keep result;
- do named cutter overlap regions extend in the intended local directions;
- do low/high/export resolution levels show increasing tessellation detail.

Human evidence is a small curated PNG set. It is organized by **verification
question**, not one image per API symbol.

## Verification questions and evidence

| Area | Verification question | Machine evidence | Human evidence |
| --- | --- | --- | --- |
| Resolution | Do `low`, `high`, and `export` select the exact Forge `$fa/$fs` policy without fixed `$fn`? | Assertions in `test/resolution.scad` plus rendered geometry | `resolution-levels.png` shows the visible tessellation progression |
| Placement and rotation | Do ordinary moves, axis moves, rotations and flips execute as valid geometry operations? | Every transform variant in `test/transform.scad` is exported | `transforms-overview.png` shows representative move/rotate/flip behavior |
| 2D project planes | Do XY, XZ and YZ 2D placement helpers remain independently usable as 2D operations? | Temporary SVG exports for `move2d`, `xzmove`, and `yzmove` | No dedicated image unless a future semantic risk requires one |
| Coordinate frames | Do direct and object frame APIs preserve explicit local-axis remapping semantics? | Direct and object frame variants render successfully | `coordinate-frame.png` compares local geometry, a simple Y rotation, and an explicit axis frame |
| Tagged CSG | Does `fg_diff()` produce `(body - remove) + keep`? | Render of `test/csg.scad` | `tagged-csg.png` shows construction roles beside the final result |
| Cutter overlap | Are direct/object cutter forms valid and are named overlap tokens retained independently? | Assertions and real renders in `test/cutter.scad` | `cutters-overlap.png` uses exaggerated overlap to make direction semantics visible |
| Umbrella entrypoint | Can a consumer use resolution, transforms, tagged CSG and cutters through `forge.scad` together? | Render of `test/umbrella.scad` | No separate image; successful composition is a machine/API concern |

## Evidence interpretation

Some contracts should **not** be judged from pixels.

The default `FG_OVERLAP_MM()` value is 0.001 mm. That is intentionally too
small to be useful as visual evidence. The exact value remains an assertion.
The cutter PNG uses a much larger explicit `overlap_mm` only to make selected
local face/region directions inspectable.

Likewise, PNGs do not prove exact transforms, dimensions or policy values.
They are review evidence for semantics and gross regressions; assertions and
successful OpenSCAD exports remain the machine proof for exact contracts.

## Published verification output

The intended published snapshot is compact:

```text
prod/vrf/
├── README.md
├── verification-plan.md
├── png/
│   ├── transforms-overview.png
│   ├── coordinate-frame.png
│   ├── tagged-csg.png
│   ├── cutters-overlap.png
│   └── resolution-levels.png
├── evidence/
├── orchestration/
└── publication-info.txt
```

Temporary STL/SVG machine outputs are created outside `vrf/out/` and removed
after verification. They therefore do not become part of `prod/vrf`.

## Change rules

Update this plan when a public Forge behavior introduces a new verification
risk or changes what counts as meaningful evidence.

Add a published PNG only when it gives a maintainer something useful to inspect.
Do not mirror the API surface mechanically in verification output.

A passing visual render does not replace an assertion where a value can be
checked exactly, and a passing machine render does not automatically justify
publishing its geometry artifact.
