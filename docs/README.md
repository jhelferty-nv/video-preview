# Video preview

This command-line application converts synthetic Rec. 709 Y′CbCr samples to
RGB. It deliberately does not decode video, open a window, or use a graphics
API; its purpose is to demonstrate package resolution and native execution.

It depends on two packages directly: `ycbcr-display` for conversion and
`color-encoding` for the studio-range metadata used to validate input samples.
