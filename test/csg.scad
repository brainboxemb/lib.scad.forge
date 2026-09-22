use <../openscad/csg.scad>

fg_diff() {
    fg_body()
        cube([10, 10, 10]);

    fg_remove()
        translate([3, 3, -1])
            cube([4, 4, 12]);

    fg_keep()
        translate([4, 4, 4])
            cube([2, 2, 2]);
}
