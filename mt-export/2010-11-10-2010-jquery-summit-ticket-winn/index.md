title: "2010 jQuery Summit: Ticket Winners!"
categories: [ Code, News ]
tags: [ conference, contest, jquery, online, pluginization, presentation, summit, winners ]
date: 2010-11-10 16:56:13 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

In case you missed my [previous blog post][contest], I'm speaking at the upcoming [jQuery Summit](http://www.environmentsforhumans.com/2010/jquery-summit/), a two-day online conference taking place on November 16th and 17th. I'll be giving two talks, "Idiomatic jQuery" and "jQuery Pluginization" (one each day). In addition to my presentations, there will also be talks by a number of other well-known jQuery community members.

In addition, I [promised][contest] that a few lucky winners would win a ticket for either the Designer or Developer tracks. So, with a little help from [Brendan Eich](http://brendaneich.com/), [Ronald Fisher and Frank Yates](http://en.wikipedia.org/wiki/Fisher-Yates_shuffle), and without further ado...

[contest]: http://benalman.com/news/2010/11/2010-jquery-summit-win-tickets/

<!--MORE-->

# Super-awesome JavaScript code

<pre class="brush:js">
var developer = [
      '@jaredwilli',
      '@addy_osmani',
      '@coldfuser',
      '@jakemcgraw',
      '@robtarr'
    ],
    
    designer = [
      '@uberPinto',
      '@HEY_GERMANO',
      '@lynseydesign'
    ];

// From http://en.wikipedia.org/wiki/Fisher-Yates_shuffle
function shuffle( a ) {
  var n = a.length;
  for(var i = n - 1; i &gt; 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
  }
};

shuffle( developer );
shuffle( designer );

console.log( developer[0] ); // @coldfuser
console.log( developer[1] ); // @jaredwilli
console.log( designer[0] );  // @uberPinto
console.log( designer[1] );  // @lynseydesign
</pre>

Congratulations, guys! I'll send the discount codes out to you shortly!

And if you're not one of the lucky winners, there's still time, so [sign up now](http://www.environmentsforhumans.com/2010/jquery-summit/).


