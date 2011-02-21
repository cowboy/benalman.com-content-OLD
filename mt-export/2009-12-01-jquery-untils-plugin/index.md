title: "jQuery Untils: nextUntil, prevUntil, parentsUntil"
categories: [ Projects, jQuery ]
tags: [ core, dom, jquery, next, parents, plugin, prev, siblings, traversal ]
date: 2009-12-01 11:21:59 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery Untils provides three very simple, but very useful methods: nextUntil, prevUntil, and parentsUntil. These methods are based on their nextAll, prevAll, and parents counterparts, except that they allow you to stop when a certain selector is reached. Elements are returned in "traversal order".

<!--MORE-->

<p class="warn">
  As of jQuery 1.4, these methods are now included in jQuery core! See the <a href="http://github.com/jquery/jquery/commit/2b481b93cfca62f95aa7005e7db651456fa08e65">patch</a> as well as the official documentation on the
<a href="http://api.jquery.com/prevUntil/">.prevUntil</a>, 
<a href="http://api.jquery.com/nextUntil/">.nextUntil</a> and
<a href="http://api.jquery.com/parentsUntil/">.parentsUntil</a> methods.
</p>

 * Release v1.1
 * Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 2-3.7, Safari 3-4, Chrome 4-5, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (0.6kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [nextUntil][ex-nextuntil], [prevUntil][ex-prevuntil], [parentsUntil][ex-parentsuntil] 

  [github]: http://github.com/cowboy/jquery-untils
  [issues]: http://github.com/cowboy/jquery-untils/issues
  [src]: http://github.com/cowboy/jquery-untils/blob/v1.1/jquery.ba-untils.js
  [src-min]: http://github.com/cowboy/jquery-untils/blob/v1.1/jquery.ba-untils.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-untils/docs/
  
  [ex-nextuntil]: http://benalman.com/code/projects/jquery-untils/examples/nextuntil/
  [ex-prevuntil]: http://benalman.com/code/projects/jquery-untils/examples/prevuntil/
  [ex-parentsuntil]: http://benalman.com/code/projects/jquery-untils/examples/parentsuntil/
  
  [unit]: http://benalman.com/code/projects/jquery-untils/unit/

Note that these methods take a less naïve approach than others bearing the same names, and are designed to actually return elements in traversal order, despite the element ordering flaws inherent in the jQuery 1.3.2 selector engine.

## Basic usage ##

<pre class="brush:js">

// Select all list items between the first and last.
$("ul > :first").nextUntil( ":last" );

// The same elements, in the opposite order.
$("ul > :last").prevUntil( ":first" );

// Select all "div" elements between .foo and .bar
$(".foo").nextUntil( ".bar", "div" );

// Select all parent elements, excluding body and html.
$(".foo").parentsUntil( "body" );

</pre>

## Advanced usage ##

This is not rocket science. There really is no "advanced" usage!

## But, seriously ##

This plugin is going to do exactly what you expect, except that it takes care of some general jQuery 1.3.2 selector issues when there are multiple elements in the initial selector. This might be an edge-case, but it exists nonetheless.

Just take a look at the [nextUntil][ex-nextuntil], [prevUntil][ex-prevuntil] and [parentsUntil][ex-parentsuntil] examples to see what's going on.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

