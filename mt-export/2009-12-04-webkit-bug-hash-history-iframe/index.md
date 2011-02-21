title: "WebKit bug: hash history + Iframe = fail"
categories: [ Code, Geek, News ]
tags: [ bug, chrome, hash, iframe, javascript, location, safari, webkit ]
date: 2009-12-04 08:55:07 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I recently encountered an odd behavior in WebKit while testing [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) on a page that lived in an Iframe. What I initially thought might be a bug in jQuery BBQ actually appears to be a bug in Webkit, so I set up an [example page](http://benalman.com/code/projects/jquery-hashchange/examples/bug-webkit-hash-iframe/) that shows how location.hash browser history breaks in an Iframe, in WebKit, Safari, and Chrome.

<!--MORE-->

To make a long story short, when the location.hash is changed in a document loaded in an Iframe, history entries are not always created correctly. 

For example, given an Iframe like this: `<iframe src="page.html#begin"></iframe>`

If that page.html location.hash is then set to #middle and #end, when the back
button is pressed, #middle can be reached, but #begin cannot. That's in the latest WebKit nightly.. in the current Safari and Chrome, no history is created whatsoever!

Please view the [example page](http://benalman.com/code/projects/jquery-hashchange/examples/bug-webkit-hash-iframe/) and WebKit Bugzilla [Bug 32156](https://bugs.webkit.org/show_bug.cgi?id=32156) to see for yourself!

