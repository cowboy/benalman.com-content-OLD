title: "The Mysterious Firefox setTimeout \"Lateness\" argument™"
categories: [ Code, Geek, News ]
tags: [ bug, firefox, javascript, setTimeout, wtf ]
date: 2009-07-15 06:20:24 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

So I was updating my [doTimeout](http://benalman.com/projects/jquery-dotimeout-plugin/) plugin last night, and I was running into this really odd issue. It seems that in Firefox, and only Firefox, the callback I was passing into a setTimeout call was being invoked with an extra argument, and better yet - this argument was a seemingly random integer. Usually zero, but often positive or negative. Well, apparently this is by design.

<!--MORE-->

### The problem ###

Let's say we have a situation like this: I'm setting up a polling loop that I want to be able to easily cancel by calling my loop's `do_loop` function with an optional `cancel` argument.

<pre class="brush:js">
// Define the polling loop.
var id, delay = 100;

function do_loop( cancel ) {
  console.log( cancel );
  if ( cancel ) {
    clearTimeout( id );
  } else {
    id = setTimeout( do_loop, delay );
  }
};

// Start polling.
do_loop();

// At some arbitrary point (later on) cancel polling like this.
do_loop( true );
</pre>

Well, I did this, and found that the loop would self-cancel, randomly, in Firefox. But how can this be? I haven't called `do_loop(true)` manually, so is some kind of `cancel` argument getting passed into `do_loop()`? But how, and why? After all, I'd never consider passing additional arguments into a `setTimeout` callback, because IE doesn't treat those arguments consistently. Well, it turns out, Firefox isn't consistent either.

If you look at the [MDC window.setTimeout documentation](https://developer.mozilla.org/en/window.setTimeout), there, in the notes at the very bottom is the text _"Functions invoked by setTimeout are passed an extra "lateness" argument in Mozilla, i.e., the lateness of the timeout in milliseconds."_. No, this text is not up in the top, where they mention _"Note that passing additional parameters to the function in the first syntax does not work in Internet Explorer."_ - it's in a totally separate, and completely missable area (so completely missable that I didn't even see it, even after reading that page, until temp01 pointed it out to me).

### The fix ###

There are many ways to go about this, of course, this is the way I'm handling it:

<pre class="brush:js">
// Define the polling loop.
var id, delay = 100;

function do_loop( cancel ) {
  console.log( cancel );
  if ( cancel ) {
    clearTimeout( id );
  } else {
    id = setTimeout( function(){ do_loop(); }, delay ); // Ugly
  }
};

// Start polling.
do_loop();

// At some arbitrary point (later on) cancel polling like this.
do_loop( true );
</pre>

### The rant ###

Come on guys, it's a **great** idea but confusing and inconsistent.. and if someone tried to develop polling code in another browser, their code would be broken in yours!

### The epilogue ###

When I initially looked at what turned out to be the _Mysterious Firefox setTimeout "Lateness" argument™_, my first instinct told me that it represented some kind of latency, since it was most often 0 with a few 1 values here or there, but as I ran more tests, I discounted that when I started seeing negative numbers. After all, would you ever expect a setTimeout to execute its callback early?

