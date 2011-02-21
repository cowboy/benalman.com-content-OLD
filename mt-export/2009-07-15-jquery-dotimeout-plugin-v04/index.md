title: "jQuery doTimeout plugin v0.4"
categories: [ Code, News, Project ]
tags: [ doTimeout, jquery, plugin ]
date: 2009-07-15 14:07:10 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I just updated my [doTimeout plugin][dotimeout], adding a few useful features. First, the id argument is completely optional now, and if the callback returns true, a polling loop is created. More functionality, easier to use, what more could you want?

In case you aren't familiar with doTimeout, here's a description:

It's fairly common to need to delay execution of some code, and then also repeatedly continue to delay that code until some condition is met (polling). It's also not uncommon to need to delay execution of some code until a triggering event or events has stopped for a certain amount of time (debouncing). This [jQuery](http://jquery.com/) plugin greatly simplifies doing either of those things, as well as many other delay- or interval-related tasks. Just think of setTimeout, but with additional management options, jQuery chainable, and with a simpler and more flexible API.

As always, check out the documentation and examples over at the [doTimeout plugin][dotimeout] page now, and let me know if you have any questions, comments, or suggestions!

  [dotimeout]: http://benalman.com/projects/jquery-dotimeout-plugin/
