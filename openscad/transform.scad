//////////////////////////////////////////////////////////////////////
// LibFile: transform.scad
//   Readable placement, reflection, rotation and coordinate-frame helpers.
//   .
//   Forge does not try to replace every native OpenSCAD transform. Prefer the
//   smallest operation that makes the CAD intent obvious at the call site.
// FileSummary: Readable moves, rotations, reflections and coordinate frames.
// Includes:
//   use <openscad/transform.scad>
//////////////////////////////////////////////////////////////////////


// Section: Choosing a transform
//   Use fg_xf_move() for ordinary XY/XYZ placement and the axis-specific move
//   helpers when only one project axis changes.
//   .
//   Use fg_xf_xzmove() or fg_xf_yzmove() when OpenSCAD 2D local X/Y
//   semantically represents a different project plane. Their value is making
//   that project-axis meaning visible at the call site.
//   .
//   Use the axis-specific rotation helpers for simple rotations. Use
//   fg_xf_frame() only when the mapping of local axes into project axes is
//   itself meaningful model information. A frame is not a more elaborate
//   spelling for an otherwise ordinary rotation.
//   .
//   Keep native multmatrix() for genuine general affine/skew transforms, and
//   keep native transforms when they communicate a local construction more
//   directly than a Forge wrapper.


// Section: Transform objects
//   Create a transform object only when placement/orientation is meaningful
//   reusable data. For a one-off obvious move or rotation, direct helpers are
//   normally easier to read.


// Function: fg_xf_create()
// Synopsis: Creates a reusable position/rotation transform object.
// Arguments:
//   pos_mm = Translation vector in millimetres.
//   rot_deg = Euler rotation vector in degrees.
function fg_xf_create(
    pos_mm = [0, 0, 0],
    rot_deg = [0, 0, 0]
) =
    assert(is_list(pos_mm) && len(pos_mm) == 3,
        "fg_xf_create pos_mm must contain three values")
    assert(is_list(rot_deg) && len(rot_deg) == 3,
        "fg_xf_create rot_deg must contain three values")
    object(
        kind = "pose",
        pos_mm = pos_mm,
        rot_deg = rot_deg
    );



// Section: Coordinate frames
//   Coordinate frames describe where the local axes of child geometry point.
//   Use them when that axis relationship is the design intent. If the operation
//   is simply "rotate this part 90 degrees around Y", prefer fg_xf_yrot().
//
// Function: fg_xf_frame_create()
// Synopsis: Creates an orthogonal coordinate-frame transform object.
// Description:
//   Supply any two orthogonal destination axes. The missing third axis is
//   derived to preserve a right-handed coordinate system. Supplying all three
//   axes is allowed when they are mutually orthogonal and right-handed.
//   .
//   Use a frame when local-axis remapping itself matters to the reader; do not
//   use it merely because an ordinary rotation can also be described by axes.
// Arguments:
//   pos_mm = Destination origin in millimetres.
//   x_axis = Destination direction of local +X.
//   y_axis = Destination direction of local +Y.
//   z_axis = Destination direction of local +Z.
function fg_xf_frame_create(
    pos_mm = [0, 0, 0],
    x_axis = undef,
    y_axis = undef,
    z_axis = undef
) =
    assert(is_list(pos_mm) && len(pos_mm) == 3,
        "fg_xf_frame_create pos_mm must contain three values")
    assert(_fg_xf_defined_axis_count(x_axis, y_axis, z_axis) >= 2,
        "fg_xf_frame_create requires at least two axes")
    assert(_fg_xf_axis_is_valid(x_axis),
        "fg_xf_frame_create x_axis must be undef or a non-zero vec3")
    assert(_fg_xf_axis_is_valid(y_axis),
        "fg_xf_frame_create y_axis must be undef or a non-zero vec3")
    assert(_fg_xf_axis_is_valid(z_axis),
        "fg_xf_frame_create z_axis must be undef or a non-zero vec3")
    let(
        _x = is_undef(x_axis) ? undef : _fg_xf_unit(x_axis),
        _y = is_undef(y_axis) ? undef : _fg_xf_unit(y_axis),
        _z = is_undef(z_axis) ? undef : _fg_xf_unit(z_axis),
        _resolved_x =
            is_undef(_x)
                ? _fg_xf_unit(cross(_y, _z))
                : _x,
        _resolved_y =
            is_undef(_y)
                ? _fg_xf_unit(cross(_z, _x))
                : _y,
        _resolved_z =
            is_undef(_z)
                ? _fg_xf_unit(cross(_x, _y))
                : _z
    )
    assert(_fg_xf_axes_are_orthogonal(
        _resolved_x,
        _resolved_y,
        _resolved_z
    ), "fg_xf_frame_create axes must be mutually orthogonal")
    assert(
        _fg_xf_dot(
            _fg_xf_unit(cross(_resolved_x, _resolved_y)),
            _resolved_z
        ) > 0.999999,
        "fg_xf_frame_create axes must form a right-handed frame"
    )
    object(
        kind = "frame",
        pos_mm = pos_mm,
        x_axis = _resolved_x,
        y_axis = _resolved_y,
        z_axis = _resolved_z
    );


