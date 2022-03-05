include plotters

let
    width: Tscalar = 640.0
    height: Tscalar = 480.0
    spread: Tscalar = 2.0

    xlim: Tscalar = 10.0
    ylim: Tscalar = 10.0


    offset: Tscalar = 30

var
    arr1: seq[int] = @[]
    arr2: seq[int] = @[]
    arr3: seq[int] = @[]

for _ in 0..5:
    arr1.add(rand(10))
    arr2.add(rand(10))
    arr3.add(rand(10))

let
    numData: TintData = @[arr1, arr2, arr3]
    labels: TstrData = @["Label 1", "Label 2", "Label 3"]


let image = newImage(int(width), int(height))
image.fill(rgba(255, 255, 255, 255))

let ctx = newContext(image)
ctx.fillStyle = rgba(255, 0, 0, 255)


barChart(ctx, image, labels, numData, width, height, offset)
axesNumerical(ctx, image, numData, xlim, ylim, width, height, spread, offset, 1)

image.writeFile("res/bar.png")