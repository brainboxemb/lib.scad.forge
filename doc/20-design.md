# Forge design

This document explains how Forge realises the contracts in
[10-specification.md](10-specification.md).

## Library decomposition

Forge keeps the public concerns independent:

```text
openscad/
├── resolution.scad
├── transform.scad
├── csg.scad
├── cutter.scad
└── forge.scad
```

`forge.scad` includes the four focused entrypoints. Each focused entrypoint is
designed to remain usable on its own.

Public API documentation is kept beside these source files using the
`openscad_docsgen` comment format. The generated reference explains how to call
the API; this design document explains implementation choices and rationale.

## Resolution context design

The canonical API is:

```scad
fg_res_scope(resolution)
    child_geometry();
```

The module performs three operations:

1. validate the semantic resolution token;
2. establish Forge's `$fn/$fa/$fs` policy;
3. evaluate its children inside that context.

Conceptually:

```text
caller context
    ↓
fg_res_scope(resolution)
    ↓ set temporary Forge tessellation context
child geometry
    ↓
restore caller context
```

### Why the context is a child module

OpenSCAD tessellation settings are special variables consumed by geometry
created below the call. A normal Forge function cannot establish that dynamic
geometry context for later unrelated statements.

A child module gives the context an explicit lifetime: exactly the geometry
passed as children.

### Why one child does not need braces

OpenSCAD modules accept a single following child statement directly:

```scad
fg_res_scope(resolution)
    _part_geometry(part_obj);
```

That is the preferred shape when one private geometry helper owns the complete
part.

When several sibling statements belong to the same scope, OpenSCAD braces group
those siblings:

```scad
fg_res_scope(resolution) {
    first_part();
    second_part();
}
```

The grouping belongs to the caller's geometry structure, not to the Forge
resolution mechanism itself. Forge therefore does not prescribe braces merely
to make the word 'scope' visually obvious.

This distinction is part of contract `RES-CTX-05`.

### Internal `let()` choice

`fg_res_scope()` currently establishes the special-variable context with:

```scad
let(
    $fn = 0,
    $fa = ...,
    $fs = ...
)
    children();
```

This internal `let()` is deliberately retained for this change.

OpenSCAD issue
[openscad/openscad#5916](https://github.com/openscad/openscad/issues/5916)
discusses cases where ordinary assignments can replace statement-style
`let()`. That does not by itself prove that changing Forge's special-variable
child-context implementation improves clarity or preserves all supported
behavior.

The resolution-context verification therefore first qualifies:

- child visibility of `$fn/$fa/$fs`;
- caller restoration;
- nested restoration;
- one-child syntax without braces;
- grouped multiple-child syntax.

A future simplification of the internal implementation can be considered
separately while keeping those contracts fixed.

### Compatibility alias

`fg_res_apply()` forwards its children through `fg_res_scope()`:

```text
existing consumer
    fg_res_apply(...)
        child
          ↓
compatibility wrapper
          ↓
fg_res_scope(...)
        child
```

This keeps released consumers source-compatible while giving new code a name
that describes the context semantics rather than sounding like an ordinary
one-shot operation.

## Transform design

Forge transform helpers are intentionally thin. They label common placement and
orientation intent rather than introducing a second geometry system.

`fg_xf_frame()` uses explicit destination axes because axis mapping is the
semantic content of that operation. Simple rotations stay simple rotations.

## Tagged CSG design

Tagged CSG uses child roles to make a meaningful construction read as:

```text
body - remove + keep
```

Native `difference()` remains appropriate for local primitive construction,
crop/section operations or explanatory differences where child roles would add
ceremony rather than meaning.

## Cutter design

Cutter specifications keep overlap selection in local cutter coordinates.
Placement/rotation is applied after the local overlap expansion. This makes
tokens such as left/right/top/radial stable regardless of where the cutter is
later placed.
