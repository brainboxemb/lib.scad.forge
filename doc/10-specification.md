# Forge specification

This document defines the externally meaningful contracts of Forge. For purpose,
scope and working method, start with [00-plan.md](00-plan.md).

## General modeling contract

### FORGE-GEN-01 — generic modeling layer

Forge provides domain-independent modeling mechanics. Project geometry,
mechanical interfaces, fit rules and manufacturing settings remain outside this
library.

### FORGE-GEN-02 — readability over wrapper count

Using Forge is not a goal by itself. A native OpenSCAD operation remains correct
when it communicates the design intent more directly.

### FORGE-API-01 — public namespace

Operational public APIs use the `fg_*` namespace. Transform operations use the
`fg_xf_*` subfamily.

Fixed public token values that must survive normal OpenSCAD `use` use callable
`FG_*()` constants.

### FORGE-API-02 — independent sub-entrypoints

`resolution.scad`, `transform.scad`, `csg.scad` and `cutter.scad` remain
independently usable. `forge.scad` is the umbrella entrypoint.

## Geometry resolution

Resolution is output/presentation context. It controls tessellation only and
must not change nominal dimensions, fit, clearance or feature semantics.

### RES-LEVEL-01 — semantic levels

| Token | Meaning |
| --- | --- |
| `FG_RES_LOW()` | fast interactive geometry |
| `FG_RES_HIGH()` | normal design/render/verification geometry |
| `FG_RES_EXPORT()` | production mesh geometry |

### RES-POLICY-01 — exact tessellation policy

Within a Forge resolution context:

| Level | `$fn` | `$fa` | `$fs` |
| --- | ---: | ---: | ---: |
| low | `0` | `12` | `2` |
| high | `0` | `6` | `1` |
| export | `0` | `3` | `0.5` |

`$fn = 0` is part of the contract so a caller's fixed global segment count does
not override the semantic Forge policy.

### RES-CTX-01 — public owner applies context

A public build/render interface that exposes a `resolution` parameter owns
establishing that resolution context around all geometry owned by the
interface.

A caller must not need to know whether an outer entrypoint already established
the context.

### RES-CTX-02 — private helpers inherit by default

A private geometry helper normally inherits the active caller context. It does
not establish a second resolution policy unless it intentionally creates a
nested context.

### RES-CTX-03 — child-only effect

A Forge resolution context changes `$fn`, `$fa` and `$fs` for its child geometry
only.

After the child completes, the caller's previous special-variable values are
restored.

### RES-CTX-04 — nested restoration

A nested Forge resolution context may temporarily override an outer Forge
resolution context. When the nested child completes, the outer context is
restored for subsequent sibling geometry.

### RES-CTX-05 — braces are grouping, not resolution syntax

The canonical context call is:

```scad
fg_res_scope(resolution)
    child_geometry();
```

No braces are required for one child statement.

Braces are ordinary OpenSCAD grouping when multiple sibling child statements
must share the same context:

```scad
fg_res_scope(resolution) {
    first_geometry();
    second_geometry();
}
```

The braces do not activate or strengthen Forge resolution behavior.

### RES-CTX-06 — canonical API name

`fg_res_scope()` is the canonical public API for establishing the child
resolution context.

`fg_res_apply()` is a compatibility alias with identical behavior. Existing
consumers remain valid; new code should prefer `fg_res_scope()`.

### RES-CTX-07 — tessellation only

Changing the Forge resolution level may change mesh tessellation, render cost
and visible faceting. It must not alter the nominal modeled geometry or any
mechanical/design parameter.

## Transform semantics

### XF-01 — smallest meaningful transform

Use the smallest transform construct that communicates placement/orientation
intent.

Simple one-axis rotations use the axis-specific rotation helpers. A coordinate
frame is reserved for cases where mapping of local axes into project axes is
itself meaningful model information.

### XF-02 — right-handed coordinate frames

Forge coordinate frames are orthogonal and right-handed. Reflections remain
explicit operations.

## Tagged CSG

### CSG-01 — semantic construction roles

`fg_diff()` is for construction where body/remove/keep are meaningful roles. It
is not a requirement to replace every native `difference()`.

## Cutter overlap

### CUT-01 — numerical robustness only

Forge cutter overlap is a numerical Boolean-robustness allowance. It is not
mechanical clearance, print tolerance or nominal geometry.

The default overlap is `FG_OVERLAP_MM() == 0.001`.
