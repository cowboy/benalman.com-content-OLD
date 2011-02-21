title: "jQuery Misc plugins"
categories: [ Projects, jQuery ]
tags: [ assorted, miscellaneous, plugin, plugins ]
date: 2010-02-12 09:00:59 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This page contains a collection of minor jQuery plugins which are too small, too simple, or just not exciting enough to require individual pages. More will be added as I find the time... and the code!

<!--MORE-->

* [jQuery :attached, :detached selectors](#attached-detached) - Selectors that match elements currently attached to or detached from the DOM.
* [jQuery each2](#each2) - If you're going to use `$(this)` inside an `.each` loop, iterating over many thousands of elements, use this plugin instead. It's faster.
* [jQuery getClassData](#getclassdata) - If you're not yet using HTML 5 data- attributes, you can store basic data in an element's class attribute for easy retrieval.
* [jQuery getUniqueClass](#getuniqueclass) - For when you really need a unique classname.
* [jQuery htmlDoc](#htmldoc) - Get `html`, `head` and `body` in your `$(html)`.
* [jQuery isjQuery](#isjquery) - Determine if an object reference is a jQuery object.
* [jQuery loadAdScript](#loadadscript) - Load third party ad network scripts that use `document.write` into specific containers.
* [jQuery :nth-last-child selector](#nth-last-child) - Works exactly like jQuery's built-in :nth-child selector, except that it counts from the end. 
* [jQuery queueFn](#queuefn) - Execute any jQuery method or arbitrary function in the animation queue.
* [jQuery scrollbarWidth](#scrollbarwidth) - Calculate the scrollbar width dynamically!
* [jQuery selectColorize](#selectcolorize) - Basic cross-browser colored select boxes.
* [jQuery serializeObject](#serializeobject) - Serialize a form into an object.
* [jQuery viewportOffset](#viewportoffset) - Calculate left and top from the element's position relative to the viewport, not the document.

These once-misc plugins have been "promoted" to full projects:

* [jQuery replaceText](http://benalman.com/projects/jquery-replacetext-plugin/) - String replace for your jQueries!
* [jQuery throttle / debounce](http://benalman.com/projects/jquery-throttle-debounce-plugin/) - Rate-limit your functions in multiple useful ways, great for event callbacks.
* [jQuery Untils](http://benalman.com/projects/jquery-untils-plugin/) - nextUntil, prevUntil, and parentsUntil traversal methods.

<a name="jquery-optional"></a>
### Note for non-jQuery users ###
For plugins that are marked "jQuery is optional" please note that jQuery isn't actually required for the plugin to work, because nothing internal uses any jQuery methods or properties. jQuery is just used as a namespace under which the plugin's methods can exist.

Since jQuery isn't actually required for the plugin, if jQuery doesn't exist when this plugin is loaded, the plugin's methods will be created in the Cowboy namespace. Usage will be exactly the same, but instead of `$.method()` or `jQuery.method()`, you'll need to use `Cowboy.method()`.

<a name="attached-detached"></a>
## jQuery :attached, :detached selectors ##
Selectors that match elements currently attached to or detached from the DOM.

* Download [Source][attached-src], [Minified][attached-min] (0.4kb)

[attached-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-attached.js
[attached-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-attached.min.js

Usage example:

<pre class="brush:js">
var elem = $('div');

elem.filter(':attached').addClass( 'foo' ); // all divs get the class
elem.eq(0).is(':detached'); // false

elem.detach();

elem.filter(':attached').addClass( 'bar' ); // no divs get the class
elem.eq(0).is(':detached'); // true
</pre>

<a name="each2"></a>
## jQuery each2 ##
When you need to do `$(this)` inside an `.each` loop iterating over many thousands of elements, you could use this plugin instead of `.each`, because it has been specifically optimized for this use case.

Inside the `.each2` callback, while `this` is still the DOM element and that element's index is still the first function argument, the second argument is a jQuery object referencing the single DOM element, which is functionally equivalent to using `$(this)`, but a [whole lot faster][each2-perf].

_Note: if you don't need `$(this)` inside the callback, the core jQuery `.each` method will be significantly faster. Also, if you're not trying to super-ultra-hyper-optimize performance, this plugin is probably not going to make a huge difference to you. Inspired by [James Padolsey's quickEach](http://gist.github.com/500145)._

* Download [Source][each2-src], [Minified][each2-min] (0.3kb gzipped)
* [Performance tests][each2-perf]

[each2-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-each2.js
[each2-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-each2.min.js
[each2-perf]: http://jsperf.com/jquery-each2-vs-each

Usage example:

<pre class="brush:js">
// jQuery each2 plugin usage:
$('a').each2(function( i, jq ){
  this; // DOM element
  i; // DOM element index
  jq; // jQuery object
});

// jQuery core .each method usage:
$('a').each(function( i, elem ){
  this; // DOM element ( this === elem )
  i; // DOM element index
  $(this); // jQuery object
});
</pre>

<a name="getclassdata"></a>
## jQuery getClassData ##
If you're not yet using HTML 5 data- attributes, you can store basic data in an element's class attribute for easy retrieval. Just give each datum a prefix, which you can then use to select it.

_Note: data can't contain spaces, and prefix is case-sensitive._

* Download [Source][getclassdata-src], [Minified][getclassdata-min] (0.4kb)

[getclassdata-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-getClassData.js
[getclassdata-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-getClassData.min.js

Usage example:

<pre class="brush:js">
// Given this HTML
// &lt;div id="foo" class="bar-123 baz.test baz.xyz"&gt;Look, I'm a div!&lt;/div&gt;

$('#foo').getClassData( 'bar' );      // returns '123'
$('#foo').getClassData( 'baz', '.' ); // returns 'test xyz'
</pre>

<a name="getuniqueclass"></a>
## jQuery getUniqueClass ##
For when you really need a unique classname, (like when you're cloning a whole bunch of elements and don't exactly know where they're going, but need to do something with them after they've gotten there).

* Download [Source][getuniqueclass-src], [Minified][getuniqueclass-min] (0.2kb)

[getuniqueclass-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-getUniqueClass.js
[getuniqueclass-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-getUniqueClass.min.js

Usage example:

<pre class="brush:js">
var c = $.getUniqueClass(); // c set to 'BA-12352576545660' or so
$('p').addClass( c );
// .. haphazardly clone a bunch of &lt;p&gt; elements ..
$('.' + c).removeClass( c ).doSomethingNow();
</pre>


<a name="htmldoc"></a>
## jQuery htmlDoc ##

Use `$.htmlDoc( html )` as an alternative to `$(html)` when you have `html`, `head` or `body` tags defined in your HTML string and need to access those elements or maintain the hierarchical structure those elements provide.

* Download [Source][htmldoc-src], [Minified][htmldoc-min] (0.7kb)

[htmldoc-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-htmldoc.js
[htmldoc-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-htmldoc.min.js

### Why this plugin is necessary ###

From the jQuery [.load() API docs](http://api.jquery.com/load/):

jQuery uses the browser's `.innerHTML` property to parse the retrieved document and insert it into the current document. During this process, browsers often filter elements from the document such as `html`, `head` or `body` elements. As a result, the elements retrieved by `.load()` may not be exactly the same as if the document were retrieved directly by the browser.

Using jQuery, and given this test.html:

<pre class="brush:html">
&lt;!DOCTYPE HTML&gt;
&lt;html lang=&quot;en-US&quot;&gt;
&lt;head&gt;
  &lt;title&gt;Test&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
  &lt;div id=&quot;content&quot;&gt;
    &lt;p&gt;stuff&lt;/p&gt;
    &lt;p&gt;more stuff&lt;/p&gt;
  &lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;
</pre>

This behavior can be seen:

<pre class="brush:js">
$.get( 'test.html', function( html ) {
  // In doing this, the browser removes the HTML, HEAD and BODY elements
  // which results in the loss of part of the hierarchical structure of the
  // document.
  var h = $(html);
  
  // Not great: [, &lt;title&gt; Test &lt;/title&gt;, , &lt;div id=&quot;content&quot;&gt;...&lt;/div&gt;, ]
  console.log( h );
  
  // This fails: []
  console.log( h.find( 'body' ) );
  
  // This fails too: []
  console.log( h.find( '#content' ) );
  
  // This selects the content div, but it's ugly and not generic.
  console.log( h.filter( '#content' ) );
  
  // This also selects the content div, but it's also ugly, and won't work
  // for HTML, HEAD or BODY elements.
  console.log( $('&lt;div/&gt;').html( html ).find( '#content' ) );
});
</pre>

Using this plugin, things works more like you'd expect them to:

<pre class="brush:js">
$.get( 'test.html', function( html ) {
  // Since placeholders are used when rendering, and once done, placeholders
  // are systematically replaced with the corresponding HTML, HEAD and BODY
  // elements, the hierarchical structure of the document is preserved.
  var hd = $.htmlDoc( html );
  
  console.log( hd.filter( 'html' ).length ); // 1
  console.log( hd.filter( 'html' ).attr( 'lang' ) ); // "en-US"
  console.log( hd.find( 'head' ).length ); // 1
  console.log( hd.find( 'body' ).length ); // 1
});
</pre>


<a name="isjquery"></a>
## jQuery isjQuery ##
Determine if an object reference is a jQuery object.

Since every jQuery object has a `.jquery` property, it's usually safe to test the existence of that property. Of course, this only works as long as you know that any non-jQuery object you might be testing has no `.jquery` property. So.. what do you do when you need to test an external object whose properties you don't know?

_If you currently use `instanceof`, read [this Ajaxian article](http://ajaxian.com/archives/working-aroung-the-instanceof-memory-leak)._

* Download [Source][isjquery-src], [Minified][isjquery-min] (0.2kb)

[isjquery-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-isjquery.js
[isjquery-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-isjquery.min.js

Usage example:

<pre class="brush:js">
function doSomething( obj ) {
  if ( $.isjQuery( obj ) ) {
    obj.somejQueryMethod();
  } else {
    nonjQueryMethod( obj );
  }
}
</pre>

<a name="loadadscript"></a>
## jQuery loadAdScript ##
Load third party ad network scripts that use `document.write` into specific containers.

The only downside is that the ads will load serially.. but that's necessary to keep them from stepping on each others' toes. And the upside is that your site isn't completely borked!

* Download [Source][loadadscript-src], [Minified][loadadscript-min] (0.5kb)
* Try [working demo](http://benalman.com/code/projects/jquery-misc/examples/loadadscript/)
* Requires the [jQuery Message Queueing](http://benalman.com/projects/jquery-message-queuing-plugin/) plugin

[loadadscript-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-loadadscript.js
[loadadscript-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-loadadscript.min.js

Usage example:

<pre class="brush:js">
$('#ad1').loadAdScript( 'http://adnetwork.com/horrible_ad_1.js', function(){
  // This optional callback executes when the script has fully
  // loaded and executed.
  $(this).show();
});

$('#ad2').loadAdScript( 'http://adnetwork.com/horrible_ad_2.js', function(){
  // This optional callback executes when the script has fully
  // loaded and executed.
  $(this).show();
});
</pre>

<a name="nth-last-child"></a>
## jQuery :nth-last-child selector ##
Works exactly like jQuery's built-in [:nth-child selector](http://api.jquery.com/nth-child-selector/), except that it counts from the end. Supports any index/even/odd/equation that :nth-child does.

* Download [Source][nth-last-child-src], [Minified][nth-last-child-min] (0.4kb)

[nth-last-child-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-nth-last-child.js
[nth-last-child-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-nth-last-child.min.js

Usage example:

<pre class="brush:js">
// Exactly like :last-child, but slower!
var elems = $('ul li:nth-last-child(1)');

// Select every third element from the end, starting from
// the last element.
var elems = $('ul li:nth-last-child(3n+1)');
</pre>

<a name="queuefn"></a>
## jQuery queueFn ##
Execute any jQuery method or arbitrary function in the animation queue. The first argument is either a function reference or the string name of a jQuery method, like "css" or "remove". Any additional arguments will be passed into the specified method or function when it is executed. All queued functions execute, in order, in the default jQuery "fx" animation queue.

* Download [Source][queuefn-src], [Minified][queuefn-min] (0.4kb)

[queuefn-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-queuefn.js
[queuefn-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-queuefn.min.js

Usage example:

<pre class="brush:js">
// Remove an element from the DOM after fading out.
$('#foo').fadeOut().queueFn( 'remove' );

// Add "fading" class to en element, but only while it's fading in.
$('#bar')
  .hide()
  .addClass( 'fading' )
  .fadeIn()
  .queueFn( 'removeClass', 'fading' );

// Change color of an element (in slightly different ways) between fades, then
// remove the element if some_condition is true.
$('a:first')
  .fadeOut()
  .queueFn( 'css', { color: 'orange' } )
  .fadeIn()
  .queueFn( 'css', 'color', 'red' )
  .fadeOut()
  .queueFn(function(){
    if ( some_condition ) {
      $(this).remove();
    }
  });
</pre>

<a name="scrollbarwidth"></a>
## jQuery scrollbarWidth ##
Calculate the scrollbar width dynamically!

* Download [Source][scrollbarwidth-src], [Minified][scrollbarwidth-min] (0.4kb)

[scrollbarwidth-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-scrollbarwidth.js
[scrollbarwidth-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-scrollbarwidth.min.js

Usage example:

<pre class="brush:js">
var content = $('#content').css( 'width', 'auto' ),
  container = content.parent();

if ( content.height() > container.height() ) {
  content.width( content.width() - $.scrollbarWidth() );
}
</pre>

<a name="selectcolorize"></a>
## jQuery selectColorize ##
By default, select elements in Internet Explorer and Opera show the selected option's color and background color, while Firefox and WebKit browsers do not. jQuery selectColorize normalizes this behavior cross-browser for basic select box color styling, without having to resort to more "fancy" select box replacements.

_See [this article](http://lowfatcode.wordpress.com/2009/12/04/firefox-getcomputedstyle-bug/) for more information on the Firefox issue._

* Download [Source][selectcolorize-src], [Minified][selectcolorize-min] (0.9kb)
* Try [working demo](http://benalman.com/code/projects/jquery-misc/examples/selectcolorize/)

[selectcolorize-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-selectcolorize.js
[selectcolorize-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-selectcolorize.min.js

Usage example:

<pre class="brush:js">
// Initialize.
$('select').selectColorize();

// Destroy.
$('select').selectColorize( false );
</pre>

<a name="serializeobject"></a>
## jQuery serializeObject ##
Whereas jQuery's built-in `.serializeArray()` method serializes a form into an array, `.serializeObject()` serializes a form into an (arguably more useful) object.

* Download [Source][serializeobject-src], [Minified][serializeobject-min] (0.4kb)

[serializeobject-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-serializeobject.js
[serializeobject-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-serializeobject.min.js

Usage example:

<pre class="brush:js">
var html = '&lt;form&gt;'
  + '&lt;input type="hidden" name="a" value="1"/&gt;'
  + '&lt;input type="hidden" name="a" value="2"/&gt;'
  + '&lt;input type="hidden" name="a" value="3"/&gt;'
  + '&lt;input type="hidden" name="b" value="4"/&gt;'
  + '&lt;/form&gt;';

$(html).serializeObject(); // returns { a: [ "1", "2", "3" ], b: "4" }
</pre>

<a name="viewportoffset"></a>
## jQuery viewportOffset ##
Like the built-in jQuery `.offset()` method, but calculates left and top from the element's position relative to the viewport, not the document.

* Download [Source][viewportoffset-src], [Minified][viewportoffset-min] (0.3kb)
* Try [working demo](http://benalman.com/code/projects/jquery-misc/examples/viewportoffset/)

[viewportoffset-src]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-viewportoffset.js
[viewportoffset-min]: http://github.com/cowboy/jquery-misc/raw/master/jquery.ba-viewportoffset.min.js

Usage example:

<pre class="brush:js">
var elem = $('#thing');
if ( elem.viewportOffset().top > $(window).height() ) {
  // #thing element is "below the fold"
}
</pre>

