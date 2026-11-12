"""Read foreverchanges.pro quest pages (saved as <questID>.html) and write
one JSON object per quest: start / end (NPC or item, zone, x, y) and the
chain steps before the quest.

Usage: python parse_quest_pages.py <pages dir> <ids file> <out.jsonl>
Positions come from the page's map data (escaped JSON "zones":[{"id",
"name","pins":[{x,y,name,start,end}]}]) or from its facts list
("Start <NPC> <Zone> x, y"); zone names are turned into uiMapIDs with the
zones seen on all the pages.
"""
import html as H, json, re, sys

src, ids, out = sys.argv[1], sys.argv[2], sys.argv[3]

def zones_of(page):
    text = page.replace('\\"', '"').replace('\\\\', '\\')
    found = []
    for m in re.finditer(r'"zones":\[\{"id"', text):
        start = m.start() + len('"zones":')
        depth, j = 0, start
        while j < len(text):
            if text[j] == '[': depth += 1
            elif text[j] == ']':
                depth -= 1
                if depth == 0: break
            j += 1
        try:
            found = json.loads(text[start:j + 1]); break
        except ValueError:
            continue
    return found

def clean(fragment):
    t = fragment.replace("<!-- -->", "")
    t = re.sub(r"<[^>]+>", "|", t)
    return [H.unescape(x).strip() for x in t.split("|") if x.strip()]

def facts_of(page):
    i = page.find('class="qp-facts"')
    block = page[i:i + 5000].replace("<!-- -->", "") if i >= 0 else ""
    out = {}
    for kind in ("Start", "End"):
        m = re.search(kind + r"</dt><dd>(.*?)</dd>", block)
        if not m:
            continue
        dd = m.group(1)
        coord = re.search(r'<span class="qp-coord">\s*([^<]*?)\s+([\d.]+),\s*([\d.]+)</span>', dd)
        parts = clean(re.sub(r'<span class="qp-coord">.*?</span>', "", dd))
        item = "an item" in dd
        name = parts[-1] if parts else None
        if item and name and name.lower().startswith("an item"):
            name = name.split(":", 1)[-1].strip() or None
        out[kind] = {"name": name, "item": item,
                     "zoneName": H.unescape(coord.group(1)).strip() if coord else None,
                     "x": float(coord.group(2)) if coord else None,
                     "y": float(coord.group(3)) if coord else None}
    return out

def chain_of(page):
    i = page.find('<ol class="qp-route">')
    if i < 0:
        return []
    j = page.find("</ol>", i)
    steps = re.split(r"<li[ >]", page[i:j])[1:]
    before = []
    for step in steps:
        if 'class="is-here"' in step[:60] or "qp-route-here" in step:
            break
        quests = []
        for q in re.split(r'<div class="qp-route-quest', step)[1:]:
            link = re.search(r'href="/quest/(\d+)/[^"]*">([^<]+)</a>', q)
            level = re.search(r'qp-route-level">\[(?:<!-- -->)?(\d+)', q)
            who = re.search(r'qp-route-who">.*?<span><span[^>]*>([^<]+)</span>(?:<small>([^<]+)</small>)?', q, re.S)
            if link:
                quests.append({"id": int(link.group(1)), "title": H.unescape(link.group(2)),
                               "level": int(level.group(1)) if level else None,
                               "who": H.unescape(who.group(1)) if who else None,
                               "zoneName": H.unescape(who.group(2)) if who and who.group(2) else None})
        if quests:
            before.append(quests)
    return before

pages, zone_ids = {}, {}
for qid in (l.strip() for l in open(ids) if l.strip()):
    try:
        page = open(f"{src}/{qid}.html", encoding="utf-8", errors="replace").read()
    except OSError:
        continue
    zones = zones_of(page)
    for z in zones:
        if z.get("name") and z.get("id"):
            zone_ids.setdefault(z["name"], z["id"])
    pages[qid] = (page, zones)

with open(out, "w", encoding="utf-8") as fh:
    for qid, (page, zones) in pages.items():
        rec = {"id": int(qid)}
        facts = facts_of(page)
        for kind, key in (("Start", "start"), ("End", "end")):
            f = facts.get(kind)
            if not f:
                continue
            pin = None
            for z in zones:
                for p in z.get("pins", []):
                    if p.get(key) and pin is None:
                        pin = (z["id"], p["x"], p["y"], p.get("name"))
            entry = {"name": f["name"], "item": f["item"]}
            if pin:
                entry.update(map=pin[0], x=pin[1], y=pin[2])
                entry["name"] = entry["name"] or pin[3]
            elif f["x"] is not None:
                entry.update(map=zone_ids.get(f["zoneName"]), x=f["x"], y=f["y"], zoneName=f["zoneName"])
            rec[key] = entry
        chain = chain_of(page)
        for step in chain:
            for q in step:
                q["map"] = zone_ids.get(q.pop("zoneName", None) or "")
        if chain:
            rec["chain"] = chain
        fh.write(json.dumps(rec, ensure_ascii=False) + "\n")
print(len(pages), "pages,", len(zone_ids), "zone names")
