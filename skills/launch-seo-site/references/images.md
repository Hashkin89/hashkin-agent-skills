# Images & assets (macOS, no ImageMagick)

Optimize and generate assets using tools present on macOS: `sips` (resize/convert)
and `qlmanage` (rasterize SVG/preview). No `rsvg-convert`, `cairosvg`, `inkscape`,
or `imagemagick` assumed. Verify a tool exists before relying on it.

## Table of contents
1. Favicons
2. OG share image (1200×630)
3. General image optimization
4. Lazy-loading & rel=noopener
5. Vendoring heavy libraries

## 1. Favicons
From a square source logo (≥512px, ideally on transparent or brand bg):
```bash
cd assets
sips -s format png "logo-source.png" --out favicon.png -Z 512   >/dev/null
sips -Z 180 favicon.png --out apple-touch-icon.png              >/dev/null
sips -Z 32  favicon.png --out favicon-32.png                    >/dev/null
```
Reference them in `<head>` (see `seo.md` §2) and in `site.webmanifest`:
```json
{ "name":"Brand","short_name":"Brand","description":"…","start_url":"/",
  "display":"standalone","background_color":"#0b1622","theme_color":"#0b1622",
  "icons":[
    {"src":"assets/favicon-32.png","sizes":"32x32","type":"image/png"},
    {"src":"assets/apple-touch-icon.png","sizes":"180x180","type":"image/png"},
    {"src":"assets/favicon.png","sizes":"512x512","type":"image/png"}] }
```

## 2. OG share image (1200×630)
The link-preview image. Must be exactly 1200×630, with the key text/logo safely
inside a center band (previews crop edges).

- **If you have a 1200×630 PNG/JPG already**: just place it at `assets/og-image.png`.
- **Generating from SVG on macOS** (workaround, since qlmanage pads to a square and
  top-aligns): author the SVG as **1200×1200** with all content in the vertical
  center band (wrap content in `<g transform="translate(0,285)">`), rasterize, then
  center-crop to 630 tall:
```bash
qlmanage -t -s 1200 -o . og-src.svg           # → og-src.svg.png (1200x1200, padded)
sips -c 630 1200 og-src.svg.png --out og-image.png   # center-crop to 1200x630
```
  (`sips -c H W` crops to height H, width W, centered.) Verify final dims:
  `sips -g pixelWidth -g pixelHeight og-image.png`. Keep text ~54px+ and away from
  the right edge so nothing clips. Design: brand bg + wordmark + one-line value prop.

## 3. General image optimization
- Downscale oversized images: `sips -Z 2000 big.jpg` (longest side 2000), or
  `sips -Z 760 illustration.png` for an inline illustration shown ~400px (2× retina).
- Keep PNG for transparency (illustrations that sit on a colored section); JPEG for
  photos. `sips` cannot quantize PNGs, so **resizing** is the main PNG lever; a
  760px transparent PNG is usually plenty.
- Check size after: `wc -c < file`. Target: hero/illustration < ~400KB, most images
  much less. Rename to URL-safe names (no spaces): `arbitrator-illustration.png`,
  not `My Illustration (1).png`. Remove the heavy original after creating the web copy.
- Confirm alpha when it matters: `sips -g hasAlpha file.png | tail -1`.

## 4. Lazy-loading & rel=noopener
- Below-the-fold images: `loading="lazy"` + explicit `width`/`max-width` + `height:auto`.
- Every `target="_blank"` link needs `rel="noopener"`. Pre-deploy sweep: add
  `rel="noopener"` to any `<a … target="_blank" …>` without a `rel`.

## 5. Vendoring heavy libraries
If a page needs a heavy lib (WebGL/three.js globe, chart lib, map data):
- Vendor the minified UMD build locally under `assets/` (pin the version) and any
  data it needs (e.g. a land GeoJSON), rather than fetching from a third-party CDN
  at runtime (fragile in prod).
- Load it only where needed: lazy-load via dynamic `<script>` injection on first
  interaction, or an IntersectionObserver when the element nears the viewport.
- Provide a static fallback if WebGL/the lib is unavailable.
- Keep it off other routes so the rest of the site stays light.
