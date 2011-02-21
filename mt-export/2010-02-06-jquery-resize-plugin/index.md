title: "jQuery resize event"
categories: [ Projects, jQuery ]
tags: [ event, jquery, plugin, resize, throttle, window ]
date: 2010-02-06 16:11:48 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With jQuery resize event, you can now bind resize event handlers to elements other than window, for super-awesome-resizing-greatness!

<!--MORE-->

 * Release v1.1
 * Tested with jQuery 1.3.2, 1.4.1, 1.4.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (1.0kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [resize][ex]

  [github]: http://github.com/cowboy/jquery-resize
  [issues]: http://github.com/cowboy/jquery-resize/issues
  [src]: http://github.com/cowboy/jquery-resize/raw/v1.1/jquery.ba-resize.js
  [src-min]: http://github.com/cowboy/jquery-resize/raw/v1.1/jquery.ba-resize.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-resize/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-resize/examples/resize/
  
  [unit]: http://benalman.com/code/projects/jquery-resize/unit/

## Why is a plugin needed for the resize event? ##

Long ago, the powers-that-be decided that the resize event would only fire on the browser's window object. Unfortunately, that means that if you want to know when another element has resized, you need to manually test its width and height, periodically, for changes. While this plugin doesn't do anything fancy internally to obviate that approach, the interface it provides for binding the event is exactly the same as what's already there for window.

For all elements, an internal polling loop is started which periodically checks for element size changes and triggers the event when appropriate. The polling loop runs only once the event is actually bound somewhere, and is stopped when all resize events are unbound.

## What about window resizing? ##

Because the window object has its own resize event, it doesn't need to be provided by this plugin, and its execution can be left entirely up to the browser. However, since certain browsers fire the resize event continuously while others do not, this plugin throttles the window resize event (by default), making event behavior consistent across all elements.

Of course, you could just set the [`jQuery.resize.throttleWindow`](http://benalman.com/code/projects/jquery-resize/docs/files/jquery-ba-resize-js.html#jQuery.resize.throttleWindow) property to false to disable this, but why would you?

## A basic usage example ##

It couldn't be more easy, just use `.resize()` or `.bind( "resize", fn )` or `.trigger( "resize" )` just like you've always used them... except on any element your heart desires. Look at the [working examples][ex] for more details.

<pre class="brush:js">
// You know this one already, right?
$(window).resize(function(e){
  // do something when the window resizes
});

// Well, try this on for size!
$("#unicorns").resize(function(e){
  // do something when #unicorns element resizes
});

// And of course, you can still use .bind with namespaces!
$("span.rainbows").bind( "resize.rainbows", function(e){
  // do something when any span.rainbows element resizes
});
</pre>

## Known issues ##

* While this plugin works in jQuery 1.3.2, if an element's event callbacks are manually triggered via `.trigger( 'resize' )` or `.resize()` those callbacks may double-fire, due to limitations in the jQuery 1.3.2 special events system. This is not an issue when using jQuery 1.4+, and is explained in detail in the [documentation][docs].

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

