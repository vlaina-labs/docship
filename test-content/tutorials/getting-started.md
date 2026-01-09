# Getting Started

## Prerequisites

- A GitHub repository
- GitHub Pages enabled

## Installation

Add this to `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/docusaurus.yml@main
```

## Choose Your Theme

Replace `docusaurus.yml` with any of these:

- `docusaurus.yml` - Full-featured React-based
- `vitepress.yml` - Fast Vue-powered
- `mkdocs-material.yml` - Python Material theme
- `docsify.yml` - No build required
- `starlight.yml` - Astro-based
- `rspress.yml` - Rspack-powered

## Directory Structure

```
your-repo/
├── docs/
│   ├── index.md
│   ├── guide.md
│   └── api/
│       └── reference.md
└── .github/
    └── workflows/
        └── deploy.yml
```

## Next Steps

Check out the [Advanced Guide](/tutorials/advanced) for more options.
