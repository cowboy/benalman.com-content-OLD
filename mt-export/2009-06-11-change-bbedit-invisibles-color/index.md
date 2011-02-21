title: "Change BBEdit Invisibles colors"
categories: [ Code, Geek, News ]
tags: [ bbedit, code, osx ]
date: 2009-06-11 06:51:19 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

**Update: this feature has officially been added as of BBEdit 9.3, see [my post](http://benalman.com/news/2009/11/bbedit-invisibles-colors-updat/) about it!**

While I find BBEdit to be a fantastic text editor, there are a few minor things I've always wanted to change, one of which is the color for Invisibles. I _love_ the idea, but against my preferred background color, they stand out far too much to be anything but distracting.

If you've never seen Invisibles, you can enable them for the current document in the Text Options menu of that window's toolbar, or globally by going to Preferences > Editor Defaults > Show Invisibles.

Now, if at first glance they seem obnoxious, imagine their color changed to be a bit more subtle, like _just slightly_ darker or lighter than the background color. Sound better? Read on!

<!--MORE-->

First of all, I recommend that you backup the `~/Library/Preferences/com.barebones.bbedit.plist` BBEdit prefs file, just in case. Now, open a new Terminal window and paste this line (leave the window open afterwards):

<pre class="brush:bash">export BBEDIT_COLOR=$(defaults read com.barebones.bbedit Color:Comment)
</pre>

In BBEdit, go to Preferences > Text Colors and change the color for Comment to the color you'd like for Invisibles (feel free to actually throw some code and comments into a page to test with), then quit BBEdit.

In the same shell as before:

<pre class="brush:bash">defaults write com.barebones.bbedit Color:Invisibles:Spaces \
  -string "$(defaults read com.barebones.bbedit Color:Comment)"
defaults write com.barebones.bbedit Color:Invisibles:Other \
  -string "$(defaults read com.barebones.bbedit Color:Comment)"
defaults write com.barebones.bbedit Color:Comment -string "$BBEDIT_COLOR"
</pre>

Open BBEdit, and you're done. You can close the shell now if you'd like.

### Notes ###

* If "Reopen documents that were open at last quit" is enabled, when BBEdit opens, the first document apparently uses the default Invisibles colors (even if they are changed in BBEdit's DefaultPreferences.plist file). I have found no way around this annoyance, short of always opening an empty placeholder text file as the first open file in that window.
* `Color:Invisibles:Other` doesn't actually seem to change anything, not that I've noticed at least.. but I'm setting it anyways, just in case.
* If you think [Bare Bones](http://www.barebones.com/) should include proper configuration for Invisibles colors, let them know!

