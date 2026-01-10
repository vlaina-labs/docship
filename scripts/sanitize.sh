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
  
  # Remove dangerous HTML tags completely (opening and closing)
  for tag in iframe object embed form button textarea select svg video audio source img marquee blink body input; do
    sed -i "s/<${tag}[^>]*>//gi" "$f" 2>/dev/null || true
    sed -i "s/<\/${tag}>//gi" "$f" 2>/dev/null || true
  done
  
  # Remove XML/XXE patterns
  sed -i 's/<!DOCTYPE[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!ENTITY[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<!\[CDATA\[.*\]\]>//gi' "$f" 2>/dev/null || true
  
  # Remove SSI (Server Side Include) directives
  sed -i 's/<!--#[^>]*-->//gi' "$f" 2>/dev/null || true
  
  # ===== IMAGE LINK CLEANUP =====
  sed -i 's/!\[[^]]*\]([^)]*\.html[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](<[^>]*\.html[^>]*>)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\]([^)]*charset[^)]*)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](url)//g' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](javascript:[^)]*)//gi' "$f" 2>/dev/null || true
  sed -i 's/!\[[^]]*\](data:text\/html[^)]*)//gi' "$f" 2>/dev/null || true
  
  # ===== CUSTOM HTML TAG CLEANUP =====
  sed -i 's/<invalid-tag[^>]*>//gi' "$f" 2>/dev/null || true
  sed -i 's/<\/invalid-tag>//gi' "$f" 2>/dev/null || true
  
  # ===== CODE BLOCK LANGUAGE CLEANUP =====
  # Use awk to normalize ALL code block languages
  # Replace any unknown/problematic language with 'text'
  awk '
    BEGIN {
      # Known safe languages
      split("text txt plain bash sh shell zsh fish powershell ps1 cmd batch " \
            "javascript js jsx ts typescript tsx mjs cjs " \
            "python py python3 ruby rb perl php php3 php4 php5 php7 php8 " \
            "java kotlin scala groovy clojure " \
            "c cpp cxx cc h hpp hxx hh cs csharp fsharp fs vb vbnet " \
            "go golang rust rs swift " \
            "html htm xml xhtml svg xsl xslt dtd " \
            "css scss sass less stylus " \
            "json json5 jsonc yaml yml toml ini cfg conf config properties " \
            "sql mysql postgresql postgres sqlite oracle plsql tsql " \
            "markdown md mdx rst restructuredtext asciidoc adoc " \
            "diff patch " \
            "docker dockerfile makefile make cmake " \
            "nginx apache htaccess " \
            "graphql gql " \
            "latex tex bibtex " \
            "r rlang matlab octave julia " \
            "lua moonscript " \
            "haskell hs elm purescript purs " \
            "erlang elixir ex exs " \
            "ocaml ml sml fsharp " \
            "lisp scheme racket clj cljs " \
            "prolog " \
            "fortran f90 f95 f03 f08 " \
            "cobol " \
            "pascal delphi " \
            "ada " \
            "d dlang " \
            "nim " \
            "crystal cr " \
            "zig " \
            "v vlang " \
            "dart " \
            "solidity sol " \
            "vyper " \
            "move " \
            "wasm wat " \
            "asm assembly nasm masm gas " \
            "llvm ir " \
            "glsl hlsl wgsl " \
            "cuda opencl " \
            "terraform tf hcl " \
            "puppet " \
            "ansible " \
            "vagrant " \
            "helm " \
            "kustomize " \
            "jsonnet " \
            "cue " \
            "dhall " \
            "nix " \
            "bazel starlark bzl " \
            "gradle " \
            "maven pom " \
            "ant " \
            "sbt " \
            "cargo " \
            "npm " \
            "yarn " \
            "pnpm " \
            "pip " \
            "poetry " \
            "conda " \
            "gem " \
            "bundler " \
            "composer " \
            "nuget " \
            "hex " \
            "opam " \
            "cabal " \
            "stack " \
            "lein " \
            "boot " \
            "rebar " \
            "mix " \
            "dune " \
            "esy " \
            "bsb " \
            "dub " \
            "nimble " \
            "shards " \
            "vcpkg " \
            "conan " \
            "meson " \
            "xmake " \
            "premake " \
            "gn " \
            "gyp " \
            "waf " \
            "scons " \
            "rake " \
            "gulp " \
            "grunt " \
            "webpack " \
            "rollup " \
            "vite " \
            "esbuild " \
            "parcel " \
            "snowpack " \
            "rome " \
            "turbopack " \
            "swc " \
            "babel " \
            "tsc " \
            "vue " \
            "svelte " \
            "astro " \
            "angular " \
            "react " \
            "preact " \
            "solid " \
            "qwik " \
            "marko " \
            "riot " \
            "alpine " \
            "htmx " \
            "erb " \
            "ejs " \
            "pug jade " \
            "haml " \
            "slim " \
            "blade " \
            "twig " \
            "jinja jinja2 " \
            "liquid " \
            "mustache " \
            "handlebars hbs " \
            "nunjucks njk " \
            "eta " \
            "dot " \
            "velocity vtl " \
            "freemarker ftl " \
            "thymeleaf " \
            "jsp " \
            "asp aspx " \
            "razor cshtml " \
            "http " \
            "graphql " \
            "protobuf proto " \
            "thrift " \
            "avro " \
            "capnproto " \
            "flatbuffers " \
            "msgpack " \
            "cbor " \
            "bson " \
            "ion " \
            "edn " \
            "rison " \
            "hjson " \
            "json5 " \
            "cson " \
            "kdl " \
            "sdl " \
            "ogdl " \
            "ucl " \
            "hocon " \
            "libconfig " \
            "dotenv env " \
            "editorconfig " \
            "gitignore " \
            "gitattributes " \
            "gitmodules " \
            "gitconfig " \
            "hgignore " \
            "svnignore " \
            "npmignore " \
            "dockerignore " \
            "prettierignore " \
            "eslintignore " \
            "stylelintignore " \
            "log " \
            "csv tsv " \
            "regex regexp " \
            "cron " \
            "ssh sshconfig " \
            "gpg " \
            "pem crt cer key pub " \
            "applescript scpt " \
            "vimscript vim " \
            "emacslisp elisp el " \
            "fish " \
            "tcl tk " \
            "awk gawk " \
            "sed " \
            "jq " \
            "yq " \
            "xq " \
            "fq " \
            "mlir " \
            "circom " \
            "cairo " \
            "noir " \
            "leo " \
            "aleo " \
            "sway " \
            "fuel " \
            "ink " \
            "ask " \
            "scilla " \
            "ligo " \
            "michelson " \
            "yul " \
            "huff " \
            "fe " \
            "objc objectivec objective-c m mm " \
            "console output terminal " \
            "diff patch unified context " \
            "abnf ebnf bnf peg " \
            "dot graphviz " \
            "mermaid plantuml ditaa " \
            "abc lilypond musicxml " \
            "csv tsv ssv " \
            "properties " \
            "ignore " \
            "hosts " \
            "crontab " \
            "fstab " \
            "passwd shadow group " \
            "sudoers " \
            "systemd service timer socket " \
            "unit " \
            "desktop " \
            "mime " \
            "xdefaults xresources " \
            "gtkrc " \
            "kdeglobals " \
            "dconf " \
            "gsettings " \
            "plist " \
            "reg registry " \
            "inf " \
            "msi " \
            "wix " \
            "nsi nsis " \
            "iss innosetup " \
            "spec rpm " \
            "deb control " \
            "ebuild " \
            "pkgbuild " \
            "apkbuild " \
            "snapcraft " \
            "flatpak " \
            "appimage " \
            "dmg " \
            "pkg " \
            "msi " \
            "exe " \
            "elf " \
            "macho " \
            "pe coff " \
            "ar " \
            "cpio " \
            "tar " \
            "zip " \
            "gzip gz " \
            "bzip2 bz2 " \
            "xz lzma " \
            "zstd zst " \
            "lz4 " \
            "snappy " \
            "brotli br " \
            "7z " \
            "rar " \
            "cab " \
            "iso " \
            "squashfs " \
            "erofs " \
            "btrfs " \
            "zfs " \
            "xfs " \
            "ext4 " \
            "ntfs " \
            "fat32 " \
            "exfat " \
            "hfs " \
            "apfs", known, " ")
      for (i in known) safe[known[i]] = 1
    }
    /^```/ {
      if (match($0, /^```([a-zA-Z0-9_+#.-]*)/, arr)) {
        lang = tolower(arr[1])
        if (lang != "" && !(lang in safe)) {
          sub(/^```[a-zA-Z0-9_+#.-]*/, "```text")
        }
      }
    }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f" 2>/dev/null || true
  
  # ===== TEMPLATE SYNTAX ESCAPE =====
  # Use awk to escape template syntax ONLY outside code blocks
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
        # Hugo shortcodes: {{< >}}
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
  # Remove zero-width and direction override characters
  sed -i 's/\xe2\x80\x8b//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\x8c//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\x8d//g' "$f" 2>/dev/null || true
  sed -i 's/\xef\xbb\xbf//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xae//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xad//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xab//g' "$f" 2>/dev/null || true
  sed -i 's/\xe2\x80\xaa//g' "$f" 2>/dev/null || true
  
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l)
echo "✅ Sanitized $COUNT markdown files"
