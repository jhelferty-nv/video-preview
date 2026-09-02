# Video preview

This command-line application converts synthetic Rec. 709 Y′CbCr samples to
RGB. It is not a video player: it does not decode video, open a window, or use
a graphics API. Its purpose is to demonstrate Slang source-package resolution
and an optional experimental native executable.

It depends on two packages directly: `ycbcr-display` for conversion and
`color-encoding` for the studio-range metadata used to validate input samples.

The workspace README at the repository root explains why this demo exists,
what is experimental, and that `slang package` comes from
[shader-slang/slang#12656](https://github.com/shader-slang/slang/pull/12656).
