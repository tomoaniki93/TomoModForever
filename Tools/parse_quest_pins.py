"""Read foreverchanges.pro quest pages (saved as <questID>.html) and print
"questID|zoneID|x|y|giver|endZoneID|endX|endY|ender" lines (- when unknown).

Usage: python parse_quest_pins.py <dir with pages> <ids file>
The page embeds its map data as escaped JSON: "zones":[{"id":<uiMapID>,
"pins":[{"x","y","name","start","end"}]}].
"""
import json, re, sys

src, ids = sys.argv[1], sys.argv[2]

def zones_of(html):
    text = html.replace('\\"', '"').replace('\\\\', '\\')
    i = text.find('"zones":[{"id"')
    if i < 0:
        return []
    start = i + len('"zones":')
    depth, j = 0, start
    while j < len(text):
        c = text[j]
        if c == '[': depth += 1
        elif c == ']':
            depth -= 1
            if depth == 0: break
        j += 1
    try:
        return json.loads(text[start:j + 1])
    except ValueError:
        return []

# Zone names -> uiMapID, from the zones' own pages (map data) when the map
# has no pin: the facts list still gives "Name Zone x, y".
ZONE_IDS = {}

def facts_of(html):
    """Start / End from the facts list: (kind, name, zoneName, x, y, item)."""
    i = html.find('class="qp-facts"')
    if i < 0:
        return {}
    block = html[i:i + 4000]
    block = block.replace("<!-- -->", "")
    out = {}
    for kind in ("Start", "End"):
        m = re.search(kind + r'</dt><dd>(.*?)</dd>', block)
        if not m:
            continue
        dd = m.group(1)
        coord = re.search(r'<span class="qp-coord">\s*([^<]*?)\s+([\d.]+),\s*([\d.]+)</span>', dd)
        name = re.sub(r'<[^>]+>', '|', dd).split('|')
        name = [n.strip() for n in name if n.strip()]
        item = re.search(r'an item:\s*</?[^>]*>?\s*([^<]+)', dd)
        out[kind] = (name[0] if name else "-", coord.group(1).strip() if coord else None,
                     coord.group(2) if coord else None, coord.group(3) if coord else None,
                     bool(re.search(r'an item', dd)))
    return out

import html as htmlmod

for qid in (l.strip() for l in open(ids) if l.strip()):
    try:
        html = open(f"{src}/{qid}.html", encoding="utf-8", errors="replace").read()
    except OSError:
        print(f"{qid}|-|-|-|-|-|-|-|-"); continue
    start = end = None
    zones = zones_of(html)
    for z in zones:
        ZONE_IDS.setdefault(z.get("name"), z.get("id"))
    for z in zones:
        for p in z.get("pins", []):
            if p.get("start") and not start: start = (z["id"], p["x"], p["y"], p.get("name", "-"))
            if p.get("end") and not end: end = (z["id"], p["x"], p["y"], p.get("name", "-"))
    facts = facts_of(html)
    for kind in ("Start", "End"):
        f = facts.get(kind)
        if not f:
            continue
        name, zone, x, y, item = f
        name = htmlmod.unescape(name)
        if item:
            name = "item:" + htmlmod.unescape(name.split(":", 1)[-1].strip()) if ":" in name else "item"
        zid = ZONE_IDS.get(htmlmod.unescape(zone)) if zone else None
        val = (zid or "-", x or "-", y or "-", name) if (zid and x) else ("-", "-", "-", name)
        if kind == "Start" and not start: start = val
        if kind == "End" and not end: end = val
    s = start or ("-", "-", "-", "-")
    e = end or ("-", "-", "-", "-")
    print("|".join(str(v) for v in (qid, *s, *e)))