// Module: fg_xf_frame()
// Synopsis: Remaps child geometry into an orthogonal destination frame.
// Usage:
//   fg_xf_frame(x_axis=[0,1,0], y_axis=[0,0,1]) CHILDREN;
// Description:
//   Remaps local coordinate axes into explicit project directions. Prefer a
//   simple axis rotation when no semantic axis remap needs to be communicated.
// Arguments:
//   pos_mm = Destination origin in millimetres.
//   x_axis = Destination direction of local +X, or undef.
//   y_axis = Destination direction of local +Y, or undef.
//   z_axis = Destination direction of local +Z, or undef.
module fg_xf_frame(
    pos_mm = [0, 0, 0],
    x_axis = undef,
    y_axis = undef,
    z_axis = undef
) {
    fg_xf_apply(
        fg_xf_frame_create(
            pos_mm = pos_mm,
            x_axis = x_axis,
            y_axis = y_axis,
            z_axis = z_axis
        )
    )
        children();
}


// Function: fg_xf_pos_mm()
// Synopsis: Returns the translation vector from a transform object.
function fg_xf_pos_mm(obj) =
    obj.pos_mm;


// Function: fg_xf_rot_deg()
// Synopsis: Returns the Euler rotation vector from a transform object.
function fg_xf_rot_deg(obj) =
    obj.rot_deg;


// Module: fg_xf_apply()
// Synopsis: Applies a transform object to child geometry.
// Arguments:
//   obj = Pose or frame transform object created by fg_xf_create() or
//         fg_xf_frame_create().
module fg_xf_apply(obj) {
    if (obj.kind == "pose")
        translate(fg_xf_pos_mm(obj))
            rotate(fg_xf_rot_deg(obj))
                children();
    else if (obj.kind == "frame")
        multmatrix(_fg_xf_frame_matrix(obj))
            children();
    else
        assert(false, str("Unsupported transform kind: ", obj.kind));
}


// Section: Placement
//   Placement helpers preserve ordinary OpenSCAD transform ordering. The
//   plane-aware 2D helpers label project-plane semantics; they do not perform a
//   hidden 3D transform.
//
// Module: fg_xf_move()
// Usage:
//   fg_xf_move([10, 5])
//       children();
//   fg_xf_move([10, 0, 5])
//       children();
// Description:
//   Moves child geometry by an ordinary XY or XYZ vector. Two-value vectors
//   are for normal 2D XY geometry; three-value vectors are for 3D geometry.
// Arguments:
//   offset_mm = [X, Y] or [X, Y, Z] translation vector in millimetres.
module fg_xf_move(offset_mm) {
    assert(
        is_list(offset_mm)
        && (len(offset_mm) == 2 || len(offset_mm) == 3),
        "fg_xf_move offset_mm must contain two or three values"
    )
        translate(offset_mm)
            children();
}


// Module: fg_xf_xzmove()
// Usage:
//   fg_xf_xzmove([10, 5])
//       profile_2d();
// Description:
//   Moves 2D child geometry whose local OpenSCAD X/Y coordinates semantically
//   represent project X/Z. The supplied vector is [X, Z].
// Arguments:
//   offset_xz_mm = [X, Z] translation vector in millimetres.
module fg_xf_xzmove(offset_xz_mm) {
    assert(
        is_list(offset_xz_mm) && len(offset_xz_mm) == 2,
        "fg_xf_xzmove offset_xz_mm must contain two values"
    )
        translate(offset_xz_mm)
            children();
}


// Module: fg_xf_yzmove()
// Usage:
//   fg_xf_yzmove([10, 5])
//       profile_2d();
// Description:
//   Moves 2D child geometry whose local OpenSCAD X/Y coordinates semantically
//   represent project Y/Z. The supplied vector is [Y, Z].
// Arguments:
//   offset_yz_mm = [Y, Z] translation vector in millimetres.
module fg_xf_yzmove(offset_yz_mm) {
    assert(
        is_list(offset_yz_mm) && len(offset_yz_mm) == 2,
        "fg_xf_yzmove offset_yz_mm must contain two values"
    )
        translate(offset_yz_mm)
            children();
}


// Module: fg_xf_xmove()
// Usage:
//   fg_xf_xmove(10)
//       children();
// Description:
//   Moves child geometry along X.
// Arguments:
//   distance_mm = Translation distance in millimetres.
module fg_xf_xmove(distance_mm) {
    translate([distance_mm, 0, 0])
        children();
}


