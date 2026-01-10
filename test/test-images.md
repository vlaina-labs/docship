> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Broken Image Links Test

## Various Broken Image Patterns

### HTML Extension with Charset
![Image 1](assets/J_RlyTRkaaGXAiFgGHDM1W50O5rQXt6kaOYxDVzV6SY=.html; charset=utf-8)
![Image 2](assets/Z6XJerle1L9T5rPPYeoMuS3H2J7iJbagtIvk3t7u-fU=.html; charset=utf-8)

### Angle Bracket Syntax
![Image 3](<assets/broken-file.html; charset=utf-8>)
![Image 4](<./relative/path/image.html;charset=utf-8>)

### URL Encoded
![Image 5](assets/file%20with%20spaces.html;%20charset=utf-8)
![Image 6](assets/special%3Fchars.html;charset=utf-8)

### Base64 Looking Names
![Image 7](assets/aGVsbG8gd29ybGQ=.html; charset=utf-8)
![Image 8](assets/dGVzdCBpbWFnZQ==.html;charset=utf-8)

### Mixed Valid and Invalid
![Valid](https://github.com/NekoTick.png)
![Invalid](assets/broken.html; charset=utf-8)
![Also Valid](https://avatars.githubusercontent.com/u/12345)
![Also Invalid](<assets/another.html;charset=utf-8>)

### Deeply Nested Paths
![Deep 1](../../../assets/deep.html; charset=utf-8)
![Deep 2](./folder/subfolder/image.html;charset=utf-8)

### Query String Variations
![Query 1](assets/image.html?v=1; charset=utf-8)
![Query 2](assets/image.html?foo=bar&charset=utf-8)

### Fragment Variations
![Frag 1](assets/image.html#section; charset=utf-8)
![Frag 2](assets/image.html;charset=utf-8#anchor)

## Normal Content After Broken Images

This text should render normally after all the broken images above.

- List item 1
- List item 2
- List item 3
