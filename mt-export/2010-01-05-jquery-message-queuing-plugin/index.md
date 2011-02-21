title: "jQuery Message Queuing: Get all your JavaScript ducks in a row"
categories: [ Projects, jQuery ]
tags: [ ajax, jquery, messaging, plugin, queue, throttling ]
date: 2010-01-05 12:33:38 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With jQuery Message Queuing, you can process and manage operations on large queues of items or elements. You can throttle, giving each operation a little breathing room (firing tracking pixels, performing DOM manipulations). You can force multiple asynchronous operations to execute serially (AJAX requests). You can also get some quantity of JavaScript ducks, put them in a boat, in a line, and have them fight loudly over who gets to use the oars.

<!--MORE-->

 * Release v1.0
 * Tested with jQuery 1.3.2 and jQuery 1.4a2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.
 * Download [Source][src], [Minified][src-min] (1.2kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [Serial AJAX][ex-ajax], [Throttling][ex-throttling]

  [github]: http://github.com/cowboy/jquery-message-queuing
  [issues]: http://github.com/cowboy/jquery-message-queuing/issues
  [src]: http://github.com/cowboy/jquery-message-queuing/raw/master/jquery.ba-jqmq.js
  [src-min]: http://github.com/cowboy/jquery-message-queuing/raw/master/jquery.ba-jqmq.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-message-queuing/docs/
  
  [ex-ajax]: http://benalman.com/code/projects/jquery-message-queuing/examples/ajax/
  [ex-throttling]: http://benalman.com/code/projects/jquery-message-queuing/examples/throttling/

  [unit]: http://benalman.com/code/projects/jquery-message-queuing/unit/

## Why this plugin exists ##

I initially wrote this plugin to throttle a high volume of Google Analytics tracking requests (among other things) in a complex web application. Because the application used frames (please, please don't ask) and the Google Analytics code lived in a different frame from the main application code, requests had to be able to be queued initially, even if the `pageTracker._trackPageview` method was not yet available.

After creating that core functionality, I realized that I could easily build some extra controls into the queue, add some chainable jQuery element-adding methods, and add in the ability for asynchronous requests to pause the queue until their callback completes, and a plugin was born.

Of course, that was eleven months ago. I completely forgot about this plugin until recently.. at which point I completely rewrote it, adding [documentation][docs], [unit tests][unit] and examples ([serial AJAX][ex-ajax], [throttling][ex-throttling]).

## Throttling ##

Let's say you have hundreds or thousands of similar operations you need to perform. For example: firing many tracking pixels, or performing costly DOM manipulations. If these operations need to hit a remote server or are computationally expensive, it's often a good idea to give them some breathing room, otherwise they'll use up all your bandwidth or CPU.

jQuery Message Queuing makes this easy, just set up a queue with a callback and delay, and add items onto the queue as-needed. Just take a look at the following examples, then view the live [throttling example][ex-throttling].

In this example, table rows are processed up to 100 at a time, until the queue is emptied. The status shows "processing..." until processing is finished, at which point the status is changed to "done!"

<pre class="brush:js">
// Create a new queue.
var q = $.jqmq({
  delay: 100,
  batch: 100,
  callback: function( elems ) {
    $(elems).each(function(){
      $(this).doSomethingExpensive();
    });
  },
  complete: function(){
    $('#status').html( 'done!' );
  }
});

// Add every row of a gigantic table.
$('#status').html( 'processing...' );
$('table tr').jqmqAddEach( q );

// Redrawing the table? Just clear the queue, redraw the table, and
// start over from the beginning.
q.clear();
redraw_table();
$('#status').html( 'processing...' );
$('table tr').jqmqAddEach( q );
</pre>

In this example, Google Analytics tracking requests are made whenever the mouse position changes, or an element is clicked. Of course, these requests are throttled, becasue there's going to be a LOT of them.

<pre class="brush:js">
// Create a new queue.
var q = $.jqmq({
  delay: 100,
  callback: function( item ) {
    pageTracker._trackPageview( item );
  }
});

// Add a new tracking request every time the mouse position changes.
// If you ever needed something like this, you'd want to debounce it
// using "hover intent" code like jQuery doTimeout allows:
// http://benalman.com/projects/jquery-dotimeout-plugin/
$(window).mousemove(function(e){
  q.add( '/mouse/' + e.pageX + ',' + e.pageY );
});

// Add a new tracking request every time an element is clicked.
$('body').live( 'click', function(e){
  q.add( '/click/' + e.target.nodeName );
});
</pre>

## Serial, asynchronous requests ##

Unlike the above examples, it's not always helpful to iterate over a queue using a fixed delay.

Sometimes, when you're making asynchronous requests, the callback might not fire for an indeterminate amount of time. If enough asynchronous requests take longer than the delay, this can lead to stacking of requests, which is often problematic from a performance perspective. Worse yet, if a prior request finishes after a later request due to latency issues, the later request's callback will actually fire before the prior request's callback, which can potentially cause problems.

This issue becomes a non-issue by setting `delay` to `-1`. At this point, the only way to advance the queue is to explicitly do so in the asynchronous request callback, forcing all requests to execute serially.

In this Serial AJAX example, data is requested from the server, one "thing" at a time. And because all the requests execute serially, the order of callback execution is guaranteed! Once you're done here, view the working [serial AJAX example][ex-ajax].

<pre class="brush:js">
// Create a new queue.
var q = $.jqmq({
  delay: -1,
  callback: function( id ) {
    var q = this;
    $.getJSON( '/get_thing_by_id', { id: id }, function(data) {
      if ( data.success ) {
        // Write some data about this thing onto the page.
        $('&lt;div id="thing' + data.id + '"/&gt;')
          .html( data.title )
          .appendTo( 'body' );
      }
      // If unsuccessful, re-add this item onto the beginning of the queue
      // for another try.
      q.next( !data.success );
    });
  }
});

// Add 100 ids onto the queue.
for ( var i = 0; i < 100; i++ ) {
  q.add( i );
}
</pre>

While these examples cover the basics, there are many other options and settings available. Please explore the [documentation][docs] as well as the [serial AJAX][ex-ajax] and [throttling][ex-throttling] examples.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

