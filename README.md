# Forge verification

This snapshot contains human-facing Forge verification evidence.

The source verification strategy is maintained in `doc/50-00-verification.md`.
A copy is included here as [50-00-verification.md](50-00-verification.md) so the
evidence snapshot remains self-contained.

Machine smoke tests also run for every public entrypoint and transform/cutter
variant. Their temporary STL/SVG files are intentionally not published.

## Visual evidence

### Transform helpers

Representative ordinary move, rotation and reflection behavior.

![Transform helpers](png/transforms-overview.png)

### Coordinate-frame semantics

Comparison of local geometry, a simple Y-axis rotation, and an explicit
coordinate-frame remap.

![Coordinate-frame semantics](png/coordinate-frame.png)

### Tagged CSG

Body/remove/keep construction roles beside the final tagged-difference result.

![Tagged CSG](png/tagged-csg.png)

### Cutter overlap semantics

The visual uses exaggerated overlap so selected local directions are visible.
The exact default 0.001 mm overlap remains machine-asserted.

![Cutter overlap](png/cutters-overlap.png)

### Resolution levels

Low, high and export tessellation policy shown on the same nominal cylinder.

![Resolution levels](png/resolution-levels.png)

## Machine checks

The verification run also checks:

- exact low/high/export `$fn`, `$fa` and `$fs` policy;
- resolution scope, restoration, nesting and compatibility-alias behavior;
- ordinary 3D transform helpers plus object/frame forms;
- 2D XY/XZ/YZ move helpers through SVG export;
- tagged CSG through a real geometry render;
- direct/object cutter forms and independent overlap-token membership;
- the umbrella `forge.scad` entrypoint combining all API families.

See [50-00-verification.md](50-00-verification.md) for the intent/design/evidence mapping.

<!-- scad-project-evidence-navigation -->
## Producer execution evidence

These files describe the SCAD producer executions that actually created the retained output.
They remain unchanged when equivalent output is later hydrated from cache.

- [scad-verify execution](evidence/executions/scad-verify/execution.json) — capability, producer source revision, exact owner revision, result and producer timing when available.
  - [scad-verify log](evidence/executions/scad-verify/execution.log) — concise human-readable producer summary.

## Domain evidence

Structured SCAD/SCons reports contain the detailed target-level build and cache decisions.
They are richer domain evidence, not alternate producer logs.

- No structured domain reports are present for this output.

## Orchestration/materialization evidence

Current-run orchestration evidence explains why capabilities were selected, whether Moon executed or hydrated them, and how long current materialization and snapshot preparation took.
Producer execution evidence above remains the authority for the work that originally created cached output.

- [Workflow phase timings](orchestration/timings.json)
- [Run context and snapshot-preparation timing](orchestration/run-context.json)
- [Moon impact decision](orchestration/impact-decision.json)
- [Affected Moon task ids](orchestration/affected-task-ids.json)
- [SCAD execution/materialization plan](orchestration/scad-ci-plan.json)

### Current workflow timing

| Phase | Duration |
| --- | ---: |
| Preflight + execution plan | 13.264 s |
| Cache restore | 1.169 s |
| Runtime pull | 11.963 s |
| Capability materialization | 9.150 s |
| Cache save | 1.284 s |
| Validation + finishing | 674 ms |
| Snapshot preparation | 2 ms |
| **Total to prepared snapshot** | **37.665 s** |

The table stops when this generated snapshot is ready. The remote branch push happens afterwards; detailed per-capability timings remain in the materialization files below.

- [consumer:scad.docs materialization](orchestration/moon-invocations/consumer_scad.docs/materialization.json) — current execute/cache/hydrate result and duration.
  - [consumer:scad.docs raw Moon/producer log](orchestration/moon-invocations/consumer_scad.docs/moon.log)
- [consumer:scad.verify materialization](orchestration/moon-invocations/consumer_scad.verify/materialization.json) — current execute/cache/hydrate result and duration.
  - [consumer:scad.verify raw Moon/producer log](orchestration/moon-invocations/consumer_scad.verify/moon.log)

## Publication context

`publication-info.txt` records generated-branch context plus source, tooling and runtime provenance.
Publication/finalization consumes prepared output and must not rewrite producer execution evidence.
