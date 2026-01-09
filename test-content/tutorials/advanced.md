# Advanced Configuration

## Custom Styling

Each theme supports custom CSS. Create a `custom.css` file in your docs folder.

## Sidebar Configuration

By default, sidebar is auto-generated from your file structure.

### Manual Sidebar

For Docusaurus, create `sidebars.js`:

```javascript
module.exports = {
  docs: [
    'intro',
    {
      type: 'category',
      label: 'Guides',
      items: ['guide1', 'guide2'],
    },
  ],
};
```

## Search

All themes include search functionality:

- Docusaurus: `@easyops-cn/docusaurus-search-local`
- VitePress: Built-in local search
- MkDocs: Built-in search plugin
- Docsify: Search plugin
- Starlight: Built-in search
- Rspress: Built-in search

## Environment Variables

Some themes support environment variables:

```yaml
env:
  SITE_URL: https://example.com
  GA_ID: UA-XXXXX-X
```

## Troubleshooting

### Build Fails

1. Check for MDX syntax errors
2. Ensure all links are valid
3. Check frontmatter format

### Missing Pages

1. Verify file extensions (`.md`)
2. Check file permissions
3. Ensure files are committed

## Vue Template Syntax Test

This tests VitePress handling of `{{ variable }}` syntax.
