# Lookout's feed library: the JSON reader and writer, the schema check, and the run that
# turns items/ into feed/index.json and feed/feed.json. tools/feed.ring is its command and
# tools/guard.ring its guard; both load this file. The rules are docs/FEED.md.
#
# It is written in Ring syntax, runs on Haro, and needs no other library.

# ---------------------------------------------------------------- JSON values
#
# A string is a Ring string. Everything else is a list whose first item says what it is:
#   ["{", [[key, value], ...]]   an object, keys in the order they were written
#   ["[", [value, ...]]          an array
#   ["#", "12.5"]                a number, kept as the text it was written as
#   ["t"] ["f"] ["n"]            true, false, null

func JKind v
    if isstring(v) return "string" ok
    t = v[1]
    if t = "{" return "object" ok
    if t = "[" return "array" ok
    if t = "#" return "number" ok
    if t = "t" or t = "f" return "boolean" ok
    return "null"

func JHas oObj, cKey
    aP = oObj[2]
    n = len(aP)
    for i = 1 to n
        if aP[i][1] = cKey return 1 ok
    next
    return 0

func JGet oObj, cKey
    aP = oObj[2]
    n = len(aP)
    for i = 1 to n
        if aP[i][1] = cKey return aP[i][2] ok
    next
    return ["n"]

func JKeys oObj
    aK = []
    aP = oObj[2]
    n = len(aP)
    for i = 1 to n
        aK + aP[i][1]
    next
    return aK

func JItems oArr
    return oArr[2]

func JEqual a, b
    ka = JKind(a)
    if ka != JKind(b) return 0 ok
    if ka = "string" return a = b ok
    if ka = "number" return number(a[2]) = number(b[2]) ok
    if ka = "boolean" return a[1] = b[1] ok
    if ka = "null" return 1 ok
    if ka = "array"
        na = len(a[2])
        if na != len(b[2]) return 0 ok
        for i = 1 to na
            if not JEqual(a[2][i], b[2][i]) return 0 ok
        next
        return 1
    ok
    # objects: the same keys with equal values, in any order
    if len(a[2]) != len(b[2]) return 0 ok
    na = len(a[2])
    for i = 1 to na
        cK = a[2][i][1]
        if not JHas(b, cK) return 0 ok
        if not JEqual(a[2][i][2], JGet(b, cK)) return 0 ok
    next
    return 1

func JIsString v
    return isstring(v)

# ---------------------------------------------------------------- JSON writer
#
# The bytes docs/FEED.md fixes: two-space indentation, ": " after a key, "," at the end of a
# line, an empty array or object as [] or {}, non-ASCII text written as UTF-8 and not escaped.

func JWrite v, nDepth
    k = JKind(v)
    if k = "string" return JQuote(v) ok
    if k = "number" return v[2] ok
    if k = "boolean"
        if v[1] = "t" return "true" ok
        return "false"
    ok
    if k = "null" return "null" ok
    aI = v[2]
    n = len(aI)
    if k = "array"
        if n = 0 return "[]" ok
        cOpen = "[" cClose = "]"
    else
        if n = 0 return "{}" ok
        cOpen = "{" cClose = "}"
    ok
    cPad = copy(" ", 2 * (nDepth + 1))
    cOut = cOpen + char(10)
    for i = 1 to n
        if k = "array"
            cOut += cPad + JWrite(aI[i], nDepth + 1)
        else
            cOut += cPad + JQuote(aI[i][1]) + ": " + JWrite(aI[i][2], nDepth + 1)
        ok
        if i < n cOut += "," ok
        cOut += char(10)
    next
    cOut += copy(" ", 2 * nDepth) + cClose
    return cOut

func JQuote s
    cOut = '"'
    n = len(s)
    for i = 1 to n
        c = s[i]
        b = ascii(c)
        if c = '"'
            cOut += "\" + '"'
        but c = "\"
            cOut += "\\"
        but b = 10
            cOut += "\n"
        but b = 13
            cOut += "\r"
        but b = 9
            cOut += "\t"
        but b = 8
            cOut += "\b"
        but b = 12
            cOut += "\f"
        but b < 32
            cOut += "\u00" + Hex2(b)
        else
            cOut += c
        ok
    next
    return cOut + '"'

func Hex2 n
    cH = lower(hex(n))
    if len(cH) < 2 cH = "0" + cH ok
    return cH

# ---------------------------------------------------------------- small helpers

func Utf8 n
    if n < 128 return char(n) ok
    if n < 2048
        return char(192 + floor(n / 64)) + char(128 + (n % 64))
    ok
    if n < 65536
        return char(224 + floor(n / 4096)) + char(128 + (floor(n / 64) % 64)) + char(128 + (n % 64))
    ok
    return char(240 + floor(n / 262144)) + char(128 + (floor(n / 4096) % 64)) +
           char(128 + (floor(n / 64) % 64)) + char(128 + (n % 64))

# The number of code points in a UTF-8 string: every byte that does not continue a character.
func CodePoints s
    n = len(s)
    nCount = 0
    for i = 1 to n
        b = ascii(s[i])
        if b < 128 or b >= 192 nCount++ ok
    next
    return nCount

func IsDigits s
    n = len(s)
    if n = 0 return 0 ok
    for i = 1 to n
        if not isdigit(s[i]) return 0 ok
    next
    return 1

func IsLeapYear y
    if y % 400 = 0 return 1 ok
    if y % 100 = 0 return 0 ok
    if y % 4 = 0 return 1 ok
    return 0

# YYYY-MM-DD, and a day that exists.
func IsDate s
    if len(s) != 10 return 0 ok
    if s[5] != "-" or s[8] != "-" return 0 ok
    cY = substr(s, 1, 4) cM = substr(s, 6, 2) cD = substr(s, 9, 2)
    if not (IsDigits(cY) and IsDigits(cM) and IsDigits(cD)) return 0 ok
    y = number(cY) m = number(cM) d = number(cD)
    if m < 1 or m > 12 return 0 ok
    aDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    nMax = aDays[m]
    if m = 2 and IsLeapYear(y) nMax = 29 ok
    if d < 1 or d > nMax return 0 ok
    return 1

# RFC 3339: YYYY-MM-DDTHH:MM:SS, an optional fraction, then Z or +HH:MM / -HH:MM.
func IsDateTime s
    if len(s) < 20 return 0 ok
    if not IsDate(substr(s, 1, 10)) return 0 ok
    if upper(s[11]) != "T" return 0 ok
    if s[14] != ":" or s[17] != ":" return 0 ok
    cH = substr(s, 12, 2) cMi = substr(s, 15, 2) cS = substr(s, 18, 2)
    if not (IsDigits(cH) and IsDigits(cMi) and IsDigits(cS)) return 0 ok
    if number(cH) > 23 or number(cMi) > 59 or number(cS) > 60 return 0 ok
    i = 20
    n = len(s)
    if s[i] = "."
        i++
        nStart = i
        while i <= n and isdigit(s[i]) i++ end
        if i = nStart return 0 ok
    ok
    if i > n return 0 ok
    cRest = substr(s, i, n - i + 1)
    if upper(cRest) = "Z" return 1 ok
    if len(cRest) != 6 return 0 ok
    if cRest[1] != "+" and cRest[1] != "-" return 0 ok
    if cRest[4] != ":" return 0 ok
    if not (IsDigits(substr(cRest, 2, 2)) and IsDigits(substr(cRest, 5, 2))) return 0 ok
    return 1

# Ring compares strings with strcmp; dates written YYYY-MM-DD compare as text.
func Before a, b
    return strcmp(a, b) < 0

func ReadText cPath
    return read(cPath)

func StripCR s
    if substr(s, char(13)) = 0 return s ok
    cOut = ""
    n = len(s)
    for i = 1 to n
        if ascii(s[i]) != 13 cOut += s[i] ok
    next
    return cOut

# ---------------------------------------------------------------- the run

