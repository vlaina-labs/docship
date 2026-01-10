> ⚠️ **This is a test file for DocShip development. The content below is intentionally broken.**

# Syntax Ambiguity Test

## List vs Not List

-not a list (no space)
- list item
 - indented (is it nested?)
  - more indent
   - even more
    - too much?
     - way too much

* asterisk list
*not a list
 * indented asterisk
  * more

+ plus list
+not a list
 + indented plus

1. numbered
2. list
1.not a list
 1. indented numbered

1) parenthesis style
2) second item
1)not a list

## Header vs Not Header

#not a header (no space)
# header
##not a header
## header
###not
### yes
####not
#### yes
#####not
##### yes
######not
###### yes
#######too many hashes

## Bold/Italic Ambiguity

*single asterisk*
**double asterisk**
***triple asterisk***
****four asterisks****
*****five asterisks*****

_single underscore_
__double underscore__
___triple underscore___
____four underscores____
_____five underscores_____

*mixed**styles*
**mixed*styles**
_mixed__styles_
__mixed_styles__

*unclosed
**unclosed
***unclosed
_unclosed
__unclosed
___unclosed

*space before *
* space after*
** space before **
** space after**

*multi
line
italic*

**multi
line
bold**

## Code Ambiguity

`single backtick`
``double backtick``
```triple backtick```
````four backticks````

`unclosed
``unclosed
```unclosed

` space before `
` space after`
`space before `

`multi
line
code`

## Link Ambiguity

[text](url)
[text] (url)
[text]( url)
[text](url )
[text]
(url)
[](url)
[text]()
[]()
[text][ref]
[text] [ref]
[text][]
[][ref]
[][]

[ref]: url
[ref]:url
[ref] : url
[ref]:
[]: url

## Image Ambiguity

![alt](url)
![ alt](url)
![alt ](url)
![](url)
![alt]
(url)
![][ref]
![alt][ref]
![alt][]

## Blockquote Ambiguity

>not a quote (no space)
> quote
 > indented (is it nested?)
  > more indent
>> nested
> > spaced nested
>>>triple
> >> mixed

>multi
>line
>quote

> multi
> line
> with spaces

## Horizontal Rule Ambiguity

---
***
___
- - -
* * *
_ _ _
--
**
__
----
****
____
-_-
*-*
_*_

## Table Ambiguity

| A | B |
|---|---|
| 1 | 2 |

|A|B|
|-|-|
|1|2|

| A | B
|---|---
| 1 | 2

A | B |
---|---|
1 | 2 |

| A | B |
|---|
| 1 | 2 |

| A | B |
|---|---|---|
| 1 | 2 |

| A |
|---|
| 1 |
| 2 |
| 3 |

## Escape Ambiguity

\*escaped asterisk\*
\\*backslash then asterisk*
\\\*double backslash asterisk\\\*
\\\\*triple backslash*

\[escaped bracket\]
\\[backslash bracket]
\\\[double backslash\\\]

\`escaped backtick\`
\\`backslash backtick`
\\\`double backslash\\\`

## Autolink Ambiguity

<http://example.com>
<https://example.com>
<mailto:test@example.com>
<not-a-protocol://example.com>
<http://example.com
http://example.com>
< http://example.com>
<http://example.com >

## HTML vs Markdown

<div>
**bold in div**
</div>

<p>
*italic in p*
</p>

<span>inline **bold**</span>

<pre>
```
code in pre
```
</pre>

## Setext Header Ambiguity

Header
======

Header
------

Not Header
=

Not Header
-

Header
===

Header
---

Paragraph
text
======

## Definition List Ambiguity (some parsers)

Term
: Definition

Term
:Definition

Term
 : Definition

: No term

Term
: Definition 1
: Definition 2

## Footnote Ambiguity (some parsers)

[^1]: Footnote
[^1]:Footnote
[^1] : Footnote
[^ 1]: Footnote
[^]: Footnote
[^longnote]: Long footnote

Reference[^1] in text.
Reference [^1] in text.
Reference[^1]in text.

## End

If you see this, the file rendered without crashing.
