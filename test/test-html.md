> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# HTML Edge Cases Test

## Script Tags (should be removed)

Script tags should be sanitized by the build process.

## Style Tags (should be removed)

Style tags should also be sanitized.

## Event Handlers

Event handlers in HTML should be handled:

- onclick attributes
- onerror attributes
- onload attributes

## HTML Comments

<!-- Normal comment -->

<!-- 
Multi-line
comment
-->

## Valid HTML

<div>
  <p>This is valid HTML inside markdown.</p>
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</div>

## Tables in HTML

<table>
  <tr>
    <th>Header 1</th>
    <th>Header 2</th>
  </tr>
  <tr>
    <td>Cell 1</td>
    <td>Cell 2</td>
  </tr>
</table>

## Details/Summary

<details>
  <summary>Click to expand</summary>
  
  Hidden content here.
</details>

## Normal Content

This paragraph should render normally.

Regular markdown works fine:

- List item 1
- List item 2
- List item 3

**Bold text** and *italic text* work as expected.
