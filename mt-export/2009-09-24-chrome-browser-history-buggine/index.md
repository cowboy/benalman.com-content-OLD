title: "Chrome, browser history, bugginess"
categories: [ Code, Geek, News ]
tags: [ back button, bug, chrome, history, javascript, web ]
date: 2009-09-24 07:24:19 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

So I've been working on a groovy new jQuery history / deparam plugin.. and in my testing I've encountered a rather elusive yet completely evil bug in Chrome (current, 3.0.195.21) / Chromium: When document.location.hash is changed via JavaScript, new history entries sometimes are NOT created.

<!--MORE-->

This means that while using a complex AJAX/DHTML webapp like Gmail in Chrome, sometimes pressing the "back" button will skip pages, possibly even navigating back to the page you were on before you loaded the webapp, causing you to completely lose your state.

For example, when Gmail is loaded from a `http://mail.google.com/mail/#inbox` bookmark and then a message is selected, JavaScript changes document.location (via the hash) to `http://mail.google.com/mail/#inbox/1e9241db222afca0`, which adds a history entry for the previous URL. To get "back" to the previous page, either the "back" button can be pressed, the previous page can be selected from the back button dropdown menu, or the JavaScript method `window.history.go(-1);` can be called.

In Chrome, as a direct result of this bug, sometimes no "Inbox" history entry corresponding to the `#inbox` hash gets created. It's not a Gmail thing. It's not a JavaScript history library thing. It's an actual, low-level Chrome history bug. And because a history entry might not be created for the inbox, when you press the back button it could take you right past the inbox and into the completely-previous non-Gmail page you were on. What a mess.

As I've said, this bug is elusive. Sometimes you see it, sometimes you don't. I've encountered it on multiple machines, and have even created a very basic [Back Button Test page](http://benalman.com/code/projects/jquery-hashchange/examples/bug-chrome-back-button/) so you can see it for yourself. I have also added a comment into what seems to be the [official Chromium issue, 1016](http://code.google.com/p/chromium/issues/detail?id=1016) for this bug, linking back to my test page.

If you have any findings, comments, or suggestions.. please post them here, thanks! And check back in a few days for my new plugin, jQuery BBQ: Back Button & Query Library. I'm still writing unit tests for it over at [GitHub](http://github.com/cowboy/jquery-bbq), but I'll be done soon!

_Note: It's common knowledge that IE6 and IE7 don't add history entries when document.location.hash is changed, but everything else does.. or should!_

