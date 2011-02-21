title: "On contributing to jQuery, and new plugins too..."
categories: [ Code, News ]
tags: [ jquery, plugin, url utils ]
date: 2009-09-30 21:08:15 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Well, I've spent a lot of time over the last few weeks working with [John Resig](http://ejohn.org/) and [Yehuda Katz](http://yehudakatz.com/) on a few contributions to the upcoming [jQuery](http://jquery.com/) 1.4. John thought that my [unwrap plugin](http://benalman.com/projects/jquery-unwrap-plugin/) would be a valuable addition to the core functionality, so he suggested that I add it in, [which I did](http://dev.jquery.com/changeset/6586).

And since I already had the latest jQuery trunk checked out, I decided to poke around. I found (and reported) a few minor bugs, and worked with both Yehuda and John on [rewriting the `$.param` method](http://dev.jquery.com/changeset/6582) to be able to serialize far more than `$.param` currently can in 1.3.2. While not every framework supports the new format, Rails and PHP (at least) are both able to work with this much more robust request param format, and I've even added a `$.param.traditional` flag for backwards compatibility. 

Just so you know, instead of being limited to just scalars and shallow arrays, Rails is also able to deserialize nested hashes, while PHP can do that *and* additionally deserialize nested arrays. At long last, you won't need to set the name of multiple checkbox form elements to `a[]` or create params objects that look like `{ "a[]": [1,2,3] }` anymore, all you'll need to do is name your checkboxes `a`, and a params objects like `{ a: [1,2,3] }` will be serialized to `a[]=1&a[]=2&a[]=3` when the request is made.

But I'm not just posting in order to mention my contributions to the upcoming jQuery 1.4, because I've also been working on some new things!

After looking at how people have been using my [jQuery URL Utils](http://benalman.com/projects/jquery-url-utils-plugin/) plugin, it seemed like a good idea to actually split it up into two separate plugins. One will handle all the history, params, query string and fragment stuff, and the other will handle the urlInternal / urlExternal selector stuff.

Both plugins are nearing completion, and I plan on finalizing the first in the next few days, so stay tuned!
