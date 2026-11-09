/*! Radar info bar 2.0.0 -- https://github.com/mayouni/stzradar -- MIT
 *
 * One line on any page: the newest Radar notice written for your readers, checked before it is shown.
 *
 *   <script src="https://mayouni.github.io/stzradar/bar/radar-bar-2.0.0.js"
 *           data-audience="developer" data-projects="haro,zane" data-level="advice" defer></script>
 *
 * Any watch built with Radar (docs/ADOPT.md) uses this same script: data-feed names that watch's site and
 * data-key the public key it signs with, so the page that includes the bar pins the key it trusts.
 *
 * Where it goes: inside the first element carrying `data-radar-bar`, or else at the top of <body>, in the
 * page's flow (it never floats over the page). What it does, in the order docs/FEED.md sets:
 *   1. fetches feed/index.json and its signature, at most once a day per browser;
 *   2. checks the SSH signature against the key pinned below, and shows nothing if the check fails;
 *   3. keeps live entries for the chosen audience, level and projects, and drops the ones dismissed;
 *   4. shows one notice as plain text, with one link: the entry's own page.
 * The bar names the watch by data-title when the page gives one, else by the feed's "title", else "Radar".
 * Every piece carries a part name -- bar, name, level, text, link, more, dismiss -- so a page restyles it from its own
 * CSS with [data-radar-bar]::part(name) { ... }; --radar-accent, --radar-bg and --radar-ink set its colours.
 * It also exposes window.RadarFeed.load(), which the radar site uses, so the site and the bar read the
 * feed through the same check.
 */
