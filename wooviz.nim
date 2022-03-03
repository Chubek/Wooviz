include plotters

let
    width: Tscalar = 640.0
    height: Tscalar = 480.0
    spread: Tscalar = 2.0

    xlim: Tscalar = 10.0
    ylim: Tscalar = 10.0


    offset: Tscalar = 20

    arr1: seq[int] = @[0..5].map(x => rand(10))
    arr2: seq[int] = @[0..5].map(x => rand(10))
    arr3: seq[int] = @[0..5].map(x => rand(10))

    numData: TintData = @[arr1, arr2, arr3]
    labels: TstrData = @["Label 1", "Label 2", "Label 3"]


let image = newImage(int(width) + 20, int(height) + 20)
image.fill(rgba(255, 255, 255, 255))

let ctx = newContext(image)
ctx.fillStyle = rgba(255, 0, 0, 255)



barChart(ctx, image, labels, numData, width, height, offset)
axesNumerical(ctx, xlim, ylim, width, height, spread, offset)

image.writeFile("res/bar.png")