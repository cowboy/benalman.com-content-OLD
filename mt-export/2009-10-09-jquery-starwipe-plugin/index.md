title: "jQuery Star Wipe: Why eat hamburger when you can have steak? "
categories: [ Projects, jQuery ]
tags: [ fun, hamburger, jquery, plugin, silly, simpsons, starwipe, steak, transition ]
date: 2009-10-09 15:37:32 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With jQuery Star Wipe you can enable the single best transition ever created, the star wipe, in any recent WebKit browser!

<!--MORE-->

 * Release v1.0
 * Tested with jQuery 1.3.2 in Chrome 3, Safari 4.
 * Download [Source][src], [Minified][src-min] (8.9kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * Examples: [Star Wipe][ex]

  [github]: http://github.com/cowboy/jquery-starwipe
  [issues]: http://github.com/cowboy/jquery-starwipe/issues
  [src]: http://github.com/cowboy/jquery-starwipe/raw/master/jquery.ba-starwipe.js
  [src-min]: http://github.com/cowboy/jquery-starwipe/raw/master/jquery.ba-starwipe.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-starwipe/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-starwipe/examples/starwipe/

## Why do I need this plugin? ##

If you even have to ask, then you don't need it. In fact, you're not even allowed to look at the [live example][ex]. Just go away, now.

Ok, so for those of you who _can_ appreciate the single best transition EVER, the star wipe, I have some bad news. Unfortunately, the star wipe is only possible in the latest WebKit browsers. Yes, it's been possible in IE for like five years, but their way is totally non-standard. META tags? Forget about it. CSS 3 is the wave of the future!

Sure, only Chrome 3 and Safari 4 support [CSS masks](http://webkit.org/blog/181/css-masks/) right now, but do you want support for star wipe in more browsers? Of course you do! So, step up and ask your favorite browser manufacturer to support CSS masks!

## Why did you create this plugin? ##

I made a funny reference when I was writing up the [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) project page.. and it gave me an idea. No other reason.

## I want a star wipe! How can I use this plugin? ##

It's so easy, anyone can do it! Check out this sample code, and [the live example][ex].

<pre class="brush:js">
$(function(){
  $("a").starwipe();
});
</pre>

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

