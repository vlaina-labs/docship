#!/bin/bash
# DocShip Markdown Formatter
# Uses remark to normalize markdown files for compatibility with all documentation frameworks

CONTENT_DIR="${1:-.}"
WORK_DIR=$(pwd)

# Convert to absolute path
if [[ "$CONTENT_DIR" != /* ]]; then
  CONTENT_DIR="$WORK_DIR/$CONTENT_DIR"
fi

echo "馃摑 Formatting markdown files in: $CONTENT_DIR"

# Check if npx is available
if ! command -v npx &> /dev/null; then
  echo "鉂?npx not found, please install Node.js"
  exit 1
fi

# Create temporary working directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Create remark config
cat > "$TEMP_DIR/remark-config.mjs" << 'EOF'
import remarkParse from 'remark-parse'
import remarkGfm from 'remark-gfm'
import remarkFrontmatter from 'remark-frontmatter'
import remarkStringify from 'remark-stringify'
import { unified } from 'unified'

export const processor = unified()
  .use(remarkParse)
  .use(remarkFrontmatter, ['yaml', 'toml'])
  .use(remarkGfm)
  .use(remarkStringify, {
    bullet: '-',
    emphasis: '*',
    strong: '*',
    fence: '`',
    fences: true,
    listItemIndent: 'one'
  })
EOF

# Create processing script (doesn't exit on error, just logs)
cat > "$TEMP_DIR/process-md.mjs" << 'EOF'
import { readFileSync, writeFileSync } from 'fs'
import { processor } from './remark-config.mjs'

const file = process.argv[2]
if (!file) {
  process.exit(0)
}

try {
  const content = readFileSync(file, 'utf8')
  const result = await processor.process(content)
  writeFileSync(file, String(result))
  console.log(`  鉁?${file}`)
} catch (err) {
  // Don't exit with error, just log and continue
  console.error(`  鈿?${file}`)
}
EOF

# Install dependencies
echo "馃摝 Installing remark..."
cd "$TEMP_DIR"
npm init -y > /dev/null 2>&1
if ! npm install unified remark-parse remark-gfm remark-frontmatter remark-stringify --silent 2>/dev/null; then
  echo "鉂?Failed to install remark dependencies"
  exit 1
fi
cd "$WORK_DIR"

# Process all markdown files
echo "馃攧 Processing files..."

find "$CONTENT_DIR" -type f \( -name "*.md" -o -name "*.mdx" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -print0 | while IFS= read -r -d '' f; do
  node "$TEMP_DIR/process-md.mjs" "$f"
done

COUNT=$(find "$CONTENT_DIR" -type f \( -name '*.md' -o -name '*.mdx' \) ! -path "*/node_modules/*" ! -path "*/.git/*" | wc -l)
echo "鉁?Formatted $COUNT markdown files"
