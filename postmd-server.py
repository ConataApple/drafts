#!/usr/bin/env python3
# postmd 保存助手：在你 Mac 本地跑一个小服务，
# 让 postmd.html 的「保存」按钮能把 .md 直接写进 content/posts/。
# 用法：双击「postmd-启动.command」即可（它会启动本脚本并打开页面）。
import http.server
import json
import os
import re
import shutil
import urllib.parse

ROOT = os.path.dirname(os.path.abspath(__file__))
PORT = 8787


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, obj, code=200):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urllib.parse.urlparse(self.path).path
        if path in ("", "/"):
            path = "/static/postmd.html"
        fp = os.path.normpath(os.path.join(ROOT, path.lstrip("/")))
        # 防目录穿越：只允许访问项目内的文件
        if not fp.startswith(ROOT):
            self.send_error(403)
            return
        if os.path.isfile(fp):
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            with open(fp, "rb") as f:
                shutil.copyfileobj(f, self.wfile)
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path.rstrip("/") != "/save":
            self.send_error(404)
            return
        try:
            n = int(self.headers.get("Content-Length", 0))
            data = json.loads(self.rfile.read(n) or b"{}")
            title = (data.get("title") or "未命名文章").strip()
            content = data.get("content") or ""
            safe = re.sub(r'[\\/:*?"<>|\r\n\t]', "_", title).strip()
            safe = safe[:120] or "未命名文章"
            out_dir = os.path.join(ROOT, "content", "posts")
            os.makedirs(out_dir, exist_ok=True)
            out = os.path.join(out_dir, safe + ".md")
            with open(out, "w", encoding="utf-8") as f:
                f.write(content)
            rel = os.path.relpath(out, ROOT)
            self._send_json({"ok": True, "file": rel})
        except Exception as e:  # noqa: BLE001
            self._send_json({"ok": False, "error": str(e)}, code=500)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    srv = http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler)
    print(f"postmd 保存助手已启动 -> http://localhost:{PORT}/static/postmd.html")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