// Module: fg_xf_ymove()
// Usage:
//   fg_xf_ymove(10)
//       children();
// Description:
//   Moves child geometry along Y.
// Arguments:
//   distance_mm = Translation distance in millimetres.
module fg_xf_ymove(distance_mm) {
    translate([0, distance_mm, 0])
        children();
}


// Module: fg_xf_zmove()
// Usage:
//   fg_xf_zmove(10)
//       children();
// Description:
//   Moves child geometry along Z.
// Arguments:
//   distance_mm = Translation distance in millimetres.
module fg_xf_zmove(distance_mm) {
    translate([0, 0, distance_mm])
        children();
}



// Section: Reflections
//   Reflections are explicit because they change handedness. Coordinate frames
//   remain right-handed; combine a frame with a flip when both are required.
//
// Module: fg_xf_flip()
// Synopsis: Mirrors child geometry across the plane normal to the supplied vector.
// Arguments:
//   normal = Mirror-plane normal vector.
module fg_xf_flip(normal) {
    mirror(normal)
        children();
}


// Module: fg_xf_xflip()
// Synopsis: Mirrors child geometry across the YZ plane.
module fg_xf_xflip() {
    fg_xf_flip([1, 0, 0])
        children();
}


// Module: fg_xf_yflip()
// Synopsis: Mirrors child geometry across the XZ plane.
module fg_xf_yflip() {
    fg_xf_flip([0, 1, 0])
        children();
}


// Module: fg_xf_zflip()
// Synopsis: Mirrors child geometry across the XY plane.
module fg_xf_zflip() {
    fg_xf_flip([0, 0, 1])
        children();
}


// Section: Rotations
//   Prefer the axis-specific helper for a simple one-axis rotation. For
//   example, an OpenSCAD cylinder runs along local +Z; mapping that cylinder to
//   project +X is simply fg_xf_yrot(90), not a coordinate-frame problem.
//
// Module: fg_xf_rot()
// Usage:
//   fg_xf_rot([90, 0, 45])
//       children();
// Description:
//   Rotates child geometry by the supplied [X, Y, Z] Euler-angle vector.
// Arguments:
//   angles_deg = Rotation angles in degrees.
module fg_xf_rot(angles_deg) {
    rotate(angles_deg)
        children();
}


// Module: fg_xf_xrot()
// Usage:
//   fg_xf_xrot(90)
//       children();
// Description:
//   Rotates child geometry around X.
// Arguments:
//   angle_deg = Rotation angle in degrees.
module fg_xf_xrot(angle_deg) {
    rotate([angle_deg, 0, 0])
        children();
}


// Module: fg_xf_yrot()
// Usage:
//   fg_xf_yrot(90)
//       children();
// Description:
//   Rotates child geometry around Y.
// Arguments:
//   angle_deg = Rotation angle in degrees.
module fg_xf_yrot(angle_deg) {
    rotate([0, angle_deg, 0])
        children();
}


// Module: fg_xf_zrot()
// Usage:
//   fg_xf_zrot(90)
//       children();
// Description:
//   Rotates child geometry around Z.
// Arguments:
//   angle_deg = Rotation angle in degrees.
module fg_xf_zrot(angle_deg) {
    rotate([0, 0, angle_deg])
        children();
}


function _fg_xf_defined_axis_count(x_axis, y_axis, z_axis) =
    (is_undef(x_axis) ? 0 : 1)
    + (is_undef(y_axis) ? 0 : 1)
    + (is_undef(z_axis) ? 0 : 1);


function _fg_xf_axis_is_valid(axis) =
    is_undef(axis)
    || (
        is_list(axis)
        && len(axis) == 3
        && _fg_xf_norm(axis) > 0
    );


function _fg_xf_dot(a, b) =
    a[0] * b[0]
    + a[1] * b[1]
    + a[2] * b[2];


function _fg_xf_norm(v) =
    sqrt(_fg_xf_dot(v, v));


function _fg_xf_unit(v) =
    v / _fg_xf_norm(v);


function _fg_xf_axes_are_orthogonal(x_axis, y_axis, z_axis) =
    abs(_fg_xf_dot(x_axis, y_axis)) < 0.000001
    && abs(_fg_xf_dot(x_axis, z_axis)) < 0.000001
    && abs(_fg_xf_dot(y_axis, z_axis)) < 0.000001;


function _fg_xf_frame_matrix(obj) =
    [
        [
            obj.x_axis[0],
            obj.y_axis[0],
            obj.z_axis[0],
            obj.pos_mm[0]
        ],
        [
            obj.x_axis[1],
            obj.y_axis[1],
            obj.z_axis[1],
            obj.pos_mm[1]
        ],
        [
            obj.x_axis[2],
            obj.y_axis[2],
            obj.z_axis[2],
            obj.pos_mm[2]
        ],
        [0, 0, 0, 1]
    ];
