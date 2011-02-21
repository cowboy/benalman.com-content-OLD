title: "jQuery BBQ: Back Button & Query Library"
categories: [ Projects, jQuery ]
tags: [ bbq, deparam, fragment, hashchange, history, jquery, plugin, project, query string ]
date: 2009-10-03 11:07:14 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery BBQ leverages the HTML5 [hashchange event](http://benalman.com/projects/jquery-hashchange-plugin/) to allow simple, yet powerful bookmarkable #hash history. In addition, jQuery BBQ provides a full .deparam() method, along with both hash state management, and fragment / query string parse and merge utility methods.

This plugin and the [jQuery urlInternal](http://benalman.com/projects/jquery-urlinternal-plugin/) plugin supersede the URL Utils plugin.

<!--MORE-->

 * Release v1.2.1
 * Tested with jQuery 1.3.2, 1.4.1, 1.4.2 in Internet Explorer 6-8, Firefox 2-3.7, Safari 3-4, Chrome 4-5, Opera 9.6-10.1, [Mobile Safari 3.1.1](http://paulirish.com/i/6920.png).
 * Download [Source][src], [Minified][src-min] (4.0kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [basic hashchange][ex-frag-basic], [advanced hashchange][ex-frag-advanced], [jQuery UI Tabs history & bookmarking][ex-frag-tabs], [jQuery.deparam][ex-deparam]

  [github]: http://github.com/cowboy/jquery-bbq
  [issues]: http://github.com/cowboy/jquery-bbq/issues
  [src]: http://github.com/cowboy/jquery-bbq/raw/v1.2.1/jquery.ba-bbq.js
  [src-min]: http://github.com/cowboy/jquery-bbq/raw/v1.2.1/jquery.ba-bbq.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-bbq/docs/
  
  [ex-frag-basic]: http://benalman.com/code/projects/jquery-bbq/examples/fragment-basic/
  [ex-frag-advanced]: http://benalman.com/code/projects/jquery-bbq/examples/fragment-advanced/
  [ex-frag-tabs]: http://benalman.com/code/projects/jquery-bbq/examples/fragment-jquery-ui-tabs/
  [ex-deparam]: http://benalman.com/code/projects/jquery-bbq/examples/deparam/
  
  [unit]: http://benalman.com/code/projects/jquery-bbq/unit/
  
  [hashchange]: http://benalman.com/projects/jquery-hashchange-plugin/

Note: If you're using jQuery 1.3.2 or earlier and need BBQ to merge query string or fragment params containing `[]`, you'll want to include the [jQuery 1.4 `.param` method](http://gist.github.com/206323) in your code.

Also, my article [Cooking BBQ: the original recipe](http://benalman.com/news/2010/04/cooking-bbq-the-original-recipe/) gives a history of jQuery BBQ along with some plugin authoring guidelines, if you're interested.

## What jQuery BBQ allows you to do: ##

While this brief overview will give you the broad strokes, for specifics you should look at the the basic examples below, read [the documentation][docs], and check out the full examples listed above.

 * Deserialize any params string, the document query string or fragment into an object, including the new jQuery.param format (new in jQuery 1.4, [read more here](http://benalman.com/news/2009/12/jquery-14-param-demystified/)). ([example][ex-deparam])
 * Merge any URL plus query string or fragment params--in an object, params string or second URL (including the current document location)--into a new URL.
 * Update the "URL attribute" (ie. `a[href]`, `img[src]`, `form[action]`, etc) in multiple elements, merging any URL plus query string or fragment params--in an object, params string or second URL (including the current document location)--into a new URL, which is then set into that attribute.
 * Push (and retrieve) bookmarkable, history-enabling "state" objects or strings onto the document fragment, allowing cross-browser back- and next-button functionality for dynamic web applications ([example 1][ex-frag-basic], [example 2][ex-frag-advanced], [example 3][ex-frag-tabs])
 * Bind event handlers to a normalized, cross-browser [hashchange event][hashchange] ([example 1][ex-frag-basic], [example 2][ex-frag-advanced], [example 3][ex-frag-tabs])

<a name="community"></a>
## jQuery BBQ community ##

Have you used jQuery BBQ in an project, website, article or tutorial? [Let me know](http://benalman.com/about/contact/), and I'll mention it here!

### Projects or websites using jQuery BBQ ###

* [Drupal 7](http://drupal.org/)
* [Struts2 jQuery Plugin](http://code.google.com/p/struts2-jquery/)
* [Yii PHP framework](http://www.yiiframework.com/)
* [bit.ly](http://bit.ly/)
* [K2 WordPress theme/framework](http://code.google.com/p/kaytwo/wiki/WhatisK2)
* [jQAPI - Alternative jQuery Documentation](http://jqapi.com/)
* [jQuery source viewer](http://james.padolsey.com/jquery/)
* [jqGrid/BBQ Integration](http://craigstuntz.github.com/jqGrid/)
* [SVG-edit](http://code.google.com/p/svg-edit/)
* [GemKitty custom jewelry](http://gemkitty.com/custom-jewelry/earrings)

### Articles or tutorials featuring jQuery BBQ ###

* [History and Back Button Support](http://msdn.microsoft.com/en-us/scriptjunkie/ff690558.aspx) - MSDN ScriptJunkie
* [Enabling the Back Button](http://jqueryfordesigners.com/enabling-the-back-button/) - jQuery for Designers
* [jQuery, ASP.NET, and Browser History](http://stephenwalther.com/blog/archive/2010/04/08/jquery-asp.net-and-browser-history.aspx) - Stephen Walther
* [The Future of Web Apps - Single Page Applications](http://happyworm.com/blog/2010/08/23/the-future-of-web-apps-single-page-applications/) - Mark Boas
* [Enabling browser back button on cascading dropdowns with jQuery BBQ plugin](http://mattfrear.com/2010/03/20/enabling-browser-back-button-on-cascading-dropdowns-with-jquery-bbq-plugin/) - Matt Frear
* [AJAX History and Bookmarks Railscast](http://railscasts.com/episodes/175-ajax-history-and-bookmarks), [ASCIIcast](http://asciicasts.com/episodes/175-ajax-history-and-bookmarks) - _Note: features URL Utils, jQuery BBQ's predecessor_

<a name="why"></a>
## Why BBQ? AKA: Why "history" and "deparam" together? ##

Imagine three scenarios. Now, imagine a [star wipe](http://benalman.com/projects/jquery-starwipe-plugin/)...

### The single widget ###
In the first scenario, you've got a single widget on the page. Maybe the page is the widget, whatever. Either way, things are so simple that every history plugin can do this (including jQuery BBQ):

**&lt;Widget&gt;** Yo, hash, update the state with this string.  
**&lt;Hash&gt;** No prob, dude, done. Sure, your state takes up the whole hash, but what do you care, you're the only widget on the page!  
**&lt;Widget&gt;** But I'm so lonely.  
**&lt;Hash&gt;** Tough luck, kid. There's only room in this hash for one state.

### Multiple widgets, rough-and-tumble ###
In the next scenario, you've got multiple widgets on the page. And unfortunately, because the history plugin developer didn't provide an easy way to manage multiple, separate, individual states simultaneously, your widgets need to be somewhat aware of each other's existence, so they don't accidentally erase each other's state in the hash:

**&lt;Widget&gt;** Yo, hash.. I need to update my state parameters. Whatcha got in there?  
**&lt;Hash&gt;** A string representation of your state, plus maybe some others, I'm not sure. Whatever. Here ya go!  
**&lt;Widget&gt;** Wow, that sure contains a lot of stuff I don't care about.. But a job's a job, right?  
**&lt;Widget&gt;** So, first let me figure out where my parameters are. Ok, right.. Wait! I think some other widget's parameters are in here too! Ok. Let's see, add this in there, carry the one.. great, that seems to be working now.  
**&lt;Widget&gt;** Well, hash, here's the whole new state. I inserted my parameters in there next to all the other parameters that were there. Or maybe i didn't. I dunno, it probably works.  
**&lt;Widget2&gt;** Are you telling me I've got to do all that too? 404 dudes, I quit.

### Multiple widgets, with some tasty BBQ sauce ###
In this final scenario, while there are multiple widgets on the same page, each one can get and set its own state very easily because the history plugin can deparameterize any fragment-based params string into its component parts easily, then merge replacement params in, and update:

**&lt;Widget&gt;** Yo, hash, update my state parameters.  
**&lt;Hash&gt;** No prob, dude, done. And you didn't even have to know about that other widget's parameter, I just merged them in there for you.  
**&lt;Widget&gt;** There's another widget?  
**&lt;Widget2&gt;** Huh? Did someone say my name?

In case you hadn't guessed, jQuery BBQ helps you do all this the easy way.

## Examples ##

### jQuery.deparam ###

In the following examples, `jQuery.deparam` is used to deserialize params strings generated with the built-in `jQuery.param` method. Check out the [jQuery.deparam example page][ex-deparam] and [documentation][docs] for more information.

<pre class="brush:js;auto-links:false">
// Serializing a params string using the built-in jQuery.param method.
// myStr is set to "a=1&b=2&c=true&d=hello+world"
var myStr = $.param({ a:1, b:2, c:true, d:"hello world" });

// Deserialize the params string into an object.
// myObj is set to { a:"1", b:"2", c:"true", d:"hello world" }
var myObj = $.deparam( myStr );

// Deserialize the params string into an object, coercing values.
// myObj is set to { a:1, b:2, c:true, d:"hello world" }
var myObj = $.deparam( myStr, true );

// Deserialize jQuery 1.4-style params strings.
// myObj is set to { a:[1,2], b:{ c:[3], d:4 } }
var myObj = $.deparam( "a[]=1&a[]=2&b[c][]=3&b[d]=4", true );
</pre>

### jQuery.deparam with query string and fragment ###

The `jQuery.deparam.querystring` and `jQuery.deparam.fragment` methods can be used to parse params strings out of any URL, including the current document. Complete usage information is available in the [documentation][docs].

<pre class="brush:js;auto-links:false">
// Deserialize current document query string into an object.
var myObj = $.deparam.querystring();

// Deserialize current document fragment into an object.
var myObj = $.deparam.fragment();

// Parse URL, deserializing query string into an object.
// myObj is set to { a:"1", b:"2", c:"hello" }
var myObj = $.deparam.querystring( "/foo.php?a=1&b=2&c=hello#test" );

// Parse URL, deserializing fragment into an object.
// myObj is set to { a:"3", b:"4", c:"world" }
var myObj = $.deparam.fragment( "/foo.php?test#a=3&b=4&c=world" );
</pre>

### Parsing the query string or fragment from a URL ###

The `jQuery.param.querystring` and `jQuery.param.fragment` methods can be used to return a normalized query string or fragment from the current document or a specified URL. Complete usage information is available in the [documentation][docs].

<pre class="brush:js;auto-links:false">
// Return the document query string (similar to location.search, but with
// any leading ? stripped out).
var qs = $.param.querystring();

// Return the document fragment (similar to location.hash, but with any
// leading # stripped out. The result is *not* urldecoded).
var hash = $.param.fragment();

// Parse URL, returning the query string, stripping out the leading ?.
// qs is set to "a=1&b=2&c=3"
var qs = $.param.querystring( "/index.php?a=1&b=2&c=3#hello-world" );

// Parse URL, returning the fragment, stripping out the leading #.
// hash is set to "hello-world"
var hash = $.param.fragment( "/index.php?a=1&b=2&c=3#hello-world" );
</pre>

### URL building, using query string and fragment ###

The `jQuery.param.querystring` and `jQuery.param.fragment` methods can also be used to merge a params string or object into an existing URL. Complete usage information and merge options are available in the [documentation][docs].

<pre class="brush:js;auto-links:false">
var url = "http://example.com/file.php?a=1&b=2#c=3&d=4",
  paramsStr = "a=5&c=6",
  paramsObj = { a:7, c:8 };

// Build URL, merging params_str into url query string.
// newUrl is set to "http://example.com/file.php?a=5&b=2&c=6#c=3&d=4"
var newUrl = $.param.querystring( url, paramsStr );

// Build URL, merging params_obj into url query string.
// newUrl is set to "http://example.com/file.php?a=7&b=2&c=8#c=3&d=4"
var newUrl = $.param.querystring( url, paramsObj );

// Build URL, merging params_str into url fragment.
// newUrl is set to "http://example.com/file.php?a=1&b=2#a=5&c=6&d=4"
var newUrl = $.param.fragment( url, paramsStr );

// Build URL, merging params_obj into url fragment.
// newUrl is set to "http://example.com/file.php?a=1&b=2#a=7&c=8&d=4"
var newUrl = $.param.fragment( url, paramsObj );

// Build URL, overwriting url fragment with new fragment string.
// newUrl is set to "index.php#/path/to/file.php"
var newUrl = $.param.fragment( "index.php", "/path/to/file.php", 2 );
</pre>

### URL building in elements with "URL attributes" ###

The `jQuery.fn.querystring` and `jQuery.fn.fragment` methods are used to merge a params string or object into an existing URL, in the appropriate selected elements' "URL attribute" (ie. `a[href]`, `img[src]`, `form[action]`, etc). Complete usage information and merge options, as well as a list of all elements' default "URL attributes" are available in the [documentation][docs].

<pre class="brush:js;auto-links:false">
// Merge a=1 and b=2 into the `href` attribute's URL's query string,
// for every `a` element.
$("a").querystring({ a:1, b:2 });

// Completely replace the `href` attribute's URL's query string with
// "a=1&b=2", for every `a` element.
$("a").querystring( "a=1&b=2", 2 );

// Completely replace the `href` attribute's URL's fragment with
// "new-fragment", for every `a` element.
$("a").fragment( "new-fragment", 2 );

// Merge the current document's query string params into every
// `a[href]` and `form[action]` attribute, but don't
// propagate the "foo" parameter.
var qsObj = $.deparam.querystring();
delete qsObj.foo;
$("a, form").querystring( qsObj );
</pre>

### History & bookmarking via hashchange event ###

jQuery BBQ leverages the [hashchange event plugin][hashchange] to create a normalized, cross-browser `window.onhashchange` event that enables very powerful but easy to use location.hash state / history and bookmarking. Check out the [basic hashchange][ex-frag-basic], [advanced hashchange][ex-frag-advanced] and [jQuery UI Tabs history & bookmarking][ex-frag-tabs] examples, as well as the [documentation][docs] for more information.

<pre class="brush:js;auto-links:false">
// Be sure to bind to the "hashchange" event on document.ready, not
// before, or else it may fail in IE6/7. This limitation may be
// removed in a future revision.
$(function(){
  
  // Override the default behavior of all `a` elements so that, when
  // clicked, their `href` value is pushed onto the history hash
  // instead of being navigated to directly.
  $("a").click(function(){
    var href = $(this).attr( "href" );
    
    // Push this URL "state" onto the history hash.
    $.bbq.pushState({ url: href });
    
    // Prevent the default click behavior.
    return false;
  });
  
  // Bind a callback that executes when document.location.hash changes.
  $(window).bind( "hashchange", function(e) {
    // In jQuery 1.4, use e.getState( "url" );
    var url = $.bbq.getState( "url" );
    
    // In this example, whenever the event is triggered, iterate over
    // all `a` elements, setting the class to "current" if the
    // href matches (and removing it otherwise).
    $("a").each(function(){
      var href = $(this).attr( "href" );
      
      if ( href === url ) {
        $(this).addClass( "current" );
      } else {
        $(this).removeClass( "current" );
      }
    });
    
    // You probably want to actually do something useful here..
  });
  
  // Since the event is only triggered when the hash changes, we need
  // to trigger the event now, to handle the hash the page may have
  // loaded with.
  $(window).trigger( "hashchange" );
});
</pre>

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

_I want to thank [Paul Irish](http://paulirish.com/) and [Yehuda Katz](http://yehudakatz.com/) for all their help refining the jQuery BBQ API, as well as [Brandon Aaron](http://brandonaaron.net/) for explaining parts of the jQuery.event.special API for me and providing me the example code on which I based the [hashchange event plugin][hashchange]. I also want to thank everyone in the #jquery IRC channel on irc.freenode.net for all their suggestions and enthusiasm!_

