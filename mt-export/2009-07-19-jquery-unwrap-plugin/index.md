title: "jQuery unwrap: The opposite of .wrap, pretty much "
categories: [ Projects, jQuery ]
tags: [ javascript, jquery, plugin ]
date: 2009-07-19 06:29:38 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This very basic [jQuery](http://jquery.com/) plugin does exactly what you'd think: the selected elements are unwrapped, removing their parent element, which effectively "promotes" them (and their siblings).

<!--MORE-->

<p class="warn">
  As of jQuery 1.4, this method is now included in jQuery core! See the <a href="http://github.com/jquery/jquery/commit/69e6e53555f21f07b534f1169298f7b33011bb4b">patch</a> as well as the <a href="http://api.jquery.com/unwrap/">official .unwrap documentation</a>.
</p>

* Release v0.2
* Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 3, Safari 3-4, Chrome, Opera 9.
* Download [Source](http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-unwrap.js),
[Minified](http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-unwrap.min.js) (0.3kb)
* View [Unit Tests](http://benalman.com/code/unittest/unwrap.html)
* View [Example][example]

  [example]: http://benalman.com/code/test/jquery-unwrap/

This plugin is so simple that it really needs no explanation, just look at the [example][example] to see it in action. I will, however, use this space to explain how I got to this point, in case you're curious.

## Too naive ##

Originally, my unwrap method was very simple, very elegant, and very broken:

<pre class="brush:js">
$.fn.unwrap = function() {
  return this.each(function(){
    $(this).parent().replaceWith( this );
  });
};
</pre>

If you do a web search for "jQuery unwrap plugin", you'll find a few snippets of code that look almost exactly like that. The code looks clean and makes sense, _"for each element, replace its parent with itself,"_ which works great until you realize that you've been losing sibling elements here and there.

## Oops? ##

So, what we really want is _"for each element, replace its parent with itself AND its siblings."_ Here's the literal interpretation of that pseudocode:

<pre class="brush:js">
$.fn.unwrap = function() {
  return this.each(function(){
    var that = $(this);
    that.parent().replaceWith( that.add( that.siblings ) );
  });
};
</pre>

Ok, not so good. I guess _"for each element, replace its parent with itself AND its siblings."_ isn't quite what we want, since the child nodes are now out of order, because of the way they were selected. And even if the child nodes were selected in the correct order, what if we try to unwrap multiple sibling elements together?

Unwrapping the first element would replace its parent with itself and its siblings, which is great.. but wait, now unwrapping the second sibling element would replace the NEW parent with itself and its siblings.. which is a total mess, and not at all what we want. We need to figure out a better way!

## Eureka! ##

The issue here is the parents. Unwrap only ought to do the "replace parent with its children" part once per parent.. So, let's try _"for each unique element's parent, replace that parent with its children."_ Fortunately, this is very easy to do, and the resulting code is the core of my unwrap plugin:

<pre class="brush:js">
$.fn.unwrap = function() {
  this.parent(':not(body)')
    .each(function(){
      $(this).replaceWith( this.childNodes );
    });
  
  return this;
};
</pre>

Note: the `':not(body)'` selector keeps the user from trying to unwrap children of the body tag, which would end up deleting the body tag and make a mess of things. I'm sure that _you_ wouldn't do this, of course, I'm providing it just in case someone else does (I actually initially had `.parent(':not(html,head,body)').not(document)` but it seemed like total overkill).

_Thanks to nlogax for pointing out that `.parent()` returns a unique list of parent elements, which allowed me to remove a lot of unnecessary `$.unique()` code!_

