title: "Finder Copy Open Window Paths"
categories: [ AppleScript, Projects ]
tags: [ applescript, file, finder, osx ]
date: 2010-02-22 08:36:48 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This AppleScript allows you to very easy copy the path of any open Finder window to the clipboard. Also, in any application's Open or Save dialog, you can open a "Go to the folder" dialog into which a folder path can be entered. Coincidence?! Instead of typing in that path manually, just run this AppleScript to choose from the paths of all the open Finder windows!

<!--MORE-->

* Tested in OS X 10.4 and 10.5, but it should work pretty much anywhere

Using [FastScripts](http://www.red-sweater.com/fastscripts/), I have this script bound to `Cmd-Opt-Shift-G` so that in any application's Open or Save dialog I can very easily press `Cmd-Shift-G` to first open the "Go to the folder" dialog then `Cmd-Opt-Shift-G` to open this AppleScript. That hotkey might sound crazy, but trust me, it works.

I used to use [Default Folder X](http://www.stclairsoft.com/DefaultFolderX/), now I use this!

<pre class="brush:applescript">
(*
 * Finder Copy Open Window Paths - v1.1 - 7/30/2007
 * http://benalman.com/projects/finder-copy-open-window-paths/
 *
 * Copyright (c) 2007 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 *)

set allPaths to {}

tell application "Finder"
  set allwindows to (every Finder window)
  
  if allwindows is not {} then
    repeat with thisWindow in allwindows
      try
        set thisWindowPath to the POSIX path of (target of thisWindow as alias)
        if thisWindowPath is not in allPaths then
          set allPaths to allPaths & thisWindowPath
        end if
      end try
    end repeat
  else
    display dialog "No open Finder windows" with icon stop buttons {"Bloops!"} default button 1
    return
  end if
end tell

set strPath to choose from list allPaths with prompt "Copy the path of a Finder window:" default items item 1 of allPaths without multiple selections allowed

if strPath is not false then
  set the clipboard to item 1 of strPath
end if
</pre>

If you have any feedback or suggestions, please let me know below in the comments!

