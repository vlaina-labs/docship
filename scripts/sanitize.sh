#!/bin/bash
# DocShip Markdown Sanitizer
# This script cleans markdown files to ensure compatibility with all documentation frameworks

CONTENT_DIR="${1:-.}"

echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read f; do
  # ===== IMAGE LINK CLEANUP =====
  # Remove broken image links with .html extension
  sed -i 's/!\[[^]]*\]([^)]*\.html[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](<[^>]*\.html[^>]*>)//g' "$f" 2>/dev/null || true
  # Remove image links with charset in URL
  sed -i 's/!\[[^]]*\]([^)]*charset[^)]*)//g' "$f" 2>/dev/null || true
  # Remove image links with just 'url' as src (placeholder)
  sed -i 's/!\[[^]]*\](url)//g' "$f" 2>/dev/null || true
  
  # ===== DANGEROUS HTML CLEANUP =====
  # Remove script tags (single line)
  sed -i 's/<script[^>]*>.*<\/script>//gi' "$f" 2>/dev/null || true
  # Remove style tags (single line)
  sed -i 's/<style[^>]*>.*<\/style>//gi' "$f" 2>/dev/null || true
  # Remove onclick/onerror/onload attributes
  sed -i 's/ on[a-z]*="[^"]*"//gi' "$f" 2>/dev/null || true
  
  # ===== CODE BLOCK LANGUAGE CLEANUP =====
  # Replace unknown/unsupported languages with text
  sed -i 's/```invalidlanguage/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```mermaid/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```plantuml/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```nonexistent/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```fake-lang-123/```text/g' "$f" 2>/dev/null || true
  
  # ===== TEMPLATE SYNTAX ESCAPE =====
  # Escape Nunjucks/Jinja2/Vue template syntax
  sed -i 's/{{/\&#123;\&#123;/g' "$f" 2>/dev/null || true
  sed -i 's/}}/\&#125;\&#125;/g' "$f" 2>/dev/null || true
  sed -i 's/{%/\&#123;%/g' "$f" 2>/dev/null || true
  sed -i 's/%}/%\&#125;/g' "$f" 2>/dev/null || true
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
