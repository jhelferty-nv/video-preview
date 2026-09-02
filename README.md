# video-preview

Slang source-package demonstration workspace. This is **not a video player**.
It is a small command-line Rec. 709 Y′CbCr preview that converts synthetic
samples. It does not decode media, open a window, or use a graphics API.

## Why this exists

[`slang package`](https://github.com/shader-slang/slang/blob/packaging-prototype/docs/user-guide/12-source-packages.md)
is not in a Slang release yet. This repository is a public, cloneable graph
that the [source-package walkthrough](https://github.com/shader-slang/slang/blob/packaging-prototype/docs/user-guide/12-01-source-package-workflow.md)
uses so people can exercise fetch, update, retractions, and an optional native
executable without inventing their own packages.

The graph is a diamond on purpose. Three packages constrain `color-encoding`.
The resolver intersects those ranges and selects one tag, which appears once
in the lock and is checked out once under `deps/`.

```text
video-preview
├── ycbcr-display
│   ├── color-convert
│   │   └── color-encoding
│   └── color-encoding
└── color-encoding
```

- `color-encoding` defines Rec. 709 luma coefficients and limited-range code values.
- `color-convert` turns Y′CbCr samples into RGB using that metadata.
- `ycbcr-display` converts a sample and also uses `color-encoding` directly to
  flag illegal luma.
- `video-preview` is the workspace. It depends on `ycbcr-display` and
  `color-encoding` so the application both converts pixels and validates input.

The committed lock selects `v1.0.0`. The three dependencies also publish
`v1.1.0`. `color-encoding` `v1.1.0` retracts `1.0.0` (truncated luma weights).
`fetch` still materializes the lock; `update` will not reselect the retracted
tag. After `update`, the program reports full-precision weights
`(0.2126, 0.7152, 0.0722)` instead of `(0.2130, 0.7150, 0.0720)`.

## Packaging status

Source packages land in Slang through
[shader-slang/slang#12656](https://github.com/shader-slang/slang/pull/12656).
That pull request adds `slang-package` / `slang package` (and the `slang pkg`
short form), the `slang-package.json` / `slang-package-lock.json` schema, and
the user-guide chapters linked above.

Until that work is merged and released, you need a Slang build from that PR
(or a later tree that contains it). A released Slang that does not include
#12656 will not provide `slang package`.

## What you need

| You want | Required |
| --- | --- |
| Fetch, status, tree, update, validate, stable `build`, `docs` | `git` on `PATH`, and a `slang-package` binary from #12656 |
| Experimental host executable or `.slang-module` files | The above, plus a supported host C++ compiler (`clang` or MSVC, the same downstream compiler Slang uses for CPU/host output) |

`slang-package` locates `git` itself; it does not vendor Git. Host compilation
is the same CPU path Slang already uses: the package tool invokes the host
target and copies `slang-rt` beside the binary.

There is no extra media or graphics SDK. The program only prints numbers.

## Experimental vs stable

`slang package` is stable for dependency management and for distributing
**source**. Binary artifacts are opt-in.

| Command | What it does here |
| --- | --- |
| `slang package fetch` | Materialize the locked `v1.0.0` graph. |
| `slang package update` | Re-solve. Discovers `v1.1.0` and leaves the retracted 1.0.0 encoding behind. |
| `slang package build` | Validate, copy exported `.slang` into `build/bundle/source/`, collect Markdown under `build/docs/`. **No** host binary, **no** `.slang-module`. |
| `slang package --experimental build` | Also compile `.slang-module` files (unstable format) and the `build.host` executable `video-preview` under `build/host/`. |
| `slang package --experimental run` | Run that existing host binary. Does not compile. |
| `slang package docs` | Open `build/docs/index.md`. Does not regenerate files. |

`--experimental` is a global flag and must appear immediately after
`slang package`. Stable help omits `run` and host/module build behavior;
`slang package --experimental help` lists them.

This workspace configures the experimental host executable in `slang-package.json`
as `build.host` (not a top-level `host` object). The matching primary is
`src/video-preview.slang` (`module video_preview;`). There is no reserved
`main.slang` filename.

`.slang-module` output is **not** a stable distribution format. Experimental
builds warn and write `build/bundle/modules/provenance.json`. Host output is
likewise marked with `build/host/EXPERIMENTAL.txt`.

`slang package test` is reserved and not implemented.

## Walkthrough

```sh
git clone https://github.com/jhelferty-nv/video-preview.git
cd video-preview

# Use the slang-package from #12656. A development build is typically:
#   /path/to/slang/build/Debug/bin/slang-package
# The rest of this listing writes `slang package` as in the user guide.

slang package fetch
slang package status
slang package tree
slang package why color-encoding
slang package update --dry-run
slang package update --yes
slang package build
slang package --experimental build
slang package --experimental run
slang package docs --print
```

Interactive `update` asks before writing the lock. Use `--yes` when there is
no terminal.

Manifests use `git` plus a `version` range. Lock rows record the selected tag
as `ref`, its exact solver identity as `version`, and the resolved commit.
Pinned branches or non-release tags use `git` + `ref` + `as`.

`slang-workspace.json` is gitignored machine-local state for `edit` and
`override`. A clean clone should not contain it.

## Repositories

- https://github.com/jhelferty-nv/video-preview
- https://github.com/jhelferty-nv/ycbcr-display
- https://github.com/jhelferty-nv/color-convert
- https://github.com/jhelferty-nv/color-encoding

## Further reading

- [Slang Source Packages](https://github.com/shader-slang/slang/blob/packaging-prototype/docs/user-guide/12-source-packages.md)
- [Using Source Packages](https://github.com/shader-slang/slang/blob/packaging-prototype/docs/user-guide/12-01-source-package-workflow.md)
- [Growing an Application with Source Packages](https://github.com/shader-slang/slang/blob/packaging-prototype/docs/user-guide/12-02-source-package-command-use-cases.md)
- [shader-slang/slang#12656](https://github.com/shader-slang/slang/pull/12656)
