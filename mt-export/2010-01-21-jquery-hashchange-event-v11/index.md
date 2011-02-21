title: "jQuery hashchange event v1.1"
categories: [ News, Project ]
tags: [ bug, event, hashchange, ie8, meta, plugin ]
date: 2010-01-21 09:51:31 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This release fixes a bug in IE8, when [jQuery hashchange event][plugin] is used on a page with the [X-UA-Compatible IE=EmulateIE7 meta tag](http://www.nczonline.net/blog/2010/01/19/internet-explorer-8-document-and-browser-modes/). Apparently IE behaves a little differently when the meta tag is used versus when the "IE7 Compatibility Mode" toolbar button is pressed, so the code has been updated and an additional [unit test](http://benalman.com/code/projects/jquery-hashchange/unit/ie7-compat.html) has been added.

If you use the hashchange event plugin and the X-UA-Compatible IE=EmulateIE7 meta tag, please [update to v1.1][plugin] to fix this issue.

I want to thank [Vincent Voyer](http://github.com/vvo) for not only bringing this issue to my attention, but also using the GitHub issue tracker to report the bug, which made it easy for me to address! Also, I will update [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) as soon as possible to take advantage of this bug fix.

  [plugin]: http://benalman.com/projects/jquery-hashchange-plugin/
