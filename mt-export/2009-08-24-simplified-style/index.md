title: "Simplified: a Linkinus Style"
categories: [ Misc, Projects ]
tags: [ css, javascript, linkinus, project, web ]
date: 2009-08-24 21:20:31 -0500
_primary_category: Projects
_allow_comments: 1
_allow_pings: 1
_published: Publish
--- |

Simplified is a WebKit message style for the popular OS X [Linkinus][linkinus] IRC application. While developed independently of the Linkinus app, great effort was spent working with the app development team to not only tailor Simplified to it, but to also enhance the app style API for Simplified and other message styles. As a result, the Simplified source is modular and well-organized, and style authors are encouraged to use Simplified as a framework for building their own styles.

 [linkinus]: http://conceitedsoftware.com/products/linkinus

<!--MORE-->

Simplified is included with Linkinus 2.0.2 and newer, but updates will made available here first as the style is updated.

Latest version: [Simplified v2.2.1][latest]

[latest]: https://github.com/cowboy/Simplified.lnk2Style/zipball/v2.2.1

Simplified was designed with these goals in mind:

 * The display has to be simple, clean, and colorful.
 * The user needs to be able to recognize his own text easily.
 * Non-chat text (timestamps, joins, parts, etc) should be obvious, but shouldn't distract from chat messages.
 * The user should be able to copy & paste IRC chat into other apps without weird formatting issues.

In addition to meeting these goals, Simplified also supports:

 * Nearly all [Linkinus][linkinus] style options, including the new 2.0.2 variants feature.
 * Short-URL auto expansion (full URL visible on hover).
 * Smooth scrolling animations.
 * [Adium Emoticon][emoticons] support using my [Javascript Emotify][emotify] code.
 * Exploding emoticons - just click them!
 * Clicking on a nickname will spotlight that user's text in that channel.

## Installation Instructions ##

 1. Download [the latest version][latest] (.zip) and extract it.
 2. Rename the created folder to `Simplified.lnk2Style`.
 3. Double-click to install in Linkinus.

Also, feel free to visit [#linkinus on irc.conceited.net](irc://irc.conceited.net/linkinus) for style testing and discussion!

## Variants: Light, Dark and Stealth ##

Simplified supports variants, and as such comes with three. Choose whichever suits you. Let me know if you create a good one, and I might include it in the next version!

### Light ###
![Light Variant](/images/simplified/light.gif)

### Dark ###
![Dark Variant](/images/simplified/dark.gif)

### Stealth ###
![Stealth Variant](http://gyazo.com/b1e4edf6728596ed4235f96c2b2bda56.png)

## Channel topic ##

By default, the topic is hidden to save space, but is easily revealed by hovering over the top area of the channel.

![Topic](/images/simplified/topic.gif)

## Short URLs, lengthened ##

Short URLs can be a bit of a mystery. They use less characters, and as such are suited for communications media where character limits are important (IM, IRC, Twitter, etc). Unfortunately, you have no idea where you're going when you click one of them.. until now. Just hover over any shortened link to see its long URL (if that URL is available).

![Long URL](/images/simplified/long-url.gif)

## Spotlight: like highlight, but different ##

When chatting with someone in a busy channel, sometimes it's hard to follow their messages because other conversations are going on at the same time. Instead of taking it into a private message, just click that user's nickname to spotlight all their messages in that channel (there is a style option to "Spotlight user messages on hover" but it's better on click. Believe me!)

### Before ###
![Spotlight: before](/images/simplified/spotlight.gif)

### After ###
![Spotlight: after](/images/simplified/spotlighted.gif)

Much nicer!

## Starring ##

[Linkinus][linkinus] supports "starring" a message, which effectively saves it for later (you can see all starred and highlighted messages by pressing command-1 in the app). In order to keep Simplifed's interface clean, the star/unstar button is a small area to the right of every message, and shows up as a green message highlight or green tab.

### Before ###
![Starring: before](/images/simplified/star.gif)

### After ###
![Starring: after](/images/simplified/starred.gif)

## Emoticons ##

Simplified brings [Adium Emoticon][emoticons] support to [Linkinus][linkinus] by way of my [Javascript Emotify][emotify] code. Just place any Adium Emoticon package (except for the iChat one, it won't work) in your `~/Library/Application Support/Linkinus 2/Emoticons/` folder, and rename it to `Linkinus.AdiumEmoticonset`. After doing this, re-apply the style. Hovering over an emoticon will show you its description and triggerening text, and clicking an emoticon will explode it!

![Emoticons](/images/simplified/smiley.gif)

## Simplified as a style framework ##

If you'd like to use Simplified as the basis for your [Linkinus][linkinus] style, feel free. It's licensed under the MIT License, which is explained in detail on the [license page](http://benalman.com/about/license/). All I ask is that you give credit where it's due! The style contents should be fairly self-explanatory, but here are a few notes:

 * `Info.plist` and `README.TXT` should be modified to reflect your style's information. Please keep all Simplified license notices intact.
 * `Variants.plist` should be modified to reflect your style's variants and default variant.
 * One `.html` file exists for each of the six different views. Take care to modify them all as-needed.
 * `js/api.js` acts as a bridge between all the style modules and the app. It contains methods that the app knows about (or should know about in the near future).
 * `js/settings.js` contains additional style configuration options. Eventually, the app will create this data object based on in-app per-style preferences, but until that happens, it's an external file.
 * Each JavaScript file in the `js/core` directory represents a main functionality module.
 * The `js/jquery` folder contains the jQuery 1.3.2 source.
 * The `js/plugin` folder contains assorted JavaScript and jQuery plugins (all of which are currently documented or will be documented on my site)
 * The `css` folder contains the base `style.css` CSS file along with a `variants` folder containing files with only variant-specific CSS.

## Notes ##

If you have any comments or suggestions, please post them in the comments on this page! And while I've designed Simplified to meet specific goals, I'm always open to new ideas. If you have an additional variant, for example, let me know and I'll add it in if I like it.

Also, I strongly recommend that you disable "Group consecutive messages" and "Spotlight user messages on hover" in the app prefs. While these will both work, the style was designed to show a user nickname for every chat message, as well as spotlight user messages on click, not hover.

Outstanding to-dos:

 * Fix outstanding linkification issues.
 * Add "embed media" support.

## A simple request ##

I just have one simple request for you, the user. If you use Simplified or base a new style on it, and like it enough to consider donating, please do! I've spent many hours working on not just this style's design and code, but also working with the [Linkinus][linkinus] app developers on enhancing the style API.

<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
  <input type="hidden" name="cmd" value="_s-xclick">
  <input type="hidden" name="hosted_button_id" value="5791421">
  <input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif" name="submit" alt="PayPal - The safer, easier way to pay online!">
  <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>

Thanks!

 [linkinus]: http://conceitedsoftware.com/products/linkinus
 [emoticons]: http://www.adiumxtras.com/index.php?a=search&cat_id=2&sort=downloads
 [emotify]: http://benalman.com/projects/javascript-emotify/