title: "jQuery BBQ plugin v1.0.3"
categories: [ News, Project ]
tags: [ bbq, bug, jquery, plugin ]
date: 2009-12-02 22:14:53 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've just updated [jQuery BBQ][bbq] to 1.0.3, fixing a really stupid IE 6 bug, and making a few internal tweaks and API refinements.

The stupid IE6 bug? Commenter [Bogdan Stoica](http://benalman.com/projects/jquery-bbq-plugin/#comment-186) noticed that with a URL like `http://example.com#foo?bar`, IE 6 would mistakenly report `location.hash` to be "foo" and `location.search` to be "bar" which.. is completely insane.

Since jQuery BBQ already contained some code to fix a few cross-browser location idiosyncrasies, I just expanded and generalized it a bit, creating a pair of internal "get the _actual_ fragment and query string" utility methods, that the publicly available methods can utilize.

The API refinements are minor.. the `$.param.querystring` and `$.param.fragment` methods now need a valid URL as the first parameter. For example "a=1&b=2" won't work there, while "?a=1&b=2" will. This probably doesn't affect you anyways, so don't worry about it.

 [bbq]: http://benalman.com/projects/jquery-bbq-plugin/
