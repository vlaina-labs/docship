> ⚠️ **This is a test file for DocShip development. The content below is intentionally broken.**

# Parser Killer Test

## Deeply Nested Structures

### 50 Level Nested List
- L1
  - L2
    - L3
      - L4
        - L5
          - L6
            - L7
              - L8
                - L9
                  - L10
                    - L11
                      - L12
                        - L13
                          - L14
                            - L15
                              - L16
                                - L17
                                  - L18
                                    - L19
                                      - L20
                                        - L21
                                          - L22
                                            - L23
                                              - L24
                                                - L25

### Nested Blockquotes
> L1
>> L2
>>> L3
>>>> L4
>>>>> L5
>>>>>> L6
>>>>>>> L7
>>>>>>>> L8
>>>>>>>>> L9
>>>>>>>>>> L10

### Nested Code Blocks (should break)
```
outer
```inner
nested
```
more
```

## Ambiguous Syntax

### Is this a list or not?
-not a list
- list
-also not
 - indented
  -not
   - yes

### Is this a header?
#not a header
# header
##not
## yes
###not
### yes

### Is this bold?
**bold**
** not bold **
**not bold **
** not bold**
***is this bold italic?***
****what about this****
*****or this*****

### Is this a link?
[link](url)
[link] (url)
[link]( url)
[link](url )
[link] [ref]
[link][ref]
[link][]
[]
[](url)
[link]()

### Is this an image?
![alt](url)
![ alt](url)
![alt ](url)
![](url)
![][ref]
![alt][ref]

## Escape Sequences

\\backslash
\*asterisk
\_underscore
\`backtick
\#hash
\+plus
\-minus
\.period
\!exclamation
\[bracket
\]bracket
\(paren
\)paren
\{brace
\}brace
\|pipe
\\\\double backslash
\\\*escaped escape

## Edge Case Tables

### No Header Separator
| A | B |
| 1 | 2 |

### Wrong Column Count
| A | B | C |
|---|---|
| 1 | 2 | 3 | 4 |

### Empty Table
|   |   |
|---|---|
|   |   |

### Pipes in Content
| A | B |
|---|---|
| a|b | c|d |
| \| | \| |

### Alignment Edge Cases
|:---|:---:|---:|
| L | C | R |

|:::|
| ? |

## Code Block Edge Cases

### Empty Code Block
```
```

### Only Whitespace
```
   
```

### Unclosed
```javascript
const x = 1;

### Wrong Closing
```javascript
const x = 1;
``

### Nested Backticks
```
`single`
``double``
```triple```
```

### Language with Special Chars
```c++
int main() {}
```

```c#
class Main {}
```

```f#
let x = 1
```

```objective-c
@interface Main
@end
```

## HTML Edge Cases

### Unclosed Tags
<div>
<p>
<span>
<a href="#">

### Self-closing Variants
<br>
<br/>
<br />
<hr>
<hr/>
<hr />
<img src="x">
<img src="x"/>
<img src="x" />

### Attributes Edge Cases
<div class="a"class="b">
<div class='single'>
<div class=noquotes>
<div data-x="a'b">
<div data-x='a"b'>
<div data-x=a"b>

### Comments
<!-- normal -->
<!--- extra dash --->
<!-- -- nested -- -->
<!---->
<!-- unclosed

### CDATA
<![CDATA[content]]>
<![CDATA[unclosed

### DOCTYPE
<!DOCTYPE html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN">

## Math Edge Cases

### Inline Math
$x$
$ x$
$x $
$ x $
$$
$\$
$\\$

### Block Math
$$
x = y
$$

$$x = y$$

$$
unclosed

$$ mismatched
$

## Reference Edge Cases

### Undefined References
[undefined]
[undefined][ref]
![undefined]
![undefined][ref]

### Circular References
[a]: #b
[b]: #a

### Self Reference
[self]: #self

### Empty Reference
[]: url
[ref]: 

### Reference with Special Chars
[ref with space]: url
[ref-with-dash]: url
[ref_with_underscore]: url
[ref.with.dot]: url

## Frontmatter Edge Cases

Not at start:

---
title: not frontmatter
---

### Multiple Frontmatters
---
first: true
---

---
second: true
---

### Unclosed Frontmatter
---
title: unclosed

### YAML Edge Cases
---
title: "quote with \"escape\""
multiline: |
  line 1
  line 2
array: [1, 2, 3]
nested:
  deep:
    deeper: value
number: 1.23e10
boolean: true
null_value: null
date: 2024-01-01
---

## End

If you see this, the file rendered without crashing.
