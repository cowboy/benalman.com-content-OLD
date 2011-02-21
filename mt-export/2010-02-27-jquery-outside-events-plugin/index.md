title: "jQuery outside events: Why trigger an event on something, when you can trigger it on everything else?"
categories: [ Projects, jQuery ]
tags: [ blur, click, dblclick, event, focus, jquery, mousemove, mouseout, mouseover, outside, plugin ]
date: 2010-02-27 15:52:16 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With jQuery outside events you can bind to an event that will be triggered only when a specific "originating" event occurs *outside* the element in question. For example, you can click outside, double-click outside, mouse-over outside, focus outside (and over ten more default "outside" events). Also, if an outside event hasn't been provided by default, you can easily define your own.

Note that this was previously known as the "jQuery clickoutside" plugin.. but, hey--it's pretty amazing what a an [awesome idea](http://blog.petersendidit.com/post/jquery-focusoutside-event/) and few more lines of code can do!

<!--MORE-->

 * Release v1.1
 * Tested with jQuery 1.4.2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome 4-5, Opera 9.6-10.1.
 * Download [Source][src], [Minified][src-min] (0.9kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [click outside][ex-clickoutside], [double-click outside][ex-dblclickoutside], [mouse-over outside][ex-mouseoveroutside], [focus outside][ex-focusoutside]

  [github]: http://github.com/cowboy/jquery-outside-events
  [issues]: http://github.com/cowboy/jquery-outside-events/issues
  [src]: http://github.com/cowboy/jquery-outside-events/raw/v1.1/jquery.ba-outside-events.js
  [src-min]: http://github.com/cowboy/jquery-outside-events/raw/v1.1/jquery.ba-outside-events.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-outside-events/docs/
  
  [ex-clickoutside]: http://benalman.com/code/projects/jquery-outside-events/examples/clickoutside/
  [ex-dblclickoutside]: http://benalman.com/code/projects/jquery-outside-events/examples/dblclickoutside/
  [ex-mouseoveroutside]: http://benalman.com/code/projects/jquery-outside-events/examples/mouseoveroutside/
  [ex-focusoutside]: http://benalman.com/code/projects/jquery-outside-events/examples/focusoutside/
  
  [unit]: http://benalman.com/code/projects/jquery-outside-events/unit/

## Supported "outside" events ##

By default, these "outside" events are supported: `clickoutside`, `dblclickoutside`, `focusoutside`, `bluroutside`, `mousemoveoutside`, `mousedownoutside`, `mouseupoutside`, `mouseoveroutside`, `mouseoutoutside`, `keydownoutside`, `keypressoutside`, `keyupoutside`, `changeoutside`, `selectoutside`, `submitoutside`.

Note that each "outside" event is powered by an "originating" event (see [the complete list](http://benalman.com/code/projects/jquery-outside-events/docs/files/jquery-ba-outside-events-js.html#Defaultoutsideevents)). Only when the originating event is triggered on an element outside the element to which that outside event is bound will the bound event be triggered.

## A basic usage example ##

Let's say you have a modal dialog. In addition to a standard "close dialog" button, you want the user to be able to click anywhere outside the dialog to close it. Instead of creating a background overlay that the user must click on, you can just use this plugin!

<pre class="brush:js">
// Hide the modal dialog when someone clicks outside of it.
$("#modal").bind( "clickoutside", function(event){
  $(this).hide();
});
</pre>

Note that you can also utilize the `event.target` property, which references the actual element clicked, in your event handler logic. This may be useful if you want to constrain the 'outside-ness' of the click to certain elements or containers.

And of course, this same approach works for all "outside" events. See the working examples for more information.

## How it works ##

jQuery outside events are made possible by [event delegation](http://www.nczonline.net/blog/2009/06/30/event-delegation-in-javascript/). Because events in jQuery bubble up the DOM tree, a catch-all event handler bound on document can be used to see when and where a specific event has been triggered.

When an "outside" event is bound on one or more elements, those elements are added into an internal array and an event handler for the corresponding "originating" event is bound on document. For example, when a "clickoutside" event handler is bound on some divs, the plugin binds a "click" event handler to document.

After that point, whenever an element on the page is clicked, the event will propagate up the DOM tree to document, where the document click event handler will execute. Since that handler can use `event.target` to know on which element the event was triggered, it can then iterate over all elements in the aforementioned internal array, triggering the custom "outside" event on all elements that aren't equal to, or a parent of, the triggering element.

Now, whenever an event is triggered on an element, that event's `.target` property refers to the element on which the event was triggered. Normally, since events bubble, a bound event handler might not be on the triggering element, but instead might be on one of its ancestor elements, so this makes sense for most events. Of course, in a situation like this, where the custom "outside" event is triggered directly on the element to which it is bound, `event.target` and `this` will be the same value inside the event handler.

Now, because the originating event is, by definition, being triggered on an element that is *outside* the element on which the custom "outside" event is triggered, it seems most useful to set `event.target` to be the element on which the originating event was triggered, which, if you remember, was available in the document-bound originating event handler.

Fortunately, the special events API in jQuery 1.4.2+ makes this very easy, and it's just a few lines of code (see [here](http://github.com/cowboy/jquery-outside-events/blob/v1.1/jquery.ba-outside-events.js#L193-209) and [here](http://github.com/cowboy/jquery-outside-events/blob/v1.1/jquery.ba-outside-events.js#L228)) to override any `event` object properties for a custom event.

While this explanation might have been a little long-winded, this really is a fairly simple example of a jQuery "special event" plugin, so if you want to write one of your own, feel free to take a look at the [fully commented source code](http://github.com/cowboy/jquery-outside-events/blob/v1.1/jquery.ba-outside-events.js).

## Ok, back to usage ##

Well, there's little else to say. Technical explanation on event bubbling aside, this plugin is really quite straightforward. Be sure to check out the [click outside][ex-clickoutside], [double-click outside][ex-dblclickoutside], [mouse-over outside][ex-mouseoveroutside] and [focus outside][ex-focusoutside] working examples to see it in action, and work from there!

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

_Special thanks to [Jeff Robbins](http://www.lullabot.com/) for the original "clickoutside" plugin idea, and [David Petersen](http://blog.petersendidit.com/post/jquery-focusoutside-event/) for the "focusoutside" idea that got me thinking about converting this into a more general "outside events" plugin!_

