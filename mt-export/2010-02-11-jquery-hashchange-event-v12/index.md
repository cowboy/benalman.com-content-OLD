title: "jQuery hashchange event v1.2"
categories: [ News, Project ]
tags: [ bug, event, hashchange, plugin, safari ]
date: 2010-02-11 09:22:39 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've just updated [jQuery hashchange event][plugin] to fix a [bizarre bug in Safari](http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/). Apparently references to window.location become stale when pressing the back button from a page on another domain.

Of course, this broke the plugin for the one person who was doing this (thanks for the tip, [Chris](http://github.com/csytan)), but it's now fixed, along with [WebKit Bugzilla bug 34679](https://bugs.webkit.org/show_bug.cgi?id=34679) filed, and a few other miscellaneous things:

* The IE6/7 Iframe is now inserted after the body (this actually works), which prevents the page from scrolling when the event is first bound.
* The event can also now be bound before DOM ready, but it won't be usable before then in IE6/7. Meaning: you can do it, but be warned!
* The plugin is now unit-tested in jQuery 1.4.2pre, and everything works!

[jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) will be updated soon to incorporate these changes, but if you want them right now, you can just grab the [hashchange event plugin][plugin]!

  [plugin]: http://benalman.com/projects/jquery-hashchange-plugin/
