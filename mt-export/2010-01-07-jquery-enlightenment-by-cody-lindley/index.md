title: "jQuery Enlightenment by Cody Lindley"
categories: [ Code, News ]
tags: [ book, jquery, rant, review ]
date: 2010-01-07 16:29:34 -0500
_primary_category: News
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Recently, [Cody Lindley](http://codylindley.com/) asked me to take a look at his new book, [jQuery Enlightenment](http://jqueryenlightenment.com/), and write up my thoughts. Now, I've never written a book review before, but since I've spent a lot of time helping novice [jQuery](http://jquery.com/) users understand programming and design concepts as they relate to both jQuery and JavaScript, I saw this as a good opportunity for me to weigh in on a book written for exactly those people.

<!--MORE-->

People who know me might find this hard to believe, but I *can* make a long story short. Before I go any further, I'm going to simply recommend the book:

[jQuery Enlightenment](http://jqueryenlightenment.com/) is a fantastic resource for designers and beginner/intermediate developers to learn more about how to use jQuery. The prose and excellent examples in the book cover selecting elements, traversing the DOM, manipulating elements, handling events, visual effects and more.

If you understand HTML and CSS but are relatively new to JavaScript, jQuery Enlightenment will definitely get you going in the right direction, and then some. And for somewhat more advanced users, the book covers the basics of plugin authoring, performance improvement techniques, and AJAX functionality. It's a great value (especially at that price) so [pick up a copy now](http://jqueryenlightenment.com/)!

### Ok, that was the book review part of this book review ###

So, time for the long story. I'm going to start by saying that I've got a few issues. Note that I didn't say, "I've got a few issues with Cody's book," because that's not exactly where my issues exist. Well, maybe they do. I'm not sure.

jQuery has a remarkably wide target audience. Its ease-of-use, combined with a fantastic reach, plethora of how-to articles and books, and good documentation really help jQuery reach a very large and diverse group of people. While a graphic designer with very little JavaScript experience can use jQuery to animate some nav buttons or fade in a few images, a seasoned developer can use jQuery to facilitate the creation of complex event-driven single-page web applications.

Of course, because of the broad appeal of jQuery, books and tutorials written for the designer/beginner end of the spectrum aren't necessarily appropriate for the developer/advanced end of the spectrum. And while this seems to be generally true of educational content geared towards front-end web development, it seems to be very specifically true for content written for jQuery.

Now this is just the setup, I warned you that it was a long story. And none of this, yet, has anything to do with jQuery Enlightenment, which "was written to express, in short-order, the concepts essential to intermediate and advanced jQuery development," and in my opinion, does exactly that.

### But I do have a nit to pick ###

Say we have a reference to a DOM element, but we want to manipulate it using all those fantastic jQuery methods that we've come to know and love. Well, you can't just call `elem.css()` on the DOM element, because DOM elements don't have jQuery's methods, they have their own methods. So what do you do? You "wrap" the element "with jQuery" and call the method like so: `$(elem).css()`.

Right? Well, sure, that's what we do. And when you explain to a novice developer the whole idea of "wrapping" elements "with jQuery," they get it, because that's what is happening. And now that they understand what's really happening, they can go on to write lots of code and be productive.

Except for one thing, of course. That's not _really_ what's happening. Not even close.

While the characters in your JavaScript show a dollar sign and parens "wrapping" a DOM element reference, internally, there isn't really anything wrapping anything. What's really happening is that a reference to a newly-instantiated jQuery object is returned, replete with all the methods and properties defined on `jQuery.fn`. This object, internally, contains an array of references to zero or more (in this case, one) DOM elements.

Ok, so you can't say that to a beginning jQuery user. They don't know what "instantiate" means. They barely understand "method" and "property." They do understand, at least on the surface, what "wrap that DOM element with jQuery to do jQuery things," means, which at least gets them moving in the right direction. And you've got to go with what works, which is to talk about "wrapper sets" (Cody's term) despite the fact that it makes things just a little bit harder later on.

So, this is where this becomes "my issue" and not necessarily an issue with jQuery Enlightenment or any other book. In helping designers and developers in the #jquery IRC channel on irc.freenode.net, I encounter a lot of people who think in terms of this "wrapper set" kind of mentality, and I find that there's some inherent communications issues because of it.

They ask questions, using the terms "cache" or "alias" instead of "reference." They talk about "stacking selector filters," when they in fact mean "selecting the intersection of multiple filters" or even just "logical and." They talk about "wrapper sets" instead of "jQuery objects."

It not only makes it hard to understand what people mean, because they're using non-standard terminology, but it also makes it hard to explain things to them, because they don't necessarily grasp the concepts that a more experienced developer understands.

Of course, this responsibility for explaining advanced development concepts doesn't really fall within the purview of a book such as jQuery Enlightenment, but I do think that every effort should be made to use standard terminology whenever possible, to facilitate future learning and communication.

### That being said... ###

I'm still going to absolutely recommend [jQuery Enlightenment](http://jqueryenlightenment.com/). While I might not agree with all the terminology choices made in the book, I do think Cody's concepts and approach are solid, and the book is well-written with lots of great _online_ code examples. And for the price, you really can't beat it. It's a great value, so [pick up a copy now](http://jqueryenlightenment.com/)!

