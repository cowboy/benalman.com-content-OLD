title: "Immediately-Invoked Function Expression (IIFE)"
categories: [ Code, News ]
tags: [ anonymous, expression, function, iife, invoked, javascript, module pattern ]
date: 2010-11-15 16:33:27 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

In case you hadn't noticed, I'm a bit of a stickler for terminology. So, after hearing the popular, yet misleading, JavaScript term "self-executing anonymous function" (or self-invoked anonymous function) one too many times, I've finally decided to organize my thoughts into an article.

In addition to providing some very thorough information about how this pattern actually works, I've actually made a recommendation on what we should call it, moving forward. Also, If you want to skip ahead, you can just check out some actual [Immediately-Invoked Function Expressions](http://benalman.com/news/2010/11/immediately-invoked-function-expression/#iife), but I recommend reading the entire article.

<!--MORE-->

<script>
var disqus_url = 'http://benalman.com/news/2010/11/self-executing-anonymous-function/';
</script>

Please understand that this article isn't intended to be an "I'm right, you're wrong" kind of thing. I'm genuinely interested in helping people understand potentially complex concepts, and feel that using consistent and accurate terminology is one of the easiest things that people can do to facilitate understanding.

## So, what's this all about, anyways?

In JavaScript, every [function](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function), when invoked, creates a new execution context. Because variables and functions defined within a function may only be accessed inside, but not outside, that context, invoking a function provides a very easy way to create privacy (this is also known as a closure).

<pre class="brush:js">
  // Because this function returns another function that has access to the
  // "private" var i, the returned function is, effectively, "privileged."

  function makeCounter() {
    // `i` is only accessible inside the closure created when the
    // `makeCounter` function is invoked.
    var i = 0;

    return function() {
      console.log( ++i );
    };
  }

  // Note that `counter` and `counter2` each have their own scoped `i`,
  // because the closure containing `i` is created when the function
  // `makeCounter` is invoked.

  var counter = makeCounter();
  counter(); // logs: 1
  counter(); // logs: 2

  var counter2 = makeCounter();
  counter2(); // logs: 1
  counter2(); // logs: 2

  i; // ReferenceError: i is not defined (it only exists inside the closures)
</pre>

In many cases, you won't need multiple "instances" of whatever your `makeWhatever` function returns, and can make do with just a single instance, and in other cases, you're not even explicitly returning a value.

### The heart of the matter

Now, whether you define a function like `function foo(){}` or `var foo = function(){}`, what you end up with is an identifier for a function, that you can invoke by putting parens (parentheses, `()`) after it, like `foo()`.

<pre class="brush:js">
  // Because a function defined like so can be invoked by putting () after
  // the function name, like foo(), and because foo is just a reference to
  // the function expression `function() { /* code */ }`...

  var foo = function(){ /* code */ }

  // ...doesn't it stand to reason that the function expression itself can
  // be invoked, just by putting () after it?

  function(){ /* code */ }(); // SyntaxError: Unexpected token (
</pre>

As you can see, there's a catch. When the parser encounters the `function` keyword in the global scope or inside a function, it treats it as a [function declaration][mdc_declaration] (statement), and not as a [function expression][mdc_expression], by default. If you don't explicitly tell the parser to expect an expression, it sees what it thinks to be a _function declaration without a name_ and throws a [SyntaxError][mdc_syntaxerror] exception because function declarations require a name.

[mdc_declaration]: https://developer.mozilla.org/en/JavaScript/Reference/Statements/function
[mdc_expression]: https://developer.mozilla.org/en/JavaScript/Reference/Operators/Special/function
[mdc_syntaxerror]: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/SyntaxError

### An aside: functions, parens, and SyntaxErrors

Interestingly enough, if you were to specify a name for that function and put parens immediately after it, the parser would also throw a SyntaxError, but for a different reason. While parens placed after an expression indicate that the expression is a function to be invoked, parens placed after a statement are totally separate from the preceding statment, and are simply grouping operators.

<pre class="brush:js">
  // While this function declaration is now syntactically valid, it's still
  // a statement, and the following set of parens is invalid because grouping
  // operators need to contain an expression.

  function foo(){ /* code */ }(); // SyntaxError: Unexpected token )

  // Now, if you put an expression in the parens, no exception is thrown...
  // but the function isn't executed either, because this:

  function foo(){ /* code */ }( 1 );

  // Is equivalent to this:

  function foo(){ /* code */ }

  ( 1 );
</pre>

_You can read more about this in Dmitry A. Soshnikov's highly informative article, [ECMA-262-3 in detail. Chapter 5. Functions][grouping]._

<a name="iife"></a>
## Immediately-Invoked Function Expression (IIFE)

Fortunately, the SyntaxError "fix" is simple. The most widely accepted way to tell the parser to expect a function expression is just to wrap in in parens, because in JavaScript, parens can't contain statements. At this point, when the parser encounters the `function` keyword, it knows to parse it as a function expression and not a function declaration.

