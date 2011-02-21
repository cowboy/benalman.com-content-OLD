title: "Bookmarklets"
categories: [ JavaScript, Projects ]
tags: [ javascript, bookmarklet ]
date: 2009-11-14 11:31:03 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

I'm a hard-core bookmarklet junkie. I love adding non-standard functionality to my browsers, so I've created a few bookmarklets, which are posted here. I've also created a [jQuery bookmarklet generator](http://benalman.com/code/test/jquery-run-code-bookmarklet/), which you can use to create your own bookmarklets, should they require jQuery.

<!--MORE-->

What's a bookmarklet? I found this definition online: A bookmarklet is a small script that is saved as a bookmark. When the bookmark is selected in the browser, the script is executed. Because bookmark scripts are executed in the context of the current browser window, a wide variety of useful utilities can be created.

All bookmarklets on this page are represented by big green buttons, which you can drag to your Bookmarks or Links area (see the "Bookmarklet Installation" section below for more detailed installation instructions).

## Up! ##

<a class="bookmarklet floatright" href="javascript:(function(f,a,c,e,t,i,o,u,s){a=f.href;c=f.pathname;e=a.split('#')[0];t=e.split('?')[0];i=f.host.split('.');o=i.length==2?'www.':'';u=i.slice(o==''&&isNaN((i.slice(-1)+'').split(':')[0])?1:0).join('.');s=e!=a?e:t!=a?t:c.substring(0,c.substring(0,c.length-1).lastIndexOf('/')+1);f.href=s?s:f.protocol+'//'+o+u})(top.location)">Up!</a>

Up! is similar to the Google Toolbar's "Up a Level" button, but works in a more "micro" scope. First any #anchor is removed, then any ?querystring, then any filename, then any folders (one at a time). After that, hostnames are removed, and when nothing else is left to remove, www. is prepended to the domain, for good measure! Here is a simple illustration of how a URL would change through iterations:

 * http://foo.bar.com/aaa/bbb.html?c=d#eee  
 * http://foo.bar.com/aaa/bbb.html?c=d  
 * http://foo.bar.com/aaa/bbb.html  
 * http://foo.bar.com/aaa/  
 * http://foo.bar.com/  
 * http://bar.com/  
 * http://www.bar.com/  

## JavaScript Debug + Firebug Lite ##

<a class="bookmarklet floatright" href="javascript:if(!window.firebug){window.firebug=document.createElement(&quot;script&quot;);firebug.setAttribute(&quot;src&quot;,&quot;http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js&quot;);document.body.appendChild(firebug);(function(){if(window.firebug.version){firebug.init()}else{setTimeout(arguments.callee)}})();void (firebug);if(window.debug&&debug.setCallback){(function(){if(window.firebug&&window.firebug.version){debug.setCallback(function(b){var a=Array.prototype.slice.call(arguments,1);firebug.d.console.cmd[b].apply(window,a)},true)}else{setTimeout(arguments.callee,100)}})()}};">Debug + Firebug Lite</a>

This bookmarklet is intended to be used with the lightweight [JavaScript Debug](http://benalman.com/projects/javascript-debug-console-log/) console.log wrapper. When clicked, if the page doesn't use JavaScript Debug, this bookmarklet will just open Firebug Lite. If the page does use JavaScript Debug, the bookmarklet will open Firebug Lite and pre-populate it with any already-logged items. This approach facilitates debugging without inflicting a slow, heavy console on users that don't need it.

## Hammer URL ##

<a class="bookmarklet floatright" href="javascript:(function(p){open('','',p).document.write('%3Cbody%20id=1%3E%3Cnobr%20id=2%3E%3C/nobr%3E%3Chr%3E%3Cnobr%20id=3%3E%3C/nobr%3E%3Chr%3E%3Ca%20href=%22#%22onclick=%22return!(c=t)%22%3EForce%3C/a%3E%3Cscript%3Efunction%20i(n){return%20d.getElementById(n)}function%20z(){c+=0.2;if(c%3E=t){c=0;e.location=u;r++}x()}function%20x(){s=t-Math.floor(c);m=Math.floor(s/60);s-=m*60;i(1).style.backgroundColor=(r==0||c/t%3E2/3?%22fcc%22:c/t%3C1/3?%22cfc%22:%22ffc%22);i(2).innerHTML=%22Reloads:%20%22+r;i(3).innerHTML=%22Time:%20%22+m+%22:%22+(s%3C10?%220%22+s:s)}c=r=0;d=document;e=opener.top;u=prompt(%22URL%22,e.location.href);t=u?prompt(%22Seconds%22,60):0;setInterval(%22z()%22,200);if(!t){window.close()}%3C/script%3E%3C/body%3E')})('status=0,scrollbars=0,width=100,height=115,left=1,top=1')">Hammer URL</a>

Sometimes you just want to repeatedly reload a webpage. Click this bookmarklet and a small "controller" window is launched that loads the specified URL into the "opener" window ever N seconds. Stop the "hammering" by closing the controller window.

## Bookmarklet Installation ##

In most browsers, it's a simple as dragging the bookmarklet (the bright green buttons on this page) into the Bookmarks or Links area in your browser. This image is _extremely_ outdated, but it should give you the basic idea:

<img src="http://benalman.com/images/bookmarklets/bm-ie6.gif" alt="Bookmarklet Installation" style="border:none;text-align:center">

Note that if for some reason you are unable to drag-and-drop the bookmarklet into the Bookmarks or Links area, you can often right-click the bookmarklet to get a "save link" or "save bookmark" option.

Safari Bonus Tip: Many people don't realize this, but when you create bookmarklets like these and put them in the Bookmarks Bar, they are automatically assigned hotkeys, from left to right, Command-1, Command-2, etc.. and these hotkeys work regardless of the visibility of the Bookmarks bar.

And if you have any comments or suggestions regarding these bookmarklets, please let me know!

