import std/parsecsv
from std/os import paramStr
from std/streams import newFileStream


proc `-]>`(file: string): seq[seq[string]] =
    var s = newFileStream(paramStr(1), fmRead)
    if s == nil:
        quit("cannot open the file" & paramStr(1))

    var x: CsvParser
    open(x, s, paramStr(1))
    while readRow(x):
        var sub: seq[string] = @[]
        for val in items(x.row):
            sub.add(val)

        result.add(sub)
    close(x)



proc proport(fortyFive, two, ninety: float): float =
    result = (fortyFive * two) / ninety