//TEST:SIMPLE: -I $dirname/../src -I $dirname/../deps/ycbcr-display/src -I $dirname/../deps/color-convert/src -I $dirname/../deps/color-encoding/src

import video.display;
import color.encoding;

float3 previewGray()
{
    return previewRec709Pixel(float3(126.0, 128.0, 128.0) / 255.0).rgb;
}

bool grayIsLegal()
{
    return isLegalLumaSample(126.0 / 255.0);
}

float lumaScaleInUse()
{
    return rec709LimitedRange().lumaScale;
}
