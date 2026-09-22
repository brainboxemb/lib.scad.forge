# Changelog

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
