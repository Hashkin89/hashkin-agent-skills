# GEO — Generative Engine Optimization (AI-search visibility)

Getting cited by ChatGPT, Perplexity, Google AI Overviews, Gemini. Different from
classic SEO: AI engines synthesize answers and cite pages that state a complete,
quotable answer in one place. This complements `seo.md`, it does not replace it.

## Table of contents
1. The core principle
2. Page structure for citeability
3. Content patterns that get quoted
4. llms.txt
5. Technical enablers
6. Measuring & closing gaps

## 1. The core principle
AI engines cite the page that **answers the query completely, in one place, in
plain language, with the key facts stated together**. The #1 reason a site is NOT
cited while competitors are: the facts exist but are **split across pages**. Fix by
consolidating each answerable question onto one purpose-built page.

## 2. Page structure for citeability
- **One page per answerable query / intent.** If "does X support USDC for M&A" is a
  target, one page must state (product) + (USDC) + (M&A) together, not spread across
  three pages.
- Lead each section with a **direct, self-contained answer sentence**, then expand.
  AI extracts the first clear sentence.
- Use clear H2/H3 that mirror real questions ("What is an escrow service?",
  "How much does it cost?").
- Include a **comparison** where relevant (you vs the named alternatives), stated
  factually — engines love comparison tables and quote them.
- Keep entities explicit and repeated (product name, category noun) so the model
  binds facts to your brand, not a generic term.

## 3. Content patterns that get quoted
- **FAQ with direct answers** (also emit FAQPage schema, see `seo.md`).
- **Definitional openers**: "An X is …" / "X does Y by …" — quotable definitions.
- **Numbers with sources**: "settles in seconds, 24/7" / "enforceable in 170+
  countries under the New York Convention" — cite the source inline; unsourced
  numbers read as marketing and are trusted less.
- **Plain language over jargon.** Short sentences. One claim per sentence.
- Accuracy is non-negotiable (pitfall #11): a hallucinated or overclaimed fact can
  get you cited wrongly or not at all.

## 4. llms.txt
Publish `/llms.txt` (plain text/Markdown) at the site root: a concise, structured
map of the site for LLMs — what the product is, key pages with one-line summaries,
and canonical facts. Example shape:
```
# Brand
> One-sentence description of the product and who it is for.

## Products
- [Product A](https://DOMAIN/product-a): one line.
- [Product B](https://DOMAIN/product-b): one line.

## Key facts
- Fact 1 (with source).
- Fact 2.

## Contact
contact@DOMAIN
```
It is a lightweight, emerging convention; cheap to add, and it centralizes the facts
you want models to repeat.

## 5. Technical enablers
- **Content must be crawlable without heavy JS gymnastics.** If AI crawlers under-
  render JS (many do), a JS-only SPA hurts GEO more than SEO. If citeability
  matters and pages are JS-rendered, prefer prerendered per-route HTML
  (see pitfall #5) so the answer text is in the raw HTML.
- Fast, mobile-friendly, HTTPS, valid schema — same hygiene as SEO.
- Do not block AI user-agents in robots.txt unless the user explicitly wants to.

## 6. Measuring & closing gaps
- After the site is live and indexed (allow a few weeks), check whether the brand
  is cited for its target queries on ChatGPT and Perplexity, and who is cited
  instead. Tools/skills for this exist (an "AI visibility" checker); if one is
  available, run it, otherwise spot-check manually by asking the target questions.
- Output = a **gap list**: queries a competitor wins and you don't, ranked by
  winnability. Each gap → either a new consolidated page or an addition to an
  existing one that states the missing facts together.
- Re-measure periodically; AI indexes lag (weeks), so change → wait → re-check.
