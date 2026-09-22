# Forge modeling library

Forge is a lightweight object-aware modeling layer for OpenSCAD. It focuses on
four cross-project concerns:

- shared semantic geometry resolution;
- readable transforms and coordinate frames;
- explicit tagged CSG;
- reliable overlap-aware cutters.

It is inspired by useful ergonomics from BOSL2 and Relativity.scad without
trying to reproduce their attachment, selector or replacement-primitive
systems.

## Entry points

Normal consumers can import the complete language:

```openscad
use <../forge.scad>
```

Focused consumers can import only what they need:

```openscad
use <../resolution.scad> // FG_RES_*(), fg_res_apply()
use <../transform.scad>  // fg_xf_*
use <../csg.scad>        // fg_diff/body/remove/keep
use <../cutter.scad>     // fg_cut_*, cutter objects/tokens
```

The umbrella file contains the four public sub-entrypoints. Each sub-entrypoint
is independently usable.

## Namespace

```text
FG_RES_*() fixed geometry-resolution tokens
fg_*       Forge modeling API
fg_res_*   Forge resolution subfamily
fg_xf_*    Forge transform subfamily
fg_cut_*   direct cutter operations
```

Keep domain geometry, mechanical fit and product dimensions in the owning
library/project. Forge should remove generic OpenSCAD boilerplate, not hide the
design.