(function () {
  "use strict";
  var VERSION = "2.0.0";
  var BASE = "https://mayouni.github.io/stzradar/";
  /* the feed key, pinned: keys/allowed_signers, fingerprint SHA256:ZUij0xoxJIIEwH3AV5xrDXkJLuEklao7pUVhTxCs49I */
  var KEY = "AAAAC3NzaC1lZDI1NTE5AAAAIJoTrtZQEdrhJQFEybJGDuZs9DxF/9X/vPE3q2WfEgDK";
  var NAMESPACE = "radar-feed";
  var LEVELS = ["info", "advice", "action", "urgent"];
  var AUDIENCES = ["developer", "user", "learner", "maintainer"];
  var DAY = 864e5;

  /* ------------------------------------------------------------ bytes */
  function b64(s) { var bin = atob(s.replace(/[^A-Za-z0-9+/=]/g, "")); var u = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) u[i] = bin.charCodeAt(i); return u; }
  function reader(u) { var p = 0; return {
    raw: function (n) { if (p + n > u.length) throw new Error("short"); var r = u.subarray(p, p + n); p += n; return r; },
    u32: function () { var r = this.raw(4); return ((r[0] << 24) >>> 0) + (r[1] << 16) + (r[2] << 8) + r[3]; },
    str: function () { return this.raw(this.u32()); } }; }
  function text(u) { return new TextDecoder().decode(u); }
  function same(a, b) { if (a.length !== b.length) return false; for (var i = 0; i < a.length; i++) if (a[i] !== b[i]) return false; return true; }
  function cat(parts) { var n = 0, i; for (i = 0; i < parts.length; i++) n += parts[i].length;
    var out = new Uint8Array(n), p = 0; for (i = 0; i < parts.length; i++) { out.set(parts[i], p); p += parts[i].length; } return out; }
  function sshString(u) { var l = new Uint8Array(4); var n = u.length; l[0] = n >>> 24; l[1] = (n >>> 16) & 255; l[2] = (n >>> 8) & 255; l[3] = n & 255; return cat([l, u]); }
  var enc = function (s) { return new TextEncoder().encode(s); };

  /* ------------------------------------------------------------ the SSH signature (PROTOCOL.sshsig) */
  async function verify(data, armored, keyB64, namespace) {
    keyB64 = keyB64 || KEY; namespace = namespace || NAMESPACE;
    if (!(window.crypto && crypto.subtle)) throw new Error("this browser has no Web Crypto");
    var body = armored.replace(/-----(BEGIN|END) SSH SIGNATURE-----/g, "");
    var r = reader(b64(body));
    if (text(r.raw(6)) !== "SSHSIG" || r.u32() !== 1) throw new Error("not an SSH signature");
    var pub = r.str(), ns = r.str(); r.str(); var hashAlg = text(r.str()), sig = r.str();
    if (!same(pub, b64(keyB64))) throw new Error("signed by another key");
    if (text(ns) !== namespace) throw new Error("signed for another namespace");
    if (hashAlg !== "sha512" && hashAlg !== "sha256") throw new Error("unknown hash");
    var pk = reader(pub); if (text(pk.str()) !== "ssh-ed25519") throw new Error("not an Ed25519 key"); var raw = pk.str();
    var sr = reader(sig); if (text(sr.str()) !== "ssh-ed25519") throw new Error("not an Ed25519 signature"); var s = sr.str();
    var h = new Uint8Array(await crypto.subtle.digest(hashAlg === "sha512" ? "SHA-512" : "SHA-256", data));
    var signed = cat([enc("SSHSIG"), sshString(enc(namespace)), sshString(new Uint8Array(0)), sshString(enc(hashAlg)), sshString(h)]);
    var key = await crypto.subtle.importKey("raw", raw, { name: "Ed25519" }, false, ["verify"]);
    if (!(await crypto.subtle.verify({ name: "Ed25519" }, key, s, signed))) throw new Error("the signature does not match the feed");
    return true;
  }

  /* ------------------------------------------------------------ the feed, checked, at most once a day */
  function store(k, v) { try { if (v === undefined) return JSON.parse(localStorage.getItem("radar:" + k)); localStorage.setItem("radar:" + k, JSON.stringify(v)); } catch (e) { return null; } }
  async function fetchPair(base) {
    var a = await fetch(base + "feed/index.json", { cache: "no-cache" }), b = await fetch(base + "feed/index.json.sig", { cache: "no-cache" });
    if (!a.ok || !b.ok) throw new Error("the feed could not be fetched (" + a.status + ", " + b.status + ")");
    return { bytes: new Uint8Array(await a.arrayBuffer()), sig: await b.text() };
  }
  async function load(opts) {
    opts = opts || {}; var base = opts.base || BASE, now = Date.now();
    var c = opts.fresh ? null : store("feed");
    var pair;
    if (c && c.base === base && now - c.at < DAY) pair = { bytes: b64(c.bytes), sig: c.sig };
    else {
      pair = await fetchPair(base);
      var s = ""; for (var i = 0; i < pair.bytes.length; i += 8192) s += String.fromCharCode.apply(null, pair.bytes.subarray(i, i + 8192));
      store("feed", { base: base, at: now, bytes: btoa(s), sig: pair.sig });
    }
    await verify(pair.bytes, pair.sig, opts.key, opts.namespace);   /* every read is checked, the cached copy too */
    var feed = JSON.parse(text(pair.bytes));
    if (feed.feed !== "radar" || feed.version !== 1) throw new Error("this reader knows feed version 1");
    return feed;
  }
  function live(feed, today) {
    today = today || new Date().toISOString().slice(0, 10);
    return feed.items.filter(function (it) { return it.status !== "declined" && it.status !== "superseded" && it.review_by >= today; });
  }

  /* ------------------------------------------------------------ the bar */
  var CSS = ":host{all:initial;display:block;font:inherit;color:inherit}" +
    ".bar{--lk-accent:var(--radar-accent,#1B6B72);--lk-bg:var(--radar-bg,#EAF4F4);--lk-ink:var(--radar-ink,#10262A);" +
    "display:flex;flex-wrap:wrap;align-items:center;gap:6px 14px;background:var(--lk-bg);color:var(--lk-ink);border-bottom:1px solid color-mix(in srgb,var(--lk-accent) 30%,transparent);" +
    "padding:10px max(16px,env(safe-area-inset-left,0px));font-family:inherit;font-size:max(1rem,16px);line-height:1.45}" +
    "@media (prefers-color-scheme:dark){.bar{--lk-bg:var(--radar-bg,#12282B);--lk-ink:var(--radar-ink,#E3F1F2);--lk-accent:var(--radar-accent,#8FD3D8)}}" +
    ".who{font-weight:700;white-space:nowrap}.who b{color:var(--lk-accent)}" +
    ".lv{font-weight:700;border-radius:6px;padding:1px 8px;background:var(--lk-accent);color:var(--lk-bg);white-space:nowrap}" +
    ".lv.urgent{background:#B42318;color:#fff}.lv.action{background:#B54708;color:#fff}" +
    ".say{flex:1 1 22rem;min-width:0}" +
    "a{color:var(--lk-accent);font-weight:400;text-decoration:underline;white-space:nowrap}" +
    "button{font:inherit;color:inherit;background:transparent;border:1px solid color-mix(in srgb,var(--lk-ink) 30%,transparent);border-radius:6px;padding:2px 10px;cursor:pointer}" +
    "a:focus-visible,button:focus-visible{outline:2px solid var(--lk-accent);outline-offset:2px}";
  var WORD = { info: "to know", advice: "to consider", action: "to do", urgent: "to do now" };

  function pick(items, cfg, dismissed, mapAlias) {
    var min = LEVELS.indexOf(cfg.level);
    return items.filter(function (it) {
      if (LEVELS.indexOf(it.level) < min) return false;
      if (!(it.notice && it.notice[cfg.audience])) return false;
      if (dismissed.indexOf(it.id) >= 0) return false;
      if (cfg.projects.length) {
        var ps = (it.areas || []).map(mapAlias);
        if (!ps.some(function (p) { return cfg.projects.indexOf(p) >= 0; })) return false;
      }
      return true;
    }).sort(function (a, b) { return LEVELS.indexOf(b.level) - LEVELS.indexOf(a.level) || (a.date < b.date ? 1 : a.date > b.date ? -1 : 0); });
  }

  async function aliasFn(projects, base) {
    if (!projects.length) return function (a) { return a; };
    var m = {};
    try { var r = await fetch((base || BASE) + "map/estate.json", { cache: "no-cache" }); var map = await r.json();
      map.projects.forEach(function (p) { m[p.id] = p.id; (p.aliases || []).forEach(function (a) { m[a] = p.id; }); }); } catch (e) {}
    return function (a) { return m[a] || m[a.split(".")[0]] || a.split(".")[0]; };
  }

  function config(a, b) {
    a = a || {}; b = b || {};
    return {
      audience: AUDIENCES.indexOf(a.audience || b.audience) >= 0 ? (a.audience || b.audience) : "developer",
      level: LEVELS.indexOf(a.level || b.level) >= 0 ? (a.level || b.level) : "advice",
      projects: String(a.projects || b.projects || "").split(",").map(function (s) { return s.trim().toLowerCase(); }).filter(Boolean),
      feed: a.feed || b.feed || "",                  /* another watch's site, ending in / */
      key: a.key || b.key || "",                     /* its public key: the base64 after ssh-ed25519 */
      namespace: a.namespace || b.namespace || "",
      title: a.title || b.title || ""                /* the name the bar shows, in the page's own words */
    };
  }

  async function mount(script) {
    var host = document.querySelector("[data-radar-bar]") || document.querySelector("[data-lookout-bar]");   /* the hook's former name still works */
    var cfg = config(host && host.dataset, script && script.dataset);
    if (!host) { host = document.createElement("div"); host.setAttribute("data-radar-bar", ""); host.hidden = true; document.body.insertBefore(host, document.body.firstChild); }
    return mountInto(host, cfg, { base: cfg.feed || undefined, key: cfg.key || undefined, namespace: cfg.namespace || undefined });
  }

  /* opts.base reads another copy of the feed (the radar site reads its own); opts.keepDismissed shows
     dismissed notices again, for a preview */
  async function mountInto(host, cfg, opts) {
    cfg = config(cfg);
    var turn = (host.__radarTurn = (host.__radarTurn || 0) + 1);   /* only the newest mount of a host draws */
    var feed;
    try { feed = await load({ base: opts.base, key: opts.key, namespace: opts.namespace }); } catch (e) { if (window.console) console.info("Radar bar: nothing shown, " + e.message); host.hidden = true; return; }
    var alias = await aliasFn(cfg.projects, opts.base);
    if (turn !== host.__radarTurn) return;
    var title = (cfg.title || (typeof feed.title === "string" && feed.title) || "Radar").replace(/[\u0000-\u001f\u007f]/g, " ");
    var root = host.shadowRoot || host.attachShadow({ mode: "open" });
    function draw() {
      var dismissed = opts.keepDismissed ? [] : (store("dismissed") || []);
      var list = pick(live(feed), cfg, dismissed, alias);
      root.textContent = "";
      if (!list.length) { host.hidden = true; return; }
      host.hidden = false;
      var it = list[0];
      var st = document.createElement("style"); st.textContent = CSS; root.appendChild(st);
      var bar = document.createElement("div"); bar.className = "bar"; bar.setAttribute("part", "bar"); bar.setAttribute("role", "region"); bar.setAttribute("aria-label", title + ": news for this site's " + cfg.audience + "s");
      var who = document.createElement("span"); who.className = "who"; who.setAttribute("part", "name"); var wb = document.createElement("b"); wb.textContent = title; who.appendChild(wb); bar.appendChild(who);
      var lv = document.createElement("span"); lv.className = "lv " + it.level; lv.setAttribute("part", "level " + it.level); lv.textContent = WORD[it.level]; bar.appendChild(lv);
      var say = document.createElement("span"); say.className = "say"; say.setAttribute("part", "text"); say.textContent = String(it.notice[cfg.audience]).replace(/[\u0000-\u001f\u007f]/g, " "); bar.appendChild(say);
      if (/^https:\/\/github\.com\/[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+\/blob\//.test(it.url)) {
        var a = document.createElement("a"); a.href = it.url; a.target = "_blank"; a.rel = "noopener"; a.textContent = "Read it"; a.setAttribute("part", "link"); bar.appendChild(a);
      }
      if (list.length > 1) { var m = document.createElement("a"); m.href = (opts.base || BASE) + "#/week"; m.target = "_blank"; m.rel = "noopener"; m.textContent = (list.length - 1) + " more on " + title; m.setAttribute("part", "link more"); bar.appendChild(m); }
      var x = document.createElement("button"); x.type = "button"; x.textContent = "Dismiss"; x.setAttribute("aria-label", "Dismiss this notice"); x.setAttribute("part", "dismiss");
      x.addEventListener("click", function () { var ds = store("dismissed") || []; ds.push(it.id); store("dismissed", ds); draw(); });
      bar.appendChild(x);
      root.appendChild(bar);
    }
    draw();
  }

  window.RadarFeed = { version: VERSION, load: load, verify: verify, live: live };
  window.RadarBar = { version: VERSION, mount: mountInto };
  var me = document.currentScript;
  if (me && me.hasAttribute("data-no-bar")) return;          /* the radar site loads the checker without the bar */
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", function () { mount(me); });
  else mount(me);
})();
