# Features

## Theme Support

Docship supports multiple documentation themes:

| Theme | Language | Features |
|-------|----------|----------|
| Docusaurus | JavaScript | Full-featured, plugins |
| VitePress | JavaScript | Fast, Vue-powered |
| MkDocs | Python | Simple, Material theme |
| Docsify | JavaScript | No build, runtime |
| Starlight | JavaScript | Astro-based |
| Rspress | JavaScript | Rspack-powered |

## Auto Configuration

All themes are automatically configured with:

1. Site title from repository name
2. Logo from GitHub avatar
3. Auto-generated sidebar
4. Search functionality
5. Dark mode support

## Code Highlighting

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("Docship"))
```

```bash
# Deploy with one line
curl -sSL https://docship.dev/install.sh | bash
```
