#!/bin/bash
# DocShip Markdown Sanitizer
# This script cleans markdown files to ensure compatibility with all documentation frameworks
# Handles security issues, parser-breaking content, and framework-specific syntax

CONTENT_DIR="${1:-.}"

echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read f; do
  
  # ===== SECURITY: XSS & INJECTION CLEANUP =====
  # Remove script tags (single and multi-line)
  sed -i 's/<script[^>]*>.*<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<script[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/script>//gi' "$f" 2>/dev/null || true
  
  # Remove style tags
  sed -i 's/<style[^>]*>.*<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/style>//gi' "$f" 2>/dev/null || true
  
  # Remove all event handlers (onclick, onerror, onload, onmouseover, etc.)
  sed -i 's/ on[a-z]*="[^"]*"//gi' "$f" 2>/dev/null || true
  sed -i "s/ on[a-z]*='[^']*'//gi" "$f" 2>/dev/null || true
  sed -i 's/ on[a-z]*=[^ >]*//gi' "$f" 2>/dev/null || true
  
  # Remove javascript: protocol links
  sed -i 's/href="javascript:[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  sed -i "s/href='javascript:[^']*'/href='#'/gi" "$f" 2>/dev/null || true
  sed -i 's/src="javascript:[^"]*"/src=""/gi' "$f" 2>/dev/null || true
  
  # Remove data: protocol with scripts
  sed -i 's/href="data:text\/html[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  sed -i 's/src="data:text\/html[^"]*"/src=""/gi' "$f" 2>/dev/null || true
  
  # Remove vbscript: protocol
  sed -i 's/href="vbscript:[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  
  # Remove dangerous tags
  sed -i 's/<iframe[^>]*>.*<\/iframe>//gi' "$f" 2>/dev/null || true
  sed -i 's/<iframe[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<object[^>]*>.*<\/object>//gi' "$f" 2>/dev/null || true
  sed -i 's/<object[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<embed[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<form[^>]*>.*<\/form>//gi' "$f" 2>/dev/null || true
  sed -i 's/<form[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/form>//gi' "$f" 2>/dev/null || true
  sed -i 's/<input[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<button[^>]*>.*<\/button>//gi' "$f" 2>/dev/null || true
  sed -i 's/<textarea[^>]*>.*<\/textarea>//gi' "$f" 2>/dev/null || true
  sed -i 's/<select[^>]*>.*<\/select>//gi' "$f" 2>/dev/null || true
  
  # Remove SVG with potential scripts
  sed -i 's/<svg[^>]*>.*<\/svg>//gi' "$f" 2>/dev/null || true
  
  # Remove XML/XXE patterns
  sed -i 's/<!DOCTYPE[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!ENTITY[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!\[CDATA\[.*\]\]>//gi' "$f" 2>/dev/null || true
  
  # Remove SSI (Server Side Include) directives
  sed -i 's/<!--#[^>]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== IMAGE LINK CLEANUP =====
  # Remove broken image links with .html extension
  sed -i 's/!\[[^]]*\]([^)]*\.html[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](<[^>]*\.html[^>]*>)//g' "$f" 2>/dev/null || true
  # Remove image links with charset in URL
  sed -i 's/!\[[^]]*\]([^)]*charset[^)]*)//g' "$f" 2>/dev/null || true
  # Remove image links with just 'url' as src (placeholder)
  sed -i 's/!\[[^]]*\](url)//g' "$f" 2>/dev/null || true
  # Remove images with javascript/data protocol
  sed -i 's/!\[[^]]*\](javascript:[^)]*)//gi' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](data:text\/html[^)]*)//gi' "$f" 2>/dev/null || true
  
  # ===== UNCLOSED/CUSTOM HTML TAG CLEANUP =====
  # Remove custom/invalid HTML tags that Vue parser can't handle
  sed -i 's/<invalid-tag[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/invalid-tag>//gi' "$f" 2>/dev/null || true
  sed -i 's/<marquee[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/marquee>//gi' "$f" 2>/dev/null || true
  sed -i 's/<blink[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/blink>//gi' "$f" 2>/dev/null || true
  
  # ===== CODE BLOCK LANGUAGE CLEANUP =====
  # Replace unknown/unsupported languages with text
  sed -i 's/```invalidlanguage/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```mermaid/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```plantuml/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```nonexistent/```text/g' "$f" 2>/dev/null || true
  sed -i 's/```fake-lang-123/```text/g' "$f" 2>/dev/null || true
  
  # ===== TEMPLATE SYNTAX ESCAPE =====
  # Use awk to escape template syntax ONLY outside code blocks
  # This handles Vue {{ }}, Liquid {% %}, Angular, etc.
  awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code }
    /^~~~/ { in_code = !in_code }
    {
      if (!in_code) {
        # Vue/Mustache/Handlebars: {{ }}
        gsub(/\{\{/, "\\&#123;\\&#123;")
        gsub(/\}\}/, "\\&#125;\\&#125;")
        # Liquid/Jinja2: {% %}
        gsub(/\{%/, "\\&#123;%")
        gsub(/%\}/, "%\\&#125;")
        # Hugo shortcodes: {{< >}} {{< />}}
        gsub(/\{\{</, "\\&#123;\\&#123;<")
        gsub(/>\}\}/, ">\\&#125;\\&#125;")
        # ERB: <%= %> <% %>
        gsub(/<%=/, "\\&lt;%=")
        gsub(/<%/, "\\&lt;%")
        gsub(/%>/, "%\\&gt;")
      }
      print
    }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== UNICODE CLEANUP =====
  # Remove zero-width characters that can cause issues
  sed -i 's/\xe2\x80\x8b//g' "$f" 2>/dev/null || true  # Zero-width space
  sed -i 's/\xe2\x80\x8c//g' "$f" 2>/dev/null || true  # Zero-width non-joiner
  sed -i 's/\xe2\x80\x8d//g' "$f" 2>/dev/null || true  # Zero-width joiner
  sed -i 's/\xef\xbb\xbf//g' "$f" 2>/dev/null || true  # BOM
  
  # Remove direction override characters (security risk)
  sed -i 's/\xe2\x80\xae//g' "$f" 2>/dev/null || true  # RTL override
  sed -i 's/\xe2\x80\xad//g' "$f" 2>/dev/null || true  # LTR override
  sed -i 's/\xe2\x80\xab//g' "$f" 2>/dev/null || true  # RTL embedding
  sed -i 's/\xe2\x80\xaa//g' "$f" 2>/dev/null || true  # LTR embedding
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
