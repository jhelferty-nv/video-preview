# video-preview

Slang package demonstration workspace. This is a command-line Rec. 709 Y′CbCr
preview, not a video player: it converts synthetic samples and does not decode
media or open a window.

The experimental host executable is `video-preview`, configured by
`build.host` and compiled from `src/video-preview.slang` under
`build/host/`. Clone this repository and run:

```sh
slang package fetch
slang package status
slang package tree
slang package update --dry-run
slang package update --yes
slang package build
slang package --experimental build
slang package --experimental run
```

`build` distributes source and docs. `.slang-module` files and the host
executable require `--experimental`. Interactive `update` asks before
writing; use `--yes` when there is no terminal.

The committed lock selects `v1.0.0`. The dependency repositories also publish
`v1.1.0`, so `fetch` stays on 1.0.0. `color-encoding` `v1.1.0` retracts
`1.0.0`; that does not invalidate the lock. `update` then advances the
shared `color-encoding` graph to 1.1.0.

The manifests use `git` + `version`. Lock rows record the selected tag as
`ref`, its exact solver identity as `version`, and its resolved commit.
Pinned branches or non-release tags use `git` + `ref` + `as`.

Graph:

```text
video-preview
├── ycbcr-display
│   ├── color-convert
│   │   └── color-encoding
│   └── color-encoding
└── color-encoding
```

Repositories:

- https://github.com/jhelferty-nv/color-encoding.git
- https://github.com/jhelferty-nv/color-convert.git
- https://github.com/jhelferty-nv/ycbcr-display.git
- https://github.com/jhelferty-nv/video-preview.git
