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

3. 提交并推送到 GitHub：

   ```bash
   git add .
   git commit -m "新增文章：文章标题"
   git push origin main
   ```

4. 等一两分钟，打开 https://drafts.douzong.top 就能看到。

> 不会用 git 也没关系：可以直接在 GitHub 网页上进入 `content/posts/`，点 Add file → Create new file，写好内容提交即可，效果一样。

## 本地预览（可选）

```bash
hugo server -D
```

然后浏览器打开 http://localhost:1313
