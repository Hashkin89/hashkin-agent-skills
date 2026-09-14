# Verification (local + live)

Verify after each phase and before/after deploy. Prefer DOM/`curl` measurement over
screenshots (the in-app browser pane can blank after programmatic scroll, pitfall #14).

## Table of contents
1. Local server
2. Browser checks (per route)
3. Static/grep checks
4. Live checks (post-deploy)

## 1. Local server
The production SPA routing comes from Netlify `_redirects`, which a plain static
server does not emulate. Use the bundled SPA-fallback server for local review:
```bash
python3 scripts/spa_server.py 8899 /abs/path/to/site   # serves with SPA fallback
# then open http://localhost:8899/  and any route, e.g. /pricing
```
It serves real files and falls back to `index.html` for extensionless routes, so
`/pricing` etc. load on direct hit (JS then renders the route). Note: this returns
200 for unknown routes too (like the naive catch-all) — real 404 behavior is only
testable live on Netlify (§4).

## 2. Browser checks (per route)
Load the site and, for each route, verify via JS (robust) and a screenshot (when the
pane cooperates):
- Route renders: exactly one visible `<h1>`, expected sections visible.
- Head updated: `document.title`, `meta[name=description]`, `link[rel=canonical]`,
  `og:*`/`twitter:*` match the route.
- Schema present: `document.querySelectorAll('script[type="application/ld+json"]')`
  parse without error; FAQ/Service objects match visible content.
- **Console errors: zero.** Check the console after visiting every route.
- Interactions: nav dropdowns open (hover + focus), mobile accordion works, forms
  validate, demo/embeds open.

Example DOM sweep (run in the browser console / JS tool):
```js
['/','/pricing','/contact'].forEach(p=>{ history.pushState({},'',p);
  dispatchEvent(new Event('popstate'));
  const h=[...document.querySelectorAll('h1')].find(e=>e.offsetParent);
  console.log(p, document.title, h && h.textContent.trim().slice(0,40)); });
```

## 3. Static/grep checks (before deploy)
```bash
grep -c '—' index.html app.js blog-data.js          # 0 (no em dashes)
grep -c 'href="#" data-click' index.html            # 0 (all links crawlable)
grep -c 'coming soon' index.html                    # 0 on product copy
# every target=_blank has rel=noopener:
grep -oE '<a [^>]*target="_blank"[^>]*>' index.html | grep -vc 'rel='   # 0
# routes ↔ sitemap ↔ _redirects agree (spot check the route list)
```
Also: JS-handler coverage (every `data-click="X"` has a handler), no duplicate `id`s,
`app.js?v=N` bumped after JS edits.

## 4. Live checks (post-deploy)
After Netlify publishes (static deploys are ~1 min; poll):
```bash
D=https://DOMAIN
# valid routes + static files → 200
for u in / /PRODUCT /USE-CASE /contact /sitemap.xml /assets/favicon.png; do
  echo "$u -> $(curl -s -o /dev/null -w '%{http_code}' $D$u)"; done
# unknown/old URLs → 404 (or 410 for retired)
curl -s -o /dev/null -w '%{http_code}' $D/some-old-or-random-url          # 404
# canonical host chain
curl -sIL $D/../ 2>/dev/null; curl -sI https://www.DOMAIN/ | grep -i '^location'  # www→apex
# fresh title/description in the served HTML (what Google will crawl)
curl -s "$D/?cb=$(date +%s)" | grep -oE '<title>[^<]*</title>|<meta name="description"[^>]*>'
```
Then hand the user the Search Console steps (see `analytics-gsc.md`) and, for link
previews, the LinkedIn/Facebook/X validators.
