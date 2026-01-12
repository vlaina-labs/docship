# Docship Theme Development Checklist

## ⚠️ Critical Rules

### No Advertisements Policy
- **NEVER use any theme or plugin that contains ads**
- Some official themes (e.g., `@vuepress/theme-vue`) contain sponsor/advertisement content - DO NOT USE
- Always check if theme contains ads, sponsor links, or donation prompts before using
- When in doubt, use the framework's default theme

**Known themes/plugins with ads (DO NOT USE):**
| Framework | Theme/Plugin | Issue |
|-----------|--------------|-------|
| VuePress | `@vuepress/theme-vue` | Contains sponsor/advertisement content |

**Recommended ad-free alternatives:**
| Framework | Recommended Theme |
|-----------|-------------------|
| VuePress | Default theme (built-in `@vuepress/theme-default`) |

### User Content Respect
- Never restrict user filenames (e.g., `index.md`, `temp.md` are all valid)
- User markdown content must never break builds regardless of validity
- Invalid image paths, links, etc. should be ignored, not cause errors

## Markdown Compatibility

- [ ] Use `markdown.format: 'md'` instead of MDX to avoid JSX parsing errors (Docusaurus)
  - Users may have `${}`, `<>`, `{}` in their markdown content
  - MDX will treat these as JSX expressions and fail
- [ ] VitePress is more lenient with `${}` but double curly braces will be treated as Vue template
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
- [ ] Files with Vue template syntax (VitePress specific)
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
| Homepage 404 (VuePress) | Using `index.md` instead of `README.md` | Rename `index.md` to `README.md` |
| `sidebar: 'auto'` not showing files (VuePress) | VuePress auto only shows headings | Generate sidebar config via Node.js script |
| Theme has ads/sponsors (VuePress) | Using `@vuepress/theme-vue` | Use default theme (built-in, no ads) |
| `Prerendered 5 routes` only (Docus) | Nuxt can't crawl to doc pages | Add routes to `nitro.prerender.routes` |
| 404 on `/docs/CHECKLIST` (Docus) | Uppercase filename in route | Convert routes to lowercase |
| Blank page on root (Docus) | `index` file without `.html` | Create `index.html` redirect after build |
| `@nuxtjs/mcp-toolkit not compatible` (Docus) | MCP needs server | Warning only, can ignore |
| `robots.txt with base URL` error (Docus) | robots module conflict | Set `robots: { robotsTxt: false }` |
| No sidebar on homepage (Docus) | `content/index.md` is landing page | Put docs in `content/1.docs/` subdirectory |

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

## VuePress Configuration

- [ ] VuePress 1.x is Vue 2 based - use `vuepress@^1.9.10`
- [ ] **⚠️ DO NOT USE `@vuepress/theme-vue`** - it contains sponsor/advertisement content
- [ ] Use default theme `@vuepress/theme-default` (built-in, no ads)
- [ ] Content goes in `docs/` directory
- [ ] Output directory is `docs/.vuepress/dist`
- [ ] Config file is `docs/.vuepress/config.js`
- [ ] Use `base: '/${REPO_NAME}/'` for GitHub Pages subdirectory
- [ ] `themeConfig.logo` supports external URLs directly
- [ ] `themeConfig.sidebar: 'auto'` only shows current page headings - need Node.js script for full sidebar
- [ ] Homepage is `docs/README.md` (not `index.md`) - must rename `index.md` to `README.md`
- [ ] Use `themeConfig.repo` for GitHub link in navbar
- [ ] Custom styles go in `docs/.vuepress/styles/index.styl` (Stylus)
- [ ] Use `enhanceApp.js` for client-side customizations (e.g., footer injection)
- [ ] Favicon via `head: [['link', { rel: 'icon', href: 'URL' }]]` - supports external URLs
- [ ] VuePress uses Vue template syntax - double curly braces in markdown will be parsed as Vue expressions
- [ ] Use `@vuepress/plugin-back-to-top` for back-to-top button (built-in plugin)
- [ ] VuePress 1.x does NOT have native dark mode toggle - custom implementation is complex
- [ ] Green scrollbar: apply only to `.sidebar` selector, not whole page

## DocFX Configuration

