# The guard for tools/feed.ring: every rule of the check is shown refusing an entry broken on
# purpose, and the generator is shown writing the bytes docs/FEED.md fixes.
#
#   haro tools/guard.ring          from the repository root; the exit code is the number of failures
#
# Each broken entry is the real first entry with ONE change, made in memory, so the guard needs
# no fixture files and touches no file. A case passes only when the check refuses the entry for
# the reason the case names; refusing it for another reason is a failure, because a check that
# refuses for the wrong reason would pass a different defect.

load "feedlib.ring"

func main
    nStart = clock()
    oG = new Guard
    oG.cRoot = currentdir()
    # A frozen copy of the first entry as it stood at the bootstrap: the broken copies are made from
    # it, so a correction to the live entry never changes what the guard tests.
    oG.cGood = read(oG.cRoot + "/tools/fixtures/entry.md")
    oG.All()
    nMs = floor((clock() - nStart) * 1000 / clockspersecond())
    see "guard: " + oG.nPass + " passed, " + oG.nFail + " failed, " + nMs + " ms" + char(10)
    shutdown(oG.nFail)

class Guard
    cRoot = ""
    cGood = ""
    cFile = "2026-11-08-lookout-opens.md"
    nPass = 0
    nFail = 0

    func All
        Controls()
        Refusals()
        CrossFile()
        Writing()
        Patterns()
        Affirm()
        Map()

    func Pass cName
        nPass++
        see "  ok    " + cName + char(10)

    func Fail cName, cWhy
        nFail++
        see "  FAIL  " + cName + ": " + cWhy + char(10)

    func NewRun
        oRun = new FeedRun
        oRun.cRoot = cRoot
        oRun.bQuiet = 1
        oRun.Prepare()
        return oRun

    # The good entry with exactly one change. Returns "" if the change did not apply, so a case
    # whose text drifted from the entry fails instead of testing nothing.
    func Broken cOld, cNew
        if substr(cGood, cOld) = 0 return "" ok
        return substr(cGood, cOld, cNew)

    func Joined aProblems
        c = ""
        n = len(aProblems)
        for i = 1 to n
            c += aProblems[i] + " | "
        next
        return c

    # One entry text, one expected reason.
    func Refuses cName, cText, cYear, cFileName, cReason
        if cText = ""
            Fail(cName, "the change did not apply to the entry's text")
            return
        ok
        oRun = NewRun()
        oRun.AddEntryText("items/" + cYear + "/" + cFileName, cYear, cFileName, cText)
        oRun.Finish("none")
        if len(oRun.aProblems) = 0
            Fail(cName, "the check accepted it")
            return
        ok
        if substr(Joined(oRun.aProblems), cReason) = 0
            Fail(cName, "refused, but not for this reason: " + Joined(oRun.aProblems))
            return
        ok
        Pass(cName)

    func RefusesOne cName, cOld, cNew, cReason
        Refuses(cName, Broken(cOld, cNew), "2026", cFile, cReason)

    # ------------------------------------------------------------ the control
    func Controls
        oRun = NewRun()
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        oRun.Finish("none")
        if len(oRun.aProblems) > 0
            Fail("control: the real entry passes", Joined(oRun.aProblems))
            return
        ok
        Pass("control: the real entry passes")

        # every entry in items/, built in memory, must give the committed bytes
        oRun = NewRun()
        oRun.ReadEntries()
        oRun.Finish("none")
        if len(oRun.aProblems) > 0
            Fail("control: every entry in items/ passes", Joined(oRun.aProblems))
            return
        ok
        Pass("control: every entry in items/ passes (" + oRun.nEntries + ")")
        if oRun.cIndex = read(cRoot + "/feed/index.json")
            Pass("control: in memory, index.json is the committed bytes")
        else
            Fail("control: in memory, index.json is the committed bytes", "they differ")
        ok
        if oRun.cFeed = read(cRoot + "/feed/feed.json")
            Pass("control: in memory, feed.json is the committed bytes")
        else
            Fail("control: in memory, feed.json is the committed bytes", "they differ")
        ok

    # ------------------------------------------------------------ one entry, one defect
    func Refusals
        q = '"'
        NL1 = char(10)

        # notice: one sentence per audience listed, and only for those
        RefusesOne("notice speaks to an audience that is not listed",
            q + "maintainer" + q + ": " + q + "Lookout is open",
            q + "user" + q + ": " + q + "A sentence for a user." + q + "," + NL1 + "    " + q + "maintainer" + q + ": " + q + "Lookout is open",
            "notice has a sentence for user, which audiences does not list")
        RefusesOne("an audience listed has no notice",
            q + "learner" + q + ": " + q + "There is now one place that explains, in plain words, what changes in AI mean for what you learn with Softanza." + q + "," + NL1 + "    ",
            "",
            "audiences lists learner, and notice has no sentence for it")
        RefusesOne("an audience that does not exist",
            q + "developer" + q + "," + NL1,
            q + "developer" + q + "," + NL1 + "    " + q + "robot" + q + "," + NL1,
            q + "robot" + q + " is not one of")

        # the schema's values
        RefusesOne("a stance outside the list",
            q + "stance" + q + ": " + q + "adopt" + q, q + "stance" + q + ": " + q + "embrace" + q,
            q + "embrace" + q + " is not one of")
        RefusesOne("a level outside the list",
            q + "level" + q + ": " + q + "info" + q, q + "level" + q + ": " + q + "critical" + q,
            q + "critical" + q + " is not one of")
        RefusesOne("a required field is missing",
            q + "confidence" + q + ": " + q + "read" + q + "," + NL1 + "  ", "",
            "is missing confidence")
        RefusesOne("an id with capitals",
            q + "2026-11-08-lookout-opens" + q, q + "2026-11-08-Lookout-Opens" + q,
            "does not match")
        RefusesOne("a day that does not exist",
            q + "date" + q + ": " + q + "2026-11-08" + q, q + "date" + q + ": " + q + "2026-02-30" + q,
            "is not a date")
        RefusesOne("a source that is not https",
            q + "url" + q + ": " + q + "https://github.com/mayouni/lookout" + q + ",",
            q + "url" + q + ": " + q + "http://github.com/mayouni/lookout" + q + ",",
            "does not match ^https://")
        RefusesOne("an empty title",
            q + "title" + q + ": " + q + "Lookout opens: a public watch on AI, read from Softanza's point of view" + q,
            q + "title" + q + ": " + q + q,
            "is shorter than 1 characters")

        # the JSON itself
        RefusesOne("a trailing comma", q + "notices" + q + NL1, q + "notices" + q + "," + NL1,
            "is not valid JSON")
        RefusesOne("a key written twice",
            q + "kind" + q + ": " + q + "idea" + q + ",",
            q + "kind" + q + ": " + q + "idea" + q + "," + NL1 + "  " + q + "kind" + q + ": " + q + "paper" + q + ",",
            "the key kind is written twice")
        RefusesOne("no json block", "```json", "```text", "has no fenced json block")
        RefusesOne("a json block never closed", NL1 + "```" + NL1 + NL1 + "## What happened", NL1 + NL1 + "## What happened",
            "its json block is never closed")

        # what docs/FEED.md says and the schema cannot
        Refuses("a file not named after its id", cGood, "2026", "wrong-name.md",
            "the file is named after its id")
        Refuses("an entry in the wrong year folder", cGood, "2025", cFile,
            "lives in items/2026/")
        RefusesOne("an id that does not start with its date",
            q + "date" + q + ": " + q + "2026-11-08" + q, q + "date" + q + ": " + q + "2026-11-07" + q,
            "the id starts with the entry's date")
        RefusesOne("an entry that writes its own url",
            q + "review_by" + q + ": " + q + "2027-05-08" + q + ",",
            q + "review_by" + q + ": " + q + "2027-05-08" + q + "," + NL1 + "  " + q + "url" + q + ": " + q + "https://github.com/mayouni/lookout/x" + q + ",",
            "an entry does not write its url")
        RefusesOne("review_by before the entry's date",
            q + "review_by" + q + ": " + q + "2027-05-08" + q, q + "review_by" + q + ": " + q + "2026-11-01" + q,
            "must come after the entry's date")
        RefusesOne("updated before the entry's date",
            q + "updated" + q + ": " + q + "2026-11-08" + q, q + "updated" + q + ": " + q + "2026-11-07" + q,
            "is before the entry's date")
        RefusesOne("supersedes an id that does not exist",
            q + "review_by" + q + ": ",
            q + "supersedes" + q + ": " + q + "2026-01-01-nothing" + q + "," + NL1 + "  " + q + "review_by" + q + ": ",
            "there is no entry with that id")

    # ------------------------------------------------------------ across files
    func CrossFile
        oRun = NewRun()
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        oRun.Finish("none")
        if substr(Joined(oRun.aProblems), "is already used by") > 0
            Pass("two entries with one id")
        else
            Fail("two entries with one id", "not refused for that: " + Joined(oRun.aProblems))
        ok

    # ------------------------------------------------------------ the bytes written
    func Second cDate, cUpdated
        q = '"'
        cId = cDate + "-second"
        c = substr(cGood, q + "2026-11-08-lookout-opens" + q, q + cId + q)
        c = substr(c, q + "date" + q + ": " + q + "2026-11-08" + q, q + "date" + q + ": " + q + cDate + q)
        c = substr(c, q + "updated" + q + ": " + q + "2026-11-08" + q, q + "updated" + q + ": " + q + cUpdated + q)
        return c

    func Writing
        q = '"'
        # escapes in, UTF-8 out; a tab goes back out escaped
        cText = Broken(q + "summary" + q + ": " + q + "Softanza opened",
                       q + "summary" + q + ": " + q + "Café 😀 tab\there. Softanza opened")
        oRun = NewRun()
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cText)
        oRun.Finish("none")
        cWant = "Caf" + char(195) + char(169) + " " + char(240) + char(159) + char(152) + char(128) + " tab\there."
        if len(oRun.aProblems) = 0 and substr(oRun.cIndex, cWant) > 0
            Pass("\u escapes are written as UTF-8, a tab as \t")
        else
            Fail("\u escapes are written as UTF-8, a tab as \t", Joined(oRun.aProblems))
        ok

        # newest date first; updated is the newest day; date_modified only when it differs
        oRun = NewRun()
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        cTwo = Second("2026-11-09", "2026-11-10")
        oRun.AddEntryText("items/2026/2026-11-09-second.md", "2026", "2026-11-09-second.md", cTwo)
        oRun.Finish("none")
        if len(oRun.aProblems) > 0
            Fail("two entries build", Joined(oRun.aProblems))
            return
        ok
        nNew = substr(oRun.cIndex, q + "2026-11-09-second" + q)
        nOld = substr(oRun.cIndex, q + "2026-11-08-lookout-opens" + q)
        if nNew > 0 and nNew < nOld
            Pass("the newer entry comes first")
        else
            Fail("the newer entry comes first", "it does not")
        ok
        if substr(oRun.cIndex, q + "updated" + q + ": " + q + "2026-11-10T00:00:00Z" + q) > 0
            Pass("the index's updated is the newest updated, at midnight UTC")
        else
            Fail("the index's updated is the newest updated, at midnight UTC", "it is not")
        ok
        if substr(oRun.cFeed, q + "date_modified" + q + ": " + q + "2026-11-10T00:00:00Z" + q) > 0
            Pass("feed.json writes date_modified when updated differs from date")
        else
            Fail("feed.json writes date_modified when updated differs from date", "it does not")
        ok
        oOne = NewRun()
        oOne.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        oOne.Finish("none")
        if substr(oOne.cFeed, "date_modified") = 0
            Pass("feed.json writes no date_modified when updated equals date")
        else
            Fail("feed.json writes no date_modified when updated equals date", "it does")
        ok

        # the same day: by id
        oRun = NewRun()
        cA = Second("2026-11-08", "2026-11-08")
        oRun.AddEntryText("items/2026/2026-11-08-second.md", "2026", "2026-11-08-second.md", cA)
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cGood)
        oRun.Finish("none")
        nA = substr(oRun.cIndex, q + "2026-11-08-lookout-opens" + q)
        nB = substr(oRun.cIndex, q + "2026-11-08-second" + q)
        if len(oRun.aProblems) = 0 and nA > 0 and nA < nB
            Pass("on one day, entries go by id")
        else
            Fail("on one day, entries go by id", Joined(oRun.aProblems))
        ok

    # ------------------------------------------------------------ the pattern matcher
    func Patterns
        aCases = [
            ["^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$", "2026-11-08-lookout-opens", 1],
            ["^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$", "2026-11-08-lookout-", 0],
            ["^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$", "2026-11-8-lookout", 0],
            ["^[a-z0-9]+(\.[a-z0-9-]+)*$", "stzlib.security", 1],
            ["^[a-z0-9]+(\.[a-z0-9-]+)*$", "stzlib..security", 0],
            ["^https://github\.com/mayouni/lookout/", "https://github.com/mayouni/lookout/blob/x", 1],
            ["^https://github\.com/mayouni/lookout/", "https://githubXcom/mayouni/lookout/", 0],
            ["^https://", "see https://x", 0],
            ["https://", "see https://x", 1],
            ["^[a-z0-9-]+$", "", 0]
        ]
        n = len(aCases)
        nBad = 0
        for i = 1 to n
            oP = new Pattern
            b = oP.Search(aCases[i][1], aCases[i][2])
            if b != aCases[i][3]
                nBad++
                Fail("pattern " + aCases[i][1], "on " + q2(aCases[i][2]) + " answered " + b)
            ok
        next
        if nBad = 0 Pass("the pattern matcher, " + n + " cases") ok

    # ------------------------------------------------------------ public pages speak affirmatively
    func Affirm
        oRun = NewRun()
        oRun.AffirmLine("README.md", 1, "A reader command does not exist yet.", [])
        if substr(Joined(oRun.aProblems), "a public page lists what is missing") > 0
            Pass("a public line saying what is missing is refused")
        else
            Fail("a public line saying what is missing is refused", "it was accepted")
        ok

        oRun = NewRun()
        oRun.AffirmLine("README.md", 1, "A reader command does not exist yet.", [["README.md", "a reader command"]])
        if len(oRun.aProblems) = 0
            Pass("an allowed line passes")
        else
            Fail("an allowed line passes", Joined(oRun.aProblems))
        ok

        oRun = NewRun()
        oRun.AffirmLine("docs/FEED.md", 1, "Softanza reads the feed and shows each notice.", [])
        if len(oRun.aProblems) = 0
            Pass("an affirmative line passes")
        else
            Fail("an affirmative line passes", Joined(oRun.aProblems))
        ok

        # the real allow list loads, and every entry in it gives a reason
        oRun = NewRun()
        aAllow = oRun.AffirmAllow()
        if len(oRun.aProblems) = 0 and len(aAllow) > 0
            Pass("tools/affirm-allow.txt loads, every line with its reason (" + len(aAllow) + ")")
        else
            Fail("tools/affirm-allow.txt loads, every line with its reason", Joined(oRun.aProblems))
        ok

    # ------------------------------------------------------------ every entry sits on the estate map
    # The real map/estate.json, and the frozen entry with its areas line changed in memory.
    func Map
        cAct = '"actions": ['
        MapCase("an area that names no project is refused", Broken('"softanza"', '"nowhere"'), "area nowhere names no project")
        MapCase("a domain the map does not list is refused", Broken(cAct, '"domains": ["spaceships"], ' + cAct), "domains value spaceships")
        MapCase("a concern the map does not list is refused", Broken(cAct, '"concerns": ["luck"], ' + cAct), "concerns value luck")
        cText = Broken(cAct, '"domains": ["agents", "security"], "concerns": ["trust"], ' + cAct)
        cText = substr(cText, '"areas": [', '"areas": ["stzlib", "stzlib.security", "haro", ')
        MapCase("an alias and a dotted sub-area pass, with known domains and concerns", cText, "")

    func MapCase cName, cText, cReason
        if cText = ""
            Fail(cName, "the change did not apply to the entry's text")
            return
        ok
        oRun = NewRun()
        oRun.AddEntryText("items/2026/" + cFile, "2026", cFile, cText)
        oRun.MapCheck()
        cSaid = Joined(oRun.aProblems)
        if cReason = ""
            if cSaid = "" Pass(cName) else Fail(cName, cSaid) ok
            return
        ok
        if substr(cSaid, cReason) > 0 Pass(cName) else Fail(cName, "not refused for this reason: " + cSaid) ok

    func q2 s
        return '"' + s + '"'
