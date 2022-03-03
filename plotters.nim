import   
    pixie,
    std/math,
    std/sequtils,
    std/sugar,
    std/enumerate,
    std/random

include utils

type
    Tctx =  Context
    TstrData = seq[string]
    TintData =  seq[seq[int]]
    TfloatData =  seq[float]
    TrectData =  seq[Rect]
    Tscalar =   float



proc axesNumerical(ctx: Tctx, xlim, ylim, width, height, spread, offset: Tscalar) = 
    ctx.strokeStyle = "#FF5C00"
    ctx.lineWidth = 10

    let
        startAxisX = vec2(offset, height - offset)
        stopAxisX = vec2(width - offset, height - offset)

        startAxisY = vec2(offset, offset)
        stopAxisY = vec2(offset, height - offset)



    var
        xLabels: TfloatData = @[]
        yLabels: TfloatData = @[]
        xLabelsY: TfloatData = @[]
        yLabelsX: TfloatData = @[]

        i = 0
        j = 0

        spreadY = 0.0
        spreadX = 0.0



    while i <= int(ceil(xlim)):
        xLabels.add(spreadX)
        xLabelsY.add(spreadX)


        spreadX += spread

        i += 1

    while j <= int(ceil(ylim)):
        yLabels.add(spreadY)
        yLabelsX.add(spreadY)

        spreadY += spread

        j += 1

    let
        xLabelsXYRect: TrectData = xLabelsY.map(y => proport(height, y, spreadX)).map(y => (10.0, y)).map(xy => rect(xy[0], xy[1], 8.0, 3.0))
        yLabelsXYRect: TrectData = yLabelsX.map(x => proport(width, x, spreadY)).map(x => (x, height - 20)).map(xy => rect(xy[0], xy[1], 3.0, 8.0))


    apply(xLabelsXYRect, proc(x: Rect) = ctx.fillRect(x))
    apply(yLabelsXYRect, proc(x: Rect) = ctx.fillRect(x))

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
        rectsArr.add(rect(float(idx) * barWidth + offset, height - offset, barWidth, -(height * mv) / maxMax))
        var t = (textData[idx], (float(idx) * barWidth + offset * 2.5, height - offset + (offset / 2)))
        textLocs.add(t)

        
    apply(rectsArr, proc(x: Rect) = ctx.fillRect(x))
    apply(textLocs, proc(x: (string, (float, float))) = image.fillText(font.typeset(x[0], vec2(60, 20)), translate(vec2(x[1][0], x[1][1]))))
