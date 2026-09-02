# Getting started

From the workspace root: `slang package fetch`, `status`, `tree`,
`update --dry-run`, `update --yes`, `build`, `--experimental build`,
`--experimental run`, and `docs`. Host output is `build/host/video-preview`
from `src/video-preview.slang`, configured by `build.host` and requiring
`--experimental`. You need a `slang-package` binary from
[shader-slang/slang#12656](https://github.com/shader-slang/slang/pull/12656)
(or a later tree that includes it). The manifests use `git` + `version`; lock
rows record the selected tag as `ref`, its exact `version`, and its commit.
