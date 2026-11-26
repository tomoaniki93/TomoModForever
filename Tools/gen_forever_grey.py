# Greyscale variants of the Forever metal pieces, for tinting in game (gold, black, class).
import sys, numpy as np
from PIL import Image
D = sys.argv[1]
for name in ["edge_h", "edge_hb", "edge_v", "edge_vr", "corner", "crest", "plate_l", "plate_m", "plate_r", "socket", "divider"]:
    im = np.asarray(Image.open(f"{D}/{name}.tga").convert("RGBA")).astype(float) / 255
    rgb, a = im[..., :3], im[..., 3:]
    lum = rgb @ np.array([0.30, 0.55, 0.15])
    # Normalise on the metal (opaque pixels) so the highlights reach ~1:
    # the tint colour then shows at full strength, the shading stays.
    m = a[..., 0] > 0.5
    top = np.percentile(lum[m], 99) if m.any() else 1
    lum = np.clip(lum / max(top, 1e-3), 0, 1) ** 0.9
    # Dark field of plates and socket holes stays dark (it was dark already).
    out = np.concatenate([np.repeat(lum[..., None], 3, 2), a], 2)
    Image.fromarray((out * 255 + 0.5).astype(np.uint8), "RGBA").save(f"{D}/{name}_g.tga")
    print("wrote", name + "_g.tga")
