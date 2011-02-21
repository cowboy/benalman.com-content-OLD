title: "CSS: With HTTP requests, less is more!"
categories: [ Code, News ]
tags: [ css, irony, optimized, sprites ]
date: 2009-11-04 13:49:07 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Lately, I've been spending a lot of time trying to find new ways to optimize websites to enhance the front-end and the overall user experience. I've already spent some time working with CSS sprites (on [benalman.com, for example](http://benalman.com/shell/images/benalman.gif)) to reduce the number of HTTP requests, but just yesterday I decided to revisit a CSS technique I had been using for years, to see if I could optimize it somehow.

<!--MORE-->

In this [expanding box with shim example](http://benalman.com/code/projects/css-misc/examples/expanding-box-shim/), I show how you can further minimize the number of HTTP requests by combining both the top and bottom parts of a fixed width, vertically expanding box into a single CSS sprite image, instead of the more traditional multi-image approach.

It's not rocket science by any means, and there are a few minor caveats, but the code is pretty solid. Check out [the example](http://benalman.com/code/projects/css-misc/examples/expanding-box-shim/) now, and let me know what you think!

And please, before you do so, note that it's already been pointed out to me that I should be using the latest CSS3 border-radius and box-shadow techniques. Well, even though I normally make every effort to do this (like on this site's sidebar, for example), the project I was working on very specifically required everything to look "just right" in IE.. which kinda rains on the whole CSS3 party.

Next time, for sure!

