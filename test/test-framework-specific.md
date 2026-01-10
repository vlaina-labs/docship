> ⚠️ **This is a test file for DocShip development. The content below is intentionally broken.**

# Framework-Specific Edge Cases

## Vue/VitePress Specific

### Vue Template Syntax (outside code blocks)
{{ message }}
{{ user.name }}
{{ items.length > 0 ? 'Yes' : 'No' }}
{{ message.split('').reverse().join('') }}

### Vue Directives
<div v-if="show">Conditional</div>
<div v-for="item in items">{{ item }}</div>
<div v-bind:class="className">Bound</div>
<div v-on:click="handler">Click</div>
<div :class="className">Shorthand bind</div>
<div @click="handler">Shorthand event</div>
<div v-model="value">Model</div>
<div v-slot:header>Slot</div>
<div #header>Shorthand slot</div>

### Vue Components
<MyComponent />
<my-component></my-component>
<MyComponent :prop="value" @event="handler" />
<slot name="header"></slot>
<template #default="{ item }">{{ item }}</template>
<Teleport to="body">Content</Teleport>
<Suspense>Loading...</Suspense>
<KeepAlive>Cached</KeepAlive>
<Transition>Animated</Transition>

## React/Docusaurus/Nextra Specific

### JSX Syntax
<Component />
<Component prop={value} />
<Component {...props} />
<Component>Children</Component>
{condition && <Component />}
{condition ? <A /> : <B />}
{items.map(item => <Item key={item.id} />)}

### JSX Expressions
{variable}
{1 + 1}
{func()}
{obj.method()}
{arr[0]}
{`template ${literal}`}

### MDX Components
<Tabs>
  <TabItem value="js" label="JavaScript">
    Content
  </TabItem>
</Tabs>

<Admonition type="warning">
  Warning content
</Admonition>

<CodeBlock language="jsx">
  {`const x = 1;`}
</CodeBlock>

import Component from './Component';
export const meta = { title: 'Test' };

## Jekyll/Liquid Specific

### Liquid Tags
{% if page.title %}
  {{ page.title }}
{% endif %}

{% for post in site.posts %}
  {{ post.title }}
{% endfor %}

{% assign my_var = "value" %}
{% capture my_capture %}content{% endcapture %}

{% include header.html %}
{% include_relative footer.html %}

### Liquid Filters
{{ "hello" | capitalize }}
{{ page.date | date: "%Y-%m-%d" }}
{{ content | markdownify }}
{{ site.posts | size }}
{{ page.tags | join: ", " }}

### Jekyll Front Matter Variables
{{ page.title }}
{{ page.date }}
{{ page.categories }}
{{ page.tags }}
{{ site.url }}
{{ site.baseurl }}
{{ content }}

## Hugo Specific

### Hugo Shortcodes
{{< youtube dQw4w9WgXcQ >}}
{{< figure src="image.jpg" title="Title" >}}
{{< highlight go >}}
func main() {}
{{< /highlight >}}
{{< ref "other-post.md" >}}
{{< relref "other-post.md" >}}

### Hugo Variables
{{ .Title }}
{{ .Content }}
{{ .Date }}
{{ .Permalink }}
{{ .Site.Title }}
{{ .Params.author }}

## Sphinx/RST Patterns

### RST Directives
.. note::
   This is a note.

.. warning::
   This is a warning.

.. code-block:: python

   def hello():
       pass

.. toctree::
   :maxdepth: 2

   intro
   tutorial

### RST Roles
:ref:`label`
:doc:`document`
:class:`MyClass`
:func:`my_function`
:meth:`MyClass.method`

## MkDocs Specific

### Admonitions
!!! note
    This is a note.

!!! warning "Custom Title"
    This is a warning.

!!! danger ""
    No title danger.

??? note "Collapsible"
    Hidden content.

???+ note "Expanded"
    Visible content.

### Tabs
=== "Tab 1"
    Content 1

=== "Tab 2"
    Content 2

### Annotations
Some text (1)
{ .annotate }

1. Annotation content

## Docusaurus Specific

### Admonitions
:::note
This is a note
:::

:::tip
This is a tip
:::

:::info
This is info
:::

:::caution
This is a caution
:::

:::danger
This is danger
:::

### Tabs
```mdx-code-block
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
```

### Code Blocks
```jsx title="src/App.js"
function App() {
  return <div>Hello</div>;
}
```

```js {1,3-5} showLineNumbers
const a = 1;
const b = 2;
const c = 3;
const d = 4;
const e = 5;
```

## Astro/Starlight Specific

### Astro Components
---
const { title } = Astro.props;
---

<Component client:load />
<Component client:idle />
<Component client:visible />
<Component client:media="(max-width: 768px)" />
<Component client:only="react" />

### Starlight Components
<Card title="Card">Content</Card>
<CardGrid>
  <Card title="A">A</Card>
  <Card title="B">B</Card>
</CardGrid>
<Tabs>
  <TabItem label="Tab">Content</TabItem>
</Tabs>

## End

If you see this, the file rendered without crashing.
