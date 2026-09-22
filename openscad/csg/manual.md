# Tagged CSG

Forge's tagged CSG layer makes positive, subtractive and restored geometry
explicit without introducing an attachment or selector framework.

```openscad
use <../csg.scad>

fg_diff() {
    fg_body()
        housing();

    fg_remove()
        opening();

    fg_keep()
        bridge();
}
```

The result is:

```text
(body - remove) + keep
```

All geometry participating in `fg_diff()` should pass through
`fg_body()`, `fg_remove()`, `fg_keep()` or the generic `fg_tag()`.
Role wrappers may contain multiple child geometries.

Outside `fg_diff()`, role wrappers pass their children through unchanged so
individual tagged helpers remain easy to inspect.

Forge deliberately does not implement BOSL2-style attachments or a
Relativity-style selector language. The goal is a small readable CSG primitive.
