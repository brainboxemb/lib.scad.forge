# Forge plan

## Purpose

Forge is the small shared OpenSCAD modeling layer for the BrainboxEmb SCAD
portfolio.

It exists to make recurring modeling intent easier to read and review without
trying to replace normal OpenSCAD. Forge is useful when a shared construct
communicates intent more clearly than repeated low-level syntax.

Current public concerns are:

- semantic geometry resolution;
- readable transforms and coordinate frames;
- tagged constructive-solid-geometry roles;
- reusable overlap-aware cutters.

## Scope

Forge owns generic modeling mechanics.

It does not own:

- project or product geometry;
- mechanical interfaces and fit contracts;
- manufacturing tolerances or slicer settings;
- domain-specific hardware meaning.

Native OpenSCAD remains a valid and often preferred choice when it communicates
the operation more directly.

## Working method

For normal Forge work:

1. start from this plan to understand purpose, scope and current direction;
2. read [10-specification.md](10-specification.md) for the contracts affected by
   the change;
3. read [20-design.md](20-design.md) for the implementation model;
4. read [30-verification.md](30-verification.md) before changing tests or
   evidence;
5. update the structured API comments beside the public `.scad` API when a
   public call or usage rule changes;
6. run repository verification and inspect human-facing evidence where the
   change has a visual meaning.

Do not add a Forge helper merely to increase Forge usage. The smallest construct
that makes the design intent obvious is preferred.

## Information sources

| Question | Authority |
| --- | --- |
| Repository purpose, scope and current direction | this plan |
| Public/semantic behavior | [10-specification.md](10-specification.md) |
| Internal architecture and implementation choices | [20-design.md](20-design.md) |
| Verification strategy and evidence interpretation | [30-verification.md](30-verification.md) |
| Public API syntax and examples | structured comments in `openscad/*.scad` / generated `openscad_docsgen` reference |
| Repository workflow/publication | pinned `tools/tool.scad-project/AGENTS.md` |
| OpenSCAD language behavior | supported OpenSCAD runtime plus upstream language documentation/issues |

OpenSCAD issue
[openscad/openscad#5916](https://github.com/openscad/openscad/issues/5916)
is relevant background for statement scoping and `let()` syntax. It is not a
replacement for verification against the supported runtime.

## Current focus

The current resolution-context work has two goals:

- make the child-context meaning explicit at the call site with
  `fg_res_scope()`;
- prove the scope/restoration behavior before updating consumers.

`fg_res_apply()` remains available as a compatibility alias while consumers move
to the clearer name.

## Roadmap

Near-term:

1. qualify the resolution-context contract in Forge;
2. release the compatible API addition;
3. update direct consumers such as the HUB75 display-frame project;
4. use Forge as an early canary for the shared numbered SCAD documentation
   convention.

Broader portfolio rollout belongs to the coordination work tracked in
`brainboxemb.meta`; it is not owned by this library.