- [ ] DocFX is a .NET-based documentation framework - uses `dotnet tool install -g docfx`
- [ ] Content goes in `docs/` directory
- [ ] Output directory is `_site`
- [ ] Config file is `docfx.json`
- [ ] Uses `toc.yml` for navigation structure (root for navbar, docs/ for sidebar)
- [ ] `_appLogoPath` and `_appFaviconPath` do NOT support external URLs - need custom template
- [ ] Use custom template with JavaScript to inject external avatar as logo/favicon
- [ ] Remove root `toc.yml` to hide navbar tabs (e.g., "Docs" tab) when only one section
- [ ] Use `redirect_url` frontmatter in `index.md` to redirect homepage to docs
- [ ] Set `_disableContribution: true` to hide "Edit this page" link
- [ ] Set `_appFooter` to customize or remove footer
- [ ] Sidebar toc.yml format: `- name: Title` + `href: file.md`
- [ ] Delete invalid `toc.yml` files from user content subdirectories
- [ ] Exclude framework source folders in backup (fumadocs/, nextra/, docute/, etc.)

## Docute Configuration

- [ ] Docute is a pure frontend framework - no build process needed
- [ ] Only needs `index.html` + markdown files
- [ ] Uses CDN for docute.js and docute.css (`unpkg.com/docute@4`)
- [ ] URL routing: `/` => `/README.md`, `/foo` => `/foo.md`, `/foo/` => `/foo/README.md`
- [ ] Sidebar must be manually configured or auto-generated via script
- [ ] Logo is a Vue template string - use `<span>` wrapper with flex layout for avatar + text
- [ ] Use `darkThemeToggler: true` for dark mode toggle
- [ ] No npm cache needed since no build process

## mdBook Configuration

- [ ] mdBook is a Rust-based documentation tool - install via pre-built binary or `cargo install mdbook`
- [ ] Content goes in `src/` directory
- [ ] Output directory is `book/`
- [ ] Config file is `book.toml` (TOML format)
- [ ] Requires `src/SUMMARY.md` to define table of contents structure
- [ ] Homepage is `src/README.md` (linked as `[Introduction](README.md)` in SUMMARY.md)
- [ ] SUMMARY.md format: `- [Title](path/to/file.md)` for chapters
- [ ] Use `#` headers in SUMMARY.md to create section separators
- [ ] `[output.html]` section in book.toml for HTML output settings
- [ ] `site-url` in book.toml for base path (GitHub Pages subdirectory)
- [ ] Custom theme via `theme/` directory - can override `index.hbs`, `head.hbs`, CSS files
- [ ] Favicon and logo require custom theme modifications (no direct config option)
- [ ] Built-in themes: light, rust, coal, navy, ayu
- [ ] `default-theme` and `preferred-dark-theme` in `[output.html]` section
- [ ] Supports MathJax via `mathjax-support = true`
- [ ] Built-in search functionality (no additional config needed)

## Eleventy Configuration

- [ ] Eleventy (11ty) is a JavaScript-based static site generator
- [ ] Install via `npm install @11ty/eleventy`
- [ ] Config file is `eleventy.config.js` or `.eleventy.js`
- [ ] Default input directory is `.` (project root)
- [ ] Default output directory is `_site`
- [ ] Supports multiple template languages: Liquid, Nunjucks, Markdown, HTML, JavaScript
- [ ] Use `dir.input` and `dir.output` in config to customize directories
- [ ] Use `pathPrefix` for GitHub Pages subdirectory deployment
- [ ] Layouts go in `_includes/` directory by default
- [ ] Data files go in `_data/` directory (JSON, JS, or YAML)
- [ ] Use frontmatter `layout` to specify template layout
- [ ] Collections are auto-generated from tags or can be custom defined
- [ ] Use `eleventyConfig.addPassthroughCopy()` for static assets
- [ ] Markdown files need frontmatter with `layout` to use templates
- [ ] No built-in theme - requires custom CSS/layout

## Sphinx Configuration

- [ ] Sphinx is a Python-based documentation generator
- [ ] Install via `pip install sphinx furo myst-parser`
- [ ] Config file is `conf.py` (Python)
- [ ] Default source directory is `docs/` or project root
- [ ] Default output directory is `_build/html/`
- [ ] Use `myst-parser` extension to support Markdown (default is reStructuredText)
- [ ] Furo is a modern, clean theme (BSD license)
- [ ] Use `toctree` directive to define navigation structure
- [ ] `html_theme = 'furo'` to use Furo theme
- [ ] `html_logo` and `html_favicon` for branding
- [ ] `html_theme_options` for theme customization
- [ ] Custom CSS goes in `_static/` directory
- [ ] Build with `sphinx-build -b html docs docs/_build/html`
- [ ] License is BSD (Sphinx) + MIT (Furo) - very permissive

