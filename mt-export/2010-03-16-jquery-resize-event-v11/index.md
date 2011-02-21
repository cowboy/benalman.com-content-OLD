title: "jQuery resize event v1.1"
categories: [ News, Project ]
tags: [ event, jquery, plugin, resize, throttle, window ]
date: 2010-03-16 09:34:43 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Recently, while working on another plugin for which [jQuery resize event][plugin] is an optional dependency, I noticed an odd behavior, so I investigated. It turns out that a minor bug that was causing the event to trigger immediately after bind in some circumstances.. so I fixed it, and threw in a few minor performance optimizations as well.

If you're currently using the plugin, you should update it. It's not a critical bug though, and since nobody reported it to me it's either a) just not a big deal, or b) an indicator that nobody is actually using this plugin.

Either way, for the latest version, visit the [project page][plugin] now!

  [plugin]: http://benalman.com/projects/jquery-resize-plugin/
