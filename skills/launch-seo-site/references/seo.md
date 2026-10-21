# SEO setup

Everything to make the site indexable and rank-ready. Pair with `geo.md` for AI
search. Replace `DOMAIN`, `Brand`, entity details with real values.

## Table of contents
1. Per-page title & meta description
2. Static `<head>` block (home defaults)
3. Open Graph & Twitter
4. Canonical + robots meta
5. JSON-LD structured data
6. sitemap.xml
7. robots.txt
8. Crawlable links & internal linking
9. Pre-deploy SEO checklist

## 1. Per-page title & meta description
- **Title**: put the searched keyword first, brand last, separated by ` | ` (never
  `—`). ≤ ~60 chars. The homepage title should target real search terms, not an
  unsearched brand tagline (a tagline can live in the hero/eyebrow instead).
- **Description**: ≤ 155 chars, one sentence, concrete. Unique per page.
- Set both statically in `<head>` (home values) AND update per route in `app.js`
  via the `titles`/`descriptions` maps (see `spa-architecture.md` §3). Keep the
  `app.js` home entries identical to the static `<head>` so JS doesn't overwrite
  with stale text (pitfall #4).

## 2. Static `<head>` block (home defaults)
```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Primary keyword phrase | Brand</title>
<meta name="description" content="One concrete sentence, ≤155 chars.">
<link rel="canonical" href="https://DOMAIN/">
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1">
<meta name="theme-color" content="#0b1622">
<link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32.png">
<link rel="icon" type="image/png" sizes="512x512" href="/assets/favicon.png">
<link rel="apple-touch-icon" sizes="180x180" href="/assets/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
```
(Author/keywords meta are optional and low-value; skip unless asked.)

## 3. Open Graph & Twitter
```html
<meta property="og:type" content="website">
<meta property="og:site_name" content="Brand">
<meta property="og:title" content="…">
<meta property="og:description" content="…">
<meta property="og:url" content="https://DOMAIN/">
<meta property="og:image" content="https://DOMAIN/assets/og-image.png">
<meta property="og:image:secure_url" content="https://DOMAIN/assets/og-image.png">
<meta property="og:image:type" content="image/png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Brand, one-line value prop.">
<meta property="og:locale" content="en_US">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="…">
<meta name="twitter:description" content="…">
<meta name="twitter:image" content="https://DOMAIN/assets/og-image.png">
<meta name="twitter:image:alt" content="Brand, one-line value prop.">
```
`og:url`, `og:image` etc. must be ABSOLUTE (`https://DOMAIN/…`) → previews only work
once the domain is live. Update og:title/description/url per route in `app.js` too.
Test previews after deploy: LinkedIn Post Inspector, Facebook Sharing Debugger,
X Card Validator (force a re-scrape; they cache).

## 4. Canonical + robots meta
- Canonical points to the page's own absolute URL; update per route in JS.
- The `404` view must set `<meta name="robots" content="noindex, nofollow">`.
- Do not `noindex` real pages.

## 5. JSON-LD structured data
Inject `<script type="application/ld+json">` blocks. Single source of truth: build
FAQ/Service objects from the same JS data that renders the visible content so they
never drift. Core types:

- **Organization** (site-wide, in static `<head>`):
```json
{"@context":"https://schema.org","@type":"Organization","name":"Brand",
 "legalName":"Legal Entity","url":"https://DOMAIN/","logo":"https://DOMAIN/assets/favicon.png",
 "image":"https://DOMAIN/assets/og-image.png","description":"…","email":"contact@DOMAIN",
 "vatID":"…","foundingDate":"YYYY","foundingLocation":"Country",
 "address":{"@type":"PostalAddress","streetAddress":"…","postalCode":"…","addressLocality":"…","addressCountry":"XX"},
 "sameAs":["https://linkedin.com/company/…","https://…"]}
```
- **Service** or **Product** (on each product/solution page): `serviceType`, `name`,
  `provider` (Organization), `areaServed`, `url` (the page), `description`, `offers`.
- **FAQPage** (on pages with a real FAQ): `mainEntity` = array of
  `{@type:Question, name, acceptedAnswer:{@type:Answer,text}}`. Must match visible Q&A.
- **BlogPosting** (blog posts): headline, description, image, datePublished, author.
- **BreadcrumbList** (deep pages): optional, helps sitelinks.

Inject via `app.js` (works because Google renders JS) and/or statically. Validate
with Google Rich Results Test after deploy.

## 6. sitemap.xml
List every indexable route (not the 404/dormant pages). Priorities: home 1.0,
money/product pages 0.9, use-case 0.8, docs/blog 0.7, blog posts 0.5-0.6, legal 0.3.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://DOMAIN/</loc><changefreq>weekly</changefreq><priority>1.0</priority></url>
  <url><loc>https://DOMAIN/PRODUCT</loc><changefreq>monthly</changefreq><priority>0.9</priority></url>
  <!-- one <url> per route -->
</urlset>
```
Keep it in sync when adding/removing pages. Reference it from robots.txt and submit
it in Search Console.

## 7. robots.txt
```
User-agent: *
Allow: /

Sitemap: https://DOMAIN/sitemap.xml
```
Do not disallow assets (CSS/JS/images) — Google needs them to render.

## 8. Crawlable links & internal linking
- Every nav/card/footer link: real `href="/route"` (+ `data-click` for soft nav).
  Never `href="#"` (pitfall #12).
- Home should link to every important deep page (nav + hero/section cards +
  footer). Deep pages should cross-link to related pages with descriptive anchor
  text (e.g. "See programmable escrow →").
- A mega-menu is the single biggest internal-linking win: it puts keyword-anchored
  links to every page on every page.

## 9. Pre-deploy SEO checklist
- [ ] Unique title + description per route; home title is keyword-first.
- [ ] Canonical, OG, Twitter update per route; images are absolute URLs.
- [ ] Organization + per-page Service/FAQ schema present and matches content.
- [ ] sitemap.xml lists all routes; robots.txt references it.
- [ ] No `href="#"`; internal links + mega-menu wired.
- [ ] `grep -c '—'` = 0 (no em dashes).
- [ ] 404 view is noindex.
