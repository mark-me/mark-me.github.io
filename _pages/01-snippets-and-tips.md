---
layout: page
title: Snippets and tips
permalink: /snippets-and-tips/
navigation_weight: 1
---

{% assign rows = site.data.snippet-index.size | divided_by: 2.0 | ceil %}
{% for i in (1..rows) %}
  {% assign offset = forloop.index0 | times: 2 %}
  <div>
    {% for page in site.data.snippet-index limit:2 offset:offset %}
      <div class="boxed_page">
        <div class="index_item_left">
          <a href="{{ page.url }}"><img src="{{ page.image }}" alt="Image text" style="margin: 0px 5px" width="54" height="54" align="left"/></a>
        </div>
        <div class="index_item_right">
          <link_index href="{{ page.url }}">{{ page.title }}</link_index><br>
          <p class="spacer">{{ page.description }}</p>
        </div>
      </div>
    {% endfor %}
  </div>
{% endfor %}
<br><br>
