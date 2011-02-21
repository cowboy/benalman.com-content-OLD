title: "Multi-Firefox Launcher"
categories: [ AppleScript, Projects ]
tags: [ applescript, firefox ]
date: 2010-07-31 18:15:55 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

While [many articles](http://www.google.com/search?q=multiple+firefox) have been written explaining how multiple versions of Firefox can run concurrently by launching Firefox with version-specific profiles via command-line argument, this very simple AppleScript aims to greatly streamline the process. Basically, once configured, you never again have to choose which profile goes with which version of Firefox. Just run the launcher and it handles everything!

<!--MORE-->

* Tested in OS X 10.6

### In preparation ###

Name each different version Firefox app you plan to run appropriately, for example `Firefox 2.0`, `Firefox 3.6`, `Firefox 4.0` (etc) and put them all in the same folder. These names are completely arbitrary, but should probably be somewhat descriptive. I personally like to keep all my non-default web browsers in one place:

![In preparation](http://benalman.com/grab/7a969f.png)

Now, <span class="applescript-open">open this AppleScript in Script Editor</span> and save it as `Launch Firefox` in the same folder as your Firefox apps. Set file format to "Application", and ensure that hide extension is checked.

<pre class="brush:applescript">
(* 
 * Multi-Firefox Launcher - v1.0 - 7/31/2010
 * http://benalman.com/projects/multi-firefox-launcher/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 *)

set my_path to quoted form of POSIX path of (path to me)

set parts to do shell script "echo " & my_path & " | perl -pe 's#^(.*?/)([^/]+) (Firefox.*?)\\.app/$#$1•$2•$3#'"
set parts to split(parts, "•")

set bin to quoted form of (first item of parts & last item of parts & ".app/Contents/MacOS/firefox-bin")

if second item of parts is "Launch" then
  set args to "-P " & (quoted form of last item of parts)
else if second item of parts is "Safe" then
  set args to "-safe-mode -P " & (quoted form of last item of parts)
else
  set args to "-" & second item of parts
end if

try
  do shell script "open -a " & bin & " --args " & args
on error
  display dialog "An error ocurred. Be sure that you've named the AppleScript properly!" buttons {"Close"} default button 1
end try

on split(txt, delim)
  set delim_orig to AppleScript's text item delimiters
  set AppleScript's text item delimiters to delim
  set retval to text items of txt
  set AppleScript's text item delimiters to delim_orig
  return retval
end split
</pre>

When saved, it should look something like this (and if you run it now, you'll get an error, so be patient):

![Launch Firefox](http://benalman.com/grab/921c76.png)

### Managing Firefox profiles ###

Once saved, rename the new AppleScript to `ProfileManager N` where N is the name of one of your Firefox apps (for example, `ProfileManager Firefox 4.0`). It shouldn't matter which version you choose.

![ProfileManager Firefox 4.0](http://benalman.com/grab/f52855.png)

Now run the AppleScript. In a few moments, the "Firefox - Choose Use Profile"
dialog should appear. Create one profile for each Firefox version, named
`Firefox 2.0`, `Firefox 3.6`, `Firefox 4.0` (basically, each profile must be named the same as the app with which it will be associated). When done, click "Exit".

_Note that if you want to associate your current profile (settings, cookies, extensions, etc) with a particular Firefox version, be sure to rename the "default" profile appropriately. Also, you should only need to perform this step again if you install a new version of Firefox or rename an existing version._

![Firefox - Choose Use Profile](http://benalman.com/grab/ed0d7d.png)

### One AppleScript per Firefox version ###

Finally, create one copy of this AppleScript for each version of Firefox you have
installed, named `Launch Firefox 2.0`, `Launch Firefox 3.6`,
`Launch Firefox 4.0` (the same as the actual app, but with "Launch "
prepended to the name), like so:

![Launch Firefox 4.0.app](http://benalman.com/grab/35e0a6.png)

### That's it! ###

By using these "Launch" AppleScripts, you should now be able to run multiple different versions of Firefox simultaneously without any issues. The only downside I've noticed is that each version of Firefox shows up in the OS X task switcher with the same icon and the same "Firefox" name (but perhaps someone can create some custom icons and/or find a way to tweak the name as-displayed by OS X.. hint, hint).

![Success!](http://benalman.com/grab/d2dff6.png)

_Note that you can also launch any version of Firefox in "Safe" mode by changing
the appropriate AppleScript's "Launch" prefix to "Safe Launch". As always, if you have any feedback or suggestions, please let me know below in the comments!_

