#!/bin/bash
# 一键发布 drafts 博客到 GitHub Pages
# 用法：在项目目录里改好 content/ 下的 .md 后，运行 ./publish.sh
set -e
cd "$(dirname "$0")"

TOKEN=$(security find-internet-password -s github.com -a ConataApple -w)

# 1) 把源码备份到 GitHub（main 分支）
git add -A
git commit -q -m "update $(date '+%Y-%m-%d %H:%M')" || echo "（没有源码改动，跳过提交）"
git push -q https://ConataApple:$TOKEN@github.com/ConataApple/drafts.git main

# 2) 编译并发布到 GitHub Pages（gh-pages 分支）
echo "▶ 正在编译并发布到 https://drafts.douzong.top ..."
hugo --minify
cd public
rm -rf .git
git init -q -b gh-pages
git add -A
git commit -q -m "deploy $(date '+%Y-%m-%d %H:%M')"
git push -f -q https://ConataApple:$TOKEN@github.com/ConataApple/drafts.git gh-pages

echo "✅ 发布完成。等 DNS 生效后即可访问（首次绑定域名可能要几分钟到几小时）。"