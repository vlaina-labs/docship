# Docship Theme Development Checklist

## Markdown Compatibility

- [ ] Use `markdown.format: 'md'` instead of MDX to avoid JSX parsing errors (Docusaurus)
  - Users may have `${}`, `<>`, `{}` in their markdown content
  - MDX will treat these as JSX expressions and fail
- [ ] VitePress is more lenient with `${}` but `{{ }}` will be treated as Vue template
- [ ] Don't restrict filenames - users can use any name like `temp.md`
- [ ] Handle files with special characters in content gracefully

## Docusaurus Configuration

- [ ] Don't use `navbar.logo` without `logo.src` - it will throw validation error
- [ ] Remove `sidebarPath` to let Docusaurus auto-generate sidebar from file structure
- [ ] Use `onBrokenLinks: 'ignore'` to prevent build failures on broken links
- [ ] Use `markdown.hooks.onBrokenMarkdownLinks: 'ignore'` (new location in v3.9+)
- [ ] Don't include deprecated options like root-level `onBrokenMarkdownLinks`
- [ ] For local search, use `@easyops-cn/docusaurus-search-local` (no API key needed)
- [ ] Algolia search requires API key - not suitable for generic themes

## VitePress Configuration

- [ ] Use `ignoreDeadLinks: true` to prevent build failures on broken/dead links
- [ ] VitePress does NOT auto-generate sidebar - need custom script or manual config
- [ ] `sidebar: 'auto'` does NOT work like Docusaurus - only shows current page headings
- [ ] Output directory is `.vitepress/dist` (not `build`)
- [ ] Use `srcDir: 'docs'` to specify source directory
- [ ] Exclude `node_modules` in content backup
- [ ] For local search, use `search: { provider: 'local' }` (built-in)
- [ ] `logo.link` does NOT support external URLs - need custom theme to override

## Sidebar Generation (VitePress)

