use <../openscad/resolution.scad>


module _assert_resolution(expected_fn, expected_fa, expected_fs) {
    assert($fn == expected_fn, str("Unexpected $fn: ", $fn));
    assert($fa == expected_fa, str("Unexpected $fa: ", $fa));
    assert($fs == expected_fs, str("Unexpected $fs: ", $fs));

    cylinder(d = 4, h = 1);
}


module _assert_scope_contracts() {
    // Deliberately non-Forge caller values make leakage/restoration observable.
    $fn = 17;
    $fa = 23;
    $fs = 7;

    _assert_resolution(17, 23, 7);

    // RES-CTX-05: one child does not require braces.
    translate([0, 0, 0])
        fg_res_scope(FG_RES_LOW())
            _assert_resolution(0, 12, 2);

    // RES-CTX-03: the caller context is restored after the child.
    translate([6, 0, 0])
        _assert_resolution(17, 23, 7);

    // RES-CTX-05: braces group multiple siblings under one context.
    fg_res_scope(FG_RES_HIGH()) {
        translate([12, 0, 0])
            _assert_resolution(0, 6, 1);

        translate([18, 0, 0])
            _assert_resolution(0, 6, 1);

        // RES-CTX-04: a nested scope may override the outer scope.
        translate([24, 0, 0])
            fg_res_scope(FG_RES_EXPORT())
                _assert_resolution(0, 3, 0.5);

        // The outer high context must be restored after the nested child.
        translate([30, 0, 0])
            _assert_resolution(0, 6, 1);
    }

    // The original caller context must be restored after the grouped scope.
    translate([36, 0, 0])
        _assert_resolution(17, 23, 7);

    // RES-CTX-06: compatibility API has identical scope behavior.
    translate([42, 0, 0])
        fg_res_apply(FG_RES_LOW())
            _assert_resolution(0, 12, 2);

    translate([48, 0, 0])
        _assert_resolution(17, 23, 7);
}


assert(FG_RES_LOW() == "low");
assert(FG_RES_HIGH() == "high");
assert(FG_RES_EXPORT() == "export");

_assert_scope_contracts();
