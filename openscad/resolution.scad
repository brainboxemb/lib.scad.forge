//////////////////////////////////////////////////////////////////////
// LibFile: resolution.scad
//   Shared Forge geometry-resolution tokens and OpenSCAD tessellation policy.
//////////////////////////////////////////////////////////////////////


// Function: FG_RES_LOW()
// Synopsis: Returns the fast interactive geometry-resolution token.
function FG_RES_LOW() = "low";


// Function: FG_RES_HIGH()
// Synopsis: Returns the normal design/render geometry-resolution token.
function FG_RES_HIGH() = "high";


// Function: FG_RES_EXPORT()
// Synopsis: Returns the production mesh geometry-resolution token.
function FG_RES_EXPORT() = "export";


// Module: fg_res_apply()
// Synopsis: Applies Forge's OpenSCAD tessellation policy to child geometry.
// Description:
//   Callers select semantic geometry resolution. Forge owns the matching
//   OpenSCAD $fa/$fs settings. $fn is reset to automatic mode so a caller's
//   global fixed segment count cannot override this policy.
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
