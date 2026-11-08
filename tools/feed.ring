# Lookout's feed generator and its check.
#
#   haro tools/feed.ring           check every entry, then regenerate feed/index.json and feed/feed.json
#   haro tools/feed.ring check     check every entry and both committed feeds; write nothing
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
    if cMode != "generate" and cMode != "check"
        see "usage: haro tools/feed.ring [check]" + char(10)
        shutdown(1)
    ok

    oRun = new FeedRun
    oRun.cRoot = currentdir()
    oRun.Go(cMode)

    nMs = floor((clock() - nStart) * 1000 / clockspersecond())
    see "entries accepted " + oRun.nEntries + ", problems " + len(oRun.aProblems) + ", " + nMs + " ms" + char(10)
    shutdown(len(oRun.aProblems))

