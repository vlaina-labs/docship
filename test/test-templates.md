> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# Template Syntax Test

## Nunjucks/Jinja2 Syntax

{{ variable }}
{{ user.name }}
{{ items | join(', ') }}
{{ "hello" | upper }}

{% if condition %}
  Show this
{% endif %}

{% for item in items %}
  {{ item }}
{% endfor %}

{% block content %}
  Block content
{% endblock %}

{% include "partial.html" %}
{% extends "base.html" %}

{% macro button(text) %}
  <button>{{ text }}</button>
{% endmacro %}

{{ button("Click me") }}

## Vue/React Template Syntax

{{ message }}
{{ count + 1 }}
{{ ok ? 'YES' : 'NO' }}
{{ message.split('').reverse().join('') }}

{{{ rawHtml }}}

<div v-if="seen">Now you see me</div>
<div v-for="item in items">{{ item.text }}</div>
<div v-bind:id="dynamicId"></div>
<div :class="{ active: isActive }"></div>
<div @click="handleClick"></div>

## Angular Syntax

{{ title }}
{{ 1 + 1 }}
{{ getValue() }}

*ngIf="condition"
*ngFor="let item of items"
[ngClass]="{'active': isActive}"
(click)="onClick()"
[(ngModel)]="name"

{{ date | date:'short' }}
{{ price | currency }}

## Handlebars Syntax

{{title}}
{{author.name}}
{{{body}}}

{{#if author}}
  <h1>{{firstName}} {{lastName}}</h1>
{{/if}}

{{#each people}}
  <li>{{this}}</li>
{{/each}}

{{#with person}}
  {{firstname}} {{lastname}}
{{/with}}

{{> myPartial }}
{{> (lookup . 'template') }}

## Liquid Syntax (Jekyll/Shopify)

{{ page.title }}
{{ site.url }}
{{ content }}

{% assign my_variable = "value" %}
{% capture my_capture %}captured{% endcapture %}

{% if product.available %}
  In stock
{% endif %}

{% for product in collection.products %}
  {{ product.title }}
{% endfor %}

{{ "hello" | capitalize }}
{{ product.price | money }}

## ERB Syntax (Ruby)

<%= @title %>
<%= link_to 'Home', root_path %>
<% if @user.admin? %>
  Admin content
<% end %>
<%= render partial: 'form' %>

## PHP Syntax

<?php echo $variable; ?>
<?= $shorthand ?>
<?php if ($condition): ?>
  Content
<?php endif; ?>

## Normal Content

This text should render normally after all the template syntax above.