class FeedRun
    cRoot = ""
    aProblems = []
    nEntries = 0
    oSchema = NULL
    oItemSchema = NULL
    oConfig = NULL      # lookout.yaml, read and checked by LoadConfig
    cConfig = ""        # the same, as the bytes of app/config.json
    aEntries = []       # [ [cFile, oData], ... ]
    bQuiet = 0          # the guard sets it: problems are kept and not printed
    oIndex = NULL       # what the last Finish built, for the guard to read
    oFeed = NULL
    cIndex = ""
    cFeed = ""

    func Problem cWhere, cMsg
        aProblems + (cWhere + ": " + cMsg)
        Say("REFUSED " + cWhere + ": " + cMsg)

    # Ring stores a COPY of an object, so the schema check cannot call back into this run:
    # it keeps what it found, and the run takes it here.
    func Drain
        aSaid = oSchema.aSaid
        n = len(aSaid)
        for i = 1 to n
            aProblems + aSaid[i]
            Say("REFUSED " + aSaid[i])
        next
        oSchema.aSaid = []

    # The whole run over this repository: generate writes the feeds, check only compares them.
    func Go cMode
        if not Prepare() return ok
        KeyCheck()
        if ConfOn("checks.affirm") AffirmScan() ok
        ReadEntries()
        LessonsCheck()
        MapCheck()
        Finish(cMode)

    # map/estate.json is the estate as Lookout reads it: layers, projects, domains, concerns. Every
    # entry's areas must name a project of the map (by id or alias, or a dotted sub-area of one), and
    # its domains and concerns must be ids of the map, so the site never places a signal nowhere.
    func MapCheck
        cMapRel = Conf("map")
        if cMapRel = "" cMapRel = "map/estate.json" ok
        cPath = cRoot + "/" + cMapRel
        if not fexists(cPath)
            Problem(cMapRel, "is the map every entry is placed on (lookout.yaml, map), and this run reads it")
            return
        ok
        oReader = new JsonReader
        try
            oM = oReader.Parse(StripCR(read(cPath)), cMapRel)
        catch e
            Problem("map/estate.json", "is not valid JSON: " + e.Message())
            return
        done
        if JKind(oM) != "object"
            Problem("map/estate.json", "holds one object")
            return
        ok
        aLayers = MapIds(oM, "layers")
        aDomains = MapIds(oM, "domains")
        aConcerns = MapIds(oM, "concerns")
        aNames = []
        if not JHas(oM, "projects") or JKind(JGet(oM, "projects")) != "array"
            Problem("map/estate.json", 'holds a "projects" array')
            return
        ok
        aP = JItems(JGet(oM, "projects"))
        nP = len(aP)
        for i = 1 to nP
            oP = aP[i]
            if JKind(oP) != "object" or not JHas(oP, "id") or not JHas(oP, "name") or not JHas(oP, "layer") or not JHas(oP, "line")
                Problem("map/estate.json", "project " + i + " has an id, a name, a layer and a line")
                loop
            ok
            cId = JGet(oP, "id")
            if find(aNames, cId) > 0 Problem("map/estate.json", "names " + cId + " twice") ok
            aNames + cId
            if find(aLayers, JGet(oP, "layer")) = 0
                Problem("map/estate.json", "project " + cId + " sits on layer " + JGet(oP, "layer") + ", and the map has no layer with that id")
            ok
            if JHas(oP, "link")
                cLink = JGet(oP, "link")
                if not isstring(cLink) or left(cLink, 8) != "https://"
                    Problem("map/estate.json", "project " + cId + " links to an https:// address")
                ok
            ok
            if JHas(oP, "aliases")
                aA = JItems(JGet(oP, "aliases"))
                nA = len(aA)
                for j = 1 to nA
                    if find(aNames, aA[j]) > 0 Problem("map/estate.json", "names " + aA[j] + " twice") ok
                    aNames + aA[j]
                next
            ok
        next
        nE = len(aEntries)
        for i = 1 to nE
            oData = aEntries[i][2]
            cWhere = aEntries[i][1]
            if JHas(oData, "areas")
                aV = JItems(JGet(oData, "areas"))
                nV = len(aV)
                for j = 1 to nV
                    if not MapNames(aNames, aV[j])
                        Problem(cWhere, "area " + aV[j] + " names no project of map/estate.json")
                    ok
                next
            ok
            MapField(cWhere, oData, "domains", aDomains)
            MapField(cWhere, oData, "concerns", aConcerns)
        next

    # The ids of one list of the map, refusing a list that is missing or an item with no id.
    func MapIds oM, cKey
        aIds = []
        if not JHas(oM, cKey) or JKind(JGet(oM, cKey)) != "array"
            Problem("map/estate.json", 'holds a "' + cKey + '" array')
            return aIds
        ok
        aI = JItems(JGet(oM, cKey))
        nI = len(aI)
        for i = 1 to nI
            if JKind(aI[i]) != "object" or not JHas(aI[i], "id") or not JHas(aI[i], "name")
                Problem("map/estate.json", cKey + " item " + i + " has an id and a name")
                loop
            ok
            cId = JGet(aI[i], "id")
            if find(aIds, cId) > 0 Problem("map/estate.json", cKey + " names " + cId + " twice") ok
            aIds + cId
        next
        return aIds

    # An area matches by its whole name, or by the project it is a dotted sub-area of.
    func MapNames aNames, cArea
        if find(aNames, cArea) > 0 return 1 ok
        nDot = substr(cArea, ".")
        if nDot > 1 and find(aNames, left(cArea, nDot - 1)) > 0 return 1 ok
        return 0

    func MapField cWhere, oData, cKey, aIds
        if not JHas(oData, cKey) return ok
        aV = JItems(JGet(oData, cKey))
        nV = len(aV)
        for j = 1 to nV
            if find(aIds, aV[j]) = 0
                Problem(cWhere, cKey + " value " + aV[j] + " is not an id of map/estate.json")
            ok
        next

    # app/lessons.json is what Lookout Radar shows under Build and Learn. It must be valid JSON, and
    # every key under "entries" must name an entry that exists, so the site never shows an orphan.
    func LessonsCheck
        cPath = cRoot + "/app/lessons.json"
        if not fexists(cPath) return ok
        oReader = new JsonReader
        try
            oL = oReader.Parse(StripCR(read(cPath)), "app/lessons.json")
        catch e
            Problem("app/lessons.json", "is not valid JSON: " + e.Message())
            return
        done
        if JKind(oL) != "object" or not JHas(oL, "entries")
            Problem("app/lessons.json", 'holds an object with an "entries" object, keyed by entry id')
            return
        ok
        oE = JGet(oL, "entries")
        if JKind(oE) != "object"
            Problem("app/lessons.json", '"entries" is an object keyed by entry id')
            return
        ok
        aIds = []
        nE = len(aEntries)
        for i = 1 to nE
            aIds + JGet(aEntries[i][2], "id")
        next
        aKeys = JKeys(oE)
        nK = len(aKeys)
        for i = 1 to nK
            if find(aIds, aKeys[i]) = 0
                Problem("app/lessons.json", "has lessons for " + aKeys[i] + ", and there is no entry with that id")
            ok
        next

    # ------------------------------------------------------------ public pages speak affirmatively
    #
    # A public page says what Softanza is and does; it never lists what has not been done, shown or
    # measured. Each line of README.md, docs/, digests/ and every entry is read for that class of
    # phrase. tools/affirm-allow.txt lists the lines that may keep one, each with its reason.

    func AffirmPhrases
        return ["not yet", "nobody has", "never been", "limit:", "does not exist", "doesn't exist",
                "not built", "is missing", "are missing", "what is missing", "still on ",
                "only by one", "protected only by", "has no ", "have no ", "nothing in stzlib",
                "nothing in softanza", "we have not", "not checked"]

    func AffirmScan
        aAllow = AffirmAllow()
        aFiles = ["README.md"]
        aDirs = ["docs", "digests"]
        nD = len(aDirs)
        for d = 1 to nD
            aIn = dir(cRoot + "/" + aDirs[d])
            nIn = len(aIn)
            for i = 1 to nIn
                if aIn[i][2] = 0 and right(aIn[i][1], 3) = ".md"
                    aFiles + (aDirs[d] + "/" + aIn[i][1])
                ok
            next
        next
        aYears = dir(cRoot + "/items")
        nY = len(aYears)
        for y = 1 to nY
            if aYears[y][2] = 1
                aIn = dir(cRoot + "/items/" + aYears[y][1])
                nIn = len(aIn)
                for i = 1 to nIn
                    if aIn[i][2] = 0 and right(aIn[i][1], 3) = ".md"
                        aFiles + ("items/" + aYears[y][1] + "/" + aIn[i][1])
                    ok
                next
            ok
        next
        nF = len(aFiles)
        for f = 1 to nF
            aLines = str2list(StripCR(read(cRoot + "/" + aFiles[f])))
            nL1 = len(aLines)
            for i = 1 to nL1
                AffirmLine(aFiles[f], i, aLines[i], aAllow)
            next
        next

    # One line of one public page. The guard calls this directly with lines it wrote.
    func AffirmLine cFile, nLine, cLine, aAllow
        cLow = lower(cLine)
        aP = AffirmPhrases()
        nP = len(aP)
        for p = 1 to nP
            if substr(cLow, aP[p]) > 0 and not AffirmAllowed(cFile, cLow, aAllow)
                Problem(cFile + ":" + nLine, "a public page lists what is missing (" + aP[p] +
                        "); say what holds or what is proposed, or allow the line in tools/affirm-allow.txt with its reason")
            ok
        next

    func AffirmAllowed cFile, cLow, aAllow
        nA = len(aAllow)
        for a = 1 to nA
            if aAllow[a][1] = cFile and substr(cLow, aAllow[a][2]) > 0 return 1 ok
        next
        return 0

    # tools/affirm-allow.txt: one line each, "file | words from the line | reason". A line with no
    # reason is refused, so nothing is allowed without saying why.
    func AffirmAllow
        aOut = []
        cPath = cRoot + "/tools/affirm-allow.txt"
        if not fexists(cPath) return aOut ok
        aLines = str2list(StripCR(read(cPath)))
        nL1 = len(aLines)
        for i = 1 to nL1
            cL = trim(aLines[i])
            if cL = "" or left(cL, 1) = "#" loop ok
            n1 = substr(cL, " | ")
            if n1 = 0
                Problem("tools/affirm-allow.txt:" + i, "a line is: file | words from the line | reason")
                loop
            ok
            cFile = trim(left(cL, n1 - 1))
            cRest = substr(cL, n1 + 3, len(cL) - n1 - 2)
            n2 = substr(cRest, " | ")
            if n2 = 0 or trim(substr(cRest, n2 + 3, len(cRest) - n2 - 2)) = ""
                Problem("tools/affirm-allow.txt:" + i, "every allowed line gives its reason")
                loop
            ok
            aOut + [cFile, lower(trim(left(cRest, n2 - 1)))]
        next
        return aOut

    # Loads the item schema. Returns 0 when the run cannot start.
    func Prepare
        oSchema = new SchemaCheck
        oSchema.cDir = cRoot + "/schema"
        if not fexists(oSchema.cDir + "/item.schema.json")
            Problem("tools/feed.ring", "run it from the repository root: schema/item.schema.json is not here")
            return 0
        ok
        oItemSchema = oSchema.SchemaFile("item.schema.json")
        Drain()
        if not islist(oItemSchema) return 0 ok
        return LoadConfig()

    # lookout.yaml: everything that belongs to the project this watch serves (docs/ADOPT.md). It is
    # read with the YAML reader below and checked against schema/config.schema.json; the run does not
    # start without it, because every URL and name the feed carries comes from it.
    func LoadConfig
        cPath = cRoot + "/lookout.yaml"
        if not fexists(cPath)
            Problem("lookout.yaml", "is this watch's configuration, and the run reads it first (docs/ADOPT.md)")
            return 0
        ok
        return LoadConfigText(read(cPath))

    # The same, from a text: the guard hands it configurations broken on purpose.
    func LoadConfigText cText
        oY = new YamlReader
        try
            oConfig = oY.Parse(cText, "lookout.yaml")
        catch e
            Problem("lookout.yaml", e.Message())
            return 0
        done
        oConfigSchema = oSchema.SchemaFile("config.schema.json")
        Drain()
        if not islist(oConfigSchema) return 0 ok
        nBefore = len(aProblems)
        oSchema.Check(oConfig, oConfigSchema, "lookout.yaml", "")
        Drain()
        if len(aProblems) > nBefore return 0 ok
        cConfig = JWrite(oConfig, 0) + char(10)
        return 1

    # One value of the configuration by its dotted path, "watch.repository".
    func Conf cPath
        v = oConfig
        cPart = ""
        cP = cPath + "."
        nP = len(cP)
        for i = 1 to nP
            if cP[i] = "."
                if JKind(v) != "object" or not JHas(v, cPart) return "" ok
                v = JGet(v, cPart)
                cPart = ""
            else
                cPart += cP[i]
            ok
        next
        return v

    # The key lookout.yaml publishes for the site and the bar must be the key the feed is checked
    # against, keys/allowed_signers, for the signer it names.
    func KeyCheck
        cPath = cRoot + "/keys/allowed_signers"
        if not fexists(cPath)
            Problem("keys/allowed_signers", "holds the public key the feed is signed with (docs/ADOPT.md, step 4)")
            return
        ok
        cWant = Conf("feed.signer") + " " + 'namespaces="' + Conf("feed.namespace") + '" ssh-ed25519 ' + Conf("feed.key")
        aLines = str2list(StripCR(read(cPath)))
        nL1 = len(aLines)
        for i = 1 to nL1
            if trim(aLines[i]) = cWant return ok
        next
        Problem("lookout.yaml", "feed.key, feed.signer and feed.namespace must match a line of keys/allowed_signers: " + cWant)

    # digests/<YYYY-Www>.md, as a sorted JSON list of weeks: the weeks a survey has closed.
    func DigestWeeks
        aW = []
        aIn = dir(cRoot + "/digests")
        nIn = len(aIn)
        for i = 1 to nIn
            cN = aIn[i][1]
            if aIn[i][2] = 0 and len(cN) = 11 and right(cN, 3) = ".md" and cN[5] = "-" and cN[6] = "W"
                aW + left(cN, 8)
            ok
        next
        aW = sort(aW)
        return JWrite(["[", aW], 0) + char(10)

    func ConfOn cPath
        v = Conf(cPath)
        return islist(v) and len(v) = 1 and v[1] = "t"

    # Cross-checks the entries read so far, builds both feeds and checks them. cMode "generate"
    # writes changed files, "check" compares them with what is committed, "none" touches no file.
    func Finish cMode
        nEntries = len(aEntries)
        if nEntries = 0
            Problem("items/", "there is no entry, so the feed has no date to carry")
            return
        ok
        CrossChecks()
        if len(aProblems) > 0
            Say("nothing written: the entries above must be corrected first")
            return
        ok

        SortEntries()
        oIndex = BuildIndex()
        oFeed = BuildJsonFeed()

        oIndexSchema = oSchema.SchemaFile("feed.schema.json")
        Drain()
        if not islist(oIndexSchema) return ok
        oSchema.Check(oIndex, oIndexSchema, "feed/index.json", "")
        Drain()
        CheckJsonFeed(oFeed)
        if len(aProblems) > 0
            Say("nothing written: the generated feed does not pass its own check")
            return
        ok

        cIndex = JWrite(oIndex, 0) + char(10)
        cFeed = JWrite(oFeed, 0) + char(10)
        if cMode = "none" return ok
        Settle(cMode, "feed/index.json", cIndex)
        Settle(cMode, "feed/feed.json", cFeed)
        Settle(cMode, "app/config.json", cConfig)      # the site and the bar read the configuration here
        Settle(cMode, "app/digests.json", DigestWeeks())  # the weeks surveyed: the site opens on the newest

    func Say cLine
        if not bQuiet see cLine + char(10) ok

    # In check mode, a committed feed that differs from what the entries generate is a problem.
    # In generate mode, the file is written only when its bytes change.
    func Settle cMode, cRel, cBytes
        cPath = cRoot + "/" + cRel
        cOld = ""
        if fexists(cPath) cOld = read(cPath) ok
        if cOld = cBytes
            Say("unchanged " + cRel + " (" + len(cBytes) + " bytes)")
            return
        ok
        if cMode = "check"
            Problem(cRel, "is not what the entries generate: run haro tools/feed.ring and commit the result")
            return
        ok
        write(cPath, cBytes)
        Say("written   " + cRel + " (" + len(cBytes) + " bytes)")

    func ReadEntries
        cItems = cRoot + "/items"
        aTop = dir(cItems)
        nTop = len(aTop)
        for i = 1 to nTop
            cName = aTop[i][1]
            if aTop[i][2] = 0
                if cName != "README.md"
                    Problem("items/" + cName, "an entry lives in a year folder, items/<year>/<id>.md")
                ok
                loop
            ok
            if not (len(cName) = 4 and IsDigits(cName))
                Problem("items/" + cName + "/", "a folder under items/ is a year, four digits")
                loop
            ok
            aYear = dir(cItems + "/" + cName)
            nYear = len(aYear)
            for j = 1 to nYear
                cFile = aYear[j][1]
                cRel = "items/" + cName + "/" + cFile
                if aYear[j][2] = 1
                    Problem(cRel + "/", "a year folder holds entries only, no folders")
                    loop
                ok
                if right(cFile, 3) != ".md"
                    Problem(cRel, "an entry is a .md file")
                    loop
                ok
                AddEntryText(cRel, cName, cFile, read(cRoot + "/" + cRel))
            next
        next

    # One entry, given as the text of its file: the guard calls this with texts it has broken.
    func AddEntryText cRel, cYear, cFile, cFileText
        cText = StripCR(cFileText)
        aLines = str2list(cText)
        nLines = len(aLines)
        nOpen = 0
        nClose = 0
        for i = 1 to nLines
            if trim(aLines[i]) = "```json"
                nOpen = i
                exit
            ok
        next
        if nOpen = 0
            Problem(cRel, "has no fenced json block, so it has no data")
            return
        ok
        for i = nOpen + 1 to nLines
            if trim(aLines[i]) = "```"
                nClose = i
                exit
            ok
        next
        if nClose = 0
            Problem(cRel, "its json block is never closed")
            return
        ok
        cJson = ""
        for i = nOpen + 1 to nClose - 1
            cJson += aLines[i] + char(10)
        next

        oReader = new JsonReader
        try
            oData = oReader.Parse(cJson, cRel)
        catch e
            Problem(cRel, "its json block is not valid JSON: " + e.Message())
            return
        done

        nBefore = len(aProblems)
        oSchema.Check(oData, oItemSchema, cRel, "")
        Drain()
        if len(aProblems) > nBefore return ok
        EntryRules(cRel, cYear, cFile, oData)
        if len(aProblems) > nBefore return ok
        aEntries + [cRel, oData]

    # What the schema cannot say, docs/FEED.md does.
    func EntryRules cRel, cYear, cFile, oData
        cId = JGet(oData, "id")
        cDate = JGet(oData, "date")
        if cFile != cId + ".md"
            Problem(cRel, "the file is named after its id, so it should be " + cId + ".md")
        ok
        if left(cId, 10) != cDate
            Problem(cRel, "the id starts with the entry's date, " + cDate + ", and this one starts with " + left(cId, 10))
        ok
        if left(cDate, 4) != cYear
            Problem(cRel, "an entry dated " + cDate + " lives in items/" + left(cDate, 4) + "/")
        ok
        if substr(JGet(oData, "title"), char(10)) > 0
            Problem(cRel, "the title is one line")
        ok
        if JHas(oData, "url")
            Problem(cRel, "an entry does not write its url: the generator adds it to the index")
        ok
        if JHas(oData, "updated")
            if Before(JGet(oData, "updated"), cDate)
                Problem(cRel, "updated, " + JGet(oData, "updated") + ", is before the entry's date")
            ok
        ok
        if not Before(cDate, JGet(oData, "review_by"))
            Problem(cRel, "review_by, " + JGet(oData, "review_by") + ", must come after the entry's date")
        ok

        # notice holds one sentence per audience listed, and only for those
        aAud = JItems(JGet(oData, "audiences"))
        oNotice = JGet(oData, "notice")
        aKeys = JKeys(oNotice)
        nK = len(aKeys)
        for i = 1 to nK
            if find(aAud, aKeys[i]) = 0
                Problem(cRel, "notice has a sentence for " + aKeys[i] + ", which audiences does not list")
            ok
        next
        nA = len(aAud)
        for i = 1 to nA
            if find(aKeys, aAud[i]) = 0
                Problem(cRel, "audiences lists " + aAud[i] + ", and notice has no sentence for it")
            ok
        next
        ActionDates(cRel, oData)

    # Every action carries the day it reached each stage, so Lookout Radar can say how fast Softanza
    # reacts. A stage is dated between the entry's date and the day the entry was last written, the
    # stages run in order, the current state has its date, and no stage beyond it is dated.
    func ActionDates cRel, oData
        if not JHas(oData, "actions") return ok
        aStages = ["proposed", "routed", "in-progress", "done"]
        cDate = JGet(oData, "date")
        cLast = cDate
        if JHas(oData, "updated") cLast = JGet(oData, "updated") ok
        aAct = JItems(JGet(oData, "actions"))
        nAct = len(aAct)
        for i = 1 to nAct
            oA = aAct[i]
            cWhere = "action " + i + " (" + JGet(oA, "area") + ")"
            cState = JGet(oA, "state")
            if not JHas(oA, "dates")
                Problem(cRel, cWhere + " has no dates: give the day it reached each stage, at least proposed")
                loop
            ok
            oD = JGet(oA, "dates")
            if JKind(oD) != "object"
                Problem(cRel, cWhere + " dates is an object of stage: day")
                loop
            ok
            aK = JKeys(oD)
            nK = len(aK)
            for j = 1 to nK
                cK = aK[j]
                if find(aStages, cK) = 0 and cK != "declined"
                    Problem(cRel, cWhere + " dates a stage named " + cK + ", and the stages are proposed, routed, in-progress, done, declined")
                    loop
                ok
                cD = JGet(oD, cK)
                if not isstring(cD) or not IsDate(cD)
                    Problem(cRel, cWhere + " dates " + cK + " with something that is not a YYYY-MM-DD day")
                    loop
                ok
                if Before(cD, cDate)
                    Problem(cRel, cWhere + " reached " + cK + " on " + cD + ", before the entry's date " + cDate)
                ok
                if Before(cLast, cD)
                    Problem(cRel, cWhere + " reached " + cK + " on " + cD + ", after the entry was last written (" + cLast + "): set updated")
                ok
            next
            if not JHas(oD, "proposed")
                Problem(cRel, cWhere + " dates the day it was proposed")
            ok
            if not JHas(oD, cState)
                Problem(cRel, cWhere + " is " + cState + " and does not date that stage")
            ok
            nNow = find(aStages, cState)
            cPrev = ""
            nS = len(aStages)
            for j = 1 to nS
                if not JHas(oD, aStages[j]) loop ok
                if nNow > 0 and j > nNow
                    Problem(cRel, cWhere + " is " + cState + " and dates a later stage, " + aStages[j])
                ok
                cD = JGet(oD, aStages[j])
                if cPrev != "" and Before(cD, cPrev)
                    Problem(cRel, cWhere + " reached " + aStages[j] + " on " + cD + ", before an earlier stage (" + cPrev + ")")
                ok
                cPrev = cD
            next
        next

    func CrossChecks
        n = len(aEntries)
        aIds = []
        for i = 1 to n
            aIds + JGet(aEntries[i][2], "id")
        next
        for i = 1 to n
            for j = i + 1 to n
                if aIds[i] = aIds[j]
                    Problem(aEntries[j][1], "its id " + aIds[j] + " is already used by " + aEntries[i][1])
                ok
            next
        next
        for i = 1 to n
            oData = aEntries[i][2]
            if JHas(oData, "supersedes")
                cTarget = JGet(oData, "supersedes")
                if cTarget = aIds[i]
                    Problem(aEntries[i][1], "an entry cannot supersede itself")
                but find(aIds, cTarget) = 0
                    Problem(aEntries[i][1], "supersedes " + cTarget + ", and there is no entry with that id")
                ok
            ok
        next

    # Newest date first, then by id.
    func SortEntries
        n = len(aEntries)
        for i = 2 to n
            j = i
            while j > 1 and ComesFirst(aEntries[j][2], aEntries[j - 1][2])
                aTmp = aEntries[j]
                aEntries[j] = aEntries[j - 1]
                aEntries[j - 1] = aTmp
                j--
            end
        next

    func ComesFirst a, b
        da = JGet(a, "date") db = JGet(b, "date")
        if da != db return Before(db, da) ok
        return Before(JGet(a, "id"), JGet(b, "id"))

    func EntryUrl oData
        cId = JGet(oData, "id")
        return Conf("watch.repository") + "/blob/main/items/" + left(cId, 4) + "/" + cId + ".md"

    # The newest date or updated among the entries, at midnight UTC: an unchanged feed
    # regenerates to the same bytes.
    func NewestDay
        cMax = ""
        n = len(aEntries)
        for i = 1 to n
            oData = aEntries[i][2]
            cD = JGet(oData, "date")
            if cMax = "" or Before(cMax, cD) cMax = cD ok
            if JHas(oData, "updated")
                cU = JGet(oData, "updated")
                if Before(cMax, cU) cMax = cU ok
            ok
        next
        return cMax + "T00:00:00Z"

    func BuildIndex
        aItems = []
        n = len(aEntries)
        for i = 1 to n
            oData = aEntries[i][2]
            aPairs = oData[2]
            aPairs + ["url", EntryUrl(oData)]
            aItems + ["{", aPairs]
        next
        return ["{", [
            ["feed", "lookout"],
            ["version", ["#", "1"]],
            ["updated", NewestDay()],
            ["home", Conf("watch.repository")],
            ["items", ["[", aItems]]
        ]]

    # The same entries as a JSON Feed 1.1 (docs/FEED.md, "The JSON Feed").
    func BuildJsonFeed
        aItems = []
        n = len(aEntries)
        for i = 1 to n
            oData = aEntries[i][2]
            aTags = [JGet(oData, "kind"), JGet(oData, "stance"), JGet(oData, "level")]
            if JHas(oData, "tags")
                aOwn = JItems(JGet(oData, "tags"))
                nT = len(aOwn)
                for t = 1 to nT
                    aTags + aOwn[t]
                next
            ok
            cDate = JGet(oData, "date")
            aPairs = [
                ["id", JGet(oData, "id")],
                ["url", EntryUrl(oData)],
                ["title", JGet(oData, "title")],
                ["summary", JGet(oData, "summary")],
                ["content_text", JGet(oData, "summary")],
                ["date_published", cDate + "T00:00:00Z"]
            ]
            if JHas(oData, "updated")
                cUp = JGet(oData, "updated")
                if cUp != cDate
                    aPairs + ["date_modified", cUp + "T00:00:00Z"]
                ok
            ok
            aPairs + ["tags", ["[", aTags]]
            aItems + ["{", aPairs]
        next
        return ["{", [
            ["version", "https://jsonfeed.org/version/1.1"],
            ["title", Conf("watch.name")],
            ["home_page_url", Conf("watch.repository")],
            ["feed_url", substr(Conf("watch.repository"), "https://github.com/", "https://raw.githubusercontent.com/") + "/main/feed/feed.json"],
            ["description", "A public watch on what is changing in " + Conf("watch.topic") + ", read from " + Conf("project.name") + "'s point of view."],
            ["language", Conf("watch.language")],
            ["items", ["[", aItems]]
        ]]

    # What JSON Feed 1.1 requires of a feed and of each item.
    func CheckJsonFeed oFeed
        cW = "feed/feed.json"
        if JGet(oFeed, "version") != "https://jsonfeed.org/version/1.1"
            Problem(cW, "version is not https://jsonfeed.org/version/1.1")
        ok
        if not JIsString(JGet(oFeed, "title"))
            Problem(cW, "has no title")
        ok
        aItems = JItems(JGet(oFeed, "items"))
        n = len(aItems)
        if n != nEntries
            Problem(cW, "carries " + n + " items for " + nEntries + " entries")
        ok
        for i = 1 to n
            oI = aItems[i]
            cId = JGet(oI, "id")
            if not JIsString(cId)
                Problem(cW, "item " + i + " has no id")
                loop
            ok
            if not (JHas(oI, "content_text") or JHas(oI, "content_html"))
                Problem(cW, cId + " has neither content_text nor content_html")
            ok
            if not IsDateTime(JGet(oI, "date_published"))
                Problem(cW, cId + ": date_published is not an RFC 3339 date-time")
            ok
            if JHas(oI, "date_modified") and not IsDateTime(JGet(oI, "date_modified"))
                Problem(cW, cId + ": date_modified is not an RFC 3339 date-time")
            ok
        next

