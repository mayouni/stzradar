# Lookout's feed generator and its check.
#
#   haro tools/feed.ring           check every entry, then regenerate feed/index.json and feed/feed.json
#   haro tools/feed.ring check     check every entry and both committed feeds; write nothing
#   haro tools/feed.ring verify    check that both feed files carry a good signature (docs/FEED.md, "The signature")
#
# Run it from the repository root. The exit code is the number of problems found, so 0 means
# every entry passed, both feeds match their schema, and (in check mode) the committed feeds are
# exactly what the entries generate. The rules are docs/FEED.md; the shapes are schema/.
#
# It is written in Ring syntax and runs on Haro. The work is in tools/feedlib.ring, which needs no
# other library; tools/guard.ring proves that the check refuses broken entries.

load "feedlib.ring"

func main
    nStart = clock()
    cMode = "generate"
    if len(sysargv) >= 3
        cMode = lower(sysargv[3])
    ok
    if cMode != "generate" and cMode != "check" and cMode != "verify"
        see "usage: haro tools/feed.ring [check | verify]" + char(10)
        shutdown(1)
    ok
    if cMode = "verify"
        shutdown(Verify())
    ok

    oRun = new FeedRun
    oRun.cRoot = currentdir()
    oRun.Go(cMode)

    nMs = floor((clock() - nStart) * 1000 / clockspersecond())
    see "entries accepted " + oRun.nEntries + ", problems " + len(oRun.aProblems) + ", " + nMs + " ms" + char(10)
    shutdown(len(oRun.aProblems))


# Both feed files must carry a good SSH signature by the key in keys/allowed_signers, for the
# principal feed@lookout and the namespace lookout-feed. ssh-keygen does the cryptography; this
# only asks it, file by file, and counts what it refuses. Returns the number of problems.
func Verify
    aFiles = ["feed/index.json", "feed/feed.json"]
    nBad = 0
    if not fexists("keys/allowed_signers")
        see "REFUSED keys/allowed_signers: there is no key to check against" + char(10)
        return 1
    ok
    nF = len(aFiles)
    for i = 1 to nF
        cF = aFiles[i]
        if not fexists(cF + ".sig")
            see "REFUSED " + cF + ": it has no signature, " + cF + ".sig" + char(10)
            nBad++
            loop
        ok
        cCmd = "ssh-keygen -Y verify -f keys/allowed_signers -I feed@lookout -n lookout-feed -s " +
               cF + ".sig < " + cF
        if system(cCmd) != 0
            see "REFUSED " + cF + ": its signature does not verify; sign it again after any change" + char(10)
            nBad++
        ok
    next
    see "signatures checked " + nF + ", problems " + nBad + char(10)
    return nBad
