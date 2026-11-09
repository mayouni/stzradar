# The radar for agents: a small, read-only MCP server over the signed feed.
#
#   haro tools/mcp.ring            run from the repository root; speaks MCP over standard input and output
#   haro tools/mcp.ring <folder>   the same, for the radar checked out in <folder>
#
# An agent that supports MCP (Claude Code, an IDE, any MCP client) starts this program and asks it
# questions while it works: what this week asks of a developer, which signals touch a part of the
# project, one signal in full. Everything comes from the radar's own files -- feed/index.json, the map,
# app/config.json -- and nothing is answered until feed/index.json's signature checks against
# keys/allowed_signers (ssh-keygen does the cryptography, as tools/feed.ring verify does).
#
# The protocol: JSON-RPC 2.0, one message per line (MCP's stdio transport). It answers initialize,
# ping, tools/list and tools/call, and ignores notifications. Nothing it does writes a file.

load "feedlib.ring"

cRoot = ""
oCfg = NULL
oMap = NULL
aItems = []
aDigests = []
cTrust = ""            # "" when the signature checked; otherwise why it did not

func main
    $cRoot = currentdir()
    if len(sysargv) >= 3 $cRoot = sysargv[3] ok
    LoadRadar()
    nEmpty = 0
    while true
        give cLine
        if cLine = ""
            nEmpty++
            if nEmpty > 3 exit ok          # the client closed our input
            loop
        ok
        nEmpty = 0
        Handle(cLine)
    end

# ---------------------------------------------------------------- the radar's data

func LoadRadar
    oR = new JsonReader
    try
        oIndex = oR.Parse(read($cRoot + "/feed/index.json"), "feed/index.json")
        $aItems = JItems(JGet(oIndex, "items"))
        $oCfg = oR.Parse(read($cRoot + "/app/config.json"), "app/config.json")
    catch e
        $cTrust = "the radar's files could not be read from " + $cRoot + ": " + e.Message()
        return
    done
    try
        $oMap = oR.Parse(read($cRoot + "/" + Cf("map")), "map")
    catch
        $cTrust = "the map " + Cf("map") + " could not be read"
        return
    done
    if fexists($cRoot + "/app/digests.json")
        try
            $aDigests = JItems(oR.Parse(read($cRoot + "/app/digests.json"), "digests"))
        catch
            $aDigests = []
        done
    ok
    $cTrust = CheckSignature()

# The feed is trusted only when its signature checks; ssh-keygen's own words are kept off our output,
# which carries the protocol.
func CheckSignature
    cIdx = $cRoot + "/feed/index.json"
    if not fexists(cIdx + ".sig") return "feed/index.json has no signature (feed/index.json.sig)" ok
    if not fexists($cRoot + "/keys/allowed_signers") return "there is no key to check the feed against (keys/allowed_signers)" ok
    cQuiet = " >/dev/null 2>&1"
    if iswindows() cQuiet = " >nul 2>&1" ok
    cCmd = "ssh-keygen -Y verify -f " + Q($cRoot + "/keys/allowed_signers") + " -I " + Cf("feed.signer") +
           " -n " + Cf("feed.namespace") + " -s " + Q(cIdx + ".sig") + " < " + Q(cIdx) + cQuiet
    if system(cCmd) != 0 return "feed/index.json's signature does not check against keys/allowed_signers (or ssh-keygen is missing)" ok
    return ""

func Q c
    return '"' + c + '"'

# one value of app/config.json by its dotted path
func Cf cPath
    v = $oCfg
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
    if isstring(v) return v ok
    return ""

func S o, k
    if JKind(o) != "object" return "" ok
    v = JGet(o, k)
    if isstring(v) return v ok
    return ""

func Word cLevel
    if cLevel = "info" return "To know" ok
    if cLevel = "advice" return "To consider" ok
    if cLevel = "action" return "To do" ok
    if cLevel = "urgent" return "To do now" ok
    return cLevel

func LevelRank cLevel
    return find(["info", "advice", "action", "urgent"], cLevel)

