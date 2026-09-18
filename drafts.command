#!/bin/zsh
# 启动 Hugo 本地预览：自动起服务器 + 自动打开浏览器
# 关闭此终端窗口（Cmd+W）或按 Ctrl+C 即可停止服务器

cd "$(dirname "$0")" || exit 1

# 找 hugo：优先 PATH，找不到再用 Homebrew 默认路径
HUGO="$(command -v hugo 2>/dev/null || echo /opt/homebrew/bin/hugo)"

# 如果 1313 已经在跑，直接开浏览器，避免重复启动
if curl -s -o /dev/null "http://127.0.0.1:1313/" 2>/dev/null; then
  echo "✅ Hugo 已经在运行，直接打开浏览器…"
  open "http://localhost:1313"
  exit 0
fi

echo "🚀 正在启动 Hugo 本地预览…"
echo "   稍等几秒，浏览器会自动打开 http://localhost:1313"
echo "   关闭此窗口或按 Ctrl+C 可停止服务器"
echo

# 延迟 4 秒后自动打开浏览器（等服务器起来）
( sleep 4 && open "http://localhost:1313" ) &

"$HUGO" server -D --bind 127.0.0.1 --port 1313
