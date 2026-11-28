# unkernel compiles the Linux 7 kernel to one WebAssembly module with a real MMU, boots it to a shell in under a second in a browser tab or in Node, and runs unmodified Alpine and Debian aarch64 programs on an emulated processor with a JIT

```json
{
  "id": "2026-11-28-unkernel-linux-wasm",
  "date": "2026-11-28",
  "title": "unkernel compiles the Linux 7 kernel to one WebAssembly module with a real MMU, boots it to a shell in under a second in a browser tab or in Node, and runs unmodified Alpine and Debian aarch64 programs on an emulated processor with a JIT",
  "kind": "release",
  "summary": "unkernel, by Pooya Parsa and sponsored by Vercel's open source programme, builds Linux 7.x as a single WebAssembly module with page tables and a real MMU, grown from Joel Severin's arch/wasm port. The kernel is compiled, not emulated; user programs are unmodified aarch64 Linux binaries run on kwemu, an emulated processor written in Zig and linked into the kernel, whose JIT compiles hot code to WebAssembly. The kernel reaches /init in about 70 ms, and an Alpine prompt appears 0.3 s after Node starts; getppid takes about 170 ns against 110 natively and fork with exit and wait about 60 microseconds. Several processors run as threads on shared memory, about 3 times faster with 4 on parallel work. The root is a read-only erofs image under a persistent ext4 disk; in the browser writes are kept in IndexedDB. Networking runs Linux's own TCP/IP through a Wisp proxy in the browser or host sockets in Node. The repository (pithings/unkernel, GPL-2.0 on GitHub, opened 2026-11-12) is public. The figures are the author's own.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A real Linux, with its packages, can now run in a browser tab or a Node process with nothing installed: about 10 MB to download, a shell in under a second, and a disk that keeps its changes. Expect CPU-heavy programs to run well behind native, since user code is emulated.",
    "maintainer": "Harobanda declares the machine an application runs on. unkernel adds a machine that exists only inside a browser tab or a Node process, with real Linux semantics, persistence and networking through a proxy: a target to measure for trying a Softanza application with nothing installed."
  },
  "areas": ["harobanda"],
  "domains": ["devices", "web"],
  "concerns": ["sovereignty", "cost", "speed"],
  "actions": [
    {"area": "harobanda", "do": "measure unkernel as a declared machine: run a Linux aarch64 build of a Softanza tool under it in Node and in the browser, and record boot to first output, the tool's run time against native, memory held, and whether its files persist across reloads", "state": "routed", "dates": {"proposed": "2026-11-28", "routed": "2026-11-28"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "unkernel", "url": "https://unkernel.dev/", "by": "Pooya Parsa", "read": "2026-11-28"},
    {"title": "unkernel documentation", "url": "https://docs.unkernel.dev/", "by": "Pooya Parsa", "read": "2026-11-28"},
    {"title": "pithings/unkernel", "url": "https://github.com/pithings/unkernel", "by": "Pooya Parsa", "read": "2026-11-28"}
  ],
  "review_by": "2027-02-28",
  "tags": ["webassembly", "linux", "browser", "emulation", "jit", "sandbox", "zig"]
}
```

## What happened

Pooya Parsa published unkernel, sponsored by Vercel's open source programme: the Linux kernel built as one WebAssembly
module, running in a browser tab or in Node. The repository opened on GitHub on November 12, 2026.

- **The kernel.** Linux 7.x with page tables and a real MMU, grown from Joel Severin's arch/wasm port. Each extra
  processor is a thread on shared memory and costs 9 MiB of guest memory; 4 processors run parallel work about 3 times
  faster, and 8 or 16 add little.
- **The programs.** Unmodified aarch64 Linux binaries, from Alpine and Debian packages, run on kwemu, an emulated
  processor written in Zig and linked into the kernel. A JIT compiles hot code, including AES, PMULL and SHA
  instructions, to WebAssembly.
- **The disks.** A read-only distribution image packed with erofs sits under a persistent ext4 disk that holds the
  changes. In the browser an image is read over HTTP by ranges and writes are kept in IndexedDB.
- **The network.** Off by default. The guest runs Linux's own TCP/IP stack; in the browser it reaches the outside
  through a Wisp proxy, which sees host names, ports and plain HTTP while TLS stays end to end, and in Node through
  host sockets. Inbound access goes through vsock.

The author's measures, taken on 14 and 18 November 2026:

| measure | unkernel | native | QEMU system emulation |
|---|---|---|---|
| getppid | about 170 ns | 110 ns | 1.7 microseconds |
| fork, exit and wait | about 60 microseconds | about 70 | 1.2 ms |

The kernel reaches /init about 70 ms after start, and the Alpine prompt appears 0.3 s after Node launches. The browser
demo downloads about 10 MB. It needs WebAssembly's JS Promise Integration: Node 24, Chrome and Edge 137, Firefox 153,
Safari 27 or later.

## Why it matters to Softanza

Harobanda declares the machine an application runs on. unkernel makes that machine a browser tab or a Node process,
with real Linux system calls, packages, a disk that persists and a network through a proxy whose view is known. Its
system calls run close to native while its user code is emulated, which tells Harobanda what such a machine is good
for: tools and shells first, CPU-heavy work on a native machine.

## What we do

- Route to Harobanda: measure unkernel as a declared machine, with a Linux aarch64 build of a Softanza tool, in Node
  and in the browser.
- Look again by 2027-02-28.

## Sources

- Pooya Parsa, [unkernel](https://unkernel.dev/), booted in a browser tab on 2026-11-28; its
  [documentation](https://docs.unkernel.dev/), introduction and SDK pages on workers, disks, network and options, read
  2026-11-28 through a summarising reader; and the [repository](https://github.com/pithings/unkernel), whose licence
  GitHub reports as GPL-2.0. All figures are the author's own.
