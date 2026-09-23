use <../openscad/forge.scad>

fg_res_scope(FG_RES_LOW())
    fg_diff() {
        fg_body()
            fg_xf_zmove(1)
                cube([10, 10, 10]);

        fg_remove()
            fg_cut_box(
                size_mm = [4, 4, 12],
                pos_mm = [3, 3, 0],
                overlap = [
                    FG_BOTTOM(),
                    FG_TOP()
                ]
            );
    }
