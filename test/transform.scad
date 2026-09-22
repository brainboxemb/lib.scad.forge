use <../openscad/transform.scad>

test_transform = "move"; // [move,move2d,movexz,moveyz,xmove,ymove,zmove,flip,xflip,yflip,zflip,rot,xrot,yrot,zrot,object,frame,frame-object]

module fixture() {
    cube([2, 3, 4]);
}

module profile_fixture() {
    square([2, 3]);
}

if (test_transform == "move")
    fg_xf_move([5, 6, 7])
        fixture();
else if (test_transform == "move2d")
    fg_xf_move([5, 6])
        profile_fixture();
else if (test_transform == "xzmove")
    fg_xf_xzmove([5, 7])
        profile_fixture();
else if (test_transform == "yzmove")
    fg_xf_yzmove([6, 7])
        profile_fixture();
else if (test_transform == "xmove")
    fg_xf_xmove(5)
        fixture();
else if (test_transform == "ymove")
    fg_xf_ymove(6)
        fixture();
else if (test_transform == "zmove")
    fg_xf_zmove(7)
        fixture();
else if (test_transform == "flip")
    fg_xf_flip([1, 1, 0])
        fixture();
else if (test_transform == "xflip")
    fg_xf_xflip()
        fixture();
else if (test_transform == "yflip")
    fg_xf_yflip()
        fixture();
else if (test_transform == "zflip")
    fg_xf_zflip()
        fixture();
else if (test_transform == "rot")
    fg_xf_rot([15, 25, 35])
        fixture();
else if (test_transform == "xrot")
    fg_xf_xrot(30)
        fixture();
else if (test_transform == "yrot")
    fg_xf_yrot(40)
        fixture();
else if (test_transform == "zrot")
    fg_xf_zrot(50)
        fixture();
else if (test_transform == "object")
    fg_xf_apply(
        fg_xf_create(
            pos_mm = [5, 6, 7],
            rot_deg = [15, 25, 35]
        )
    )
        fixture();
else if (test_transform == "frame")
    fg_xf_frame(
        pos_mm = [5, 6, 7],
        x_axis = [0, 1, 0],
        y_axis = [0, 0, 1]
    )
        fixture();
else if (test_transform == "frame-object")
    fg_xf_apply(
        fg_xf_frame_create(
            pos_mm = [5, 6, 7],
            x_axis = [0, 1, 0],
            y_axis = [0, 0, 1]
        )
    )
        fixture();
