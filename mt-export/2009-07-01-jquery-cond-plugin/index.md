title: "jQuery cond: A chainable \"if-then-else\" statement"
categories: [ Projects, jQuery ]
tags: [ javascript, jquery, plugin ]
date: 2009-07-01 22:15:38 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Like my [iff plugin](http://benalman.com/projects/jquery-iff-plugin/), this small [jQuery](http://jquery.com/) plugin gives you the ability to perform conditional logic without breaking the chain, but in addition to `if`, allows for any number of `else if` tests and callbacks, as well as a final `else` callback.

<!--MORE-->

The cond plugin was patterned after the Lisp `cond` operator, which was basically the precursor to the if-then-else control structure. This pattern was suggested by Stephen Band and DBJDBJ as an elegant solution to the "if-then-else, without breaking the chain" dilemma presented in [this jquery-dev thread][jqd], which I further refined (with some healthy back-and-forth) before coming up with the version offered here.

  [jqd]: http://groups.google.com/group/jquery-dev/browse_thread/thread/6e31ae96b2238375

 * Release v0.1
 * Tested with jQuery 1.3.2 in Internet Explorer 6-8, Firefox 3, Safari 3-4, Chrome.
 * Download [Source](http://benalman.com/code/javascript/jquery/jquery.ba-cond.js), [Minified](http://benalman.com/code/javascript/jquery/jquery.ba-cond.min.js) (521 bytes)
 * View [Unit Tests](http://benalman.com/code/unittest/cond.html)

## Usage ##

It's pretty basic:

<pre class="brush:js">
$('selector').cond( [test, callback, ... ] [, callback ] );
</pre>

For each test-callback pair, if test is a function reference, that function is invoked and the value it returns is evaluated. If test is not a function reference, its value is evaluated. If that value is [truthy](http://www.isolani.co.uk/blog/javascript/TruthyFalsyAndTypeCasting), callback is invoked, after which processing ends.. otherwise the next test-callback pair is processed. If all test arguments evaluate to false, and the very last argument is a solitary callback, that callback will be executed.

_Phew, that was a lot to read! In simple terms, "if test, then callback, else if test, then callback, (etc), else callback."_

## Notes ##

* Inside both test (if test is a function) and callback, `this` refers to the jQuery collection of elements. Also, if test is truthy, its evaluated value is passed into callback as its only argument. 
* If the executed callback returns a value, that value will be returned by .cond, thus modifying the chain. This action cannot be undone with `.end()`.

## Examples ##

Using cond, this code will first set the color of all links to blue, then append "!" to them. If `x` was set to anything else, the links would be colored red instead (and "!" would still be appended).

<pre class="brush:js">
var x = 1;

$('a') 
  .cond( 
    x === 1, function(){
      this.css({ color: 'blue' });
    },
    function(){
      this.css({ color: 'red' });
    }
  )
  .append( '!' ); 
</pre>

In the next example, the first test-callback pair is skipped, because `x === 1` evaluates to `false`. Since `my_test` is a function, it is invoked, returning `'olive'` (which is truthy). That pair's callback is invoked, the links are colored olive, and "!" gets appended.. _but only to the first link_, because the callback returned a value: `this.eq(0)`.

If `x` was `2`, all links would be colored green, with "!" appended, and if `x` was `'bunnies in teacups'`, all links would be colored red, with "!" appended.

<pre class="brush:js">
var x = 3;

function my_test() { 
  return x === 2 ? 'green'
    : x === 3 ? 'olive'
    : false;
};

$('a') 
  .cond( 
    x === 1, function(){
      this.css({ color: 'blue' });
    },
    my_test, function( val ){
      this.css({ color: val });
      return this.eq(0);
    },
    function(){
      this.css({ color: 'red' });
    }
  )
  .append( '!' ); 
</pre>

Just like [iff](http://benalman.com/projects/jquery-iff-plugin/), cond can be used to execute any arbitrary function without breaking the chain, much like [Paul Irish's doOnce plugin](http://paulirish.com/2008/jquery-doonce-plugin-for-chaining-addicts/), and since it doesn't destructively modify the jQuery object, you don't need to worry about returning `true` or using `.end()` afterwards.

<pre class="brush:js">
function my_alert() {
  alert( 'I am temporarily interrupting things!' );
};

$('div')
  .append( 'hello' )
  .cond( my_alert )
  .append( ' world' );
</pre>

In this example, `'hello'` is appended immediately, while `' world'` is only appended after the user dismisses the alert box.

_Ultimately, it seems like a generalized `run` method (see the conclusion of the [jquery-dev thread][jqd]) might be better than this, at least in terms of inclusion in jQuery core. Regardless, I've published this code for general consumption. Feel free to let me know if and how you use it, thanks!_

