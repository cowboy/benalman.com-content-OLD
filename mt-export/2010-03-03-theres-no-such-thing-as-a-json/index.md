title: "There's no such thing as a \"JSON Object\""
categories: [ Code, News ]
tags: [ json, object, object literal, string ]
date: 2010-03-03 14:54:49 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I want to clear up a common misconception. It's my belief that developers mistakenly call JavaScript Object literals "JSON Objects" because their syntax is identical to (well, a superset of) what is described in the [JSON specification][json], but what the specification fails to mention explicitly is that since JSON is a "data-interchange language," _it's only actually JSON when it's used in a string context._

[json]: http://json.org/

<!--MORE-->

## Serialization and deserialization ##

When two applications/servers/languages/etc need to communicate, they tend to do so using strings, since strings can be interpreted in pretty much the same way in all languages. While a complex data structure is often described internally in terms of memory references, and represented with all kinds of curly, square, angle brackets or whitespace.. a string is just an ordered series of characters.

To this end, standard rules or syntaxes have been created to describe complex data structures as strings. JSON is one such syntax, as it can describe Objects, Arrays, Strings, Numbers, Booleans and null in a string context, which can be passed from application to application and decoded as needed. [YAML](http://en.wikipedia.org/wiki/YAML) and [XML](http://en.wikipedia.org/wiki/XML) (and even [request params](http://benalman.com/news/2009/12/jquery-14-param-demystified/)) are two other popular data interchange (or serialization) formats, but of course we like JSON because we're JavaScript developers!

## Literals ##

And just for reference, I'm going to quote Mozilla Developer Center here:

* Literals are fixed values, not variables, that you _literally_ provide in your script. ([Literals](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Core_Language_Features#Literals))
* A string literal is zero or more characters enclosed in double (") or single (') quotation marks. ([String Literals](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Core_Language_Features#String_Literals))
* An object literal is a list of zero or more pairs of property names and associated values of an object, enclosed in curly braces ({}). ([Object Literals](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Core_Language_Features#Object_Literals))

## So, when is JSON not JSON? ##

[JSON][json] was designed as a data interchange format, which happens to have a syntax that is a subset of JavaScript.

And as such, `{ "prop": "val" }` could be a JavaScript Object literal or a JSON string, depending in what context it's being used. If it's used in a string context (surrounded by single or double quotes, loaded from a text file, etc) it is a JSON string. If it's used in an Object literal context, it's an Object literal.

<pre class="brush:js">
// This is a JSON String.
var foo = '{ "prop": "val" }';

// This is an Object literal.
var bar = { "prop": "val" };
</pre>

Also, note that JSON has a very strict syntax, and while `{ "prop": "val" }` is valid JSON when used in a string context, `{ prop: "val" }` and `{ 'prop': 'val' }` are not valid JSON. All property names and string values must be surrounded by double quotes, not single quotes! And for you PHP guys, note that [escaped single quotes](http://www.php.net/manual/en/security.magicquotes.whynot.php) are also invalid. Yes, Flickr, I'm [talking to you](http://www.flickr.com/groups/api/discuss/72157622950514923/). Either way, see [the syntax rules][json] for all of the details.

## Putting things into context ##

So, all you smart-asses out there, you know who you are.. you're thinking "Well, isn't my JavaScript source code just one big string of text?"

Yes, of course it is. All your JavaScript and HTML (among other things) are, by themselves, strings of text.. until they are interpreted by the browser. That .js file or inline JavaScript code ceases to be "just one big string of text" the moment that the browser interprets it as JavaScript source... just like the page's innerHTML ceases to be "just one big string of text" as soon as it is converted into a DOM structure.

Again, it's all about context. Use that curly-brace-delimited JavaScript object in a string context and you've got a JSON string. Use it in an Object literal context, and you've got an Object literal.

## The JSON object ##

So, maybe I fibbed a little. While Object literals are not "JSON Objects," there really is [a JSON object](https://developer.mozilla.org/en/Using_native_JSON), but it's something else entirely. In modern browsers, the JSON object is a native object with the static methods `JSON.parse` (deserialize a JSON string into an object) and `JSON.stringify` (serialize an object into a JSON string). When you want to convert to and from JSON, you use these methods. In older browsers that don't provide a native JSON object, you can use [json2.js][json] to add this functionality.

And just in case you still don't understand, don't worry about it, here's a little cheat sheet:

<pre class="brush:js">
// This is a JSON String, like what you'd get back from an AJAX request.
var my_json_string = '{ "prop": "val" }';

// This is how you deserialize that JSON String into an Object.
var my_obj = JSON.parse( my_json_string );

alert( my_obj.prop == 'val' ); // Alerts true, fancy that!

// And this is how you serialize an Object into a JSON String.
var my_other_json_string = JSON.stringify( my_obj );
</pre>

Also, [Paul Irish](http://paulirish.com/) pointed out to me that Douglas Crockford uses the term "JSON object" in the [JSON RFC][rfc], but in that context it means "Object as represented in a JSON string" and not "Object literal."

## Extra credit ##

If you want to learn more about JSON, here are a few notable JSON-related links, for perusal at your leisure.

 * [JSON specification][json]
 * [JSON RFC][rfc]
 * [JSON on Wikipedia](http://en.wikipedia.org/wiki/JSON)
 * [JSONLint - The JSON Validator](http://www.jsonlint.com/)
 * [JSON is not the same as JSON](http://james.padolsey.com/javascript/json-is-not-the-same-as-json/)

[json]: http://json.org/
[rfc]: http://www.ietf.org/rfc/rfc4627.txt?number=4627

