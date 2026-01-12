# Docship

Build and deploy documentation sites to GitHub Pages with a single command.

## Usage

Add to `.github/workflows/deploy.yml`:

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

## Supported Frameworks

| Framework | Workflow File | Features |
|-----------|---------------|----------|
| Docsify | `docsify.yml` | Pure frontend, no build required |
| Docusaurus | `docusaurus.yml` | React-powered, feature-rich |
| Docus | `docus.yml` | Nuxt 4-powered, modern design |
| Docute | `docute.yml` | Pure frontend, Vue-based |
| DocFX | `docfx.yml` | .NET ecosystem |
| Eleventy | `eleventy.yml` | JavaScript, flexible templating |
| Fumadocs | `fumadocs.yml` | Next.js-powered |
| HonKit | `honkit.yml` | GitBook fork |
| Jekyll | `jekyll-just-the-docs.yml` | Ruby ecosystem, Just the Docs theme |
| mdBook | `mdbook.yml` | Rust-powered, lightweight |
| MkDocs Material | `mkdocs-material.yml` | Python ecosystem, Material theme |
| Nextra | `nextra.yml` | Next.js-powered |
| Sphinx | `sphinx.yml` | Python ecosystem, Furo theme |
| Rspress | `rspress.yml` | Rspack-powered |
| Starlight | `starlight.yml` | Astro framework |
| VitePress | `vitepress.yml` | Vue-powered, fast |
| VuePress | `vuepress.yml` | Vue 2 ecosystem |

## Examples

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
