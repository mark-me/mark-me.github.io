---
layout: page
title: Presentations
permalink: /presentations/
navigation_weight: 1
---

Now and then I give R related presentations to collegues, which I collect those here.

* [Machine learning for the laymen](/machine-learning-layman/) – A presentation given to my collegues of Marketing showing them what machine learning is, the classes of algorithms and some examples of those.
* [Use case R](/use-case-r/) – The first presentation I gave to my collegues of Analytics to show them my findings while using R for the first time. Sorry: it’s in Dutch.

{% for page in site.data.presentations-index %}
  <div class="boxed_page">
    <div class = "index_item_left">
      <img src="{{ page.image }}" style="margin: 0px 10px" width="54" height="54" align="left"/>
    </div>
    <div clas = "index_item_right">
      <a href="{{ page.url }}">{{ page.title }}</a><br>
      {{ page.description }}
      <br>
    </div>
  </div>
{% endfor %}
<br><br>
