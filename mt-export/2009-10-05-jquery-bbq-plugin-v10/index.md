title: "jQuery BBQ plugin v1.0"
categories: [ Code, News, Project ]
tags: [ bbq, jquery, plugin ]
date: 2009-10-05 07:24:52 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I've finally finished my long-awaited [jQuery BBQ: Back Button & Query Library][plugin] plugin. So, what is jQuery BBQ? From the plugin page:

jQuery BBQ enables simple, yet powerful bookmarkable #hash history via a cross-browser window.onhashchange event. In addition, jQuery BBQ provides a full jQuery.deparam() method, along with both fragment and query string parse and merge utility methods.

What this means is that you can utilize jQuery BBQ to help build a single-page, event-driven web application, with full history and bookmarkability. You can also just use it to help parse, merge and deserialize query strings and fragments. The plugin weighs in at just over 3k, so you get a lot of functionality in a very small footprint.

Feel free to check out [the documentation and examples][plugin] to see how I've been using jQuery BBQ, and be sure to follow the project on [GitHub][github].

Also, note that this plugin, plus the upcoming jQuery urlInternal plugin, completely supersede my URL Utils plugin, providing a cleaner API and more efficient code. Moving forward, I would recommend switching to the new plugins!

  [plugin]: http://benalman.com/projects/jquery-bbq-plugin/
  [github]: http://github.com/cowboy/jquery-bbq
