title: "jQuery throttle / debounce: Sometimes, less is more!"
categories: [ Projects, jQuery ]
tags: [ debounce, delay, event, jquery, plugin, throttle ]
date: 2010-03-06 13:38:46 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery throttle / debounce allows you to rate-limit your functions in multiple useful ways. Passing a delay and callback to `$.throttle` returns a new function that will execute no more than once every `delay` milliseconds. Passing a delay and callback to `$.debounce` returns a new function that will execute only once, coalescing multiple sequential calls into a single execution at either the very beginning or end.

<!--MORE-->

 * Release v1.1
 * Tested both without jQuery and with jQuery 1.3.2 and 1.4.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome 4-5, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (0.7kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [Throttling][ex-throttle], [Debouncing][ex-debounce]

  [github]: http://github.com/cowboy/jquery-throttle-debounce
  [issues]: http://github.com/cowboy/jquery-throttle-debounce/issues
  [src]: http://github.com/cowboy/jquery-throttle-debounce/raw/v1.1/jquery.ba-throttle-debounce.js
  [src-min]: http://github.com/cowboy/jquery-throttle-debounce/raw/v1.1/jquery.ba-throttle-debounce.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-throttle-debounce/docs/
  
  [ex-throttle]: http://benalman.com/code/projects/jquery-throttle-debounce/examples/throttle/
  [ex-debounce]: http://benalman.com/code/projects/jquery-throttle-debounce/examples/debounce/
  
  [unit]: http://benalman.com/code/projects/jquery-throttle-debounce/unit/


## Note for non-jQuery users ##

jQuery isn't actually required for this plugin, because nothing internal
uses any jQuery methods or properties. jQuery is just used as a namespace
under which these methods can exist.

Since jQuery isn't actually required for this plugin, if jQuery doesn't exist
when this plugin is loaded, the methods described below will be created in
the `Cowboy` namespace. Usage will be exactly the same, but instead of
$.method() or jQuery.method(), you'll need to use Cowboy.method().


## Throttle versus debounce ##

Both throttling and debouncing will rate-limit execution of a function, but which is appropriate for a given situation?

Well, to put it simply: while throttling limits the execution of a function to no more than once every delay milliseconds, debouncing guarantees that the function will only ever be executed a single time (given a specified threshhold).

For example, if your function is toggling a state, it won't be sufficient to simply throttle that function, because given enough calls over time, the throttled function will still execute more than once. In this case, because each subsequent execution "flips" the state back to its previous value, throttling won't do the trick, but debouncing will.

In another example, the scroll event fires continuously in certain browsers, which means in those browsers, any bound event handler will execute (probably) far more often than you want it to. If your scroll handler is modifying the DOM or performing some other expensive computation, throttling it will guarantee that it executes _far less_ frequently.

But perhaps you don't need constant updates, but just want to update things when the user has completed the scroll. In this case, debouncing the scroll event handler will guarantee that it doesn't fire until the user has finished scrolling.

Of course, if you wanted to take this example even further, you could use a pair of debounced event handlers (one using the at_begin parameter, the other not) to do something like set a class only while scrolling. Or only while the user is moving the mouse, or resizing the window, or doing anything else that fires many events sequentially. [See an example](http://jsfiddle.net/cowboy/cTZJU/show/)!


## Throttling ##

Using jQuery throttle / debounce, you can pass a delay and function to `$.throttle` to get a new function, that when called repetitively, executes the original function (in the same context and with all arguments passed through) no more than once every delay milliseconds.

Throttling can be especially useful for rate limiting execution of handlers on events like resize and scroll. Just take a look at the following usage example or the [working throttling examples][ex-throttle] to see for yourself!

### A Visualization ###

While `$.throttle` is designed to throttle callback execution, it behaves slightly differently based on how the `no_trailing` parameter is used.

<style type="text/css">
  img { border: none !important; }
  ul img { vertical-align: middle; }
</style>

Throttled with `no_trailing` specified as false or unspecified:
![throttled, no_trailing false](http://benalman.com/images/projects/jquery-throttle-debounce/throttle.png)

Throttled with `no_trailing` specified as true:
![throttled, no_trailing true](http://benalman.com/images/projects/jquery-throttle-debounce/throttle-no_trailing.png)

Key:

 * ![](http://benalman.com/images/projects/jquery-throttle-debounce/td-func.png) represents a throttled-function call.
 * ![](http://benalman.com/images/projects/jquery-throttle-debounce/callback.png) represents an actual callback execution.
 * spaces between multiple ![](http://benalman.com/images/projects/jquery-throttle-debounce/callback.png) represent the `delay` value.
 * ![](http://benalman.com/images/projects/jquery-throttle-debounce/pause.png) is a delay longer than the specified `delay` value.

### Usage example ###

<pre class="brush:js">
function log( event ) {
  console.log( $(window).scrollTop(), event.timeStamp );
};

// Console logging happens on window scroll, WAAAY more often
// than you want it to.
$(window).scroll( log );

// Console logging happens on window scroll, but no more than
// once every 250ms.
$(window).scroll( $.throttle( 250, log ) );

// Note that in jQuery 1.4+ you can unbind by reference using
// either the throttled function, or the original function.
$(window).unbind( 'scroll', log );
</pre>


## Debouncing ##

Using jQuery throttle / debounce, you can pass a delay and function to `$.debounce` to get a new function, that when called repetitively, executes the original function just once per "bunch" of calls, effectively coalescing multiple sequential calls into a single execution at either the beginning or end. For more information, see this [article explaining debouncing](http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/).

Debouncing can be especially useful for rate limiting execution of handlers on events that will trigger AJAX requests. Just take a look at the following usage example or the [working debouncing examples][ex-debounce] to see for yourself!

### A Visualization ###

While `$.debounce` is designed to debounce callback execution, it behaves slightly differently based on how the `at_begin` parameter is used.

Debounced with `at_begin` specified as false or unspecified:
![debounced, at_begin false](http://benalman.com/images/projects/jquery-throttle-debounce/debounce.png)

Debounced with `at_begin` specified as true:
![debounced, at_begin true](http://benalman.com/images/projects/jquery-throttle-debounce/debounce-at_begin.png)

Key:

* ![](http://benalman.com/images/projects/jquery-throttle-debounce/td-func.png) represents a debounced-function call.
* ![](http://benalman.com/images/projects/jquery-throttle-debounce/callback.png) represents an actual callback execution.
* ![](http://benalman.com/images/projects/jquery-throttle-debounce/pause.png) is a delay longer than the specified `delay` value.

### Usage example ###

<pre class="brush:js">
function ajax_lookup( event ) {
  // Perform an AJAX lookup on $(this).val();
};

// Console logging happens on keyup, for every single key
// pressed, which is WAAAY more often than you want it to.
$('input:text').keyup( ajax_lookup );

// Console logging happens on window keyup, but only after
// the user has stopped typing for 250ms.
$('input:text').keyup( $.debounce( 250, ajax_lookup ) );

// Note that in jQuery 1.4+ you can unbind by reference using
// either the throttled function, or the original function.
$('input:text').unbind( 'keyup', log );
</pre>

Just take a look at the [documentation][docs] for methods, arguments and usage, as well as the [throttling examples][ex-throttle] and [debouncing examples][ex-debounce].

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

