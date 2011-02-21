title: "Organ1k, my JS1k contest entry"
categories: [ Code, News ]
tags: [ 1024, 1k, javascript, minification ]
date: 2010-08-04 14:26:11 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Recently, word came through the twitter-nets that [JS1k](http://js1k.com/), a 1 kilobyte JavaScript competition, was accepting entries. Now, I haven't done anything "fancy" in a while, but I used to do that kind of [stuff](http://cowboyscripts.org/flash/diamond2.html) [all][orig] [the](http://benalman.com/portfolio/flash-3d-engine/) [time](http://benalman.com/portfolio/website-personal-cowboy-v4/) (you know, before I was married).

So I asked myself, "Ben, can you do something _extra_ fancy in exactly 1024 bytes of JavaScript?"

[orig]: http://benalman.com/portfolio/javascript-simple-dhtml-mouse-trails/

<!--MORE-->

I should mention that I've wanted to revisit my 2004 [DHTML mouse trails][orig] JavaScript (written back before I really had any idea what I was doing) for a long time, using the HTML5 `canvas` element. At one point, I looked at [Processing.js](http://processingjs.org/), but at the time I just couldn't wrap my head around it.

So, last night I sat down, cracked open my [old source code](view-source:http://benalman.com/code/javascript/mousetrails/4.html) (horrible), and started coding... and a few hours later, my code had evolved into [Organ1k][demo], an exactly-1024-byte HTML5 canvas-based demo inspired by my original DHTML mouse trails script.

**In case you missed the link to the actual demo, it's [Organ1k][demo].**

Of course, while the resemblance to the original (version 4, specifically) should be obvious, I've taken the opportunity to do a lot of the things that were simply not possible at the time, and I'm pleased with the result.

While Organ1k has been tested in Firefox 3.6, Safari 5.0, Chrome 5, Opera 10.60 and IE9 test build 4, it's a bit slow in Firefox, so I'd recommend against that. Still, it should be relatively zippy in all of them (provided you have a modern computer, of course).

_Edit: Organ1k has been accepted and is now listed at the [JS1k demos page](http://js1k.com/demos), so check it out now. And while you're there, be sure to take some time to check out all the other amazing entries!_

### A few words on minification for the JavaScript savvy ###

First, please realize that I'm not at all advocating using minification techniques like these under normal development conditions, because they make your code a totally unmaintainable mess. If that last sentence confused you, read the "Avoid premature optimization" section of my article [Style in jQuery Plugins and Why it Matters](http://msdn.microsoft.com/en-us/scriptjunkie/ff696759.aspx).

That being said, if you want to see a whole bunch of absolutely silly, over-the top byte-saving optimizations, feel free to view the [unminified source on GitHub][github], where I have full documented and commented (with examples) all the different things I did. Just in case you were curious, my goal was not to make it as small as possible, but to make it exactly 1024 bytes... which was especially difficult whenever I went _below_ the limit and have to un-minify my code.

Also, since developing something that meets requirements like these is an _extremely_ iterative process, it's not a bad idea to create a build script of some sort that can help streamline the whole "minify + remove unnecessary code + measure final size + test in browser" process.

These are some of the byte-saving techniques that I used:

 * vars declared as function arguments (avoids 4 chars lost to the `var` keyword plus trailing space)
 * splitting a string into an array, saving 2 bytes (from quotes) because it was joined with a number, eg. `'a1b1c'.split(1)`
 * using minifiable references to anything that gets reused, eg. `document`, `setInterval`, `Math`, `Math.PI`, `pi_over_180`, etc
 * initializing multiple variables/properties in a single statement, eg. `a = b.c = 0`
 * assigning variables as function arguments or in conditionals, eg. `if ( a = 1 ) { ... }`
 * using ternary conditionals instead of `if` / `else` blocks, eg. ` a < 1 ? b = 1 : a < 2 ? c = 2 : d = 3`
 * decrement loops instead of increment loops where possible
 * using `~~` instead of `Math.floor`
 * using hard-coded values instead of `my_array.length` (this can get scary without good comments)
 * closure + vars explicitly declared to help YUI minifier, then stripped from the minified output _(no longer necessary!)_
 * referring to `window` as `this` _(no longer necessary, thanks Remy!)_

Again, read more about these techniques in the [unminified source on GitHub][github].

Have any feedback? Let me know in the comments, thanks!

[demo]: http://benalman.com/code/projects/js1k-organ1k/organ1k.html
[orig]: http://benalman.com/portfolio/javascript-simple-dhtml-mouse-trails/
[github]: http://github.com/cowboy/js1k-organ1k

