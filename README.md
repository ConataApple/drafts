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

3. 在项目目录里运行一条命令发布：

   ```bash
   ./publish.sh
   ```

   它会自动把源码备份到 GitHub，并把网站编译发布到 GitHub Pages。

4. 打开 https://drafts.douzong.top 就能看到（首次绑定域名可能要等 DNS 生效，几分钟到几小时）。

> 不会用命令行也没关系：可以直接在 GitHub 网页上进入 `content/posts/`，点 Add file → Create new file 写好内容，然后在本地跑 `./publish.sh` 发布即可。

## 本地预览（可选）

```bash
hugo server -D
```

然后浏览器打开 http://localhost:1313
