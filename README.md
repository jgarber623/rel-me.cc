# rel-me.cc

**Discover a URL's published rel=“me” links.**

[![Build](https://img.shields.io/github/actions/workflow/status/jgarber623/rel-me.cc/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/jgarber623/rel-me.cc/actions/workflows/ci.yml)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/jgarber623/rel-me.cc.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/jgarber623/rel-me.cc)
[![Coverage](https://img.shields.io/codeclimate/c/jgarber623/rel-me.cc.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/jgarber623/rel-me.cc/code)
[![Vulnerabilities](https://img.shields.io/snyk/vulnerabilities/github/jgarber623/rel-me.cc.svg?logo=snyk&style=for-the-badge)](https://snyk.io/test/github/jgarber623/rel-me.cc)

## Usage

There are a couple of ways you can use rel-me.cc:

You may point your browser at [the website](https://rel-me.cc), enter a URL into the search form, and submit! You could also hack on the URL itself and throw something like this at your browser's URL bar:

```text
https://rel-me.cc/search?url=https://sixtwothree.org
```

Lastly, if you're comfortable working on the command line, you can query the service directly using a tool like [curl](https://curl.haxx.se):

```sh
curl --header 'Accept: application/json' --silent 'https://rel-me.cc/search?url=https://sixtwothree.org'
```

…or [Wget](https://www.gnu.org/software/wget/):

```sh
wget --header 'Accept: application/json' --quiet -O - 'https://rel-me.cc/search?url=https://sixtwothree.org'
```

The above command will return a [JSON](https://json.org) array with the results of the search:

```json
[
  "https://sixtwothree.org/",
  "mailto:jason@sixtwothree.org",
  "https://www.flickr.com/photos/jgarber",
  "https://atom.io/users/jgarber623",
  "https://bandcamp.com/jgarber",
  "…"
]
```

## Improving rel-me.cc

You want to help make rel-me.cc better? Hell yeah! I like your enthusiasm. For more on how you can help, check out [CONTRIBUTING.md](https://github.com/jgarber623/rel-me.cc/blob/master/CONTRIBUTING.md).

### Donations

If diving into Ruby isn't your thing, but you'd still like to support rel-me.cc, consider making a donation! Any amount—large or small—is greatly appreciated. As a token of my gratitude, I'll add your name to the [Acknowledgments](#acknowledgments) below.

[![Donate via Square Cash](https://img.shields.io/badge/square%20cash-$jgarber-28c101.svg?style=for-the-badge)](https://cash.me/$jgarber)
[![Donate via Paypal](https://img.shields.io/badge/paypal-jgarber-009cde.svg?style=for-the-badge)](https://www.paypal.me/jgarber)

## Acknowledgments

rel-me.cc wouldn't exist without the hard work put in by everyone involved in the [IndieWeb](https://indieweb.org) and [microformats](https://microformats.org) communities.

Text is set using [Alfa Slab One](https://fonts.google.com/specimen/Alfa+Slab+One) and [Gentium Book Basic](https://fonts.google.com/specimen/Gentium+Book+Basic) which are provided by [Google Fonts](https://fonts.google.com). Iconography is from [Font Awesome](https://fontawesome.com)'s icon set.

rel-me.cc is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

rel-me.cc is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
