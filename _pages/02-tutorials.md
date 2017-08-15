---
layout: page
title: Tutorials
permalink: /tutorials/
navigation_weight: 2
---

{% for page in site.data.tutorial-index %}
  <div class="boxed_page">
    <img src="{{ page.image }}" alt="Image text" style="margin: 0px 10px" width="60" height="60" align="left"/>
    <a href="{{ page.url }}">{{ page.title }}</a><br>
    {{ page.description }}
    <br>
  </div>   
{% endfor %}
<br><br>
