use <../../openscad/forge.scad>

verification_view = "transforms-overview";
// [transforms-overview,coordinate-frame,tagged-csg,cutters-overlap,resolution-levels]


module _vrf_label(value, pos = [0, 0, 0], size = 3) {
    color([0.12, 0.12, 0.12])
        translate(pos)
            linear_extrude(height = 0.35)
                text(
                    value,
                    size = size,
                    halign = "center",
                    valign = "center"
                );
}


module _vrf_axes(length = 8, thickness = 0.55) {
    color([0.85, 0.15, 0.15])
        cube([length, thickness, thickness]);

    color([0.15, 0.65, 0.20])
        cube([thickness, length, thickness]);

    color([0.15, 0.30, 0.90])
        cube([thickness, thickness, length]);
}


module _vrf_fixture() {
    union() {
        cube([8, 5, 3]);
        cube([3, 5, 9]);

        translate([0, 0, 9])
            cube([6, 5, 2]);
    }
}


module _vrf_transform_sample(label, x) {
    translate([x, 0, 0]) {
        _vrf_axes();

        color([0.20, 0.45, 0.85])
            children();

        _vrf_label(label, [4, -7, 0]);
    }
}


module _vrf_transforms_overview() {
    _vrf_transform_sample("local", -42)
        _vrf_fixture();

    _vrf_transform_sample("move", -14)
        fg_xf_move([4, 3, 2])
            _vrf_fixture();

    _vrf_transform_sample("Z rot", 14)
        fg_xf_zrot(45)
            _vrf_fixture();

    _vrf_transform_sample("X flip", 42)
        fg_xf_xflip()
            _vrf_fixture();
}


module _vrf_coordinate_frame() {
    translate([-34, 0, 0]) {
        _vrf_axes();
        color([0.20, 0.45, 0.85])
            _vrf_fixture();
        _vrf_label("local", [4, -8, 0]);
    }

    translate([0, 0, 0]) {
        fg_xf_yrot(90) {
            _vrf_axes();
            color([0.85, 0.55, 0.15])
                _vrf_fixture();
        }
        _vrf_label("Y rot 90", [0, -8, 0]);
    }

    translate([34, 0, 0]) {
        fg_xf_frame(
            x_axis = [0, 1, 0],
            y_axis = [0, 0, 1]
        ) {
            _vrf_axes();
            color([0.25, 0.70, 0.40])
                _vrf_fixture();
        }
        _vrf_label("axis frame", [0, -8, 0]);
    }
}


module _vrf_csg_roles() {
    translate([-26, 0, 0]) {
        color([0.20, 0.45, 0.85])
            cube([14, 14, 10]);
        _vrf_label("body", [7, -7, 0]);
    }

    translate([0, 4, 0]) {
        color([0.90, 0.20, 0.20])
            cube([6, 6, 14]);
        _vrf_label("remove", [3, -11, 0]);
    }

    translate([20, 6, 0]) {
        color([0.20, 0.75, 0.30])
            cube([4, 4, 6]);
        _vrf_label("keep", [2, -13, 0]);
    }
}


module _vrf_csg_result() {
    fg_diff() {
        fg_body()
            cube([14, 14, 10]);

        fg_remove()
            translate([4, 4, -2])
                cube([6, 6, 14]);

        fg_keep()
            translate([6, 6, 4])
                cube([2, 2, 4]);
    }
}


module _vrf_tagged_csg() {
    translate([-18, 0, 0])
        _vrf_csg_roles();

    translate([38, 0, 0]) {
        color([0.25, 0.65, 0.45])
            _vrf_csg_result();
        _vrf_label("result", [7, -7, 0]);
    }
}


module _vrf_cutters_overlap() {
    translate([-42, 0, 0]) {
        color([0.70, 0.70, 0.70])
            cube([12, 10, 8]);
        _vrf_label("box nominal", [6, -7, 0]);
    }

    translate([-14, 0, 0]) {
        color([0.20, 0.55, 0.90])
            fg_cut_box(
                size_mm = [12, 10, 8],
                overlap = [
                    FG_LEFT(),
                    FG_RIGHT(),
                    FG_BACK()
                ],
                overlap_mm = 1.5
            );
        _vrf_label("L R back", [6, -7, 0]);
    }

    translate([14, 5, 0]) {
        color([0.70, 0.70, 0.70])
            cylinder(d = 12, h = 10);
        _vrf_label("cyl nominal", [0, -12, 0]);
    }

    translate([42, 5, 0]) {
        color([0.25, 0.70, 0.45])
            fg_cut_cylinder(
                diameter_mm = 12,
                height_mm = 10,
                overlap = [
                    FG_RADIAL(),
                    FG_TOP()
                ],
                overlap_mm = 1.5
            );
        _vrf_label("radial top", [0, -12, 0]);
    }
}


module _vrf_resolution_level(label, x, resolution, part_color) {
    translate([x, 0, 0]) {
        color(part_color)
            fg_res_scope(resolution)
                cylinder(d = 20, h = 12);

        _vrf_label(label, [0, -14, 0]);
    }
}


module _vrf_resolution_levels() {
    _vrf_resolution_level(
        "low",
        -28,
        FG_RES_LOW(),
        [0.85, 0.35, 0.25]
    );

    _vrf_resolution_level(
        "high",
        0,
        FG_RES_HIGH(),
        [0.85, 0.65, 0.20]
    );

    _vrf_resolution_level(
        "export",
        28,
        FG_RES_EXPORT(),
        [0.25, 0.65, 0.40]
    );
}


if (verification_view == "transforms-overview")
    _vrf_transforms_overview();
else if (verification_view == "coordinate-frame")
    _vrf_coordinate_frame();
else if (verification_view == "tagged-csg")
    _vrf_tagged_csg();
else if (verification_view == "cutters-overlap")
    _vrf_cutters_overlap();
else if (verification_view == "resolution-levels")
    _vrf_resolution_levels();
else
    assert(false, str("Unsupported verification_view: ", verification_view));
