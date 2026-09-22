# Changelog

## Unreleased

### Added

- Initial standalone Forge modeling library.
- Umbrella `forge.scad` plus independently usable transform, tagged-CSG and
  cutter entrypoints.
- `fg_xf_*` transform family for moves, rotations, mirrors, reusable transform
  objects and coordinate frames.
- `fg_diff()` body/remove/keep tagged CSG.
- Object-aware overlap-safe box and cylinder cutters with named face tokens.
