> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# DocShip

A collection of documentation site generators for GitHub Pages.

## Features

- 🚀 One-click deployment to GitHub Pages
- 📦 13+ documentation frameworks supported
- 🎨 Automatic branding with your GitHub avatar
- 🔍 Built-in search for most frameworks
- 📱 Mobile responsive

## Supported Frameworks

| Framework | Type | Language |
|-----------|------|----------|
| Docsify | Runtime | JavaScript |
| Docute | Runtime | JavaScript |
| VitePress | Static | Vue |
| VuePress | Static | Vue |
| Docusaurus | Static | React |
| Starlight | Static | Astro |
| Rspress | Static | React |
| MkDocs Material | Static | Python |
| HonKit | Static | Node.js |
| DocFX | Static | .NET |
| Fumadocs | Static | Next.js |
| Nextra | Static | Next.js |
| Jekyll | Static | Ruby |

## Quick Start

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches:
      - main

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/vitepress.yml@main
```

## Links

- [GitHub Repository](https://github.com/NekoTick/docship)
- [NekoTick](https://github.com/NekoTick/NekoTick)
