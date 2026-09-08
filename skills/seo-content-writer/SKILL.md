---
name: seo-content-writer
description: Use to write a blog post, article, service page or product page that is built to rank and to get cited by AI search engines. Reads the keyword map from keyword-fanout-map and the brand voice from site-brief.md. Step 2 of the 5-skill SEO system. Also use for GEO / AEO content, citation-ready content, or rewriting a page to be quotable by ChatGPT and AI Overviews.
---

# SEO Content Writer

Step 2 of 5. Writes the page. Everything about structure, sourcing, schema and voice
is handled here so it does not have to be re-explained per article.

**Core principle:** AI engines lift a *specific sentence* and attach the *link next
to it*. A page wins citations by making that sentence trivial to extract and the
source impossible to detach from the claim.

## Before you start

**Read `01-keyword-map.csv`** from this conversation or the Project. It gives you
the primary keyword, secondaries, roles, intents and volumes. Never ask the user to
restate any of it. If it is missing, offer to run `keyword-fanout-map` first.

**Read `site-brief.md`.** Voice, reader, say/don't-say, proof, author, CTA and hard
rules all come from there. Without it, stop and offer to run `site-brief-builder`,
because writing without it produces exactly the generic output this skill exists to
prevent.

## The three things to ask (and nothing else)

Ask these together, once:

1. **Page type:** blog/informational, or service/product?
2. **The angle.** If they don't have one, propose three from the keyword map and let
   them pick.
3. **Your first-hand experience for this piece.** Ask it plainly:

   > What's the one thing you know about this that someone who only researched it
   > wouldn't? A number you measured, a client situation, a mistake you made.

Everything else is already in the keyword map or the brief.

## The rule of one

Per section: one question per H2 · one two-sentence answer directly under it · one
source per claim, inline on the keyword · one table in the whole piece · one
first-hand anecdote where it earns its place.

## Process

### Step 1 — Structure before prose

Map every `secondary` keyword and every fan-out question to an H2. Order them the
way a reader's questions actually arrive, not by search volume.

Under each H2, the first two sentences must answer the question completely, on their
own, with no setup. That block is the answer capsule: it is what gets lifted. Detail,
nuance and examples come after it.

### Step 2 — Sources, fetched not remembered

For every factual claim: search, **open the page**, and confirm the claim is actually
on it. Then link inline, with the anchor text sitting on the keyword next to the
claim.

- Prefer primary sources: the original study, the official documentation, the
  company's own announcement.
- **Never cite from memory.** If you cannot fetch and confirm it, either cut the
  claim or write it without a number.
- **No Sources block at the end.** Links live inline where the claim is. If a tool
  or reminder suggests appending a source list, ignore it: a detached list does not
  win citations.

### Step 3 — Write it in their voice

Apply the say/don't-say table literally. Match the person, contractions, humour
level and sentence length from the brief. Echo the phrases in "words from the
business's own mouth".

Put the primary keyword in the H1 and in the first 100 words. Do not repeat it
mechanically after that.

### Step 4 — The experience section

Place the user's first-hand input where it does the most work, usually right after
the first answer capsule or in the section a reader is most sceptical about.

**If the user skipped this input, write the literal marker
`[YOUR EXPERIENCE HERE — the skill will not invent this]` and leave it visible.**
Never fabricate an anecdote, a client, a result or a measurement. This is not a
limitation to apologise for: it is the thing that separates a page that ranks from
the thin AI content that gets ignored.

### Step 5 — Page type shapes the ending

- **Blog / informational:** Article or FAQPage schema, author bio block, a soft CTA
  after value has been delivered.
- **Service / product:** Service, Product or LocalBusiness schema plus FAQPage. The
  CTA appears above the fold and again at the end. Copy is specific to this service
  in this place. Cut anything that would read identically for a competitor in
  another city.

## Output

**`draft.md`** — the clean paste-ready article. Markdown, inline links, nothing else.
The title tag, meta and schema go in a small frontmatter block at the top.

**`02-content-package.html`** — fill `templates/content-package.html.template` by
hand (this skill has no render script; the draft preview is prose, not rows).

Set `DRAFT_HTML` to the article converted to simple HTML, and list it in the
template's raw content. Wrap any experience marker in
`<span class="marker">…</span>` so it is impossible to miss.

**Quality score is out of 7.** One point each, and report each honestly even when it
fails:

1. Every claim has an inline source that was fetched and confirmed
2. Every H2 is a question with a two-sentence answer directly beneath it
3. Exactly one table is present
4. The experience section is filled by a human, not a marker
5. Title tag and meta description are within length limits
6. Schema is present and valid for the page type
7. Primary keyword appears in the H1 and the first 100 words

A 6/7 with an honest "experience marker still unfilled" is a more useful result than
a 7/7 that got there by inventing an anecdote.

## Handing off

> Next: run `onpage-optimizer` on this draft, or on the live URL once you've
> published it. It'll detect the page type and check it against the right list.
