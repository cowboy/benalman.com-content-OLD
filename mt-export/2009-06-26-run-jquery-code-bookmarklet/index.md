title: "jQuery Bookmarklet Generator"
categories: [ Projects, jQuery ]
tags: [ bookmarklet, javascript, jquery ]
date: 2009-06-26 09:41:34 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This would probably actually be better called "Run some arbitrary code that requires jQuery, loading a minimum required version of [jQuery](http://jquery.com/) first (but only if necessary), affecting the host page as little as possible Bookmarklet Generator" but that wasn't nearly as catchy as "jQuery Bookmarklet Generator" so I'm going to stick with that.

This boilerplate code is useful for bookmarklets that need jQuery to execute their payload, in situations where you don't know if jQuery or a specific minimum required version of jQuery will already exist in the page. If you just want to load jQuery itself into a page, check out the [Learning jQuery "jQuerify" bookmarklet](http://www.learningjquery.com/2009/04/better-stronger-safer-jquerify-bookmarklet).

<!--MORE-->

* Release v0.4
* Tested in Internet Explorer 6-8, Firefox 3, Safari 3-4, Chrome, Opera 9.
* View [Source][source]
* Use the super-convenient [bookmarklet generator][generator]
  
  [source]: http://benalman.com/code/javascript/jquery/jquery.ba-run-code-bookmarklet.js
  [generator]: http://benalman.com/code/test/jquery-run-code-bookmarklet/

## Usage ##

### The easy way ###

Visit the [bookmarklet generator][generator] page. It's super-convenient!

### The hard way ###

1. In the minified version below, replace `/* YOUR JQUERY CODE GOES HERE */` with your jQuery code, for example: `$('a').attr('href','http://benalman.com/');`
2. If necessary, adjust the minimum required jQuery version, by changing "1.3.2" to whatever you need it to be.
3. Use your brand new bookmarklet!

<pre class="brush:js; auto-links:false">
javascript:(function(e,a,g,h,f,c,b,d){if(!(f=e.jQuery)||g>f.fn.jquery||h(f)){c=a.createElement("script");c.type="text/javascript";c.src="http://ajax.googleapis.com/ajax/libs/jquery/"+g+"/jquery.min.js";c.onload=c.onreadystatechange=function(){if(!b&&(!(d=this.readyState)||d=="loaded"||d=="complete")){h((f=e.jQuery).noConflict(1),b=1);f(c).remove()}};a.documentElement.childNodes[0].appendChild(c)}})(window,document,"1.3.2",function($,L){/* YOUR JQUERY CODE GOES HERE */});
</pre>

## Notes ##

* If a jQuery version is specified and jQuery isn't already loaded, or the existing version of jQuery is lower (via string comparison) than the specified version, that minified version of jQuery will be loaded from the Google AJAX API server (set to `"1.3.2"` by default).
* A minimum version of jQuery must be specified. Specify `"1"` if your code doesn't require a specific version.
* Any bookmarklet-loaded jQuery will always run in noConflict mode, and will only be available inside the callback. It shouldn't contaminate the page.
* Inside the callback, `$` refers to the jQuery object, and `L` is a boolean that indicates whether or not an external jQuery file was just "L"oaded.

