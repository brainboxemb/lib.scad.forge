# Forge design

This document explains the **library-level architecture** used to realise the
intent in [10-specification.md](10-specification.md).

Detailed implementation of a functional area belongs in a numbered detailed
design when it is substantial enough to deserve one.

## Library decomposition

Forge separates its public modeling concerns into focused entrypoints:

```text
openscad/
├── resolution.scad
├── transform.scad
├── csg.scad
├── cutter.scad
└── forge.scad
```

`forge.scad` is the umbrella entrypoint. The four focused entrypoints remain
independently usable with normal OpenSCAD `use`.

This keeps a consumer free to depend only on the modeling capability it needs
and prevents hidden coupling between otherwise independent concerns.

## Responsibility split

| Area | Responsibility | Detailed design |
| --- | --- | --- |
| Resolution | semantic geometry-detail context | [20-01-resolution-context.md](20-01-resolution-context.md) |
| Transforms | readable placement, rotation, reflection and coordinate frames | source/API remains sufficient for now |
| Tagged CSG | explicit body/remove/keep construction roles | source/API remains sufficient for now |
| Cutters | generic overlap-aware box/cylinder subtraction helpers | source/API remains sufficient for now |

Do not create detailed-design documents for the other areas until their
internal reasoning becomes complex enough that the architecture/API docs are
no longer sufficient.

## API and source documentation

Public API/reference documentation lives beside the owning `.scad` source
using `openscad_docsgen` structured comments.

The layers deliberately serve different questions:

- specification: why the capability exists;
- design: how Forge is decomposed;
- detailed design: how a complex functional area works internally;
- source/API docs: exact signatures, parameters, examples and deprecation.

## Native OpenSCAD remains part of the design

Forge is intentionally not an abstraction boundary around all OpenSCAD.

Native `difference()`, `translate()`, `rotate()`, `multmatrix()` and other
language constructs remain appropriate when they express the operation more
directly than a Forge helper.

This prevents the shared library from growing wrappers whose only purpose is
uniformity.
