title: "jQuery 1.4 \$.param demystified"
categories: [ Code, News ]
tags: [ jquery, param, php, query string, rack, rails ]
date: 2009-12-20 20:52:46 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

If you've tried out [jQuery 1.4](http://jquery14.com/), you might have noticed that, among other things, the $.param method has seen some significant improvements.

I'd like to take a few moments to explain how request params parsing works, and how things have changed in jQuery 1.4.

<!--MORE-->

If you really only want to read about what's changed in jQuery 1.4, skip ahead to the [so, what does all this have to do with jQuery 1.4?](#so-what-does-all-this-have to-do-with-jquery-14) section... otherwise, continue onward!

### Some back story ###

So, I spend a lot of time in the #jquery irc.freenode.net support channel helping newbies, and a very common newbie mistake is how people try to submit forms with array values in PHP or Rails. The thing is, this "mistake" could be made by anyone, because it's not really a mistake.

There is no RFC that I know of that states exactly how a query string must be decoded by a web server (please correct me if I'm wrong). While there are a few de facto standards, different servers and frameworks behave differently.

### The problem in modern frameworks ###

Many "traditional" frameworks will decode a query string like `?a=1&a=2&a=3&b=1` into a "get" (or "post" or "request") hash (associative array, object, etc) such that its `a` property is an indexed array like `["1","2","3"]` and its `b` property is a scalar string value of `"1"`. There is no provision made for nested arrays or hashes, and there is also no provision for types other than string. Either you have string values, or shallow arrays of string values, and that's it.

Now, in PHP, if you try to pass a query string like `?a=1&a=2&a=3`, you'll see that `$_GET["a"]` is `"3"` instead of an array like `["1","2","3"]`, which you might expect.

This example illustrates the problem perfectly. Submitting this HTML form:

<pre class="brush:html">
&lt;form action="dump.php" method="get"&gt;
  &lt;input type="checkbox" name="a" value="1" checked="checked"&gt;
  &lt;input type="checkbox" name="a" value="2" checked="checked"&gt;
  &lt;input type="checkbox" name="a" value="3" checked="checked"&gt;
  &lt;input type="submit" name="Submit" value="submit"&gt;
&lt;/form&gt;
</pre>

To this very simple dump.php PHP script:

<pre class="brush:php">
&lt;?PHP
header( 'Content-type: text/plain' );
print_r( $_GET );
?&gt;
</pre>

Yields this result:

<pre class="brush:text">
Array
(
    [a] => 3
    [Submit] => submit
)
</pre>

PHP should be smarter than this, right? What gives?

### The dealio ###

Well, let's look at how to [push onto an array](http://php.net/manual/en/function.array-push.php) in PHP, because this gives us a very helpful hint towards fixing our little problem:

<pre class="brush:php">
&lt;?PHP
// One way to push "value" onto $array.
array_push( $array, "value" );

// Another way to push "value" onto $array.
$array[] = "value";
?&gt;
</pre>

That second method is pretty telling. PHP's request params parser was written to use square-bracket-notation as a means of indicating array index or key, and as such, a query string like `?a[]=1&a[]=2&a[]=3` tells PHP that `a` is an array, and to push each value `"1"`, `"2"` and `"3"` onto that array in order, yielding an array like `["1","2","3"]`.

This is different than the "traditional" way where, in the absence of square brackets, all properties are assumed to have scalar values until a second property with the same name is passed, at which point the scalar value is promoted to be the first element in an array, and all subsequent values are pushed onto that array.

Wow, that last sentence was a mouthful. To make a long story short, the "traditional" way is less explicit.

Ok... so does that make the "traditional" way bad?

Well, this implicit array promotion parsing method means you can't pass in a single-element array, because how would you indicate to the server that `a` in `?a=1` is an array? Also, because for each name=value pair the property name is "everything to the left of the equals" there is no way to indicate nested objects. While PHP handles square brackets like you'd (now) expect, servers using the "traditional" way would deserialize a query string like `?a[]=1&a[]=2&a[]=3` into an array named `a[]` (and not `a`) with the value `["1","2","3"]`.

### The solution for modern frameworks ###

The solution for submitting arrays in HTML forms to PHP or Rails is nothing new, and people have been using the following technique for some time. Just add `[]` to the end of every array-value form element's name, and things will be just peachy (note that this won't change the fact that every scalar value is a string):

