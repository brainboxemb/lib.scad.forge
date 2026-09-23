# Resolution context detailed design

This document describes how Forge implements the semantic resolution intent
from [30-00-specification.md](30-00-specification.md#why-semantic-resolution-exists).

## Public shape

The canonical API is:

```scad
fg_res_scope(resolution)
    child_geometry();
```

A public build/render interface that exposes a `resolution` parameter normally
owns one such scope around all geometry built by that interface.

Private geometry helpers inherit the active context unless they intentionally
open a nested resolution context.

## Semantic levels and concrete policy

Forge currently maps the semantic levels to:

| Level | `$fn` | `$fa` | `$fs` |
| --- | ---: | ---: | ---: |
| low | `0` | `12` | `2` |
| high | `0` | `6` | `1` |
| export | `0` | `3` | `0.5` |

`$fn = 0` deliberately restores OpenSCAD's automatic fragment-count behavior
so an unrelated caller-level fixed `$fn` cannot override the Forge policy.

## Child-context lifetime

`fg_res_scope()` validates the semantic token, establishes the special-variable
context, then evaluates its children inside that context.

Conceptually:

```text
caller context
    ↓
fg_res_scope(resolution)
    ↓ temporary $fn/$fa/$fs
child geometry
    ↓
caller context restored
```

A nested scope may temporarily replace the outer resolution. When the nested
child completes, the outer context becomes active again.

## Why one child does not need braces

OpenSCAD accepts one following child statement directly:

```scad
fg_res_scope(resolution)
    _part_geometry(part_obj);
```

This is the preferred shape when one private geometry helper owns the complete
part.

Braces are only normal OpenSCAD grouping when several sibling statements must
share the same context:

```scad
fg_res_scope(resolution) {
    first_part();
    second_part();
}
```

The braces are not part of the resolution API and do not create any extra
Forge behavior.

## Internal special-variable scope

The current implementation uses:

```scad
let(
    $fn = 0,
    $fa = ...,
    $fs = ...
)
    children();
```

This keeps the temporary special-variable values attached directly to the child
evaluation.

OpenSCAD issue
[openscad/openscad#5916](https://github.com/openscad/openscad/issues/5916)
discusses situations where statement-style `let()` can be replaced by ordinary
assignments. Forge does not change this internal form merely on stylistic
grounds; any later simplification must continue to pass the scope, nesting and
restoration tests.

## Deprecated `fg_res_apply()` wrapper

`fg_res_apply()` is a short-lived pre-1.0 compatibility wrapper around
`fg_res_scope()`.

It emits one visible message:

```text
DEPRECATED: fg_res_apply() is deprecated; use fg_res_scope() instead.
```

The wrapper preserves geometry behavior during the migration, but it is not
intended to remain as a second API. The plan currently allows one compatibility
release before removal after known consumers have migrated.

## Verification

The relevant machine checks and published evidence are described in
[50-00-verification.md](50-00-verification.md#resolution-context-and-policy).
