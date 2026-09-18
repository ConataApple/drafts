#!/bin/bash
cd "$(dirname "$0")" || exit 1

# 自动读取 macOS 系统代理，让 git 走和浏览器相同的代理
PROXY=""
SCOUT=$(scutil --proxy 2>/dev/null)
hen=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPEnable : \([01]\)/\1/p')
hse=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPSEnable : \([01]\)/\1/p')
sen=$(printf '%s\n' "$SCOUT" | sed -n 's/.*SOCKSEnable : \([01]\)/\1/p')
hp=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPProxy : \([^ ]*\)/\1/p')
hport=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPPort : \([0-9]*\)/\1/p')
sp=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPSProxy : \([^ ]*\)/\1/p')
sport=$(printf '%s\n' "$SCOUT" | sed -n 's/.*HTTPSPort : \([0-9]*\)/\1/p')
sop=$(printf '%s\n' "$SCOUT" | sed -n 's/.*SOCKSProxy : \([^ ]*\)/\1/p')
soport=$(printf '%s\n' "$SCOUT" | sed -n 's/.*SOCKSPort : \([0-9]*\)/\1/p')
if { [ "$hen" = "1" ] || [ "$hse" = "1" ]; } && [ -n "$hp" ] && [ -n "$hport" ]; then
  PROXY="http://$hp:$hport"
elif [ "$hse" = "1" ] && [ -n "$sp" ] && [ -n "$sport" ]; then
  PROXY="http://$sp:$sport"
elif [ "$sen" = "1" ] && [ -n "$sop" ] && [ -n "$soport" ]; then
  PROXY="socks5://$sop:$soport"
fi
if [ -n "$PROXY" ]; then
  export HTTP_PROXY="$PROXY" HTTPS_PROXY="$PROXY" ALL_PROXY="$PROXY" http_proxy="$PROXY" https_proxy="$PROXY" all_proxy="$PROXY"
  echo "已启用系统代理：$PROXY"
fi

# 清理可能残留的 git 锁，避免 git add/commit 静默失败
find .git -name '*.lock' -delete 2>/dev/null

git fetch origin
git pull origin main --no-edit

# pull 过程中可能再次产生锁，清掉
find .git -name '*.lock' -delete 2>/dev/null

# 全推送：暂存所有改动（文章 / 模板 / 工具 / README），不含被 .gitignore 忽略的文件
git add -A
if ! git diff --cached --quiet; then
  git commit -m "更新模板、工具与 README（全推送）"
fi

if git push origin main 2>push_err.log; then
  rm -f push_err.log
  osascript -e 'display dialog "已推送全部改动到 GitHub，稍等片刻网页会自动更新。" buttons {"好"} default button "好"'
else
  if grep -qiE "couldn't connect|failed to connect|timed out|could not resolve|connection refused|network is unreachable" push_err.log; then
    rm -f push_err.log
    osascript -e 'display dialog "推送失败：连不上 github.com，请检查网络或打开 VPN 后重试。" buttons {"好"} default button "好"'
  else
    rm -f push_err.log
    osascript -e 'display dialog "推送失败：可能需要登录 GitHub（钥匙串令牌）。请检查后重试。" buttons {"好"} default button "好"'
  fi
  exit 1
fi
