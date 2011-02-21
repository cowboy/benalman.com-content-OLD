title: "Multi-Firefox Launcher for OS X"
categories: [ Code, News ]
tags: [ applescript, firefox, osx ]
date: 2010-08-02 12:51:33 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

While I generally try to avoid Firefox these days (using Chrome instead), I still like to test my code in multiple versions of all the major browsers to ensure that behavior is generally consistent. For a while, I was using [MultiFirefox](http://davemartorana.com/multifirefox/), which is a great utility, but I found using it to be far less streamlined than I would like.

Fortunately, I stumbled upon [an article](http://www.howtogeek.com/howto/internet/firefox/use-multiple-firefox-profiles-at-the-same-time/) this weekend that explained how to launch Firefox with an arbitrary profile via command-line parameter (which is probably what MultiFirefox does internally). Unfortunately, because OS X aliases don't work like Windows shortcuts, it's a bit cumbersome to have to open the Terminal and type a command every time you want to launch Firefox... so I wrote a [relatively simple AppleScript][script] that greatly streamlines the process.

Basically, once configured, you never again have to choose which profile goes with which version of Firefox. Just run the launcher and it handles everything! If you're curious, check out the instructions for [Multi-Firefox Launcher][script] now, and let me know what you think.

[script]: http://benalman.com/projects/multi-firefox-launcher/
