# The Lookout bar

The Lookout bar puts the newest notice of Softanza Radar for a site's readers at the top of any page, from one
script line. It is the same reader the radar site uses, so a site and the radar show the same checked feed.

```html
<script src="https://mayouni.github.io/lookout/bar/lookout-bar-1.2.0.js"
        integrity="sha384-41Km1SPZGI7Qg1kYW6NYIVash8x+kLEzSXCb9OX2JR7zRQ6eUnAZZn/ZlR+6hiIW" crossorigin="anonymous"
        data-audience="developer" data-level="advice" data-projects="haro,zane" defer></script>
```

**Another watch.** A project running its own Lookout ([docs/ADOPT.md](ADOPT.md)) uses this same script and names its
own feed and key, so the page pins the key it trusts:

```html
<script src="https://mayouni.github.io/lookout/bar/lookout-bar-1.2.0.js"
        integrity="sha384-41Km1SPZGI7Qg1kYW6NYIVash8x+kLEzSXCb9OX2JR7zRQ6eUnAZZn/ZlR+6hiIW" crossorigin="anonymous"
        data-feed="https://you.github.io/your-watch/" data-namespace="your-watch-feed"
        data-key="AAAAC3NzaC1lZDI1NTE5AAAAI..." data-audience="developer" defer></script>
```

Versions 1.0.0 and 1.1.0 stay where they were, with their own integrity values, for the pages that already carry
them. Version 1.2.0 names the watch by its feed's `title` (here, Softanza Radar), and its links are underlined at
normal weight.

The radar site builds this line for you, with a live preview: [Make your own](https://mayouni.github.io/lookout/#/yours).

## The settings

| Attribute | Values | Default |
|---|---|---|
| `data-audience` | `developer`, `user`, `learner`, `maintainer`: whose notice is shown | `developer` |
| `data-level` | `info`, `advice`, `action`, `urgent`: the lowest level shown | `advice` |
| `data-projects` | project ids or aliases from the watch's map, comma-separated: only signals touching one of them | every project |
| `data-feed` | another watch's site, ending in `/` | Lookout's |
| `data-key` | that watch's public key: the base64 after `ssh-ed25519` | Lookout's key |
| `data-namespace` | that watch's signing namespace | `lookout-feed` |

The attributes go on the script tag, or on an element carrying `data-lookout-bar`, which also says where the bar
goes. With that element absent, the bar goes at the top of `<body>`, in the page's flow.

To match a site's colours, set `--lookout-accent`, `--lookout-bg` and `--lookout-ink` on that element. The bar takes
the page's own font.

## What it does, in order

1. It fetches `feed/index.json` and `feed/index.json.sig`, at most once a day per browser, and keeps them in the
   browser's storage.
2. It checks the SSH signature (Ed25519, through the browser's Web Crypto) against the key written into the script,
   fingerprint `SHA256:ZUij0xoxJIIEwH3AV5xrDXkJLuEklao7pUVhTxCs49I`, on every read, the stored copy included. A feed
   that fails the check shows nothing, and the reason goes to the browser's console.
3. It keeps live entries (within `review_by`, and neither declined nor superseded) that carry a notice for the
   audience, at or above the level, touching the projects asked for, and leaves out the ones the reader dismissed.
4. It shows the most pressing one as plain text, with its level and one link: the entry's own page, plus a link
   to the radar site when there are more. It names the watch by the feed's `title`, or `Lookout` when there is none.

It follows every rule of [Showing a notice](FEED.md#showing-a-notice), and its styles live in a shadow root, so the
page and the bar never restyle each other.

## Versions

A published version never changes: `lookout-bar-1.2.0.js` is the same bytes for as long as it exists, and the
`integrity` value above holds the browser to that. A new version is a new file, announced as an entry.
`bar/lookout-bar.js` is the newest version, for a site that prefers to follow it without a pin.

## Reading the feed from a script

The bar's script also gives a page `window.LookoutFeed.load()`, which returns the feed after its signature checks,
and `window.LookoutBar.mount(element, settings)`, which draws the bar inside an element of the page's choosing.
Load it with `data-no-bar` to get those two without the bar.
