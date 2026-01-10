> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# API Reference

## Workflow Inputs

All DocShip workflows accept the following inputs:

### `base_path_suffix`

- **Type:** `string`
- **Required:** `false`
- **Default:** `''`

Additional path suffix for base URL. Used internally by showcase mode.

### `deploy`

- **Type:** `boolean`
- **Required:** `false`
- **Default:** `true`

Whether to deploy to GitHub Pages. Set to `false` for showcase mode.

## Example Usage

### Basic Deployment

```yaml
jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/vitepress.yml@main
```

### With Custom Base Path

```yaml
jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/vitepress.yml@main
    with:
      base_path_suffix: docs
```

## Available Workflows

| Workflow | File |
|----------|------|
| Docsify | `docsify.yml` |
| Docute | `docute.yml` |
| VitePress | `vitepress.yml` |
| VuePress | `vuepress.yml` |
| Docusaurus | `docusaurus.yml` |
| Starlight | `starlight.yml` |
| Rspress | `rspress.yml` |
| MkDocs Material | `mkdocs-material.yml` |
| HonKit | `honkit.yml` |
| DocFX | `docfx.yml` |
| Fumadocs | `fumadocs.yml` |
| Nextra | `nextra.yml` |
| Jekyll (Just the Docs) | `jekyll-just-the-docs.yml` |
| Showcase (All) | `showcase.yml` |

## Code Examples

### JavaScript

```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
  return true;
}

greet('World');
```

### Python

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
```

### Rust

```rust
fn main() {
    println!("Hello, Rust!");
}
```