func RelRank c
    return find(["low", "medium", "high"], c)

# ISO week of a "YYYY-MM-DD" date, as "YYYY-Www"
func IsoWeek cDate
    y = number(left(cDate, 4)) m = number(substr(cDate, 6, 2)) d = number(substr(cDate, 9, 2))
    aCum = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
    nOrd = aCum[m] + d
    if m > 2 and Leap(y) nOrd++ ok
    nW = floor((nOrd - Dow(y, m, d) + 10) / 7)
    if nW < 1
        y--
        nW = WeeksIn(y)
    but nW > WeeksIn(y)
        y++
        nW = 1
    ok
    cW = "" + nW
    if nW < 10 cW = "0" + cW ok
    return "" + y + "-W" + cW

func Leap y
    return (y % 4 = 0 and y % 100 != 0) or y % 400 = 0

# Monday 1 .. Sunday 7
func Dow y, m, d
    t = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
    if m < 3 y-- ok
    n = (y + floor(y / 4) - floor(y / 100) + floor(y / 400) + t[m] + d) % 7
    if n = 0 return 7 ok
    return n

func WeeksIn y
    if P(y) = 4 or P(y - 1) = 3 return 53 ok
    return 52

func P y
    return (y + floor(y / 4) - floor(y / 100) + floor(y / 400)) % 7

# the project ids an entry touches: its areas through the map's ids and aliases
func ProjectsOf o
    aOut = []
    vA = JGet(o, "areas")
    if JKind(vA) != "array" return aOut ok
    aA = JItems(vA)
    aP = JItems(JGet($oMap, "projects"))
    nA = len(aA) nP = len(aP)
    for i = 1 to nA
        cA = lower(aA[i])
        cHead = cA
        nDot = substr(cA, ".")
        if nDot > 0 cHead = left(cA, nDot - 1) ok
        cHit = ""
        for k = 1 to nP
            cId = S(aP[k], "id")
            if cA = cId or cHead = cId cHit = cId exit ok
            vAl = JGet(aP[k], "aliases")
            if JKind(vAl) = "array"
                aAl = JItems(vAl) nAl = len(aAl)
                for j = 1 to nAl
                    if lower(aAl[j]) = cA or lower(aAl[j]) = cHead cHit = cId exit 2 ok
                next
            ok
        next
        if cHit != "" and find(aOut, cHit) = 0 aOut + cHit ok
    next
    return aOut

func LayersOf o
    aOut = []
    aPr = ProjectsOf(o)
    aP = JItems(JGet($oMap, "projects"))
    n = len(aPr) nP = len(aP)
    for i = 1 to n
        for k = 1 to nP
            if S(aP[k], "id") = aPr[i]
                cL = S(aP[k], "layer")
                if find(aOut, cL) = 0 aOut + cL ok
            ok
        next
    next
    return aOut

func NameOf cList, cId
    aX = JItems(JGet($oMap, cList))
    n = len(aX)
    for i = 1 to n
        if S(aX[i], "id") = cId return S(aX[i], "name") ok
    next
    return cId

func HasIn o, cKey, cId
    v = JGet(o, cKey)
    if JKind(v) != "array" return 0 ok
    return find(JItems(v), cId) > 0

# newest week the survey closed (it has a digest), else the newest week that holds an entry
func LatestWeek
    cBest = ""
    n = len($aDigests)
    for i = 1 to n
        if isstring($aDigests[i]) and $aDigests[i] > cBest cBest = $aDigests[i] ok
    next
    if cBest != "" return cBest ok
    n = len($aItems)
    for i = 1 to n
        w = IsoWeek(S($aItems[i], "date"))
        if w > cBest cBest = w ok
    next
    return cBest

# most pressing first: level, then relevance, then newest
func SortItems aIn
    a = aIn
    n = len(a)
    for i = 2 to n
        j = i
        while j > 1 and Before(a[j], a[j - 1])
            t = a[j] a[j] = a[j - 1] a[j - 1] = t
            j--
        end
    next
    return a

