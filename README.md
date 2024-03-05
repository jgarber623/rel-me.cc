# rel-me.cc

**Discover a URL's published rel=“me” links.**

[![Build](https://img.shields.io/github/actions/workflow/status/jgarber623/rel-me.cc/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/jgarber623/rel-me.cc/actions/workflows/ci.yml)
[![Deployment](https://img.shields.io/github/deployments/jgarber623/rel-me.cc/production?label=Deployment&logo=github&style=for-the-badge)](https://github.com/jgarber623/rel-me.cc/deployments/activity_log?environment=production)

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

## Acknowledgments

rel-me.cc wouldn't exist without the hard work put in by everyone involved in the [IndieWeb](https://indieweb.org) and [microformats](https://microformats.org) communities.

Text is set using [Alfa Slab One](https://fonts.google.com/specimen/Alfa+Slab+One) and [Gentium Book Basic](https://fonts.google.com/specimen/Gentium+Book+Basic) which are provided by [Google Fonts](https://fonts.google.com). Iconography is from [Font Awesome](https://fontawesome.com)'s icon set.

rel-me.cc is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

rel-me.cc is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
