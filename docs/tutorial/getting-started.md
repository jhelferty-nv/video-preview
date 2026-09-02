# Getting started

From the workspace root: `slang package fetch`, `status`, `tree`,
`update --dry-run`, `update --yes`, `build`, `--experimental build`,
`--experimental run`, and `docs`. Host output is `build/host/video-preview`
from `src/video-preview.slang`, configured by `build.host` and requiring
`--experimental`. The manifests use `git` + `version`; lock rows record the
selected tag as `ref`, its exact `version`, and its commit.
