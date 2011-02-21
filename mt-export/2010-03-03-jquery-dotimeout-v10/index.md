title: "jQuery doTimeout v1.0"
categories: [ News, Project ]
tags: [ delay, jquery, plugin, settimeout ]
date: 2010-03-03 09:09:42 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I haven't had a reason to update [jQuery doTimeout][plugin] in a long time, mainly because nobody has had any suggestions on how to improve it.. until last night, when [Brandon Aaron](http://brandonaaron.net/) suggested that, "hey, wouldn't be great if doTimeout could be called like this: `$('div').show().doTimeout( 2000, 'hide' )`, passing a string jQuery method name instead of a function reference?"

Well, it seemed like a great idea to me, so I took a look at the plugin, spent about fifteen minutes adding four lines of code.. and then spent another few hours updating documentation, examples, and unit tests.

The end result is [version 1.0][plugin], which makes it even easier for people to delay execution of their jQuery methods. Just take a look at the first [hover intent example](http://benalman.com/code/projects/jquery-dotimeout/examples/hoverintent/) to get an idea of how easy it is now!

[plugin]: http://benalman.com/projects/jquery-dotimeout-plugin/
