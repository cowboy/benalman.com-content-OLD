title: "Safari View Source in TextMate"
categories: [ AppleScript, Projects ]
tags: [ applescript, html, safari, textmate, view source ]
date: 2010-02-21 23:21:53 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

This AppleScript does exactly what it says, which is allow you to view source from Safari in TextMate. Since it uses a temporary file to store the page source, TextMate won't ask if you'd like to save when you close the window. And since it tries to guess the correct filename extension to use, the correct syntax highlighter should be chosen automatically.

<!--MORE-->

* Tested with Safari 4 in OS X 10.5, but it should work pretty much anywhere

Note: if the script is converting a file extension you wish to keep intact to `.html`, just add that extension into the `extensions_to_keep` space-delimited list.

Also, I recommend that you bind this AppleScript to a hotkey like `Cmd-U` with a utility like [FastScripts](http://www.red-sweater.com/fastscripts/), for lightning-fast view-source-ability!

<pre class="brush:applescript">
(* 
 * Safari View Source in TextMate - v1.0 - 2/21/2010
 * http://benalman.com/projects/safari-view-source-in-textmate/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 *)

tell application "Safari"
  set src to source of document 1
  set location to URL of document 1
end tell

set file_name to do shell script "echo " & quoted form of location & " | perl -pe 's/^.*\\/\\/[^\\/]+.*\\/([^?#]*).*$/$1/'"
set file_base to do shell script "echo " & quoted form of file_name & " | perl -pe 's/\\.[^.]*$//'"
set file_ext to do shell script "echo " & quoted form of file_name & " | perl -pe 's/^(?:[^.]*\\.?|.*\\.(.*))$/$1/'"

if file_base is "" then set file_base to "file"

set extensions_to_keep to "js css txt"
if (" " & extensions_to_keep & " ") does not contain (" " & file_ext & " ") then set file_ext to "html"

set tmp to (do shell script "mktemp -d /tmp/textmate.XXXXXX") & "/" & file_base & "." & file_ext

try
  set handle to POSIX file tmp
  open for access handle with write permission
  write src to handle
  close access handle
on error
  do shell script "curl " & quoted form of location & " -o " & quoted form of tmp
end try

tell application "TextMate"
  activate
  open tmp
end tell
</pre>

If you have any feedback or suggestions, please let me know below in the comments!

