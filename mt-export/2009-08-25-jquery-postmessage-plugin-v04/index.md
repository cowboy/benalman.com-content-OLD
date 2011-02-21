title: "jQuery postMessage plugin v0.4"
categories: [ Code, News, Project ]
tags: [ javascript, jquery, plugin, project ]
date: 2009-08-25 09:59:55 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

How about some cross-domain scripting goodness, for a change?

This [jQuery](http://jquery.com/) plugin enables simple and easy window.postMessage communication in browsers that support it (FF3, Safari 4, IE8), while falling back to a document.location.hash communication method for all other browsers (IE6, IE7, Opera). [One example][iframe] where this is useful is when a child Iframe needs to tell its parent that its contents have resized.

Check out the documentation and examples over at the [postMessage][plugin] plugin page now, and let me know if you have any questions, comments, or suggestions!

  [plugin]: http://benalman.com/projects/jquery-postmessage-plugin/
  [iframe]: http://benalman.com/code/test/js-jquery-postmessage/
