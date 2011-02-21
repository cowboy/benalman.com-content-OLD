title: "Is this a Firefox remote XMLHttpRequest bug?"
categories: [ Code, Geek, News ]
tags: [ bug, firefox, hash, javascript, location ]
date: 2009-11-09 23:03:22 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

A [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) user came across a rather interesting behavior in Firefox the other day, so I set up an [example page](http://benalman.com/code/projects/jquery-hashchange/examples/bug-firefox-remote-xhr/) to test things out.. and it turns out I've either encountered a completely useless "feature" or a legitimate (and annoying) bug in Firefox when setting `location.href` in a remote XMLHttpRequest callback.

<!--MORE-->

So maybe this is a totally ridiculous edge-case, but when I make a cross-domain JSONP `jQuery.ajax()` request, if the success callback tries to change the hash by setting `location.href = baseurl + "#hash"` instead of `location.hash = "#hash"`, things break.. but not in the way you _might_ expect.

And note that if I wrap the location-setting code in a `setTimeout`, everything works as-expected.

Now, you might think this is some kind of fancy security feature, "well, some data is coming from an external site, so it's unsafe to change the location." Except that the problem isn't in the location being changed. The location gets changed just fine. The problem is that the _previous_ location loses its history entry, such that hitting the back button actually skips back _two_ locations.

It's the same behavior you'd expect from a `location.replace()` call.

So, I'm going out on a limb here and calling this a bug, which I've submitted as [Firefox bug 527618](https://bugzilla.mozilla.org/show_bug.cgi?id=527618). Either way, please check out the [example page](http://benalman.com/code/projects/jquery-hashchange/examples/bug-firefox-remote-xhr/) in Firefox 2-3.6 on any OS for yourself, and let me know what you think!

Also, once I figure out what the deal is, I'll update [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) so that this is no longer an issue.

