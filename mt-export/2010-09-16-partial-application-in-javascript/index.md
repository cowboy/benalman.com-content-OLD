title: "Partial application in JavaScript?"
categories: [ Code, News ]
tags: [ curry, dysfunctional, functional, javascript, pattern ]
date: 2010-09-16 22:58:39 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've been learning more about functional programming lately, and after seeing a few [interesting](http://gist.github.com/576723) [things](http://jsfiddle.net/t8cAK/2/) on the interwebs, I decided to spend a little more time experimenting with [partial application](http://en.wikipedia.org/wiki/Partial_application) in JavaScript.

Now, I'm far from an expert in functional programming. What I've done here seems strange and exciting to me, and I have absolutely no idea how I would use it, or even what it's called.

Is this partial application? Currying? Something else? (Vindaloo maybe?)

_[Edit: I now know what this is called, thanks to some very helpful comments. It was explained to me that I had reversed the concepts of "partial" and "curry," so I've updated my explanations and examples to be more accurate.]_


<!--MORE-->

## The new ###

In the following code sample, invoking the curried function will always return a function until _all_ arguments are satisfied, at which point the original function is invoked, returning its result. This means that all function arguments are required, which also allows the function to be called either like `foo( 1, 2, 3 )` or `foo( 1 )( 2 )( 3 )`. This also means that if any argument is omitted, the original function is never invoked.

_(Note that I'm not doing anything smart here with execution context)_

<pre class="brush:js">
function curry( orig_func ) {
  var ap = Array.prototype,
    args = arguments;
  
  function fn() {
    ap.push.apply( fn.args, arguments );
    
    return fn.args.length < orig_func.length
      ? fn
      : orig_func.apply( this, fn.args );
  };
  
  return function() {
    fn.args = ap.slice.call( args, 1 );
    return fn.apply( this, arguments );
  };
};

var i = 0;
function a( x, y, z ) {
  console.log( ++i + ': ' + x + ' and ' + y + ' or ' + z );
};

a( 'x', 'y', 'z' );     // "1: x and y or z"

var b = curry( a );
b();                    // nothing logged, `a` not invoked
b( 'x' );               // nothing logged, `a` not invoked
b( 'x', 'y' );          // nothing logged, `a` not invoked
b( 'x' )( 'y' );        // nothing logged, `a` not invoked
b( 'x' )( 'y' )( 'z' ); // "2: x and y or z"
b( 'x', 'y', 'z' );     // "3: x and y or z"

var c = curry( a, 'x' );
c();                    // nothing logged, `a` not invoked
c( 'y' );               // nothing logged, `a` not invoked
c( 'y', 'z' );          // "4: x and y or z"
c( 'y' )( 'z' );        // "5: x and y or z"

var d = curry( c, 'y' );
d();                    // nothing logged, `c` not invoked
d( 'z' );               // "6: x and y or z"

var e = curry( a, 'x', 'y' );
e();                    // nothing logged, `a` not invoked
e( 'z' );               // "7: x and y or z"

var f = curry( a, 'x', 'y', 'z' );
f();                    // "8: x and y or z"
</pre>

## The "knew" ##

Contrast that with this partial application approach (which I had incorrectly learned as "currying"). Invoking the partially applied function will _always_ invoke the original function, and if any arguments are omitted, they are simply undefined. This allows for any number of arguments, but must be called like `foo( 1, 2, 3 )` and not `foo( 1 )( 2 )( 3 )`.

<pre class="brush:js">
function partial( orig_func ) {
  var aps = Array.prototype.slice,
    args = aps.call( arguments, 1 );
  
  return function() {
    return orig_func.apply( this, args.concat( aps.call( arguments ) ) );
  };
};

var j = 0;
function m( x, y, z ) {
  console.log( ++j + ': ' + x + ' and ' + y + ' or ' + z );
};

m( 'x', 'y', 'z' );     // "1: x and y or z"

var n = partial( m );
n();                    // "2: undefined and undefined or undefined"
n( 'x' );               // "3: x and undefined or undefined"
n( 'x', 'y' );          // "4: x and y or undefined"
n( 'x', 'y', 'z' );     // "5: x and y or z"

var o = partial( m, 'x' );
o();                    // "6: x and undefined or undefined"
o( 'y' );               // "7: x and y or undefined"
o( 'y', 'z' );          // "8: x and y or z"

var p = partial( o, 'y' );
p();                    // "9: x and y or undefined"
p( 'z' );               // "10: x and y or z"

var q = partial( m, 'x', 'y' );
q();                    // "11: x and y or undefined"
q( 'z' );               // "12: x and y or z"
</pre>

## Questions, questions ##

I'd only ever seen partial application done like in the above `partial` function until recently, but a strange and confusing new world has been opened up to me here.. so, that being said, while the `curry` pattern is interesting, can I do anything useful with it?

_If you're curious, I have a [gist you can fork](http://gist.github.com/583102) as well._


