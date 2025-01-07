# 贡献指南

这将对你如何为此存储库做出贡献提供建议

## fork 仓库

点击右上角的“Fork”按钮, 将此存储库 Fork 到你的 GitHub 帐户

## clone 你的仓库

使用 `git clone` 将你 fork 的仓库克隆到本地

```bash
git clone https://github.com/YourUsername/note.git
```

## 创建一个新的分支

这有助于将你的工作与主仓库分开

```bash
git checkout -b ${your-branch-name}
```

## 进行编辑

> [!IMPORTANT]
> 请遵循以下规范, 以确保一致性
>
> 以最终 GitHub 的渲染呈现效果为准

### 排版格式

基本遵循 [中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines/blob/master/README.zh-Hans.md)

> [!TIP]
> 如果你使用 VS Code 进行编辑, 可以安装以下扩展来帮助你检查 Markdown 文件的格式
> - [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one): 辅助编辑 markdown
> - [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid): 提供 [markdown mermaid](https://docs.github.com/zh/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams#about-creating-diagrams) 拓展支持
> - [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint): markdown 格式约束
> - [AutoCorrect](https://marketplace.visualstudio.com/items?itemName=huacnlee.autocorrect): 中英文混排辅助

#### 例外

- 不使用全角的（）, 而使用半角的 (), 并且前后空一格
- 不使用「」, 使用“”, 并且前后空一格
- 句末不加句号

#### 额外的

- 不使用行尾空两格的形式进行换行, 而是额外一个空行

  ```markdown
  P1

  P2
  ```

- 行内数学公式前后空一格
  - `句子(注意空一格) $math$ (空一格)句子`
- 行间数学公式使用以下形式

  ```markdown
  (注意空一行)
  $$
  math
  $$
  (空一行)
  ```

> [!TIP]
> 如果你不熟悉 $\LaTeX$ 编辑, 可以参考 [这个](./latex.md)

## 添加 commit

将更改提交到你的分支

```bash
git add .
git commit -m "Your meaningful commit message"
```

## 与上游同步

定期将你 fork 的存储库与原始（上游）存储库同步, 以随时了解最新更改

```bash
git remote add upstream https://github.com/chai-mi/note.git
git fetch upstream
git checkout main
git rebase upstream/main
```

## 提交 Pull Request

```bash
# 与上游同步
git fetch upstream
git checkout main
git rebase upstream/main
git checkout ${your-branch-name}
git rebase main
# 推送到你的远端仓库
git push
```

前往 [原始存储库](https://github.com/chai-mi/note/pulls) 并提交 Pull Request (PR)
