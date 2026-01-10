> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Advanced Configuration

## Custom Branding

DocShip automatically uses your GitHub avatar for:

- Site logo (navbar)
- Favicon
- Social preview

The title is set to `username/repository`.

## Directory Structure

DocShip supports nested directories:

```
your-repo/
├── index.md          # Homepage
├── getting-started.md
├── docs/
│   ├── api.md
│   └── guide.md
└── tutorials/
    ├── beginner.md
    └── advanced.md
```

## Front Matter

Some frameworks support YAML front matter:

```yaml
---
title: Custom Title
description: Page description
---

# Content starts here
```

## Callouts / Admonitions

Different frameworks have different syntax:

### VitePress

```md
::: tip
This is a tip
:::

::: warning
This is a warning
:::
```

### Docusaurus

```md
:::note
This is a note
:::

:::danger
This is dangerous
:::
```

### MkDocs Material

```md
!!! note
    This is a note

!!! warning
    This is a warning
```

## Multiple Versions

Some frameworks support versioning:

- **Docusaurus**: Built-in versioning
- **MkDocs**: mike plugin
- **VitePress**: Manual setup

## Custom CSS

Most frameworks allow custom CSS. Check each framework's documentation for details.

## Environment Variables

Available in workflows:

| Variable | Description |
|----------|-------------|
| `GITHUB_REPOSITORY` | `owner/repo` |
| `GITHUB_REPOSITORY_OWNER` | `owner` |
| `GITHUB_REF_NAME` | Branch name |

## Performance Tips

1. Use smaller images
2. Minimize external dependencies
3. Enable caching (already configured)
4. Use static frameworks for faster load times
