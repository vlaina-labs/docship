# Docship

只需一行命令就可以构建主流静态网站

## 使用方法

放到 `.github/workflows/deploy.yml` 即可：

```yaml
name: Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/docusaurus.yml@main
```

## 支持的框架

| 框架 | 工作流文件 | 特点 |
|------|-----------|------|
| Docsify | `docsify.yml` | 纯前端渲染，无需构建，最轻量 |
| Docusaurus | `docusaurus.yml` | React 驱动，功能丰富 |
| VitePress | `vitepress.yml` | Vue 驱动，速度快 |
| MkDocs Material | `mkdocs-material.yml` | Python 生态，Material 主题 |
| Starlight | `starlight.yml` | Astro 框架 |
| Rspress | `rspress.yml` | Rspack 驱动 |
| Fumadocs | `fumadocs.yml` | Next.js 驱动，现代化 UI |

## 示例

### Fumadocs (Next.js)
```yaml
jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/fumadocs.yml@main
```

### VitePress
```yaml
jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/vitepress.yml@main
```

### Docsify
```yaml
jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/docsify.yml@main
```

<img width="342" height="116" alt="image" src="https://github.com/user-attachments/assets/11c19407-73af-4375-95d0-c561924388b2" />
