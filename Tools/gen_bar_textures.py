"""Generates the TMF action button textures (1.4.1):
  ornate_frame.tga  bronze bevel frame, gold corner studs, transparent centre
  ornate_glow.tga   soft gold halo around a button (hover / ready pulse)
  shine.tga         diagonal light band swept across an icon when a cooldown ends
Palette: Forever bronze (0.545,0.420,0.247) and antique gold (0.788,0.635,0.322).
"""
import math, sys
from PIL import Image, ImageFilter, ImageDraw

out = sys.argv[1]
S = 128
BRONZE_D = (74, 52, 26)
BRONZE   = (139, 107, 63)
GOLD     = (201, 162, 82)
GOLD_L   = (246, 214, 140)

def lerp(a, b, t): return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))

# ---------------------------------------------------------------- frame
fr = Image.new("RGBA", (S, S), (0, 0, 0, 0))
px = fr.load()
outer, band = 2, 13          # band = bronze thickness in px (at 128)
for y in range(S):
    for x in range(S):
        d = min(x, y, S - 1 - x, S - 1 - y)          # distance to the edge
        if d < outer or d >= outer + band:
            continue
        t = (d - outer) / (band - 1)                 # 0 outside .. 1 inside
        # bevel: light from the top-left
        light = ((S - x) + (S - y)) / (2 * S)        # 1 top-left .. 0 bottom-right
        prof = math.sin(t * math.pi)                 # raised moulding
        base = lerp(BRONZE_D, BRONZE, prof)
        col = lerp(base, GOLD, max(0, prof - 0.35) * light * 1.4)
        if 0.30 < t < 0.42:                          # thin bright ridge
            col = lerp(col, GOLD_L, 0.55 * light + 0.15)
        a = 255
        if d == outer: a = 170                       # soft outer edge
        px[x, y] = (*col, a)
# dark inner line against the icon
for y in range(S):
    for x in range(S):
        d = min(x, y, S - 1 - x, S - 1 - y)
        if d in (outer + band, outer + band + 1):
            px[x, y] = (8, 6, 4, 230 if d == outer + band else 120)
# gold diamond studs on the corners
dr = ImageDraw.Draw(fr)
for cx, cy in ((9, 9), (S - 10, 9), (9, S - 10), (S - 10, S - 10)):
    r = 7
    dr.polygon([(cx, cy - r), (cx + r, cy), (cx, cy + r), (cx - r, cy)], fill=(*GOLD, 255), outline=(*BRONZE_D, 255))
    dr.polygon([(cx, cy - r + 2), (cx + r - 3, cy - 1), (cx, cy), (cx - r + 3, cy - 1)], fill=(*GOLD_L, 255))
fr.save(f"{out}/ornate_frame.tga")

# ---------------------------------------------------------------- glow
gl = Image.new("L", (S, S), 0)
g = ImageDraw.Draw(gl)
g.rounded_rectangle((18, 18, S - 19, S - 19), radius=10, outline=255, width=10)
gl = gl.filter(ImageFilter.GaussianBlur(9))
glow = Image.new("RGBA", (S, S), (*GOLD_L, 0))
glow.putalpha(gl.point(lambda v: min(255, int(v * 1.6))))
glow.save(f"{out}/ornate_glow.tga")

# ---------------------------------------------------------------- shine
W, H = 64, 128
sh = Image.new("RGBA", (W, H), (255, 236, 190, 0))
sp = sh.load()
for y in range(H):
    for x in range(W):
        t = abs(x - W / 2) / (W / 2)                 # 0 centre .. 1 edge
        a = max(0.0, 1 - t) ** 2.2
        v = abs(y - H / 2) / (H / 2)
        a *= max(0.0, 1 - v ** 4)
        sp[x, y] = (255, 236, 190, int(a * 235))
sh.save(f"{out}/shine.tga")
print("ok")
