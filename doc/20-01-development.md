# Forge development manual

## Start

1. read [../AGENTS.md](../AGENTS.md);
2. read [10-00-plan.md](10-00-plan.md);
3. use [README.md](README.md) to find the affected specification/design/verification authority;
4. inspect the owning `openscad/*.scad` API comments and matching `test/` cases.

## Repository entrypoints

Current root repository mechanics are the managed generic launchers:

```text
bootstrap.ps1 / bootstrap.sh
update.ps1 / update.sh
```

`tools/tool.git-project` is the committed bootstrap gitlink. `project.yml`
selects the released `tool.scad-project` dependency; the committed gitlink
records its exact resolved revision.

Current repository-owned workflows are:

```text
.github/workflows/self-ci.yml
.github/workflows/self-release.yml
.github/workflows/self-pr-cleanup.yml
```

They are thin self-entry callers. Shared orchestration remains in the released
`tool.scad-project` / `tool.git-project` reusable workflow APIs.

## Local API and verification work

Public API/reference documentation is generated from structured comments beside
the owning `.scad` files:

```bash
./scripts/build-api-docs.sh
```

Forge verification is run through the SCAD project workflow and
`scripts/run-verification.sh`. Machine-only STL/SVG intermediates remain
temporary; curated review evidence is published under `vrf/out/`.

## Release sequence

Before an immutable Forge release:

1. qualify the implementation on exact PR head;
2. merge only that qualified revision;
3. require successful exact-main CI/publication and inspect generated provenance;
4. prepare release identity/changelog changes if needed;
5. create the release through `self-release.yml`;
6. retain exact tag/release evidence in the coordinating Migration record.

Public pre-1.0 API removal/deprecation rules are defined by the local plan and
specification, not by the repository tooling layer.
