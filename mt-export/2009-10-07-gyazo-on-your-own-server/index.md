title: "Gyazo.. on your own server"
categories: [ Code, Geek, News ]
tags: [ gyazo, hack, osx, php, ruby ]
date: 2009-10-07 08:00:00 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

A while back, [Paul Irish](http://paulirish.com/2009/get-gyazo-for-seriously-instant-screen-grabbing/) turned me on to [gyazo](http://gyazo.com/index_e.html), a very small, very simple, very free app that allows you to very quickly share screen captures over the web. It works by first using the operating system's own screen capture tools to snap an image of a region you specify, then it uploads that image to gyazo.com, opening it in your web browser. The URL is even copied to the clipboard afterwards.

Perfect, right?

Well.. almost perfect. Because of firewall restrictions, I found that gyazo.com was blocked for some of my friends, so they couldn't see my screen captures. Also, I really liked the idea of uploading the images to my own server, so that I'd have full control over them.

So, that being said, I decided to crack open gyazo.app (Right click, Show Package Contents) and see if there was anything I could do to change that.

<!--MORE-->

Fortunately, modifying gyazo was pretty easy (despite the fact that I know next to nothing about Ruby). In the `/Applications/gyazo.app/Contents/Resources/script` file, I gave these two variables:

<pre class="brush:ruby">
HOST = 'gyazo.com'
CGI = '/upload.cgi'
</pre>

values that made sense for my server. My HOST is `'benalman.com'` and CGI is `'gyazo.php'`, a little PHP script I've worked up and posted on [GitHub](http://gist.github.com/203474). I'll post the script here as well:

<pre class="brush:php">
&lt;?PHP

/*
 * PHP upload for Gyazo - v1.1 - 10/7/2009
 * http://benalman.com/news/2009/10/gyazo-on-your-own-server/
 * 
 * Copyright (c) 2009 "Cowboy" Ben Alman
 * Licensed under the MIT license
 * http://benalman.com/about/license/
 */

// The local path in which images will be stored (change as neceesary).
$path = '/srv/www/gyazo/';

// The URI path at which images will be accessed (change as neceesary).
$uri  = 'http://' . $_SERVER['HTTP_HOST'] . '/grab/';

// Get binary image data from HTTP POST.
$imagedata = $_POST['imagedata'];

// Generate a unique filename.
$i = 0;
do {
  $filename = substr( md5( $imagedata . $i++ ), -6 ) . '.png';
} while ( file_exists( "$path$filename" ) );

// Save the image.
$fp = fopen( "$path$filename", 'ab' );
fwrite( $fp, $imagedata );
fclose( $fp );

// Compress the image (destroying any alpha transparency).
$image = @imagecreatefrompng( "$path$filename" );
imagepng( $image, "$path$filename", 9 );
imagedestroy( $image );

// Return the image URI.
print "$uri$filename";

?&gt;
</pre>

Obviously, you'll want to adjust `$path` and `$uri` to the appropriate values for your server, and make sure that the local directory stored in `$path` is writable by PHP. But other than that, it should just work.

One last thing, in the gyazo.app `script` file, I also changed `system "screencapture -i #{tmpfile}"` to `system "screencapture -io #{tmpfile}"`, adding the `o` option which means "in window capture mode, do not capture the shadow of the window". I never really liked the window shadow capturing, and since the PHP imagepng function removes alpha transparancy, it seemed like a good change to make.

## Et voilà! ##

![my tweet](http://benalman.com/grab/e09f87.png)

I have only tried this in the OS X version of Gyazo, so I have no idea how it works in other versions. If you can confirm that it works (or doesn't work) in Windows, or have any comments or suggestions, please let me know in the comments!

## Notes ##

* Be sure to disable [Magic quotes](http://php.net/manual/en/security.magicquotes.php), because they will corrupt your binary image data.