<pre class="brush:html">
&lt;form action="dump.php" method="get"&gt;
  &lt;input type="checkbox" name="a[]" value="1" checked="checked"&gt;
  &lt;input type="checkbox" name="a[]" value="2" checked="checked"&gt;
  &lt;input type="checkbox" name="a[]" value="3" checked="checked"&gt;
  &lt;input type="submit" name="Submit" value="submit"&gt;
&lt;/form&gt;
</pre>

To the same, simple dump.php PHP script:

<pre class="brush:php">
&lt;?PHP
header( 'Content-type: text/plain' );
print_r( $_GET );
?&gt;
</pre>

Yields the result you want:

<pre class="brush:text">
Array
(
    [a] => Array
        (
            [0] => 1
            [1] => 2
            [2] => 3
        )

    [Submit] => submit
)
</pre>

Great, problem solved. And with `[]` notation, not only can we use `?a[]=1` to "push" `"1"` onto array `a`, but we can use `?a[5]=1` to set the index `5` value of array `a` to be `"1"`, `?a[x]=1` to set property `x` of hash `a` to be `"1"`, or even `?a[2][x][]=1` to push `1` onto the `a` array element's index `2` value's hash's `x` property's array (good grief).

The only caveats to this are:

 * Traditional frameworks don't know what to do with the fancy `[]` stuff, so request object property names become horribly munged.
 * Rails (well, actually rack) can't handle arrays containing non-scalar values.

