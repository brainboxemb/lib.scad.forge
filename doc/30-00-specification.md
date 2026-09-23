# Forge specification

This document explains **why Forge exists**, what it is trying to improve, and
why its main functional areas belong in the library.

For current work sequencing and information sources, start with
[10-00-plan.md](10-00-plan.md).

## Why Forge exists

OpenSCAD is intentionally small and expressive, but a portfolio of projects
quickly accumulates repeated low-level patterns whose intent is clearer than
their syntax.

Forge exists to give those recurring patterns a small shared vocabulary when
that vocabulary makes models easier to understand and review.

The goal is not to hide OpenSCAD. The goal is that a reader can more often see
**what the model means** instead of reconstructing the intent from repeated
`translate()`, `rotate()`, Boolean bookkeeping or tessellation settings.

## What Forge tries to achieve

Forge should:

- make common modeling intent readable at the call site;
- give repeated cross-project behavior one consistent meaning;
- keep domain-specific geometry and mechanical decisions out of the generic
  modeling layer;
- remain small enough that native OpenSCAD is still obvious and normal;
- prefer one clear API for one concept instead of accumulating equivalent
  aliases.

Forge should not become a general replacement geometry framework or a BOSL2
clone.

## Why semantic resolution exists

Projects need different geometry detail while designing, reviewing and
exporting. Passing raw `$fn`, `$fa` and `$fs` choices through every public
build API exposes implementation detail and encourages each project to invent
its own policy.

Forge therefore treats resolution as **semantic output context**: callers say
whether they need low, high or export quality and the library owns the
tessellation policy behind those meanings.

The important intent is:

- a public build that offers a resolution choice owns that context for the
  geometry it builds;
- private geometry normally inherits that context rather than inventing
  another policy;
- the context is local to the child geometry and must not leak outward;
- changing resolution changes tessellation, not nominal dimensions, fit or
  feature meaning.

The detailed scope mechanism and concrete tessellation policy are design
details documented in [40-01-resolution-context.md](40-01-resolution-context.md).

## Why transform helpers exist

Simple placement is already easy in OpenSCAD and should stay simple.

Forge transform helpers exist where a named operation makes repeated intent
more obvious: axis-specific movement/rotation, explicit reflection, reusable
transform objects and meaningful coordinate-frame remapping.

A coordinate frame has a different purpose from a simple rotation. It is useful
when the mapping from local axes to project axes is itself part of the model's
meaning; it should not be used merely because it can express a rotation.

## Why tagged CSG exists

Large nested Boolean expressions can hide the construction roles of their
children.

Tagged CSG exists for constructions where `body`, `remove` and `keep` are
meaningful engineering roles. It lets the source communicate those roles
directly.

It is not intended to replace every native `difference()` or `union()`.

## Why reusable cutters exist

Robust Boolean subtraction often needs a tiny intentional overlap so nominally
coincident faces do not create fragile CSG results.

That overlap pattern is easy to repeat inconsistently and easy to confuse with
mechanical clearance or print tolerance.

Forge cutters exist to give generic box/cylinder cutters one consistent local
overlap vocabulary. The overlap remains a numerical CSG aid only; mechanical
fit belongs elsewhere.

## What Forge deliberately does not own

Forge does not define:

- product or project dimensions;
- mechanical interfaces and mating clearances;
- printer/slicer resolution or manufacturing tolerances;
- domain-specific hardware semantics;
- a requirement to wrap native OpenSCAD when native syntax is already clearer.

## Pre-1.0 API evolution

Forge is still being shaped before 1.0. During this phase, clearer naming and
simpler concepts are preferred over preserving duplicate APIs indefinitely.

When an API is replaced, controlled consumers should receive a visible
deprecation path, migrate promptly, and allow the obsolete name to be removed
rather than turning a temporary alias into permanent surface area.
