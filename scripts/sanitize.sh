#!/bin/bash
# DocShip Markdown Sanitizer
# This script cleans markdown files to ensure compatibility with all documentation frameworks

CONTENT_DIR="${1:-.}"

echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read f; do
  
  # ===== SECURITY: XSS & INJECTION CLEANUP =====
  sed -i 's/<script[^>]*>.*<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<script[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>.*<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/style>//gi' "$f" 2>/dev/null || true
  
  # Remove event handlers
  sed -i 's/ on[a-z]*="[^"]*"//gi' "$f" 2>/dev/null || true
  sed -i "s/ on[a-z]*='[^']*'//gi" "$f" 2>/dev/null || true
  
  # Remove dangerous protocols
  sed -i 's/href="javascript:[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  sed -i 's/href="vbscript:[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  sed -i 's/href="data:text\/html[^"]*"/href="#"/gi' "$f" 2>/dev/null || true
  
  # Remove dangerous HTML tags
  for tag in iframe object embed form button textarea select svg video audio source marquee blink; do
    sed -i "s/<${tag}[^>]*>//gi" "$f" 2>/dev/null || true
    sed -i "s/<\/${tag}>//gi" "$f" 2>/dev/null || true
  done
  
  # Remove XML processing instructions (<?xml, <?php, etc.)
  sed -i 's/<?[a-z][^>]*?>//gi' "$f" 2>/dev/null || true
  sed -i 's/<?[a-z][^>]*>//gi' "$f" 2>/dev/null || true
  
  # Remove DOCTYPE, ENTITY, CDATA
  sed -i 's/<!DOCTYPE[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!ENTITY[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!\[CDATA\[.*\]\]>//gi' "$f" 2>/dev/null || true
  
  # Remove SSI directives
  sed -i 's/<!--#[^>]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== IMAGE LINK CLEANUP =====
  sed -i 's/!\[[^]]*\]([^)]*\.html[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\]([^)]*charset[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](url)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](javascript:[^)]*)//gi' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](data:text\/html[^)]*)//gi' "$f" 2>/dev/null || true
  # Remove images with simple placeholder URLs like url1, url2, etc. (causes MDX import errors)
  sed -i 's/!\[[^]]*\](url[0-9]*)//g' "$f" 2>/dev/null || true
  # Remove images with path traversal
  sed -i 's/!\[[^]]*\](\.\.[^)]*)//g' "$f" 2>/dev/null || true
  
  # ===== LINK CLEANUP =====
  # Remove links with path traversal attempts
  sed -i 's/\[[^]]*\](\.\.[^)]*)//g' "$f" 2>/dev/null || true
  # Remove links with encoded path traversal (%2F, %c0%af, etc.)
  sed -i 's/\[[^]]*\]([^)]*%[0-9a-fA-F][0-9a-fA-F]%[0-9a-fA-F][0-9a-fA-F][^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/\[[^]]*\]([^)]*%c0%[0-9a-fA-F][0-9a-fA-F][^)]*)//gi' "$f" 2>/dev/null || true
  
  # ===== VUE COMPONENT CLEANUP =====
  # Remove Vue 3 built-in components that break parsers
  for comp in Suspense KeepAlive Teleport Transition TransitionGroup; do
    sed -i "s/<${comp}[^>]*>//gi" "$f" 2>/dev/null || true
    sed -i "s/<\/${comp}>//gi" "$f" 2>/dev/null || true
  done
  
  # Remove custom components (PascalCase tags)
  sed -i 's/<[A-Z][a-zA-Z]*[^>]*\/>//g' "$f" 2>/dev/null || true
  sed -i 's/<[A-Z][a-zA-Z]*[^>]*>//g' "$f" 2>/dev/null || true
  sed -i 's/<\/[A-Z][a-zA-Z]*>//g' "$f" 2>/dev/null || true
  
  # Remove kebab-case custom components
  sed -i 's/<[a-z]*-[a-z][a-z-]*[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/[a-z]*-[a-z][a-z-]*>//gi' "$f" 2>/dev/null || true
  
  # ===== MKDOCS/DOCUSAURUS ADMONITION CLEANUP =====
  # Convert MkDocs admonitions to blockquotes
  sed -i 's/^!!! \([a-z]*\).*$/> **\1**/gi' "$f" 2>/dev/null || true
  sed -i 's/^??? \([a-z]*\).*$/> **\1**/gi' "$f" 2>/dev/null || true
  sed -i 's/^???+ \([a-z]*\).*$/> **\1**/gi' "$f" 2>/dev/null || true
  
  # Remove Docusaurus admonitions (:::note, :::tip, etc.)
  sed -i 's/^:::[a-z]*.*$/> **Note**/gi' "$f" 2>/dev/null || true
  sed -i 's/^:::$//' "$f" 2>/dev/null || true
  
  # Remove MkDocs tabs syntax
  sed -i 's/^=== ".*"$//' "$f" 2>/dev/null || true
  
  # Remove MkDocs annotations
  sed -i 's/{ \.annotate }//' "$f" 2>/dev/null || true
  
  # ===== CODE BLOCK CLEANUP =====
  # Use awk to normalize code block languages
  awk '
    /^```[a-zA-Z]/ {
      # Extract language
      match($0, /^```([a-zA-Z0-9_+#.-]*)/, arr)
      lang = tolower(arr[1])
      
      # List of problematic languages to replace
      if (lang == "mermaid" || lang == "plantuml" || lang == "ditaa" || \
          lang == "mdx-code-block" || lang == "unclosed" || \
          lang ~ /```$/ || lang ~ /^text```/ || lang ~ /^triple/) {
        sub(/^```[a-zA-Z0-9_+#.-]*/, "```text")
      }
      # objective-c -> objc (more compatible)
      if (lang == "objective-c") {
        sub(/^```objective-c/, "```objc")
      }
    }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== TEMPLATE SYNTAX ESCAPE =====
  awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code }
    /^~~~/ { in_code = !in_code }
    {
      if (!in_code) {
        # Vue/Mustache: {{ }}
        gsub(/\{\{/, "\\&#123;\\&#123;")
        gsub(/\}\}/, "\\&#125;\\&#125;")
        # Liquid/Jinja2: {% %}
        gsub(/\{%/, "\\&#123;%")
        gsub(/%\}/, "%\\&#125;")
        # Hugo: {{< >}}
        gsub(/\{\{</, "\\&#123;\\&#123;<")
        gsub(/>\}\}/, ">\\&#125;\\&#125;")
      }
      print
    }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== UNICODE CLEANUP =====
  # Remove zero-width and direction override characters
  sed -i 's/\xe2\x80\x8b//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\x8c//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\x8d//g' "$f" 2>/dev/null || true
  sed -i 's/\xef\xbb\xbf//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xae//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xad//g' "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
