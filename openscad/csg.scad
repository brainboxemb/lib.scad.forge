//////////////////////////////////////////////////////////////////////
// LibFile: csg.scad
//   Tagged constructive-solid-geometry helpers.
// FileSummary: Explicit body/remove/keep roles for readable differences.
// Includes:
//   use <openscad/csg.scad>
//////////////////////////////////////////////////////////////////////


// Section: Choosing tagged CSG
//   Use tagged CSG when positive body geometry, subtractive cutters and
//   restored/kept geometry are meaningful construction roles. The call site
//   should read as design intent rather than as child ordering.
//   .
//   Do not mechanically replace native difference(). Keep native OpenSCAD for
//   small local primitive construction, crop/section masks, and explanatory set
//   differences between complete states when that form is clearer.


// Section: CSG roles


// Module: fg_tag()
// Synopsis: Marks geometry with a Forge CSG role.
// Arguments:
//   tag = One of "body", "remove" or "keep".
module fg_tag(tag) {
    assert(
        tag == "body"
            || tag == "remove"
            || tag == "keep",
        str("Unsupported Forge tag: ", tag)
    );

    if (
        is_undef($fg_role)
        || $fg_role == "all"
        || $fg_role == tag
    )
        children();
}


// Module: fg_body()
// Synopsis: Marks positive/base geometry for fg_diff().
module fg_body() {
    fg_tag("body")
        children();
}


// Module: fg_remove()
// Synopsis: Marks geometry subtracted by fg_diff().
module fg_remove() {
    fg_tag("remove")
        children();
}


// Module: fg_keep()
// Synopsis: Marks geometry unioned back after fg_diff().
module fg_keep() {
    fg_tag("keep")
        children();
}


// Section: Tagged difference
//
// Module: fg_diff()
// Synopsis: Performs an explicit body/remove/keep tagged difference.
// Usage:
//   fg_diff() { fg_body() body(); fg_remove() cutter(); }
//   fg_diff() { fg_body() body(); fg_remove() cutter(); fg_keep() reinforcement(); }
// Description:
//   The result is (body - remove) + keep. Participating geometry should pass
//   through fg_body(), fg_remove(), fg_keep() or fg_tag().
//   .
//   Use this when those roles are the actual construction model; it is not a
//   requirement to wrap every OpenSCAD difference.
module fg_diff() {
    union() {
        difference() {
            let($fg_role = "body")
                children();

            let($fg_role = "remove")
                children();
        }

        let($fg_role = "keep")
            children();
    }
}
