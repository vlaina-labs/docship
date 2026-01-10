> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Malformed Tables Test

## Missing Separator Row

| Header 1 | Header 2 |
| Cell 1 | Cell 2 |

## Inconsistent Columns

| A | B | C |
|---|---|
| 1 | 2 | 3 | 4 | 5 |
| x |

## No Pipes at Edges

Header 1 | Header 2
--- | ---
Cell 1 | Cell 2

## Only Separator

|---|---|---|

## Empty Table

| | |
|-|-|
| | |

## Pipes in Content

| Code | Example |
|------|---------|
| `a|b` | a|b |
| \| | escaped |

## Very Wide Table

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 |
|------|------|------|------|------|------|------|------|------|-------|-------|-------|-------|-------|-------|
| a | b | c | d | e | f | g | h | i | j | k | l | m | n | o |

## Nested Markdown in Table

| Feature | Example |
|---------|---------|
| **Bold** | `code` |
| *Italic* | [link](url) |
| ~~Strike~~ | ![img](url) |

## Normal Content

This should render fine.
