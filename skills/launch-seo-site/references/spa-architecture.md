# SPA architecture (dependency-free static site)

A fast, cheap, no-build stack: one `index.html`, one vanilla `app.js`, static
assets. No framework, no bundler. Deploys as static files (Netlify). Client-side
routing gives multi-page UX from a single document.

## Table of contents
1. File layout
2. Page model (route → section)
3. app.js runtime (state, routing, head, render)
4. Design tokens
5. Header & mega-menu
6. Footer
7. Adding a new page (checklist)

## 1. File layout
```
index.html          # <head> + all page sections + header/footer, one document
app.js              # vanilla runtime: routing, per-page <head>, in-place binding
blog-data.js        # optional: blog posts as a JS array (window.SITE_BLOG)
robots.txt  sitemap.xml  site.webmanifest  _redirects  404.html
assets/             # logo, favicons, og-image, images, vendored libs
```

## 2. Page model (route → section)
Every page is a top-level block in `index.html`, shown/hidden by the current route:
```html
<div id="app">
  <!-- header here (always visible) -->
  <div data-page="home">        …home sections…        </div>
  <div data-page="pricing">     …pricing sections…     </div>
  <div data-page="contact">     …contact sections…     </div>
  <!-- footer here (always visible) -->
</div>
```
Toggle visibility by route. Two workable approaches:
- **Attribute toggle** (simplest): `app.js` sets `hidden` on all `[data-page]`
  except the current one.
- **Conditional blocks** if you use a tiny template runtime (`data-if`).

All pages coexist in the DOM. That is fine, but it means multiple `<h1>`s exist at
once — keep exactly one visible per route and rely on per-route `<head>` (below)
for SEO.

## 3. app.js runtime
Keep it small and readable. Core pieces:

```js
var App = {
  routes: { home:'/', pricing:'/pricing', contact:'/contact' /* ...one per page */ },
  titles: { home:'Brand | primary keyword phrase', pricing:'Pricing | Brand' /*...*/ },
  descriptions: { home:'…', pricing:'…' /*...*/ },

  pageFromPath: function () {
    var p = (location.pathname || '/').replace(/\/+$/,'') || '/';
    for (var k in this.routes) if (this.routes[k] === p) return k;
    if (/^\/blog\/.+/.test(p)) return 'blog-post';   // dynamic route example
    return '404';                                     // unknown → 404 view (noindex)
  },
  nav: function (page) { var self=this; return function (e){ if(e) e.preventDefault();
    self.setState({ page: page, menuOpen:false }); self.pushRoute(page); scrollTo(0,0); }; },
  pushRoute: function (page) { var path=this.routes[page]||'/';
    if (location.pathname!==path) try{ history.pushState({},'',path); }catch(e){} },

  updateHead: function (st) {
    var t=this.titles[st.page]||this.titles.home, d=this.descriptions[st.page]||this.descriptions.home;
    var path=this.routes[st.page]||'/', url='https://DOMAIN'+path;
    document.title=t;
    this.setMeta('name','description',d);
    this.setMeta('property','og:title',t); this.setMeta('property','og:description',d);
    this.setMeta('property','og:url',url); this.setMeta('name','twitter:title',t);
    this.setMeta('name','twitter:description',d); this.setLink('canonical',url);
  },
  setMeta: function (attr,key,val){ var el=document.head.querySelector('meta['+attr+'="'+key+'"]');
    if(!el){el=document.createElement('meta');el.setAttribute(attr,key);document.head.appendChild(el);} el.setAttribute('content',val); },
  setLink: function (rel,href){ var el=document.head.querySelector('link[rel="'+rel+'"]');
    if(!el){el=document.createElement('link');el.setAttribute('rel',rel);document.head.appendChild(el);} el.setAttribute('href',href); },

  mount: function(){ this.state={page:this.pageFromPath(),menuOpen:false}; this.render();
    window.addEventListener('popstate', function(){ App.setState({page:App.pageFromPath()}); scrollTo(0,0); }); },
  setState: function(patch){ Object.assign(this.state,patch); this.render(); },
  render: function(){ var st=this.state;
    [].forEach.call(document.querySelectorAll('[data-page]'), function(el){ el.hidden = el.getAttribute('data-page')!==st.page; });
    this.updateHead(st);
    /* bind data-click handlers once (event delegation) */ }
};
```
Notes:
- **Event delegation** for `data-click`: one document-level listener maps
  `data-click="pricing"` → `App.nav('pricing')`. Keeps real `href` for crawlers.
- Prefer **in-place DOM updates** over re-rendering innerHTML so CSS animations and
  input focus survive.
- Inject JSON-LD once at mount and/or per route (see `seo.md`).
- Bump `app.js?v=N` in `index.html` after each JS edit (cache-bust, pitfall #15).

## 4. Design tokens
Define brand as CSS variables on `:root` so the whole site is consistent and
theme-able. Example shape:
```css
:root{
  --brand:#1FD3F0; --brand-600:#…; --ink:#0b1622; --surface-page:#f6f8fa;
  --text-strong:#0b1622; --text-muted:#…; --border-subtle:#…;
  --font-display:'…',sans-serif; --font-body:'…',sans-serif; --font-mono:'…',monospace;
}
```
Load fonts from a self-hosted or Google Fonts `<link>`. Section patterns to reuse:
dark hero (`background:var(--ink)`), light content sections, an eyebrow
(`/ SECTION /` uppercase, brand color), H1/H2 in the display font, cards with
`border:1px solid var(--border-subtle)`. Make it responsive with `@media` and
`grid-template-columns:minmax(0,1fr)` collapse on mobile.

## 5. Header & mega-menu
- ≤4 destinations: a flat nav bar.
- >4 destinations: a **mega-menu** grouping links (Solutions / Use cases /
  Resources / …) + primary CTA + a mobile hamburger.
- **Desktop dropdowns with zero JS**: CSS `:hover` + `:focus-within` on a
  `.menu` wrapper reveals a `.panel` positioned `absolute; top:100%`. Add a
  transparent `::before` bridge over the gap so the hover doesn't drop. Make the
  trigger focusable (`tabindex="0"`) for keyboard access.
- **Mobile: native `<details>` accordions** inside the hamburger panel (no JS).
- Every link is a real `href` + `data-click` (crawlable + soft nav).
- The header lives once in the DOM, above `[data-page]` blocks, always visible.

## 6. Footer
Mirror the IA: columns for Solutions, Use cases, Resources, Company + a legal row
(Privacy, Terms, Legal) and © line. Same real-href + data-click rule. Collapses to
one column on mobile via the responsive grid rule.

## 7. Adding a new page (checklist)
1. Add a `<div data-page="X">…</div>` block in `index.html`.
2. Add `X:'/x'` to `routes`, `X:'…'` to `titles` and `descriptions` in `app.js`.
3. Add nav + footer links (real href + data-click), and cross-links from related pages.
4. Add the URL to `sitemap.xml`.
5. Add `/x  /index.html  200` to `_redirects` (pitfall #1).
6. Bump `app.js?v=N`.
7. Verify the route renders, title/canonical update, 0 console errors.
