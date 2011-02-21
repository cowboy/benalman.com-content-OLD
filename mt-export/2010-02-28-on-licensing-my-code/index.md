title: "On licensing my code"
categories: [ Code, News ]
tags: [ jquery, license, plugin ]
date: 2010-02-28 10:00:25 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

When I initially started releasing [jQuery][jquery] plugins, I asked a number of my peers how I should license them. I was already using a [Creative Commons](http://benalman.com/about/license/) license for my photography and text, but I had read that [it wasn't recommended for software][cc]. The most common suggestion was to use the [MIT license][mit], which I really liked because it is concise, establishes that I own the copyright, that the software in question is free, and that no warranty is provided.

You might not be thinking about this now, but it's never a bad idea to state somewhere that this hard work, that you're doing free of charge because you love open source, is provided as-is, without any kind of warranty. I'm not saying that anyone is going to hold you liable and take you to court because your code broke in production due to some wacky bug, costing them thousands of dollars.. but you're better safe than sorry, right?

Either way, the MIT license allows people to pretty much use your code however they want, in a free or commercial product, as long as they keep your copyright notice intact.

So, that's it, right? Well, that's actually only half the story...

[mit]: http://en.wikipedia.org/wiki/MIT_License
[gpl]: http://en.wikipedia.org/wiki/GNU_General_Public_License
[cc]: http://wiki.creativecommons.org/FFAQ#Can_I_license_software_using_CC_licenses.3F
[drupal]: http://drupal.org/
[jquery]: http://jquery.com/
[bbq]: http://benalman.com/projects/jquery-bbq-plugin/

<!--MORE-->

## Dual licensing MIT and GPL ##

While my code was all initially MIT licensed, I have since changed my licensing policy somewhat, to be more inline with jQuery's licensing, which is a dual licensed under the [MIT license][mit] and [GPL license][gpl]. That basically means that, like jQuery, whenever someone wants to use one of my plugins, they can choose whether they want to use the MIT or GPL license, depending on where that plugin is being used.

From my point of view, there are really no downsides--the GPL license is actually more restrictive (for the end user) than the MIT license. I was already giving my stuff away for free, and the GPL doesn't prevent that in any way.. I still own the copyright, I'm still providing no warranty.. but now, projects that are GPL-licensed can actually use my code.

This all came about a few months back, when I was contacted by someone working on the GPL-licensed [Drupal][drupal] CMS. They wanted to include my [jQuery BBQ][bbq] plugin in the Drupal D7 core for some advanced hash-history stuff they were doing, but they couldn't actually use it because my code wasn't also GPL licensed.

So, after doing a little research, it became obvious for me that the best thing to do was to license my code exactly the same way that jQuery is licensed. That way, anyone can use any of my plugins anywhere they're already using jQuery, and they don't need to contact me about anything.

## Don't get fancy ##

You might want to make people let you know that they're using your code, you might say, "This software is beer-ware. Buy me a beer if you like it." but do you really want to inconvenience other developers or yourself? The short answer: No.

You might really care about who is using your code right now, but later on, when you're busy with the next big project, you're not going to want the hassle of keeping track of all that stuff. Just ask people, outside any kind of license, to post about how cool your stuff is in your blog comments, or something.

And just face it, the majority of developers can't be bothered, and will just skip your plugin, even if it's totally awesome, if it's a hassle. They probably won't buy you a beer or donate, even if you ask politely. But they'll be glad to use your totally free, open-source-with-no-strings-attached code. Some of the cool guys will donate, but people generally expect middle-tier and front-end code to be free, so get used to it.

## Well, it works for me ##

I'm not writing all this code for profit.. I'm doing it because I like helping contribute to this cool open source "jQuery" thing. And in writing plugins that both designers and developers might use, I'm learning how to better organize, test and document my code which is only going to help make me a better developer in the end. And if I can write code that helps people, all the better.

While I'd like to know who is using my plugins, and while I'd love people to buy me beers or otherwise donate to me, it's far more important for me to make it easy for people to use my plugins. And this goes not only for jQuery plugins, but all the code I write and release. You may have different motives, that's entirely up to you, but I highly recommend this approach.

To sum it all up, dual licensing your code both MIT and GPL covers your bases, ensures that people will actually be able to use your code everywhere they already use jQuery (which is pretty much everywhere, these days), and keeps the barrier to entry low, making it as easy as possible for people to actually use your code.. which is great, if that's what you want!

### A few links ###

* [MIT License (wikipedia)][mit]
* [GPL License (wikipedia)][gpl]
* [Why not to license software using Creative Commons][cc]
* [Benalman.com license page](http://benalman.com/about/license/)

Also, if you look at the [jQuery BBQ GitHub project page](http://github.com/cowboy/jquery-bbq) you can see the included [LICENSE-MIT](http://github.com/cowboy/jquery-bbq/blob/master/LICENSE-MIT) and [LICENSE-GPL](http://github.com/cowboy/jquery-bbq/blob/master/LICENSE-GPL) files as well as the comment header at the top of the [jquery.ba-bbq.js](http://github.com/cowboy/jquery-bbq/blob/master/jquery.ba-bbq.js) and [jquery.ba-bbq.min.js](http://github.com/cowboy/jquery-bbq/blob/master/jquery.ba-bbq.min.js) source code files. I follow this example in all of my open source projects, and suggest you do something similar.

Have any feedback or suggestions? Please let me know in the comments, thanks! And if you'd like to support the hard work I put into this open source software, don't be afraid to [donate now](http://benalman.com/donate).

[mit]: http://en.wikipedia.org/wiki/MIT_License
[gpl]: http://en.wikipedia.org/wiki/GNU_General_Public_License
[cc]: http://wiki.creativecommons.org/FFAQ#Can_I_license_software_using_CC_licenses.3F

[drupal]: http://drupal.org/
[jquery]: http://jquery.com/
[bbq]: http://benalman.com/projects/jquery-bbq-plugin/

