#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/vrf/out"
mkdir -p "$out"

transform_source="$root/test/transform.scad"
for transform in move xmove ymove zmove flip xflip yflip zflip rot xrot yrot zrot object frame frame-object; do
  openscad \
    --enable=object-function \
    --render \
    -D "test_transform=\"$transform\"" \
    -o "$out/transform-$transform.stl" \
    "$transform_source"
  test -s "$out/transform-$transform.stl"
done

openscad \
  --enable=object-function \
  --render \
  -o "$out/csg.stl" \
  "$root/test/csg.scad"
test -s "$out/csg.stl"

cutter_source="$root/test/cutter.scad"
for cutter in box-direct box-object box-faces cylinder-direct cylinder-object cylinder-faces; do
  openscad \
    --enable=object-function \
    --render \
    -D "test_cutter=\"$cutter\"" \
    -o "$out/cutter-$cutter.stl" \
    "$cutter_source"
  test -s "$out/cutter-$cutter.stl"
done

openscad \
  --enable=object-function \
  --render \
  -o "$out/umbrella.stl" \
  "$root/test/umbrella.scad"
test -s "$out/umbrella.stl"

cat > "$out/README.md" <<'EOF'
# Verification

Verified:

- direct transform entrypoint and all fg_xf_* transform families;
- direct tagged-CSG entrypoint;
- direct cutter entrypoint;
- named box overlap including simultaneous left + right faces;
- named cylinder overlap;
- cutter object/direct forms;
- umbrella forge.scad import combining transforms, tagged CSG and cutters.
EOF
