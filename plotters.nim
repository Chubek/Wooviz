import   
    pixie,
    std/math,
    std/sequtils,
    std/sugar,
    std/enumerate,
    std/random,
    std/strformat,
    std/algorithm

include utils

type
    Tctx =  Context
    TstrData = seq[string]
    TintData =  seq[seq[int]]
    TfloatData =  seq[float]
    TrectData =  seq[Rect]
    Tscalar =   float


proc axesNumerical(ctx: Tctx, image: Image, numData: TintData, xlim, ylim, width, height, spread, offset: Tscalar, step: int) = 
    ctx.strokeStyle = "#FF5C00"
    ctx.lineWidth = offset / 2.0

    let
        maxVals: TfloatData = numData.map(x => float(max(x)))

        maxMax = float(max(maxVals))

        startAxisX = vec2(offset, height - offset)
        stopAxisX = vec2(width - offset, height - offset)

        startAxisY = vec2(offset, offset)
        stopAxisY = vec2(offset, height - offset)



    var
        yNumbers: seq[float] = @[]

        i = 0


        numStep = 0

        font = readFont("assets/Ubuntu-Regular_1.ttf")



    font.size = 10

    while i <= maxMax.toInt() div step:
        yNumbers.add(numStep.toFloat())

        numStep += step


        i += 1


    let
        xLabelsXYRect: TrectData = yNumbers.map(y => proport(height - offset, y, maxMax)).map(y => (
            offset / 2, y + offset)).map(xy => rect(xy[0], xy[1], offset / 2.0, offset / 4.0))
        
        xLabelsXYNum: seq[(int, float, float)] = yNumbers.map(
            y => (y, proport(height - offset, y, maxMax))).map(y => (y[0].toInt(), offset / 18.0, y[1] + offset))
        


    apply(xLabelsXYNum, proc(x: (int, float, float)) = image.fillText(
        font.typeset(fmt"{maxMax.toInt() - x[0]}", vec2(15, 5), hAlign=CenterAlign),
        translate(vec2(x[1], x[2]))))
    

    apply(xLabelsXYRect, proc(x: Rect) = ctx.fillRect(x))

    ctx.strokeSegment(segment(startAxisX, stopAxisX))
    ctx.strokeSegment(segment(startAxisY, stopAxisY))



proc barChart(ctx: Tctx, image: Image, textData: TstrData, numData: TintData, width, height, offset: Tscalar) =
    let 
        maxVals: TfloatData = numData.map(x => float(max(x)))

        maxMax = float(max(maxVals))

        size = float(textData.len())

        barWidth = ceil(width / size) - (ceil(width / size) / size)

    var 
        font = readFont("assets/Roboto-Regular_1.ttf")
        rectsArr: TrectData = @[]
        textLocs: seq[(string, (float, float))] = @[]
    
    font.size = 12
        
    for idx, mv in enumerate(maxVals):
        rectsArr.add(rect(float(idx) * barWidth + offset, height - offset, barWidth, -((height - offset) * mv) / maxMax))
        var t = (textData[idx], (float(idx) * barWidth + offset * 2.5, height - offset + (offset / 3)))
        textLocs.add(t)

        
    apply(rectsArr, proc(x: Rect) =
                            var randR: float = rand(255.0)
                            var randColor: Color = Color(r: randR, g: 255.0, b: 255.0)
                            ctx.fillStyle = rgb(randColor)
                            ctx.fillRect(x))

    apply(textLocs, proc(x: (string, (float, float))) = image.fillText(font.typeset(x[0], vec2(60, offset)), translate(vec2(x[1][0], x[1][1]))))
