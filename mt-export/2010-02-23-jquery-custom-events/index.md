title: "jQuery Custom Events"
categories: [ Code, News ]
tags: [ @hidden, @nonav, @nosearch ]
date: 2010-02-23 10:43:45 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery custom events help you write more scalable and modular code by providing a very powerful API for inter-module communication, which helps simplify code organization. In this article, I'm going to explain some of the key benefits of using custom events, illustrated with a few code examples.



<!--MORE-->


I'm actually going to start by quoting [Rebecca Murphey](http://www.rebeccamurphey.com/) here, because I think she said it best:

> "Custom events let you structure your code such that behaviors are bound to the thing that's being acted on, rather than the thing that triggers the action."

Fortunately, jQuery provides a [complete API][api] for creating custom events, so you can spend more time writing *your* code than writing the underlying framework to support it.

### An example ###

Let's say you have two completely different modules, or widgets, on a page, and an admin control module that can remove either widget (among other things--for the purposes of this example, we'll focus on widget removal). The widgets are so completely different internally that they must be removed from the page in very different ways. While widget A is simple and can just be removed from the DOM, widget B is far more complicated and needs to have extensive cleanup done first.

One approach would be to add all or part of the logic for widget removal into the admin control, so when "Remove widget A" is clicked, the admin control removes that widget from the DOM, while when "Remove widget B" is clicked, the admin control performs the aforementioned cleanup before removing that widget from the DOM:

<pre class="brush:js">
  // admin_control.js
  $('#admin_control').each(function(){
    
    $(this).find('a.widget_a_remove').click(function(event){
      // Remove widget A from the DOM.
      $('#widget_a').remove();
    });
    
    $(this).find('a.widget_b_remove').click(function(event){
      // crazy complicated widget B cleanup code!
      // crazy complicated widget B cleanup code!
      // crazy complicated widget B cleanup code!
      
      // Remove widget B from the DOM.
      $('#widget_b').remove();
    });
    
  });
  
  // second_admin_control.js
  $('#second_admin_control').each(function(){
    
    $(this).find('a.widget_a_remove').click(function(event){
      // Remove widget A from the DOM.
      $('#widget_a').remove();
    });
    
    $(this).find('a.widget_b_remove').click(function(event){
      // crazy complicated widget B cleanup code!
      // crazy complicated widget B cleanup code!
      // crazy complicated widget B cleanup code!
      
      // Remove widget B from the DOM.
      $('#widget_b').remove();
    });
    
  });
</pre>

Ok, so maybe I've exaggerated a little. Perhaps, instead of all those "crazy complicated cleanup code" lines, a simple widget-B-specific method is called in the admin control's "remove widget B" link, leaving all but that one line of code in widget\_b.js, where it belongs.

Still, even this this is less than ideal. Why?

### The problem ###

Well, to anyone who has worked on a larger site or with a team of developers, the flaws in this approach should be immediately apparent:

* The admin control needs to know that widget B's removal process is different than widget A's. If widget B's removal process changes, it not only needs to be updated in widget\_b.js, but also potentially in admin\_control.js, second\_admin\_control.js, and anywhere else that removal process might be initiated.
* Each widget's internals are stored in their own widget\_a.js or widget\_b.js files.. well, except for the code that's in the admin (and maybe other) files. What other files? You probably know, but that other developer across the room or in another country? He doesn't.
* Every time another admin control is created, widget removal initiation logic needs to be duplicated. Either that or decisions need to be made, like, "We're duplicating this code again, should we finally generalize it?" or "Can we somehow tie these admin controls together?"

### The solution ###

The solution is far simpler. All widget-specific code needs to live with the widget, not in any kind of external non-widget control. By binding a custom "destroy" event handler with widget-specific code to each widget, the admin control doesn't need to know any of the specifics to remove a widget. It just triggers the "destroy" event on the widget in question, and that widget takes care of itself.

<pre class="brush:js">
  // widget_a.js
  
  // Bind the custom "destroy" event.
  $('#widget_a').bind( 'destroy', function(event){
    // Remove widget A from the DOM.
    $(this).remove();
  });
  
  // widget_b.js
  
  // Bind the custom "destroy" event.
  $('#widget_b').bind( 'destroy', function(event){
    // crazy complicated widget B cleanup code!
    // crazy complicated widget B cleanup code!
    // crazy complicated widget B cleanup code!
    
    // destroy widget B from the DOM.
    $(this).remove();
  });
  
  // admin_control.js
  $('#admin_control').each(function(){
    
    $(this).find('a.widget_a_remove').click(function(event){
      // Just trigger the custom event.
      $('#widget_a').trigger( 'destroy' );
    });
    
    $(this).find('a.widget_b_remove').click(function(event){
      // Just trigger the custom event.
      $('#widget_b').trigger( 'destroy' );
    });
    
  });
  
  // second_admin_control.js
  $('#second_admin_control').each(function(){
    
    $(this).find('a.widget_a_remove').click(function(event){
      // Just trigger the custom event.
      $('#widget_a').trigger( 'destroy' );
    });
    
    $(this).find('a.widget_b_remove').click(function(event){
      // Just trigger the custom event.
      $('#widget_b').trigger( 'destroy' );
    });
    
  });