# ---------------------------------------------------------------- JSON reader

class JsonReader
    cText = ""
    nPos = 1
    nSize = 0
    cWhere = ""

    func Parse cSrc, cName
        cText = cSrc
        nSize = len(cSrc)
        nPos = 1
        cWhere = cName
        v = ReadValue()
        SkipSpace()
        if nPos <= nSize Fail("there is text after the JSON value") ok
        return v

    func Fail cMsg
        # the line, counted from the start of the block
        nLine = 1
        for i = 1 to nPos - 1
            if i <= nSize and ascii(cText[i]) = 10 nLine++ ok
        next
        raise("line " + nLine + " of the block: " + cMsg)

    func SkipSpace
        while nPos <= nSize
            b = ascii(cText[nPos])
            if b = 32 or b = 9 or b = 10 or b = 13
                nPos++
            else
                exit
            ok
        end

    func ReadValue
        SkipSpace()
        if nPos > nSize Fail("the value ends early") ok
        c = cText[nPos]
        if c = "{" return ReadObject() ok
        if c = "[" return ReadArray() ok
        if c = '"' return ReadString() ok
        if c = "t"
            Word("true")
            return ["t"]
        ok
        if c = "f"
            Word("false")
            return ["f"]
        ok
        if c = "n"
            Word("null")
            return ["n"]
        ok
        if c = "-" or isdigit(c) return ReadNumber() ok
        Fail("unexpected character " + c)

    func Word cWord
        if substr(cText, nPos, len(cWord)) != cWord Fail("expected " + cWord) ok
        nPos += len(cWord)

    func ReadObject
        nPos++
        aPairs = []
        aSeen = []
        SkipSpace()
        if nPos <= nSize and cText[nPos] = "}"
            nPos++
            return ["{", aPairs]
        ok
        while 1
            SkipSpace()
            if nPos > nSize or cText[nPos] != '"' Fail("expected a key in double quotes") ok
            cKey = ReadString()
            if find(aSeen, cKey) > 0 Fail("the key " + cKey + " is written twice") ok
            aSeen + cKey
            SkipSpace()
            if nPos > nSize or cText[nPos] != ":" Fail("expected : after the key " + cKey) ok
            nPos++
            v = ReadValue()
            aPairs + [cKey, v]
            SkipSpace()
            if nPos > nSize Fail("the object is never closed") ok
            c = cText[nPos]
            nPos++
            if c = "}" return ["{", aPairs] ok
            if c != "," Fail("expected , or } after the value of " + cKey) ok
        end

    func ReadArray
        nPos++
        aItems = []
        SkipSpace()
        if nPos <= nSize and cText[nPos] = "]"
            nPos++
            return ["[", aItems]
        ok
        while 1
            v = ReadValue()
            aItems + v
            SkipSpace()
            if nPos > nSize Fail("the array is never closed") ok
            c = cText[nPos]
            nPos++
            if c = "]" return ["[", aItems] ok
            if c != "," Fail("expected , or ] in an array") ok
        end

    func ReadString
        nPos++
        cOut = ""
        while 1
            if nPos > nSize Fail("a string is never closed") ok
            c = cText[nPos]
            b = ascii(c)
            if c = '"'
                nPos++
                return cOut
            ok
            if b < 32 Fail("a control character inside a string must be escaped") ok
            if c != "\"
                cOut += c
                nPos++
                loop
            ok
            nPos++
            if nPos > nSize Fail("a string ends on a backslash") ok
            e = cText[nPos]
            nPos++
            if e = '"' cOut += '"'
            but e = "\" cOut += "\"
            but e = "/" cOut += "/"
            but e = "b" cOut += char(8)
            but e = "f" cOut += char(12)
            but e = "n" cOut += char(10)
            but e = "r" cOut += char(13)
            but e = "t" cOut += char(9)
            but e = "u"
                n = Hex4()
                if n >= 55296 and n <= 56319
                    if substr(cText, nPos, 2) != "\u" Fail("a high surrogate is not followed by a low one") ok
                    nPos += 2
                    n2 = Hex4()
                    if n2 < 56320 or n2 > 57343 Fail("a high surrogate is not followed by a low one") ok
                    n = 65536 + (n - 55296) * 1024 + (n2 - 56320)
                but n >= 56320 and n <= 57343
                    Fail("a low surrogate stands alone")
                ok
                cOut += Utf8(n)
            else
                Fail("unknown escape \" + e)
            ok
        end

    func Hex4
        if nPos + 3 > nSize Fail("\u needs four hex digits") ok
        cH = substr(cText, nPos, 4)
        for i = 1 to 4
            if substr("0123456789abcdefABCDEF", cH[i]) = 0 Fail("\u needs four hex digits") ok
        next
        nPos += 4
        return dec(cH)

    func ReadNumber
        nStart = nPos
        if cText[nPos] = "-" nPos++ ok
        if nPos > nSize or not isdigit(cText[nPos]) Fail("a number needs a digit") ok
        if cText[nPos] = "0"
            nPos++
        else
            while nPos <= nSize and isdigit(cText[nPos]) nPos++ end
        ok
        if nPos <= nSize and cText[nPos] = "."
            nPos++
            if nPos > nSize or not isdigit(cText[nPos]) Fail("a fraction needs a digit") ok
            while nPos <= nSize and isdigit(cText[nPos]) nPos++ end
        ok
        if nPos <= nSize and (cText[nPos] = "e" or cText[nPos] = "E")
            nPos++
            if nPos <= nSize and (cText[nPos] = "+" or cText[nPos] = "-") nPos++ ok
            if nPos > nSize or not isdigit(cText[nPos]) Fail("an exponent needs a digit") ok
            while nPos <= nSize and isdigit(cText[nPos]) nPos++ end
        ok
        return ["#", substr(cText, nStart, nPos - nStart)]

# ---------------------------------------------------------------- schema check
#
# The part of JSON Schema 2020-12 that schema/ uses. A keyword this check does not implement is
# refused by name, so a later schema cannot pass because nobody here read it.

class SchemaCheck
    cDir = ""
    aSaid = []       # what this check found, taken by FeedRun.Drain
    aCache = []      # [ [cName, oSchema], ... ]

    func SchemaFile cName
        n = len(aCache)
        for i = 1 to n
            if aCache[i][1] = cName return aCache[i][2] ok
        next
        cPath = cDir + "/" + cName
        if not fexists(cPath)
            aSaid + ("schema/" + cName + ": is referred to and does not exist")
            return NULL
        ok
        oReader = new JsonReader
        try
            oS = oReader.Parse(StripCR(read(cPath)), "schema/" + cName)
        catch e
            aSaid + ("schema/" + cName + ": is not valid JSON: " + e.Message())
            return NULL
        done
        aCache + [cName, oS]
        return oS

    func Say cWhere, cPath, cMsg
        if cPath = ""
            aSaid + (cWhere + ": " + cMsg)
        else
            aSaid + (cWhere + ": " + cPath + ": " + cMsg)
        ok

    func Check v, oS, cWhere, cPath
        if JKind(oS) = "boolean"
            if oS[1] = "f" Say(cWhere, cPath, "is not allowed here") ok
            return
        ok
        aKnown = ["$schema", "$id", "title", "description", "$ref", "allOf", "type", "const", "enum",
                  "required", "properties", "additionalProperties", "propertyNames", "minProperties",
                  "items", "minItems", "uniqueItems", "minLength", "pattern", "format"]
        aKeys = JKeys(oS)
        nK = len(aKeys)
        for i = 1 to nK
            if find(aKnown, aKeys[i]) = 0
                Say(cWhere, cPath, "the schema uses " + aKeys[i] + ", which tools/feed.ring does not check yet")
            ok
        next

        if JHas(oS, "$ref")
            cRef = JGet(oS, "$ref")
            nSlash = 0
            nRef = len(cRef)
            for i = 1 to nRef
                if cRef[i] = "/" nSlash = i ok
            next
            oRef = SchemaFile(substr(cRef, nSlash + 1, len(cRef) - nSlash))
            if islist(oRef) Check(v, oRef, cWhere, cPath) ok
        ok
        if JHas(oS, "allOf")
            aAll = JItems(JGet(oS, "allOf"))
            nAll = len(aAll)
            for i = 1 to nAll
                Check(v, aAll[i], cWhere, cPath)
            next
        ok

        k = JKind(v)
        cShown = cPath
        if cShown = "" cShown = "the entry" ok

        if JHas(oS, "type")
            cT = JGet(oS, "type")
            if not isstring(cT)
                Say(cWhere, cPath, "the schema gives a list of types, which tools/feed.ring does not check yet")
                return
            ok
            bOk = 0
            if cT = k bOk = 1 ok
            if cT = "integer" and k = "number"
                if substr(v[2], ".") = 0 and substr(lower(v[2]), "e") = 0 bOk = 1 ok
            ok
            if not bOk
                Say(cWhere, cPath, "should be " + cT + " and is " + k)
                return
            ok
        ok
        if JHas(oS, "const")
            if not JEqual(v, JGet(oS, "const"))
                Say(cWhere, cPath, "should be " + JWrite(JGet(oS, "const"), 0))
            ok
        ok
        if JHas(oS, "enum")
            aE = JItems(JGet(oS, "enum"))
            nE = len(aE)
            bFound = 0
            aShow = []
            for i = 1 to nE
                if JEqual(v, aE[i]) bFound = 1 ok
                aShow + JWrite(aE[i], 0)
            next
            if not bFound
                cList = ""
                for i = 1 to nE
                    if i > 1 cList += ", " ok
                    cList += aShow[i]
                next
                cGot = "this value"
                if k = "string" cGot = JQuote(v) ok
                Say(cWhere, cShown, cGot + " is not one of " + cList)
            ok
        ok

        if k = "string"
            if JHas(oS, "minLength")
                oMin = JGet(oS, "minLength")
                if CodePoints(v) < number(oMin[2])
                    Say(cWhere, cShown, "is shorter than " + oMin[2] + " characters")
                ok
            ok
            if JHas(oS, "pattern")
                oRx = new Pattern
                try
                    bMatch = oRx.Search(JGet(oS, "pattern"), v)
                catch e
                    Say(cWhere, cShown, "the schema's pattern cannot be read: " + e.Message())
                    bMatch = 1
                done
                if not bMatch
                    Say(cWhere, cShown, JQuote(v) + " does not match " + JGet(oS, "pattern"))
                ok
            ok
            if JHas(oS, "format")
                cF = JGet(oS, "format")
                if cF = "date"
                    if not IsDate(v) Say(cWhere, cShown, JQuote(v) + " is not a date, YYYY-MM-DD") ok
                but cF = "date-time"
                    if not IsDateTime(v) Say(cWhere, cShown, JQuote(v) + " is not an RFC 3339 date-time") ok
                else
                    Say(cWhere, cShown, "the schema asks for format " + cF + ", which tools/feed.ring does not check yet")
                ok
            ok
        ok

        if k = "array"
            aI = JItems(v)
            nI = len(aI)
            if JHas(oS, "minItems")
                oMin = JGet(oS, "minItems")
                if nI < number(oMin[2])
                    Say(cWhere, cShown, "needs at least " + oMin[2] + " item(s)")
                ok
            ok
            oUniq = ["f"]
            if JHas(oS, "uniqueItems") oUniq = JGet(oS, "uniqueItems") ok
            if oUniq[1] = "t"
                for i = 1 to nI
                    for j = i + 1 to nI
                        if JEqual(aI[i], aI[j])
                            Say(cWhere, cShown, "item " + j + " repeats item " + i)
                        ok
                    next
                next
            ok
            if JHas(oS, "items")
                oIs = JGet(oS, "items")
                for i = 1 to nI
                    Check(aI[i], oIs, cWhere, cPath + "[" + i + "]")
                next
            ok
        ok

        if k = "object"
            aOwn = JKeys(v)
            nO = len(aOwn)
            if JHas(oS, "required")
                aR = JItems(JGet(oS, "required"))
                nR = len(aR)
                for i = 1 to nR
                    if not JHas(v, aR[i])
                        Say(cWhere, cShown, "is missing " + aR[i])
                    ok
                next
            ok
            if JHas(oS, "minProperties")
                oMin = JGet(oS, "minProperties")
                if nO < number(oMin[2])
                    Say(cWhere, cShown, "needs at least " + oMin[2] + " key(s)")
                ok
            ok
            oProps = ["{", []]
            if JHas(oS, "properties") oProps = JGet(oS, "properties") ok
            for i = 1 to nO
                cK = aOwn[i]
                cSub = cK
                if cPath != "" cSub = cPath + "." + cK ok
                if JHas(oS, "propertyNames")
                    Check(cK, JGet(oS, "propertyNames"), cWhere, cSub + " (as a key)")
                ok
                if JHas(oProps, cK)
                    Check(JGet(v, cK), JGet(oProps, cK), cWhere, cSub)
                but JHas(oS, "additionalProperties")
                    Check(JGet(v, cK), JGet(oS, "additionalProperties"), cWhere, cSub)
                ok
            next
        ok

# ---------------------------------------------------------------- patterns
#
# The regular expressions schema/ uses: literals, ., \d \w \s and escaped punctuation,
# [classes] with ranges, (groups), and * + ? {n} {n,} {n,m}, with ^ and $. Matching keeps
# the set of reachable positions, so it never backtracks. It reads bytes, which is exact for the
# ASCII patterns the schema writes.

class Pattern
    cPat = ""
    nAt = 1

    func Search cPattern, cSubject
        cPat = cPattern
        nAt = 1
        aSeq = ParseSeq()
        if nAt <= len(cPat) raise("an unmatched ) at " + nAt) ok
        nS = len(cSubject)
        aStart = []
        for p = 1 to nS + 1
            aStart + p
        next
        aEnd = Run(aSeq, cSubject, aStart)
        return len(aEnd) > 0

    func ParseSeq
        aSeq = []
        nP = len(cPat)
        while nAt <= nP
            c = cPat[nAt]
            if c = ")" exit ok
            if c = "|" raise("alternation | is not supported") ok
            if c = "^"
                nAt++
                aSeq + ["bol", NULL, 1, 1]
                loop
            ok
            if c = "$"
                nAt++
                aSeq + ["eol", NULL, 1, 1]
                loop
            ok
            if c = "("
                nAt++
                aInner = ParseSeq()
                if nAt > nP or cPat[nAt] != ")" raise("a ( is never closed") ok
                nAt++
                aNode = ["grp", aInner, 1, 1]
            but c = "["
                aNode = ["set", ParseClass(), 1, 1]
            but c = "."
                nAt++
                aNode = ["set", [0, [[0, 9], [11, 255]]], 1, 1]     # any byte but a line feed
            but c = "\"
                nAt++
                aNode = ["set", EscapeSet(), 1, 1]
            else
                nAt++
                b = ascii(c)
                aNode = ["set", [0, [[b, b]]], 1, 1]
            ok
            aQ = ParseQuantifier()
            aNode[3] = aQ[1]
            aNode[4] = aQ[2]
            aSeq + aNode
        end
        return aSeq

    # After a backslash: a class letter or a literal character. Returns [negate, ranges].
    func EscapeSet
        if nAt > len(cPat) raise("the pattern ends on a backslash") ok
        e = cPat[nAt]
        nAt++
        if e = "d" return [0, [[48, 57]]] ok
        if e = "w" return [0, [[48, 57], [65, 90], [97, 122], [95, 95]]] ok
        if e = "s" return [0, [[9, 10], [13, 13], [32, 32]]] ok
        b = ascii(e)
        return [0, [[b, b]]]

    func ParseClass
        nAt++
        nNeg = 0
        aR = []
        nP = len(cPat)
        if nAt <= nP and cPat[nAt] = "^"
            nNeg = 1
            nAt++
        ok
        bFirst = 1
        while 1
            if nAt > nP raise("a [ is never closed") ok
            c = cPat[nAt]
            if c = "]" and not bFirst
                nAt++
                exit
            ok
            bFirst = 0
            if c = "\"
                nAt++
                aE = EscapeSet()
                nE = len(aE[2])
                for i = 1 to nE
                    aR + aE[2][i]
                next
                loop
            ok
            nLo = ascii(c)
            nAt++
            if nAt + 1 <= nP and cPat[nAt] = "-" and cPat[nAt + 1] != "]"
                nHi = ascii(cPat[nAt + 1])
                nAt += 2
                aR + [nLo, nHi]
            else
                aR + [nLo, nLo]
            ok
        end
        return [nNeg, aR]

    func ParseQuantifier
        nP = len(cPat)
        if nAt > nP return [1, 1] ok
        c = cPat[nAt]
        if c = "*"
            nAt++
            return [0, -1]
        ok
        if c = "+"
            nAt++
            return [1, -1]
        ok
        if c = "?"
            nAt++
            return [0, 1]
        ok
        if c != "{" return [1, 1] ok
        nClose = 0
        for i = nAt to nP
            if cPat[i] = "}"
                nClose = i
                exit
            ok
        next
        if nClose = 0 raise("a { is never closed") ok
        cIn = substr(cPat, nAt + 1, nClose - nAt - 1)
        nAt = nClose + 1
        nComma = substr(cIn, ",")
        if nComma = 0
            if not IsDigits(cIn) raise("{" + cIn + "} is not a count") ok
            return [number(cIn), number(cIn)]
        ok
        cLo = left(cIn, nComma - 1)
        cHi = substr(cIn, nComma + 1, len(cIn) - nComma)
        if not IsDigits(cLo) raise("{" + cIn + "} is not a count") ok
        if cHi = "" return [number(cLo), -1] ok
        if not IsDigits(cHi) raise("{" + cIn + "} is not a count") ok
        return [number(cLo), number(cHi)]

    # Every position reachable after matching the sequence from any of the given positions.
    func Run aSeq, cS, aPos
        n = len(aSeq)
        for i = 1 to n
            aPos = Repeat(aSeq[i], cS, aPos)
            if len(aPos) = 0 return [] ok
        next
        return aPos

    func Repeat aNode, cS, aPos
        nMin = aNode[3]
        nMax = aNode[4]
        aOut = []
        if nMin = 0 aOut = aPos ok
        aCur = aPos
        nGuard = len(cS) + 2
        k = 0
        while 1
            k++
            aCur = StepOnce(aNode, cS, aCur)
            if len(aCur) = 0 exit ok
            if k >= nMin aOut = Union(aOut, aCur) ok
            if nMax != -1 and k >= nMax exit ok
            if k > nGuard and k > nMin exit ok
        end
        return aOut

    func StepOnce aNode, cS, aPos
        cKind = aNode[1]
        nS = len(cS)
        aOut = []
        n = len(aPos)
        if cKind = "grp" return Run(aNode[2], cS, aPos) ok
        for i = 1 to n
            p = aPos[i]
            if cKind = "bol"
                if p = 1 aOut + p ok
            but cKind = "eol"
                if p = nS + 1 aOut + p ok
            else
                if p <= nS and InSet(aNode[2], ascii(cS[p])) aOut + (p + 1) ok
            ok
        next
        return aOut

    func InSet aSet, b
        aR = aSet[2]
        n = len(aR)
        bIn = 0
        for i = 1 to n
            if b >= aR[i][1] and b <= aR[i][2]
                bIn = 1
                exit
            ok
        next
        if aSet[1] = 1 return not bIn ok
        return bIn

    func Union a, b
        aOut = a
        n = len(b)
        for i = 1 to n
            if find(aOut, b[i]) = 0 aOut + b[i] ok
        next
        return aOut


# ---------------------------------------------------------------- the YAML reader
#
# lookout.yaml is read with a small, strict subset of YAML, enough for a configuration a person
# writes by hand (docs/ADOPT.md, "The file"):
#   key: value              a map; keys are letters, digits, _ and -
#   key:                    a deeper block follows, indented by spaces (a tab is refused)
#   - value / - key: value  a list of values, or of maps
#   "text", 'text', text    a string; true, false and null are themselves; # starts a comment
#   [a, b, "c d"]           a short list on one line
#   key: |  or  key: >      a block of text on the lines below (| keeps the line breaks, > joins them)
# Anything else is refused with its line number, never guessed. The result has the JSON reader's
# shape, so every check that reads JSON reads this too.
class YamlReader
    aSrc = []
    nAt = 1
    cDoc = ""

    func Parse cText, cWhere
        cDoc = cWhere
        aSrc = YamlLines(StripCR(cText))
        nAt = 1
        SkipEmpty()
        if nAt > len(aSrc) return ["{", []] ok
        v = Block(Indent(aSrc[nAt]))
        SkipEmpty()
        if nAt <= len(aSrc) Fail("this line is indented less than its block and more than its parent") ok
        return v

    func Fail cMsg
        raise(cDoc + ", line " + nAt + ": " + cMsg)

    func Indent cL
        n = 0
        nL = len(cL)
        while n < nL and cL[n + 1] = " " n++ end
        if n < nL and ascii(cL[n + 1]) = 9 Fail("a tab indents this line; indent with spaces") ok
        return n

    func IsEmpty cL
        c = Uncomment(cL)
        return trim(c) = ""

    func SkipEmpty
        while nAt <= len(aSrc) and IsEmpty(aSrc[nAt]) nAt++ end

    # The text of a line with its comment removed: # starts a comment at the line's start or after a
    # space, outside quotes.
    func Uncomment cL
        cQ = ""
        nL = len(cL)
        for i = 1 to nL
            c = cL[i]
            if cQ != ""
                if c = cQ cQ = "" ok
            but c = '"' or c = "'"
                cQ = c
            but c = "#" and (i = 1 or cL[i - 1] = " ")
                return left(cL, i - 1)
            ok
        next
        return cL

    # A block: every line at this indent is one key of a map, or one item of a list.
    func Block nInd
        cFirst = trim(Uncomment(aSrc[nAt]))
        if cFirst = "-" or left(cFirst, 2) = "- " return Seq(nInd) ok
        return Mapping(nInd)

    func Mapping nInd
        aPairs = []
        aKeys = []
        while true
            SkipEmpty()
            if nAt > len(aSrc) exit ok
            n = Indent(aSrc[nAt])
            if n < nInd exit ok
            if n > nInd Fail("this line is indented more than the keys above it") ok
            cL = trim(Uncomment(aSrc[nAt]))
            if left(cL, 2) = "- " or cL = "-" Fail("a list item where a key of the map is expected") ok
            aKV = SplitKey(cL)
            cK = aKV[1]
            if find(aKeys, cK) > 0 Fail("the key " + cK + " is written twice") ok
            aKeys + cK
            aPairs + [cK, Value(aKV[2], nInd)]
        end
        return ["{", aPairs]

    func Seq nInd
        aItems = []
        while true
            SkipEmpty()
            if nAt > len(aSrc) exit ok
            n = Indent(aSrc[nAt])
            if n < nInd exit ok
            if n > nInd Fail("this line is indented more than the list items above it") ok
            cL = trim(Uncomment(aSrc[nAt]))
            if not (left(cL, 2) = "- " or cL = "-") Fail("a key where a list item is expected") ok
            cRest = trim(substr(cL, 2, len(cL)))
            if cRest = ""
                nAt++
                SkipEmpty()
                if nAt > len(aSrc) or Indent(aSrc[nAt]) <= nInd Fail("an empty list item") ok
                aItems + Block(Indent(aSrc[nAt]))
            but IsKeyLine(cRest)
                # "- key: value": a map whose keys sit where the text after "- " starts
                nKeyInd = nInd + 2
                aSrc[nAt] = copy(" ", nKeyInd) + cRest
                aItems + Mapping(nKeyInd)
            else
                aItems + Scalar(cRest)
                nAt++
            ok
        end
        return ["[", aItems]

    func IsKeyLine cL
        if left(cL, 1) = '"' or left(cL, 1) = "'" or left(cL, 1) = "[" return 0 ok
        nC = substr(cL, ":")
        if nC < 2 return 0 ok
        if nC < len(cL) and cL[nC + 1] != " " return 0 ok
        return KeyName(left(cL, nC - 1))

    func KeyName cK
        nK = len(cK)
        if nK = 0 return 0 ok
        for i = 1 to nK
            c = cK[i]
            if not (isalnum(c) or c = "_" or c = "-") return 0 ok
        next
        return 1

    func SplitKey cL
        nC = substr(cL, ":")
        if nC < 2 Fail("a line of a map is key: value, and this one has no key") ok
        cK = left(cL, nC - 1)
        if not KeyName(cK) Fail("the key " + cK + " uses a character other than letters, digits, _ and -") ok
        if nC < len(cL) and cL[nC + 1] != " " Fail("a key is followed by a colon and a space") ok
        return [cK, trim(substr(cL, nC + 1, len(cL)))]

    # The value after "key:", which may be on the following lines.
    func Value cRest, nInd
        if cRest = "|" or cRest = ">"
            nAt++
            return TextBlock(nInd, cRest = ">")
        ok
        nAt++
        if cRest != "" return Scalar(cRest) ok
        SkipEmpty()
        if nAt > len(aSrc) return ["n"] ok
        n = Indent(aSrc[nAt])
        if n <= nInd
            # a list may sit at the key's own indent
            cL = trim(Uncomment(aSrc[nAt]))
            if n = nInd and (left(cL, 2) = "- " or cL = "-") return Seq(nInd) ok
            return ["n"]
        ok
        return Block(n)

    func TextBlock nInd, bFold
        aOut = []
        nBody = -1
        while nAt <= len(aSrc)
            cL = aSrc[nAt]
            if trim(cL) = ""
                aOut + ""
                nAt++
                loop
            ok
            n = Indent(cL)
            if n <= nInd exit ok
            if nBody < 0 nBody = n ok
            if n < nBody Fail("a line of this text block is indented less than its first line") ok
            aOut + substr(cL, nBody + 1, len(cL))
            nAt++
        end
        while len(aOut) > 0 and aOut[len(aOut)] = "" del(aOut, len(aOut)) end
        cText = ""
        nO = len(aOut)
        for i = 1 to nO
            if i > 1
                if bFold and aOut[i] != "" and aOut[i - 1] != ""
                    cText += " "
                else
                    cText += char(10)
                ok
            ok
            cText += aOut[i]
        next
        return cText

    func Scalar cS
        cS = trim(cS)
        if left(cS, 1) = "[" return FlowList(cS) ok
        if left(cS, 1) = '"' or left(cS, 1) = "'"
            aQ = Quoted(cS, 1)
            if trim(substr(cS, aQ[2], len(cS))) != "" Fail("text follows the closing quote") ok
            return aQ[1]
        ok
        if cS = "true" return ["t"] ok
        if cS = "false" return ["f"] ok
        if cS = "null" or cS = "~" return ["n"] ok
        if left(cS, 1) = "{" or left(cS, 1) = "&" or left(cS, 1) = "*" or left(cS, 1) = "!" or left(cS, 1) = "|" or left(cS, 1) = ">"
            Fail("this file uses a YAML feature Lookout does not read here (" + left(cS, 1) + "); write the value in quotes")
        ok
        return cS

    # A quoted string starting at nFrom; returns [text, the position after the closing quote].
    func Quoted cS, nFrom
        cQ = cS[nFrom]
        cOut = ""
        i = nFrom + 1
        nS = len(cS)
        while i <= nS
            c = cS[i]
            if c = cQ
                if cQ = "'" and i < nS and cS[i + 1] = "'"
                    cOut += "'"
                    i += 2
                    loop
                ok
                return [cOut, i + 1]
            ok
            if cQ = '"' and c = "\" and i < nS
                d = cS[i + 1]
                if d = "n" cOut += char(10)
                but d = "t" cOut += char(9)
                but d = '"' or d = "\" or d = "/" cOut += d
                else Fail("an escape this reader does not know: \" + d) ok
                i += 2
                loop
            ok
            cOut += c
            i++
        end
        Fail("a quoted string is not closed on its line")

    func FlowList cS
        if right(cS, 1) != "]" Fail("a [ list is closed with ] on the same line") ok
        cIn = trim(substr(cS, 2, len(cS) - 2))
        aItems = []
        if cIn = "" return ["[", aItems] ok
        i = 1
        nS = len(cIn)
        while i <= nS
            while i <= nS and cIn[i] = " " i++ end
            if cIn[i] = '"' or cIn[i] = "'"
                aQ = Quoted(cIn, i)
                aItems + aQ[1]
                i = aQ[2]
                while i <= nS and cIn[i] = " " i++ end
                if i <= nS and cIn[i] != "," Fail("items of a [ list are separated by commas") ok
                i++
            else
                nComma = i
                while nComma <= nS and cIn[nComma] != "," nComma++ end
                cItem = trim(substr(cIn, i, nComma - i))
                if cItem = "" Fail("an empty item in a [ list") ok
                aItems + Scalar(cItem)
                i = nComma + 1
            ok
        end
        return ["[", aItems]

# The lines of a text, split on line feeds.
func YamlLines cText
    aOut = []
    cCur = ""
    nT = len(cText)
    for i = 1 to nT
        c = cText[i]
        if ascii(c) = 10
            aOut + cCur
            cCur = ""
        else
            cCur += c
        ok
    next
    if cCur != "" aOut + cCur ok
    return aOut
