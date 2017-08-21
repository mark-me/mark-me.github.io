---
layout: page
title: Presentations
permalink: /presentations/
navigation_weight: 1
---

{% for page in site.data.presentations-index %}
  <div class="boxed_page">
    <div class = "index_item_left">
      <a href="{{ page.url }}"><img src="{{ page.image }}" style="margin: 0px 10px" width="54" height="54" align="left"/></a>
    </div>
    <div clas = "index_item_right">
      <blogheader><a href="{{ page.url | prepend: site.baseurl }}">{{ page.title }}</a></blogheader><time>{% if page.author %}&nbsp;•&nbsp;{{ page.author}}{% endif %}</time>
      <p style="text-align:left;">{{ page.description }}</p>
    </div>
  </div>
{% endfor %}
