---
layout: page
title: Snippets and tips
permalink: /snippets-and-tips/
navigation_weight: 1
---
{% for page in site.data.snippet-index %}
  <div class="boxed_page">
    <img src="{{ page.image }}" alt="Image text" style="margin: 0px 10px" width="54" height="54" align="left"/>
    <a href="{{ page.url }}">{{ page.title }}</a><br>
    {{ page.description }}
    <br>
  </div>   
{% endfor %}
<br><br>
