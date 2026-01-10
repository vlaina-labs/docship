> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Front Matter Edge Cases

## Front Matter in Wrong Position

This content comes before any front matter.

---
title: This is not valid front matter
description: Because it's not at the top
---

More content after the fake front matter.

## Multiple Front Matter Blocks

---
title: First block
---

Some content

---
title: Second block
---

More content

---
title: Third block
---

## Malformed YAML

---
title: Missing closing
description: This YAML is broken
  - invalid indentation
    nested: wrong
key without value:
: value without key
---

## Empty Front Matter

---
---

Content after empty front matter.

## Only Dashes

---

Just three dashes, no closing.

------

Six dashes.

---------

Nine dashes.

## Front Matter with Special Characters

---
title: "Quotes: 'single' and \"double\""
description: Special chars: <>&"'
tags: [one, two, three]
emoji: 🚀 📦 ✨
unicode: 你好世界
---

## TOML Front Matter (Hugo style)

+++
title = "TOML Front Matter"
date = 2024-01-01
draft = false
[params]
  author = "Test"
+++

## JSON Front Matter

;;;
{
  "title": "JSON Front Matter",
  "date": "2024-01-01",
  "tags": ["test", "json"]
}
;;;

## Normal Content

This is normal content that should render properly.
