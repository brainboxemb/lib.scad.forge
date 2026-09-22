//////////////////////////////////////////////////////////////////////
// LibFile: cutter.scad
//   Overlap-aware Forge cutter specifications and geometry.
//////////////////////////////////////////////////////////////////////

_FG_BOOLEAN_OVERLAP_MM = 0.001;


// Function: fg_overlap_mm()
// Synopsis: Returns the default Boolean robustness overlap.
function fg_overlap_mm() =
    _FG_BOOLEAN_OVERLAP_MM;


// Function: FG_LEFT()
// Synopsis: Returns the local X-min box face token.
function FG_LEFT() = "left";


// Function: FG_RIGHT()
// Synopsis: Returns the local X-max box face token.
function FG_RIGHT() = "right";


// Function: FG_FRONT()
// Synopsis: Returns the local Y-min box face token.
function FG_FRONT() = "front";


// Function: FG_BACK()
// Synopsis: Returns the local Y-max box face token.
function FG_BACK() = "back";


// Function: FG_BOTTOM()
// Synopsis: Returns the local Z-min overlap token.
function FG_BOTTOM() = "bottom";


// Function: FG_TOP()
// Synopsis: Returns the local Z-max overlap token.
function FG_TOP() = "top";


// Function: FG_RADIAL()
// Synopsis: Returns the radial cylinder-overlap token.
function FG_RADIAL() = "radial";


// Function: fg_box_cutter_create()
// Synopsis: Creates an overlap-aware box cutter object.
function fg_box_cutter_create(
    size_mm,
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0],
    overlap = [
        FG_LEFT(),
        FG_RIGHT(),
        FG_FRONT(),
        FG_BACK(),
        FG_BOTTOM(),
        FG_TOP()
    ],
    overlap_mm = fg_overlap_mm()
) =
    assert(
        is_list(size_mm) && len(size_mm) == 3 && min(size_mm) > 0,
        "fg_box_cutter_create size_mm must contain three values > 0"
    )
    assert(
        is_list(pos_mm) && len(pos_mm) == 3,
        "fg_box_cutter_create pos_mm must contain three values"
    )
    assert(
        is_list(rot_deg) && len(rot_deg) == 3,
        "fg_box_cutter_create rot_deg must contain three values"
    )
    assert(
        _fg_overlap_names_are_valid(
            overlap,
            [
                FG_LEFT(),
                FG_RIGHT(),
                FG_FRONT(),
                FG_BACK(),
                FG_BOTTOM(),
                FG_TOP()
            ]
        ),
        "fg_box_cutter_create overlap contains an unsupported face"
    )
    assert(
        overlap_mm >= 0,
        "fg_box_cutter_create overlap_mm must be >= 0"
    )
    object(
        kind = "box",
        size_mm = size_mm,
        pos_mm = pos_mm,
        rot_deg = rot_deg,
        overlap = overlap,
        overlap_mm = overlap_mm
    );


// Function: fg_cylinder_cutter_create()
// Synopsis: Creates an overlap-aware local-Z cylinder cutter object.
function fg_cylinder_cutter_create(
    diameter_mm,
    height_mm,
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0],
    overlap = [
        FG_RADIAL(),
        FG_BOTTOM(),
        FG_TOP()
    ],
    overlap_mm = fg_overlap_mm()
) =
    assert(
        diameter_mm > 0,
        "fg_cylinder_cutter_create diameter_mm must be > 0"
    )
    assert(
        height_mm > 0,
        "fg_cylinder_cutter_create height_mm must be > 0"
    )
    assert(
        is_list(pos_mm) && len(pos_mm) == 3,
        "fg_cylinder_cutter_create pos_mm must contain three values"
    )
    assert(
        is_list(rot_deg) && len(rot_deg) == 3,
        "fg_cylinder_cutter_create rot_deg must contain three values"
    )
    assert(
        _fg_overlap_names_are_valid(
            overlap,
            [FG_RADIAL(), FG_BOTTOM(), FG_TOP()]
        ),
        "fg_cylinder_cutter_create overlap contains an unsupported region"
    )
    assert(
        overlap_mm >= 0,
        "fg_cylinder_cutter_create overlap_mm must be >= 0"
    )
    object(
        kind = "cylinder",
        diameter_mm = diameter_mm,
        height_mm = height_mm,
        pos_mm = pos_mm,
        rot_deg = rot_deg,
        overlap = overlap,
        overlap_mm = overlap_mm
    );


