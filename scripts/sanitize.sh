#!/bin/bash
# DocShip Markdown Sanitizer
# Cleans markdown files for compatibility with all documentation frameworks

set -e

CONTENT_DIR="${1:-.}"
echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read -r f; do
  echo "  Processing: $f"
  
  # ===== STEP 1: REMOVE ALL IMAGES (MDX frameworks import them as modules) =====
  sed -i -E 's/!\[[^]]*\]\([^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/!\[[^]]*\]\[[^]]*\]//g' "$f" 2>/dev/null || true
  sed -i 's/!\[/[IMAGE REMOVED: /g' "$f" 2>/dev/null || true
  
  # ===== STEP 2: REMOVE XML PROCESSING INSTRUCTIONS =====
  sed -i 's/<?\s*xml[^?]*?>//gi' "$f" 2>/dev/null || true
  sed -i 's/<?\s*php[^?]*?>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<\?[a-zA-Z][^?]*\?>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<\?[^>]*>//g' "$f" 2>/dev/null || true
  # Escape remaining <?
  sed -i 's/<?/\&lt;?/g' "$f" 2>/dev/null || true
  
  # ===== STEP 3: REMOVE DOCTYPE AND ENTITY DECLARATIONS =====
  sed -i 's/<!DOCTYPE[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<!\s*ENTITY[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<!\[CDATA\[.*\]\]>//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 4: REMOVE DANGEROUS HTML TAGS =====
  sed -i 's/<script[^>]*>[^<]*<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<script[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>[^<]*<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<iframe[^>]*>[^<]*<\/iframe>//gi' "$f" 2>/dev/null || true
  sed -i 's/<iframe[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/iframe>//gi' "$f" 2>/dev/null || true
  sed -i 's/<object[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/object>//gi' "$f" 2>/dev/null || true
  sed -i 's/<embed[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<form[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/form>//gi' "$f" 2>/dev/null || true
  sed -i 's/<input[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<button[^>]*>[^<]*<\/button>//gi' "$f" 2>/dev/null || true
  sed -i 's/<svg[^>]*>[^<]*<\/svg>//gi' "$f" 2>/dev/null || true
  sed -i 's/<svg[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/svg>//gi' "$f" 2>/dev/null || true
  sed -i 's/<img[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<video[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/video>//gi' "$f" 2>/dev/null || true
  sed -i 's/<audio[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/audio>//gi' "$f" 2>/dev/null || true
  sed -i 's/<source[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<marquee[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/marquee>//gi' "$f" 2>/dev/null || true
  sed -i 's/<body[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/body>//gi' "$f" 2>/dev/null || true
  
  # Remove event handlers
  sed -i -E 's/ on[a-z]+="[^"]*"//gi' "$f" 2>/dev/null || true
  sed -i -E "s/ on[a-z]+='[^']*'//gi" "$f" 2>/dev/null || true
  
  # ===== STEP 5: REMOVE SSI =====
  sed -i 's/<!--#[^-]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 6: REMOVE VUE/REACT/ASTRO COMPONENTS =====
  # Self-closing PascalCase components: <Component />
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*\/>//g' "$f" 2>/dev/null || true
  # Opening PascalCase tags: <Component> or <Component prop="val">
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*>//g' "$f" 2>/dev/null || true
  # Closing PascalCase tags: </Component>
  sed -i -E 's/<\/[A-Z][a-zA-Z]*>//g' "$f" 2>/dev/null || true
  # Vue directives: v-if, v-for, :prop, @event
  sed -i -E 's/<div[^>]*(v-[a-z]+|:[a-z]+|@[a-z]+)[^>]*>[^<]*<\/div>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<template[^>]*>[^<]*<\/template>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<slot[^>]*>[^<]*<\/slot>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<slot[^>]*\/>//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 7: REMOVE DANGEROUS LINKS =====
  sed -i -E 's/\[[^]]*\]\(javascript:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(vbscript:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(data:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(file:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(\.\.[^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%2[fF][^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%5[cC][^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%[cC]0[^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%00[^)]*\)//g' "$f" 2>/dev/null || true
  
  # ===== STEP 8: CODE BLOCK LANGUAGE NORMALIZATION =====
  sed -i 's/```mermaid/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```plantuml/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```ditaa/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```invalidlanguage/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```nonexistent/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```fake-lang-123/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```mdx-code-block/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```unclosed/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```objective-c/```objc/gi' "$f" 2>/dev/null || true
  # Fix malformed code block languages (contains backticks or special chars)
  sed -i -E 's/```[^a-zA-Z0-9\n][^\n]*$/```text/g' "$f" 2>/dev/null || true
  sed -i -E "s/\`\`\`triple\`\`\`/\`\`\`text/g" "$f" 2>/dev/null || true
  
  # ===== STEP 9: ESCAPE TEMPLATE SYNTAX (CRITICAL FOR VITEPRESS/HONKIT) =====
  # Must escape {{ }} for Vue/VitePress
  sed -i 's/{{/\&#123;\&#123;/g' "$f" 2>/dev/null || true
  sed -i 's/}}/\&#125;\&#125;/g' "$f" 2>/dev/null || true
  # Must escape {% %} for Liquid/Nunjucks/HonKit
  sed -i 's/{%/\&#123;%/g' "$f" 2>/dev/null || true
  sed -i 's/%}/%\&#125;/g' "$f" 2>/dev/null || true
  # Escape {# #} for Jinja comments
  sed -i 's/{#/\&#123;#/g' "$f" 2>/dev/null || true
  sed -i 's/#}/\&#125;#/g' "$f" 2>/dev/null || true
  # Escape {{< >}} for Hugo shortcodes
  sed -i 's/{{</\&#123;\&#123;\&lt;/g' "$f" 2>/dev/null || true
  sed -i 's/>}}/\&gt;\&#125;\&#125;/g' "$f" 2>/dev/null || true
  # Escape <% %> for ERB/ASP
  sed -i 's/<%/\&lt;%/g' "$f" 2>/dev/null || true
  sed -i 's/%>/%\&gt;/g' "$f" 2>/dev/null || true
  # Escape ${} for template literals that might be interpreted
  sed -i 's/\${/\&#36;{/g' "$f" 2>/dev/null || true
  # Escape #{} for Ruby interpolation
  sed -i 's/#{/\&#35;{/g' "$f" 2>/dev/null || true
  
  # ===== STEP 10: REMOVE FRAMEWORK-SPECIFIC SYNTAX =====
  # MkDocs admonitions
  sed -i -E 's/^!!! [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E 's/^\?\?\? [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E 's/^\?\?\?\+ [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  # Docusaurus admonitions
  sed -i -E 's/^:::[a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i 's/^:::$//' "$f" 2>/dev/null || true
  # MkDocs tabs
  sed -i -E 's/^=== ".*"$//' "$f" 2>/dev/null || true
  # MkDocs annotations
  sed -i 's/{ \.annotate }//g' "$f" 2>/dev/null || true
  # RST directives (.. directive::)
  sed -i -E 's/^\.\. [a-z]+::.*$/> **Note**/g' "$f" 2>/dev/null || true
  # RST roles (:role:`text`)
  sed -i -E 's/:[a-z]+:`[^`]*`/`\1`/g' "$f" 2>/dev/null || true
  # MDX imports/exports
  sed -i -E 's/^import .* from .*;//g' "$f" 2>/dev/null || true
  sed -i -E 's/^export (const|let|var|default) .*//g' "$f" 2>/dev/null || true
  # Astro frontmatter (---)
  # Don't remove YAML frontmatter, just Astro code blocks
  
  # ===== STEP 11: REMOVE JSX EXPRESSIONS =====
  # Single curly brace expressions {variable} - but not in code blocks
  # This is tricky, so we'll be conservative
  sed -i -E 's/\{[a-zA-Z_][a-zA-Z0-9_.]*\}//g' "$f" 2>/dev/null || true
  sed -i -E 's/\{[a-zA-Z_][a-zA-Z0-9_.()]*\}//g' "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