## Docus Configuration

- [ ] Docus is a Nuxt 4-based documentation framework (MIT license)
- [ ] Install via `npm install docus nuxt better-sqlite3`
- [ ] Config file is `nuxt.config.ts` with `extends: ['docus']`
- [ ] Content goes in `content/` directory with number prefixes for ordering (e.g., `1.docs/`, `2.guide/`)
- [ ] Output directory is `.output/public/`
- [ ] Use `nuxt generate` for static build
- [ ] **Homepage is special** - `content/index.md` renders as landing page without sidebar
- [ ] **Documentation pages need subdirectory** - put docs in `content/1.docs/` to get sidebar layout
- [ ] Number prefixes in filenames control order: `1.index.md`, `2.guide.md` → `/index`, `/guide`
- [ ] Use `.navigation.yml` in directories to set section titles
- [ ] Frontmatter `title` is required for each page
- [ ] `app.config.ts` goes in `app/` directory for theme configuration
- [ ] `header.title` and `header.logo` for branding
- [ ] `socials.github` for GitHub link in header
- [ ] Custom components override defaults - put in `app/components/app/`
- [ ] `AppHeaderLogo.vue` - customize logo + title display
- [ ] `AppFooterLeft.vue` - customize footer left (attribution)
- [ ] `AppFooterRight.vue` - customize footer right (social icons, theme toggle)
- [ ] Set empty `AppFooterRight.vue` to remove duplicate theme toggle
- [ ] Logo click should link to `/docs` not `/` (override `AppHeaderLogo.vue` with `<NuxtLink to="/docs">`)
- [ ] Favicon via `app.head.link` in `nuxt.config.ts`
- [ ] **Prerendering issue**: Nuxt only prerenders routes it can crawl from homepage
- [ ] Must explicitly list routes in `nitro.prerender.routes` or generate dynamically
- [ ] Convert filenames to lowercase for routes (uppercase causes 404)
- [ ] Create `index.html` redirect after build for root → `/docs`
- [ ] `robots: { robotsTxt: false }` to avoid base URL error
- [ ] `@nuxtjs/mcp-toolkit` warning is normal - not compatible with static generate

## Undocs Configuration

- [ ] Undocs is a UnJS documentation CLI tool based on Nuxt (MIT license)
- [ ] Install via `pnpm add -D undocs` (requires pnpm)
- [ ] Build command is `undocs build` (not `nuxt generate`)
- [ ] Config file is `.config/docs.yaml` (YAML format)
- [ ] Content goes in root directory with number prefixes (e.g., `1.guide/`, `2.config/`)
- [ ] Output directory is `.output/public/`
- [ ] **Required config fields**: `name`, `github`, `url` (url required for production)
- [ ] `shortDescription` and `description` for SEO
- [ ] `themeColor` for primary color (e.g., 'amber', 'blue')
- [ ] Custom assets go in `.docs/public/` directory
- [ ] Logo is set via `.docs/public/icon.svg`
- [ ] Favicon is set via `.docs/public/favicon.ico`
- [ ] Number prefixes control navigation order: `1.guide/` appears before `2.config/`
- [ ] File naming: `1.index.md`, `2.getting-started.md` → `/guide`, `/guide/getting-started`
- [ ] Frontmatter `title` is recommended for each page
- [ ] GitHub link automatically added from `github` config
- [ ] Landing page features via `landing.features` array in config
- [ ] Hero code block via `landing.heroCode` config
- [ ] Redirects via `redirects` config object
- [ ] Custom icons go in `.docs/icons/` directory (prefix: `custom`)
- [ ] Base URL set via `NUXT_APP_BASE_URL` environment variable
- [ ] Footer attribution requires post-build HTML injection (no built-in config)

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

All workflows must include a footer with attribution: `Powered by NekoTick · {Framework}`

- [ ] NekoTick link: `https://github.com/NekoTick/NekoTick`
- [ ] Framework link: GitHub repository of the framework (not official website)
- [ ] NekoTick comes first (deployment service provider)
- [ ] Framework comes second (underlying tool)
- [ ] Use `·` as separator
- [ ] Links should open in new tab (`target="_blank"`)

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
| VuePress | `https://github.com/vuejs/vuepress` |
| mdBook | `https://github.com/rust-lang/mdBook` |
| Eleventy | `https://github.com/11ty/eleventy` |
| Sphinx | `https://github.com/sphinx-doc/sphinx` |
| Docus | `https://github.com/nuxt-content/docus` |
| Undocs | `https://github.com/unjs/undocs` |

