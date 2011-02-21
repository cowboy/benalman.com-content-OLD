title: "jQuery BBQ v1.2.1"
categories: [ News, Project ]
tags: [ bug, event, hashchange, ie, jquery, plugin, safari, special events ]
date: 2010-02-16 21:33:17 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This [jQuery BBQ][bbq] release incorporates the recently-updated [jQuery hashchange event v1.2](http://benalman.com/news/2010/02/jquery-hashchange-event-v12/) which fixed a [bizarre bug in Safari](http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/), and a few other miscellaneous things:

* The IE6/7 Iframe is now inserted after the body (this actually works), which prevents the page from scrolling when the event is first bound.
* The event can also now be bound before DOM ready, but it won't be usable before then in IE6/7. Meaning: you can do it, but be warned!

In addition, I:

* Added the [$.param.fragment.noEscape](http://benalman.com/code/projects/jquery-bbq/docs/files/jquery-ba-bbq-js.html#jQuery.param.fragment.noEscape) method, which allows designating characters to *not* be urlencoded in the hash, which can result in prettier-looking URLs.
* Reworked the hashchange event internal "add" method to be compatible with changes made to the jQuery 1.4.2 special events API.
* Unit-tested the plugin in jQuery 1.3.2, 1.4.1, and 1.4.2... and everything works!

Also, since the special events API in jQuery 1.4.2 has been reworked (fixing some serious issues), I recommend that you update to [jQuery 1.4.2](http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js) as soon as possible. Keep in mind that jQuery BBQ prior to v1.2.1 will not be fully compatible with jQuery 1.4.2, because of the aforementioned API changes, so I recommend upgrading both BBQ and jQuery to the latest versions!

So, what are you waiting for, [get the latest and greatest now!][bbq]

_Note: this post was originally for BBQ v1.2, but since it's only been a few hours and I've already released BBQ v1.2.1, I'm just going to edit this existing post and hope that nobody notices. Except that I'm explicitly commenting about it in the post. Damn, you've found me out._

  [bbq]: http://benalman.com/projects/jquery-bbq-plugin/
