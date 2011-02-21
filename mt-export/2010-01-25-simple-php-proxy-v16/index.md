title: "Simple PHP Proxy v1.6"
categories: [ News, Project ]
tags: [ json, jsonp, php, proxy ]
date: 2010-01-25 21:19:07 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've just updated my [Simple PHP Proxy][proxy] script. It now defaults to JSON mode, which can be changed to native mode by specifying ?mode=native. Also, native and JSONP modes are disabled by default because of possible XSS vulnerability issues, but are configurable in the PHP script along with a URL whitelisting regex.

Check out the [script, example, documentation and, yes, feline endorsement][proxy] to see how everything works, download it onto your server, and have fun!

  [proxy]: http://benalman.com/projects/php-simple-proxy/
