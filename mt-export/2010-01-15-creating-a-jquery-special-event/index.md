title: "Creating a jQuery Special Event "
categories: [ Code, News ]
tags: [ @hidden, @nonav, @nosearch ]
date: 2010-01-15 22:24:04 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

The jQuery special events API is a fairly flexible system by which you can specify bind and unbind hooks as well as default actions for custom events. In using this API, you can create custom events that do more than just execute bound event handlers when triggered--these "special" events can modify the event object passed to event handlers, trigger other entirely different events, or execute complex setup and teardown code when events are bound to or unbound from elements.



<!--MORE-->


[plugin-resize]: http://benalman.com/projects/jquery-resize-plugin/
[plugin-hashchange]: http://benalman.com/projects/jquery-hashchange-plugin/
[plugin-bbq]: http://benalman.com/projects/jquery-bbq-plugin/
[plugin-outside]: http://benalman.com/projects/jquery-outside-events-plugin/

* [The special event API](#api)
  * Methods: 
  [setup](#api-setup), 
  [teardown](#api-teardown), 
  [add](#api-add), 
  [remove](#api-remove), 
  [_default](#api-default)
  * [jQuery version compatibility](#version-compatibility)
* [A jQuery special event pattern, AKA code organization](#pattern)
* [Setup and teardown](#setup-and-teardown)
  * Custom events: 
  [click](#setup-and-teardown-click), 
  [tripleclick](#setup-and-teardown-tripleclick), 
  [resize: heavy polling](#setup-and-teardown-resize-heavy), 
  [resize: minimal polling](#setup-and-teardown-resize-minimal)
* [Add and remove](#add-and-remove)
  * Custom events: 
  [hashchange](#add-and-remove-hashchange), 
  [clickoutside](#add-and-remove-clickoutside), 
  [tripleclick: revisited](#add-and-remove-tripleclick), 
  [theoretical exercise](#add-and-remove-theoretical)
* [A default action](#default)
  * []()
  * []()
  * []()
  * []()
.


## Then and now ##

Back in the dark ages of jQuery development, if you wanted an arbitrary callback to be executed whenever a certain condition was met, you'd just create a "When Condition Met" plugin, which would be used like `$.whenConditionMet( callback )`. Inside the `$.whenConditionMet` method, magic would happen such that the callback was executed at the appropriate time, and that's that.

Of course, if you wanted to be able to de-register a callback, you'd need to figure out how you wanted to handle that.. maybe `$.whenConditionMet( callback, false )` or perhaps a `$.noLongerCareAboutCondition` method, or maybe even a polite note in the documentation suggesting the end-user "refresh the page."

This was adequate for simple use-cases, but because a well thought-out, flexible API didn't exist, more complicated scenarios could get _really_ messy.

What if, instead of creating a `$.whenConditionMet` method, you could just create a custom "conditionmet" event that callbacks could be bound to? What if those callbacks could be [bound](http://api.jquery.com/bind/), [triggered](http://api.jquery.com/trigger/) or [unbound](http://api.jquery.com/unbind/), with or without [namespaces](http://docs.jquery.com/Namespaced_Events)? What if that custom event [bubbled up the DOM tree](http://api.jquery.com/category/events/event-object/), could have its [propagation stopped](http://api.jquery.com/event.preventDefault/) and could even have a [default action](http://api.jquery.com/event.preventDefault/) as well? What if this custom event, powered by advanced JavaScript magic hitherto undreamed of behaved _exactly_ like every other [jQuery event](http://api.jquery.com/category/events/)?

You've probably got the idea by now, so without further ado, let's get into the details.


<a name="api"></a>
## The special events API ##

A special event can be defined using the following five methods. Each method is optional, and only needs to be specified if necessary. The namespace for the special event is `jQuery.event.special.myevent` where `myevent` is the name of your event. Also note that while you can have any number of other methods and properties attached to this namespace, all but these five will be ignored:

<pre class="brush:js">
jQuery.event.special.myevent = {
  setup: function( data, namespaces, eventHandle ) {
    // code
  },
  teardown: function( namespaces ) {
    // code
  },
  add: function( handleObj ) {
    // code
  },
  remove: function( handleObj ) {
    // code
  },
  _default: function( event ) {
    // code
  }
};
</pre>

<a name="api-setup"></a>
#### setup ####

> Do something when the first event handler is bound to a particular element.
> 
> _More explicitly: do something when an event handler is bound to a particular element, but only if there are not currently any event handlers bound. This may occur in two scenarios: 1) either the very first time that event is bound to that element, or 2) the next time that event is bound to that element, after all previous handlers for that event have been unbound from that element._

Method arguments:

* `data` - (Anything) Whatever `eventData` (optional) was passed in when binding the event.
* `namespaces` - (Array) An array of namespaces specified when binding the event.
* `eventHandle` - (Function) The actual function that will be bound to the browser's native event. This is used internally for the `beforeunload` event.

Notes:

* Returning `false` tells jQuery to bind the specified event using native DOM methods.
* `this` is the element to which the event is being bound.
* This method, when executed, will always execute immediately _before_ the corresponding `add` method executes.

<a name="api-teardown"></a>
#### teardown ####

> Do something when the last event handler is unbound from a particular element.

Method arguments:

* `namespaces` - (Array) An array of namespaces specified when unbinding the event.

Notes:

* Returning `false` tells jQuery to unbind the specified event using native DOM methods.
* `this` is the element from which the event is being unbound.
* This method, when executed, will always execute immediately _after_ the corresponding `remove` method executes.

<a name="api-add"></a>
#### add ####

> Do something each time an event handler is bound to a particular element.

Method arguments:

* `handleObj` - (Object) An object containing these properties (same as the `remove` method):
  * `type` - (String) The name of the event.
  * `data` - (Anything) Whatever data object (optional) was passed in when binding the event.
  * `namespace` - (String) A sorted, dot-delimited list of namespaces specified when binding the event.
  * `handler` - (Function) The event handler being bound to the event. This function will be called whenever the event is triggered.
  * `guid` - (Number) A unique ID for this event handler. This is used internally for managing handlers.

Notes:

  * `this` is the element to which the event is being bound.
  * This method, when executed, will always execute immediately _after_ the corresponding `setup` method executes.

<a name="api-remove"></a>
#### remove ####

> Do something each time an event handler is unbound from a particular element.

Method arguments:

* `handleObj` - (Object) An object containing these properties (same as the `add` method):
  * `type` - (String) The name of the event.
  * `data` - (Anything) Whatever data object (optional) was passed in when binding the event.
  * `namespace` - (String) A sorted, dot-delimited list of namespaces specified when binding the event.
  * `handler` - (Function) The event handler being bound to the event. This function will be called whenever the event is triggered.
  * `guid` - (Number) A unique ID for this event handler. This is used internally for managing handlers.

Notes:

* `this` is the element from which the event is being unbound.
* This method, when executed, will always execute immediately _before_ the corresponding `teardown` method executes.

<a name="api-default"></a>
#### _default ####

> The default action for the event. This callback will be triggered unless event.preventDefault() is called.

Method arguments:

* `event` - (Object) The jQuery event object.

Notes:

* Returning `false` does... TODO: ASK RESIG
* `this` will always reference `document` (TODO: ASK RESIG), so it's not particularly useful.


<a name="version-compatibility"></a>
### jQuery version compatibility ###

The special events API has been evolving since jQuery 1.2.2, when the `setup` and `teardown` methods were first added. Initially, those methods accepted no arguments, but in jQuery 1.3, the `data` and `namespaces` arguments were added, and in jQuery 1.4, the `eventHandle` argument was added. Also in jQuery 1.4, The `add` and `remove` methods were added, but their signatures changed in jQuery 1.4.2 along with the addition of a `_default` method.

As such, due to a few special event-related issues in jQuery 1.4 and 1.4.1, I strongly advise against using those jQuery versions, and recommend using jQuery 1.4.2 (or newer, when available). And if you're stuck using jQuery 1.3.2, everything pertaining to the `setup` and `teardown` methods still applies, so be sure to read on!


<a name="pattern"></a>
## A jQuery special event pattern, AKA code organization ##

While additional properties and methods can be added into the `jQuery.event.special.myevent` namespace, this approach should be avoided. By using a closure, the code is easy to read, minifies smaller, allows internal methods and properties (like `some_var` and `init`) to be private, and allows you to use the much more terse `$` instead of `jQuery` without fear of conflict:

_(All of the code examples in this article as well as all my jQuery special events plugins are based on this pattern, so feel free to examine their code: [resize event][plugin-resize], [hashchange event][plugin-hashchange], [outside events][plugin-outside] and [BBQ][plugin-bbq])_

#### The code ####
<pre class="brush:js">
(function($){
  
  // A private property.
  var some_var;
  
  // Special event definition.
  $.event.special.myevent = {
    setup: function( data, namespaces ) {
      init( this, true );
    },
    teardown: function( namespaces ) {
      init( this, false );
    },
    add: function( handleObj ) {
      var old_handler = handleObj.handler;
      handleObj.handler = function( event ) {
        // Modify event object here!
        old_handler.apply( this, arguments );
      };
    }
  };
  
  // A private method.
  function init( elem, state ) {
    // Do something to `elem` based on `state`
  };
  
})(jQuery);
</pre>


<a name="setup-and-teardown"></a>
## Setup and teardown ##

When binding an event handler for a "special" event, if no event handlers are currently bound to the element in question, the `setup` method is called. This effectively allows you to setup or initialize complex code for that event on a per-element basis to "enable" it to work. The `teardown` method works in exactly the same way, except that it's called when the last event handler is being unbound from an element.

In addition, if either the `setup` or `teardown` methods return `false`, jQuery will bind (or unbind) the event using native DOM methods. This is useful when you want to augment an existing event with additional functionality, which brings us to our first example:


<a name="setup-and-teardown-click"></a>
### Custom click event ###

[David Walsh](http://davidwalsh.name/mootools-add-event) posted an article not too long ago expressing his frustration that many site designers bind click event handlers to non-anchor elements, without updating those elements' CSS to change the mouse cursor to "pointer", signifying that the element is clickable. It might be a minor detail, but it's one I agree with completely.

The traditional way to do this would be to set an inline style on the element every time a click event handler is bound, like `$('div').css( 'cursor', 'pointer' ).click( fn )` (or add a predefined "clickable" class), but that's potentially a lot of extra code in your application. Another approach might be to to create a `$.fn.bindCustomClick` method that is effectively a wrapper for just that, which results in less code.. but just ends up being an unnecessary abstraction.

Fortunately, the special events API can be used to make this automatic. As in David's [jQuery solution](http://davidwalsh.name/add-events-jquery), in this example a special "click" event is set up such that whenever the first click event handler is bound to an element, an inline style is automatically set on that element, with the reverse happening when the last event handler is unbound.. and because the `setup` and `teardown` methods return `false`, jQuery binds the click event normally, using the native DOM methods.

#### The code ####
<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.click = {
    setup: function() {
      // This is only done the first time a "click" event handler is bound,
      // per-element.
      $(this).css( 'cursor', 'pointer' );
      
      // Bind the "click" event normally.
      return false;
    },
    teardown: function() {
      // This is only done the last time a "click" event handler is unbound,
      // per-element.
      $(this).css( 'cursor', '' );
      
      // Unbind the "click" event normally.
      return false;
    }
  };
  
})(jQuery);
</pre>

#### Sample Usage ####
<pre class="brush:js">
  $(function(){
    
    // All div elements will have their cursor automatically pointer-ified.
    $('div').bind( 'click', function(){
      alert( 'I have been clicked!' );
    });
    
  });
</pre>


<a name="setup-and-teardown-tripleclick"></a>
### Custom tripleclick event ###

Unlike the native browser "click" and "dblclick" events, there is no native "tripleclick" event, but that didn't stop [Brandon Aaron](http://brandonaaron.net/blog/2009/03/26/special-events) from creating one last year using the special events API. At its core, the tripleclick event is powered by the click event. Click three times within a certain time threshold, and the tripleclick event fires.

In the following example, because the tripleclick event doesn't exist natively, there's no need for jQuery to bind to it using the native DOM methods, so it makes no sense to return `false`. And unlike the previous example, which "piggybacks" additional code onto an existing event, this special event creates an entirely new "custom" event that is powered by another, existing event.

A few things to note about the `setup` method's first argument, which may be specified as `eventData` when the event is bound (see the [official bind method documentation](http://api.jquery.com/bind/)):

* `eventData` can be any data type, except Function. While an Object is usually passed, it can also be a String, Number or Boolean.
* Because the `setup` method only fires the first time an special event is bound to an element, using the approach outlined in this example will cause only the first bind's `eventData` to be used (but see the [custom tripleclick event: revisited](#add-and-remove-tripleclick) example later in this article for a way around this limitation).

<!-- http://jsfiddle.net/cowboy/ErA8f/ -->

<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.tripleclick = {
    setup: function( data ) {
      // When the event is first bound, initialize the element plugin data
      // and bind the "click" event handler that will be used to power the
      // custom "tripleclick" event.
      $(this)
        .data( 'tripleclick', {
          clicks: 0,              // Clicks counter.
          last: 0,                // Last-clicked timestamp.
          threshold: data || 500  // Click speed threshold.
        })
        .bind( 'click', click_handler );
    },
    teardown: function() {
      // When the last event is unbound, remove all element plugin data and
      // unbind the "click" event handler.
      $(this)
        .removeData( 'tripleclick' )
        .unbind( 'click', click_handler );
    }
  };
  
  // This function is executed every time an element is clicked.
  function click_handler( event ) {
    var elem = $(this),
      
      // Get plugin data stored on the element.
      data = elem.data( 'tripleclick' );
    
    // If more than `threshold` time has passed since the last click, reset
    // the clicks counter.
    if ( event.timeStamp - data.last > data.threshold ) {
      data.clicks = 0;
    }
    
    // Update the element's last-clicked timestamp.
    data.last = event.timeStamp;
    
    // Increment the clicks counter. If the counter has reached 3, trigger
    // the "tripleclick" event and reset the clicks counter to 0.
    if ( ++data.clicks === 3 ) {
      elem.trigger( 'tripleclick' );
      data.clicks = 0;
    }
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // When '#foo' has been triple-clicked within the default threshold of
    // 500 milliseconds, the message will alert.
    $('#foo').bind( 'tripleclick', function(){
      alert( 'I have been triple-clicked!' );
    });
    
    // When '#bar' has been triple-clicked within the specified threshold of
    // 250 milliseconds, the message will alert.
    $('#bar').bind( 'tripleclick', 250, function(){
      alert( 'I have also been triple-clicked!' );
    });
    
    // When '#bar' has been triple-clicked within the originally specified
    // threshold of 250 milliseconds, the message will alert. Since `setup`
    // doesn't execute for subsequent bound handlers, the only way to change
    // the threshould (in this case) would be to unbind and then rebind all
    // event handlers.
    $('#bar').bind( 'tripleclick', function(){
      alert( 'Another triple-click alert!' );
    });
    
  });
</pre>


<a name="setup-and-teardown-resize-heavy"></a>
### Custom resize event: heavy on the polling ###

Long ago, the powers-that-be decided that the "resize" event would only fire on the browser’s `window` object, so it's unfortunately not available on other elements. Of course, it _could_ be, if the special events API were involved, so I recently created a [jQuery resize event][plugin-resize] plugin.

Because there is no event that gets fired when an element resizes, the custom resize event can't be "powered" by another event as in the "tripleclick" event. Instead, for each element to which the custom resize event is bound, a periodic measurement of that element's dimensions must be taken, triggering the event on that element if either the width or height has changed since the last measurement.

So, for each element to which the event is bound, a polling loop is started which periodically checks for element size changes and triggers the event when appropriate. And thanks to the `setup` and `teardown` methods, the polling loop can be started only once the event is actually bound to an element, and can be stopped when all resize events are unbound from that element.

_(See the next special event example, [custom resize event: minimal polling](#setup-and-teardown-resize-minimal) for code that looks more like the actual [jQuery resize event][plugin-resize] plugin)_

<!-- http://jsfiddle.net/cowboy/FUqe9/ -->

<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.resize = {
    setup: function() {
      var elem = $(this);
      
      // Initialize default plugin data on this element.
      elem.data( 'resize', { w: elem.width(), h: elem.height() } );
      
      // Start polling loop for this element.
      poll( elem );
    },
    teardown: function() {
      var elem = $(this),
        data = elem.data( 'resize' );
      
      // Since no more "resize" events are bound to this element, cancel
      // polling loop.
      clearTimeout( data.timeout_id );
      
      // Remove plugin data from this element.
      elem.removeData( 'resize' );
    }
  };
  
  // As long as a "resize" event is bound, this function will execute
  // repeatedly.
  function poll( elem ) {
    
    var width = elem.width(),
      height = elem.height(),
      data = elem.data( 'resize' );
    
    // If element size has changed since the last time, update the element
    // data store and trigger the "resize" event.
    if ( width !== data.w || height !== data.h ) {
      elem.trigger( 'resize' );
    }
    
    // Poll, storing timeout_id in element data so the polling loop can be
    // canceled.
    data.timeout_id = setTimeout( function(){ poll( elem ); }, 250 );
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // When any 'div' element has resized, log the new size to the console.
    $('div').bind( 'resize', function(){
      var width = $(this).width(),
        height = $(this).height(),
      
      console.log( 'Size: ' + width + 'x' + height );
    });
    
  });
</pre>


<a name="setup-and-teardown-resize-minimal"></a>
### Custom resize event: minimal polling ###

While this custom "resize" event example provides the same functionality as the previous example, it has been structured differently to improve performance. Whereas the previous example used one polling loop per element, this example uses a single polling loop for _all_ elements. In general, polling loops should be avoided wherever possible. And while it's not possible to avoid polling in the case of a custom resize event, there is no reason to create a separate polling loop for each element.

In addition to using the `setup` and `teardown` methods to initialize a specific element when an event is bound or unbound from that element, these methods can also be utilized to perform a much more "global" task, like updating a private property inside the special event's closure. In this example, the `elems` variable contains a collection of all elements to which the event is bound, that is iterated over each time the polling loop function executes. And because this collection of elements has a length, the polling loop can be started only when it's needed, and stopped otherwise.

_(Note that in the "real world," while the overall structure of this special event is the same, some additional logic had to be written to prevent double-firing of the event callback when the event was manually triggered. See my [jQuery resize event][plugin-resize] plugin for the complete, finished source)_

<pre class="brush:js">
(function($){
  
  // A collection of elements to which the resize event is bound.
  var elems = $([]),
  
    // An id with which the polling loop can be canceled.
    timeout_id;
  
  // Special event definition.
  $.event.special.resize = {
    setup: function() {
      var elem = $(this);
      
      // Add this element to the internal collection.
      elems = elems.add( elem );
      
      // Initialize default plugin data on this element.
      elem.data( 'resize', { w: elem.width(), h: elem.height() } );
      
      // If this is the first element to which the event has been bound,
      // start the polling loop.
      if ( elems.length === 1 ) {
        poll();
      }
    },
    teardown: function() {
      var elem = $(this);
      
      // Remove this element from the internal collection.
      elems = elems.not( elem );
      
      // Remove plugin data from this element.
      elem.removeData( 'resize' );
      
      // If this is the last element to which the event was bound, cancel
      // the polling loop.
      if ( !elems.length ) {
        clearTimeout( timeout_id );
      }
    }
  };
  
  // As long as a "resize" event is bound, this function will execute
  // repeatedly.
  function poll() {
    
    // Iterate over all elements in the internal collection.
    elems.each(function(){
      var elem = $(this),
        width = elem.width(),
        height = elem.height(),
        data = elem.data( 'resize' );
      
      // If element size has changed since the last time, update the element
      // data store and trigger the "resize" event.
      if ( width !== data.w || height !== data.h ) {
        elem.trigger( 'resize' );
      }
    });
    
    // Poll, setting timeout_id so the polling loop can be canceled.
    timeout_id = setTimeout( poll, 250 );
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // When any div element has resized, log the new size to the console.
    $('div').bind( 'resize', function(){
      var width = $(this).width(),
        height = $(this).height(),
      
      console.log( 'Size: ' + width + 'x' + height );
    });
    
  });
</pre>


<a name="add-and-remove"></a>
## Add and remove ##

The `add` and `remove` methods, added in jQuery 1.4 (and revamped in 1.4.2), work much like their `setup` and `teardown` counterparts, but they are called _every_ time an event is bound or unbound from an element, not just the first and last times (and their signatures are a bit different).

The single `handleObj` argument passed into these methods contains a number of useful properties, most useful of which is the `handler` method. This is the event handler being bound to the event, which is what gets called every time the event is triggered.

Since `handleObj.handler` is available at the time the event is being bound, it's possible to override the handler method to do something useful every time the event is triggered, like augment the [event object](http://api.jquery.com/category/events/event-object/) with a custom property or even override an existing event object property.


<a name="add-and-remove-hashchange"></a>
### Custom hashchange event ###

This simple "hashchange" special event is a good segue between the preceding "setup and teardown" section and the current "add and remove" section because it not only uses the `setup` and `teardown` methods to start and stop a polling loop (but only in browsers that don't natively support the hashchange event), but it also illustrates how the event object can be augmented with a custom property:

_(Note that in the "real world," while the overall structure of this special event is the same, a fair amount of additional code had to be written to make it work correctly cross-browser. In addition, I have split the functionality such that while my [jQuery hashchange event][plugin-hashchange] plugin creates the event in browsers that don't natively support it, my [jQuery BBQ][plugin-bbq] plugin augments that event with an additional property and method, among other things)_

<!-- http://jsfiddle.net/cowboy/hKpgT/ -->

<pre class="brush:js">
(function($){
  
  // Store the initial location.hash so that the event isn't triggered when
  // the page is first loaded.
  var last_hash = location.hash,
    
    // An id with which the polling loop can be canceled.
    timeout_id;
  
  // Special event definition.
  $.event.special.hashchange = {
    setup: function() {
      // If the event is supported natively, return false so that jQuery
      // will bind to the event using DOM methods instead of using the
      //  polling loop.
      if ( 'onhashchange' in window ) { return false; }
      
      // Start the polling loop if it's not already running.
      start();
    },
    teardown: function() {
      // If the event is supported natively, return false so that jQuery
      // will bind to the event using DOM methods instead of using the
      // polling loop.
      if ( 'onhashchange' in window ) { return false; }
      
      // Stop the polling loop.
      stop();
    },
    add: function( handleObj ) {
      // Save a reference to the bound event handler.
      var old_handler = handleObj.handler;
      
      // This function will now be called when the event is triggered,
      // instead of the bound event handler.
      handleObj.handler = function(event) {
        
        // Augment the event object with the location.hash at the time
        // the event was triggered.
        event.fragment = location.hash.replace( /^#/, '' );
        
        // Call the originally-bound event handler, complete with modified
        // event object!
        old_handler.apply( this, arguments );
      };
    }
  };
  
  // Start (or continue) the polling loop.
  function start() {
    // Stop the polling loop if it has already started.
    stop();
    
    // Get the current location.hash. If is has changed since the last loop
    // iteration, store that value and trigger the hashchange event.
    var hash = location.hash;
    if ( hash !== last_hash ) {
      $(window).trigger( 'hashchange' );
      last_hash = hash;
    }
    
    // Poll, setting timeout_id so the polling loop can be canceled.
    timeout_id = setTimeout( start, 100 );
  };
  
  // Stop the polling loop.
  function stop() {
    clearTimeout( timeout_id );
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // Whenever the haschange event is triggered, alert the `fragment`
    // property stored in the event object.
    $(window).bind( 'hashchange', function( event ){
      alert( event.fragment );
    });
    
    // "foo" will be alerted.
    location.hash = '#foo';
    
  });
</pre>


<a name="add-and-remove-clickoutside"></a>
### Custom clickoutside event ###

The following "clickoutside" event is made possible by event delegation. Because events in jQuery bubble up the DOM tree, a catch-all "click" handler bound on document is used to see when and where that event has been triggered. When the "clickoutside" event is bound on one or more elements, those elements are added into an internal collection of elements and a "click" event handler is bound on document.

After that point, whenever an element on the page is clicked, the event will propagate up the DOM tree to document, where the document click event handler will execute. Since that handler can use `event.target` to know on which element the event was triggered, it can then iterate over all elements in the aforementioned internal collection of elements, triggering the custom "clickoutside" event on all elements that aren’t equal to, or a parent of, the triggering element.

Now, whenever an event is triggered on an element, that event's `.target` property refers to the element on which the event was triggered. Normally, since events bubble, a bound event handler might not be on the triggering element, but instead might be on one of its ancestor elements, so this makes sense for most events. Of course, in a situation like this, where the custom "outside" event is triggered directly on the element to which it is bound, `event.target` and this will be the same value inside the event handler.

And because the originating event is, by definition, being triggered on an element that is outside the element on which the custom "outside" event is triggered, it seems most useful to set `event.target` to be the element on which the originating event was triggered, which, if you remember, was available in the document-bound originating event handler.

<!-- http://jsfiddle.net/cowboy/4ASP6/ -->

<pre class="brush:js">
(function($){
  
  // A collection of elements to which the clickoutside event is bound.
  var elems = $([]);
  
  // Special event definition.
  $.event.special.clickoutside = {
    setup: function(){
      // Add this element to the internal collection.
      elems = elems.add( this );
      
      // If this is the first element to which the event has been bound,
      // bind a handler to document to catch all 'click' events.
      if ( elems.length === 1 ) {
        $(document).bind( 'click', handle_event );
      }
    },
    teardown: function(){
      // Remove this element from the internal collection.
      elems = elems.not( this );
      
      // If this is the last element removed, remove the document 'click'
      // event handler that "powers" this special event.
      if ( elems.length === 0 ) {
        $(document).unbind( 'click', handle_event );
      }
    },
    add: function( handleObj ) {
      // Save a reference to the bound event handler.
      var old_handler = handleObj.handler;
      
      // This function will now be called when the event is triggered,
      // instead of the bound event handler.
      handleObj.handler = function( event, elem ) {
        
        // Set the event object's .target property to the element that the
        // user clicked, not the element the event that the 'clickoutside'
        // event was triggered on.
        event.target = elem;
        
        // Call the originally-bound event handler, complete with modified
        // event object!
        old_handler.apply( this, arguments );
      };
    }
  };
  
  // When an element is clicked..
  function handle_event( event ) {
    
    // Iterate over all elements in the internal collection.
    $(elems).each(function(){
      var elem = $(this);
      
      // If this element isn't the clicked element, and this element doesn't
      // contain the clicked element, then the clicked element is considered
      // outside, and the event should be triggered!
      if ( this !== event.target && !elem.has(event.target).length ) {
        
        // Use triggerHandler instead of trigger so that the event doesn't
        // bubble. Pass the 'click' event.target so that the 'clickoutside'
        // event.target can be overridden.
        elem.triggerHandler( 'clickoutside', [ event.target ] );
      }
    });
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // Hide a modal dialog when someone clicks outside of it.
    $("#modal").bind( "clickoutside", function(){
      $(this).hide();
    });
    
  });
</pre>


<a name="add-and-remove-tripleclick"></a>
### Custom tripleclick event: revisited ###

Because the `add` method is called for each bound event handler, it is possible to use the aforementioned `eventData` argument (again, see the [official bind method documentation](http://api.jquery.com/bind/)) on a per-handler basis, instead of on a per-element basis like using only the `setup` method allows.

In this revisited "tripleclick" example, instead of storing data on the element, it's stored on the handler (which is made possible due to the fact that in JavaScript, Functions are Objects and as such can have arbitrary properties and methods attached to them). This allows each handler to have its own threshold, which ultimately makes things far more flexible. Contrast this with the previous [custom tripleclick event](#setup-and-teardown-tripleclick) example, which used only the `setup` and `teardown` methods.

<!-- http://jsfiddle.net/cowboy/5MLdS/ -->

<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.tripleclick = {
    setup: function( data ) {
      // When the event is first bound, bind the "click" event handler that
      // will be used to power the custom "tripleclick" event.
      $(this).bind( 'click', click_handler );
    },
    teardown: function() {
      // When the last event is unbound, unbind the "click" event handler.
      $(this).unbind( 'click', click_handler );
    },
    add: function( handleObj ){
      // The event handler being bound to the event.
      var old_handler = handleObj.handler,
        
        // Click speed threshold passed in as `eventData` when binding.
        threshold = handleObj.data || 500;
      
      // This `new_handler` function calls the `old_handler` function
      // internally. Notice that an extra argument is being passed to the
      // new_handler function, see the `click_handler` function for more
      // information.
      function new_handler( event, timestamp ) {
        // Ignore all handler calls due to bubbling.
        if ( this !== event.target ) { return; }
        
        var elem = $(this);
        
        // If more than `threshold` time has passed since the last click,
        // reset the clicks counter.
        if ( timestamp - new_handler.last > threshold ) {
          new_handler.clicks = 0;
        }
        
        // Update the element's last-clicked timestamp.
        new_handler.last = timestamp;
        
        // Increment the clicks counter. If the counter has reached 3,
        // trigger the "tripleclick" event and reset the clicks counter.
        if ( ++new_handler.clicks === 3 ) {
          old_handler.apply( this, arguments );
          new_handler.clicks = 0;
        }
      };
      
      // When the event is triggered, instead of executing the bound
      // handler directly, `new_handler` will be called, which will then
      // call the original `old_handler` function.
      handleObj.handler = new_handler;
      
      // Since `threshold` is a per-handler datum, and not a per-element
      // datum, store all datum on the handler instead of in element data.
      new_handler.clicks = 0;
      new_handler.last = 0;
    }
  };
  
  // This function is executed every time an element is clicked.
  function click_handler( event ) {
    // Trigger the "tripleclick" event, passing in the click event's 
    //`timeStamp` property as `extraParameters`.
    $(this).trigger( 'tripleclick', [ event.timeStamp ] );
  };
  
})(jQuery);
</pre>

#### Sample Usage ####

<pre class="brush:js">
  $(function(){
    
    // When '#foo' has been triple-clicked within the default threshold of
    // 500 milliseconds, the message will alert.
    $('#foo').bind( 'tripleclick', function(){
      alert( 'I have been triple-clicked!' );
    });
    
    // When '#bar' has been triple-clicked within the specified threshold of
    // 250 milliseconds, the message will alert.
    $('#bar').bind( 'tripleclick', 250, function(){
      alert( 'I have also been triple-clicked!' );
    });
    
    // When '#bar' has been triple-clicked within the default threshold of
    // 500 milliseconds, the message will alert.
    $('#bar').bind( 'tripleclick', function(){
      alert( 'Another triple-click alert!' );
    });
    
  });
</pre>


<a name="add-and-remove-theoretical"></a>
### A theoretical exercise ###

It would actually be trivial to simulate the "first event bound / last event unbound" `setup` and `teardown` functionality using `add` and `remove` like this.. but of course your code won't be backwards-compatible with jQuery 1.3.2 (in case you care) and you won't be able to return `false` to bind or unbind events with native DOM methods, so this should be considered a theoretical exercise only:

<!-- http://jsfiddle.net/cowboy/h9wW4/ -->

<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.myevent = {
    add: function() {
      var elem = $(this),
        data = elem.data( 'myevent' );
      
      if ( !data ) {
        elem.data( 'myevent', data = { bound_count: 0 } );
        // Simulated "setup" code here.
      }
      
      data.bound_count++;
    },
    remove: function() {
      var elem = $(this),
        data = elem.data( 'myevent' );
      
      if ( --data.bound_count === 0 ) {
        elem.removeData( 'myevent' );
        // Simulated "teardown" code here.
      }
    }
  };
  
})(jQuery);
</pre>


<a name="default"></a>
## A default action ##

With the `_default` method, it is now possible to specify a default action for any custom event. Take the following custom "widget_remove" event...

<!-- http://jsfiddle.net/cowboy/gxT8S/ -->

<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.widget_remove = {
    _default: function( event ) {
      // First: do some fancy widget cleanup.
      // ...
      
      // Second: remove the widget.
      $(event.target).remove();
    }
  };
  
})(jQuery);
</pre>



TODO: using namespaces when binding
TODO: special events + event delegation

