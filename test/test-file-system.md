> ⚠️ **This is a test file for DocShip development. The content below is intentionally broken.**

# File System & Path Edge Cases

## Path Traversal Attempts

### Basic Traversal
[etc passwd](../../../etc/passwd)
[windows hosts](..\..\..\..\windows\system32\drivers\etc\hosts)
![image](../../../etc/shadow)

### Encoded Traversal
[encoded](..%2F..%2F..%2Fetc%2Fpasswd)
[double encoded](..%252F..%252F..%252Fetc%252Fpasswd)
[unicode](..%c0%af..%c0%af..%c0%afetc/passwd)
[overlong](..%c0%2e%c0%2e%c0%aeetc/passwd)

### Null Byte Injection
[null](../../../etc/passwd%00.md)
[null2](../../../etc/passwd\x00.md)

### Absolute Paths
[absolute](/etc/passwd)
[windows](C:\Windows\System32\config\SAM)
[unc](\\server\share\file)
[unc2](//server/share/file)

### Special Files
[dev null](/dev/null)
[dev zero](/dev/zero)
[dev random](/dev/random)
[proc self](/proc/self/environ)
[proc cmdline](/proc/self/cmdline)

## Filename Edge Cases

### Reserved Names (Windows)
[CON](CON)
[PRN](PRN)
[AUX](AUX)
[NUL](NUL)
[COM1](COM1)
[LPT1](LPT1)
[CON.md](CON.md)
[PRN.txt](PRN.txt)

### Special Characters in Filenames
[space file](file name.md)
[tab file](file	name.md)
[newline](file
name.md)
[quotes](file"name.md)
[single quotes](file'name.md)
[backtick](file`name.md)
[dollar](file$name.md)
[ampersand](file&name.md)
[pipe](file|name.md)
[semicolon](file;name.md)
[angle brackets](file<name>.md)
[asterisk](file*name.md)
[question](file?name.md)
[backslash](file\name.md)
[colon](file:name.md)

### Unicode Filenames
[chinese](文件.md)
[japanese](ファイル.md)
[korean](파일.md)
[arabic](ملف.md)
[hebrew](קובץ.md)
[emoji](📄.md)
[rtl](‮file‬.md)

### Long Filenames
[long](aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.md)

### Hidden Files
[hidden](.hidden)
[hidden dir](.hidden/file.md)
[double hidden](..hidden)

### Extension Edge Cases
[no extension](file)
[double extension](file.md.md)
[hidden extension](file.md.bak)
[executable](file.md.exe)
[script](file.md.sh)
[many dots](file...md)
[dot only](.)
[double dot](..)

## URL Edge Cases

### Protocol Handlers
[javascript](javascript:alert(1))
[data](data:text/html,<script>alert(1)</script>)
[vbscript](vbscript:msgbox(1))
[file](file:///etc/passwd)
[ftp](ftp://server/file)
[gopher](gopher://server/file)
[ldap](ldap://server/query)

### URL Encoding
[encoded space](file%20name.md)
[encoded slash](file%2Fname.md)
[encoded backslash](file%5Cname.md)
[encoded null](file%00name.md)
[encoded newline](file%0Aname.md)
[encoded carriage](file%0Dname.md)

### URL Fragments
[fragment](#section)
[fragment with special](#section<script>)
[fragment encoded](#section%3Cscript%3E)
[empty fragment](#)
[only hash](# )

### URL Query Strings
[query](file.md?param=value)
[query xss](file.md?param=<script>)
[query injection](file.md?param='; DROP TABLE)
[multiple params](file.md?a=1&b=2&c=3)

### Malformed URLs
[no protocol](//example.com/file)
[missing slash](http:example.com)
[extra slashes](http:///example.com)
[port](http://example.com:8080/file)
[auth](http://user:pass@example.com/file)
[ipv6](http://[::1]/file)
[localhost](http://localhost/file)
[127.0.0.1](http://127.0.0.1/file)
[0.0.0.0](http://0.0.0.0/file)

## Image Source Edge Cases

### Data URIs
![data uri](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==)
![svg data](data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg"><script>alert(1)</script></svg>)

### SVG with Script
![svg](image.svg#<script>alert(1)</script>)

### External Resources
![external](http://evil.com/tracking.gif)
![external https](https://evil.com/tracking.gif)

## End

If you see this, the file rendered without crashing.