func Before a, b
    la = LevelRank(S(a, "level")) lb = LevelRank(S(b, "level"))
    if la != lb return la > lb ok
    ra = RelRank(S(a, "relevance")) rb = RelRank(S(b, "relevance"))
    if ra != rb return ra > rb ok
    return S(a, "date") > S(b, "date")

func ReaderOk c
    return find(["developer", "maintainer", "learner", "user"], c) > 0

# one signal in a few lines, for a list
func Brief o, cReader, nNo
    c = "" + nNo + ". [" + Word(S(o, "level")) + "] " + S(o, "title") + char(10)
    cLine = ""
    vN = JGet(o, "notice")
    if JKind(vN) = "object" cLine = S(vN, cReader) ok
    if cLine = "" cLine = S(o, "summary") ok
    c += "   " + cLine + char(10)
    aPr = ProjectsOf(o)
    aNames = []
    n = len(aPr)
    for i = 1 to n aNames + NameOf("projects", aPr[i]) next
    c += "   touches: " + Joined(aNames, ", ") + " | id: " + S(o, "id") + " | " + S(o, "date") + char(10)
    return c

func Joined a, cSep
    c = ""
    n = len(a)
    for i = 1 to n
        if i > 1 c += cSep ok
        c += a[i]
    next
    return c

# ---------------------------------------------------------------- the tools

func ToolList
    cR = '"reader":{"type":"string","enum":["developer","maintainer","learner","user"],"description":"who the answer is written for; default developer"}'
    return '{"tools":[' +
      '{"name":"radar_week","description":"The signals of one week, most pressing first, each with the sentence written for the reader. Without a week, the latest surveyed week.",' +
      '"inputSchema":{"type":"object","properties":{"week":{"type":"string","description":"ISO week, e.g. 2026-W45"},' + cR + '}}},' +
      '{"name":"radar_search","description":"Signals that match every filter given: a project, layer, domain or concern of the map (ids from radar_map), a lowest level, a week, or words in the title or summary.",' +
      '"inputSchema":{"type":"object","properties":{"project":{"type":"string"},"layer":{"type":"string"},"domain":{"type":"string"},"concern":{"type":"string"},' +
      '"level_at_least":{"type":"string","enum":["info","advice","action","urgent"]},"week":{"type":"string"},"text":{"type":"string"},' + cR + '}}},' +
      '{"name":"radar_signal","description":"One signal in full: what happened, the sentence for each reader, what was proposed, its sources and its page.",' +
      '"inputSchema":{"type":"object","properties":{"id":{"type":"string","description":"the signal id, from radar_week or radar_search"}},"required":["id"]}},' +
      '{"name":"radar_map","description":"The project map signals are placed on: layers, parts (projects), domains and concerns, with the ids the other tools take.",' +
      '"inputSchema":{"type":"object","properties":{}}}' +
      ']}'

func Arg oArgs, k
    if JKind(oArgs) != "object" return "" ok
    return S(oArgs, k)

func CallTool cName, oArgs
    if $cTrust != "" return [1, "The radar did not answer: " + $cTrust + ". Its feed is trusted only when its signature checks."] ok
    cReader = lower(Arg(oArgs, "reader"))
    if not ReaderOk(cReader) cReader = "developer" ok
    if cName = "radar_week" return [0, ToolWeek(Arg(oArgs, "week"), cReader)] ok
    if cName = "radar_search" return [0, ToolSearch(oArgs, cReader)] ok
    if cName = "radar_signal" return ToolSignal(Arg(oArgs, "id")) ok
    if cName = "radar_map" return [0, ToolMap()] ok
    return [1, "There is no tool named " + cName + "; the tools are radar_week, radar_search, radar_signal and radar_map."]

