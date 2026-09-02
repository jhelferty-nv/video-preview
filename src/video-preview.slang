module video_preview;

import video.display;
import color.encoding;

// Report the studio-range luma window the encoding package defines. The
// application asks `color-encoding` for these code values instead of repeating
// the 16/235 convention itself, which is why it depends on that package
// directly rather than only through `ycbcr-display`.
void printEncodingSummary()
{
    YCbCrEncoding encoding = rec709LimitedRange();
    printf(
        "Encoding: luma weights (%.4f, %.4f, %.4f), luma scale %.4f\n",
        encoding.lumaWeights.x,
        encoding.lumaWeights.y,
        encoding.lumaWeights.z,
        encoding.lumaScale);
}

void printPreview(NativeString label, float lumaCode)
{
    // Validate the incoming sample with `color-encoding` before handing it to
    // the display package, so out-of-range input is reported as such instead of
    // silently converting to an out-of-gamut color.
    float3 ycbcr = float3(lumaCode, 128.0, 128.0) / 255.0;
    if (!isLegalLumaSample(ycbcr.x))
    {
        printf("%s: luma code %.0f is outside the legal range; skipped\n", label, lumaCode);
        return;
    }

    PreviewResult result = previewRec709Pixel(ycbcr);
    printf(
        "%s: luma code %.0f -> RGB=(%.3f, %.3f, %.3f)\n",
        label,
        lumaCode,
        result.rgb.x,
        result.rgb.y,
        result.rgb.z);
}

export __extern_cpp int main(int argc, Ptr<NativeString> argv)
{
    printf("Synthetic Rec. 709 YCbCr preview (no video decoding or window)\n");
    printEncodingSummary();

    printPreview("black    ", 16.0);
    printPreview("gray     ", 126.0);
    printPreview("white    ", 235.0);
    printPreview("superwhite", 250.0);

    PreviewResult revision = previewRec709Pixel(float3(126.0, 128.0, 128.0) / 255.0);
    printf(
        "Package revisions: encoding=%d, convert=%d, display=%d\n",
        revision.encodingRevision,
        revision.converterRevision,
        revision.displayRevision);
    return 0;
}
