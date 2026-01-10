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
[Space in URL](https://example.com/path%20with%20spaces)

## Special Protocol Links

These should be handled gracefully:

- javascript links (removed for security)
- data URIs (removed for security)
- file protocol links (removed for security)

## Empty and Null Links

[Empty href]()
[Just hash](#)

## Unicode in Links

[Chinese path](./文档/测试.md)
[Emoji path](./docs/readme.md)

## Very Long Links

[Super long path](./very-long-path-name-that-goes-on-and-on.md)

## Normal Content

This should render fine.

[Valid external link](https://github.com)
[Valid internal link](./getting-started.md)
