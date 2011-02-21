title: "jQuery replaceText: String replace for your jQueries!"
categories: [ Projects, jQuery ]
tags: [ dom, grep, jquery, plugin, regexp, replace, tree walk ]
date: 2009-11-21 16:07:43 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery replaceText will replace text in specified elements. Note that only text content will be modified, leaving all tags and attributes untouched.

<!--MORE-->

 * Release v1.1
 * Tested with jQuery 1.3.2 and 1.4.1 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (0.5kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * Example: [replaceText][ex]

  [github]: http://github.com/cowboy/jquery-replacetext
  [issues]: http://github.com/cowboy/jquery-replacetext/issues
  [src]: http://github.com/cowboy/jquery-replacetext/raw/master/jquery.ba-replacetext.js
  [src-min]: http://github.com/cowboy/jquery-replacetext/raw/master/jquery.ba-replacetext.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-replacetext/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-replacetext/examples/replacetext/

Recently, [Paul Irish](http://paulirish.com/) asked me how I would go about "wrappifying" text on a page with span tags, presumably for some CSS styling.. and he knows that if he mentions something enough, there's a pretty good chance I'll make a jQuery plugin for it. Of course, he's right, so.. here's the plugin. And Paul, you'd better use this thing!

## So, why not just set .html( new_text ) ? ##

While using the jQuery `.html()` method is one of the fastest ways to replace text in a huge HTML structure, when you do this, all event handlers and references bound to any child elements are lost. This is not good!

Now, if you have no event handlers or references to these elements, just update the `.html()` using a standard [string replace](https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/String/Replace), and everything will be super-fast! But if you do have event handlers and element references, you will need something a little "smarter" .. like this plugin.

## So, are there any caveats? ##

Not really. You should understand, however, that even though the String replace part of this plugin is very straightforward, two different methods are used internally for setting the new value, depending on whether or not that value contains HTML.

This is done because it's significantly faster to just set the content as text instead of setting it as HTML. The plugin is smart, however.. it will automatically render HTML using the second method, but only if HTML is detected in the new value (and this behavior can be overridden with the "text_only" argument).

Also, keep in mind that there are a few elements that don't really like to have HTML child elements.. like `textarea`, `pre` and `code`. You can see how this can be dealt with in [the examples][ex], but to make a long story short.. either use the "text_only" argument, or explicitly avoid those elements by using an initial selector like `$("body :not(textarea)")` instead of `$("body *")`.

## So, how do I use this thing? ##

It's easy! Here are some examples.

<pre class="brush:js">
// Replace all instances of "this" or "that" with "the other".
$("body *").replaceText( /this|that/gi, "the other" );

// Wrap all instances of "this" or "that" in &lt;b&gt; tags, generating HTML
// in the process!
function embolden( str ){
  return "&lt;b&gt;" + str + "&lt;\/b&gt;";
};

$("body *").replaceText( /this|that/gi, embolden );

// Of course, you could just do this if you want to wrap something in
// &lt;b&gt; tags.. I was just illustrating how using a replace callback
// would work.
$("body *").replaceText( /(something)/gi, "&lt;b&gt;$1&lt;\/b&gt;" );

// This is a "better" example of why you might want to use a callback:
// Wrap every word on the page in a span, giving it a title with that
// word's definition if possible.
var dictionary = {
  "word": "this is the definition for word",
  "otherword": "this is the definition for otherword",
  ...
};

function get_definition( str ){
  return dictionary[ str ]
    ? '&lt;span title="' + dictionary[ str ] + '"&gt;' + str + '&lt;\/span&gt;'
    : str;
};

$("body *").replaceText( /\b(\S+?)\b/g, get_definition );
</pre>

The plugin usage is really quite simple. Just check out the [documentation][docs] and [example][ex] if you want to see it in action!

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

