//////////////////////////////////////////////////////////////////////
// LibFile: forge.scad
//   Umbrella entrypoint for the Forge modeling library.
//   .
//   Normal consumers can import this file to get resolution, transforms,
//   tagged CSG and cutters through one public entrypoint.
// FileSummary: Umbrella entrypoint for the complete Forge modeling API.
// Includes:
//   use <openscad/forge.scad>
//////////////////////////////////////////////////////////////////////

include <resolution.scad>
include <transform.scad>
include <csg.scad>
include <cutter.scad>