<pre class="brush:js">
  // Either of the following two patterns can be used to immediately invoke
  // a function expression, thus creating an anonymous closure with privacy.

  (function(){ /* code */ })(); // I've been using this one
  (function(){ /* code */ }()); // Crockford recommends this one

  // Because the point of the parens or coercing operators is to disambiguate
  // between function expressions and function declarations, they can be
  // omitted when the parser already expects an expression (but please see the
  // "important note" below).

  var i = function(){ return 10; }();
  true && function(){ /* code */ }();
  0, function(){ /* code */ }();

  // If you don't care about the return value, or the possibility of making
  // your code slightly harder to read, you can save a byte by just prefixing
  // the function with a unary operator.

  !function(){ /* code */ }();
  ~function(){ /* code */ }();
  -function(){ /* code */ }();
  +function(){ /* code */ }();

  // Here's another variation, from @kuvos - I'm not sure of the performance
  // implications, if any, of using the `new` keyword, but it works.
  // http://twitter.com/kuvos/status/18209252090847232

  new function(){ /* code */ }
  new function(){ /* code */ }() // Only need parens if passing arguments
</pre>

### An important note about those parens

In cases where the extra "disambiguation" parens surrounding the function expression are unnecessary (because the parser already expects an expression), it's still a good idea to use them when making an assignment, _as a matter of convention_.

Such parens typically indicate that the function expression will be immediately invoked, and the variable will contain the _result_ of the function, not the function itself. This can save someone reading your code the trouble of having to scroll down to the bottom of what might be a very long function expression to see if it has been invoked or not.

_As a rule of thumb, while writing unambiguous code might be technically necessary to keep the JavaScript parser from throwing SyntaxError exceptions, writing unambiguous code is also fairly necessary to keep other developers from throwing "WTFError" exceptions at you!_

<a name="closures"></a>
### Saving state with closures

Just like when arguments are passed when functions are invoked by their identifier, they may also be passed when invoking a function expression immediately. Because the closure that is created "locks in" the passed value(s), an **Immediately-Invoked Function Expression** can be used to effectively save state.

<pre class="brush:js">
  // This doesn't work like you might think, because the value of `i` never
  // gets locked in. Instead, every link, when clicked (well after the loop
  // has finished executing), alerts the total number of elements, because
  // that's what the value of `i` actually is at that point.

  var elems = document.getElementsByTagName( 'a' );

  for ( var i = 0; i < elems.length; i++ ) {

    elems[ i ].addEventListener( 'click', function(e){
      e.preventDefault();
      alert( 'I am link #' + i );
    }, 'false' );

  }

  // This works, because inside the IIFE closure, the value of `i` is locked
  // in as `lockedInIndex`. After the loop has finished executing, even though
  // the value of `i` is the total number of elements, inside the IIFE closure
  // the value of `lockedInIndex` is whatever the value passed into it (`i`)
  // was when the function expression was invoked, so when a link is clicked,
  // the correct value is alerted.

  var elems = document.getElementsByTagName( 'a' );

  for ( var i = 0; i < elems.length; i++ ) {

    (function( lockedInIndex ){

      elems[ i ].addEventListener( 'click', function(e){
        e.preventDefault();
        alert( 'I am link #' + lockedInIndex );
      }, 'false' );

    })( i );

  }

  // You could also use an IIFE like this to create a closure that encompasses
  // (and returns) only the click handler function, and not the entire
  // `addEventListener` assignment. Either way, while both examples lock in
  // the value using an IIFE, I find the previous example to be more readable.

  var elems = document.getElementsByTagName( 'a' );

  for ( var i = 0; i < elems.length; i++ ) {

    elems[ i ].addEventListener( 'click', (function( lockedInIndex ){
      return function(e){
        e.preventDefault();
        alert( 'I am link #' + lockedInIndex );
      };
    })( i ), 'false' );

  }
</pre>

_Note that in the last two examples, `lockedInIndex` could have just been called `i` without any issue, but using a differently named identifier as a function argument makes the concept significantly easier to explain._

One of the most advantageous side effects of Immediately-Invoked Function Expressions is that, because this unnamed, or anonymous, function expression is invoked immediately, without using an identifier, a closure can be created without polluting the current scope.

<a name="self-executing"></a>
### What's wrong with "Self-executing anonymous function?"

You've already seen it mentioned a few times, but in case it wasn't clear, I'm proposing the term "**Immediately-Invoked Function Expression**", and "**IIFE**" if you like acronyms. The pronunciation ["iffy"](http://www.forvo.com/word/iffy/) was suggested to me, and I like it, so let's go with that.

What is an **Immediately-Invoked Function Expression**? It's a [function expression][mdc_expression] that gets invoked immediately. Just like the name would lead you to believe.

