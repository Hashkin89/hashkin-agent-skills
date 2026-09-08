---
name: internal-link-architect
description: Use to plan internal links for a page. Crawls the site's existing pages and returns exactly which pages should link to the target and which the target should link out to, with the exact anchor text and the sentence to place it in. Also finds orphan pages and maps topic clusters. Step 4 of the 5-skill SEO system. Use for internal linking, orphan pages, topical authority or site structure questions.
---

# Internal Link Architect

Step 4 of 5. This is the step almost everyone skips. People publish a post and link
it from nowhere, so it sits with no internal authority and Google has no signal that
it belongs to a topic the site covers in depth.

It is also the most rules-based of the five, which is why automating it works well.

## Before you start

**The DataForSEO connector is required.** This skill needs a real page inventory.

**Read `site-brief.md`** for the domain and, importantly, the **money pages**, so
links get prioritised towards the pages that actually earn.

## Input

The target page (a live URL, or the draft plus its intended URL) and the domain.

## Process

### Step 1 — Build the page inventory

Get every indexable page on the site with its URL, title, H1 and main topic.

- Start with `/sitemap.xml`. If it returns HTML rather than XML, the sitemap is
  missing or broken: report that as a finding, it is a real problem, then fall back
  to a crawl.
- Use `on_page/task_post` for a full crawl, or `on_page/pages` for the page list on
  a site already crawled. For topic extraction use `on_page/content_parsing`.
- Exclude: tag and category archives, paginated archives, thank-you pages,
  noindex pages, and the target page itself.

Report how many pages you crawled. If you had to cap the crawl, **say what you
capped and what was left out.** A silent cap reads as complete coverage.

### Step 2 — Find the links IN (this is the valuable half)

For each existing page, decide whether it has a genuine reason to link to the
target. A reason means the source page already discusses the target's topic in
passing.

For every proposed link, give all four of these:

1. **Source page URL** to edit
2. **Exact anchor text.** Descriptive and keyword-relevant. Never "click here",
   never the bare URL, never the same anchor on every link.
3. **The actual sentence on the source page** where the link belongs, quoted, so the
   user can search for it and place the link in seconds.
4. **Priority:** `pass` for high (strong topical match, strong page), `warn` for
   medium, `na` for optional.

Rank by topical relevance first, then by how strong the source page is.

**Cap at 15 links in.** More than that on one target looks manipulative and nobody
will place 40 links by hand. If you found more, say how many you found and that you
showed the top 15.

### Step 3 — Find the links OUT

From the target page, link to existing pages that genuinely help the reader. Push
towards money pages where the context is honest. Never force a money-page link into
a sentence where it does not belong: that is the thing that makes a page read like
SEO spam.

Cap at 8.

### Step 4 — Orphans

List pages with zero internal links pointing at them, excluding the homepage. For
each, name the best page to link from and a suggested anchor. This is usually the
highest-value thing in the whole report because these pages are currently invisible.

### Step 5 — Topic clusters

Group the inventory into topic clusters. For each: how many pages, which is the hub,
and whether the members actually interlink (`pass`), interlink weakly (`warn`), or
sit isolated (`fail`).

## Output

**`04-internal-links.html`** — fill `templates/internal-links.html.template`.

Build a `data.json` and render it, because these tables get long:

```
python3 scripts/render.py templates/internal-links.html.template data.json 04-internal-links.html
```

Row blocks: `LINK_IN_ROW`, `LINK_OUT_ROW`, `ORPHAN_ROW`, `CLUSTER_ROW`.

Notes:
- `ROW_PRIORITY_CLASS` and `ROW_CLUSTER_CLASS` are one of `pass`, `warn`, `fail`,
  `na`.
- If there are no orphans, pass an empty `ORPHAN_ROW` list and set
  `ORPHAN_EMPTY_DISPLAY` to `block`. Otherwise set it to `none`.
- `DATA_NOTES` must state how many pages were crawled and anything excluded or
  capped.

## Honesty rules

- Only propose a link where the source page genuinely discusses the topic. A
  plausible-looking link plan full of forced links is worse than a short honest one.
- Quote real sentences from the real page. Never invent the sentence the anchor goes
  in: the user will search for it and not find it, and the whole report loses trust.
- If the target page is brand new and nothing on the site relates to it, say that
  plainly and suggest what to publish first.

## Handing off

> Next: run `ai-visibility-checker`. It's the one that tells you whether any of this
> is actually getting you cited in ChatGPT and AI Overviews.
