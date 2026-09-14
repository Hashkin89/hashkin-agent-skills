#!/usr/bin/env bash
# Scaffold a bare dependency-free static SPA ready for SEO wiring.
# Usage:  bash new-site.sh <target-dir> [domain] [brand]
# Creates: index.html, app.js, robots.txt, sitemap.xml, _redirects,
#          site.webmanifest, 404.html, assets/  (placeholders to fill in).
# After scaffolding, follow SKILL.md phases to add pages, SEO, schema, assets.
set -euo pipefail

DIR="${1:?usage: new-site.sh <target-dir> [domain] [brand]}"
DOMAIN="${2:-example.com}"
BRAND="${3:-Brand}"
mkdir -p "$DIR/assets"
cd "$DIR"

cat > index.html <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${BRAND} | primary keyword phrase</title>
<meta name="description" content="One concrete sentence, 155 chars max.">
<link rel="canonical" href="https://${DOMAIN}/">
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1">
<meta name="theme-color" content="#0b1622">
<link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32.png">
<link rel="apple-touch-icon" sizes="180x180" href="/assets/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
<!-- Open Graph / Twitter: add per seo.md (absolute image URL, 1200x630) -->
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"Organization","name":"${BRAND}","url":"https://${DOMAIN}/"}
</script>
<style>
:root{--brand:#1FD3F0;--ink:#0b1622;--surface-page:#f6f8fa;--text-strong:#0b1622;
--text-muted:#5b6b78;--border-subtle:#e6ebef;--font-display:system-ui,sans-serif;
--font-body:system-ui,sans-serif}
*{box-sizing:border-box}body{margin:0;font-family:var(--font-body);color:var(--text-strong)}
a{color:inherit}[hidden]{display:none!important}
.wrap{max-width:1200px;margin:0 auto;padding:0 24px}
header.site{position:sticky;top:0;background:var(--ink);color:#fff;padding:14px 0}
header .wrap{display:flex;gap:20px;align-items:center}
nav a{color:#fff;text-decoration:none;opacity:.8;font-size:14px}
section{padding:80px 0}.hero{background:var(--ink);color:#fff}
footer.site{background:#08111a;color:rgba(255,255,255,.62);padding:48px 0;font-size:14px}
</style>
</head>
<body>
<div id="app">

<header class="site"><div class="wrap">
  <a href="/" data-click="home" style="font-weight:700;text-decoration:none">${BRAND}</a>
  <nav style="margin-left:auto;display:flex;gap:18px">
    <a href="/pricing" data-click="pricing">Pricing</a>
    <a href="/contact" data-click="contact">Contact</a>
  </nav>
</div></header>

<div data-page="home">
  <section class="hero"><div class="wrap">
    <div style="color:var(--brand);text-transform:uppercase;letter-spacing:.15em;font-size:12px">/ ${BRAND} /</div>
    <h1 style="font-family:var(--font-display);font-size:56px;font-weight:300;margin:16px 0 0">Headline from the spec.</h1>
    <p style="max-width:560px;color:rgba(255,255,255,.72)">Subhead: what it does, for whom.</p>
    <a href="/contact" data-click="contact" style="display:inline-block;margin-top:24px;background:var(--brand);color:#06141d;font-weight:700;padding:14px 26px;border-radius:999px;text-decoration:none">Get started</a>
  </div></section>
</div>

<div data-page="pricing" hidden>
  <section><div class="wrap"><h1>Pricing</h1><p>Fill from spec.</p></div></section>
</div>

<div data-page="contact" hidden>
  <section><div class="wrap"><h1>Contact</h1><p>Fill from spec.</p></div></section>
</div>

<div data-page="404" hidden>
  <section><div class="wrap"><h1>Page not found</h1><p><a href="/" data-click="home">Back home</a></p></div></section>
</div>

<footer class="site"><div class="wrap">
  &copy; ${BRAND}. <a href="/privacy" data-click="privacy">Privacy</a> · <a href="/terms" data-click="terms">Terms</a>
</div></footer>

</div>
<script src="/app.js?v=1"></script>
</body>
</html>
HTML

cat > app.js <<'JS'
/* Dependency-free SPA runtime. Extend routes/titles/descriptions per page.
   See launch-seo-site/references/spa-architecture.md */
(function () {
  'use strict';
  var App = {
    routes: { home:'/', pricing:'/pricing', contact:'/contact', privacy:'/privacy', terms:'/terms' },
    titles: { home:'BRAND | primary keyword', pricing:'Pricing | BRAND', contact:'Contact | BRAND',
              privacy:'Privacy | BRAND', terms:'Terms | BRAND', '404':'Page not found | BRAND' },
    descriptions: { home:'One concrete sentence.', pricing:'Pricing for BRAND.', contact:'Contact BRAND.',
              privacy:'Privacy policy.', terms:'Terms and conditions.', '404':'Page not found.' },
    origin: 'https://DOMAIN',
    pageFromPath: function () {
      var p = (location.pathname || '/').replace(/\/+$/, '') || '/';
      for (var k in this.routes) if (this.routes[k] === p) return k;
      return '404';
    },
    pushRoute: function (page) { var path = this.routes[page] || '/';
      if (location.pathname !== path) { try { history.pushState({}, '', path); } catch (e) {} }
      if (window.gtag) gtag('event','page_view',{page_path:location.pathname,page_title:document.title}); },
    nav: function (page) { var self=this; return function (e){ if(e) e.preventDefault();
      self.setState({page:page}); self.pushRoute(page); window.scrollTo(0,0); }; },
    setMeta: function (a,k,v){ var el=document.head.querySelector('meta['+a+'="'+k+'"]');
      if(!el){el=document.createElement('meta');el.setAttribute(a,k);document.head.appendChild(el);} el.setAttribute('content',v); },
    setLink: function (rel,href){ var el=document.head.querySelector('link[rel="'+rel+'"]');
      if(!el){el=document.createElement('link');el.setAttribute('rel',rel);document.head.appendChild(el);} el.setAttribute('href',href); },
    updateHead: function (st){ var t=this.titles[st.page]||this.titles.home, d=this.descriptions[st.page]||this.descriptions.home,
      url=this.origin+(this.routes[st.page]||'/');
      document.title=t; this.setMeta('name','description',d);
      this.setMeta('property','og:title',t); this.setMeta('property','og:description',d);
      this.setMeta('property','og:url',url); this.setLink('canonical',url);
      this.setMeta('name','robots', st.page==='404' ? 'noindex, nofollow' : 'index, follow'); },
    render: function (){ var st=this.state;
      [].forEach.call(document.querySelectorAll('[data-page]'), function(el){ el.hidden = el.getAttribute('data-page')!==st.page; });
      this.updateHead(st); },
    setState: function (patch){ Object.assign(this.state,patch); this.render(); },
    mount: function (){ var self=this; this.state={page:this.pageFromPath()}; this.render();
      document.addEventListener('click', function(e){ var a=e.target.closest && e.target.closest('[data-click]');
        if(!a) return; var page=a.getAttribute('data-click'); if(self.routes[page]){ self.nav(page)(e); } });
      window.addEventListener('popstate', function(){ self.setState({page:self.pageFromPath()}); window.scrollTo(0,0); }); }
  };
  if (document.readyState==='loading') document.addEventListener('DOMContentLoaded', function(){App.mount();});
  else App.mount();
})();
JS

cat > 404.html <<HTML
<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Page not found | ${BRAND}</title>
<meta name="robots" content="noindex, nofollow">
<style>body{font-family:system-ui,sans-serif;background:#0b1622;color:#fff;display:grid;place-items:center;height:100vh;margin:0;text-align:center}</style>
</head><body><div><h1>Page not found</h1><p><a href="/" style="color:#1FD3F0">Back to ${BRAND}</a></p></div></body></html>
HTML

cat > robots.txt <<TXT
User-agent: *
Allow: /

Sitemap: https://${DOMAIN}/sitemap.xml
TXT

cat > sitemap.xml <<XML
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://${DOMAIN}/</loc><changefreq>weekly</changefreq><priority>1.0</priority></url>
  <url><loc>https://${DOMAIN}/pricing</loc><changefreq>monthly</changefreq><priority>0.8</priority></url>
  <url><loc>https://${DOMAIN}/contact</loc><changefreq>yearly</changefreq><priority>0.6</priority></url>
  <url><loc>https://${DOMAIN}/privacy</loc><changefreq>yearly</changefreq><priority>0.3</priority></url>
  <url><loc>https://${DOMAIN}/terms</loc><changefreq>yearly</changefreq><priority>0.3</priority></url>
</urlset>
XML

cat > _redirects <<'RED'
# Valid SPA routes: 200 (serve index.html). KEEP IN SYNC with routes/sitemap.
/                /index.html   200
/pricing         /index.html   200
/contact         /index.html   200
/privacy         /index.html   200
/terms           /index.html   200
# Everything else = real 404 (avoid soft-404 homepage render).
/*    /404.html   404
RED

cat > site.webmanifest <<JSON
{ "name":"${BRAND}","short_name":"${BRAND}","start_url":"/","display":"standalone",
  "background_color":"#0b1622","theme_color":"#0b1622",
  "icons":[
    {"src":"assets/favicon-32.png","sizes":"32x32","type":"image/png"},
    {"src":"assets/apple-touch-icon.png","sizes":"180x180","type":"image/png"},
    {"src":"assets/favicon.png","sizes":"512x512","type":"image/png"}] }
JSON

echo "Scaffolded ${BRAND} site in $(pwd)"
echo "Next: replace DOMAIN/BRAND placeholders, add pages+content, favicons+og-image, then follow SKILL.md phases."