I'd like to see JavaScript community members adopt the term **"Immediately-Invoked Function Expression"** and **"IIFE"** in their articles and presentations, because I feel it makes understanding this concept a little easier, and because the term "self-executing anonymous function" isn't really even accurate:

<pre class="brush:js">
  // This is a self-executing function. It's a function that executes (or
  // invokes) itself, recursively:

  function foo() { foo(); }

  // This is a self-executing anonymous function. Because it has no
  // identifier, it must use the  the `arguments.callee` property (which
  // specifies the currently executing function) to execute itself.

  var foo = function() { arguments.callee(); };

  // This *might* be a self-executing anonymous function, but only while the
  // `foo` identifier actually references it. If you were to change `foo` to
  // something else, you'd have a "used-to-self-execute" anonymous function.

  var foo = function() { foo(); };

  // Some people call this a "self-executing anonymous function" even though
  // it's not self-executing, because it doesn't invoke itself. It is
  // immediately invoked, however.

  (function(){ /* code */ })();

  // Adding an identifier to a function expression (thus creating a named
  // function expression) can be extremely helpful when debugging. Once named,
  // however, the function is no longer anonymous.

  (function foo(){ /* code */ })();

  // IIFEs can also be self-executing, although this is, perhaps, not the most
  // useful pattern.

  (function(){ arguments.callee(); })();
  (function foo(){ foo(); })();

  // One last thing to note: this will cause an error in BlackBerry 5, because
  // inside a named function expression, that name is undefined. Awesome, huh?

  (function foo(){ foo(); })();
</pre>

Hopefully these examples have made it clear that the term "self-executing" is somewhat misleading, because it's not the function that's executing _itself_, even though the function is being executed. Also, "anonymous" is unnecessarily specific, since an **Immediately Invoked Function Expression** can be either anonymous or named. And as for my preferring "invoked" over "executed," it's a simple matter of [alliteration](http://en.wikipedia.org/wiki/Alliteration); I think "**IIFE**" looks and sounds nicer than "IEFE."

So, that's it. That's my big idea.

_Fun fact: because `arguments.callee` is [deprecated in ECMAScript 5 strict mode](https://developer.mozilla.org/en/JavaScript/Strict_mode#Differences_in_functions) it's actually technically impossible to create a "self-executing anonymous function" in ECMAScript 5 strict mode._

### A final aside: The Module Pattern

While I'm invoking function expressions, I'd be remiss if I didn't at least _mention_ the Module Pattern. If you're not familiar with the Module Pattern in JavaScript, it's similar to my first example, but is implemented as a singleton (and generally with an Object being returned instead of a Function).

<pre class="brush:js">
  // Create an anonymous function expression that gets invoked immediately,
  // and assign its *return value* to a variable. This approach "cuts out the
  // middleman" of the named `makeWhatever` function reference.
  // 
  // As explained in the above "important note," even though parens are not
  // required around this function expression, they should still be used as a
  // matter of convention to help clarify that the variable is being set to
  // the function's *result* and not the function itself.

  var counter = (function(){
    var i = 0;

    return {
      get: function(){
        return i;
      },
      set: function( val ){
        i = val;
      },
      increment: function() {
        return ++i;
      }
    };
  })();

  // `counter` is an object with properties, which in this case happen to be
  // methods.

  counter.get(); // 0
  counter.set( 3 );
  counter.increment(); // 4
  counter.increment(); // 5

  counter.i; // undefined (`i` is not a property of the returned object)
  i; // ReferenceError: i is not defined (it only exists inside the closure)
</pre>

The Module Pattern approach is not only incredibly powerful, but incredibly simple. With very little code, you can effectively namespace related methods and properties, organizing entire _modules_ of code in a way that both minimizes global scope pollution and creates privacy.

## Further reading

Hopefully this article was informative and has answered some of your questions. Of course, if you now have even more questions than when you started, you can learn even more about functions and the module pattern by reading the following articles.

 * [ECMA-262-3 in detail. Chapter 5. Functions.][grouping] - Dmitry A. Soshnikov
 * [Functions and function scope][mdc_fn_scope] - Mozilla Developer Network
 * [Named function expressions][kangax] - Juriy "kangax" Zaytsev
 * [JavaScript Module Pattern: In-Depth][module] - Ben Cherry

[kangax]: http://kangax.github.com/nfe/
[mdc_fn_scope]: https://developer.mozilla.org/en/JavaScript/Reference/Functions_and_function_scope
[grouping]: http://dmitrysoshnikov.com/ecmascript/chapter-5-functions/#question-about-surrounding-parentheses
[module]: http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth

_I'd like to thank [Asen Bozhilov](http://asenbozhilov.com/) and [John David Dalton](http://allyoucanleet.com/) for contributing technical advice, as well as [Nick Morgan](http://skilldrick.co.uk/) for his insights. If you'd also like to contribute, please post any suggestions or feedback in the comments, thanks!_


