title: "jQuery urlInternal: Easily test URL internal-, external-, or fragment-ness"
categories: [ Projects, jQuery ]
tags: [ bbq, external, fragment, internal, jquery, plugin, url, urlexternal, urlfragment, urlinternal ]
date: 2009-10-06 23:44:17 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery urlInternal allows you to easily test internal-, external-, or fragment-ness for any relative or absolute URL. Includes element filtering methods and pseudo-selectors.

This plugin and the [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) plugin supersede the URL Utils plugin.

<!--MORE-->

 * Release v1.0
 * Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.
 * Download [Source][src], [Minified][src-min] (1.7kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [urlInternal / urlExternal / urlFragment][ex]

  [github]: http://github.com/cowboy/jquery-urlinternal
  [issues]: http://github.com/cowboy/jquery-urlinternal/issues
  [src]: http://github.com/cowboy/jquery-urlinternal/raw/master/jquery.ba-urlinternal.js
  [src-min]: http://github.com/cowboy/jquery-urlinternal/raw/master/jquery.ba-urlinternal.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-urlinternal/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-urlinternal/examples/urlinternal/
  
  [unit]: http://benalman.com/code/projects/jquery-urlinternal/unit/
  
  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/

## Why do I need this plugin? ##

Ok. Let's say you have a page full of links that you need to tweak. All the "external" links (linking to someone else's server) need to open in a new window, and also need a class added to them that displays a little "popup" icon. All the "internal" links need to have a few of the current page's query string parameters propagated through to them.

And all this needs to happen via JavaScript because your page caching strategy doesn't allow you to change these link `target` or `href` attributes for every user.

So, when you're only dealing with relative links, this is pretty easy. You know they're all "internal", while all the absolute links are "external". Well, except when they aren't. Just because a URL is absolute doesn't mean it goes to someone else's server. Some content management systems like to publish absolute URLs for internal pages. Sometimes your "content guy" just enters them that way. And in IE6/7, even relative URLs in `href`, `src`, or other "URL" attributes can't always be differentiated from absolute URLs (due to a [known bug](http://www.quirksmode.org/bugreports/archives/2005/02/getAttributeHREF_is_always_absolute.html)).

And the same thing goes for fragments. What do I mean by fragment? I consider a "fragment" to be any absolute or relative URL that, when navigated to, only changes the current page's location.href "hash". Fragments are used in single-page apps as a simple way to push a new state onto the browser history (see [jQuery BBQ][bbq] for some great examples of this).

Normally, you could just select `$("a[href^=#]")` to get a collection of all `a` elements that have an `href` starting with "#". These all contain fragments. Well, except in IE6/7, where no `href` will ever start with "#" because of that aforementioned bug! That's where this plugin comes in. It does all the dirty work, so you don't have to.

## How do I use this plugin? ##

It's pretty easy. Here are a few examples:

<pre class="brush:js">
// Open every external link in a new window.
$("a:urlExternal").attr( "target", "_blank" );

// Test if a URL is internal.
var url = "http://google.com/";
if ( $.isUrlInternal( url ) ) { /* this certainly won't execute */ }

// Pass document query string through to all internal links and forms (see
// jQuery BBQ for the query string methods).
$("a, form").urlInternal().querystring( $.deparam.querystring() );

// Pass just the "foo" query string parameter through to all internal links
// (see jQuery BBQ for the query string methods).
$("a:urlInternal").querystring({ foo: $.deparam.querystring().foo });

// Add an onclick handler to all fragment links (see jQuery BBQ for the
// pushState and fragment methods).
$("a:urlFragment").click(function(){
  var frag = $.param.fragment( $(this).attr( 'href' ) );
  $.bbq.pushState({ page: frag });
  return false;
});
</pre>

Since this is a very simple plugin, these are only a few very simple examples. Check out the [documentation][docs] and [live example][ex] for detailed usage information.

Also, you may have noticed that many of these examples reference [jQuery BBQ][bbq]. That's because these plugins complement each other. They _are_ different enough to warrant separating them, but don't be surprised if you find yourself using both of them together.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

