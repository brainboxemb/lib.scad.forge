# Forge verification

This document defines the verification strategy for Forge. Generated output
under `vrf/out/` is evidence from this plan; it is not the source authority.

Related documents:

- [00-plan.md](00-plan.md) — purpose, scope and working method;
- [10-specification.md](10-specification.md) — contracts being proven;
- [20-design.md](20-design.md) — implementation model.

## Verification model

Forge verification has two deliberately separate layers.

### Machine verification

Machine checks answer questions that can be decided exactly or mechanically:

- does every public entrypoint parse and generate the expected geometry type;
- do semantic resolution tokens select the exact shared tessellation policy;
- do resolution contexts obey child/restoration/nesting contracts;
- do transform families, including 2D plane-aware moves, execute successfully;
- do tagged CSG and cutter object/direct forms survive a real OpenSCAD render;
- do overlap token sets retain all requested faces/regions;
- does the umbrella entrypoint expose the combined API without hidden
  sub-entrypoint coupling.

Where a real CGAL build is useful, verification may render temporary STL files.
Those files are test intermediates and are not publication evidence.

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

Human evidence is a small curated PNG set organized by verification question,
not one image per API symbol.

## Resolution-context traceability

| Contract | Verification question | Evidence |
| --- | --- | --- |
| `RES-LEVEL-01` / `RES-POLICY-01` | Are low/high/export tokens and exact `$fn/$fa/$fs` values unchanged? | assertions in `test/resolution.scad` |
| `RES-CTX-01` | Can the canonical public scope establish policy for child geometry? | one-child scope testcase |
| `RES-CTX-02` | Can child helpers inherit the active policy without receiving another resolution argument? | child assertion module in `test/resolution.scad` |
| `RES-CTX-03` | Does the resolution context stop at the child boundary? | caller restoration assertions |
| `RES-CTX-04` | Does an inner context restore the outer context for later siblings? | nested-context assertions |
| `RES-CTX-05` | Does one child work without braces and do braces correctly group multiple siblings? | separate ungrouped/grouped scope cases |
| `RES-CTX-06` | Does the compatibility alias preserve the canonical behavior? | `fg_res_apply()` compatibility case |
| `RES-CTX-07` | Are resolution changes tessellation-only? | exact policy assertions plus visual `resolution-levels.png` |

The exact scope/restoration checks are machine evidence. PNGs are not used to
prove special-variable scoping.

## Other verification questions and evidence

| Area | Verification question | Machine evidence | Human evidence |
| --- | --- | --- | --- |
| Placement and rotation | Do ordinary moves, axis moves, rotations and flips execute as valid geometry operations? | every transform variant in `test/transform.scad` is exported | `transforms-overview.png` |
| 2D project planes | Do XY, XZ and YZ 2D placement helpers remain independently usable as 2D operations? | temporary SVG exports for `move2d`, `xzmove`, and `yzmove` | none unless a future risk requires it |
| Coordinate frames | Do direct and object frame APIs preserve explicit local-axis remapping semantics? | direct and object frame variants render successfully | `coordinate-frame.png` |
| Tagged CSG | Does `fg_diff()` produce `(body - remove) + keep`? | render of `test/csg.scad` | `tagged-csg.png` |
| Cutter overlap | Are direct/object cutter forms valid and are named overlap tokens retained independently? | assertions and real renders in `test/cutter.scad` | `cutters-overlap.png` |
| Umbrella entrypoint | Can a consumer use all API families through `forge.scad` together? | render of `test/umbrella.scad` | none; this is an API composition concern |

## Evidence interpretation

Some contracts should not be judged from pixels.

The default `FG_OVERLAP_MM()` value is 0.001 mm. That is intentionally too
small to be useful as visual evidence. The exact value remains an assertion.
The cutter PNG uses a larger explicit `overlap_mm` only to make selected local
directions inspectable.

Likewise, PNGs do not prove exact transforms, dimensions or policy values. They
are review evidence for semantics and gross regressions; assertions and
successful OpenSCAD exports remain the machine proof for exact contracts.

## Published verification output

The intended published snapshot is compact:

```text
prod/vrf/
├── README.md
├── 30-verification.md
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

The published `30-verification.md` is a copy for self-contained evidence. The
source authority remains `doc/30-verification.md`.

Temporary STL/SVG machine outputs are created outside `vrf/out/` and removed
after verification. They therefore do not become part of `prod/vrf`.

## Change rules

Update this document when a public Forge behavior introduces a new verification
risk or changes what counts as meaningful evidence.

Add a published PNG only when it gives a maintainer something useful to inspect.
Do not mirror the API surface mechanically in verification output.

A passing visual render does not replace an assertion where a value can be
checked exactly, and a passing machine render does not automatically justify
publishing its geometry artifact.
