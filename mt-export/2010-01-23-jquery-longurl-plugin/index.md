title: "jQuery longUrl: Uniform Resource Elongator"
categories: [ Projects, jQuery ]
tags: [ batch, jquery, json, lengthen, long url, plugin, queue, short url, url ]
date: 2010-01-23 13:18:43 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery Long Url uses the [longurlplease.com](http://longurlplease.com/) short URL lengthening API to expand short URLs from at least 80 services, including bit.ly, is.gd, tinyurl.com and more!

<!--MORE-->

And not only has jQuery Long Url been written to take advantage of the longurlplease.com API "batch" ability, where up to ten URLs can be lengthened per request, but it can optionally use any lengthening service, supporting any URL-per-request "batch" limitations, which minimizes the number of external requests made for faster performance.

 * Release v1.0
 * Tested with jQuery 1.3.2 and jQuery 1.4.1 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (1.2kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [Long Url][ex]

  [github]: http://github.com/cowboy/jquery-longurl
  [issues]: http://github.com/cowboy/jquery-longurl/issues
  [src]: http://github.com/cowboy/jquery-longurl/raw/master/jquery.ba-longurl.js
  [src-min]: http://github.com/cowboy/jquery-longurl/raw/master/jquery.ba-longurl.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-longurl/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-longurl/examples/longurl/
  
  [unit]: http://benalman.com/code/projects/jquery-longurl/unit/

## Usage ##

### Basic ###

Look, how easy can it get? You call `.longUrl()` on some `A` elements, and they get updated:

<pre class="brush:js">
// Lengthen URLs of all selected "a" elements. The "title"
// and "href" attributes of each element will be updated
// with the fetched long URL.
$("a").longUrl();
</pre>

### Slightly more advanced ###

So, let's say you want a little more control over what happens when those `A` elements are updated...

<pre class="brush:js">
// Lengthen URLs of all selected "a" elements, giving them
// a class of "fetch" in the meantime.
$("a").longUrl({
  complete: function(result){
    // The "complete" function executes after all elements
    // have been updated, so remove the "fetch" class on
    // everything (`this` is the initial set of elements).
    this.removeClass( "fetch" );
  }
}).addClass( "fetch" );

// Lengthen URLs of all selected "a" elements, setting their
// text to be their long URL value.
$("a").longUrl({
  callback: function( href, long_url ){
    // The "callback" function executes for each unique
    // href, and `this` is a jQuery object containing all
    // elements sharing that href.
    if ( long_url ) {
      this.text( long_url );
    }
  }
});
</pre>

And if you're trying to do something fancy, you can call `$.longUrl()` to just fetch long URLs without updating any `A` elements. This gives you the flexibility to use longURL however you'd like...

<pre class="brush:js;auto-links:false">
// Lenthen a single URL.
$.longUrl( "http://url.ie/4qns", function(result){
  // When URL is fetched, result will be:
  // { "http://url.ie/4qns": "http://twitter.com/cowboy/" }
});

// Lenthen a few URLs.
var urls = [
  "http://url.ie/4qns",
  "http://tinyurl.com/d2b3do",
  "http://su.pr/A5aJ2t"
];

$.longUrl( urls, function(result){
  // When URLs are fetched, result will be:
  // {
  //  "http://url.ie/4qns": "http://twitter.com/cowboy/",
  //  "http://tinyurl.com/d2b3do": "http://benalman.com/",
  //  "http://su.pr/A5aJ2t": "http://jquery.com/"
  // }
});
</pre>

Either way, check out [the live example][ex] to see the plugin in _actual_ action, and if you have any non-bug-related feedback or suggestions, please let me know below in the comments. If you have any bug reports, please report them in the [issues tracker][issues], thanks!

_Also, I really want to thank Darragh Curran for keeping his awesome [longurlplease.com](http://www.longurlplease.com/) service up and running!_

