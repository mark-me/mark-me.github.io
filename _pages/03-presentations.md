---
layout: page
title: Presentations
permalink: /presentations/
navigation_weight: 1
---

Now and then I give R related presentations to collegues, which I collect those here.

{% for page in site.data.presentations-index %}
  <div class="boxed_page">
    <div class = "index_item_left">
      <img src="{{ page.image }}" style="margin: 0px 10px" width="54" height="54" align="left"/>
    </div>
    <div clas = "index_item_right">
      <p style="text-align:left;"><a href="{{ page.url }}">{{ page.title }}</a><br>&nbsp;<span style="float:right;">
		<time>&nbsp;•&nbsp;{{ site.author.name}}</time></p>
      {{ page.description }}
      <br>
    </div>
  </div>
{% endfor %}
<br><br>
