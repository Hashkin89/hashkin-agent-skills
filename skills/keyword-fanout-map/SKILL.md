---
name: keyword-fanout-map
description: Use for keyword research: turning a seed keyword, business type or topic into an intent-clustered keyword map with real search volumes, AI search volume and the fan-out questions a page must answer. Step 1 of the 5-skill SEO system. Also use when asked what to write about, which keyword to target, or to find keywords for a page.
---

# Keyword & Fan-Out Map

Step 1 of 5. Produces the keyword map every later skill reads, so nothing has to be
restated.

## Before you start

**Required: the DataForSEO connector.** Without it there are no real search volumes
and this skill would be guessing, which is worse than useless because the guesses
look like data.

Check for a DataForSEO tool. If there isn't one, stop and say:

> This skill needs real search data. Connect DataForSEO first:
> Customize → Connectors → Add custom connector → `https://mcp.dataforseo.com/mcp`
> → Connect → approve. Takes about a minute, then run this again.

**Also read `site-brief.md`** from the Project. Take `SEARCH_COUNTRY`,
`SEARCH_LANGUAGE`, the service area, the services list and the competitors from it.
If it is missing, say so and offer to run `site-brief-builder` first. You can
proceed without it, but you must then ask for country and language explicitly and
warn that the volumes are only correct for the values given.

## Input

A seed keyword, or a business type plus location, or just a topic. If the user
gives you nothing, propose three seeds from the services list in the brief.

## Process

### Step 1 — Expand

Use the DataForSEO connector. The endpoints you want, by API path:

- `dataforseo_labs/google/keyword_ideas` — the main expansion
- `dataforseo_labs/google/related_keywords` — semantic neighbours
- `keywords_data/google_ads/search_volume` — volume, CPC, competition
- `ai_optimization/ai_keyword_data/keyword_data` — AI search volume, meaning how
  often people put this into an LLM rather than a search box
- `serp/google/organic` — who currently ranks (optional but makes the report better)

Tool names in the connector map onto these paths. Pick the matching tool by its
description rather than assuming an exact name.

Always pass the location and language from the brief. Never default to the United
States because it is convenient.

### Step 2 — Filter and cluster

Discard: keywords with zero volume and zero AI volume, obvious misspellings, and
branded terms belonging to competitors.

Group what is left into topic clusters. Tag every keyword with one intent:

- `informational` — wants to understand ("what is", "how does")
- `commercial` — comparing before buying ("best", "vs", "review")
- `transactional` — ready to act ("near me", "book", "buy", "price")
- `navigational` — looking for a specific brand

Then assign each keyword a **role**:

- `primary` — exactly one. The H1 subject.
- `secondary` — earns its own H2.
- `support` — use naturally in body copy.
- `skip` — right topic, wrong intent for this page. Keep it visible so the user can
  see it was considered and rejected rather than missed.

**Pick the primary on intent match, not just volume.** A 2,400/month
informational keyword is the wrong primary for a service page, and choosing it is
the single most common keyword research mistake.

### Step 3 — Fan-out questions

Get the follow-up queries AI engines expand this topic into:

- `ai_optimization/llm_mentions` for the fan-out queries attached to the topic
- the People Also Ask block from the SERP endpoint
- `dataforseo_labs/google/related_keywords` question-form results

Keep the ones a single page could genuinely answer. Each becomes an H2 with a
two-sentence answer directly under it. Drop anything that belongs on a different
page and say so.

## Output

Write two files.

**`01-keyword-map.csv`** — columns exactly:
`cluster,keyword,intent,role,search_volume,ai_search_volume,competition,cpc`
Sort by role (primary, secondary, support, skip) then volume descending. This is
the file `seo-content-writer` reads, so the column names matter.

**`01-keyword-map.html`** — fill `templates/keyword-map.html.template`.

Build a `data.json` and render it:

```
python3 scripts/render.py templates/keyword-map.html.template data.json 01-keyword-map.html
```

`data.json` shape:

```json
{
  "tokens": { "SUBJECT": "...", "KW_TOTAL": 42, "...": "..." },
  "rows": {
    "KEYWORD_ROW": [{ "ROW_CLUSTER": "...", "ROW_KEYWORD": "...", "...": "..." }],
    "FANOUT_ROW": [{ "ROW_QUESTION": "...", "ROW_QUESTION_NOTE": "..." }],
    "SERP_ROW": [{ "ROW_POSITION": 1, "ROW_DOMAIN": "...", "...": "..." }]
  }
}
```

Notes on tokens:
- `ROW_INTENT_CLASS` must be one of `info`, `comm`, `trans`, `nav`.
- If you skipped the SERP check, set `SERP_TABLE_DISPLAY` to `none` and
  `SERP_EMPTY_DISPLAY` to `block`. Otherwise `block` and `none`.
- `DATA_WINDOW` is the volume window, normally "12-month average".
- `DATA_NOTES` must state the location and language used. This is how the user
  catches a wrong-market run.

Do not restyle the template. Do not add fonts, colours or charts.

## Honesty rules

- Never write a volume you did not get from the API. If a keyword returned no
  volume, show "no data", not 0 and not an estimate.
- AI search volume is newer and thinner than Google volume. Where it is missing,
  say missing rather than implying zero demand.
- If the total keyword count is small because the niche is small, say so. A short
  honest map beats a padded one.

## Handing off

Finish by telling the user:

> Next: run `seo-content-writer`. It reads `01-keyword-map.csv` on its own, so you
> won't need to repeat the keyword. It will ask you three things, and one of them
> only you can answer.
