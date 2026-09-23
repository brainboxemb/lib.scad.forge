# Changelog

## Unreleased

### Added

- Add the numbered `doc/` engineering set and a first detailed design for the resolution context.
- Add canonical `fg_res_scope()` for explicit child resolution-context semantics while retaining `fg_res_apply()` as a compatibility alias.
- Add exact resolution scope/restoration/nesting verification, including one-child syntax without braces and grouped sibling syntax with braces.
- Move the source verification strategy from `vrf/verification-plan.md` to the numbered `doc/30-verification.md`; `vrf/` now owns execution and generated evidence only.
- Add curated PNG verification scenes for transforms, coordinate frames,
  tagged CSG, cutter-overlap semantics and resolution levels.
- Add `scripts/build-api-docs.sh` to generate the Forge API/reference set with
  the `openscad-docsgen` command already provided by the shared SCAD runtime.

### Deprecated

- Deprecate `fg_res_apply()` in favor of `fg_res_scope()`. Deprecated calls
  emit a visible migration message. Forge is pre-1.0; after one compatibility
  release and migration of known consumers, the duplicate API is planned for
  removal in the following minor release.

### Changed

- Align Forge with Migration 010 agent/document guidance: route shared working rules through `brainboxemb.meta`, do not inherit dependency-owner AGENTS instructions, and use the `20-xx` detailed-design numbering family.
- Refine Forge documentation roles: specification now explains why the library and functional areas exist, architecture stays in `20-design.md`, and resolution implementation detail lives in `20-01-resolution-context.md`.

- Keep machine-test STL/SVG renders temporary instead of publishing one geometry
  artifact per test at the root of `prod/vrf`; published verification now
  focuses on a human-readable README, plan and PNG evidence.
- Expand transform verification to include the 2D XY/XZ/YZ move helpers.
- Make structured `.scad` comments the authority for Forge API/reference
  documentation, including practical selection guidance for transforms,
  coordinate frames, resolution scope, tagged CSG and cutters.
- Make the root README the discoverable documentation entrypoint and keep the
  former hand-written manual paths only as compatibility pointers.

## v0.3.0

### Added

- Add `fg_xf_xzmove()` and `fg_xf_yzmove()` for readable placement of
  2D profile geometry whose local OpenSCAD X/Y coordinates represent project
  X/Z or Y/Z, and explicitly support two-value XY vectors in `fg_xf_move()`.

### Changed

- Advance Migration 009 to released `tool.scad-project v0.15.7` with exact tool gitlink `bfaac9f6916c09bc6525abddf64c87238fe59103`, retaining production-run serialization and restoring the qualified read-only `update-repo status` contract while preserving Forge geometry/API.
- Requalify exact main `00c02dc7fd1878e5c815377723adf7520ef0d2ec` through production run `35729434643`; both `prod/bld` and `prod/vrf` identify the v0.15.6 stack.

## v0.2.2

### Added

- Add semantic `FG_RES_LOW()`, `FG_RES_HIGH()` and `FG_RES_EXPORT()` tokens
  plus `fg_res_apply()` as Forge's shared geometry-resolution policy. Public
  interfaces can now pass intent instead of exposing `$fn`; Forge translates
  the level to automatic `$fn = 0` with shared `$fa` / `$fs` settings.


## v0.2.1

### Added

- Add callable constant `FG_OVERLAP_MM()` for Forge's fixed 0.001 mm Boolean
  robustness allowance. Existing `fg_overlap_mm()` remains as a compatibility
  alias for v0.2.0 consumers; new/default code uses the callable constant.


## v0.2.0

### Changed

- Rename Forge's enum-like cutter overlap token functions to callable constants:
  `FG_LEFT()`, `FG_RIGHT()`, `FG_FRONT()`, `FG_BACK()`,
  `FG_BOTTOM()`, `FG_TOP()` and `FG_RADIAL()`. They remain
  zero-argument functions so OpenSCAD `use` imports them, while uppercase
  spelling makes their fixed-token semantics explicit.


## v0.1.0

### Added

- Initial standalone Forge modeling library.
- Umbrella `forge.scad` plus independently usable transform, tagged-CSG and
  cutter entrypoints.
- `fg_xf_*` transform family for moves, rotations, mirrors, reusable transform
  objects and coordinate frames.
- `fg_diff()` body/remove/keep tagged CSG.
- Object-aware overlap-safe box and cylinder cutters with named face tokens.
