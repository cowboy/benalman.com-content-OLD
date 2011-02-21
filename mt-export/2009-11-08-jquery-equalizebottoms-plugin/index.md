title: "jQuery equalizeBottoms"
categories: [ Projects, jQuery ]
tags: [ bottom, columns, contest, equalize, height, jquery, jquery14, layout, media temple, offset, plugin ]
date: 2009-11-08 10:22:14 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With jQuery equalizeBottoms you can "equalize" the bottoms of multiple elements, making columns heights even, even when CSS refuses to help.

Great news! This plugin won day eight of Media Temple's [14 Days of jQuery](http://mediatemple.net/jquery14/) contest. How it beat [jQuery Star Wipe](http://benalman.com/projects/jquery-starwipe-plugin/), I'll never know.. but if you're dying to see what the hype is all about, read on! _(note: hype not actual)_

<!--MORE-->

<div class="photo"><a href="http://mediatemple.net/jquery14/"><img src="http://benalman.com/images/projects/jquery-equalizebottoms/125x125winner.png"></a></div>

 * Release v1.5
 * Tested with jQuery 1.3.2 and 1.4.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.5.
 * Download [Source][src], [Minified][src-min] (0.5kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * Examples: [equalizeBottoms][ex]

  [github]: http://github.com/cowboy/jquery-equalizebottoms
  [issues]: http://github.com/cowboy/jquery-equalizebottoms/issues
  [src]: http://github.com/cowboy/jquery-equalizebottoms/blob/v1.5/jquery.ba-equalizebottoms.js
  [src-min]: http://github.com/cowboy/jquery-equalizebottoms/blob/v1.5/jquery.ba-equalizebottoms.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-equalizebottoms/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-equalizebottoms/examples/equalizebottoms/

Keep in mind that you should still do everything you can in CSS first.. but then, after you've exhausted all your other options, this plugin may help!

## Where you might use equalizeBottoms ##

Normally, when columns are adjacent elements, you can easily equalize their heights using some basic CSS positioning. But what if you have a more complex layout, and want elements *inside* columns to line up? There is no easy CSS-only way to do this.

So, let's say there are an arbitrary number of column divs, each with an arbitrary number of child divs. Each child div has a potentially different height, but the bottoms of each column should line up.

In this example, you could use background images to achieve the same visual effect, but what if your layout is fluid? What if the number of columns is variable?

This code:

<pre class="brush:js">
$(function(){
  
  // You'll want to do this whenever the column heights change.
  $('.column > :last-child').equalizeBottoms();
  
});
</pre>

Yields this result:

<img src="http://benalman.com/images/projects/jquery-equalizebottoms/sample.gif" alt="sample" style="border:none">

Wasn't that easy? Now, I'm sure there are other possible use-cases for this plugin, but they all revolve around making columns look just a little nicer. It's one of those "progressive enhancement" things - nice to have, but not really necessary.

To see jQuery equalizeBottoms in action, be sure to check out the [working example][ex].

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

