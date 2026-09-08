---
name: ai-visibility-checker
description: Use to check whether a website is being cited or mentioned in AI search results across ChatGPT, Gemini, Google AI Overviews and Perplexity, compare it against competitors, and produce the gap list of queries it should own but doesn't. Step 5 of the 5-skill SEO system. Use for AI visibility, GEO, AI search tracking, LLM citations, "am I showing up in ChatGPT", or AI Overview monitoring.
---

# AI Visibility Checker

Step 5 of 5, and the one that closes the loop. Ranking in Google and being cited by
an AI engine are different outcomes with different causes. This measures the second
one, then hands the gaps back to Step 1.

## Before you start

**The DataForSEO connector is required**, specifically its AI Optimization tools. If
you cannot find any, the connector may have been added with a restricted module set.
Say so plainly rather than substituting a workaround:

> I can't see the DataForSEO AI Optimization tools, so I can't get real citation
> data. Guessing at this would be worse than not answering. Check the connector has
> the AI_OPTIMIZATION module enabled and re-run.

**Read `site-brief.md`** for the brand name, domain, competitors, country and
language. Without the brand name you cannot tell a mention of this business from a
mention of a similarly-named one.

## Input

- The domain and brand name (from the brief)
- The queries to check. Use the fan-out questions from `01-keyword-map.csv` if
  present, otherwise ask, otherwise derive them from the services in the brief.
- Competitors (from the brief)

Check between 10 and 25 queries. Say how many you checked and why you stopped there.

## Process

### Step 1 — Pull the citation data

Endpoints, by API path:

- `ai_optimization/llm_mentions` — the main one. Brand, domain and keyword mentions
  across LLM responses, with the sources cited and the snippets.
- `ai_optimization/chat_gpt/llm_responses` and the Gemini, Claude and Perplexity
  equivalents — live spot checks on specific queries.
- `ai_optimization/ai_keyword_data/keyword_data` — AI search volume, to weight which
  gaps are worth chasing.

Match tools by description rather than assuming exact names.

### Step 2 — Classify every result

For each query and engine, record:

- Is **this domain** cited with a link? That is a citation.
- Is the **brand named** without a link? That is a mention, and it counts for less.
  Track it separately; do not merge the two numbers.
- Which domains **are** cited?
- Which exact sentence was attributed to each source?

Be strict about identity. A different business with a similar name is not you, and a
citation of a directory listing that happens to include the business is not a
citation of the site.

### Step 3 — Compare

Build the competitor table: citations, queries won, and share of total citations
across the checked set. Include this domain in the same table so the comparison is
direct.

### Step 4 — The gap list

A gap is a query where a competitor is cited and this domain is not.

For each gap, record which page of theirs gets cited and **what that page has that
this site doesn't.** Be specific: a stat with a primary source, a comparison table,
first-hand testing, a clearer direct answer near the top. That specific difference is
the actionable part.

Rate each gap `pass` (winnable now), `warn` (needs real work), `fail` (not realistic
soon), and rank the list by winnability against AI search volume.

### Step 5 — Protect what you have

List the queries where this domain is already cited, with the page and the sentence
that got lifted. These are worth defending and worth learning from: whatever those
pages do is what the rest of the site should copy.

## Output

**`05-ai-visibility.html`** — fill `templates/ai-visibility.html.template`.

Build a `data.json` and render it:

```
python3 scripts/render.py templates/ai-visibility.html.template data.json 05-ai-visibility.html
```

Row blocks: `ENGINE_ROW`, `RIVAL_ROW`, `GAP_ROW`, `WIN_ROW`, `NEXT_ROW`.

Notes:
- In `RIVAL_ROW`, set `ROW_IS_YOU` to ` ← you` on this domain's row and empty on the
  others.
- If cited nowhere, pass an empty `WIN_ROW` list and set `WIN_EMPTY_DISPLAY` to
  `block`, otherwise `none`.
- `CITED_CLASS` should be `is-fail` when citations are zero, so the number reads as
  the finding it is.
- `NEXT_ROW` is the top three to five gaps, phrased as the next seed keywords.

## Honesty rules

This skill is the easiest of the five to fake and the most damaging to fake.

- **Zero citations is a real, useful answer.** Report it plainly. Do not soften it
  into "limited visibility" and do not pad the report with mentions to make the
  number look better.
- Never list a citation you did not receive from the API.
- LLM responses vary between runs. Say when the data was pulled and that a re-run
  can differ. Do not present a single check as a stable ranking.
- If coverage was thin for an engine, say which engine and why, rather than
  averaging it away.

## Closing the loop

End with the handoff that makes these five a system rather than a pipeline:

> Take the top gaps and feed them back into `keyword-fanout-map` as your next seed
> keywords. That's the loop: research, write, optimise, link, check, then research
> the gap you just found.