</pre>

Imagine that your page can have any number of widgets, each with its own very different internal requirements. What better way for them to be controlled by the admin control than to each listen for predefined custom events, like "redraw" or "destroy"?

Just think about it:

* The admin control doesn't need to know that widget B's removal process is any different than widget A's. It just says "widget, remove yourself" and the widget takes care of the details. There's no guesswork.
* All widget-specific code is stored with the widget, not anywhere else. Where's all widget B's code? In widget\_b.js. End of story.

And in addition to the organizational benefits of keeping your code more modular, you can also:

* Pass extra parameters into [custom event triggers](http://api.jquery.com/trigger/) for extra flexibility.
* Bind custom events to elements using [bind](http://api.jquery.com/bind/), [live](http://api.jquery.com/live/), or [delegate](http://api.jquery.com/delegate/), depending on your needs.
* Specify [custom namespaces](http://api.jquery.com/bind/) to more explicitly control triggering or unbinding.
* Use [event.stopPropagation](http://api.jquery.com/event.stopPropagation/) to control whether or not custom events bubble up the DOM tree.

### What, what's that about bubbling? ###

Oh, you didn't know? Custom events bubble up the DOM tree, just like all those other jQuery events.

Great. So.. how is this useful?

In our widget scenario, imagine that widgets can only be removed if certain criteria are met. For example, a widget might be in the middle of processing, or perhaps form data being edited hasn't been saved yet. Obviously, this is easy to handle: you just code "if criteria is met, remove this widget."

Now, what happens when you need some kind of not-widget-specific error handling? In this example, we want to show a global error message, but maybe error handling needs to be generic because things other than widgets can be removed. Or perhaps every time something can't be removed, a message needs to be logged somewhere. _Just like you don't want to include widget code in the admin controller, you don't want to include global logging code in your widgets._

Because custom events bubble, unless a specific event handler calls `event.stopPropagation()` that event will continue up the DOM tree, triggering bound event handlers on every element that has one. In this example, a "catch-all" event handler is bound to document which handles error messages (but could theoretically do anything, like trigger a "log" event on a system module, for example):

<pre class="brush:js">
  // main.js
  
  // Bind a default "catch-all" handler for the custom "destroy" event.
  $(document).bind( 'destroy', function(event){
    if ( event.error_message ) {
      $('#global_error').text( 'Removal error: ' + event.error_message );
    }
  });
  
  // widget_a.js
  
  // Bind the custom "destroy" event.
  $('#widget_a').bind( 'destroy', function(event){
    if ( something_preventing_removal ) {
      // Widget can't be destroyed, so add a custom property into
      // the event object for other event handlers to utilize.
      event.error_message = 'No can do!';
      
    } else {
      // Remove widget A from the DOM.
      $(this).remove();
      
      // Stop the event from bubbling up the DOM tree.
      event.stopPropagation();
    }
  });
  
  // widget_b.js
  
  // admin_control.js
  $('#admin_control a.widget_a_remove').click(function(event){
    // Trigger the custom event.
    $('#widget_a').trigger( 'destroy' );
  });
</pre>

Of course, your implementation will be far more involved than this simple example, but this should give you an idea of how custom event bubbling might be utilized.

### A working example ###

This [custom events example](http://jsfiddle.net/cowboy/DzrNT/) combines parts from all the examples detailed on this page to create a working widgets + admin control + event bubbling example.

### Recommended reading ###

* Rebecca Murphey: [Demystifying custom events in jQuery](http://blog.rebeccamurphey.com/2009/12/03/demystifying-custom-events-in-jquery/).
* Yehuda Katz: [Evented Programming With jQuery](http://jquery14.com/day-11/evented-programming-with-jquery) (video) and [article](http://yehudakatz.com/2009/04/20/evented-programming-with-jquery/)
* Official documentation: [Events - jQuery API][api]

In a future article, I will be explaining the details of jQuery special events, so be sure to check back!

  [api]: http://api.jquery.com/category/events/

