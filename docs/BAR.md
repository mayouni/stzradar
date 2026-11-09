# The Lookout bar

The Lookout bar puts Lookout's newest notice for a site's readers at the top of any page, from one script line. It
is the same reader Lookout Radar uses, so a site and the Radar show the same checked feed.

```html
<script src="https://mayouni.github.io/lookout/bar/lookout-bar-1.1.0.js"
        integrity="sha384-7/R5PqRB2LH7f40qq531NaFAmP6YxNc9K8WgJT0h9n6Z7KvuzkMxVLsBEwSMuAYv" crossorigin="anonymous"
        data-audience="developer" data-level="advice" data-projects="haro,zane" defer></script>
```

**Another watch.** A project running its own Lookout ([docs/ADOPT.md](ADOPT.md)) uses this same script and names its
own feed and key, so the page pins the key it trusts:

```html
<script src="https://mayouni.github.io/lookout/bar/lookout-bar-1.1.0.js"
        integrity="sha384-7/R5PqRB2LH7f40qq531NaFAmP6YxNc9K8WgJT0h9n6Z7KvuzkMxVLsBEwSMuAYv" crossorigin="anonymous"
        data-feed="https://you.github.io/your-watch/" data-namespace="your-watch-feed"
        data-key="AAAAC3NzaC1lZDI1NTE5AAAAI..." data-audience="developer" defer></script>
```

Version 1.0.0 stays where it was, with its own integrity value, for the pages that already carry it.

Lookout Radar builds this line for you, with a live preview: [Lookout bar](https://mayouni.github.io/lookout/#/bar).

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
4. It shows the most pressing one as plain text, with its level and one link: the entry's page on Lookout, plus a
   link to Lookout Radar when there are more.

It follows every rule of [Showing a notice](FEED.md#showing-a-notice), and its styles live in a shadow root, so the
page and the bar never restyle each other.

## Versions

A published version never changes: `lookout-bar-1.1.0.js` is the same bytes for as long as it exists, and the
`integrity` value above holds the browser to that. A new version is a new file, announced as an entry.
`bar/lookout-bar.js` is the newest version, for a site that prefers to follow it without a pin.

## Reading the feed from a script

The bar's script also gives a page `window.LookoutFeed.load()`, which returns the feed after its signature checks,
and `window.LookoutBar.mount(element, settings)`, which draws the bar inside an element of the page's choosing.
Load it with `data-no-bar` to get those two without the bar.
