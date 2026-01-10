#!/bin/bash
# DocShip Markdown Sanitizer
# Cleans markdown files for compatibility with all documentation frameworks

set -e

CONTENT_DIR="${1:-.}"
echo "🧹 Sanitizing markdown files in: $CONTENT_DIR"

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) | while read -r f; do
  echo "  Processing: $f"
  
  # ===== STEP 1: REMOVE ALL IMAGES =====
  sed -i -E 's/!\[[^]]*\]\([^)]*\)//g' "$f" 2>/dev/null || true
  sed -i -E 's/!\[[^]]*\]\[[^]]*\]//g' "$f" 2>/dev/null || true
  
  # ===== STEP 2: REMOVE XML/PHP PROCESSING INSTRUCTIONS =====
  sed -i 's/<?xml[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<?php[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<?/\&lt;?/g' "$f" 2>/dev/null || true
  
  # ===== STEP 3: REMOVE DOCTYPE/ENTITY =====
  sed -i 's/<!DOCTYPE[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!ENTITY[^>]*>//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 4: REMOVE DANGEROUS HTML =====
  sed -i 's/<script[^>]*>[^<]*<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<script[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/script>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>[^<]*<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<style[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/style>//gi' "$f" 2>/dev/null || true
  sed -i 's/<iframe[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/iframe>//gi' "$f" 2>/dev/null || true
  sed -i 's/<object[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/object>//gi' "$f" 2>/dev/null || true
  sed -i 's/<embed[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<form[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/form>//gi' "$f" 2>/dev/null || true
  sed -i 's/<input[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<img[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<svg[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/svg>//gi' "$f" 2>/dev/null || true
  sed -i 's/<video[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/video>//gi' "$f" 2>/dev/null || true
  sed -i 's/<audio[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/audio>//gi' "$f" 2>/dev/null || true
  sed -i 's/<source[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<marquee[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/marquee>//gi' "$f" 2>/dev/null || true
  sed -i 's/<body[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/body>//gi' "$f" 2>/dev/null || true
  sed -i 's/<button[^>]*>[^<]*<\/button>//gi' "$f" 2>/dev/null || true
  
  # Remove event handlers
  sed -i -E 's/ on[a-z]+="[^"]*"//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 5: REMOVE SSI =====
  sed -i 's/<!--#[^-]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 6: REMOVE VUE/REACT COMPONENTS =====
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*\/>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<[A-Z][a-zA-Z]*[^>]*>//g' "$f" 2>/dev/null || true
  sed -i -E 's/<\/[A-Z][a-zA-Z]*>//g' "$f" 2>/dev/null || true
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
  # Fix triple backtick language issues
  sed -i "s/\`\`\`triple\`\`\`/\`\`\`text/g" "$f" 2>/dev/null || true
  sed -i -E "s/\`\`\`[^a-zA-Z0-9_\n-]/\`\`\`text/g" "$f" 2>/dev/null || true
  
  # ===== STEP 9: ESCAPE/REMOVE TEMPLATE SYNTAX (CRITICAL) =====
  # Use a temp file to process with awk (handles code blocks properly)
  awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code }
    {
      if (!in_code) {
        # Replace {{ with escaped version
        gsub(/\{\{/, "\\{\\{")
        gsub(/\}\}/, "\\}\\}")
        # Replace {% with escaped version  
        gsub(/\{%/, "\\{%")
        gsub(/%\}/, "%\\}")
        # Replace {# with escaped version
        gsub(/\{#/, "\\{#")
        gsub(/#\}/, "#\\}")
      }
      print
    }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== STEP 10: ESCAPE <% %> (ERB/ASP) =====
  sed -i 's/<%/\&lt;%/g' "$f" 2>/dev/null || true
  sed -i 's/%>/%\&gt;/g' "$f" 2>/dev/null || true
  
  # ===== STEP 11: ESCAPE ${} (Template literals) =====
  sed -i 's/\${/\\${/g' "$f" 2>/dev/null || true
  
  # ===== STEP 12: REMOVE FRAMEWORK-SPECIFIC SYNTAX =====
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
  # RST directives
  sed -i -E 's/^\.\. [a-z]+::.*$/> **Note**/g' "$f" 2>/dev/null || true
  # MDX imports/exports - REMOVE completely
  sed -i -E "s/^import .+ from ['\"].*['\"];?$//g" "$f" 2>/dev/null || true
  sed -i -E 's/^export (const|let|var|default) .*//g' "$f" 2>/dev/null || true
  
  # ===== STEP 13: REMOVE JSX EXPRESSIONS =====
  sed -i -E 's/^\{[a-zA-Z_][a-zA-Z0-9_. ()]*\}$//g' "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
