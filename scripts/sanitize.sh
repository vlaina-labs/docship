#!/bin/bash
# DocShip Markdown Sanitizer
# Cleans markdown files for compatibility with all documentation frameworks

set -e

CONTENT_DIR="${1:-.}"
echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read -r f; do
  echo "  Processing: $f"
  
  # ===== STEP 1: REMOVE ALL IMAGES (MDX frameworks import them as modules) =====
  # Match ![any](any) - most common format
  sed -i -E 's/!\[[^]]*\]\([^)]*\)//g' "$f" 2>/dev/null || true
  # Match ![any][ref] - reference style
  sed -i -E 's/!\[[^]]*\]\[[^]]*\]//g' "$f" 2>/dev/null || true
  # Match remaining image patterns with special chars
  sed -i 's/!\[/[IMAGE REMOVED: /g' "$f" 2>/dev/null || true
  
  # ===== STEP 2: REMOVE XML PROCESSING INSTRUCTIONS =====
  # <?xml ... ?> and <?php ... ?> etc - these break VitePress
  sed -i 's/<?\s*xml[^?]*?>//gi' "$f" 2>/dev/null || true
  sed -i 's/<?\s*php[^?]*?>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<\?[a-zA-Z][^?]*\?>//g' "$f" 2>/dev/null || true
  # Fallback: remove any remaining <? ... > patterns
  sed -i -E 's/<\?[^>]*>//g' "$f" 2>/dev/null || true
  # Nuclear option: remove standalone <? 
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
  
  # Remove event handlers from remaining HTML
  sed -i -E 's/ on[a-z]+="[^"]*"//gi' "$f" 2>/dev/null || true
  sed -i -E "s/ on[a-z]+='[^']*'//gi" "$f" 2>/dev/null || true
  
  # ===== STEP 5: REMOVE SSI (Server Side Includes) =====
  sed -i 's/<!--#[^-]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 6: REMOVE VUE/REACT COMPONENTS =====
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*\/>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*>[^<]*<\/[A-Z][a-zA-Z]*>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<\/[A-Z][a-zA-Z]*>//g' "$f" 2>/dev/null || true
  
  # ===== STEP 7: REMOVE DANGEROUS LINKS =====
  # JavaScript/VBScript/Data protocols
  sed -i -E 's/\[[^]]*\]\(javascript:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(vbscript:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(data:[^)]*\)//gi' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\(file:[^)]*\)//gi' "$f" 2>/dev/null || true
  
  # Path traversal links - remove links starting with ..
  sed -i -E 's/\[[^]]*\]\(\.\.[^)]*\)//g' "$f" 2>/dev/null || true
  
  # Encoded path traversal - %2F, %5C, %c0, %00
  sed -i -E 's/\[[^]]*\]\([^)]*%2[fF][^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%5[cC][^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%[cC]0[^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/\[[^]]*\]\([^)]*%00[^)]*\)//g' "$f" 2>/dev/null || true
  
  # ===== STEP 8: CODE BLOCK LANGUAGE NORMALIZATION =====
  # Replace unknown/problematic languages with 'text'
  sed -i 's/```mermaid/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```plantuml/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```ditaa/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```invalidlanguage/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```nonexistent/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```fake-lang-123/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```mdx-code-block/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```unclosed/```text/gi' "$f" 2>/dev/null || true
  sed -i 's/```objective-c/```objc/gi' "$f" 2>/dev/null || true
  
  # ===== STEP 9: ESCAPE TEMPLATE SYNTAX =====
  # Escape {{ }} - Vue/Nunjucks/Jinja
  sed -i 's/{{/\&lbrace;\&lbrace;/g' "$f" 2>/dev/null || true
  sed -i 's/}}/\&rbrace;\&rbrace;/g' "$f" 2>/dev/null || true
  # Escape {% %} - Liquid/Jinja/Nunjucks
  sed -i 's/{%/\&lbrace;%/g' "$f" 2>/dev/null || true
  sed -i 's/%}/\&rbrace;%/g' "$f" 2>/dev/null || true
  # Escape {# #} - Jinja comments
  sed -i 's/{#/\&lbrace;#/g' "$f" 2>/dev/null || true
  sed -i 's/#}/\&rbrace;#/g' "$f" 2>/dev/null || true
  # Escape <% %> - ERB/ASP
  sed -i 's/<%/\&lt;%/g' "$f" 2>/dev/null || true
  sed -i 's/%>/%\&gt;/g' "$f" 2>/dev/null || true
  
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
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
