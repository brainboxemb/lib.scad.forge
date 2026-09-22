assert(FG_OVERLAP_MM() == 0.001, "Forge overlap constant must remain 0.001 mm");
assert(fg_overlap_mm() == FG_OVERLAP_MM(), "compatibility alias must match FG_OVERLAP_MM()");

use <../openscad/cutter.scad>

test_cutter = "box-faces"; // [box-direct,box-object,box-faces,cylinder-direct,cylinder-object,cylinder-faces]

if (test_cutter == "box-direct")
    fg_cut_box(
        size_mm = [4, 5, 6],
        pos_mm = [1, 2, 3]
    );
else if (test_cutter == "box-object")
    fg_cutter_build(
        fg_box_cutter_create(
            size_mm = [4, 5, 6],
            pos_mm = [1, 2, 3],
            rot_deg = [0, 0, 15]
        )
    );
else if (test_cutter == "box-faces") {
    _cutter =
        fg_box_cutter_create(
            size_mm = [4, 5, 6],
            overlap = [
                FG_LEFT(),
                FG_RIGHT(),
                FG_BACK()
            ]
        );

    assert(_fg_test_has(_cutter.overlap, FG_LEFT()));
    assert(_fg_test_has(_cutter.overlap, FG_RIGHT()));
    assert(_fg_test_has(_cutter.overlap, FG_BACK()));

    fg_cutter_build(_cutter);
}
else if (test_cutter == "cylinder-direct")
    fg_cut_cylinder(
        diameter_mm = 5,
        height_mm = 8
    );
else if (test_cutter == "cylinder-object")
    fg_cutter_build(
        fg_cylinder_cutter_create(
            diameter_mm = 5,
            height_mm = 8,
            pos_mm = [2, 3, 1],
            rot_deg = [0, 25, 0]
        )
    );
else if (test_cutter == "cylinder-faces") {
    _cutter =
        fg_cylinder_cutter_create(
            diameter_mm = 5,
            height_mm = 8,
            overlap = [
                FG_RADIAL(),
                FG_TOP()
            ]
        );

    assert(_fg_test_has(_cutter.overlap, FG_RADIAL()));
    assert(!_fg_test_has(_cutter.overlap, FG_BOTTOM()));
    assert(_fg_test_has(_cutter.overlap, FG_TOP()));

    fg_cutter_build(_cutter);
}

function _fg_test_has(values, value) =
    len([
        for (_value = values)
            if (_value == value)
                true
    ]) > 0;
