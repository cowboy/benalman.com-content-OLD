title: "jQuery iff: A chainable \"if\" statement"
categories: [ Projects, jQuery ]
tags: [ javascript, jquery, plugin ]
date: 2009-06-01 09:03:05 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This relatively simple and very small [jQuery](http://jquery.com/) plugin gives you the functionality and power of a standard JavaScript "if" statement, without breaking the chain. In one way, iff operates like `.filter()`, in that it allows you to conditionally process a subset of selected elements, but instead of allowing you to preserve or remove individual elements, it operates on the entire set of elements.

<!--MORE-->

* Release v0.2
* Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 3, Safari 3-4, Chrome.
* Download [Source](http://benalman.com/code/javascript/jquery/jquery.ba-iff.js),
[Minified](http://benalman.com/code/javascript/jquery/jquery.ba-iff.min.js) (368 bytes)
* View [Unit Tests](http://benalman.com/code/unittest/iff.html)

This code:

<pre class="brush:js">
function my_test( x ) {
  return x === 'bar';
};

var elem = $('div');
elem.append( '1' );
if ( my_test( 'foo' ) ) {
  elem.append( '2' );
}
elem.append( '3' );
</pre>

Can be written as this, using iff:

<pre class="brush:js">
function my_test( x ) {
  return x === 'bar';
};

$('div')
  .append( '1' )
  .iff( my_test, 'foo' )
    .append( '2' )
    .end()
  .append( '3' );
</pre>

In each example, `'2'` is not appended between `'1'` and `'3'` because the my_test function call returns false.

If the argument passed to iff is `true`, or is a function that, when invoked, returns `true`, all selected elements are passed through. Otherwise, all elements will be removed, and an empty jQuery object will be passed through. If a function reference is passed, any following arguments will be passed to that function.

Inside the callback, `this` refers to the jQuery collection of elements. Note that iff is considered a 'destructive' traversing operation, and can be reverted with `.end()`, even if no elements were removed.

Here's another example, this time inside of a fictional `$.getJSON()` callback:

<pre class="brush:js">
function my_callback( data ) {
  $('&lt;div/&gt;')
    .iff( data.success )
      .append( '&lt;img src="' + data.src + '"/&gt;' )
      .end()
    .iff( data.error )
      .append( 'An error has occurred.' )
      .addClass( 'error' )
      .end()
    .appendTo( 'body' );
};
</pre>

As a bonus, iff can be used to execute any arbitrary function without breaking the chain, much like [Paul Irish's doOnce plugin](http://paulirish.com/2008/jquery-doonce-plugin-for-chaining-addicts/), just make sure to either return `true` or use `.end()` afterwards (here, I do both). For example:

<pre class="brush:js">
function my_alert() {
  alert( 'I am temporarily interrupting things!' );
  return true;
};

$('div')
  .append( 'hello' )
  .iff( my_alert ).end()
  .append( ' world' );
</pre>

In this example, `'hello'` is appended immediately, while `' world'` is only appended after the user dismisses the alert box.

## Notes ##

* I have considered an "else" complement to iff, but it seems like all the possible solutions for this would either require awkward or inconsistent `.end()` usage, and would complicate or confuse the value of the `.selector` property. If you have an elegant solution to this, please let me know!
* Keep in mind that even `elems.iff( false ).method();` will still execute `method`, but on an empty set. Even though it's not modifying any elements, there is some _slight_ overhead.. so you'll need to decide what's more important for you, convenience or performance.

_Thanks to [Paul Irish](http://paulirish.com/) and [Adam Sontag](http://ajpiano.com/) for their help with the API and examples._

