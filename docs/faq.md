> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# FAQ

## General Questions

### What is DocShip?

DocShip is a collection of GitHub Actions workflows that automatically build and deploy documentation sites from your markdown files.

### Which framework should I choose?

It depends on your needs:

- **Speed**: VitePress, Rspress
- **Features**: Docusaurus, Fumadocs
- **Simplicity**: Docsify, Docute
- **Python ecosystem**: MkDocs Material
- **Ruby ecosystem**: Jekyll

### Is it free?

Yes! DocShip is open source and free to use. It runs on GitHub Actions, which is free for public repositories.

## Technical Questions

### Why is my build failing?

Common causes:

1. **Invalid markdown syntax** - Check for unclosed code blocks
2. **Broken image links** - DocShip tries to clean these automatically
3. **Missing permissions** - Ensure your workflow has `pages: write` permission

### Can I customize the theme?

Each framework has different customization options. Check the framework's official documentation for details.

### How do I add search?

Most frameworks have search enabled by default:

- VitePress: Local search
- Docusaurus: Algolia or local
- MkDocs: Built-in search
- Just the Docs: Lunr.js search

## Troubleshooting

### 404 Error on GitHub Pages

1. Check that GitHub Pages is enabled in repository settings
2. Verify the base path is correct
3. Wait a few minutes for deployment to complete

### Images not showing

Make sure your images are:

1. In a supported format (png, jpg, gif, svg)
2. Using relative paths
3. Not using external URLs that might be blocked

### Build takes too long

The showcase mode builds all 13 frameworks in parallel, which takes about 3 minutes. Individual framework builds are much faster (30-90 seconds).
