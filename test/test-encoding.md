> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Encoding and Special Characters Test

## Zero Width Characters

Here​is​zero​width​space (U+200B)
Here‌is‌ZWNJ (U+200C)
Here‍is‍ZWJ (U+200D)
Here⁠is⁠word⁠joiner (U+2060)

## Bidirectional Text

English עברית English
مرحبا Hello مرحبا
‫Right to left override‬
‪Left to right override‬

## Control Characters

Bell:  (may not display)
Backspace:  (may not display)
Escape:  (may not display)
Null: (may not display)

## Unicode Edge Cases

Combining: é = e + ́ (e + combining acute)
Surrogate pairs: 𝕳𝖊𝖑𝖑𝖔 (Mathematical Bold Fraktur)
Private use: 
Replacement char: �

## HTML Entities

Named: &amp; &lt; &gt; &quot; &apos; &nbsp;
Numeric: &#60; &#62; &#38;
Hex: &#x3C; &#x3E; &#x26;
Invalid: &invalid; &notreal; &fake;

## Emoji Sequences

Simple: 😀 🎉 🚀
Skin tones: 👋🏻 👋🏼 👋🏽 👋🏾 👋🏿
ZWJ sequences: 👨‍👩‍👧‍👦 🏳️‍🌈 👩‍💻
Flags: 🇺🇸 🇯🇵 🇨🇳 🇩🇪

## Line Endings

Line with CR only
Line with LF only
Line with CRLF
Line with NEL (U+0085)…
Line with LS (U+2028) 
Line with PS (U+2029) 

## BOM Characters

 (UTF-8 BOM at start)
 (UTF-16 BE BOM)
 (UTF-16 LE BOM)

## Normal Content

This should render normally.
