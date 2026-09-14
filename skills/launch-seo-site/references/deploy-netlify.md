# Deploy on Netlify

Static site, no build. Netlify serves files as-is + applies `_redirects`. Deploy is
usually via a Git repo connected to Netlify (push to `main` → auto-publish).

## Table of contents
1. `_redirects` (the critical file)
2. Why not the naive SPA catch-all
3. Domain canonicalization (www/http)
4. Netlify Forms (contact)
5. Custom 404 page
6. Git push (multi-account)
7. Post-deploy verification

## 1. `_redirects` (the critical file)
Enumerate valid routes → 200, retired paths → 410, everything else → real 404.
```
# Retired URLs (old CMS): 410 Gone (strong "permanently removed" signal)
/demo               /404.html   410
/services/*         /404.html   410
/wp-admin/*         /404.html   410
/category/*         /404.html   410

# Valid SPA routes: serve index.html (200) so client routing works on direct hits.
# KEEP IN SYNC when adding/removing pages.
/                        /index.html   200
/PRODUCT                 /index.html   200
/USE-CASE                /index.html   200
/blog                    /index.html   200
/blog/*                  /index.html   200
/contact                 /index.html   200
/privacy                 /index.html   200
/terms                   /index.html   200

# Everything else = real 404 (not a soft-404 homepage render).
/*    /404.html   404
```
Notes:
- Existing static files (assets, `sitemap.xml`, `robots.txt`, `site.webmanifest`,
  favicons) are served directly by Netlify and are NOT affected by these rules.
- `/blog/*` (wildcard) covers dynamic blog-post routes with a single 200 rule.
- Order matters top-to-bottom; specific 410s before the 200 routes before the 404.

## 2. Why not the naive SPA catch-all
`/* /index.html 200` alone returns the homepage (200) for every path, including old
and garbage URLs → soft-404s that Google keeps indexed (pitfall #1). The enumerated
list above fixes it site-wide with no per-URL whack-a-mole.

## 3. Domain canonicalization (www/http)
Pick one canonical host (usually the apex `DOMAIN`). Ensure:
- `http://…` → `https://…` (Netlify does this automatically with HTTPS enabled).
- `www.DOMAIN` → `DOMAIN` (301). Configure in Netlify Domain settings (set the apex
  as primary; www redirects automatically), or add a redirect. Canonical tags,
  sitemap, and OG URLs all use the apex.
- Verify the full chain: `www` deep URL → 301 to apex → then the route's status.

## 4. Netlify Forms (contact)
If a contact form is needed without a backend:
- Add `data-netlify="true"` and a hidden `form-name` input; include a honeypot field.
- Netlify detects forms **at deploy build time** from the served HTML, so the form
  must exist in the deployed HTML (not injected only by JS) — include a static form,
  or a hidden static copy Netlify can parse. Submit via AJAX `POST` to `/` with
  `new URLSearchParams(new FormData(form))`.
- After first deploy: enable form detection + a notification email in Netlify UI,
  then redeploy. Test a real submission.
- Validate inputs client-side (e.g. phone: strip to digits + a single leading `+`).

## 5. Custom 404 page
`404.html` at root: a real page with `<meta name="robots" content="noindex, nofollow">`,
a short "page not found" message, and a link home. It is the target for both the
`404` catch-all and the `410` rules. Keep its title `Page not found | Brand` (no em dash).

## 6. Git push (multi-account)
- If the machine has multiple GitHub accounts (via `gh` CLI credential helper),
  select the right one before pushing: `gh auth status`, then
  `gh auth switch --user <account>`; otherwise a private repo returns the misleading
  `Repository not found` (pitfall #7).
- Commit only site files; exclude local/working files (`.DS_Store`,
  `.claude/settings.local.json`, internal reports, briefs).
- End commit messages with the required trailer:
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`.
- Push to `main` (or the branch Netlify builds). A sandboxed shell may lack keychain
  access → push from a context that has it, or have the user push (pitfall #8).

## 7. Post-deploy verification
See `verification.md` §live. At minimum, after the deploy publishes:
```bash
for u in / /PRODUCT /contact; do echo "$u -> $(curl -s -o /dev/null -w '%{http_code}' https://DOMAIN$u)"; done   # 200
curl -s -o /dev/null -w '%{http_code}' https://DOMAIN/some-old-url        # expect 404
curl -s -o /dev/null -w '%{http_code}' https://DOMAIN/sitemap.xml         # 200
curl -s https://DOMAIN/ | grep -oE '<title>[^<]*</title>'                 # new title
```
