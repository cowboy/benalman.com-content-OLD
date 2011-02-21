title: "jQuery hashchange event v1.3"
categories: [ News, Project ]
tags: [ domain, event, hashchange, iframe, plugin, title ]
date: 2010-07-22 09:16:11 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've just released [jQuery hashchange event][plugin] v1.3, which fixes all outstanding [issues](http://github.com/cowboy/jquery-hashchange/issues/closed), most notably bringing `document.title` and `document.domain` support to IE6/7. In addition, the plugin has been unit tested with jQuery 1.2.6, 1.3.2, 1.4.1 and 1.4.2 in Internet Explorer 6-8, Firefox 2-4, Chrome 5-6, Safari 3.2-5, Opera 9.6-10.60, iPhone 3.1, Android 1.6-2.2 and BlackBerry 4.6-5, so you should find that it's extremely reliable.

Here's a full list of the changes in the latest version:

* Reorganized IE6/7 Iframe code to make it more "removable" for mobile-only development.
* Added IE6/7 document.title support.
* Added BlackBerry support (4.6+)
* Attempted to make Iframe as hidden as possible by using techniques suggested by [the paciello group](http://www.paciellogroup.com/blog/?p=604).
* Added support for the "shortcut" format `$(window).hashchange( fn )` and `$(window).hashchange()` like jQuery provides for built-in events.
* Renamed `jQuery.hashchangeDelay` to `jQuery.fn.hashchange.delay` and lowered its default value to 50.
* Added `jQuery.fn.hashchange.domain` and `jQuery.fn.hashchange.src` properties plus document-domain.html file to address access denied issues when setting `document.domain` in IE6/7.

As always, [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) will be updated soon to incorporate these changes, but if you want them right now, you can just grab the [hashchange event source](http://github.com/cowboy/jquery-hashchange/blob/v1.3/jquery.ba-hashchange.min.js) and integrate it yourself, which is easy to do if you just look at the [BBQ source](http://github.com/cowboy/jquery-bbq/blob/v1.2.1/jquery.ba-bbq.min.js).

Either way, check out [jQuery hashchange event][plugin] now and let me know what you think! Also, if you can, please show your appreciation for my hard work with [a donation](http://benalman.com/donate). Thanks!

  [plugin]: http://benalman.com/projects/jquery-hashchange-plugin/
