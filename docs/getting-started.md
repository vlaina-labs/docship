> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Getting Started

This guide will help you set up DocShip for your project.

## Prerequisites

- A GitHub repository with markdown files
- GitHub Pages enabled in repository settings

## Installation

1. Create a workflow file in your repository:

```
.github/workflows/deploy.yml
```

2. Add the following content:

```yaml
name: Deploy Docs

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
    uses: NekoTick/docship/.github/workflows/vitepress.yml@main
```

3. Push to your repository and watch the magic happen!

## Choosing a Framework

Each framework has its own strengths:

- **VitePress** - Fast, Vue-based, great for technical docs
- **Docusaurus** - Feature-rich, React-based, versioning support
- **MkDocs Material** - Beautiful, Python-based, extensive plugins
- **Docsify** - No build step, runtime rendering
- **Jekyll** - GitHub native, Ruby-based, huge theme ecosystem

## Configuration

Most frameworks will automatically:

- Use your GitHub avatar as logo and favicon
- Generate navigation from your folder structure
- Enable search functionality
- Add a footer with attribution

## Next Steps

- Check out the [API Reference](api-reference.md)
- Read the [FAQ](faq.md)
- Explore [Advanced Configuration](advanced-config.md)