### Logo Implementation Patterns

| Framework | Logo Config |
|-----------|-------------|
| Docusaurus | `navbar.logo.src` + `navbar.title` |
| VitePress | `themeConfig.logo` + `themeConfig.siteTitle` |
| Fumadocs | `nav.title` as JSX with `<img>` + `<span>` |
| Nextra | `Navbar logo` prop as JSX |
| Docute | `logo` as Vue template string |
| DocFX | Custom template JS to replace `#logo` element |
| VuePress | `themeConfig.logo` (external URL supported) |
| Starlight | `logo.src` + `title` |
| Docus | Custom `AppHeaderLogo.vue` with `<NuxtLink>` + `<UColorModeImage>` + `<span>` |
| Undocs | `appConfig.docs.logo` + `appConfig.site.name` (via `.config/docs.yaml`) |

### Sidebar Generation

- [ ] Auto-generate from directory structure when possible
- [ ] Convert filenames to titles: `my-file.md` → `My File`
- [ ] Handle nested directories as collapsible groups
- [ ] Skip `README.md` / `index.md` from sidebar items (they're folder landing pages)
- [ ] Use `sort` for consistent ordering

### Testing Checklist (Updated)

- [ ] Files with invalid image paths (should not break build)
- [ ] Files with special markdown syntax (`${}`, `<>`, `{}`)
- [ ] Empty repository (should show welcome page)
- [ ] Nested folder structure (should generate proper sidebar)
- [ ] Repository without index.md (should use first doc as homepage)

## Multi-Language Support

- [ ] VitePress/Docusaurus i18n is static - requires manual translation files
- [ ] No automatic translation built-in
- [ ] Options: browser translation, or integrate translation API (costs money)
- [ ] Structure: `docs/en/`, `docs/zh/` etc. for each language

## Adding New Framework

When adding a new documentation framework to Docship:

### 1. Create Workflow File

- [ ] Create `.github/workflows/{framework}.yml`
- [ ] Use `on: workflow_call` with `base_path_suffix` and `deploy` inputs
- [ ] Follow existing workflow structure for consistency

### 2. Add Footer Attribution

Every framework MUST include a footer with: `Powered by NekoTick · {Framework}`

- [ ] NekoTick link: `https://github.com/NekoTick/NekoTick`
- [ ] Framework link: GitHub repository of the framework
- [ ] Use `·` (middle dot) as separator
- [ ] Links should open in new tab (`target="_blank"`)

**Footer implementation by framework type:**

| Framework Type | Implementation Method |
|----------------|----------------------|
| Docusaurus | `themeConfig.footer.copyright` |
| VitePress | `themeConfig.footer.message` |
| Docsify | Plugin with `hook.afterEach` |
| Docute | `footer` config option |
| Starlight | Custom Footer.astro component |
| Rspress | `themeConfig.footer.message` |
| MkDocs Material | `copyright` in mkdocs.yml |
| HonKit | JS injection in HTML files |
| DocFX | `_appFooter` in globalMetadata |
| Fumadocs | Footer element in app/layout.tsx |
| Nextra | `footer` prop in Layout component |
| VuePress | enhanceApp.js DOM injection |
| mdBook | Custom theme/index.hbs or theme/head.hbs |
| Eleventy | Custom layout template with footer |
| Sphinx | Custom CSS in _static/custom.css |
| Docus | `footer.credits` in app.config.ts |
| Undocs | Post-build HTML injection (sed) |
| Jekyll | `footer_content` in _config.yml |

### 3. Update Showcase

- [ ] Add build job in `showcase.yml` with `name: {framework}`
- [ ] Add to `needs` array in `combine` job
- [ ] Add build result env variable (e.g., `BUILD_FRAMEWORK`)
- [ ] Add to `RESULTS` array in combine step
- [ ] Add entry in `showcase/frameworks.json` with GitHub link(s)

**frameworks.json format:**
```json
{
  "framework-name": {
    "links": ["https://github.com/org/repo"]
  },
  "framework-with-theme": {
    "links": ["https://github.com/org/framework", "https://github.com/org/theme"]
  }
}
```

### 4. Update Documentation

- [ ] Add framework to README.md supported frameworks table
- [ ] Add framework-specific notes to CHECKLIST.md if needed
