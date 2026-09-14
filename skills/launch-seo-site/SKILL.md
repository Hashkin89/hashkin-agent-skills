---
name: launch-seo-site
description: >-
  Launch a production-ready marketing/product website from a written spec, wired
  end to end for SEO and GEO (AI-search visibility): dependency-free static SPA,
  design tokens, per-page meta + JSON-LD schema, sitemap/robots, Open Graph +
  favicons, Google Analytics, Google Search Console, and a Netlify deploy with
  correct 200/404/410 routing. Use when the user says "build/launch/ship a
  website (from this spec/brief)", "make a landing/marketing site", "a site
  ready for SEO/referencing/Google", or asks to set up analytics + Search
  Console + sitemap for a new site. Also use to add SEO/GEO, per-page meta,
  schema, sitemap, redirects, or fix soft-404s on an existing static site.
argument-hint: [path-to-spec-or-one-line-brief]
---

# Launch an SEO/GEO-ready website from a spec

Turn a project description into a live, referenceable website. This skill encodes
a full, battle-tested workflow (including the pitfalls that cost real time) so
another Claude can ship a clean site without rediscovering them.

## Operating principles (read first)

- **Ship only what is real.** Never advertise a feature that is not live. No
  "coming soon" badges — describe the actual capability, or use a "talk to us"
  CTA to market-test an idea (framed as a solution, not a shipped product).
- **Facts must be defensible.** No unsubstantiated superlatives; describe
  competitors accurately (e.g. a licensed escrow holds funds in regulated trust
  accounts, not "its own account").
- **House style: never use em dashes (`—`)** in any copy. Rewrite with a comma,
  colon, period, or parentheses. Grep for `—` before every deploy.
- **`index.html` is the source of truth**, not any design-tool export. If a spec
  came from a design tool, transpile once, then hand-edit `index.html`/`app.js`
  directly and never re-transpile over hand edits.
- **Verify, do not assume.** After each phase, check in a browser (console
  errors, rendered content) and, post-deploy, with `curl` on the live URLs.
- Ask the user only for what you cannot decide or discover (brand assets, real
  metrics/claims, domain, GA id, which provider names may be cited).

## Workflow

Run phases in order. Each links a reference file — read it when you start that
phase. **Read `references/pitfalls.md` before Phase 1** and keep it in mind; it is
the highest-value file here.

### Phase 0 — Intake & plan
1. Read the spec (`$ARGUMENTS` may be a path or a one-line brief; if a path, read it).
2. Extract: product, audience (B2B/B2C), primary value prop, the real features
   that ship today, pages needed, brand (name, colors, logo, fonts), domain,
   legal entity + address (for schema NAP), socials, GA id, whether it deploys
   to Netlify.
3. Derive the **information architecture**: home + one page per real
   product/solution + use-case pages + resources (docs/blog) + legal
   (privacy/terms) + contact. One deep page per keyword cluster beats one page
   trying to rank for everything.
4. Present a brief plan (IA tree + stack) and get explicit approval before building.

### Phase 1 — Architecture & scaffold
Read `references/spa-architecture.md`. Build a **dependency-free static SPA**:
`index.html` (all pages as `<section>` blocks toggled by route) + a small vanilla
`app.js` runtime (history-API routing, per-page `<title>`/meta via `titles`/
`descriptions` maps, in-place DOM binding). Set up design tokens (CSS variables:
brand colors, fonts, surfaces), responsive layout, and a header (mega-menu if the
site has >4 destinations) + footer that mirror the IA. `scripts/new-site.sh`
scaffolds the bare skeleton.

### Phase 2 — Content & pages
Write each page from the spec, matching one design language (hero eyebrow + H1 +
subhead + CTAs, consistent section patterns). Cross-link pages (home cards → deep
pages; deep pages → related pages). Keep copy concrete and benefit-led.

### Phase 3 — SEO
Read `references/seo.md`. Per-page title/description/canonical (static defaults in
`<head>` + JS updates per route), Open Graph + Twitter tags, JSON-LD
(`Organization` with NAP, `Service`/`Product`, `FAQPage`, `BreadcrumbList`),
`sitemap.xml`, `robots.txt`, crawlable real `href`s on every nav/link (never
`href="#"`), contextual internal links.

### Phase 4 — GEO (AI-search visibility)
Read `references/geo.md`. Structure content so ChatGPT/Perplexity/Google-AI can
cite it: one consolidated page per answerable query (facts stated together, not
split across pages), FAQ with direct answers, `llms.txt`, quotable claims with
sources.

### Phase 5 — Analytics & Search Console
Read `references/analytics-gsc.md`. Add Google Analytics (gtag) with a compact
cookie notice; prepare Google Search Console (domain verification, sitemap
submission, request-indexing, Removals tool). The user performs the GSC clicks
(no API access) — give exact steps + the URL list.

### Phase 6 — Images & assets
Read `references/images.md`. Favicons (32/180/512 + manifest), a 1200×630
`og-image`, optimized/lazy-loaded images (macOS `sips`/`qlmanage` workflow,
no ImageMagick needed), `rel="noopener"` on every `target="_blank"`.

### Phase 7 — Deploy (Netlify)
Read `references/deploy-netlify.md`. `_redirects` with **valid SPA routes → 200,
everything else → real 404** (avoid the soft-404 trap), `410` for retired URLs,
www→apex and http→https canonicalization, Netlify Forms if a contact form is
needed. Commit + push (mind multi-account git — see pitfalls).

### Phase 8 — Verify (local + live)
Read `references/verification.md`. Run `scripts/spa_server.py`, check every route
+ console in the browser, then after deploy `curl` the live URLs for correct
status codes, titles, sitemap, and that old/unknown URLs return 404.

## Reference map

| File | Read when |
| --- | --- |
| `references/pitfalls.md` | **First**, and whenever something behaves oddly |
| `references/spa-architecture.md` | Phase 1 (scaffold, routing, mega-menu, tokens) |
| `references/seo.md` | Phase 3 (meta, schema, sitemap, robots) |
| `references/geo.md` | Phase 4 (AI-search visibility) |
| `references/analytics-gsc.md` | Phase 5 (GA + Search Console) |
| `references/images.md` | Phase 6 (favicons, og-image, optimization) |
| `references/deploy-netlify.md` | Phase 7 (redirects, canonicalization, forms) |
| `references/verification.md` | Phase 8 (local + live checks) |

## Scripts

- `scripts/spa_server.py` — local static server with SPA fallback (serves real
  files, falls back to `index.html` for extensionless routes). Local review only;
  production routing is Netlify `_redirects`.
- `scripts/new-site.sh` — scaffold a bare site (index.html shell, app.js runtime
  stub, robots.txt, sitemap.xml, _redirects, site.webmanifest, 404.html).

## Definition of done
- All routes render with correct per-page title/meta/canonical; 0 console errors.
- Sitemap + robots live; schema validates; OG image renders in a link preview.
- Unknown/old URLs return 404 (or 410); valid routes and static files return 200.
- GA firing; GSC steps handed to the user; no em dashes; only-real-features copy.
