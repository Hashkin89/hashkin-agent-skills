# Pitfalls & fixes (read first)

Real problems hit while shipping a static SPA marketing site, and the fix for each.
Skim all of these before building; they are cheap to prevent, expensive to debug.

## Table of contents
1. Soft-404: SPA catch-all makes every URL return 200
2. Retired/old-CMS URLs stay indexed
3. GSC "indexed" vs live "test the URL" (stale index reads)
4. Per-page SEO in a JS SPA (title/meta/canonical duplication)
5. JS-rendered content may index slowly → prerendering escalation
6. Design-tool re-export overwrites hand edits
7. Multi-account git/GitHub push ("Repository not found")
8. Sandboxed git can't reach the private repo / keychain
9. Em dashes in copy
10. Marketing unshipped features / "coming soon"
11. Factual/competitor accuracy
12. `href="#"` links are not crawlable
13. `target="_blank"` without `rel="noopener"`
14. Screenshot pane blanks after programmatic scroll
15. Cache-busting JS/CSS after edits
16. Heavy third-party libs and demos (lazy-load)
17. Cookie/consent + analytics

---

## 1. Soft-404: SPA catch-all makes every URL return 200
An SPA needs unknown-to-server paths (e.g. `/pricing`) to return `index.html` so
client routing can render them. The naive `/* /index.html 200` catch-all makes
**every** path (including `/random-old-url`) return 200 + the homepage → Google
sees infinite soft-404 duplicates of home and keeps old URLs indexed.

**Fix:** enumerate valid routes explicitly as `200` rewrites, and send everything
else to a real `404`. See `deploy-netlify.md` for the full `_redirects`. Keep the
route list in sync when adding pages.

## 2. Retired/old-CMS URLs stay indexed
Migrating from WordPress/Wix/etc.: Google still shows old URLs
(`/services/x`, `/wp-*`, `/category/*`) as sitelinks. If they resolve to 200 (via
the soft-404 trap) Google never drops them.