func ToolWeek cWeek, cReader
    if cWeek = "" cWeek = LatestWeek() ok
    aW = []
    n = len($aItems)
    for i = 1 to n
        o = $aItems[i]
        if IsoWeek(S(o, "date")) = cWeek and S(o, "status") != "superseded" aW + o ok
    next
    if len(aW) = 0 return Cf("watch.title") + " holds no signal for week " + cWeek + "." ok
    aW = SortItems(aW)
    cN = "" + len(aW) + " signals"
    if len(aW) = 1 cN = "1 signal" ok
    c = Cf("watch.title") + ", week " + cWeek + ": " + cN + ", written for a " + cReader + "." + char(10) + char(10)
    n = len(aW)
    for i = 1 to n c += Brief(aW[i], cReader, i) next
    c += char(10) + "Ask radar_signal with an id for the whole signal."
    return c

func ToolSearch oArgs, cReader
    cP = lower(Arg(oArgs, "project")) cL = lower(Arg(oArgs, "layer")) cD = lower(Arg(oArgs, "domain"))
    cC = lower(Arg(oArgs, "concern")) cV = lower(Arg(oArgs, "level_at_least")) cW = Arg(oArgs, "week")
    cT = lower(Arg(oArgs, "text"))
    aHit = []
    n = len($aItems)
    for i = 1 to n
        o = $aItems[i]
        if S(o, "status") = "superseded" loop ok
        if cP != "" and find(ProjectsOf(o), cP) = 0 loop ok
        if cL != "" and find(LayersOf(o), cL) = 0 loop ok
        if cD != "" and not HasIn(o, "domains", cD) loop ok
        if cC != "" and not HasIn(o, "concerns", cC) loop ok
        if cV != "" and LevelRank(S(o, "level")) < LevelRank(cV) loop ok
        if cW != "" and IsoWeek(S(o, "date")) != cW loop ok
        if cT != "" and substr(lower(S(o, "title") + " " + S(o, "summary")), cT) = 0 loop ok
        aHit + o
    next
    if len(aHit) = 0 return "No signal matches these filters. radar_map lists the ids the filters take." ok
    aHit = SortItems(aHit)
    cN = "" + len(aHit) + " signals match"
    if len(aHit) = 1 cN = "1 signal matches" ok
    c = cN + ", most pressing first, written for a " + cReader + "." + char(10) + char(10)
    n = len(aHit)
    for i = 1 to n c += Brief(aHit[i], cReader, i) next
    return c

func ToolSignal cId
    n = len($aItems)
    for i = 1 to n
        o = $aItems[i]
        if S(o, "id") = cId
            NL1 = char(10)
            c = S(o, "title") + NL1 + NL1
            c += "Level: " + Word(S(o, "level")) + ". Kind: " + S(o, "kind") + ". Stance: " + S(o, "stance") + ". Relevance: " +
                 S(o, "relevance") + ". Date: " + S(o, "date") + ". Week: " + IsoWeek(S(o, "date")) + "." + NL1 + NL1
            c += "What happened: " + S(o, "summary") + NL1
            vN = JGet(o, "notice")
            if JKind(vN) = "object"
                c += NL1 + "For each reader:" + NL1
                aP = vN[2] nP = len(aP)
                for k = 1 to nP
                    if isstring(aP[k][2]) c += "- " + aP[k][1] + ": " + aP[k][2] + NL1 ok
                next
            ok
            vA = JGet(o, "actions")
            if JKind(vA) = "array" and len(JItems(vA)) > 0
                c += NL1 + "Proposed:" + NL1
                aA = JItems(vA) nA = len(aA)
                for k = 1 to nA c += "- " + S(aA[k], "area") + ": " + S(aA[k], "do") + " (" + S(aA[k], "state") + ")" + NL1 next
            ok
            vS = JGet(o, "sources")
            if JKind(vS) = "array"
                c += NL1 + "Sources:" + NL1
                aS = JItems(vS) nS = len(aS)
                for k = 1 to nS c += "- " + S(aS[k], "title") + ": " + S(aS[k], "url") + NL1 next
            ok
            c += NL1 + "Page: " + Cf("watch.pages") + "items/" + left(cId, 4) + "/" + cId + ".md"
            return [0, c]
        ok
    next
    return [1, "There is no signal " + cId + "; radar_week and radar_search give the ids."]

