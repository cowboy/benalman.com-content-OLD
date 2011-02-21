title: "jQuery hashchange event"
categories: [ Projects, jQuery ]
tags: [ bbq, event, fragment, hash, hashchange, jquery, plugin ]
date: 2010-07-22 09:00:00 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This jQuery plugin enables very basic bookmarkable #hash history via a cross-browser HTML5 window.onhashchange event.

While this functionality was initially tied to the [jQuery BBQ][bbq] plugin, the event.special window.onhashchange functionality has now been broken out into a separate plugin for users who want just the basic event & back button support, without all the extra awesomeness that BBQ provides.

  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/

<!--MORE-->

 * Release v1.3
 * Tested with jQuery 1.2.6, 1.3.2, 1.4.1, 1.4.2 in Internet Explorer 6-8, Firefox 2-4, Chrome 5-6, Safari 3.2-5, Opera 9.6-10.60, iPhone 3.1, Android 1.6-2.2, BlackBerry 4.6-5.
 * Download [Source][src], [Minified][src-min] (0.8kb gzipped)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]
 * Examples: [hashchange][ex-h], [document.domain][ex-dd]

  [github]: http://github.com/cowboy/jquery-hashchange/tree/v1.3
  [issues]: http://github.com/cowboy/jquery-hashchange/issues
  [src]: http://github.com/cowboy/jquery-hashchange/raw/v1.3/jquery.ba-hashchange.js
  [src-min]: http://github.com/cowboy/jquery-hashchange/raw/v1.3/jquery.ba-hashchange.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-hashchange/docs/
  
  [ex-h]: http://benalman.com/code/projects/jquery-hashchange/examples/hashchange/
  [ex-dd]: http://benalman.com/code/projects/jquery-hashchange/examples/document_domain/
  
  [unit]: http://benalman.com/code/projects/jquery-hashchange/unit/

  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/

## Why is a plugin needed for the hashchange event? ##

Right now, in Internet Explorer 8, Firefox 3.6+, and Chrome 5+, you can bind callbacks to the [window.onhashchange](https://developer.mozilla.org/en/DOM/window.onhashchange) event and use it without any kind of plugin. Of course, what happens when you want your code to work in a browser that _doesn't_ support window.onhashchange?

Well, nothing happens.. because the event doesn't exist, so it never fires. But because jQuery provides a layer of abstraction between actual events and bound callbacks, it's relatively easy to create a new event using jQuery's [special events](http://benalman.com/news/2010/03/jquery-special-events/).

## How does the plugin work? ##

When a browser-native window.onhashchange event is detected, that event is used for the `hashchange` event automatically. However, when that event isn't detected, at the first attempt to bind to the event, a polling loop is started to monitor `location.hash` for changes, firing the event whenever appropriate.

Additionally, since history entries aren't added when the hash changes in IE6/7, a hidden Iframe is created and updated whenever the hash changes to trick the browser into thinking that the page's URL has changed, thus forcing new entries to be added into the history. Without this Iframe, the `hashchange` event would still fire, but without back button support the utility of the event is reduced substantially.

When the last window.onhashchange event is unbound, the polling loop is stopped (except in IE6/7, because it is still needed for back button support).

## A basic usage example ##

Simple. Bind the `"hashchange"` event to `$(window)` and every time the hash changes, the callback will fire. Check out the [working example][ex] to see this in action.

<pre class="brush:js">
$(function(){
  
  // Bind the event.
  $(window).hashchange( function(){
    // Alerts every time the hash changes!
    alert( location.hash );
  })
  
  // Trigger the event (useful on page load).
  $(window).hashchange();
  
});
</pre>

## A more robust solution ##

This plugin is, by design, very basic. If you want to add lot of extra utility around getting and setting the hash as a state, and parsing and merging fragment params, check out the [jQuery BBQ][bbq] plugin. It includes this plugin at its core, plus a whole lot more, and has thorough documentation and examples as well. You can't have too much of a good thing!

## Known hashchange issues ##

While this jQuery hashchange event implementation is quite stable and robust, there are a few unfortunate browser bugs surrounding expected hashchange event-based behaviors, independent of any JavaScript window.onhashchange abstraction. See the following pages for more information:

 * [Chrome: Back Button](http://benalman.com/news/2009/09/chrome-browser-history-buggine/)
 * [Firefox: Remote XMLHttpRequest](http://benalman.com/news/2009/11/is-this-a-firefox-remote-xhr-bug/)
 * [WebKit: Back Button in an Iframe](http://benalman.com/news/2009/12/webkit-bug-hash-history-iframe/)
 * [Safari: Back Button from a different domain](http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/)

Also note that should a browser natively support the window.onhashchange event, but not report that it does, the fallback polling loop will be used.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

_I want to thank [Brandon Aaron](http://brandonaaron.net/) for explaining parts of the jQuery.event.special API for me and providing me the example code on which I based this plugin._

