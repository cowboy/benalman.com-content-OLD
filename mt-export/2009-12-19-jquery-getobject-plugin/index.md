title: "jQuery getObject: get.and.set.deep.objects.easily = true;"
categories: [ Projects, jQuery ]
tags: [ dojo, exists, get, getObject, jquery, object, plugin, properties, set, setObject ]
date: 2009-12-19 20:02:20 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

jQuery getObject allows you to get and set properties of an object via dot-delimited name string. Inspired by the Dojo methods of the same names.

<!--MORE-->

 * Release v1.1
 * Tested both without jQuery and with jQuery 1.3.2 and 1.4a2 in Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.
 * Download [Source][src], [Minified][src-min] (0.7kb)
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * View [Unit Tests][unit]

  [github]: http://github.com/cowboy/jquery-getobject
  [issues]: http://github.com/cowboy/jquery-getobject/issues
  [src]: http://github.com/cowboy/jquery-getobject/raw/master/jquery.ba-getobject.js
  [src-min]: http://github.com/cowboy/jquery-getobject/raw/master/jquery.ba-getobject.min.js
  
  [docs]: http://benalman.com/code/projects/jquery-getobject/docs/
  
  [unit]: http://benalman.com/code/projects/jquery-getobject/unit/

## Note for non-jQuery users ##

jQuery isn't actually required for this plugin, because nothing internal
uses any jQuery methods or properties. jQuery is just used as a namespace
under which these methods can exist.

Since jQuery isn't actually required for this plugin, if jQuery doesn't exist
when this plugin is loaded, the methods described below will be created in
the `Cowboy` namespace. Usage will be exactly the same, but instead of
$.method() or jQuery.method(), you'll need to use Cowboy.method().

## Note for Dojo users ##

The setObject, getObject, and exists methods are similar to their Dojo
counterparts, with the exception that exists returns true or false based
on whether or not a property is defined, not whether it is truthy.

## Usage Examples ##

This plugin is useful if you have deep namespaces or data structures and don't want to do excessive testing like: `if ( a && a.b && a.b.c ) { ... }` every time you need to get or set a property or invoke a method.

If that's you, check out the examples below, and enjoy!

If that's _not_ you, check out something more exciting, like [jQuery doTimeout](http://benalman.com/projects/jquery-dotimeout-plugin/) or [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/).

<pre class="brush:js">
var myObj = {};

// Setting.
$.setObject( 'a.b.c', { d: 1, e: 2 }, myObj ); // returns a.b.c reference

// myObj is now { a: { b: { c: { d: 1, e: 2 } } } }

// Getting.
$.getObject( 'a.b.c.d', myObj ); // returns 1
$.getObject( 'a.b.c.x', myObj ); // returns undefined
$.getObject( 'a.b.c.d.x', myObj ); // returns undefined

// Testing.
$.exists( 'a.b.c.d', myObj ); // returns true
$.exists( 'a.b.c.x', myObj ); // returns false
$.exists( 'a.b.c.d.x', myObj ); // returns false

// I'm not sure why you'd want to do something like this, but it's
// certainly possible...
$.setObject( 'document.body.style.display', 'none' );
$.getObject( 'document.body.style.display' ); // returns 'none'
</pre>

Please check out the [documentation][docs] for specific usage information.

If you have any non-bug-related feedback or suggestions, please let me know below in the comments, and if you have any bug reports, please report them in the [issues tracker][issues], thanks!

