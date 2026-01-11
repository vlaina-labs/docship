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
| Docsify | `docsify.yml` | Pure frontend rendering, no build required, lightweight |
| Docusaurus | `docusaurus.yml` | React-powered, feature-rich |
| VitePress | `vitepress.yml` | Vue-powered, fast |
| MkDocs Material | `mkdocs-material.yml` | Python ecosystem, Material theme |
| Starlight | `starlight.yml` | Astro framework |
| Rspress | `rspress.yml` | Rspack-powered |
| Fumadocs | `fumadocs.yml` | Next.js-powered, modern UI |

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
