#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/bld/api"

rm -rf "$out"
mkdir -p "$out"
cd "$root"

openscad-docsgen \
  -D "$out" \
  -m \
  -t \
  -i \
  -I \
  -c \
  -P "lib.scad.forge" \
  openscad/forge.scad \
  openscad/resolution.scad \
  openscad/transform.scad \
  openscad/csg.scad \
  openscad/cutter.scad

echo "Generated Forge API documentation: ${out#$root/}"