See the [it's not all unicorns and rainbows](#unicorns-rainbows) section for more information on these issues.

<div id="so-what-does-all-this-have to-do-with-jquery-14"></div>
### So, what does all this have to do with jQuery 1.4? ###

Submitting forms in the "normal" way (like, by hitting a "Submit" button, remember pages that did that?) works exactly the same way as it's always worked. And using jQuery's [$.serialize](http://docs.jquery.com/Ajax/serialize) method to convert form values into params for AJAX POST or GET requests is also the same.

But what about when you're creating an AJAX request using one of the jQuery [$.ajax](http://docs.jquery.com/Ajax/jQuery.ajax#examples) methods, and the data you're passing to the web server isn't stored in a form, but is instead created from an arbitrary data structure?

You could add `[]` to the end of every array property's name, manually converting a `data` argument object like `{ a: [1,2,3] }` into `{ "a[]": [1,2,3] }`, but that's a bit unwieldy, and requires you to create a special version of your data object just for an AJAX request.

So, why not automate this?

Well, early in 2009, [Aaron Quint](http://www.quirkey.com/) opened [a ticket](http://dev.jquery.com/ticket/4201) with exactly this idea. A patch was committed, but in my testing of [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) I noticed that there were a few serialization ambiguity issues. After some discussion with [Yehuda Katz](http://yehudakatz.com/) and [John Resig](http://ejohn.org/), we decided that I should rewrite the $.param method for jQuery 1.4, and its final version is now merged in as of [jQuery 1.4a2](http://blog.jquery.com/2009/12/18/jquery-14-alpha-2-released/).

So, while jQuery 1.3.2 and earlier behaves one way:

<pre class="brush:js">
// jQuery 1.3.2 and earlier

// This request hits this URL: test.php?a=1&a=2&a=3 which means your
// PHP or Rails App will see `a` set to "3" (bad).
$('#test').load('test.php', {
  a: [ 1, 2, 3 ]
});

// This request hits this URL: test.php?a[]=1&a[]=2&a[]=3 which means
// your PHP or Rails App will see `a` set to ["1","2","3"] which
// works, but the javascript is ugly!
$('#test').load('test.php', {
  "a[]": [ 1, 2, 3 ]
});

// And of course, this request is a total failure. The URL hit is
// test.php?a=1&a=2&a=3&b=[object+Object] which does nobody any good,
// because the `b` object is destroyed.
$('#test').load('test.php', {
  a: [ 1, 2, 3 ],
  b: { c:4, d:5 }
});
</pre>

jQuery 1.4 behaves a bit differently:

<pre class="brush:js">
// jQuery 1.4

// This request hits this URL: test.php?a[]=1&a[]=2&a[]=3 which means
// your PHP or Rails app will see `a` set to ["1","2","3"], without
// adding any extra [] anywhere.
$('#test').load('test.php', {
  a: [ 1, 2, 3 ]
});

// But wait, it gets better. No, really!

// This request hits this URL: test.php?a[]=1&a[]=2&a[]=3&b[c]=4&b[d]=5
// which means your PHP or Rails app not only sees `a` set to
// ["1","2","3"], but also sees `b` set to `{ c: "4", d: "5" }`,
$('#test').load('test.php', {
  a: [ 1, 2, 3 ],
  b: { c:4, d:5 }
});
</pre>

Instead of being limited to shallow arrays and scalars, the jQuery 1.4 $.param method has been rewritten to allow serialization of pretty much any data structure, with any amount of array and object nesting, using as many square brackets as necessary.

Note that if you're using jQuery 1.3.2, you can leverage the power of the new jQuery 1.4 $.param method by dropping [this code](http://gist.github.com/206323) into your project.

<div id="taking-it-to-the-extreme"></div>
### Taking it to the extreme ###

For example, in jQuery 1.4, you can serialize ridiculously complicated nested objects, if you really want to:

<pre class="brush:js">
$.param({a:[4,5,6],b:{x:[7],y:8,z:[9,0,"true","false","undefined",""]},c:1})

// returns "a[]=4&a[]=5&a[]=6&b[x][]=7&b[y]=8&b[z][]=9&b[z][]=0&b[z][]=true&b[z][]=false&b[z][]=undefined&b[z][]=&c=1"

// And..

$.param({a:[0,[1,2],[3,[4,5],[6]],{b:[7,[8,9],[{c:10,d:11}],[[12]],[[[13]]],{e:{f:{g:[14,[15]]}}},16]},17]})

// returns "a[]=0&a[1][]=1&a[1][]=2&a[2][]=3&a[2][1][]=4&a[2][1][]=5&a[2][2][]=6&a[3][b][]=7&a[3][b][1][]=8&a[3][b][1][]=9&a[3][b][2][0][c]=10&a[3][b][2][0][d]=11&a[3][b][3][0][]=12&a[3][b][4][0][0][]=13&a[3][b][5][e][f][g][]=14&a[3][b][5][e][f][g][1][]=15&a[3][b][]=16&a[]=17"
</pre>

Both of those params strings (and many, many more) will be properly deserialized by PHP and [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/)'s $.deparam method. Check out the [jQuery BBQ deparam examples](http://benalman.com/code/projects/jquery-bbq/examples/deparam/) to see how both PHP and jQuery BBQ deserialize query strings.

<div id="unicorns-rainbows"></div>
### It's not all unicorns and rainbows ###

Not everything is perfect, and as such, there are still a few things to watch out for.

#### What about my "traditional" framework? ####

In frameworks utilizing the "traditional" method for deserializing request parameters, the default jQuery 1.4 $.param behavior of serializing a `data` object like `{ a: [1,2,3] }` into `?a[]=1&a[]=2&a[]=3` will make a mess of things, so you can set `$.ajaxSetup({ traditional: true }); ` to force jQuery to behave the old, crusty way. Like it did in 1.3.2 and earlier. If you want nested param fanciness, patch your framework!

#### My old JavaScript de-param code no longer works ###

You may find that the URL deserialization routine that you wrote or use doesn't handle all the extra fanciness in a new jQuery 1.4 $.param-serialized query string. Well, have no fear! I have written a deparam method, included in my [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/) plugin. Also included in jQuery BBQ are a few query string and fragment parsing / merging methods. Check them out, you won't be disappointed.

#### Rails (well, actually rack) ####

Note that rack (as of 1.0.0) can't currently deserialize nested arrays properly, and attempting to do so may cause a server error. So if you make an AJAX request with `data` containing arrays with nested arrays or objects, you'll get a server error.

Possible fixes for this are to modify rack's deserialization algorithm or to provide an option or flag in jQuery to force array serialization to be shallow.

Check out some [PHP / Rails query string parsing examples](http://gist.github.com/257267).

#### Everything is a string ####

No matter how you spin it, HTML forms and client-server interactions were never intended to be as complicated as they currently are. Sending request params is supposed to be a very simple thing, and as a result there is no way to differentiate between string, number, or other scalar values. Everything is just a string.

If you want more robust data handling, use [JSON](http://www.json.org/). It's fast, supports non-string scalar types, and is starting to get native browser implementations. Besides, every framework out there should have some kind of JSON parsing ability by now.

#### Param strings can get huge ####

Just look at the [taking it to the extreme](#taking-it-to-the-extreme) examples above. Param strings can get pretty monstrous. Beware of browser / server length limitations.

