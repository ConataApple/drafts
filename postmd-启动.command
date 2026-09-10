#!/bin/bash
cd "$(dirname "$0")" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
  osascript -e 'display dialog "需要 Python 3 才能启动文章保存助手。请先安装 Python 3（或 Xcode 命令行工具）。" buttons {"好"} default button "好"'
  exit 1
fi

# 若助手已在运行，直接打开页面
if lsof -iTCP:8787 -sTCP:LISTEN >/dev/null 2>&1; then
  echo "保存助手已在运行"
else
  nohup python3 postmd-server.py >/dev/null 2>&1 &
  sleep 1
fi

open http://localhost:8787/static/postmd.html
