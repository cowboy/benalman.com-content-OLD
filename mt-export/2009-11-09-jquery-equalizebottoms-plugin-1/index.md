title: "jQuery equalizeBottoms plugin v1.4"
categories: [ News, Project ]
tags: [ columns, equalize, jquery, layout, plugin ]
date: 2009-11-09 09:00:00 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With [jQuery equalizeBottoms][plugin] you can "equalize" the bottoms of multiple elements, making columns heights even, even when CSS refuses to help.

I actually created this plugin back in April, but never officially released it. After designing the basic functionality, I built-in the ability to poll for element height changes.. but since then, I've created [jQuery doTimeout](http://benalman.com/projects/jquery-dotimeout-plugin/), which handles all that fancy polling stuff, should you need it. So, long story short, I removed all the unnecessary polling code from equalizeBottoms, which leaves just the lean and mean bottom-equalizing code!

Either way, check out [the plugin][plugin] now, and let me know what you think!

  [plugin]: http://benalman.com/projects/jquery-equalizebottoms-plugin/
