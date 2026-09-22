//////////////////////////////////////////////////////////////////////
// LibFile: csg.scad
//   Tagged constructive-solid-geometry helpers.
//////////////////////////////////////////////////////////////////////


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


// Module: fg_diff()
// Synopsis: Performs an explicit body/remove/keep tagged difference.
// Description:
//   The result is (body - remove) + keep. Participating geometry should pass
//   through fg_body(), fg_remove(), fg_keep() or fg_tag().
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
