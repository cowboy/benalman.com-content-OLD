title: "jQuery BBQ v1.1.1, also BBQ + jQuery 1.3.2 or 1.4?"
categories: [ News, Project ]
tags: [ bbq, bug, event, hashchange, ie8, meta, plugin ]
date: 2010-01-26 07:00:00 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

First, this minor [jQuery BBQ][bbq] bugfix release incorporates the just-updated [jQuery hashchange event v1.1](http://benalman.com/news/2010/01/jquery-hashchange-event-v11/) which fixes a pretty obscure (but not entirely surprising) IE8 bug. No changes were made other than this very minor tweak, so if you're not using the X-UA-Compatible IE=EmulateIE7 meta tag, you can safely ignore this update. If you are, then run--don't walk--to the plugin page right now for the [v1.1.1 update][bbq]!

Second, a lot of people ask which version of jQuery they should use with BBQ. Since the plugin has been coded with both jQuery 1.3.2 and 1.4+ in mind, it fully works (and has been [unit tested](http://benalman.com/code/projects/jquery-bbq/unit/)) with both versions. And since 1.4 has seen some major speed increases, as well as some powerful event enhancements and a much improved [.param method](http://benalman.com/news/2009/12/jquery-14-param-demystified/) (both of which BBQ utilizes) I recommend that version.. but either will work just fine!

Please note that if you're using jQuery 1.4, due to an [event namespacing bug](http://dev.jquery.com/ticket/5834) I recommend that you upgrade to [jQuery 1.4.1](http://jquery14.com/day-12/jquery-141-released) ASAP, which addresses this and a few other issues.

Also, I want to thank [Vincent Voyer](http://github.com/vvo) for not only bringing the IE8 issue to my attention, but also using the GitHub issue tracker to report the bug, which made it easy for me to address!

  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/
