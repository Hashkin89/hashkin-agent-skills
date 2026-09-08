---
name: site-brief-builder
description: Use FIRST, before any other SEO skill, to create the site-brief.md that the other five skills read. Builds it by crawling the website and interviewing the user only on what it could not work out. Also use when asked to update or fix an existing site brief, or when another SEO skill reports that site-brief.md is missing.
---

# Site Brief Builder

## What this is for

The other five SEO skills are generic. This file is what makes them yours. Without
it they guess at your location, your services, your reader and your voice, and the
output reads like every other AI-written page on the internet.

This skill writes that file for the user instead of handing them a blank form.

## Before you start

Nothing is required. A DataForSEO connector helps but is not needed.

If a `site-brief.md` already exists in this Project, read it first and offer to
update it rather than starting over.

## Process

### Step 1 — Get the URL, then go look

Ask only for the website URL. Do not ask anything else yet.

Then gather what you can on your own:
- Fetch the homepage, the about page, the services or products pages, and two or
  three of the most recent blog posts.
- Try `/sitemap.xml` for the page inventory. If it returns HTML instead of XML,
  note that the sitemap is missing or broken. That is a finding worth reporting.
- If a DataForSEO connector is available, use the **On-Page** API
  (`on_page/content_parsing` or `on_page/instant_pages`) for cleaner extraction.
- Look for the business name, services, locations served, phone and address,
  certifications, awards, named authors, and existing schema markup.
- Read the tone: sentence length, first person singular or plural, whether they use
  contractions, recurring phrases, words they clearly avoid.

### Step 2 — Draft the brief from evidence

Fill every field you can from what you actually read. Write the draft into
`site-brief.md` using `templates/site-brief.md.template`.

**Mark every field you inferred with `⚠️ verify`.** The user must be able to see at
a glance what you guessed at.

**Never invent:** real numbers the business can claim, case study results,
certifications, awards, years in business, team size, or review counts. If you did
not read it on the site, leave the field as `⚠️ NEEDS INPUT` and ask.

### Step 3 — Interview on the gaps only

Ask about what you could not determine, in small batches of two or three
questions, not one long form. Prioritise in this order, because these are the
fields that most change the output:

1. **Country and language for search data.** Wrong values here silently return
   wrong search volumes in every later skill. If the site does not make the target
   market obvious, always ask.
2. **What the business actually sells, in one sentence.** Websites bury this.
3. **The reader and what they are afraid of.** Drives the entire content angle.
4. **Real proof:** numbers, results, certifications the business can legitimately
   claim.
5. **Competitors,** three domains. Offer your guesses from the SERP if the user
   does not know.
6. **Say / don't say.** Ask directly: "any words or phrases you never want used?"
   This single table does more to stop generic output than anything else in the
   brief.
7. **Author identity and credentials,** for author bios and E-E-A-T.
8. **The CTA and what happens after the click.**

### Step 4 — Confirm and save

Show the completed brief. Ask the user to correct anything marked `⚠️ verify`.
Save the final version as `site-brief.md`.

Then tell them, in these terms:

> Upload `site-brief.md` to this Project's knowledge so every skill can read it
> without you pasting it again. One Project per website.

## Rules

- One file, not two. Business half and Voice half, in that order.
- Plain markdown. No HTML dashboard for this skill: the output is a file the other
  skills read, and a human edits.
- Never leave a field silently blank. Either a real value, `⚠️ verify` for an
  inference, or `⚠️ NEEDS INPUT` for a genuine unknown.
- Do not pad the voice section with adjectives you did not observe. "Warm,
  respectful, capable" only if the copy actually reads that way.

## Output

`site-brief.md` in the working directory.

Tell the user what to do next:

> Next: run `keyword-fanout-map` with a seed keyword or just your business type.
> You will not need to repeat any of the information in this brief again.
