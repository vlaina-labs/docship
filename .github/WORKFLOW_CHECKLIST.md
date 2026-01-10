# DocShip Workflow Checklist

This document outlines the requirements and best practices for all framework workflows.

## Required Features

### 1. Branding
- [ ] Logo: GitHub avatar (`https://github.com/USERNAME.png`) + `username/reponame`
- [ ] Favicon: User's GitHub avatar
- [ ] Footer: `Powered by NekoTick · {Framework}` with `target="_blank"` links
  - NekoTick link: `https://github.com/NekoTick/NekoTick`
  - Framework link: GitHub repository (not official website)

### 2. Workflow Inputs
- [ ] `base_path_suffix` - For showcase subpath deployment
- [ ] `deploy` - Boolean to control deployment (false for showcase builds)

### 3. Caching
- [ ] Use fixed cache key without hash: `${{ runner.os }}-{framework}`
- [ ] Cache path: `~/.npm` for Node.js, `~/.cache/pip` for Python, etc.

### 4. Content Sanitization

**Use the centralized sanitize script** instead of inline sed commands:

```yaml
- name: Sanitize markdown content
  run: |
    curl -sL https://raw.githubusercontent.com/NekoTick/docship/main/scripts/sanitize.sh -o /tmp/sanitize.sh
    chmod +x /tmp/sanitize.sh
    /tmp/sanitize.sh /tmp/user-content
```

The script handles:
- Broken image links (`.html` extension, `charset` in URL)
- Dangerous HTML (script/style tags, event handlers)
- Unknown code block languages (mermaid, plantuml, etc.)
- Template syntax escape (Nunjucks, Vue `{{ }}`)

### 5. Artifact Upload
- [ ] For `deploy: true` - Upload to GitHub Pages
- [ ] For `deploy: false` - Upload as artifact with name `build-{framework}`

### 6. Error Tolerance
- [ ] Set `onBrokenLinks: 'ignore'` or equivalent
- [ ] Set `onBrokenMarkdownLinks: 'ignore'` or equivalent
- [ ] Handle missing files gracefully

## Code Style
- All comments MUST be in English
- Use consistent indentation (2 spaces for YAML)
- Group related steps together

## Testing
Test with files in `docship/test/` directory which contain various edge cases.
