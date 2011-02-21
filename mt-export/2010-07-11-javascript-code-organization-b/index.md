title: "JavaScript Code Organization Basics"
categories: [ Code, News ]
tags: [ @hidden, @nonav, @nosearch, code, javascript, organization ]
date: 2010-07-11 23:00:40 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

As a JavaScript developer, you'll find that there are a great many ways to organize your code. This article deals specifically with creating "modules" that ...

## Been there, done that ##

First of all, just because your code exists in different .js files or `<script>` blocks doesn't mean that your variables or functions are isolated from those in any other file or `<script>` block. Every line of JavaScript executed in any of these areas does so in the same top-level, global, scope, and as such can conflict with any other line of code in that scope. The only real "rule" is that scripts are executed in order of inclusion in the page, and that later scripts' variables and functions can override those defined previously.

Consider your code. The more of _your_ code that exists in the global scope, the more likely there is to be a conflict with _other_ code. Because everything that exists in the global scope is freely accessible, there's absolutely no concept of privacy, as all your
variables and functions are accessible everywhere. This can lead to serious issues down the road when it comes to testing your code, because you don't _really_ know what's changing what. Even routine maintenance becomes a hassle, because you can't always know what the implications of modifying code are. For example, even though you're _pretty sure_ nothing else is using this variable or that function, you can't be 100% positive, because it _is_ possible.

Also, minification options are severely limited when declaring everything in the global scope, because minification needs a closure to work properly (more on closures in a minute).

## A simple example ##

Let's take this example code, which is fairly straightforward. There's a generic `pluralize` function that returns a string of text in singular or plural form based on the number input, a `setThings` method that stores an "internal" value after first ensuring it is greater than 0, and a `getThings` method that returns a string of text representing how many "things" have been stored.

<pre class="brush:js">
var things = 0;

function pluralize( num, text ) {
  return text + ( num === 1 ? '' : 's' );
};

function setThings( val ) {
  things = Math.max( val, 0 );
};

function getThings() {
  var plural = pluralize( things, ' thing' );
  return 'You have ' + things + plural + '.';
};

setThings( 1 );
getThings();    // returns 'You have 1 thing.'
</pre>

This code is organized in a very naïve fashion, ie. _not at all_. Because the variable and functions are defined in the global scope, any other script can modify or overwrite them (or they could overwrite those in other earlier-included scripts). Another bit of code could set `things` directly, to a negative number, which is something we don't want. This code doesn't play well with others.

Ok, so in order to avoid naming collisions, the variable and function names can be modified or obfuscated. "What are the chances that some other JavaScript on this page is going to contain a variable called `myuniqueprefix_things` or a function called `myuniqueprefix_pluralize`," right?

<pre class="brush:js">
var cowboy_things = 0;

function cowboy_pluralize( num, text ) {
  return text + ( num === 1 ? '' : 's' );
};

function cowboy_setThings( val ) {
  cowboy_things = Math.max( val, 0 );
};

function cowboy_getThings() {
  var plural = cowboy_pluralize( cowboy_things, ' thing' );
  return 'You have ' + cowboy_things + plural + '.';
};

cowboy_setThings( 1 );
cowboy_getThings();     // returns 'You have 1 thing.'
</pre>

Sure, that's a reasonable argument, and code like this exists all over the web... but now all your variable and function names are harder to read, taking up more space, making lines longer and now everything seems messy. And we still haven't addressed the "no privacy whatsoever" or "minification is far from optimal" issues.

## An Object Literal Singleton ##

You can effectively "namespace" your code using an Object literal. This way,
there's only one global variable that can potentially conflict with other
variables, the names are very clear, and the code is very organized.

In this case, if the global variable name conflicts with something else, you
can just rename it to something else. Notice how, internally, `this` is used
to reference the main object? Since the cowboy namespace is never referenced
internally, that namespace can be renamed at will.

Still, there are those annoying "no privacy" and "less-than-optimal
minification" issues.

