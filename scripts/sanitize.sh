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
  
  # ===== STEP 6.5: REMOVE VUE DIRECTIVES FROM HTML TAGS =====
  # Remove entire tags with Vue directives (v-if, v-for, v-bind, v-on, v-model, v-slot, etc.)
  sed -i -E 's/<div[^>]*(v-if|v-for|v-bind|v-on|v-model|v-slot|v-show|v-html|v-text|v-pre|v-cloak|v-once)[^>]*>[^<]*<\/div>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*(v-if|v-for|v-bind|v-on|v-model|v-slot|v-show|v-html|v-text|v-pre|v-cloak|v-once)[^>]*>[^<]*<\/[a-z]+>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*(v-if|v-for|v-bind|v-on|v-model|v-slot|v-show)[^>]*>//gi' "$f" 2>/dev/null || true
  # Remove tags with Vue shorthand syntax (:prop, @event, #slot)
  sed -i -E 's/<div[^>]*(:[a-z]+|@[a-z]+|#[a-z]+)="[^"]*"[^>]*>[^<]*<\/div>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*(:[a-z]+|@[a-z]+|#[a-z]+)="[^"]*"[^>]*>//gi' "$f" 2>/dev/null || true
  # Remove Angular directives (*ngIf, *ngFor, [ngClass], (click), [(ngModel)])
  sed -i -E 's/<[a-z]+[^>]*(\*ng[A-Z][a-z]+|\[ng[A-Z][a-z]+\]|\([a-z]+\)|\[\([a-z]+\)\])[^>]*>//gi' "$f" 2>/dev/null || true
  
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
  # Handle malformed code blocks like ```triple``` or ```inner
  sed -i "s/\`\`\`triple\`\`\`/\`\`\`text/g" "$f" 2>/dev/null || true
  sed -i "s/\`\`\`triple backtick\`\`\`/\`\`\`text/g" "$f" 2>/dev/null || true
  sed -i "s/\`\`\`inner/\`\`\`text/g" "$f" 2>/dev/null || true
  # Handle C++, C#, F# which may cause issues
  sed -i 's/```c++/```cpp/gi' "$f" 2>/dev/null || true
  sed -i 's/```c#/```csharp/gi' "$f" 2>/dev/null || true
  sed -i 's/```f#/```fsharp/gi' "$f" 2>/dev/null || true
  # Handle code blocks with attributes like ```js {1,3-5} showLineNumbers
  sed -i -E 's/```([a-z]+) \{[^}]*\}[^`]*/```\1/gi' "$f" 2>/dev/null || true
  # Handle code blocks with title like ```jsx title="..."
  sed -i -E 's/```([a-z]+) title="[^"]*"/```\1/gi' "$f" 2>/dev/null || true
  
  # ===== STEP 9: REMOVE TEMPLATE SYNTAX (NUCLEAR OPTION) =====
  # Use awk to process file, removing ALL template syntax OUTSIDE code blocks
  # This is aggressive but necessary for Vue/Nunjucks/Liquid compatibility
  awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code; print; next }
    {
      if (!in_code) {
        # First pass: remove complete patterns
        gsub(/\{\{<[^>]*>\}\}/, "")
        gsub(/\{\{[^}]*\}\}/, "")
        gsub(/\{%[^%]*%\}/, "")
        gsub(/\{#[^#]*#\}/, "")
        # Second pass: remove any remaining braces (handles nested/malformed)
        # Keep removing until no more {{ or {% exist
        while (match($0, /\{\{/) || match($0, /\{%/)) {
          gsub(/\{\{/, "")
          gsub(/\}\}/, "")
          gsub(/\{%/, "")
          gsub(/%\}/, "")
        }
        # Also remove Hugo shortcode syntax {{< >}}
        gsub(/\{\{</, "")
        gsub(/>\}\}/, "")
        # Remove any orphaned }} or %}
        gsub(/\}\}/, "")
        gsub(/%\}/, "")
      }
      print
    }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== STEP 10: ESCAPE <% %> (ERB/ASP) =====
  sed -i 's/<%/\&lt;%/g' "$f" 2>/dev/null || true
  sed -i 's/%>/%\&gt;/g' "$f" 2>/dev/null || true
  
  # ===== STEP 11: REMOVE FRAMEWORK-SPECIFIC SYNTAX =====
  sed -i -E 's/^!!! [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E 's/^\?\?\? [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E 's/^\?\?\?\+ [a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E 's/^:::[a-z].*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i 's/^:::$//' "$f" 2>/dev/null || true
  sed -i -E 's/^=== ".*"$//' "$f" 2>/dev/null || true
  sed -i 's/{ \.annotate }//g' "$f" 2>/dev/null || true
  sed -i -E 's/^\.\. [a-z]+::.*$/> **Note**/g' "$f" 2>/dev/null || true
  sed -i -E "s/^import .+ from ['\"].*['\"];?$//g" "$f" 2>/dev/null || true
  sed -i -E 's/^export (const|let|var|default) .*//g' "$f" 2>/dev/null || true
  
  # ===== STEP 12: REMOVE JSX EXPRESSIONS =====
  sed -i -E 's/^\{[a-zA-Z_][a-zA-Z0-9_. ()]*\}$//g' "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
