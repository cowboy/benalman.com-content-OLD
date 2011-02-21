title: "JavaScript Debug: A simple wrapper for console.log"
categories: [ JavaScript, Projects ]
tags: [ console, javascript ]
date: 2010-06-22 06:49:19 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This code provides a simple wrapper for the console's logging methods, and was created to allow a very easy-to-use, cross-browser logging solution, without requiring excessive or unwieldy object detection. If a console object is not detected, all logged messages will be stored internally until a logging callback is added. If a console object is detected, but doesn't have any of the `debug`, `info`, `warn`, and `error` logging methods, `log` will be used in their place. For convenience, some of the less common console methods will be passed through to the console object if they are detected, otherwise they will simply fail gracefully.

<!--MORE-->

 * Release v0.4
 * No third-party JavaScript API or console required.
 * Tested in Internet Explorer 6-8, Firefox 3-3.6, Safari 3-4, Chrome 3-5, Opera 9.6-10.5.
 * Download [Source][src], [Minified][src-min] (1.1kb)
 * Follow the project on [GitHub project page][github]
 * View [Full Documentation][docs]
 * Example: [JavaScript Debug][example]

  [github]: http://github.com/cowboy/javascript-debug/tree/v0.4
  [src]: http://github.com/cowboy/javascript-debug/raw/v0.4/ba-debug.js
  [src-min]: http://github.com/cowboy/javascript-debug/raw/v0.4/ba-debug.min.js
  
  [docs]: http://benalman.com/code/projects/javascript-debug/docs/
  
  [example]: http://benalman.com/code/projects/javascript-debug/examples/debug/

## Benefits of using `debug` over `console` directly ##

*  No errors are thrown if `console` object doesn't exist, and no extra object detection is required, just log away!
* If the specified logging method doesn't exist, method will degrade to `log`.
* If `console` object doesn't exist, logs are stored internally and can be shown if and when an alternate console is added with `debug.setCallback`.
* Console logging can be disabled at any time with `debug.setLevel(0)`. This won't stop debug from storing logs, which allows you to inject a console (like [Firebug Lite](http://getfirebug.com/lite.html)) or log viewer after the fact, to see already-logged data.
* In WebKit, logged arguments are wrapped in an array [] for a more visually pleasing visual output.

<pre class="brush:js">
// Instead of this:
window.console && console.log
  && console.log( this, 'that', { the: 'other' } );

// Just do this:
debug.log( this, 'that', { the: 'other' } );
</pre>

## Supported logging methods, and their degradation path ##

* `debug.log` > `console.log`
* `debug.debug` > `console.debug` > `console.log`
* `debug.info` > `console.info` > `console.log`
* `debug.warn` > `console.warn` > `console.log`
* `debug.error` > `console.error` > `console.log`

For example:

<pre class="brush:js">
// If the current console doesn't have any of the four non-log
// methods used here, log will be used.

var a = 0,
  b = 'two',
  c = { foo: 1, bar: 2, baz: 'three' },
  d = false,
  e = [ 3, 4, 5, 6, 7, 8 ];

debug.log( a );
debug.debug( b );
debug.info( c );
debug.warn( d );
debug.error( e );
</pre>

(View a [live example][example])

## Pass-through console methods ##

* `assert`, `clear`, `count`, `dir`, `dirxml`, `exception`, `group`, `groupCollapsed`, `groupEnd`, `profile`, `profileEnd`, `table`, `time`, `timeEnd`, `trace`

These console methods are passed through (but only if both the console and the method exists), so use them without fear of reprisal. _Note that these methods will not be passed through if the logging level is set to 0 via debug.setLevel._

For example:

<pre class="brush:js">
// debug.time and debug.timeEnd only do something if console.time
// and console.timeEnd are defined, otherwise they fail gracefully.

debug.time( 'test' );
for ( var i = 0; i < 10000; i++ ) {
  document.createElement( 'div' );
}
debug.timeEnd( 'test' );
</pre>

(View a [live example][example])

## So, what do I do when `console` doesn't exist? ##

Here's a useful bookmarklet ([what's a bookmarklet?](http://benalman.com/projects/bookmarklets/)): <a class="bookmarklet" href="javascript:if(!window.firebug){window.firebug=document.createElement(&quot;script&quot;);firebug.setAttribute(&quot;src&quot;,&quot;http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js&quot;);document.body.appendChild(firebug);(function(){if(window.firebug.version){firebug.init()}else{setTimeout(arguments.callee)}})();void (firebug);if(window.debug&&debug.setCallback){(function(){if(window.firebug&&window.firebug.version){debug.setCallback(function(b){var a=Array.prototype.slice.call(arguments,1);firebug.d.console.cmd[b].apply(window,a)},true)}else{setTimeout(arguments.callee,100)}})()}};">Debug + Firebug Lite</a>

When clicked, if the page doesn't use JavaScript Debug, this bookmarklet will just open Firebug Lite. If the page does use JavaScript Debug, the bookmarklet will open Firebug Lite and pre-populate it with any already-logged items via the `debug.setCallback` method. View [the documentation][docs] for more information on `debug.setCallback`.

This bookmarklet is just one way of viewing debug logs, if you don't have a console. You could just as easily write your own alternative console, and log to that, for example:

<pre class="brush:js">
// This example uses jQuery, but yours doesn't need to.

function debug_callback( level ) {
  var args = Array.prototype.slice.call( arguments, 1 );
  $('#debug').length || $('&lt;div id="debug"/&gt;').appendTo( 'body' );
  $('&lt;div/&gt;')
    .addClass( 'debug-' + level )
    .html( '[' + level + '] ' + args )
    .appendTo( '#debug' );
};

debug.setCallback( debug_callback );
</pre>

(View a [live example][example])

## Can I temporarily disable logging? ##

Yes, very easily. Just add `debug.setLevel(0)` into your code, and all console logging will be disabled. This is very useful when you need your page or application to go live, but you're not ready to remove all your debugging hooks. Of course, this only disables *console* logging--since debug is still keeping track of logged messages, you can inject an alternate console (see the bookmarklet above) at any time to view the logs. View [the documentation][docs] for more information on `debug.setLevel`.

_Thanks again to [Paul Irish](http://paulirish.com/) and [Adam Sontag](http://ajpiano.com/) for their help with the API and examples._

