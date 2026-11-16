#!/usr/bin/env python3
"""Generates the textures of the dungeon codex (Assets/Textures/Codex/*.tga).

    python3 Tools/gen_codex_textures.py

Every texture is white (the shadow is black) with the shape in the alpha
channel, so the Lua side tints it with SetVertexColor. 32-bit uncompressed
TGA, top-left origin, power-of-two sizes -- what the other textures of the
addon use. Needs Pillow.
"""
import os
import struct

from PIL import Image, ImageDraw, ImageFilter

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "Assets", "Textures", "Codex")
SS = 8  # supersampling


def save(name, alpha, rgb=(255, 255, 255)):
    """alpha: an 'L' image. Writes <name>.tga with a flat colour."""
    w, h = alpha.size
    px = alpha.tobytes()
    b, g, r = rgb[2], rgb[1], rgb[0]
    body = bytearray()
    for a in px:
        body += bytes((b, g, r, a))
    header = struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, w, h, 32, 0x28)
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, name + ".tga"), "wb") as f:
        f.write(header + bytes(body))


def canvas(w, h=None):
    h = h or w
    img = Image.new("L", (w * SS, h * SS), 0)
    return img, ImageDraw.Draw(img)


def done(img):
    return img.resize((img.width // SS, img.height // SS), Image.LANCZOS)


def P(*pts):
    return [(x * SS, y * SS) for x, y in pts]


def stroke(d, pts, width):
    """Polyline with round joins and caps."""
    pts = P(*pts)
    w = width * SS
    d.line(pts, fill=255, width=int(round(w)), joint="curve")
    r = w / 2
    for x, y in pts:
        d.ellipse((x - r, y - r, x + r, y + r), fill=255)


def ramp(w, h, fn, vertical=False):
    img = Image.new("L", (w, h), 0)
    n = h if vertical else w
    for i in range(n):
        v = max(0, min(255, int(round(255 * fn(i / (n - 1))))))
        for j in range(w if vertical else h):
            img.putpixel((j, i) if vertical else (i, j), v)
    return img


def smooth(t):
    t = max(0.0, min(1.0, t))
    return t * t * (3 - 2 * t)


# --- gradients --------------------------------------------------------
save("fade_h", ramp(64, 4, lambda t: (1 - t) ** 1.7))                       # opaque left -> clear right
save("fade_c", ramp(128, 4, lambda t: smooth(min(t, 1 - t) / 0.30)))          # clear ends, opaque middle
save("fade_v", ramp(4, 64, lambda t: (1 - t) ** 1.7, vertical=True))        # opaque top -> clear bottom

# --- soft drop shadow, 9-sliced by the Lua side (corner 28, 20 outside) -
sh = Image.new("L", (64 * 4, 64 * 4), 0)
ImageDraw.Draw(sh).rectangle((20 * 4, 21 * 4, 44 * 4 - 1, 46 * 4 - 1), fill=255)
sh = sh.filter(ImageFilter.GaussianBlur(7 * 4)).resize((64, 64), Image.LANCZOS)
save("shadow", sh.point(lambda v: int(v * 0.80)), rgb=(0, 0, 0))

# --- corner ornament (top-left; the others are flips) -------------------
img, d = canvas(32)
d.rectangle((0, 0, 26 * SS, 4 * SS - 1), fill=255)
d.rectangle((0, 0, 4 * SS - 1, 26 * SS), fill=255)
save("corner", done(img))

# --- diamonds -----------------------------------------------------------
img, d = canvas(32)
d.polygon(P((16, 3), (29, 16), (16, 29), (3, 16)), fill=255)
save("diamond", done(img))

img, d = canvas(32)
d.polygon(P((16, 1.5), (30.5, 16), (16, 30.5), (1.5, 16)), fill=255)
d.polygon(P((16, 5), (27, 16), (16, 27), (5, 16)), fill=0)
save("diamond_ring", done(img))

# --- icons ----------------------------------------------------------------
img, d = canvas(32)
stroke(d, [(9, 9), (23, 23)], 3.4)
stroke(d, [(23, 9), (9, 23)], 3.4)
save("x", done(img))

img, d = canvas(32)
stroke(d, [(8, 20), (16, 12), (24, 20)], 3.6)
save("chevron", done(img))                                                   # points up

img, d = canvas(32)
stroke(d, [(12, 8), (20, 16), (12, 24)], 3.6)
save("chevron_r", done(img))                                                 # points right

img, d = canvas(32)
stroke(d, [(5, 16), (26, 16)], 3.2)
stroke(d, [(18, 8), (26, 16), (18, 24)], 3.2)
save("arrow", done(img))                                                     # points right

img, d = canvas(32)
d.ellipse(P((7, 3), (25, 21)), fill=255)
d.polygon(P((8.3, 16.5), (23.7, 16.5), (16, 30)), fill=255)
d.ellipse(P((12.2, 8.2), (19.8, 15.8)), fill=0)
save("pin", done(img))

print("written to", os.path.normpath(OUT))
