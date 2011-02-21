title: "jQuery doTimeout: Like setTimeout, but better"
categories: [ Projects, jQuery ]
tags: [ debouncing, delay, hoverintent, jquery, plugin, polling, setInterval, setTimeout, timeout ]
date: 2009-07-15 15:41:17 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery doTimeout takes the work out of delayed code execution, including interval and timeout management, polling loops and debouncing. In addition, it's fully [jQuery](http://jquery.com/) chainable!

<!--MORE-->

Generally, `setTimeout` is used in JavaScript to delay the execution of some code, which is fairly easy to do and doesn't require much, if any additional code. Where it starts to get a little more complicated is when you want to [debounce][debounce] or poll, or need any kind of timeout management--at which point keeping track of and clearing multiple timeout ids becomes critical and potentially messy. doTimeout maintains its own internal cache of ids and callbacks, so you don't have to. Just think of setTimeout, but with additional management options, jQuery chainable, and with a simpler and more flexible API.

 * Release v1.0
 * Tested with jQuery 1.3.2 and jQuery 1.4.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome 4-5, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (1.0kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [Debouncing][ex-debouncing], [Delays & Polling Loops][ex-delay-poll], [Hover Intent][ex-hoverintent]

  [github]: http://github.com/cowboy/jquery-dotimeout
  [issues]: http://github.com/cowboy/jquery-dotimeout/issues
  [src]: http://github.com/cowboy/jquery-dotimeout/raw/v1.0/jquery.ba-dotimeout.js
  [src-min]: http://github.com/cowboy/jquery-dotimeout/raw/v1.0/jquery.ba-dotimeout.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-dotimeout/docs/
  
  [ex-debouncing]: http://benalman.com/code/projects/jquery-dotimeout/examples/debouncing/
  [ex-delay-poll]: http://benalman.com/code/projects/jquery-dotimeout/examples/delay-poll/
  [ex-hoverintent]: http://benalman.com/code/projects/jquery-dotimeout/examples/hoverintent/
  
  [unit]: http://benalman.com/code/projects/jquery-dotimeout/unit/
  
  [debounce]: http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/

## Examples ##

Basic `setTimeout` usage (see the [basic examples][ex-delay-poll]):

<pre class="brush:js">
// Like setTimeout.
$.doTimeout( 1000, function(){
  // do something in 1 second
});

// Like setTimeout, but easily cancelable (or forceable).
$.doTimeout( 'someid', 2000, function(){
  // do something in 2 seconds
});

// Override the preceding doTimeout with a new one.
$.doTimeout( 'someid', 1000, function( state ){
  alert( state ); // alert true in 1 second
}, true);

// Outright cancel the preceding doTimeout.
$.doTimeout( 'someid' );

// Or force the callback execution immediately (synchronously).
$.doTimeout( 'someid', false );
</pre>

Create a polling loop (see the [polling loop examples][ex-delay-poll]):

<pre class="brush:js">
// Poll every 100ms until some_condition is true
$.doTimeout( 100, function(){
  if ( some_condition ) {
    // do something finally
    return false;
  }
  return true;
});

// Poll every 100ms until some_condition is true,
// cancelable (or forceable).
$.doTimeout( 'someid', 100, function(){
  if ( some_condition ) {
    // do something finally
    return false;
  }
  return true;
});

// Outright cancel the preceding doTimeout polling loop.
$.doTimeout( 'someid' );

// Or force the callback execution immediately
// (synchronously), canceling the polling loop.
$.doTimeout( 'someid', false );

// Or force the callback execution immediately
// (synchronously), NOT canceling the polling loop.
$.doTimeout( 'someid', true );
</pre>

Debounce some event handlers (see the [debouncing examples][ex-debouncing]):

<pre class="brush:js">
// Typing into a textfield (250ms delay)
$('input:text').keyup(function(){
  $(this).doTimeout( 'typing', 250, function(){
    // do something with text, like an ajax lookup
  });
});

// Window resize (IE and Safari fire this event continually)
$(window).resize(function(){
  $.doTimeout( 'resize', 250, function(){
    // do something computationally expensive
  });
});
</pre>

And this is a jQuery plugin after all, so let's chain with it (see the [delay and polling loop examples][ex-delay-poll]):

<pre class="brush:js">
var elems = $('a');

// Create a cancelable (or forceable) doTimeout.
elems
  .doTimeout( 'someid', 2000, 'removeClass', 'remove-me-in-two-seconds' )
  .addClass( 'remove-me-in-two-seconds' );

// Outright cancel the preceding doTimeout.
elems.doTimeout( 'someid' );

// Or force the callback execution immediately (synchronously).
elems.doTimeout( 'someid', true );

// "Poll" every 100ms, iterating over each element until
// none are left.
var idx = 0;
elems
  .doTimeout( 100, function(){
    var elem = this.eq( idx++ );
    if ( elem.length ) {
      elem.removeClass( 'remove-me-one-elem-at-a-time' );
      return true;
    }
  })
  .addClass( 'remove-me-one-elem-at-a-time' );
</pre>

Just take a look at the [documentation][docs] for methods, arguments and
usage, as well as the examples, which include [hover intent][ex-hoverintent], [delayed
input on form fields][ex-debouncing], [polling][ex-delay-poll], and a few event handler [debouncing][ex-debouncing] demos (among others).

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

