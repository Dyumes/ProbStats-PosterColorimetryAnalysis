using Plots, FileIO, ImageShow, TestImages, ImageTransformations,
      ColorTypes, Colors, ImageView, Random, Statistics,
      DelimitedFiles, CSV, DataFrames, Clustering

# Author : Gaëtan Veuillet
# Date : november 2025
# Description : Analyze a single poster (or multiple) and find 3 dominant colors using K-means.
# GUI display, RGB cloud, image reconstruction, and CSV export added.

# GLOBAL SETTINGS
Random.seed!(42) # For reproducibility

#Extract each pixel rgb
function findColors(img)
    result = []
    pixels = vec(img)
    #print("Finding colors...\n")
    for pixel in pixels
        r = round(Int, 255 * red(pixel))
        g = round(Int, 255 * green(pixel))
        b = round(Int, 255 * blue(pixel))
        push!(result, (r,g,b))
    end
    #print("All colors found\n")
    return result
end

"""Returns the HSV values (Hue = [0,255], Saturation = [0,1], Value = [0,1])"""
function RGBtoHSV(r::Number, g::Number, b::Number)
    r /= 255
    g /= 255
    b /= 255

    maxRGB = max(r, g, b)
    minRGB = min(r, g, b)
    delta = maxRGB - minRGB

    value = maxRGB    # V = Value
    hue = 0.0         # H = Hue
    saturation = 0.0  # S = Saturation

    if value != 0
        saturation = delta / value
    end

    if delta != 0
        if maxRGB == r
            hue = 60 * ((g - b) / delta)
        elseif maxRGB == g
            hue = 60 * (2 + (b - r) / delta)
        else
            hue = 60 * (4 + (r - g) / delta)
        end
    end

    if hue < 0
        hue += 360
    end

    hue = hue * 255 / 360
    return (hue, saturation, value)
end

#K-mean to compute dominant colors (HSV)
function findDominantColors(rgbArray, k)
    #print("Finding dominant colors (K-means HSV)...\n")

    hsvArray = [RGBtoHSV(c[1], c[2], c[3]) for c in rgbArray]
    X = hcat([Float64[h[1], h[2], h[3]] for h in hsvArray]...)

    res = kmeans(X, k; maxiter=100, display=:none)

    counts = zeros(Int, k)
    for idx in res.assignments
        counts[idx] += 1
    end

    total_pixels = length(rgbArray)
    percentages = [round(100*c/total_pixels, digits=2) for c in counts]

    dominantColors = [(res.centers[1,j],
                       res.centers[2,j],
                       res.centers[3,j],
                       percentages[j]) for j in 1:k]

    dominantColors = sort(dominantColors, by=x->x[4], rev=true)[1:3]

    println("Dominant HSV colors : $dominantColors\n")
    return dominantColors
end

#Rgb 3d visualization
function plotRGBCloud(rgbArray; max_points=50000)
    N = length(rgbArray)
    data = N > max_points ? rgbArray[randperm(N)[1:max_points]] : rgbArray

    Rs = [c[1] for c in data]
    Gs = [c[2] for c in data]
    Bs = [c[3] for c in data]
    colors_plot = [RGB(c[1]/255, c[2]/255, c[3]/255) for c in data]

    scatter3d(
        Rs, Gs, Bs,
        markersize = 2,
        markercolor = colors_plot,
        xlabel = "Red", ylabel = "Green", zlabel = "Blue",
        title = "RGB Pixel Distribution (3D Point Cloud)",
        legend = false,
        xlim = (0,255), ylim = (0,255), zlim = (0,255)
    )
end

