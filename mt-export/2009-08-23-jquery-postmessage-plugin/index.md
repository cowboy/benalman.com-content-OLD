title: "jQuery postMessage: Cross-domain scripting goodness"
categories: [ Projects, jQuery ]
tags: [ crossdomain, iframe, jquery, plugin, postmessage, xss ]
date: 2009-08-23 20:19:34 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery postMessage enables simple and easy window.postMessage communication in browsers that support it (FF3, Safari 4, IE8), while falling back to a document.location.hash communication method for all other browsers (IE6, IE7, Opera).

<!--MORE-->

With the addition of the [window.postMessage][postMessage] method, JavaScript finally has a fantastic means for cross-domain frame communication. Unfortunately, this method isn't supported in all browsers. [One example][ex] where this plugin is useful is when a child Iframe needs to tell its parent that its contents have resized.

 * Release v0.5
 * Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 3, Safari 3-4, Chrome, Opera 9.
 * Download [Source][src], [Minified][src-min] (0.9kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * Examples: [Iframe resizing][ex]

  [github]: http://github.com/cowboy/jquery-postmessage
  [issues]: http://github.com/cowboy/jquery-postmessage/issues
  [src]: http://github.com/cowboy/jquery-postmessage/raw/master/jquery.ba-postmessage.js
  [src-min]: http://github.com/cowboy/jquery-postmessage/raw/master/jquery.ba-postmessage.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-postmessage/docs/
  
  [ex]: http://benalman.com/code/projects/jquery-postmessage/examples/iframe/

  [postMessage]: https://developer.mozilla.org/en/DOM/window.postMessage
  [iframe]: http://benalman.com/code/test/js-jquery-postmessage/

## An Example ##

Let's say that you have a page at `http://benalman.com/test.html` with an Iframe. Unfortunately, the Iframe contents live at `http://rj3.net/test.html`, and due to cross domain security restrictions, the message 'hello world' that the Iframe (child) wants to send to its parent can't be received. Well, it can.. but only in certain browsers, none of which are IE7, which is still the most popular browser out there. With `$.postMessage` this is not only possible, but easy.

First, both parent and child pages need to include jQuery as well as the jQuery postMessage plugin.

This code is in the "receiving" (parent) page:
<pre class="brush:js">
$.receiveMessage(
  function(e){
    alert( e.data );
  },
  'http://rj3.net'
);
</pre>

It basically lets the window know to look for messages, but only from `'http://rj3.net'`, and when they come in, alert them.

The "sending" (child) page executes this code:
<pre class="brush:js">
$.postMessage(
  'hello world',
  'http://benalman.com/test.html',
  parent
);
</pre>

In browsers where [window.postMessage][postMessage] is supported, the message `'hello world'` is simply passed from the child frame to the parent window, and it is alerted. Very simple!

In other browsers, the child window sets the parent window location to `http://benalman.com/test.html#hello%20world`. Despite the fact that the entire URL has been set, because only the location.hash has really changed, the browser doesn't completely reload the page. Instead, the hash change is detected and the callback is called, and the message is alerted. For this reason, it is *absolutely mandatory* that the full URL of the parent page be passed into `$.postMessage` as its second param. This URL could be hard-coded into the "sending" page, or passed in dynamically.

This is better illustrated using [a live example][ex], where an iframe lets its parent know that its contents have changed, so that the Iframe can be resized.

## Notes ##

 * The [MDC window.postMessage][postMessage] reference is very useful, so be sure to check it out if you have any questions about how the method and event work.
 * In browsers that don't support window.postMessage, a "cache bust" parameter is added to the location.hash to ensure that multiple sequential-yet-same messages (like "toggle" for example) will each trigger the event.
 * In browsers that don't support window.postMessage, this script might conflict with a fragment history plugin, because the location.hash is modified. Fortunately, the hashes this script creates match the `/^#?\d+&/` regexp, so it is possible to filter them out.
 * In browsers that don't support window.postMessage, because polling is used for detection of the location.hash change, care must be taken to ensure that `$.postMessage` isn't called too rapidly, or messages may be lost. Ingenious [non-polling methods](http://shouldersofgiants.co.uk/Blog/post/2009/08/17/Another-Cross-Domain-iFrame-Communication-Technique.aspx) exist for detecting a location.hash change, but because they require additional proxy Iframes and HTML files, I've chosen to keep it simple and use polling.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

