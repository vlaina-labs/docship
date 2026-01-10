> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Broken Links Test

## Non-existent Internal Links

[Missing file](./does-not-exist.md)
[Another missing](../nowhere/file.md)
[Deep missing](./a/b/c/d/e/f/g.md)

## Broken Anchors

[Bad anchor](#non-existent-heading)
[Another bad](#this-heading-does-not-exist)
[File with anchor](./missing.md#section)

## Malformed URLs

[No protocol](www.example.com)
[Missing slash](http:example.com)
[Double protocol](http://https://example.com)
[Space in URL](https://example .com/page)
[Invalid chars](https://exam<ple>.com)

## Special Protocol Links

[JavaScript](javascript:alert('xss'))
[Data URI](data:text/html,<script>alert('xss')</script>)
[VBScript](vbscript:msgbox('xss'))
[File protocol](file:///etc/passwd)

## Empty and Null Links

[Empty href]()
[Just hash](#)
[Whitespace only](   )
[Null byte](test%00.md)

## Unicode in Links

[Chinese path](./文档/测试.md)
[Emoji path](./📁/📄.md)
[RTL path](./مجلد/ملف.md)

## Very Long Links

[Super long](./aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.md)

## Normal Content

This should render fine.
