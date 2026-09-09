# drafts

Olivia 的 Hugo 博客，域名 **https://drafts.douzong.top**

由 GitHub Pages 自动部署：推送 `main` 分支 → GitHub Actions 自动编译 Hugo 并发布。

## 怎么发一篇新文章

1. 在 `content/posts/` 下新建一个 `.md` 文件，比如 `my-post.md`
2. 文件顶部加 front matter：

   ```md
   ---
   title: "文章标题"
   date: 2026-09-09
   draft: false
   ---

   正文用 Markdown 写。
   ```

3. 提交并推送到 `main` 分支：

   ```bash
   git add -A
   git commit -m "新文章：xxx"
   git push
   ```

   GitHub Actions 会自动编译 Hugo 并发布到 GitHub Pages，**不用再跑任何脚本**。

4. 打开 https://drafts.douzong.top 就能看到（首次绑定域名可能要等 DNS 生效，几分钟到几小时）。

> 不会用命令行也没关系：直接在 GitHub 网页上进入 `content/posts/`，点 Add file → Create new file 写好内容，提交（Commit）即可。推送 `main` 会自动触发部署。

## 本地预览（可选）

```bash
hugo server -D
```

然后浏览器打开 http://localhost:1313
