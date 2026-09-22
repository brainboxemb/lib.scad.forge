//////////////////////////////////////////////////////////////////////
// LibFile: cutter.scad
//   Overlap-aware Forge cutter specifications and geometry.
//////////////////////////////////////////////////////////////////////

_FG_BOOLEAN_OVERLAP_MM = 0.001;


// Function: fg_overlap_mm()
// Synopsis: Returns the default Boolean robustness overlap.
function fg_overlap_mm() =
    _FG_BOOLEAN_OVERLAP_MM;


// Function: fg_left()
// Synopsis: Returns the local X-min box face token.
function fg_left() = "left";


// Function: fg_right()
// Synopsis: Returns the local X-max box face token.
function fg_right() = "right";


// Function: fg_front()
// Synopsis: Returns the local Y-min box face token.
function fg_front() = "front";


// Function: fg_back()
// Synopsis: Returns the local Y-max box face token.
function fg_back() = "back";


// Function: fg_bottom()
// Synopsis: Returns the local Z-min overlap token.
function fg_bottom() = "bottom";


// Function: fg_top()
// Synopsis: Returns the local Z-max overlap token.
function fg_top() = "top";


// Function: fg_radial()
// Synopsis: Returns the radial cylinder-overlap token.
function fg_radial() = "radial";


// Function: fg_box_cutter_create()
// Synopsis: Creates an overlap-aware box cutter object.
function fg_box_cutter_create(
    size_mm,
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0],
    overlap = [
        fg_left(),
        fg_right(),
        fg_front(),
        fg_back(),
        fg_bottom(),
        fg_top()
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
                fg_left(),
                fg_right(),
                fg_front(),
                fg_back(),
                fg_bottom(),
                fg_top()
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
        fg_radial(),
        fg_bottom(),
        fg_top()
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
            [fg_radial(), fg_bottom(), fg_top()]
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
        fg_left(),
        fg_right(),
        fg_front(),
        fg_back(),
        fg_bottom(),
        fg_top()
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
        fg_radial(),
        fg_bottom(),
        fg_top()
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
            fg_left(),
            obj.overlap_mm
        );
    _right_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_right(),
            obj.overlap_mm
        );
    _front_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_front(),
            obj.overlap_mm
        );
    _back_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_back(),
            obj.overlap_mm
        );
    _bottom_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_bottom(),
            obj.overlap_mm
        );
    _top_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_top(),
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
            fg_radial(),
            obj.overlap_mm
        );
    _bottom_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_bottom(),
            obj.overlap_mm
        );
    _top_mm =
        _fg_overlap_value_mm(
            obj.overlap,
            fg_top(),
            obj.overlap_mm
        );

    _fg_apply_cutter_placement(obj)
        translate([0, 0, -_bottom_mm])
            cylinder(
                d = obj.diameter_mm + 2 * _radial_mm,
                h = obj.height_mm + _bottom_mm + _top_mm
            );
}
