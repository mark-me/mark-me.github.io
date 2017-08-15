---
layout: page
title: Snippets and tips
permalink: /snippets-and-tips/
navigation_weight: 1
---

{% for page in site.data.snippet-index %}
  {% if forloop.index | modulo:2 == 0 %}
    <div id="container">
      <div id="left_page">  
        <div class="boxed_page">
          <img src="{{ page.image }}" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
          <a href="{{ page.url }}">{{ page.title }}</a><br>
          {{ page.description }}
          <br>
        </div>   
      </div>   
  {% else %}
    <div id="right_page">
      <div id="left_page">  
        <div class="boxed_page">
          <img src="{{ page.image }}" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
          <a href="{{ page.url }}">{{ page.title }}</a><br>
          {{ page.description }}
          <br>
      </div>
    </div>
  {% endif %}  
{% endfor %}


<div id="container">
  <div id="left_page">
    <div class="boxed_page">
      <img src="/_pages/snippets-and-tips/r-studio-tips.png" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
      <a href="/r-studio-tips/">R Studio tips</a><br>
      Tips on working with R Studio.
      <br>
    </div>
  </div>
  <div id="right_page">
    <div class="boxed_page">
      <img src="/_pages/snippets-and-tips/script-structuring.png" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
      <a href="/script-structuring/">Script structuring</a><br>
      Making easier to reading and navigation.
      <br>
    </div>
  </div>
</div>

<div id="container">
  <div id="left_page">
    <div class="boxed_page">
      <img src="/_pages/snippets-and-tips/importing-exporting.png" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
      <a href="/importing-exporting/">Importing and exporting</a><br>
      Mutating, restructuring, grouping and summing data.
      <br>
    </div>
  </div>
  <div id="right_page">
    <div class="boxed_page">
      <img src="/_pages/snippets-and-tips/data-types.png" alt="Image text" style="margin: 0px 10px" width="48" height="48" align="left"/>
      <a href="/data-types/">Data types and structures</a><br>
      Information on data types and data structures and how to handle them.
      <br>
    </div>
  </div>
</div>
