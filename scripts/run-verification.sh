#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/vrf/out"
png_out="$out/png"
machine_out="$(mktemp -d -t forge-vrf-machine-XXXXXX)"

cleanup() {
  rm -rf "$machine_out"
}
trap cleanup EXIT

rm -rf "$out"
mkdir -p "$png_out"

render_machine() {
  local output="$1"
  shift

  openscad \
    --enable=object-function \
    --render \
    -o "$output" \
    "$@"

  test -s "$output"
}

render_machine \
  "$machine_out/resolution.stl" \
  "$root/test/resolution.scad"

transform_source="$root/test/transform.scad"
for transform in move xmove ymove zmove flip xflip yflip zflip rot xrot yrot zrot object frame frame-object; do
  render_machine \
    "$machine_out/transform-$transform.stl" \
    -D "test_transform=\"$transform\"" \
    "$transform_source"
done

for transform in move2d xzmove yzmove; do
  render_machine \
    "$machine_out/transform-$transform.svg" \
    -D "test_transform=\"$transform\"" \
    "$transform_source"
done

render_machine \
  "$machine_out/csg.stl" \
  "$root/test/csg.scad"

cutter_source="$root/test/cutter.scad"
for cutter in box-direct box-object box-faces cylinder-direct cylinder-object cylinder-faces; do
  render_machine \
    "$machine_out/cutter-$cutter.stl" \
    -D "test_cutter=\"$cutter\"" \
    "$cutter_source"
done

render_machine \
  "$machine_out/umbrella.stl" \
  "$root/test/umbrella.scad"

evidence_source="$root/vrf/openscad/verification_evidence.scad"
for view in transforms-overview coordinate-frame tagged-csg cutters-overlap resolution-levels; do
  output="$png_out/$view.png"

  xvfb-run -a openscad \
    --enable=object-function \
    --render \
    --camera=0,0,0,65,0,30,0 \
    --autocenter \
    --viewall \
    --imgsize=1600,1000 \
    -D "verification_view=\"$view\"" \
    -o "$output" \
    "$evidence_source"

  test -s "$output"
done

cp "$root/vrf/verification-plan.md" "$out/verification-plan.md"

cat > "$out/README.md" <<'EOF'
# Forge verification

This snapshot contains the **human-facing evidence** for Forge verification.
The source reasoning and evidence-selection rules are in the
[verification plan](verification-plan.md).

Machine smoke tests also run for every public entrypoint and transform/cutter
variant. Their temporary STL/SVG files are intentionally not published.

## Visual evidence

### Transform helpers

Representative ordinary move, rotation and reflection behavior.

![Transform helpers](png/transforms-overview.png)

### Coordinate-frame semantics

Comparison of local geometry, a simple Y-axis rotation, and an explicit
coordinate-frame remap. A frame is used when local-axis mapping itself carries
meaning.

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
- ordinary 3D transform helpers plus object/frame forms;
- 2D XY/XZ/YZ move helpers through SVG export;
- tagged CSG through a real geometry render;
- direct/object cutter forms and independent overlap-token membership;
- the umbrella `forge.scad` entrypoint combining all API families.

See [verification-plan.md](verification-plan.md) for why each item uses machine
or visual evidence.
EOF
