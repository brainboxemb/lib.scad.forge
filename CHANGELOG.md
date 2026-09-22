# Changelog

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