#Dominant color cloud visualization
function plotClusteredPixelCloud(rgbArray, dominantColors; max_points=2000)
    N = length(rgbArray)
    data = N > max_points ? rgbArray[randperm(N)[1:max_points]] : rgbArray

    dom_rgb = [
        RGB(HSV(c[1] * 360 / 255, c[2], c[3]))
        for c in dominantColors
    ]

    clustered_colors = [
        dom_rgb[argmin([
            (RGB(px[1]/255,px[2]/255,px[3]/255).r-d.r)^2 +
            (RGB(px[1]/255,px[2]/255,px[3]/255).g-d.g)^2 +
            (RGB(px[1]/255,px[2]/255,px[3]/255).b-d.b)^2
            for d in dom_rgb
        ])]
        for px in data
    ]

    Rs = [round(Int,255*c.r) for c in clustered_colors]
    Gs = [round(Int,255*c.g) for c in clustered_colors]
    Bs = [round(Int,255*c.b) for c in clustered_colors]

    scatter3d(
        Rs, Gs, Bs,
        markersize=2,
        markercolor=clustered_colors,
        xlabel="Red", ylabel="Green", zlabel="Blue",
        title="Final centroids after clustering",
        legend=false,
        xlim=(0,255), ylim=(0,255), zlim=(0,255)
    )
end

function reconstructImage(img, dominantColors)
    pixels = vec(img)

    dom_rgb = [
        RGB(HSV(c[1] * 360 / 255, c[2], c[3]))
        for c in dominantColors
    ]

    new_pixels = Vector{RGB}(undef, length(pixels))

    for (i, px) in enumerate(pixels)
        distances = [(px.r-d.r)^2 + (px.g-d.g)^2 + (px.b-d.b)^2 for d in dom_rgb]
        new_pixels[i] = dom_rgb[argmin(distances)]
    end

    return reshape(new_pixels, size(img))
end

#Show the 3 dominants colors as blocks
function showDominantColorBlocks(dominantColors)
    p = plot(title="Dominant Colors Blocks", legend=false, xlim=(0,3), ylim=(0,1))
    for (i,color) in enumerate(dominantColors)
        rgb = RGB(HSV(color[1] * 360 / 255, color[2], color[3]))
        plot!(Shape([i-1,i,i,i-1],[0,0,1,1]),
              color = rgb,
              label = "")
    end
    display(p)
end

#Csv functions
CSV_file = "../data/colorsData_HSV.csv"

function resetCsv()
    df = DataFrame(
        id = Int[],
        d_c1_h = Float64[], d_c1_s = Float64[], d_c1_v = Float64[], d_c1_pc = Float64[],
        d_c2_h = Float64[], d_c2_s = Float64[], d_c2_v = Float64[], d_c2_pc = Float64[],
        d_c3_h = Float64[], d_c3_s = Float64[], d_c3_v = Float64[], d_c3_pc = Float64[]
    )
    CSV.write(CSV_file, df)
    print("CSV cleared\n")
end

function addDominantToCsv(dominantColors, posterId)
    df = DataFrame(
        id = [posterId],
        d_c1_h = dominantColors[1][1], d_c1_s = dominantColors[1][2], d_c1_v = dominantColors[1][3], d_c1_pc = dominantColors[1][4],
        d_c2_h = dominantColors[2][1], d_c2_s = dominantColors[2][2], d_c2_v = dominantColors[2][3], d_c2_pc = dominantColors[2][4],
        d_c3_h = dominantColors[3][1], d_c3_s = dominantColors[3][2], d_c3_v = dominantColors[3][3], d_c3_pc = dominantColors[3][4]
    )
    CSV.write(CSV_file, df, append=true)
    print("CSV file written for poster : ", posterId, "\n")
end

#Main
function main()
    resetCsv()
    files = readdir("../data/posters/")

    for i in 1:131262
        try
            img_path = "../data/posters/$(i).jpg"
            loaded_img = load(img_path)

            all_colors = findColors(loaded_img)
            dominantColors = findDominantColors(all_colors, 6)
            addDominantToCsv(dominantColors, i)

            #display(plot(loaded_img, title="Original Image")); readline()
            #display(plotRGBCloud(all_colors)); readline()
            #display(plotClusteredPixelCloud(all_colors, dominantColors)); readline()
            #display(plot(reconstructImage(loaded_img, dominantColors), title="Reconstructed Image")); readline()
            #showDominantColorBlocks(dominantColors); readline()

        catch e
            println("File number $(i) caused an error: $e")
        end
    end
end

# Run main
main()