- [ ] Write custom Node.js script to scan directory and generate sidebar config
- [ ] Sort entries: files first, then directories (or vice versa for consistency)
- [ ] Skip files starting with `.` or `_`
- [ ] Skip `index.md` from sidebar items (it's the folder landing page)
- [ ] Capitalize first letter and replace `-` with spaces for display text

## Homepage Selection Logic

Priority order:
1. `docs/index.md` or `content/index.md` - explicit homepage
2. `docs/README.md` or `content/README.md` - common convention
3. First `.md` file (sorted alphabetically) - fallback

- [ ] Always use `sort` before `head -1` for consistent results
- [ ] For Docusaurus: check if `slug: /` already exists before adding frontmatter
- [ ] For VitePress: `index.md` is automatically the homepage, no frontmatter needed

## GitHub Actions / Reusable Workflows

- [ ] Reusable workflows MUST be in `.github/workflows/` directory
- [ ] Use `on: workflow_call` for workflows that should only be called by others
- [ ] Caller workflow must declare `permissions` for the called workflow to use
- [ ] Remove `push` and `workflow_dispatch` triggers if workflow should not run directly

## Content Backup

- [ ] Exclude `README.md` from root (usually not documentation)
- [ ] Exclude hidden directories (`.git`, `.github`, etc.)
- [ ] Exclude `node_modules` directory
- [ ] Copy all user folders to preserve structure
- [ ] Handle empty content directory - create default welcome page

## Build & Deploy

- [ ] GitHub Pages keeps old version online during build (atomic deployment)
- [ ] First deployment shows blank page until complete - this is normal
- [ ] Public repos have unlimited GitHub Actions minutes
- [ ] Add npm cache to speed up builds: `actions/cache@v4` with `~/.npm` path

## Shell Script Best Practices (GitHub Actions)

- [ ] Don't use `sed -i '1s/^/...\n.../'` - `\n` may not work on all systems
- [ ] Don't use heredoc (`<< EOF`) inside YAML `run:` blocks - causes syntax errors
- [ ] Use `printf '%s\n' 'line1' 'line2'` for multi-line content
- [ ] Use temp files + `cat` + `mv` to prepend content to files
- [ ] Always quote variables: `"$TARGET"` not `$TARGET`

## Logo & Branding

- [ ] Use `https://github.com/USERNAME.png` to get user/org avatar
- [ ] VitePress: need custom theme (`enhanceApp`) to make logo link to external URL
- [ ] Docusaurus: `logo.href` + `logo.target: '_blank'` works for external links
- [ ] Set favicon with `head: [['link', { rel: 'icon', href: '...' }]]` (VitePress)
- [ ] Docusaurus favicon can be external URL directly

## Testing Scenarios

Before releasing a theme, test with:
- [ ] Empty repository (no markdown files)
- [ ] Single markdown file
- [ ] Nested folder structure
- [ ] Files with `${}` syntax in content
- [ ] Files with JSX-like syntax `<Component />`
- [ ] Files with curly braces `{}`
- [ ] Files with `{{ }}` Vue template syntax (VitePress specific)
- [ ] Unicode/special characters in filenames
- [ ] Very long filenames
- [ ] Files starting with `_` (usually ignored by default)
- [ ] Files containing `localhost` URLs (dead link check)
- [ ] Repository without `index.md` (homepage fallback logic)

## Starlight (Astro) Configuration

- [ ] Use `npm create astro@latest -- --template starlight` for correct project structure
- [ ] Starlight v0.33.0+ changed `social` config from object to array format
  - Old: `social: { github: 'url' }`
  - New: `social: [{ icon: 'github', label: 'GitHub', href: 'url' }]`
- [ ] Every `.md` file MUST have `title` in frontmatter - Starlight will fail without it
- [ ] Sidebar `slug` must be lowercase - uppercase will cause "slug does not exist" error
- [ ] `autogenerate: { directory: '.' }` doesn't work well - use specific directory names
- [ ] Content goes in `src/content/docs/` directory
- [ ] Output directory is `dist`
- [ ] Use `.mdx` extension for index file if needed

## Rspress Configuration

- [ ] Public assets go in `docs/public/` (not project root `public/`)
- [ ] Sidebar `items` must be an array, not `'auto'` string
- [ ] Output directory is `doc_build`
- [ ] Exclude `public` directory from sidebar generation
- [ ] Config file is `rspress.config.ts` (TypeScript)

## Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `navbar.logo.src is required` | Using `logo` without `src` | Remove `logo` or add `src` |
| `Could not parse expression with acorn` | MDX parsing `${}` as JSX | Use `markdown.format: 'md'` |
| `workflow is not reusable` | Missing `workflow_call` trigger | Add `on: workflow_call` |
| `requesting pages: write but only allowed none` | Caller missing permissions | Add `permissions` to caller |
| `onBrokenMarkdownLinks deprecated` | Old config location | Move to `markdown.hooks` |
| `Found dead link` (VitePress) | Broken links in markdown | Use `ignoreDeadLinks: true` |
| `sidebar: 'auto' not working` | VitePress doesn't auto-generate | Write custom sidebar script |
| `Page Not Found` on homepage | Missing `slug: /` frontmatter | Add frontmatter to first doc |
| `here-document delimited by end-of-file` | Heredoc in YAML run block | Use `printf` instead |
| `social: Expected array, received object` | Starlight v0.33.0+ API change | Use array format for social links |
| `title: Required` (Starlight) | Missing frontmatter title | Auto-add title from filename |
| `slug does not exist` (Starlight) | Uppercase slug in sidebar | Convert slug to lowercase |
| `Entry docs → 404 was not found` | No valid index page | Ensure index.md/mdx exists with frontmatter |
| `item.items.map is not a function` | Rspress sidebar `items: 'auto'` | Use array of items, not string |
| `Failed to read favicon` (Rspress) | Wrong public directory path | Put assets in `docs/public/` |
| `Module not found: Can't resolve './assets/...'` | Invalid image path in markdown | Set `remarkImageOptions: false` (Fumadocs) or `staticImage: false` (Nextra) |
| `Unrecognized keys: "theme", "themeConfig"` | Nextra v4 API changed | Use new `nextra()` config format |
| `Export doesn't exist in target module` | Simplified source.ts missing exports | Delete files that depend on removed exports (e.g., `app/og`, `app/llms-full.txt`) |
| `fatal: No url found for submodule path` | Downloaded repo folder treated as submodule | Add folder to `.gitignore` or `git rm -r --cached folder` |
| `shallow cloned, latest modified time not presented` | GitHub Actions shallow clone | Warning only, can ignore or use `fetch-depth: 0` |
| `InvalidTocFile: not a valid TOC File` (DocFX) | Empty or malformed toc.yml | Delete invalid toc.yml from subdirectories |
| Logo/favicon not showing (DocFX) | External URL in `_appLogoPath`/`_appFaviconPath` | Use custom template JS to inject external URLs |

## Fumadocs Configuration

- [ ] Fumadocs is based on Next.js - requires `output: 'export'` for static build
- [ ] Use `basePath` for GitHub Pages deployment (e.g., `/${REPO_NAME}`)
- [ ] Set `images: { unoptimized: true }` for static export
- [ ] Content goes in `content/docs/` directory
- [ ] Output directory is `out` (Next.js static export default)
- [ ] Every `.mdx` file should have frontmatter with `title` and `description`
- [ ] Use `create-fumadocs-app` with `--template +next+fuma-docs-mdx+static` for static export
- [ ] Fumadocs MDX is the official content source
- [ ] Config file is `next.config.mjs` (ESM)
- [ ] Requires `fumadocs-mdx/next` plugin wrapper
- [ ] Set `remarkImageOptions: false` in `source.config.ts` to prevent build failures from invalid image paths
- [ ] Delete `app/llms-full.txt` and `app/og` directories (they depend on exports not in simplified source.ts)
- [ ] Clear template's default `content/docs/*` before copying user content (removes Hello World page)

## Nextra Configuration

- [ ] Nextra v4 uses App Router - structure is `src/app/` and `src/content/`
- [ ] Requires `output: 'export'` and `images: { unoptimized: true }` for static build
- [ ] Use `basePath` via environment variable for GitHub Pages
- [ ] Content goes in `src/content/` directory
- [ ] Output directory is `out`
- [ ] Need `mdx-components.js` at project root for MDX components
- [ ] Use `nextra-theme-docs` for documentation theme
- [ ] Config uses `nextra()` wrapper with `contentDirBasePath` option
- [ ] Homepage redirect to `/docs` since content is under `/docs` route
- [ ] Nextra uses MDX - user content with `${}`, `<>`, `{}` may cause JSX parsing errors
- [ ] Set `staticImage: false` to prevent build failures from invalid image paths

## DocFX Configuration

- [ ] DocFX is a .NET-based documentation framework - uses `dotnet tool install -g docfx`
- [ ] Content goes in `docs/` directory
- [ ] Output directory is `_site`
- [ ] Config file is `docfx.json`
- [ ] Uses `toc.yml` for navigation structure:
  - Root `toc.yml`: top navbar tabs
  - `docs/toc.yml`: left sidebar
- [ ] `_appLogoPath` and `_appFaviconPath` do NOT support external URLs - need custom template
- [ ] Use custom template with JavaScript to inject external avatar as logo/favicon
- [ ] Remove root `toc.yml` to hide navbar tabs (e.g., "Docs" tab) when only one section
- [ ] Use `redirect_url` frontmatter in `index.md` to redirect homepage to docs
- [ ] Set `_disableContribution: true` to hide "Edit this page" link
- [ ] Set `_appFooter` to customize or remove footer
- [ ] Sidebar toc.yml format: `- name: Title` + `href: file.md` (not `items:` prefix)
- [ ] Nested items use `items:` array under parent
- [ ] Delete invalid `toc.yml` files from user content subdirectories
- [ ] Exclude framework source folders in backup (fumadocs/, nextra/, docute/, etc.)

### DocFX Custom Template Pattern

For external URLs (logo, favicon, GitHub icon), create custom template:
```
templates/custom/public/main.css  - styles
templates/custom/public/main.js   - JavaScript to inject elements
```

Add to docfx.json template list:
```json
"template": ["default", "modern", "templates/custom"]
```

JavaScript pattern for external resources:
```javascript
export default {
  start: () => {
    // Replace favicon
    const favicon = document.querySelector('link[rel="icon"]');
    if (favicon) favicon.href = 'EXTERNAL_URL';
    
    // Replace logo
    const logo = document.querySelector('#logo');
    if (logo) logo.src = 'EXTERNAL_URL';
    
    // Add GitHub icon to navbar
    const navbar = document.querySelector('.navbar-nav .dropdown');
    if (navbar) {
      const link = document.createElement('a');
      link.href = 'GITHUB_URL';
      link.innerHTML = '<svg>...</svg>';
      navbar.parentNode.insertBefore(link, navbar);
    }
  }
}
```

## Docute Configuration

- [ ] Docute is a pure frontend framework - no build process needed
- [ ] Only needs `index.html` + markdown files
- [ ] Uses CDN for docute.js and docute.css (`unpkg.com/docute@4`)
- [ ] URL routing: `/` => `/README.md`, `/foo` => `/foo.md`, `/foo/` => `/foo/README.md`
- [ ] Sidebar must be manually configured or auto-generated via script
- [ ] Logo is a Vue template string - use `<span>` wrapper with flex layout for avatar + text
- [ ] Use `darkThemeToggler: true` for dark mode toggle
- [ ] No npm cache needed since no build process

## General Lessons Learned

### Framework Categories

1. **Build-required frameworks** (need npm install + build):
   - Docusaurus, VitePress, Starlight, Rspress, Fumadocs, Nextra
   - Need npm cache for faster builds
   - Output to specific directories (build/, dist/, out/, doc_build/)

2. **Pure frontend frameworks** (no build, CDN-based):
   - Docsify, Docute
   - Just HTML + markdown files
   - Faster deployment, simpler setup

3. **Next.js-based frameworks**:
   - Fumadocs, Nextra
   - Require `output: 'export'` for static build
   - Require `images: { unoptimized: true }` for static export
   - Use `basePath` for GitHub Pages subdirectory

### Common Pitfalls

- [ ] **Image handling**: MDX/Next.js frameworks try to import images - disable with `remarkImageOptions: false` or `staticImage: false`
- [ ] **Template default content**: Many templates include "Hello World" or demo content - clear before copying user content
- [ ] **CLI argument changes**: Framework CLIs change frequently - check latest docs (e.g., `create-fumadocs-app` changed from `--name --template --src` to `--template +next+fuma-docs-mdx+static`)
- [ ] **API version changes**: Check for breaking changes (e.g., Starlight social config changed from object to array)
- [ ] **Sidebar in sidebar**: Some frameworks show index page in sidebar - use `index: true` frontmatter to hide it

### Branding Consistency

For all frameworks, implement:
- [ ] Logo: User avatar + `username/reponame` in top-left
- [ ] Favicon: User's GitHub avatar (`https://github.com/USERNAME.png`)
- [ ] GitHub link: Icon or text link to repository (right side of navbar)
- [ ] Title: `username/reponame` in browser tab
- [ ] Footer: `Powered by NekoTick · {Framework}` with links to both projects

### Footer Format

All workflows must include a footer with attribution:
```
Powered by NekoTick · {Framework}
```

- NekoTick link: `https://github.com/NekoTick/NekoTick`
- Framework link: GitHub repository of the framework (not official website)
- NekoTick comes first (deployment service provider)
- Framework comes second (underlying tool)
- Use `·` as separator

Example HTML:
```html
<span>Powered by <a href="https://github.com/NekoTick/NekoTick" target="_blank">NekoTick</a> · <a href="https://github.com/{org}/{framework}" target="_blank">Framework</a></span>
```

| Framework | GitHub Link |
|-----------|-------------|
| Docusaurus | `https://github.com/facebook/docusaurus` |
| VitePress | `https://github.com/vuejs/vitepress` |
| Starlight | `https://github.com/withastro/starlight` |
| Rspress | `https://github.com/web-infra-dev/rspress` |
| Fumadocs | `https://github.com/fuma-nama/fumadocs` |
| Nextra | `https://github.com/shuding/nextra` |
| Docute | `https://github.com/egoist/docute` |
| DocFX | `https://github.com/dotnet/docfx` |
| Docsify | `https://github.com/docsifyjs/docsify` |
| MkDocs Material | `https://github.com/squidfunk/mkdocs-material` |

### Logo Implementation Patterns

| Framework | Logo Config |
|-----------|-------------|
| Docusaurus | `navbar.logo.src` + `navbar.title` |
| VitePress | `themeConfig.logo` + `themeConfig.siteTitle` |
| Fumadocs | `nav.title` as JSX with `<img>` + `<span>` |
| Nextra | `Navbar logo` prop as JSX |
| Docute | `logo` as Vue template string |
| DocFX | Custom template JS to replace `#logo` element |
| Starlight | `logo.src` + `title` |

### Sidebar Generation

- [ ] Auto-generate from directory structure when possible
- [ ] Convert filenames to titles: `my-file.md` → `My File`
- [ ] Handle nested directories as collapsible groups
- [ ] Skip `README.md` / `index.md` from sidebar items (they're folder landing pages)
- [ ] Use `sort` for consistent ordering

### Testing Checklist (Updated)

- [ ] Files with invalid image paths (should not break build)
- [ ] Files with special markdown syntax (`${}`, `<>`, `{}`, `{{ }}`)
- [ ] Empty repository (should show welcome page)
- [ ] Nested folder structure (should generate proper sidebar)
- [ ] Repository without index.md (should use first doc as homepage)

## Multi-Language Support

- [ ] VitePress/Docusaurus i18n is static - requires manual translation files
- [ ] No automatic translation built-in
- [ ] Options: browser translation, or integrate translation API (costs money)
- [ ] Structure: `docs/en/`, `docs/zh/` etc. for each language
