title: "Bookmarked AJAX Hashes + Graceful Degradation = Future Incompatibilty?"
categories: [ Code, News ]
tags: [ @hidden, @nonav, @nosearch ]
date: 2010-04-15 11:29:26 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This question / issue has been occupying my thoughts for a while now, and as I don't know quite what to do, I'm going to throw it out there and see what (if any) discussion follows.

## Hashes and Fragments  ##

The [location.hash](https://developer.mozilla.org/en/DOM/window.location#Location_object) or [fragment identifier](http://www.w3.org/TR/html401/intro/intro.html#fragment-uri) part of a URL refers to everything following (and including, in the case of location.hash) the `#` symbol in that URL. The fragment is used as a "method for linking to a location within a resource." This is most commonly used in [tables of content](http://www.w3.org/TR/html401/index/elements.html) or [tabbed interfaces](http://www.filamentgroup.com/dwpe/), and if you don't already know this, read more about [the A element](http://www.w3.org/TR/html401/struct/links.html#adef-name-A), and btw welcome to, like, [1993](http://www.imdb.com/title/tt0105950/).

Anyways, in case you've been living under a rock for the last few years, or never used Gmail, or one of the five thousand other single-page web apps out there, there are a few very cool things that the location hash allows you to do.

When the hash is changed, the current page URL changes, but _without the browser navigating to a new page_. Not only does this generate a new, bookmarkable URL, but in all browsers (provided a [little JavaScript is present](http://benalman.com/projects/jquery-hashchange-plugin/) to fix some IE6/7 issues) it creates a new history entry, allowing the user to use the back button to return to the previous URL (and hash).

## Web applications ##

This approach is especially useful in complex web apps, because when combined with [AJAX](http://www.adaptivepath.com/ideas/essays/archives/000385.php), the hash allows single-page JavaScript-driven web apps to function like multi-page web apps, where the back and next buttons work and each sub "page" is bookmarkable, but all the extra overhead of needing to request, reload and re-initialized the entire application for each new "page" is eliminated.

This has obvious benefits for complex web applications, where increasing speed and reducing the number of HTTP requests is critical, and taking this approach usually results in a much better experience for the user, because of the increased performance.



But what about using 




I've developed this pretty nifty jQuery plugin, you may have heard of it, called [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) that allows you to do all kinds of cool things with the `location.hash` property, among other things. There are a lot of plugins that do this kind of thing, and while mine is yet another one in a long list, I think the implementation is pretty unique and worth checking out.

But I digress. So, in
