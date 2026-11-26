# Builds Modules/QOL/Forever/DungeonMapData.lua from ForeverDungeonRoutes (MIT, Checkov23).
#   node Tools/fdr_extract.js <ForeverDungeonRoutes addon folder> /tmp/fdr.json   (npm i fengari)
#   python3 Tools/gen_mapdata.py Modules/QOL/Forever/DungeonMapData.lua
import json, sys
d = json.load(open('/tmp/fdr.json'))
OUT = sys.argv[1]
LANGS = ["", "FR", "DE", "ES", "PT"]   # en fr de es pt (itIT falls back to en)

# codex key -> FDR key (classic instances only; new Forever dungeons have no game map art)
CODEX = {
 "rfc":"ragefire","wc":"wailingcaverns","vc":"deadmines","sfk":"shadowfang","bfd":"blackfathom",
 "stocks":"stockade","rfk":"razorfenkraul","gnomer":"gnomeregan","smgy":"sm_graveyard",
 "smlib":"sm_library","smarm":"sm_armory","rfd":"razorfendowns","smcath":"sm_cathedral",
 "ulda":"uldaman","zf":"zulfarrak","mara":"maraudon","st":"sunkentemple","brd":"blackrockdepths",
 "dme":"diremaul_east","lbrs":"lowerblackrock","dmw":"diremaul_west","dmn":"diremaul_north",
 "stratlive":"stratholme","stratud":"stratholme","scholo":"scholomance","ubrs":"upperblackrock",
}
NEW_FOREVER = ["hot","rol","exc","dal","drowned","kroldok","alcaz","blackmaw","shaper"]
floors = {int(k): v for k, v in d["floors"].items()}

def lstr(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n') + '"'

def names(obj, base="name"):
    vals = [obj.get(base + l) for l in LANGS]
    en = vals[0]
    out = []
    for i, v in enumerate(vals):
        out.append("nil" if (v is None or (i > 0 and v == en)) else lstr(v))
    while out and out[-1] == "nil": out.pop()
    return "{" + ",".join(out) + "}"

def L(x): return x if isinstance(x, list) else []

def num(x): return ("%.4f" % x).rstrip("0").rstrip(".")

lines = []
w = lines.append
w("-- =====================================================================")
w("-- Modules/QOL/Forever/DungeonMapData.lua -- dungeon and raid maps (1.3.9)")
w("--")
w("-- Generated from ForeverDungeonRoutes by Checkov23 (MIT License,")
w("-- Copyright (c) 2026 Checkov23, github.com/Checkov23/ForeverDungeonRoutes,")
w("-- full licence text in Modules/QOL/Forever/DungeonMap.lua): its dungeon")
w("-- list, the floors of the game's map tables with their art tiles, and the")
w("-- boss stops, notes and floor links of its built-in routes. Only the")
w("-- classic dungeons and the raids: the maps of the new Forever dungeons are")
w("-- Santiago Reyes' (Atlas de Azeroth: Forever), not under the MIT licence,")
w("-- and are not included.")
w("--")
w("-- Names: { en, fr, de, es, pt }, nil where the same as English.")
w("-- floors[uiMapID] = { n = names, t = { 12 texture file IDs, 4 across, 3 down } }")
w("-- Points: x, y in 0..1 over the 1002 x 668 pixels of the map art.")
w("-- Do not edit by hand: Tools/fdr_extract.js then Tools/gen_mapdata.py.")
w("-- =====================================================================")
w("")
w("TomoMod_DungeonMapData = {")
w("    order = {")
used_floors = set()
inst_lines = []
order = []
for dg in d["dungeons"]:
    fl = dg["floors"]
    key = dg["key"]
    if key == "upperblackrock":
        fl = [250, 251, 252, 253, 254, 255]       # the game's Blackrock Spire floors
    if any(f not in floors or "tiles" not in floors[f] for f in fl):
        continue
    order.append(key)
    used_floors.update(fl)
    lv = dg.get("levels", [0, 0])
    inst_lines.append('        %s = { n = %s, id = %d, raid = %s, min = %d, max = %d, floors = { %s }%s },' % (
        key, names(dg), dg["instanceID"], "true" if dg.get("raid") else "false", lv[0], lv[1],
        ", ".join(str(f) for f in fl), ", noPins = true" if key == "upperblackrock" else ""))
for k in order: w('        "%s",' % k)
w("    },")
w("    codex = {")
for ck, fk in CODEX.items():
    assert fk in order, fk
    w('        %s = "%s",' % (ck, fk))
w("    },")
w("    newForever = { %s }," % ", ".join("%s = true" % k for k in NEW_FOREVER))
w("    instances = {")
lines.extend(inst_lines)
w("    },")
w("    floors = {")
for f in sorted(used_floors):
    fv = floors[f]
    w("        [%d] = { n = %s, t = { %s } }," % (f, names(fv), ", ".join(str(t) for t in fv["tiles"])))
w("    },")
w("    -- pins[key] = { { kind, floor, x, y, names, note }, ... } in route order;")
w("    -- kind: b boss, r rare, o optional, n note, l link (note = target floor, names = label)")
w("    pins = {")
KIND = {"boss": "b", "rare": "r", "optional": "o"}
total = 0
for key in order:
    if key == "upperblackrock": continue
    r = d["routes"].get(key)
    if isinstance(r, list):   # several built-in routes (Maraudon): the first one
        r = r[0] if r else None
    if not r: continue
    items = []
    for s in L(r.get("stops")):
        k = KIND.get(s.get("kind"))
        if not k or s.get("floor") not in used_floors: continue
        note = names(s, "note") if s.get("note") else "nil"
        items.append('{ "%s", %d, %s, %s, %s, %s }' % (k, s["floor"], num(s["x"]), num(s["y"]), names(s), note))
    for n in L(r.get("notes")):
        if n.get("floor") not in used_floors or not n.get("text"): continue
        items.append('{ "n", %d, %s, %s, %s }' % (n["floor"], num(n["x"]), num(n["y"]), names(n, "text")))
    for l in L(r.get("links")):
        if l.get("floor") not in used_floors or l.get("to") not in used_floors: continue
        items.append('{ "l", %d, %s, %s, %s, %d }' % (l["floor"], num(l["x"]), num(l["y"]), lstr(l.get("label", "")), l["to"]))
    total += len(items)
    w("        %s = {" % key)
    for it in items: w("            " + it + ",")
    w("        },")
w("    },")
w("}")
open(OUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("instances", len(order), "floors", len(used_floors), "pins", total)
