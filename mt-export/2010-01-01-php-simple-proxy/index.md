title: "Simple PHP Proxy: JavaScript finally \"gets\" cross-domain!"
categories: [ PHP, Projects ]
tags: [ json, jsonp, php, proxy ]
date: 2010-01-01 16:49:57 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

With Simple PHP Proxy, your JavaScript can access content in remote webpages, without cross-domain security limitations, even if it's not available in JSONP format. Of course, you'll need to install this PHP script on your server.. but that's a small price to have to pay for this much awesomeness.

<!--MORE-->

 * Release v1.6
 * Download [Source][src]
 * Follow the project on [GitHub project page][github] or [report a bug!][issues]
 * View [Full Documentation][docs]
 * Example: [Simple PHP Proxy][example]

  [github]: http://github.com/cowboy/php-simple-proxy
  [issues]: http://github.com/cowboy/php-simple-proxy/issues
  [src]: http://github.com/cowboy/php-simple-proxy/raw/master/ba-simple-proxy.php
  
  [docs]: http://benalman.com/code/projects/php-simple-proxy/docs/
  
  [example]: http://benalman.com/code/projects/php-simple-proxy/examples/simple/

## When don't I need a proxy? ##

When your JavaScript is loading HTML, XML or JSON data from a resource on the same domain, all that's needed is an XMLHttpRequest, and the data is yours. Also, when your JavaScript is loading [JSONP](http://remysharp.com/2007/10/08/what-is-jsonp/)-formatted JSON data from another domain, all that's needed is a predefined callback + script-injection to get the data. JavaScript libraries like [jQuery](http://jquery.com/) make this kind of thing easy, which is partly why they exist.

## So, when do I need a proxy? ##

Of course, it's often not that easy. Sometimes, your JavaScript needs to access cross-domain HTML, XML or JSON data that's just not available in JSONP format. In this case, what do you do? Well, you can ask the people controlling the remote data to provide it in JSONP format, but that probably won't happen (at least not anytime soon).

So, your JavaScript can only load cross-domain data via JSONP, and JSONP isn't an option. How do you solve the problem?

Eliminate the "cross-domain" bit.

Imagine making a copy of the remote data available locally. Your first thought might be to manually copy the data to your server.. which is feasible only if there's a very small amount of data that never changes.. but what if the data is dynamic, or what if there's a lot of it?

That's where the proxy comes in!

By using a proxy, your server can act as an intermediary between your JavaScript and the remote data, removing any cross-domain issued from the equation. A proxy can be written in any server-side language, and need not be complicated. It just needs to take a request, forward it to a remote server, and return the results.

## Why use Simple PHP Proxy? ##

A few of Simple PHP Proxy's features:

 * Requested URLs can be white-listed and validated against a regex.
 * Optionally forward client cookies / SID to the remote server.
 * Optionally forward configurable User Agent to the remote server.
 * Requests can use either GET or POST request methods.
 * Remote data can be delivered as-is with all remote headers intact (disabled by default to limit XSS vulnerabilites).
 * Remote data can be wrapped in a JSON/P structure that includes status codes and remote headers (JSONP disabled by default to limit abuse).
 * If using JSON/P and remote data is valid JSON, it will be merged into the resulting data object.

## But what do cats think? ##

![Meow?](http://benalman.com/grab/b7e79c.png)

Wow, even [Loki](http://www.flickr.com/groups/loki-cat/pool/) loves Simple PHP Proxy, what more endorsement could you possibly need?

Still, you don't have to take our word for it.. just check out the [Simple PHP Proxy example][example] to see how it works, download it onto your server, and have fun!

