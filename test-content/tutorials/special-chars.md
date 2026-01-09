# Special Characters Test

This file tests various special characters that might break different parsers.

## Template Literals

JavaScript template: `${name}`

Multiple: `${first} ${last}`

## JSX-like Syntax

Component: `<Button />`

With props: `<Input type="text" />`

Nested: `<div><span>text</span></div>`

## Curly Braces

Object: `{ key: "value" }`

Destructuring: `const { a, b } = obj`

## Vue Templates

Double braces: `{{ message }}`

Directive: `v-if="{{ show }}"`

## Math Expressions

Inline: $E = mc^2$

Block:
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + ... + x_n
$$

## HTML Entities

- Less than: &lt;
- Greater than: &gt;
- Ampersand: &amp;
- Quote: &quot;

## Unicode

- Emoji: 🚀 📚 ✨
- Chinese: 你好世界
- Japanese: こんにちは
- Korean: 안녕하세요

## Edge Cases

Empty braces: `{}`

Nested: `{{ { inner: true } }}`

Mixed: `<Component prop={value} />`
