title: "jQuery special events"
categories: [ Code, News ]
tags: [ bbq, clickoutside, custom, detroy, event, hashchange, jquery, outside, plugin, resize, special, tripleclick ]
date: 2010-03-28 21:00:00 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

The jQuery special events API is a fairly flexible system by which you can specify bind and unbind hooks as well as default actions for custom events. In using this API, you can create custom events that do more than just execute bound event handlers when triggered--these "special" events can modify the event object passed to event handlers, trigger other entirely different events, or execute complex setup and teardown code when event handlers are bound to or unbound from elements.



<!--MORE-->


Note that this article uses some advanced jQuery techniques and assumes you understand the concepts of [custom events](http://blog.rebeccamurphey.com/2009/12/03/demystifying-custom-events-in-jquery/) and [event delegation using bubbling](http://www.nczonline.net/blog/2009/06/30/event-delegation-in-javascript/).

Also, because this article is rather long, it has been broken up into sections. I'd recommend reading it in order, one section at a time, because techniques used in subsequent examples often reference those used in previous examples. Also, your brain is going to need a rest here and there, so take it slow.

That being said, I do hope that you stick with it, because there is _a lot_ of useful information here.

 1. [Then and now](#introduction)
 2. [The special event API](#api)  
      2.1. Methods: [setup](#api-setup), [teardown](#api-teardown), [add](#api-add), [remove](#api-remove), [_default](#api-default)  
      2.2. [jQuery version compatibility](#version-compatibility)  
 3. [A jQuery special event pattern, AKA code organization](#pattern)  
      3.1. [Supporting jQuery 1.4, 1.4.1 and 1.4.2+](#jquery-14-plus-add)  
 4. [The setup and teardown methods](#setup-and-teardown)  
      4.1. [Custom click event](#setup-and-teardown-click)  
      4.2. [Custom tripleclick event](#setup-and-teardown-tripleclick)  
      4.3. [Custom tripleclick event: per-element threshold](#setup-and-teardown-tripleclick-per-element)  
      4.4. [Custom resize event: heavy on the polling](#setup-and-teardown-resize-heavy)  
      4.5. [Custom resize event: minimal polling](#setup-and-teardown-resize-minimal)  
 5. [The add and remove methods](#add-and-remove)  
      5.1. [Custom click event: clickDisabled](#add-and-remove-click-disabled)  
      5.2. [Custom hashchange event](#add-and-remove-hashchange)  
      5.3. [Custom clickoutside event](#add-and-remove-clickoutside)  
      5.4. [Custom tripleclick event: per-handler threshold](#add-and-remove-tripleclick-per-handler)  
      5.5. [A theoretical exercise](#add-and-remove-theoretical)  
 6. [The _default method](#default-action)  
      6.1. [Custom destroy event](#default-destroy)  
 7. [Event delegation considerations](#event-delegation)  
      7.1. [Custom clickoutside event: delegation only](#delegation-clickoutside)  
 8. [In summary](#summary)


Special events-related plugins I've created that are referenced in this article:

* jQuery [resize event][plugin-resize], [hashchange event][plugin-hashchange], [outside events][plugin-outside], [clickoutside event][plugin-clickoutside], [BBQ][plugin-bbq].


[plugin-resize]: http://benalman.com/projects/jquery-resize-plugin/
[plugin-hashchange]: http://benalman.com/projects/jquery-hashchange-plugin/
[plugin-bbq]: http://benalman.com/projects/jquery-bbq-plugin/
[plugin-outside]: http://benalman.com/projects/jquery-outside-events-plugin/
[plugin-clickoutside]: http://github.com/cowboy/jquery-outside-events/tree/v1.0

[example-click]: http://jsfiddle.net/cowboy/EhLS6/
[example-tripleclick]: http://jsfiddle.net/cowboy/zCLRa/
[example-tripleclick-per-element]: http://jsfiddle.net/cowboy/BC99w/
[example-resize-heavy]: http://jsfiddle.net/cowboy/QQhKf/
[example-resize-minimal]: http://jsfiddle.net/cowboy/2avx3/
[example-click-disable]: http://jsfiddle.net/cowboy/C2DW3/
[example-hashchange]: http://jsfiddle.net/cowboy/wf4vF/
[example-clickoutside]: http://jsfiddle.net/cowboy/gYBtn/
[example-tripleclick-per-handler]: http://jsfiddle.net/cowboy/6YvK2/
[example-tripleclick-per-handler-old]: http://jsfiddle.net/cowboy/efdQX/
[example-theoretical]: http://jsfiddle.net/cowboy/DwFqk/
[example-destroy]: http://jsfiddle.net/cowboy/q6N9E/
[example-clickoutside-delegate]: http://jsfiddle.net/cowboy/PLzEc/

Updates:

  * 3/29/10 - [Custom tripleclick event](#setup-and-teardown-tripleclick) code and working example updated.
  * 4/02/10 - [Custom tripleclick event: per-handler threshold](#add-and-remove-tripleclick-per-handler) code and working example updated, added the [Supporting jQuery 1.4, 1.4.1 and 1.4.2+](#jquery-14-plus-add) section.


<a name="introduction"></a>
## 1. Then and now ##

Back in the dark ages of jQuery development, if you wanted an arbitrary callback to be executed whenever a certain condition was met, you'd just create a "When Condition Met" plugin, which would be used like `$.whenConditionMet( callback )`. Inside the `$.whenConditionMet` method, magic would happen such that the callback was executed at the appropriate time, and that's that.

Of course, if you wanted to be able to de-register a callback, you'd need to figure out how you wanted to handle that.. maybe `$.whenConditionMet( callback, false )` or perhaps a `$.noLongerCareAboutCondition` method, or maybe even a polite note in the documentation suggesting the end-user "refresh the page."

This was adequate for simple use-cases, but because a well thought-out, flexible API didn't exist, more complicated scenarios could get _really_ messy.

What if, instead of creating a `$.whenConditionMet` method, you could just create a custom "conditionmet" event that callbacks could be bound to? What if those callbacks could be [bound](http://api.jquery.com/bind/), [triggered](http://api.jquery.com/trigger/) or [unbound](http://api.jquery.com/unbind/), with or without [namespaces](http://docs.jquery.com/Namespaced_Events)? What if that custom event [bubbled up the DOM tree](http://api.jquery.com/category/events/event-object/), could have its [propagation stopped](http://api.jquery.com/event.preventDefault/) and could even have a [default action](http://api.jquery.com/event.preventDefault/) as well? What if this custom event, powered by advanced JavaScript magic hitherto undreamed of behaved _exactly_ like every other [jQuery event](http://api.jquery.com/category/events/)?

You've probably got the idea by now, so without further ado, let's get into the details.


<a name="api"></a>
## 2. The special events API ##

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

### 2.1. Methods ###

<a name="api-setup"></a>
#### setup ####

> Do something when the first event handler is bound to a particular element.
> 
> _More explicitly: do something when an event handler is bound to a particular element, but only if there are not currently any event handlers bound. This may occur in two scenarios: 1) either the very first time that event is bound to that element, or 2) the next time that event is bound to that element, after all previous handlers for that event have been unbound from that element._

Method arguments:

* `data` - (Anything) Whatever `eventData` (optional) was passed in when binding the event.
* `namespaces` - (Array) An array of namespaces specified when binding the event.
* `eventHandle` - (Function) The actual function that will be bound to the browser's native event (this is used internally for the beforeunload event, you'll never use it).

Notes:

* Supported in [jQuery 1.3.2 or newer](#version-compatibility).
* Returning `false` tells jQuery to bind the specified event handler using native DOM methods.
* `this` is the element to which the event handler is being bound.
* This method, when executed, will always execute immediately _before_ the corresponding `add` method executes.

<a name="api-teardown"></a>
#### teardown ####

> Do something when the last event handler is unbound from a particular element.

Method arguments:

* `namespaces` - (Array) An array of namespaces specified when unbinding the event.

Notes:

* Supported in [jQuery 1.3.2 or newer](#version-compatibility).
* Returning `false` tells jQuery to unbind the specified event handler using native DOM methods.
* `this` is the element from which the event handler is being unbound.
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
  * `selector` - (String) The selector used by the [delegate](http://api.jquery.com/delegate/) or [live](http://api.jquery.com/live/) jQuery methods. Only available when binding event handlers using these two methods.

Notes:

* Supported in [jQuery 1.4.2 or newer](#version-compatibility).
* `this` is the element to which the event handler is being bound.
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
  * `selector` - (String) The selector used by the [undelegate](http://api.jquery.com/undelegate/) or [die](http://api.jquery.com/die/) jQuery methods. Only available when unbinding event handlers using these two methods.

Notes:

* Supported in [jQuery 1.4.2 or newer](#version-compatibility).
* `this` is the element from which the event handler is being unbound.
* This method, when executed, will always execute immediately _before_ the corresponding `teardown` method executes.

<a name="api-default"></a>
#### _default ####

> The default action for the event. This callback will be triggered unless event.preventDefault() is called.

Method arguments:

* `event` - (Object) The jQuery event object.

Notes:

<!-- * Returning `false` does... well I'm not sure, to be completely honest. It doesn't seem to do anything. -->

* Supported in [jQuery 1.4.2 or newer](#version-compatibility).
* Because `_default` executes after the event has bubbled all the way up the DOM tree, `this` will always reference `document`, which is not particularly useful. You'll probably want to use `event.target` instead.
* Because this method only executes for custom events triggered explicitly with the [trigger](http://api.jquery.com/trigger/) method, it isn't particularly useful for native browser events such as "click" or "submit".


<a name="version-compatibility"></a>
### 2.2. jQuery version compatibility ###

The special events API has been evolving since jQuery 1.2.2, when the `setup` and `teardown` methods were first added. Initially, those methods accepted no arguments, but in jQuery 1.3, the `data` and `namespaces` arguments were added, and in jQuery 1.4, the `eventHandle` argument was added. Also in jQuery 1.4, The `add` and `remove` methods were added, but their [signatures changed](#jquery-14-plus-add) in jQuery 1.4.2 along with the addition of a `_default` method.

As such, due to a few special event-related issues in jQuery 1.4 and 1.4.1, I strongly advise against using those jQuery versions, and recommend using jQuery 1.4.2 (or newer, when available). If you're stuck using jQuery 1.3.2, everything pertaining to the `setup` and `teardown` methods still applies, so be sure to read on!


<a name="pattern"></a>
## 3. A jQuery special event pattern, AKA code organization ##

While additional properties and methods can be added into the `jQuery.event.special.myevent` namespace, this approach should be avoided. By using a closure, the code is easy to read, minifies smaller, allows internal methods and properties (like `some_var` and `init`) to be private, and allows you to use the much more terse (and pretty) `$` instead of `jQuery` without fear of conflict.

Note that I didn't include the `remove` or `_default` methods in this pattern example. You should only include the methods you actually use, so if you just need a `setup` method, just include that method and none of the others. If your event is called "super-awesome", specify it like `$.event.special['super-awesome'] = {...};` etc. Above all else, use your best judgement, and try to write code that is readable and maintainable.

_(All of the code examples in this article as well as all my jQuery special events plugins are based on this pattern, so feel free to examine their code: [resize event][plugin-resize], [hashchange event][plugin-hashchange], [outside events][plugin-outside] and [BBQ][plugin-bbq], with more on the way!)_

#### The code ####
<pre class="brush:js">
(function($){
  
  // A private property.
  var some_var;
  
  // A public property.
  $.myeventOptions = {};
  
  // Special event definition.
  $.event.special.myevent = {
    setup: function( data, namespaces ) {
      // Event code.
      init( this, true );
    },
    teardown: function( namespaces ) {
      // Event code.
      init( this, false );
    },
    add: function( handleObj ) {
      // Event code.
      
      // Save a reference to the bound event handler.
      var old_handler = handleObj.handler;
      
      handleObj.handler = function( event ) {
        // Modify event object here!
        
        // Call the originally-bound event handler and return its result.
        return old_handler.apply( this, arguments );
      };
    }
  };
  
  // A private method.
  function init( elem, state ) {
    // Do something to `elem` based on `state`
  };
  
})(jQuery);
</pre>


<a name="jquery-14-plus-add"></a>
### 3.1. Supporting jQuery 1.4, 1.4.1 and 1.4.2+ ###

If your code doesn't need to work with the jQuery 1.4 or 1.4.1 releases, you can ignore this section, and use the pattern above. If, however, you created a special event plugin "way back" when jQuery 1.4 or 1.4.1 was released, you may have noticed that your code no longer works, due to a [necessary signature change](http://github.com/jquery/jquery/commit/e7912805d6ee290071fb15fbca752e9f47fcd032) in the jQuery 1.4.2 `add` and `remove` methods.

While it's best to to upgrade your older copy of jQuery to the latest version, if you're unable to do that, use this `add` method (instead of the simpler, 1.4.2+ compatible, `add` method in the pattern above), and everything will work again.

_(Note that I haven't documented the additional 1.4 / 1.4.1 `add` method parameters here, but if you were using them, you should be able to figure how they map to properties of the `handleObj` argument. See the [add method documentation](#api-add) if necessary)_

#### The code ####
<pre class="brush:js">
(function($){
  
  // Special event definition.
  $.event.special.myevent = {
    add: function( handleObj ) {
      // Event code.
      
      // This will reference the bound event handler.
      var old_handler;
      
      function new_handler(event) {
        // Modify event object here!
        
        // Call the originally-bound event handler and return its result.
        return old_handler.apply( this, arguments );
      };
      
      // This may seem a little complicated, but it normalizes the `add`
      // method between jQuery 1.4, 1.4.1 and 1.4.2+
      if ( $.isFunction( handleObj ) ) {
        // This is how 1.4 & 1.4.1 did it.
        old_handler = handleObj;
        return new_handler;
      } else {
        // This works in 1.4.2 or newer.
        old_handler = handleObj.handler;
        handleObj.handler = new_handler;
      }
    }
  };

})(jQuery);
</pre>


<a name="setup-and-teardown"></a>
## 4. The setup and teardown methods ##

When binding an event handler for a "special" event, if no event handlers are currently bound to the element in question, the `setup` method is called. This effectively allows you to setup or initialize complex code for that event on a per-element basis to "enable" it to work. The `teardown` method works in exactly the same way, except that it's called when the last event handler is being unbound from an element.

In addition, if either the `setup` or `teardown` methods return `false`, jQuery will bind (or unbind) the event handler using native DOM methods. This is useful when you want to augment an existing event with additional functionality, which brings us to our first example:


<a name="setup-and-teardown-click"></a>
### 4.1. Custom click event ###

In David Walsh's [Adding Events to Adding Events in MooTools](http://davidwalsh.name/mootools-add-event) article, he expressed his frustration that while many site designers bind click event handlers to non-anchor elements, they don't update those elements' CSS styles to change the mouse cursor to "pointer", signifying that the element is clickable. It might be a minor detail, but as they say, "the devil is in the details."

The traditional way to do this would be to set an inline style on the element every time a click event handler is bound, like `$('div').css( 'cursor', 'pointer' ).click( fn )` (or add a predefined "clickable" class), but that's potentially a lot of extra code in your application. Another approach might be to to create a `$.fn.bindCustomClick` method that is effectively a wrapper for just that, which results in less code.. but just ends up being an unnecessary abstraction.

Fortunately, the special events API can be used to make this automatic. As in David's [jQuery solution](http://davidwalsh.name/add-events-jquery), in this example a special "click" event is set up such that whenever the first click event handler is bound to an element, an inline style is automatically set on that element, with the reverse happening when the last event handler is unbound.. and because the `setup` and `teardown` methods return `false`, jQuery binds the click event handler normally, using the native DOM methods.

Take a look at the code below, and then view the [working example][example-click].

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
### 4.2. Custom tripleclick event ###

Unlike the native browser "click" and "dblclick" events, there is no native "tripleclick" event (or "trplclick" event), but that didn't stop Brandon Aaron from explaining [one approach for creating a tripleclick event](http://brandonaaron.net/blog/2009/03/26/special-events) using the special events API. At its core, the tripleclick event is powered by the click event. Click three times within a certain time threshold, and the tripleclick event fires.

In the following example, because the tripleclick event doesn't exist natively, there's no need for jQuery to bind to it using the native DOM methods, so it makes no sense to return `false`. And unlike the previous example, which "piggybacks" additional code onto an existing event, this special event creates an entirely new "custom" event that is powered by another, existing event.

Also, this custom event is made possible by event delegation. Because events in jQuery bubble up the DOM tree, a catch-all "click" handler bound on document is used to see on which element that event was triggered. When the "tripleclick" event is bound on one or more elements, those elements are added into an internal collection of elements and a "click" event handler is bound on document.

After that point, whenever an element on the page is clicked, the event will propagate up the DOM tree to document, where the document click event handler will execute. Since that handler can use `event.target` to know on which element the event was triggered, it can then trigger the "tripleclick" event on that element if the proper conditions have been met.

Note that the tripleclick threshold setting, `$.tripleclickThreshold`, is a "global" setting, applying to all tripleclick event handlers, and can be changed at any time. In addition, the tripleclick event is only actually triggered on `event.target` (the actual element that was triple-clicked), but because it bubbles up the DOM tree, it can have its propagation stopped, just like a native event.

_(Because Internet Explorer is super-extra-awesome, you will need to click five times for the tripleclick event to fire, due to the way it triggers the click event when selecting text. Internally binding to both the `selectstart` and `click` events will work around this issue, but this approach is not included in the examples for simplicity's sake)_

Take a look at the code below, and then view the [working example][example-tripleclick].

#### The code ####
<pre class="brush:js">
(function($){
  
  // A collection of elements to which the tripleclick event is bound.
  var elems = $([]),
    
    // Initialize the clicks counter and last-clicked timestamp.
    clicks = 0,
    last = 0;
  
  // Click speed threshold, defaults to 500.
  $.tripleclickThreshold = 500;
  
  // Special event definition.
  $.event.special.tripleclick = {
    setup: function(){
      // Add this element to the internal collection.
      elems = elems.add( this );
      
      // If this is the first element to which the event has been bound,
      // bind a handler to document to catch all 'click' events.
      if ( elems.length === 1 ) {
        $(document).bind( 'click', click_handler );
      }
    },
    teardown: function(){
      // Remove this element from the internal collection.
      elems = elems.not( this );
      
      // If this is the last element removed, remove the document 'click'
      // event handler that "powers" this special event.
      if ( elems.length === 0 ) {
        $(document).unbind( 'click', click_handler );
      }
    }
  };
  
  // This function is executed every time an element is clicked.
  function click_handler( event ) {
    var elem = $(event.target);
    
    // If more than `threshold` time has passed since the last click, reset
    // the clicks counter.
    if ( event.timeStamp - last > $.tripleclickThreshold ) {
      clicks = 0;
    }
    
    // Update the last-clicked timestamp.
    last = event.timeStamp;
    
    // Increment the clicks counter. If the counter has reached 3, trigger
    // the "tripleclick" event and reset the clicks counter to 0. Trigger
    // bound handlers using triggerHandler so the event doesn't propagate.
    if ( ++clicks === 3 ) {
      elem.trigger( 'tripleclick' );
      clicks = 0;
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
  
  // When '#bar' has been triple-clicked within the default threshold of
  // 500 milliseconds, the message will alert.
  $('#bar').bind( 'tripleclick', function(){
    alert( 'I have also been triple-clicked!' );
  });
  
  // Change the tripleclick threshold to 1000 milliseconds, affecting any
  // already-bound event handlers as well as all future event handlers.
  $.tripleclickThreshold = 1000;
  
});
</pre>


<a name="setup-and-teardown-tripleclick-per-element"></a>
### 4.3. Custom tripleclick event: per-element threshold ###

This example is similar to the [previous example](#setup-and-teardown-tripleclick), with one major difference. Instead of being limited to just "global" threshold (the `$.tripleclickThreshold` property), the threshold can now be overridden on a per-element basis.

One very important thing to note about this approach is that because the tripleclick event is being triggered explicitly on each element (instead of being triggered only on `event.target`, like in the [previous example](#setup-and-teardown-tripleclick)), the event doesn't actually propagate and as such cannot have its propagation stopped. This is an unfortunate side-effect of utilizing this per-element event-data approach.

A few things to note about the `setup` method's first argument, which may be specified as `eventData` when an event handler is bound (see the [official bind method documentation](http://api.jquery.com/bind/)):

* `eventData` can be any data type, except Function. While an Object is usually passed, it can also be a String, Number or Boolean.
* Because the `setup` method only fires the first time an special event handler is bound to the element in question, using the approach outlined in this example will cause only the first bind's `eventData` to be used (but see the [custom tripleclick event: per-handler threshold](#add-and-remove-tripleclick-per-handler) example later in this article for a way around this limitation).

Take a look at the code below, and then view the [working example][example-tripleclick-per-element].

#### The code ####
<pre class="brush:js">
(function($){
  
  // Click speed threshold, defaults to 500.
  $.tripleclickThreshold = 500;
  
  // Special event definition.
  $.event.special.tripleclick = {
    setup: function( data ) {
      // When the event is first bound, initialize the element plugin data
      // (including clicks counter, last-clicked timestamp, and a threshold
      // value if specified), and bind the "click" event handler that will
      // be used to power the custom "tripleclick" event.
      $(this)
        .data( 'tripleclick', { clicks: 0, last: 0, threshold: data })
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
      data = elem.data( 'tripleclick' ),
      
      // Use the specified threshold, otherwise use the global value.
      threshold = data.threshold || $.tripleclickThreshold;
    
    // If more than `threshold` time has passed since the last click, reset
    // the clicks counter.
    if ( event.timeStamp - data.last > threshold ) {
      data.clicks = 0;
    }
    
    // Update the element's last-clicked timestamp.
    data.last = event.timeStamp;
    
    // Increment the clicks counter. If the counter has reached 3, trigger
    // the "tripleclick" event and reset the clicks counter to 0. Trigger
    // bound handlers using triggerHandler so the event doesn't propagate.
    if ( ++data.clicks === 3 ) {
      elem.triggerHandler( 'tripleclick' );
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
### 4.4. Custom resize event: heavy on the polling ###

Long ago, the powers-that-be decided that the "resize" event would only fire on the browser's `window` object, so it's unfortunately not available on all those other elements whose dimensions might change. Of course, it _could_ be, if the special events API were involved, so I recently created a [jQuery resize event][plugin-resize] plugin to provide that functionality.

Because there is no event that gets fired when an element resizes, the custom resize event can't be "powered" by another event as in the "tripleclick" event. Instead, for each element to which the custom resize event is bound, a periodic measurement of that element's dimensions must be taken, triggering the event on that element if either its width or its height has changed since the last measurement.

So, in this example, for each element to which a resize event handler is bound, a polling loop is started which periodically checks for dimension changes and triggers the event when appropriate. And thanks to the `setup` and `teardown` methods, the polling loop can be started only once the event is actually bound to an element, and can be stopped when all resize events are unbound from that element.

_(See the next special event example, [custom resize event: minimal polling](#setup-and-teardown-resize-minimal) for code that looks more like the actual [jQuery resize event][plugin-resize] plugin)_

Take a look at the code below, and then view the [working example][example-resize-heavy].

#### The code ####
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
    // data store and trigger the "resize" event. Since the event shouldn't
    // propagate, use triggerHandler.
    if ( width !== data.w || height !== data.h ) {
      data.w = width;
      data.h = height;
      elem.triggerHandler( 'resize' );
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
### 4.5. Custom resize event: minimal polling ###

While this custom "resize" event example provides the same functionality as the previous example, it has been structured differently to improve performance. Whereas the previous example used one polling loop per element, this example uses a single polling loop for _all_ elements. In general, polling loops should be avoided wherever possible, and while it's not possible to avoid polling in the case of a custom resize event, there is no reason to create a separate polling loop for each element.

In addition to using the `setup` and `teardown` methods to initialize a specific element when an event handler is bound or unbound from that element, these methods can also be utilized to perform a much more "global" task, like updating a shared-across-all-elements private property inside the special event's closure. In this example, the `elems` variable contains a collection of all elements to which the event is bound, that is iterated over each time the polling loop function executes. And because this collection of elements has a length, the polling loop can be started only when it's needed, and stopped otherwise.

_(Note that while the overall structure of this special event example is the same as the finished plugin, some additional logic had to be written to prevent double-firing of event handlers when the event was manually triggered. See my [jQuery resize event][plugin-resize] plugin for the complete, finished source)_

Take a look at the code below, and then view the [working example][example-resize-minimal].

#### The code ####
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
        data.w = width;
        data.h = height;
        elem.triggerHandler( 'resize' );
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
## 5. The add and remove methods ##

The `add` and `remove` methods, added in jQuery 1.4 (and revamped in 1.4.2), work much like their `setup` and `teardown` counterparts, except they are called _every_ time an event handler is bound or unbound from an element (unlike `setup`, which is called only the first time an event handler is bound, and `teardown`, which is called only the last time an event handler is unbound).

The single `handleObj` argument passed into these methods contains a number of [useful properties](#api-add), most useful of which is the `handler` method. This is the event handler being bound to the event, which is what gets called every time the event is triggered.

Since `handleObj.handler` is available at the time the event handler is being bound, it's possible to override the handler property to do something else every time the event is triggered, like augment the [event object](http://api.jquery.com/category/events/event-object/) with a custom property or even override an existing event object property.


<a name="add-and-remove-click-disabled"></a>
### 5.1. Custom click event: clickDisabled ###

In Matt Snider's recent [Switching Events On & Off Globally](http://mattsnider.com/javascript/switching-events-on-off-globally/) article, he suggested a scenario in which, at a certain point during the processing of a page, all bound click events needed to be temporarily disabled. This scenario is not uncommon, and this technique can be especially useful when performing asynchronous tasks, like submitting forms or fetching data via AJAX, where you don't want the user to accidentally double-submit by clicking links or buttons before the task has completed.

While the traditional approach would be to either put an "if" statement inside every click handler or to wrap all click event binding code in another function that does just that, but automatically, those approaches are somewhat ugly and prone to mistakes. For example, what if a developer doesn't use one of these methods, because they don't understand why it's there, or what happens if you need to temporarily disable a click event that you have no control over?

In this example, you'll see that using the jQuery special events API makes this not only possible, but trivially easy. Using the `add` method to override the originally bound event handler with a new method, we can add in a little bit of extra logic that works for _every_ click event in a completely unobtrusive way.

Take a look at the code below, and then view the [working example][example-click-disable].

#### The code ####
<pre class="brush:js">
(function($){
  
  // A public property that can be changed at any time.
  $.clickDisabled = null;
  
  // Special event definition.
  $.event.special.click = {
    add: function( handleObj ) {
      // Save a reference to the bound event handler.
      var old_handler = handleObj.handler,
        
        // The current element.
        elem = $(this);
      
      handleObj.handler = function( event ) {
        if ( $.clickDisabled && elem.is( $.clickDisabled ) ) {
          // If $.clickDisabled is specified and the element to which the
          // callback is bound matches the specified selector, prevent the
          // default action without stopping propagation, and don't call
          // the originally bound event handler.
          event.preventDefault();
        } else {
          // Otherwise call the originally-bound event handler and return
          // its value.
          return old_handler.apply( this, arguments );
        }
      };
    }
  };

})(jQuery);
</pre>

#### Sample Usage ####
<pre class="brush:js">
$(function(){
  
  // All nav linkss have a click event handler bound.
  $('#nav a').bind( 'click', function(){
    alert( 'I have been clicked!' );
  });
  
  // At some point in the future, disable only those links.
  $.clickDisabled = '#nav a';
  
});
</pre>


<a name="add-and-remove-hashchange"></a>
### 5.2. Custom hashchange event ###

Right now, in Internet Explorer 8, Firefox 3.6, and Chrome 5, you can bind event handlers to the native [window.onhashchange](https://developer.mozilla.org/en/DOM/window.onhashchange) event to execute code whenever the location.hash changes, and because the event is supported natively, you don't need a plugin. Of course, what happens when you want your code to work in a browser that doesn't support the hashchange event?

This simplified "hashchange" special event is a good segue between the preceding "setup and teardown" section and the current "add and remove" section because it not only uses the `setup` and `teardown` methods to start and stop a polling loop (only in browsers that don't natively support the hashchange event, of course), but it also illustrates how the event object can be augmented with a custom property in the `add` method.

_(Note that while the overall structure of this special event example is the same as the finished plugin, a fair amount of additional code must be written to make it work correctly cross-browser, which includes some special logic for IE to properly detect native support for the event as well as to enable "back button" support, which is not discussed in this article. In addition, I have split the special event functionality such that while my [jQuery hashchange event][plugin-hashchange] plugin actually creates the event, my [jQuery BBQ][plugin-bbq] plugin augments that event with an additional property and method, among other things)_

Take a look at the code below, and then view the [working example][example-hashchange].

#### The code ####
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
      
      // Stop the polling loop. Since this event is only evern bound to
      // the `window` object, multiple-element tracking is unnecessary.
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
        // event object! The result from this call doesn't need to be
        // returned, because there is no default action to prevent, and 
        // nothing to propagate to.
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
  
  // Whenever the hashchange event is triggered, alert the `fragment`
  // property stored in the event object.
  $(window).bind( 'hashchange', function( event ){
    alert( event.fragment );
  });
  
  // "foo" will be alerted.
  location.hash = '#foo';
  
});
</pre>


<a name="add-and-remove-clickoutside"></a>
### 5.3. Custom clickoutside event ###

Just like in the [initial tripleclick event example](#setup-and-teardown-tripleclick), the following "clickoutside" event is made possible by event delegation. The difference here is that the `document`-bound click handler iterates over all elements in the aforementioned internal collection of elements, triggering the custom "clickoutside" event on all elements that aren't the same as, or a parent of, the triggering element.

Whenever an event is triggered on an element, the `event.target` property refers to the element on which the event was triggered, which is useful for when the event bubbles up the DOM tree. In this special event's `document`-bound click handler, `event.target` is necessary to know on which element the event was triggered.

Now, since the custom "clickoutside" event is triggered directly on the element to which the event handler is bound, `event.target` and `this` will be the same. Because the originating event is, by definition, being triggered on an element that is outside the element on which the custom "outside" event is triggered, it seems most useful to set `event.target` to be the element on which the originating event was triggered, which is easy to do in the `add` method.

_(While I had originally released a [clickoutside event][plugin-clickoutside] plugin, it became obvious shortly thereafter that it would be a good idea, and fairly trivial at that, to create a single [outside events][plugin-outside] plugin that created not one, but fifteen outside events based on their native counterparts, along with a method that could be used to create an "outside" event from ANY native or custom event)_

Take a look at the code below, and then view the [working example][example-clickoutside].

#### The code ####
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
        // user clicked, not the element on which the 'clickoutside' event
        // was triggered.
        event.target = elem;
        
        // Call the originally-bound event handler, complete with modified
        // event object! The result from this call doesn't need to be
        // returned, because there is no default action to prevent, and 
        // nothing to propagate to.
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


<a name="add-and-remove-tripleclick-per-handler"></a>
### 5.4. Custom tripleclick event: per-handler threshold ###

If you recall, the [per-element data "tripleclick" event example](#setup-and-teardown-tripleclick-per-element) was somewhat handicapped because the `setup` method only executes the first time an event handler is bound to a specific element. Because of this, only the `eventData` value specified in that first `bind` call is utilized, so if you wanted to bind multiple handlers to the same element, each with its own click threshold, you were out of luck.

Well, because the `add` method is called for each bound event handler, it is possible to use the aforementioned `eventData` argument (again, see the [official bind method documentation](http://api.jquery.com/bind/)) on a per-handler basis, instead of on a per-element basis like using only the `setup` method allows.

In this "tripleclick" example, instead of storing data on the element, it actually just persists in the `add` method's closure. Since each handler now has its own threshold, clicks counter and last-clicked timestamp, this ultimately makes the event far more flexible.

Of course, just like the [per-element data "tripleclick" event example](#setup-and-teardown-tripleclick-per-element), because the tripleclick event is being triggered explicitly on each element (instead of being triggered only on `event.target`, the originating element), the event doesn't actually propagate and as such cannot have its propagation stopped. Since bubbling up the DOM tree is an expected behavior for events, you may ultimately decide to keep it simple as in the [original tripleclick event example](#setup-and-teardown-tripleclick), but that decision is up to you.

Take a look at the code below, and then view the [working example][example-tripleclick-per-handler].

#### The code ####
<pre class="brush:js">
(function($){
  
  // Click speed threshold, defaults to 500.
  $.tripleclickThreshold = 500;
  
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
        
        // Initialize this handler's clicks counter and last-clicked
        // timestamp.
        clicks = 0,
        last = 0;
      
      // When the event is triggered, instead of executing the bound
      // handler directly, `handleObj.handler` will be called, which will
      // then call the original `old_handler` function. Notice that an extra
      // argument is being passed to the new_handler function, see the
      // `click_handler` function for more information.
      handleObj.handler = function( event, timestamp ) {
        // Ignore all handler calls due to bubbling.
        if ( this !== event.target ) { return; }
        
        var elem = $(this),
          
          // Use the specified threshold, otherwise use the global value.
          threshold = handleObj.data || $.tripleclickThreshold;
        
        // If more than `threshold` time has passed since the last click,
        // reset the clicks counter.
        if ( timestamp - last > threshold ) {
          clicks = 0;
        }
        
        // Update this handler's last-clicked timestamp.
        last = timestamp;
        
        // Increment the clicks counter. If the counter has reached 3,
        // trigger the "tripleclick" event and reset the clicks counter.
        if ( ++clicks === 3 ) {
          old_handler.apply( this, arguments );
          clicks = 0;
        }
      };
    }
  };
  
  // This function is executed every time an element is clicked.
  function click_handler( event ) {
    // Trigger the "tripleclick" event, passing in the click event's
    // `timeStamp` property as `extraParameters`.
    $(this).triggerHandler( 'tripleclick', [ event.timeStamp ] );
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
### 5.5. A theoretical exercise ###

This is "extra credit," but it would actually be trivial to simulate the "first event bound / last event unbound" `setup` and `teardown` functionality using `add` and `remove` like this.. but of course your code won't be backwards-compatible with jQuery 1.3.2 (in case you care) and you won't be able to return `false` to bind or unbind events with native DOM methods, so this should be considered a theoretical exercise only.

Take a look at the code below, and then view the [working example][example-theoretical].

#### The code ####
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


<a name="default-action"></a>
## 6. The _default method ##

<!-- RESIG HELP PLZ!! http://jsfiddle.net/cowboy/puJSf/ -->

By specifying a `_default` method, it is possible to create a default action for any custom event. This default action, much like native events' default actions, executes after the event has bubbled up the DOM tree and all bound event handlers have been triggered. Just like native events' default actions, a custom event's default action can be bypassed by calling the [event.preventDefault](http://api.jquery.com/event.preventDefault/) method.

Providing a default action for events offers another way in which a framework or plugin developers can abstract complex internals away from the end-user, allowing for simpler, more maintainable code. for example, imagine that you're creating a widget framework, and while every widget has a "close" button, an arbitrary parent element might need "veto" power over a widget's ability to close itself (because of some arbitrary logic like dirty form checking, or state saving).

<a name="default-destroy"></a>
### 6.1. Custom destroy event ###

In this example, when the custom 'destroy' event is triggered, the element on which it was triggered will be removed from the DOM unless the event's default action is prevented. Now, while the framework provides the default action, which is responsible for handling all the internal framework-level nuances of removing a widget, the implementation-specific code is responsible for deciding when the default behavior should be prevented, if at all.

Take a look at the code below, and then view the [working example][example-destroy].

#### The framework code ####
<pre class="brush:js">
(function($){
  
  // When the 'destroy' event is triggered on an element, that element will
  // be removed from the DOM, unless prevented with event.preventDefault().
  $.event.special.destroy = {
    _default: function(event){
      $(event.target).remove();
    }
  };
  
})(jQuery);
</pre>

#### The implementation-specific code ####
<pre class="brush:js">
$(function(){
  
  // Handle the 'destroy' event for each widget.
  $('.widget').bind( 'destroy', function(event){
    
    // Only allow the widget to be destroyed if it isn't preceded by any
    // other widgets.
    if ( $(this).prevAll('.widget').length ) {
      
      // Note that the 'heavy lifting' of removing the element is done
      // in the framework, thus abstracting away the internals from the
      // user. All they need to do is prevent it, or not.
      event.preventDefault();
      
      // An implementation-specific error message.
      alert( 'Widgets must be closed in order!' );
    }
  });
  
  // When an 'X' close link is clicked, trigger the 'destroy' event for
  // that widget.
  $('.widget .close').bind( 'click', function(event){
    $(this).closest('.widget').trigger('destroy');
  });
  
});
</pre>


<a name="event-delegation"></a>
## 7. Event delegation considerations ##

When a bound event handler executes, `this` inside that handler always refers to the element on which the event was bound. Now, when you bind a event handler to an element using [bind](http://api.jquery.com/bind/), it's simply bound to that element, and `this` is precisely what you'd expect. When you bind an event handler using [live](http://api.jquery.com/live/) or [delegate](http://api.jquery.com/delegate/) however, things work a bit differently.

You shouldn't be surprised to know that in a `live`-bound event handler, `this` refers to `document`, and in a `delegate`-bound event handler, for each of the selected elements in the jQuery object on which the `delegate` method was called, `this` refers to that element.

_(If you were surprised, please view the jQuery API documentation for [live](http://api.jquery.com/live/) and [delegate](http://api.jquery.com/delegate/) and then read Brandon Aaron's [Event Delegation with jQuery](http://brandonaaron.net/blog/2010/03/4/event-delegation-with-jquery) article before continuing)_

Because the `setup`, `teardown`, `add` and `remove` methods are also executed in the context to which the event handler is bound, things have to be structured quite differently for these methods to work correctly with `bind`-bound event handlers versus `live`- and `delegate`-bound event handlers. While `this` could be taken for granted before, it no longer can.

For example, since both `$('#foo').live( 'click', fn )` and `$('#bar').live( 'click', fn )` actually bind their event handlers to `document` to be handled via delegation, and since the `setup` method only executes when the first event handler is bound to a particular element, `setup` will only be executed for that first `live` call but _not_ the second. Not only that, but inside the `setup` method, `this` will reference `document` and not #foo.


<a name="delegation-clickoutside"></a>
### 7.1. Custom clickoutside event: delegation only ###

This custom "clickoutside" event example has been designed to enable event handlers bound with the `live` and `delegate` methods, but unlike the previous [custom clickoutside event](#add-and-remove-clickoutside), will _not_ enable event handlers bound with the `bind` method (partially because I want to illustrate how the two approaches differ, but also because combining the two is too painful for me to contemplate at the moment).

A few things to note about this approach:

* Because jQuery's `live` and `delegate` methods are based on selecting elements via a context + selector string at the time the event is triggered, a potentially _very_ expensive element selection operation happens every time the event is triggered. This can only scale so far, and if performance is more important than convenience, allowing for event delegation might be impractical.
* Because `this` references the context on which the event is bound, `event.target` references the element on which the event is triggered and shouldn't be modified, as in the previous [custom clickoutside event](#add-and-remove-clickoutside) example. Because of this, a custom `event.clicked` property is created to refer to the clicked element.

Take a look at the code below, and then view the [working example][example-clickoutside-delegate].

<pre class="brush:js">
(function($){
  
  // A collection of contexts to which the clickoutside event is bound.
  var contexts = $([]),
    
    // An array of context + handleObj items. When the click event is
    // triggered, these are iterated over to determine on which elements
    // the clickoutside event will be triggered.
    handleObjs = [];
  
  // Special event definition.
  $.event.special.clickoutside = {
    setup: function(){
      // Add this context to the internal collection.
      contexts = contexts.add( this );
      
      // If this is the first context to which the event has been bound,
      // bind a handler to document to catch all 'click' events.
      if ( contexts.length === 1 ) {
        $(document).bind( 'click', handle_event );
      }
    },
    teardown: function(){
      // Remove this context from the internal collection.
      contexts = contexts.not( this );
      
      // If this is the last context removed, remove the document 'click'
      // event handler that "powers" this special event.
      if ( contexts.length === 0 ) {
        $(document).unbind( 'click', handle_event );
      }
    },
    add: function( handleObj ) {
      // Add this context + handleObj pair onto the array.
      handleObjs.push({ context: this, handleObj: handleObj });
      
      // This function will now be called when the event is triggered,
      // instead of the bound event handler.
      handleObj.handler = function( event, elem ) {
        
        // Set the event object's .clicked property to the element that the
        // user clicked, not the element on which the 'clickoutside' event
        // was triggered.
        event.clicked = elem;
        
        // The 'clickoutside' event shouldn't propagate up the DOM tree.
        //event.stopPropagation();
        
        // For a delegated special event that shouldn't propagate, we need
        // to call handleObj.origHandler manually, instead of calling the
        // original handleObj.handler method.
        handleObj.origHandler.apply( this, arguments );
      };
    },
    remove: function( handleObj ) {
      // Remove this context + handleObj from the array.
      var context = this;
      handleObjs = $.grep( handleObjs, function(v) {
        return v.context !== context || v.handleObj !== handleObj;
      });
    }
  };
  
  // When an element is clicked..
  function handle_event( event ) {
    var elems = $([]);
    
    // Create a sorted, uniqued collection of elements selected by all
    // context + handleObj pairs. Since element selection happens every time
    // the click event is triggered, this can be extremely expensive and
    // inefficient, which is probably the biggest negative side-effect of
    // supporting live or delegate in a special event.
    $.each( handleObjs, function(i,item){
      elems = elems.add( $( item.handleObj.selector, item.context ) );
    });
    
    // Iterate over all selected elements.
    elems.each(function(){
      var elem = $(this);
      
      // If this element isn't the clicked element, and this element doesn't
      // contain the clicked element, then the clicked element is considered
      // outside, and the event should be triggered!
      if ( this !== event.target && !elem.has(event.target).length ) {
        
        // We don't want the 'clickoutside' event to propagate, but the only
        // way it can work with delegation is for it to propagate. In this
        // case, triggerHandler won't work, but trigger used in conjunction
        // with calling handleObj.origHandler in the `add` method will. Pass
        // the 'click' event.target so that the 'clickoutside' event.clicked
        // can be set.
        elem.trigger( 'clickoutside', [ event.target ] );
      }
    });
  };
  
})(jQuery);
</pre>

#### Sample Usage ####
<pre class="brush:js">
$(function(){
  
  // Hide a modal dialog when someone clicks outside of it.
  $("#modal").live( "clickoutside", function(){
    $(this).hide();
  });
  
});
</pre>

<a name="summary"></a>
## 8. In summary ##

As you can see, the jQuery special events API is very powerful. In the simplest use-cases, it allows you to modify existing events, but in more complicated use-cases, it allows you to create entirely new custom events or normalize newer not-yet-fully-supported events. Not only that, but because of the flexibility of the API, there are many possible approaches that can be undertaken to accomplish the same task. I encourage you not just to experiment with these code samples, but to create your own, and also to spend some time "under the hood," looking at the [jQuery source](http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js) which, believe it or not, will answer many of your questions (if you're patient enough).

I've been working on this article for over a month now (since before John Resig mentioned it in his [jQuery 1.4.2 release blog post](http://blog.jquery.com/2010/02/19/jquery-142-released/) and in the process have uncovered a [few](http://dev.jquery.com/ticket/6182) [jQuery](http://dev.jquery.com/ticket/6202) [bugs](http://dev.jquery.com/ticket/6208) that will be fixed in the upcoming 1.4.3 release. Should anything change with the jQuery special events API, I will update this article and send out information via my [@cowboy twitter account](http://twitter.com/cowboy/) as well as this site's RSS, so please subscribe or follow me if you haven't already!

As always, if you have any feedback or suggestions, please let me know in the comments, and if you find this article helpful, please express your appreciation for my hard work [with a donation](http://benalman.com/donate).

