---
layout: page
title: Creating your own color theme
comments: true
permalink: /color-theme/
published: true
---

```r
download.file("http://mark-me.github.io/_pages/tutorials/color-theme/lego-scientist.jpg", "image.jpg", method = "wget", mode = "wb")
image <- readJPEG("image.jpg")
```

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/color-theme/lego-scientist.jpg" alt="" align="center"/>
{: refdef}

```r
image_dim <- dim(image)
image_RGB <- data.frame(
  x = rep(1:image_dim[2], each = image_dim[1]),
  y = rep(image_dim[1]:1, image_dim[2]),
  R = as.vector(image[,,1]),
  G = as.vector(image[,,2]),
  B = as.vector(image[,,3])
)
```

**[colortools](https://www.rdocumentation.org/packages/colortools)**
