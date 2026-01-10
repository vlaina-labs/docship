> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# MDX/JSX Syntax Test

This file tests JSX-like syntax that might appear in user markdown files.

## Component-like Tags

These look like JSX components but are just text:

Button: Click me

Card with title="Test": Content inside card

MyComponent with prop=value

## Expression-like Syntax

Math: 1 + 1 = 2
Variable: variable
Array: items.map(item => item)

## Import-like Statements

These are just text, not real imports:

- import Component from './Component'
- import { named } from 'package'
- export const meta = { title: 'Test' }

## Self-closing HTML Tags

These are valid HTML:

Line break below:

---

Image placeholder: [image would go here]

## Normal Content

This should render normally without any issues.

The goal is to test that frameworks don't crash on content that looks like JSX but isn't in an MDX file.
