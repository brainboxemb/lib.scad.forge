use <../openscad/resolution.scad>


module assert_resolution(expected_fa, expected_fs) {
    assert($fn == 0, "Forge resolution must use automatic fragment count");
    assert($fa == expected_fa, str("Unexpected $fa: ", $fa));
    assert($fs == expected_fs, str("Unexpected $fs: ", $fs));

    cylinder(d = 4, h = 1);
}


assert(FG_RES_LOW() == "low");
assert(FG_RES_HIGH() == "high");
assert(FG_RES_EXPORT() == "export");

fg_res_apply(FG_RES_LOW())
    assert_resolution(12, 2);

translate([6, 0, 0])
    fg_res_apply(FG_RES_HIGH())
        assert_resolution(6, 1);

translate([12, 0, 0])
    fg_res_apply(FG_RES_EXPORT())
        assert_resolution(3, 0.5);
