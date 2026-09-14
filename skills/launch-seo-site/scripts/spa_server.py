#!/usr/bin/env python3
"""Local static server with SPA fallback, for reviewing a static SPA site.

Serves real files from the site root; for a request that has no file and looks
like a client route (no dot in the last path segment), it falls back to
index.html so client-side routing renders the page on a direct hit / refresh.

Usage:
    python3 spa_server.py [port] [root_dir]
Defaults: port=8899, root_dir=current working directory.

Note: production routing (real 404 for unknown URLs, 410 for retired ones) comes
from Netlify _redirects, NOT this server. This server returns index.html (200)
for unknown routes, like the naive catch-all, so it is for LOCAL REVIEW ONLY.
Test true 404/410 behavior on the deployed Netlify site.
"""
import http.server
import os
import posixpath
import socketserver
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8899
ROOT = os.path.abspath(sys.argv[2]) if len(sys.argv) > 2 else os.getcwd()
os.chdir(ROOT)


class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        raw = self.path.split("?", 1)[0]
        fs_path = self.translate_path(raw)
        missing = not os.path.exists(fs_path) or (
            os.path.isdir(fs_path)
            and not os.path.exists(os.path.join(fs_path, "index.html"))
        )
        # SPA fallback only for extensionless routes (real assets keep 404 if absent)
        if missing and "." not in posixpath.basename(raw):
            self.path = "/index.html"
        return super().do_GET()

    def log_message(self, *args):
        pass


socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving {ROOT} at http://localhost:{PORT}/ (SPA fallback, local review only)")
    httpd.serve_forever()