// Module: fg_cutter_build()
// Synopsis: Builds a Forge cutter object.
module fg_cutter_build(obj) {
    if (obj.kind == "box")
        _fg_box_cutter_build(obj);
    else if (obj.kind == "cylinder")
        _fg_cylinder_cutter_build(obj);
    else
        assert(
            false,
            str("Unsupported Forge cutter kind: ", obj.kind)
        );
}


// Module: fg_cut_box()
// Synopsis: Builds an overlap-aware box cutter directly.
module fg_cut_box(
    size_mm,
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0],
    overlap = [
        FG_LEFT(),
        FG_RIGHT(),
        FG_FRONT(),
        FG_BACK(),
        FG_BOTTOM(),
        FG_TOP()
    ],
    overlap_mm = fg_overlap_mm()
) {
    fg_cutter_build(
        fg_box_cutter_create(
            size_mm = size_mm,
            pos_mm = pos_mm,
            rot_deg = rot_deg,
            overlap = overlap,
            overlap_mm = overlap_mm
        )
    );
}


// Module: fg_cut_cylinder()
// Synopsis: Builds an overlap-aware cylinder cutter directly.
module fg_cut_cylinder(
    diameter_mm,
    height_mm,
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0],
    overlap = [
        FG_RADIAL(),
        FG_BOTTOM(),
        FG_TOP()
    ],
    overlap_mm = fg_overlap_mm()
) {
    fg_cutter_build(
        fg_cylinder_cutter_create(
            diameter_mm = diameter_mm,
            height_mm = height_mm,
            pos_mm = pos_mm,
            rot_deg = rot_deg,
            overlap = overlap,
            overlap_mm = overlap_mm
        )
    );
}


function _fg_has_overlap(overlap, name) =
    len([
        for (_name = overlap)
            if (_name == name)
                true
    ]) > 0;


function _fg_overlap_names_are_valid(overlap, allowed) =
    is_list(overlap)
    && len([
        for (_name = overlap)
            if (!_fg_has_overlap(allowed, _name))
                _name
    ]) == 0;


function _fg_overlap_value_mm(overlap, name, overlap_mm) =
    _fg_has_overlap(overlap, name)
        ? overlap_mm
        : 0;


module _fg_apply_cutter_placement(obj) {
    translate(obj.pos_mm)
        rotate(obj.rot_deg)
            children();
}


module _fg_box_cutter_build(obj) {
    _left_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_LEFT(),
            obj.overlap_mm
        );
    _right_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_RIGHT(),
            obj.overlap_mm
        );
    _front_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_FRONT(),
            obj.overlap_mm
        );
    _back_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_BACK(),
            obj.overlap_mm
        );
    _bottom_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_BOTTOM(),
            obj.overlap_mm
        );
    _top_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_TOP(),
            obj.overlap_mm
        );

    _fg_apply_cutter_placement(obj)
        translate([
            -_left_mm,
            -_front_mm,
            -_bottom_mm
        ])
            cube([
                obj.size_mm[0] + _left_mm + _right_mm,
                obj.size_mm[1] + _front_mm + _back_mm,
                obj.size_mm[2] + _bottom_mm + _top_mm
            ]);
}


module _fg_cylinder_cutter_build(obj) {
    _radial_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_RADIAL(),
            obj.overlap_mm
        );
    _bottom_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_BOTTOM(),
            obj.overlap_mm
        );
    _top_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            FG_TOP(),
            obj.overlap_mm
        );

    _fg_apply_cutter_placement(obj)
        translate([0, 0, -_bottom_mm])
            cylinder(
                d = obj.diameter_mm + 2 * _radial_mm,
                h = obj.height_mm + _bottom_mm + _top_mm
            );
}
