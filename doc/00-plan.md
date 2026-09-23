# Forge plan

## Purpose

Forge is the small shared OpenSCAD modeling layer for the BrainboxEmb SCAD
portfolio. Its goal is to make recurring modeling intent easier to read and
review without replacing normal OpenSCAD.

The fuller rationale for Forge and each functional area lives in
[10-specification.md](10-specification.md).

## Scope

Forge owns generic modeling mechanics. Project/product geometry, mechanical
interfaces, fit rules, manufacturing tolerances, slicer settings and
domain-specific hardware meaning stay in their owning repositories.

## Working method

For normal Forge work:

1. start here for scope, sources, current focus and roadmap;
2. read [10-specification.md](10-specification.md) to understand why the
   affected capability exists and what it is intended to achieve;
3. read [20-design.md](20-design.md) for the library architecture;
4. follow any detailed-design link for the affected functional area;
5. read [30-verification.md](30-verification.md) before changing tests or
   verification evidence;
6. update the structured API comments beside the public `.scad` API when a
   public call, usage rule or deprecation changes.

Do not add a Forge helper merely to increase Forge usage. Prefer the smallest
construct that makes the design intent clearer than native OpenSCAD.

## Information sources

| Question | Authority |
| --- | --- |
| Work scope, sources, current focus and roadmap | this plan |
| Shared BrainboxEmb working guidance | [`brainboxemb.meta/AGENTS.md`](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md) |
| Shared SCAD domain guidance | [`brainboxemb.meta/domains/scad/README.md`](https://github.com/brainboxemb/brainboxemb.meta/blob/main/domains/scad/README.md) |
| Why Forge/capabilities exist and what they should achieve | [10-specification.md](10-specification.md) |
| Library architecture and responsibility split | [20-design.md](20-design.md) |
| Resolution-context implementation | [20-01-resolution-context.md](20-01-resolution-context.md) |
| Verification strategy and evidence interpretation | [30-verification.md](30-verification.md) |
| Exact public API syntax and examples | structured comments in `openscad/*.scad` / generated `openscad_docsgen` reference |
| Exact Forge tooling intent and pins | `project.yml`, `project.scad.yml`, committed gitlinks and workflow callers |
| Exact pinned SCAD tool behavior | pinned `tools/tool.scad-project/README.md`, its `docs/`, source and tests |
| Current build/test/runtime status | live GitHub Actions plus published `prod/bld` / `prod/vrf` provenance |
| OpenSCAD language behavior | supported OpenSCAD runtime plus upstream language documentation/issues |

OpenSCAD issue
[openscad/openscad#5916](https://github.com/openscad/openscad/issues/5916)
is relevant background for statement scoping and `let()` syntax. Runtime
verification remains authoritative for Forge's supported behavior.

## Current focus

Migration 010 is complete; Forge is no longer carrying temporary canary/rollout
work for the shared documentation model.

The current Forge-local focus is pre-1.0 API cleanup. Resolution context is
converging on `fg_res_scope()`, with deprecated `fg_res_apply()` retained only
for the short compatibility window. The remaining `fg_overlap_mm()`
compatibility alias is tracked separately in issue #30 so duplicate APIs do not
become permanent surface area.

## Roadmap

Near-term:

1. release `fg_res_scope()` as the canonical API while `fg_res_apply()` is
   deprecated;
2. migrate known BrainboxEmb consumers;
3. remove `fg_res_apply()` in the following pre-1.0 minor release;
4. retire the remaining `fg_overlap_mm()` compatibility alias through issue
   #30 rather than retaining two overlap APIs indefinitely.

Current intended cadence is deprecation in v0.4.0 and removal in v0.5.0. If
release numbering changes before publication, preserve the policy of one
compatibility release followed by removal.

The shared documentation rollout completed under
`brainboxemb.meta` Migration 010 and is no longer Forge-local work.
