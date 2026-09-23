# Forge verification

This document defines how Forge checks that its specification and design intent
are actually realised. Generated output under `vrf/out/` is evidence from this
document; it is not the source authority.

Related documents:

- [00-plan.md](00-plan.md) — work context;
- [10-specification.md](10-specification.md) — why the capabilities exist;
- [20-design.md](20-design.md) — library architecture;
- [20-01-resolution-context.md](20-01-resolution-context.md) — resolution detailed design.

## Verification model

Forge uses two deliberately separate evidence types.

### Machine verification

Use exact/machine checks for behavior that can be decided mechanically:

- public entrypoints parse and generate the expected geometry type;
- semantic resolution selects the intended tessellation policy;
- resolution context obeys child, restoration and nesting behavior;
- transform families execute successfully;
- tagged CSG and cutter forms survive a real OpenSCAD render;
- overlap token sets retain the requested regions;
- the umbrella entrypoint exposes the combined API.

Temporary STL/SVG files may be generated to force real OpenSCAD/CGAL work.
They are test intermediates, not automatically publication evidence.

### Human verification

Use curated PNG evidence where visual inspection contributes something useful:

- representative transform/orientation behavior;
- coordinate-frame meaning;
- tagged CSG construction/result;
- cutter overlap directions;
- visible low/high/export tessellation progression.

Do not create one image per API symbol merely to mirror the source tree.

## Resolution context and policy

The specification section
[Why semantic resolution exists](10-specification.md#why-semantic-resolution-exists)
and the detailed design
[Resolution context](21-resolution-context.md)
are exercised by `test/resolution.scad` and the verification runner.

| Verification question | Evidence |
| --- | --- |
| Do low/high/export select the concrete policy documented by the detailed design? | exact `$fn/$fa/$fs` assertions |
| Can a public scope establish that policy for child geometry? | one-child scope case |
| Can private child helpers inherit the active context? | child assertion module |
| Does the caller context return after the child? | restoration assertions |
| Does a nested scope restore the outer context afterward? | nested-context assertions |
| Does one child work without braces? | ungrouped child case |
| Do braces correctly group multiple siblings under one scope? | grouped sibling case |
| Does the deprecated alias preserve behavior while making migration visible? | `fg_res_apply()` compatibility case plus required deprecation log message |

The exact scope/restoration behavior is machine evidence; PNGs are not used to
prove special-variable lifetime.

## Other verification questions

| Specification/design area | Verification question | Machine evidence | Human evidence |
| --- | --- | --- | --- |
| Transform intent | Do ordinary moves, axis moves, rotations and flips execute as valid operations? | every transform variant in `test/transform.scad` is exported | `transforms-overview.png` |
| 2D project planes | Do XY, XZ and YZ placement helpers remain independently usable as 2D operations? | temporary SVG exports | none unless a future risk requires it |
| Coordinate frames | Do direct and object frame APIs preserve explicit local-axis remapping? | direct/object frame renders | `coordinate-frame.png` |
| Tagged CSG | Does body/remove/keep produce the intended construction result? | `test/csg.scad` render | `tagged-csg.png` |
| Cutter robustness | Are cutter forms valid and overlap-token membership independent? | cutter assertions/renders | `cutters-overlap.png` |
| Umbrella API | Can a consumer use all public families through `forge.scad` together? | `test/umbrella.scad` render | none; API composition is mechanical |

## Evidence interpretation

Some facts should not be judged from pixels.

The default cutter overlap is 0.001 mm. That value is intentionally too small
for useful visual evidence and remains an assertion. The cutter PNG uses a
larger explicit overlap only to make selected local directions visible.

Likewise, PNGs do not prove exact transforms, dimensions or policy values.
They are review evidence for semantics and gross regressions.

## Published verification output

The intended published snapshot is:

```text
prod/vrf/
├── README.md
├── 30-verification.md
├── png/
├── evidence/
├── orchestration/
└── publication-info.txt
```

The published `30-verification.md` is a copy for a self-contained evidence
snapshot. The source authority remains `doc/30-verification.md`.

## Change rules

Update this document when a Forge behavior introduces a new verification risk
or changes what counts as meaningful evidence.

A passing visual render does not replace an exact assertion, and a passing
machine render does not automatically justify publishing its geometry artifact.
