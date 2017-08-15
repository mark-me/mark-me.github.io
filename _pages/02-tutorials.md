---
layout: page
title: Tutorials
permalink: /tutorials/
navigation_weight: 2
---

{% for page in site.data.tutorial-index %}
  <div class="index_item">
    <div id="left">
      <img src="{{ page.image }}" style="margin: 0px 10px" width="54" height="54" align="left"/>
    </div>  
    <div id="right">
      <a href="{{ page.url }}">{{ page.title }}</a><br>
      {{ page.description }}
      <br>
    </div>  
  </div>   
{% endfor %}
<br><br>
