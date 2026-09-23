//////////////////////////////////////////////////////////////////////
// LibFile: resolution.scad
//   Shared Forge geometry-resolution tokens and OpenSCAD tessellation policy.
// FileSummary: Semantic low/high/export tessellation policy and child context.
// Includes:
//   use <openscad/resolution.scad>
//////////////////////////////////////////////////////////////////////


// Section: Choosing and owning resolution
//   Geometry resolution is output/presentation context, not design data.
//   Changing resolution must not change nominal dimensions, fit or feature
//   semantics.
//   .
//   A public build/render interface that exposes a resolution parameter owns
//   establishing that context with fg_res_scope(). Public build modules may be
//   called directly, including with FG_RES_EXPORT(); callers cannot assume an
//   outer entrypoint already established the context.
//   .
//   Private geometry helpers normally inherit the caller context.


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


// Section: Resolution context
//
// Module: fg_res_scope()
// Synopsis: Establishes Forge's tessellation context for child geometry.
// Usage:
//   fg_res_scope(FG_RES_HIGH()) cylinder(d=20, h=10);
//   fg_res_scope(FG_RES_HIGH()) { first_part(); second_part(); }
// Description:
//   Sets Forge-owned $fn/$fa/$fs values while evaluating child geometry.
//   $fn is reset to automatic mode so a caller's global fixed segment count
//   cannot override the semantic Forge policy.
//   .
//   A single child statement does not require braces. Use braces only to group
//   multiple sibling child statements that share the context.
//   .
//   Leaving this module restores the caller's prior special-variable context.
// Arguments:
//   resolution = FG_RES_LOW(), FG_RES_HIGH() or FG_RES_EXPORT().
module fg_res_scope(
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


// Module: fg_res_apply()
// Synopsis: DEPRECATED compatibility alias for fg_res_scope().
// Usage:
//   fg_res_apply(FG_RES_HIGH()) CHILDREN;
// Description:
//   **DEPRECATED.** Use fg_res_scope() instead.
//   .
//   This temporary pre-1.0 compatibility API emits a visible deprecation
//   message when called. It is planned for removal after the compatibility
//   release once known consumers have migrated.
// Arguments:
//   resolution = FG_RES_LOW(), FG_RES_HIGH() or FG_RES_EXPORT().
module fg_res_apply(
    resolution = FG_RES_HIGH()
) {
    echo(str(
        "DEPRECATED: fg_res_apply() is deprecated; ",
        "use fg_res_scope() instead."
    ));

    fg_res_scope(resolution)
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