**Fix:** `410 Gone` for known old paths (stronger signal than 404), plus the
real-404 catch-all for the rest (fix #1). Then in Search Console use the
**Removals** tool to hide them within hours. They drop permanently on re-crawl.

## 3. GSC "indexed" vs live "test the URL"
URL Inspection shows the **last crawled state** (an old snapshot), not the current
server response. A URL can show "indexed" while the server already returns 301→410.
This confuses users into thinking a fix didn't work.

**Fix:** tell the user to click **"Test live URL"** — it fetches fresh and shows
the real 404/redirect. The SERP itself (title, description, sitelinks) updates only
after Google re-crawls (days to weeks); nothing site-side forces it instantly.
Accelerate with "Request indexing" (home + money pages) + Removals. Private
browsing does NOT change the SERP — it is Google's server-side index, identical
for everyone; a stale SERP is never a local cache issue.

## 4. Per-page SEO in a JS SPA (duplication risk)
All routes serve the same `index.html` whose static `<head>` has the HOME
title/description/canonical/OG. If per-page values are only set by JS, a crawler
that under-processes JS sees every page as a home duplicate.

**Fix:** keep a `titles`/`descriptions`/canonical map in `app.js` and update the
head on every route change (`document.title`, `<meta name=description>`, og:*,
twitter:*, `<link rel=canonical>`). Also inject page-appropriate JSON-LD. This is
enough for Google (it renders JS). If pages still don't index after ~3 weeks,
escalate to #5.

## 5. JS-rendered content indexes slowly → prerendering
"Discovered / crawled – currently not indexed" that persists = Google is slow to
render JS for a low-authority new site.

**Fix (escalation):** prerender static per-route HTML (each file has the correct
title/meta/canonical AND the visible content baked in) so direct crawls get real
HTML. Options: a small build script that renders each route to `/<route>/index.html`,
Netlify's prerender/`@netlify/plugin`, or Prerender.io. Do this only if #4 + Request
Indexing haven't worked; do not pre-build it.

## 6. Design-tool re-export overwrites hand edits
If `index.html` was transpiled from a design tool once, re-running the transpile
later silently reverts every hand edit (links, fixes, SEO). Symptoms: fixes you
made "come back" wrong after someone else's session.

**Fix:** declare `index.html`/`app.js` the source of truth; do not re-transpile.
If the design must change, edit the HTML directly (or re-apply hand edits after any
transpile). Grep for regressions after any suspected re-export.

## 7. Multi-account git/GitHub push ("Repository not found")
A machine can have several GitHub accounts. Pushing while the wrong one is active
gives a misleading `remote: Repository not found` (GitHub returns 404 for a private
repo the authenticated account can't access — it is an AUTH problem, not a missing
repo).

**Fix:** with `gh` CLI as credential helper, `gh auth status` to see accounts, then
`gh auth switch --user <org-account>` before pushing. Record the repo→account
mapping so it is not rediscovered each time.

## 8. Sandboxed git can't reach the private repo / keychain
A sandboxed/non-interactive shell often can't read the macOS keychain, so pushes
fail even outside the sandbox helper. `git config user.email` may be empty there,
producing commits authored `user@host.local`.

**Fix:** run the push from a context with keychain access (dangerously-disable-sandbox
if the harness allows, or have the user push from their terminal). If a commit got a
placeholder author and it matters, `git commit --amend --author="Name <email>"`.

## 9. Em dashes in copy
Users often ban em dashes (`—`) as an "AI tell". They creep in via generated copy
and default titles (`Brand — Tagline`).

**Fix:** never emit `—`. Titles use ` | ` as separator; body uses commas/colons/
periods. Before every deploy: `grep -c '—' index.html app.js blog-data.js` must be 0.

## 10. Marketing unshipped features / "coming soon"
Do not label things "coming soon" or imply a feature exists when it doesn't. It
erodes trust and creates dead ends.

**Fix:** describe only shipped capabilities. To test appetite for an idea, build a
page that describes the **solution** (present tense, benefit-led) with a "talk to
us" CTA — never a "live product" claim and never "coming soon".

## 11. Factual/competitor accuracy
A wrong claim about a competitor is a legal/credibility risk. Example: writing a
licensed escrow "holds funds in its own account" (implies commingling) when it uses
segregated regulated trust accounts.

**Fix:** state the accurate, defensible differentiator; avoid unverifiable
superlatives. When unsure of a real detail (a provider name, a number), ask or stay
generic ("via regulated providers").

## 12. `href="#"` links are not crawlable
SPA nav often uses `<a href="#" data-click="...">`. Crawlers see no destination and
the internal-link graph is invisible → weak SEO.

**Fix:** every nav/card/footer link gets a real `href="/route"` AND keeps its
`data-click` handler (the handler calls `preventDefault` for soft nav). Dynamic
links (blog cards) bind `href="/blog/<slug>"`.

## 13. `target="_blank"` without `rel="noopener"`
Reverse-tabnabbing risk (and minor perf). Easy to miss across many external links.

**Fix:** every `target="_blank"` gets `rel="noopener"`. Sweep before deploy:
add `rel="noopener"` to any `<a ... target="_blank" ...>` lacking a `rel`.

## 14. Screenshot pane blanks after programmatic scroll
The in-app browser often returns a blank screenshot right after a JS
`scrollIntoView`/`window.scrollTo`.

**Fix:** verify via DOM/JS measurement (`getBoundingClientRect`, `getComputedStyle`,
element text) instead of screenshots; or nudge with a real wheel `scroll` then
screenshot. Do not trust a blank frame as "broken".

## 15. Cache-busting JS/CSS after edits
Browsers cache `app.js`/`globe.js`. After editing, the old file may load.

**Fix:** version the query string (`app.js?v=N`) and bump `N` on every JS change.
Static HTML is served fresh by Netlify, so no version needed on `index.html` itself.

## 16. Heavy third-party libs and demos (lazy-load)
A dependency-free site can still need a heavy lib (e.g. a WebGL globe via three.js,
or a demo SDK). Loading it eagerly hurts the whole site.

**Fix:** vendor the lib locally, load it only on the page/first-interaction that
needs it (dynamic `<script>` injection on first click, or an IntersectionObserver),
and provide a graceful fallback if it fails. For embed widgets (e.g. Supademo popup),
lazy-load the SDK on the first CTA click and fall back to opening the URL in a tab.

## 17. Cookie/consent + analytics
Analytics that sets cookies needs a notice. Keep it lightweight; do not block render.

**Fix:** gtag + a compact, dismissible cookie notice (see `analytics-gsc.md`).
Prefer privacy-preserving defaults.