func ToolMap
    NL1 = char(10)
    c = "The map of " + Cf("project.name") + " (id: name)." + NL1
    aLists = [["layers", "Layers"], ["projects", "Parts"], ["domains", "Domains"], ["concerns", "Concerns"]]
    for q = 1 to 4
        cList = aLists[q]
        c += NL1 + cList[2] + ":" + NL1
        aX = JItems(JGet($oMap, cList[1]))
        n = len(aX)
        for i = 1 to n
            c += "- " + S(aX[i], "id") + ": " + S(aX[i], "name")
            if cList[1] = "projects" c += " (layer " + S(aX[i], "layer") + ")" ok
            c += NL1
        next
    next
    return c

# ---------------------------------------------------------------- the protocol

func Handle cLine
    oR = new JsonReader
    try
        oMsg = oR.Parse(cLine, "message")
    catch
        Send('{"jsonrpc":"2.0","id":null,"error":{"code":-32700,"message":"Parse error"}}')
        return
    done
    if JKind(oMsg) != "object" return ok
    if not JHas(oMsg, "id") return ok                       # a notification: nothing to answer
    cId = JLine(JGet(oMsg, "id"))
    cMethod = S(oMsg, "method")
    oParams = JGet(oMsg, "params")
    if cMethod = "initialize"
        cVer = S(oParams, "protocolVersion")
        if cVer = "" cVer = "2025-06-18" ok
        Result(cId, '{"protocolVersion":' + JQuote(cVer) + ',"capabilities":{"tools":{}},' +
            '"serverInfo":{"name":"softanza-radar","title":' + JQuote(Cf("watch.title")) + ',"version":"1.0.0"},' +
            '"instructions":' + JQuote(Cf("watch.title") + ": " + Cf("watch.tagline") + ". Start with radar_week; use radar_map for the ids radar_search takes.") + '}')
        return
    ok
    if cMethod = "ping" Result(cId, "{}") return ok
    if cMethod = "tools/list" Result(cId, ToolList()) return ok
    if cMethod = "tools/call"
        oArgs = ["n"]
        if JKind(oParams) = "object" oArgs = JGet(oParams, "arguments") ok
        aR = CallTool(S(oParams, "name"), oArgs)
        cErr = "false"
        if aR[1] cErr = "true" ok
        Result(cId, '{"content":[{"type":"text","text":' + JQuote(aR[2]) + '}],"isError":' + cErr + '}')
        return
    ok
    Send('{"jsonrpc":"2.0","id":' + cId + ',"error":{"code":-32601,"message":' + JQuote("Method not found: " + cMethod) + '}}')

func Result cId, cJson
    Send('{"jsonrpc":"2.0","id":' + cId + ',"result":' + cJson + '}')

func Send c
    see c + char(10)
    Flush()

# Haro buffers a program's output when it goes to a pipe, and has no flush for it yet; system() flushes
# it before running its command, so an empty command sends each reply now. The client waits on every reply,
# so without this nothing would arrive until the program ended. Reported to the Haro desk (HARO-STDIOFLUSH-01):
# give should flush before it waits for input, as C's stdio does, or Haro should offer flush().
func Flush
    if iswindows() system("rem") else system(":") ok

# a JSON value on one line (the stdio transport carries one message per line)
func JLine v
    k = JKind(v)
    if k = "string" return JQuote(v) ok
    if k = "number" return v[2] ok
    if k = "boolean"
        if v[1] = "t" return "true" ok
        return "false"
    ok
    if k = "null" return "null" ok
    c = ""
    aI = v[2]
    n = len(aI)
    for i = 1 to n
        if i > 1 c += "," ok
        if k = "array" c += JLine(aI[i]) else c += JQuote(aI[i][1]) + ":" + JLine(aI[i][2]) ok
    next
    if k = "array" return "[" + c + "]" ok
    return "{" + c + "}"