<pre class="brush:js">
var cowboy = {
  things: 0,
  pluralize: function( num, text ) {
    return text + ( num === 1 ? '' : 's' );
  },
  setThings: function( val ) {
    this.things = Math.max( val, 0 );
  },
  getThings: function() {
    var plural = this.pluralize( this.things, ' thing' );
    return 'You have ' + this.things + plural + '.';
  }
};

cowboy.setThings( 1 );
cowboy.getThings();     // returns 'You have 1 thing.'
</pre>

If you don't like defining all your properties or methods in an Object
literal, you can first create the object, and then define each property and
method individually, or meet somewhere in-between. It's a matter of personal
preference.

Defining methods and properties individually results in less indentation and
allows property and method names to be set dynamically using ['name'] instead
of .name syntax, but it can result in larger code when minified. For example:

var a={b:1};    // Object literal.
var a={};a.b=1; // Individual definition.

<pre class="brush:js">
var cowboy = {};

cowboy.things = 0;

cowboy.pluralize = function( num, text ) {
  return text + ( num === 1 ? '' : 's' );
};

cowboy.setThings = function( val ) {
  this.things = Math.max( val, 0 );
};

cowboy.getThings = function() {
  var plural = this.pluralize( this.things, ' thing' )
  return 'You have ' + this.things + plural + '.';
};

cowboy.setThings( 1 );
cowboy.getThings();     // returns 'You have 1 thing.'
</pre>

Since we're talking about jQuery plugins, we could just add our plugin's
properties and methods into the jQuery namespace.

We can't just set `jQuery = { ... };` because it will completely overwrite
jQuery's own properties and methods, but we can use jQuery's "extend" method
to merge our new Object literal into the existing jQuery object (overriding
any existing properties or methods with the specified values) or define
the properties and methods individually.

Of course, when Alex Sexton says, "The jQuery Namespace is the new Global
Namespace," he brings up a very valid point. Just like in the global scope,
if clutter up the jQuery namespace, names will eventually collide. It's going
to get messy. For example, this creates:

jQuery.things
jQuery.pluralize
jQuery.setThings
jQuery.getThings

<pre class="brush:js">
jQuery.extend({
  things: 0,
  pluralize: function( num, text ) {
    return text + ( num === 1 ? '' : 's' );
  },
  setThings: function( val ) {
    jQuery.things = Math.max( val, 0 );
  },
  getThings: function() {
    var plural = jQuery.pluralize( jQuery.things, ' thing' );
    return 'You have ' + jQuery.things + plural + '.';
  }
});

jQuery.setThings( 1 );
jQuery.getThings();     // returns 'You have 1 thing.'
</pre>

## How I Learned to Stop Worrying and Love the Closure ##

Up until now, each example has suffered from a few major issues. While we
were able to un-clutter the global scope by creating our variables and
functions as properties and methods of a single object, minifiers like YUI
Compressor or Google Closure Compiler can't work optimially because they are
limited by the lack of a parent closure.

Also, up until now, every property and method has been available publicly.
For example, while we have two useful methods, `setThings` and `getThings`,
we probably don't want `things` to be public. After all, if someone ignores
our getter and setter methods, they also ignore any validation logic we've
put in place to sanitize the data. Also, `pluralize` is really just a helper
method, and should also probably not be available publicly.

By using a closure, a scope is created in which local (aka private) variables
and functions can be defined, so they're usable by your code, but only your
code. They're not available outside of that scope.

Any function, when executed, creates a closure. In the following, both
`foo` and `bar` have access to get and set `a`, but since `a` is explicitly
declared in `bar`, it becomes local to that closure and doesn't affect the
`a` defined outside.

<pre class="brush:js">
var a = 1;

function foo() {
  a = 2;
};

function bar() {
  var a = 3;
};

alert( a ); // alerts 1.
foo();
alert( a ); // alerts 2.
bar();
alert( a ); // alerts 2.
</pre>

All the code that was just executed can be placed inside a function, or
closure, and executed. Notice how, inside the `everything` function,
everything works exactly like before.. but outside that function, nothing
is accessible.

