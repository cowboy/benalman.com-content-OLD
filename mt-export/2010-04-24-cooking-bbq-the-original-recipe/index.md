title: "Cooking BBQ: the original recipe"
categories: [ Code, Geek, News ]
tags: [ bbq, development, jquery, plugin ]
date: 2010-04-24 11:38:39 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Even though I initially released [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) in late 2009, the plugin has actually been many years in the making. While it started out as a little snippet of code that almost every web developer, at one point or another, has written, over time it evolved into something much larger.. and much tastier.

In this article, I'll not only explain how jQuery BBQ came to be, but I'll also give you [some things to think about](http://benalman.com/news/2010/04/cooking-bbq-the-original-recipe/#what-ive-learned), in case you're considering writing a jQuery plugin.

<!--MORE-->

## In the beginning ##

<div class="photo"><img src="http://benalman.com/code/projects/jquery-bbq/examples/fragment-advanced/ribs.jpg" width="150"/></div>

Sometime before 2005, well before I started using jQuery, I had some very simple query string parsing code that I included in every project (in a "global.js" file, along with [PPK's cookie functions](http://www.quirksmode.org/js/cookies.html), a handful of DOM wrapper methods, etc). At some point, that query string code evolved into a small [QueryString library](http://gist.github.com/324035) that could deserialize a query string, serialize an object into a params string, and merge params strings.

I had originally written QueryString to parse one or more particular state parameters out of the query string, mainly for debugging purposes, like `?debug_mode=1` → `{ debug_mode: 1 }`, but at some point, I realized that I needed to be able to merge params strings as well, in order to "pass through" query string parameters from the [window.location](https://developer.mozilla.org/En/DOM/Window.location) to some number of links on the page.

I combined a little bit of object merging code along with a little bit of object serialization code and got something that did the job, and did it well. The API was relatively simple and easy to use (but far from perfect, as I'll explain later), and everything was good.


## Along came a jQuery ##

So, at some point in 2007, I started using jQuery, and after a few projects, I realized something. jQuery came pre-packaged with the excellent [jQuery.param](http://api.jquery.com/jQuery.param/) method, which did everything that QueryString's built-in `serialize` function did.

Now, I was very hesitant to do what I'm about to describe, but.. _I decided to make my existing library-independent code dependent on jQuery._

This isn't something to take lightly, so I'd like you to step back a moment and consider the ramifications. If I then decided at any point to stop using jQuery, I would then have to revert back to older code, and any changes that I had made to the new "jQuery" version of the plugin would have to be merged back in to the old code manually, resulting in two different code branches. Also, I hadn't released my code publicly at this point, but if I had, requiring jQuery as a dependency could significantly reduce the number of people using my code, because only some of them would be using jQuery.

Still, after much consideration, I decided that, for me at least, jQuery was here to stay, and that it would be just silly to have duplicate code. So, everywhere that I could make my code smaller, I did.. and as a result, QueryString became [jQuery URL Utils](http://benalman.com/projects/jquery-url-utils-plugin/). The initial version of this now totally jQuery-dependent plugin did everything the original did, but since it lived under the jQuery namespace and used jQuery methods internally, it could be significantly smaller.

At the same time, I created unit tests and documentation, and released the plugin publicly for everyone to use, which was helpful because it allowed me to not only get user feedback, but to also give something back to the community.


## Along came some features ##

<div class="photo"><img src="http://benalman.com/code/projects/jquery-bbq/examples/fragment-advanced/kebabs.jpg" width="150"/></div>

Since more usage begets more features, over time I added them. Because I was propagating query string parameters mainly into internal links, I needed some code to help identify which links were internal. And since filtering links based on internal- or external-ness can be [far more complex](http://benalman.com/projects/jquery-urlinternal-plugin/) than just testing to see if a link starts with "http://", I wrote a few regular expressions as well as some custom jQuery selectors and filtering methods.

By this time, the API had grown somewhat, but was still backwards-compatible and relatively simple (yet still far from perfect, as I promised I'll explain later).


## Eureka! ##

Up until this point, I had been working entirely with query strings, and had never touched the [location.hash](https://developer.mozilla.org/En/DOM/Window.location#Properties), but one day the topic of fragments, a "fragment change" event and single-page web applications came up. And something in my brain clicked, because I had an idea.

I took a look around at some other JavaScript "history" libraries and plugins and noticed that they usually set the hash as an arbitrary string like `#somefragment` or as a path like `#/deep/linking/fragment`, but why didn't anyone use a params string?

Just think.. by generalizing the query string deserialization / serialization / merging code that I had already written to support not only query string but also fragments, I could allow the hash to be set like a query string `#a=1&b=2&c=3`. This way, individual parameters could be changed independently of other parameters, allowing multiple separate widgets on a page to have overlapping "back button history" with a minimum of effort. Cool!

And then, around all this, was the idea of a "fragment change" event. At the time, this wasn't even remotely a new idea, but to me it was, so I ran with it. Of course, had I known about either the new HTML5 [window.onhashchange](https://developer.mozilla.org/en/DOM/window.onhashchange) event or the [jQuery special events API](http://benalman.com/news/2010/03/jquery-special-events/) at the time, I would have done it much differently, but that's ok, because I created a custom jQuery "fragmentChange" event that worked everywhere.

At this point, I had a working plugin and everything was great. OR WAS IT?!


## Frustration ##

No, things were actually pretty great. But they could have been better. Looking back, I realized that I had tried to be a little "too smart" with the original QueryString API, which hadn't really changed much in URL Utils. Take a look at this usage example, and see if you can spot the problem.

<pre class="brush:js">
// returns data Object from document.location.search.
$.queryString();

// returns serialized '?a=1&b=2' string.
$.queryString( { a:1, b:2 } );

// returns deserialized { a:1, b:2 } object.
$.queryString( '?a=1&b=2' );

// returns '/foo?a=1&c=3&b=2' url.
$.queryString( '/foo?a=0&c=3', { a:1, b:2 } );

// returns '/foo?a=1&c=3&b=2' url.
$.queryString( '/foo?a=0&c=3', '?a=1&b=2' );
</pre>

If you've spent some time developing an API, you may have tried to do this kind of thing at some point, and it ends up causing a bit of a mess. What am I talking about? Well, in a nutshell: the `$.queryString` method returns very different results based on the parameters that are passed to it. Pass it an object and you get a string. Pass it a string or nothing and you get an object.

Now.. without context, really descriptive comments, or hungarian notation, you might look at code you wrote a few months earlier and wonder what the heck is going on. For example, does `do_something` return a string or an object? I have no idea. You have no idea. Nobody has any idea.

<pre class="brush:js">
function do_something() {
  // do some stuff here..
  // more stuff..
  return $.queryString( some_other_function() );
}

do_something(); // What does this return?? I don't know!!
</pre>

In addition to the confusion I felt could arise from these "too smart" methods, it made sense for me to change the custom "fragmentChange" event to the HTML5 [window.onhashchange](https://developer.mozilla.org/en/DOM/window.onhashchange) event, and to actually use the native browser event to power the custom event wherever possible, for the best possible performance.

Of course, these were some fairly large API changes, which warranted a whole new major version number. Or a whole new plugin, with a more carefully crafted, brand new API.


## Now we're cooking ##

<div class="photo"><img src="http://benalman.com/code/projects/jquery-bbq/examples/fragment-advanced/steak.jpg" width="150"/></div>

While part of me didn't want to create a new plugin, I had been looking for something a little sexier and more SEO-friendly than "URL Utils," and when [Paul Irish](http://paulirish.com/) suggested the name "BBQ: Back Button & Query" everyone in the #jquery IRC channel knew it was a winner.

So, now that we had a name, I started rewriting the plugin. The first thing was to make those "too smart" methods both a little less smart and a little more smart. I created a general purpose [jQuery.deparam](http://benalman.com/code/projects/jquery-bbq/docs/files/jquery-ba-bbq-js.html#jQuery.deparam) method that could be used to deserialize any params string that the built-in [jQuery.param](http://api.jquery.com/jQuery.param/) could serialize. Then, I created param- and deparam-specific fragment and query string methods that each always returned the same kind of value. Unlike their predecessors, `jQuery.param.querystring` and `jQuery.param.fragment` (like `jQuery.param`) always returned strings, while `jQuery.deparam.querystring` and `jQuery.deparam.fragment` (like `jQuery.deparam`) always returned objects, removing any potential ambiguity.

I removed the custom "fragmentChange" event and created a new [hashchange event](http://benalman.com/projects/jquery-hashchange-plugin/) from the ground up, utilizing the [jQuery special events API](http://benalman.com/news/2010/03/jquery-special-events/), with code to use the native HTML5 [window.onhashchange](https://developer.mozilla.org/en/DOM/window.onhashchange) event in any browser that supported it.

I also experimented with getting jQuery BBQ to implement the [HTML5 history interface](http://www.whatwg.org/specs/web-apps/current-work/#the-history-interface), but I ended up scrapping that idea after experiencing a lot of difficulty with getting all the specified methods to work cross-browser. I ended up settling on a subset of that functionality centered around "pushing" a state onto the hash and "getting" the current state from the hash.

Finally, I split the url internal- and external-ness selector / filtering code into its own plugin, [jQuery urlInternal](http://benalman.com/projects/jquery-urlinternal-plugin/), because it seemed like, while it was very useful code, not everyone would need it when using jQuery BBQ. If a user wanted it, they could just as easily download it separately.

Oh, and while I was at it, I spent some time rewriting the core [jQuery 1.4 $.param method](http://benalman.com/news/2009/12/jquery-14-param-demystified/) to make sure that not only did it work well with nested objects in PHP and rails, but that both it and BBQ played together as nicely as possible.

Either way, I spent a lot of time developing the jQuery BBQ API, talking to a number of people to get their feedback and suggestions, and I feel that it was time well spent.


## Après-dinner ##

<div class="photo"><img src="http://benalman.com/code/projects/jquery-bbq/examples/fragment-advanced/burger.jpg" width="150"/></div>

Since the initial release of jQuery BBQ, the API has stayed relatively stable, and the plugin has seen minor bug-fix point releases. The [jQuery hashchange event](http://benalman.com/projects/jquery-hashchange-plugin/) has actually been extracted from [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) to work as a stand-alone plugin for people who either feel that 1.6KB gzipped is "just too big" or who want to create their own API around just the event.

While I have a few minor enhancements planned for jQuery BBQ and the hashchange event, I don't anticipate any major changes, so if you've used either in a project and have any practical suggestions, I would love to hear them.


<a name="what-ive-learned"></a>
## So, you want to be a chef? ##

I hate to break the cooking metaphor, but I want to offer a fairly straightforward list of plugin authoring tips that I've learned from my experience working on jQuery BBQ (and other plugins) over the last few years, so if you're interested in creating a plugin, read on.

 * Don't just make a "jQuery" plugin. Figure out if your code is actually dependent on jQuery, and if you can avoid repeating code by using jQuery, make a jQuery plugin. If your code doesn't require jQuery, either create a JavaScript "plugin" (like [JavaScript Debug](http://benalman.com/projects/javascript-debug-console-log/)) or a "jQuery plugin" that works without jQuery (like [jQuery throttle / debounce](http://benalman.com/projects/jquery-throttle-debounce-plugin/)).
 * Spend some time really thinking through your plugin's API. Try to not only provide methods that will do the job, but are well organized and that make sense when looked at on their own in production code.
 * Create an API that you enjoy using! If using your plugin's methods feels awkward to you, the creator, think about how others will feel when they try to use your plugin.
 * Document your plugin thoroughly, providing clear usage examples. If your plugin can be used many different ways, don't skimp on the examples. Most of the time, people will just copy your example code and modify it to fit their needs, so you might as well save them some time.
 * Write unit tests for your plugin. Comprehensive unit tests serve three purposes, if they're done right. First, you know that your code works cross-browser (it should work in at least all the browsers that jQuery supports). Second, when you make changes, your know when you've broken something, so you can fix it before release. Finally, other developers can see that your code is solid, so they don't have to worry trying to use a half-working plugin.
 * Don't put too much functionality into one plugin! If you can make a good case for collecting all those methods into one plugin, great. If you can't, consider slimming down your API.
 * Finally (and maybe this should have been first), look around at other developers' code, and learn from what they have done. If you're going to create _yet another plugin_ that provides "feature X," it needs to have some kind of differentiator that makes it stand out from the other offerings out there!

As always, if you have any feedback or suggestions, please don't hesitate to post your thought in the comments, thanks!

