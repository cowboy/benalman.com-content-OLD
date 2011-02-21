title: "jQuery BBQ v1.1 and jQuery hashchange event v1.0"
categories: [ News, Project ]
tags: [ bbq, hashchange, jquery, plugin ]
date: 2010-01-10 17:31:15 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Version 1.1 brings some substantial changes to [jQuery BBQ][bbq]. I reorganized the plugin code substantially, which allowed the core `window.onhashchange` event functionality to be broken out into a separate [jQuery hashchange event][hashchange] plugin.

The end result is that while jQuery BBQ is still just as awesome as it's always been, if you've wanted just a very basic, streamlined, normalized, cross-browser jQuery hashchange event without all the extra awesomeness that BBQ provides, it's now available separately as [jQuery hashchange event][hashchange].

In addition, BBQ now has a new [$.bbq.removeState](http://benalman.com/code/projects/jquery-bbq/docs/files/jquery-ba-bbq-js.html#jQuery.bbq.removeState) method, which a few people have requested, as well as updated unit tests that utilize the most recent version of [QUnit](http://github.com/jquery/qunit).

Check out the [jQuery BBQ][bbq] project page as well as the new [jQuery hashchange event][hashchange] project page for more information, and let me know what you think!

  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/
  [hashchange]: http://benalman.com/projects/jquery-hashchange-plugin/