By using a function, you can create "private" properties and methods (`a`,
`foo` and `bar`) that are not available outside the closure.

This is how YUI Compressor and Google Closure Compiler work: they know that
since declared variables and functions defined inside a closure can't be
accessed outside that closure, those variable and function names can just be
replaced by much shorter names. For example, every instance of `foo` inside
`everything` could be changed to `b` and every instance of `bar` could be
changed to `c`. This, along with reducing whitespace and unnecessary
punctuation, can add up to a huge size savings.

<pre class="brush:js">
function everything() {
  var a = 1;

  function foo() {
    a = 2;
  };

  function bar() {
    var a = 3;
  };
  
  alert( a ); // alerts 1.
  foo();
  alert( a ); // alerts 2.
  bar();
  alert( a ); // alerts 2.
};

everything(); // alerts 1, then 2, then 2.

alert( a );   // ReferenceError: a is not defined.
foo();        // ReferenceError: foo is not defined.
</pre>

Of course, the new problem is that while we have a closure that makes all the
variables and functions defined therein private, *too much* is now private!

In this example, there is no way to access the `setThings` and `getThings`
methods, because they are "trapped" in the closure.

<pre class="brush:js">
function cowboy() {
  var things = 0;

  function pluralize( num, text ) {
    return text + ( num === 1 ? '' : 's' );
  };

  function setThings( val ) {
    things = Math.max( val, 0 );
  };

  function getThings() {
    var plural = pluralize( things, ' thing' );
    return 'You have ' + things + plural + '.';
  };
};

cowboy();

setThings( 1 ); // ReferenceError: setThings is not defined.
getThings();    // ReferenceError: getThings is not defined.
</pre>

Of course, since functions can return values, if we return an object that
contains only the properties and methods that we want to be public, you
end up with a pattern that supports both private and public properties and
methods. Because all public methods returned by the closure function are
defined inside that function, they also have access to all private variables
and functions defined inside that function.

This is generally called the "Module" pattern, and is described on page 40 of
Douglas Crockford's book, "JavaScript: The Good Parts" (a book which everyone
should have).

<pre class="brush:js">
function return_cowboy() {
  var things = 0;

  function pluralize( num, text ) {
    return text + ( num === 1 ? '' : 's' );
  };

  return {
    setThings: function( val ) {
      things = Math.max( val, 0 );
    },
    getThings: function() {
      var plural = pluralize( things, ' thing' );
      return 'You have ' + things + plural + '.';
    }
  };
};

var cowboy = return_cowboy();

cowboy.setThings( 1 );
cowboy.getThings();     // returns 'You have 1 thing.'
</pre>

If you take the module pattern one step further, invoking an anonymous
closure function immediately (instead of naming that function, then calling
it separately), you can remove yet another global reference. Here, the
`return_cowboy` function name is removed, leaving just `cowboy` in the global
scope.

Also notice that in this example, instead of returning an Object literal,
an internal `self` object is returned, with all public properties and methods
being defined on that object. In the case where a public method or property
needs to be referenced internally, there's no way to do so unless it has a
name.

This is a good example of a non-jQuery, "general JavaScript" singleton
pattern. Keep in mind, of course, that if you were creating many instances
of this, you would waste a fair amount of memory defining every method
explicitly every time, instead of using a more efficient function constructor
and prototyped methods.

<pre class="brush:js">
var cowboy = (function(){
  var things = 0,
    self = {};
  
  function pluralize( num, text ) {
    return text + ( num === 1 ? '' : 's' );
  };
  
  self.setThings = function( val ) {
    things = Math.max( val, 0 );
  };
  
  self.getThings = function() {
    var plural = pluralize( things, ' thing' );
    return 'You have ' + things + plural + '.';
  };
  
  return self;
})();

cowboy.setThings( 1 );
cowboy.getThings();     // returns 'You have 1 thing.'
</pre>


<pre class="brush:js">

</pre>


<pre class="brush:js">

</pre>


<pre class="brush:js">

</pre>
