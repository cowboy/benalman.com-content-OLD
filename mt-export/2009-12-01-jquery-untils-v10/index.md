title: "jQuery Untils v1.0"
categories: [ Code, News, Project ]
tags: [ jquery, next, parents, plugin, prev, siblings, traversal ]
date: 2009-12-01 13:59:25 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

A while back, I coded up a very basic [nextUntil](http://github.com/cowboy/jquery-misc/blob/master/jquery.ba-nextUntil.js) method, but it felt a bit simplistic. I felt that I could code a slightly more "general" solution that actually sorted correctly.. so here's the result:

[jQuery Untils](http://benalman.com/projects/jquery-untils-plugin/) provides three very simple, but very useful methods: nextUntil, prevUntil, and parentsUntil. These methods are based on their nextAll, prevAll, and parents counterparts, except that they allow you to stop when a certain selector is reached. Elements are returned in "traversal order".

Note that these methods take a less naïve approach than others bearing the same names, and are designed to actually return elements in traversal order, despite the element ordering flaws inherent in the jQuery 1.3.2 selector engine. A [ticket](http://dev.jquery.com/ticket/5551) and [patch](http://github.com/cowboy/jquery/commit/cbf1da9ed88b14bc991fc2dcfec87750d19237ad) have been submitted to the jQuery team for hopeful inclusion in the 1.4 release.

Check out the documentation and examples at the [plugin page](http://benalman.com/projects/jquery-untils-plugin/), and let me know what you think in the comments!
