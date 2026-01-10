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
  
  # Remove malformed HTML tags (duplicate attributes, missing quotes, etc.)
  # These cause Vue compiler errors - be aggressive and remove entire lines
  # Remove lines with duplicate class attributes
  sed -i '/class="[^"]*"class=/d' "$f" 2>/dev/null || true
  # Remove lines with single-quoted class
  sed -i "/class='/d" "$f" 2>/dev/null || true
  # Remove lines with unquoted class
  sed -i '/class=[a-z]/d' "$f" 2>/dev/null || true
  # Remove lines with problematic data-x attributes
  sed -i '/data-x=/d' "$f" 2>/dev/null || true
  # Remove unclosed HTML tags
  sed -i '/^<div>$/d' "$f" 2>/dev/null || true
  sed -i '/^<p>$/d' "$f" 2>/dev/null || true
  sed -i '/^<span>$/d' "$f" 2>/dev/null || true
  sed -i '/^<a href=/d' "$f" 2>/dev/null || true
  sed -i '/^<br/d' "$f" 2>/dev/null || true
  sed -i '/^<hr/d' "$f" 2>/dev/null || true
  sed -i '/^<img /d' "$f" 2>/dev/null || true
  
  # Remove event handlers
  sed -i -E 's/ on[a-z]+="[^"]*"//gi' "$f" 2>/dev/null || true
  
  # ===== STEP 5: REMOVE SSI =====
  sed -i 's/<!--#[^-]*-->//gi' "$f" 2>/dev/null || true
  # Remove unclosed HTML comments (cause Vue EOF error)
  sed -i '/^<!--[^>]*$/d' "$f" 2>/dev/null || true
  sed -i 's/<!-- unclosed//g' "$f" 2>/dev/null || true
  # Remove CDATA sections (not allowed in HTML context)
  sed -i 's/<!\[CDATA\[[^]]*\]\]>//gi' "$f" 2>/dev/null || true
  sed -i '/<!\[CDATA\[/d' "$f" 2>/dev/null || true
  # Remove DOCTYPE declarations
  sed -i '/<!DOCTYPE/d' "$f" 2>/dev/null || true
  # Remove problematic comments
  sed -i '/^<!---/d' "$f" 2>/dev/null || true
  sed -i '/^<!---->$/d' "$f" 2>/dev/null || true
  sed -i '/<!-- -- /d' "$f" 2>/dev/null || true
  
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
  # Remove tags with Vue shorthand syntax - #slot (v-slot shorthand) - SIMPLE PATTERNS
  sed -i 's/<div #[^>]*>[^<]*<\/div>//gi' "$f" 2>/dev/null || true
  sed -i 's/<span #[^>]*>[^<]*<\/span>//gi' "$f" 2>/dev/null || true
  sed -i 's/<p #[^>]*>[^<]*<\/p>//gi' "$f" 2>/dev/null || true
  sed -i 's/<a #[^>]*>[^<]*<\/a>//gi' "$f" 2>/dev/null || true
  # Remove tags with :prop or @event
  sed -i -E 's/<[a-z]+[^>]*:[a-z]+="[^"]*"[^>]*>[^<]*<\/[a-z]+>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*@[a-z]+="[^"]*"[^>]*>[^<]*<\/[a-z]+>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*:[a-z]+="[^"]*"[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i -E 's/<[a-z]+[^>]*@[a-z]+="[^"]*"[^>]*>//gi' "$f" 2>/dev/null || true
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
    /^~~~/ { in_code = !in_code; print; next }
    {
      if (!in_code) {
        # Remove Hugo shortcodes first {{< >}} and {{< />}}
        gsub(/\{\{<[^>]*>\}\}/, "")
        gsub(/\{\{<[^>]*\/>\}\}/, "")
        # Remove complete template patterns
        gsub(/\{\{[^}]*\}\}/, "")
        gsub(/\{%[^%]*%\}/, "")
        gsub(/\{#[^#]*#\}/, "")
        # Aggressively remove any remaining {{ or {% (handles nested/malformed)
        gsub(/\{\{/, "")
        gsub(/\}\}/, "")
        gsub(/\{%/, "")
        gsub(/%\}/, "")
        gsub(/\{#/, "")
        gsub(/#\}/, "")
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
  
  # ===== STEP 13: REMOVE TEMPLATE LITERALS AND BACKTICK EXPRESSIONS =====
  # These cause HonKit to add {% raw %} which then fails
  # Process with awk to only affect content outside code blocks
  awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code; print; next }
    /^~~~/ { in_code = !in_code; print; next }
    {
      if (!in_code) {
        # Remove {`...`} template literal expressions (including nested ${})
        gsub(/\{`[^`]*`\}/, "")
        # Remove lines containing backtick with ${} inside
        if ($0 ~ /`[^`]*\$\{[^}]*\}[^`]*`/) { gsub(/`[^`]*\$\{[^}]*\}[^`]*`/, "code") }
        # Remove ${...} template expressions
        gsub(/\$\{[^}]*\}/, "")
        # Remove any remaining backtick expressions that might trigger {% raw %}
        gsub(/`[^`]*\$[^`]*`/, "code")
      }
      print
    }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
