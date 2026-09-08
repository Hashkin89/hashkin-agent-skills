---
name: onpage-optimizer
description: Use to audit and optimize a single page's on-page SEO. Detects whether it is a blog post or a service/product page and applies the matching checklist, then rewrites the title tag, meta description, headings and schema. Step 3 of the 5-skill SEO system. Also use for on-page audits, title and meta rewrites, schema fixes, or when asked why a page isn't ranking.
---

# On-Page Optimizer

Step 3 of 5. The point of this skill is that **a blog post and a service page are not
graded on the same things.** Generic on-page checklists are why people optimise a
service page like an article and then wonder why it doesn't convert or rank.

## Before you start

**Read `site-brief.md`.** Several checks are literally unanswerable without it:
"is there an author bio" needs to know who the author should be, and "is this
specific rather than generic" needs the services and locations. If it is missing,
say which checks you will have to skip, or offer to run `site-brief-builder`.

**The DataForSEO connector** is required for live URLs (not for a local draft).

## Input

Either:
- `draft.md` from `seo-content-writer`, or
- a live URL. Pull it with `on_page/instant_pages` for on-page elements and
  `on_page/content_parsing` for the body content. Match the connector tool by
  description rather than assuming an exact name.

## Step 1 — Detect the page type. Do this first.

Decide between **blog / informational** and **service / product** using:

- URL pattern (`/blog/`, `/post/`, dates, versus `/services/`, `/products/`)
- existing schema (Article and BlogPosting versus Service, Product, LocalBusiness)
- intent language (explaining a topic versus selling a specific thing)
- CTA density (one soft CTA at the end versus CTAs throughout)
- presence of price, booking or enquiry elements

State your conclusion and the evidence for it. **If the signals conflict, ask before
proceeding.** Running the wrong branch produces confidently wrong advice, which is
the worst possible output.

Then run **only** the matching branch.

## Branch A — Blog / informational

1. **Topical relevance.** Does the page actually answer the target keyword's intent,
   or drift? Quote the drifting section.
2. **Freshness.** Dates in the copy, stats with a year attached, references to
   superseded tools or versions, "last updated" versus the real last modification.
   Name each stale item specifically.
3. **Internal links.** Count links in and out. Under 2 outbound contextual links or
   0 inbound is a fail, not a warning.
4. **Claims backed by sources.** Every statistic and factual claim should link to a
   high-quality source, inline, on the keyword. Flag unsourced numbers individually:
   these are what stop a page being cited.
5. **Author bio.** Present, named, with credentials, ideally linking to an author
   page. Compare against the author in the brief.
6. **Schema.** Article or BlogPosting, plus FAQPage if there are Q&A sections.
   Valid, and matching what is actually on the page.
7. **Content capsule structure.** Is each H2 a question with a complete two-sentence
   answer directly beneath it? This is the check that decides whether AI engines can
   lift from the page at all. Quote one H2 that passes and one that fails.

## Branch B — Service / product

1. **Schema.** Service, Product or LocalBusiness as appropriate, plus FAQPage.
   Check that NAP in the schema matches the brief's canonical NAP exactly.
2. **Transactional intent satisfied.** Does the page let someone act, or does it read
   like a blog post about the service? Look for: what is included, who it is for,
   how it works, what it costs or how pricing works, how to start.
3. **Specificity.** Would this copy read identically for a competitor in another
   city? If yes, that is a fail. Quote the generic sentences. Check the service and
   the location both appear naturally, not stuffed.
4. **CTA.** Present above the fold, repeated at the end, with one clear action.
   Check it matches the brief's primary CTA and points at the right URL.
5. **Trust signals.** Reviews or testimonials, credentials and certifications from
   the brief, real photos rather than stock, NAP visible.
6. **First fold.** Within one screen: what this is, who it is for, where it is
   offered, and how to start.
7. **Title and meta match intent.** Commercial or transactional phrasing, not
   informational.

## Scoring

Report `passed / total` for the branch you ran, and a score out of 100 weighted by
impact rather than a flat average. Weight schema, capsule structure, specificity and
CTA higher than cosmetic issues, and say which weighting you used in `DATA_NOTES`.

Mark each check `pass`, `warn`, `fail` or `n/a`. Use `n/a` (not `fail`) when
`site-brief.md` was missing the input a check needed, and say so.

## Output

**`03-onpage-report.html`** — fill `templates/onpage-report.html.template` by hand.

- `PAGE_TYPE_LABEL` and `BRANCH_LABEL` reflect the branch you ran.
- `OTHER_TYPE_LABEL` is the branch you did not run, so the user can spot a
  misdetection and re-run.
- Delete the `.fix` span on any check that passed.
- `ROW_STATUS_CLASS` is one of `pass`, `warn`, `fail`, `na`.
- Rewritten title, meta and H1 go in section 05, with character counts.
- Schema to add goes in section 06 as valid JSON-LD.

Every finding must quote the actual page. "Thin content" is useless; "the second H2
answers a different question than it asks, quote: …" is actionable.

## Handing off

> Next: run `internal-link-architect`. It'll crawl the rest of the site and tell you
> exactly which existing pages should link to this one, with the anchor text.
