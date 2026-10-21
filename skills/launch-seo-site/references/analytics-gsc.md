# Google Analytics & Search Console

## Table of contents
1. Google Analytics (gtag)
2. SPA pageviews
3. Cookie / consent notice
4. Search Console: verification
5. Search Console: submit sitemap + request indexing
6. Search Console: Removals (fast de-listing)
7. What only the user can do

## 1. Google Analytics (gtag)
Ask the user for the GA4 Measurement ID (`G-XXXXXXXXXX`). Put this first in `<head>`:
```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){ dataLayer.push(arguments); }
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```
If the user has no GA id yet, tell them to create a GA4 property at analytics.google.com
→ Admin → Data streams → Web → copy the Measurement ID. Do not invent an id.

## 2. SPA pageviews
`gtag('config', …)` counts the initial load. For client-side route changes, send a
pageview on each navigation so GA sees every page. In `app.js` `pushRoute`/`nav`,
after updating the URL:
```js
if (window.gtag) gtag('event','page_view',{ page_path: location.pathname, page_title: document.title });
```
(GA4 "Enhanced measurement" may capture history changes automatically; the explicit
event is the reliable path.)

## 3. Cookie / consent notice
GA sets cookies → show a compact, dismissible notice. Keep it non-blocking and
privacy-preserving (default to essential; let users decline analytics). Minimal
pattern: a fixed bottom card with "We use analytics… Privacy Policy" + Accept/Decline,
storing the choice in `localStorage`; only call `gtag('config', …)` (or set
`gtag('consent','update',{analytics_storage:'granted'})`) after Accept if the
jurisdiction requires prior consent (EU). For a lighter touch outside strict-consent
regions, load GA and offer opt-out. Confirm the user's preference/jurisdiction.

## 4. Search Console: verification
The user must verify the domain (you can't). Recommend **Domain property** (covers
http/https + www/non-www + all paths) via a **DNS TXT record**:
1. search.google.com/search-console → Add property → Domain → enter `DOMAIN`.
2. Copy the `google-site-verification=…` TXT value.
3. Add it as a TXT record at the DNS provider (or Netlify DNS).
4. Click Verify (DNS can take minutes to hours).
Alternative: URL-prefix property via an HTML file or the GA tag (faster but only
covers that exact prefix). Prefer the Domain property.

## 5. Search Console: submit sitemap + request indexing
After verification:
- **Sitemaps** → submit `https://DOMAIN/sitemap.xml`. Resubmit after adding pages.
- **URL Inspection** → paste each key URL → **Request indexing**. Prioritize: home
  first (refreshes the title/description in results), then the money/product pages.
- Prepare a copy-paste list of URLs to request. Indexing then takes ~1-3 days for
  requested URLs, longer for the rest. "Discovered/crawled – not indexed" that
  persists >3 weeks → see pitfall #5 (prerendering).

## 6. Search Console: Removals (fast de-listing)
To make stale/old URLs disappear from results within hours (vs waiting for re-crawl):
- **Removals → New request → Temporarily remove URL** for each obsolete URL. Use
  "Remove all URLs with this prefix" to clear a whole old section (e.g. `/services/`).
- This only hides them (~6 months). Pair with a real `410`/`404` (see
  `deploy-netlify.md`) so they drop permanently on re-crawl.
- Removals hides bad URLs but does NOT refresh the main result's title/description —
  that needs Request Indexing on the page itself (pitfall #3).

## 7. What only the user can do
You cannot log into Google, verify domains, or click in Search Console. Your job:
wire the site correctly (GA tag, sitemap, robots, schema, redirects) and hand the
user an exact, ordered checklist with the precise URLs and TXT value to paste.
Set expectations honestly: the SERP updates on Google's schedule; site changes never
force it instantly, but Request Indexing + Removals cut weeks to days.
