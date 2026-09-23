# Repository agent guidance

Persistent guidance for work in `lib.scad.forge`.

## Repository role

This repository owns the portfolio's small OpenSCAD modeling language:
shared geometry resolution, readable transforms, tagged CSG and generic
overlap-aware cutters.

It must remain domain-independent. Mechanical interfaces, fit rules, hardware
semantics and project geometry stay in their owning libraries/projects.

Before workflow/publication/release changes, read the pinned
`tools/tool.scad-project/AGENTS.md`.

## Public namespace

Operational public APIs use the `fg_*` namespace.

Transforms form the `fg_xf_*` subfamily. Keep that grouping visible rather
than reintroducing a separate top-level `xf_*` namespace.

Fixed public token symbols are the narrow exception: use callable
`FG_*()` constants such as `FG_LEFT()`. OpenSCAD requires the parentheses
because normal `use` imports functions/modules but not global variables; the
uppercase spelling communicates constant/enum semantics.

Private helpers use a leading underscore.

## Entry points

`openscad/forge.scad` is the umbrella entrypoint and includes the four
public sub-entrypoints:

- `resolution.scad`;
- `transform.scad`;
- `csg.scad`;
- `cutter.scad`.

Each sub-entrypoint must also remain independently usable with normal OpenSCAD
`use`.

Avoid hidden dependencies between sub-entrypoints when a small local
implementation keeps them independent and understandable.

## Modeling boundaries

Forge geometry resolution is semantic (`low`, `high`, `export`) and controls
tessellation only. Keep printer/slicer resolution outside Forge.

Forge's default Boolean overlap is numerical CSG robustness only. It is not
fit clearance, printer tolerance or a nominal design dimension.

Coordinate frames are orthogonal and right-handed. Keep reflections explicit.

Do not grow Forge into a BOSL2 clone. Add helpers only when they remove repeated
cross-project OpenSCAD bookkeeping and improve readability.

## Source/API documentation

Public Forge API/reference documentation lives with the owning `.scad` source
using upstream `openscad_docsgen` structured comments. Keep the source comment
and implementation together when a public contract or usage rule changes.

The root README is the discoverable entrypoint. Generated Markdown is derived
output under `bld/api/`; do not hand-maintain a second API manual or commit the
generated reference to the source branch.

Use the existing `tool.scad-project docs-lint` path as the syntax gate.
`scripts/build-api-docs.sh` is only the Forge-local convenience producer for a
browseable generated reference; the docs parser/runtime remains owned by the
shared toolchain.

## Verification

`vrf/verification-plan.md` is the source of truth for Forge verification
reasoning: risks, questions, proof type, published evidence and intentional
exclusions. Update the plan when a public behavior changes what must be proven
or when the evidence strategy changes.

Keep machine checks and human evidence distinct:

- `test/*.scad` owns exact assertions and functional/API smoke checks;
- temporary STL/SVG files may be used to force real OpenSCAD geometry/export,
  but they must stay outside `vrf/out/`;
- `vrf/openscad/` owns deliberately composed human verification scenes;
- published visual evidence belongs under `vrf/out/png/`;
- do not create one published artifact per API symbol unless each artifact
  answers a genuinely distinct verification question.

Verification must exercise the umbrella entrypoint and every direct
sub-entrypoint, including all three geometry-resolution levels and the 2D
plane-aware transform helpers. Opposite box faces must be tested together so
overlap token membership cannot regress into vector-cancellation behavior.

Generated evidence belongs under `vrf/out/`.
