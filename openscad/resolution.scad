//////////////////////////////////////////////////////////////////////
// LibFile: resolution.scad
//   Shared Forge geometry-resolution tokens and OpenSCAD tessellation policy.
// FileSummary: Semantic low/high/export tessellation policy and scope.
// Includes:
//   use <openscad/resolution.scad>
//////////////////////////////////////////////////////////////////////


// Section: Choosing and owning resolution
//   Geometry resolution is output/presentation context, not design data.
//   Changing resolution must not change nominal dimensions, fit or feature
//   semantics.
//   .
//   A public build/render interface that exposes a resolution parameter owns
//   applying that value with fg_res_apply(). Public build modules may be called
//   directly, including with FG_RES_EXPORT(); callers cannot assume an outer
//   entrypoint already applied the context.
//   .
//   Treat fg_res_apply() as a scope around the geometry it governs. Private
//   helpers that deliberately inherit the caller's context should not invent a
//   second independent resolution policy.


// Section: Resolution levels


// Function: FG_RES_LOW()
// Synopsis: Returns the fast interactive geometry-resolution token.
function FG_RES_LOW() = "low";


// Function: FG_RES_HIGH()
// Synopsis: Returns the normal design/render geometry-resolution token.
function FG_RES_HIGH() = "high";


// Function: FG_RES_EXPORT()
// Synopsis: Returns the production mesh geometry-resolution token.
function FG_RES_EXPORT() = "export";


// Section: Resolution scope
//
// Module: fg_res_apply()
// Synopsis: Applies Forge's OpenSCAD tessellation policy to child geometry.
// Usage:
//   fg_res_apply(FG_RES_HIGH()) CHILDREN;
// Description:
//   Callers select semantic geometry resolution. Forge owns the matching
//   OpenSCAD $fa/$fs settings. $fn is reset to automatic mode so a caller's
//   global fixed segment count cannot override this policy.
//   .
//   Use this as a scope/context. A public build or render module that accepts a
//   resolution parameter should apply it around the geometry owned by that
//   interface.
// Arguments:
//   resolution = FG_RES_LOW(), FG_RES_HIGH() or FG_RES_EXPORT().
module fg_res_apply(
    resolution = FG_RES_HIGH()
) {
    assert(
        _fg_res_is_valid(resolution),
        str("Unsupported Forge resolution: ", resolution)
    );

    let(
        $fn = 0,
        $fa = _fg_res_fa_deg(resolution),
        $fs = _fg_res_fs_mm(resolution)
    )
        children();
}


function _fg_res_is_valid(resolution) =
    resolution == FG_RES_LOW()
    || resolution == FG_RES_HIGH()
    || resolution == FG_RES_EXPORT();


function _fg_res_fa_deg(resolution) =
    resolution == FG_RES_LOW()
        ? 12
        : resolution == FG_RES_HIGH()
            ? 6
            : 3;


function _fg_res_fs_mm(resolution) =
    resolution == FG_RES_LOW()
        ? 2
        : resolution == FG_RES_HIGH()
            ? 1
            : 0.5;
