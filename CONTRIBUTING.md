# 贡献指南

这将对你如何为此存储库做出贡献提供建议

## 目录

- [贡献指南](#贡献指南)
  - [目录](#目录)
  - [fork 仓库](#fork-仓库)
  - [clone 你的仓库](#clone-你的仓库)
  - [创建一个新的分支](#创建一个新的分支)
  - [进行编辑](#进行编辑)
    - [建议](#建议)
  - [添加 commit](#添加-commit)
  - [与上游同步](#与上游同步)
  - [提交 Pull Request](#提交-pull-request)

## fork 仓库

点击右上角的“Fork”按钮，将此存储库 Fork 到你的 GitHub 帐户

## clone 你的仓库

使用 `git clone` 将你 fork 的仓库克隆到本地

```bash
git clone git@github.com:YourUsername/note.git
```

## 创建一个新的分支

这有助于将你的工作与主仓库分开

```bash
git checkout -b your-branch-name
```

## 进行编辑

> [!IMPORTANT]
> 请遵循排版规范，以确保一致性

### 建议

> [!TIP]
> 如果你使用 VS Code 进行编辑，可以安装 [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) 和 [autocorrect](https://marketplace.visualstudio.com/items?itemName=huacnlee.autocorrect) 扩展来帮助你检查 Markdown 文件的格式

## 添加 commit

将更改提交到你的分支

```bash
git add .
git commit -m "Your meaningful commit message"
```

## 与上游同步

定期将你 fork 的存储库与原始（上游）存储库同步，以随时了解最新更改

```bash
git remote add upstream git@github.com:chai-mi/note.git
git fetch upstream
git rebase upstream/main
```

## 提交 Pull Request

前往 [原始存储库](https://github.com/chai-mi/note/pulls) 并提交 Pull Request (PR)
