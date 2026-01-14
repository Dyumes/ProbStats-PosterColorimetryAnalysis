using Plots, FileIO, ImageShow, TestImages, ImageTransformations, ColorTypes, Colors, ImageView, Random, Statistics, DelimitedFiles, CSV, DataFrames, Clustering

# Author : Gaëtan Veuillet
# Date : november 2025
# Description : Analyze a single poster (or multiple) and find 3 dominant colors using K-means. 
# GUI display, RGB cloud, image reconstruction, and CSV export added.

#TODO : HSV transformation -> csv H, S, V, % of each dominant color

# GLOBAL SETTINGS
Random.seed!(42) # For reproducibility

#Extract each pixel rgb
function findColors(img)
    result = []
    pixels = vec(img)
    print("Finding colors...\n")
    for (i, pixel) in enumerate(pixels)
        r = round(Int, 255 * red(pixel))
        g = round(Int, 255 * green(pixel))
        b = round(Int, 255 * blue(pixel))
        push!(result, (r,g,b))
    end
    print("All colors found!\n")
    return result
end

#K-mean to compute dominant colors
function findDominantColors(rgbArray, k)
    print("Finding dominant colors (K-means)...\n")

    # Convert RGB tuples to 3xN matrix
    X = hcat([Float64[c[1], c[2], c[3]] for c in rgbArray]...)

    # Apply K-means
    res = kmeans(X, k; maxiter=100, display=:none)

    # Extract centroids as dominant colors
    dominant_colors = [(round(Int,res.centers[1,j]),
                        round(Int,res.centers[2,j]),
                        round(Int,res.centers[3,j])) for j in 1:k]

    # Compute percentage of pixels in each cluster
    counts = zeros(Int, k)
    for idx in res.assignments
        counts[idx] += 1
    end
    total_pixels = length(rgbArray)
    percentages = [round(100*c/total_pixels,digits=2) for c in counts]
    dominant_colors_with_pct = [(c[1],c[2],c[3],pct) for (c,pct) in zip(dominant_colors,percentages)]

    println("Dominant colors found!\n")
    println("Dominant colors : $dominant_colors_with_pct\n")

    return dominant_colors_with_pct
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

    clustered_colors = [dominantColors[argmin([sum((px[j]-c[j])^2 for j in 1:3) for c in dominantColors])][1:3] for px in data]

    Rs = [c[1] for c in clustered_colors]
    Gs = [c[2] for c in clustered_colors]
    Bs = [c[3] for c in clustered_colors]
    colors_plot = [RGB(c[1]/255, c[2]/255, c[3]/255) for c in clustered_colors]

    scatter3d(
        Rs, Gs, Bs,
        markersize=2,
        markercolor=colors_plot,
        xlabel="Red", ylabel="Green", zlabel="Blue",
        title="Final centroids after clustering",
        legend=false,
        xlim=(0,255), ylim=(0,255), zlim=(0,255)
    )
end

#Doesnt work correctly
function reconstructImage(img, dominantColors)
    pixels = vec(img)
    dom = [(c[1], c[2], c[3]) for c in dominantColors]
    new_pixels = Vector{RGB}(undef, length(pixels))

    for (i, px) in enumerate(pixels)
        r = round(Int, 255 * red(px))
        g = round(Int, 255 * green(px))
        b = round(Int, 255 * blue(px))

        # Calculer la distance au carré pour chaque couleur dominante
        distances = [ (r - d[1])^2 + (g - d[2])^2 + (b - d[3])^2 for d in dom ]

        # Trouver l'index de la couleur dominante la plus proche
        idx = argmin(distances)
        d = dom[idx]

        # Assigner le pixel à cette couleur
        new_pixels[i] = RGB(d[1]/255, d[2]/255, d[3]/255)
    end

    return reshape(new_pixels, size(img))
end


#Show the 3 dominants colors as blocks
function showDominantColorBlocks(dominantColors)
    p = plot(title="Dominant Colors Blocks", legend=false, xlim=(0,3), ylim=(0,1))
    for (i,color) in enumerate(dominantColors)
        plot!(Shape([i-1,i,i,i-1],[0,0,1,1]),
              color = RGB(color[1]/255, color[2]/255, color[3]/255),
              label = "")
    end
    display(p)
end

#Csv functions
CSV_file = "../data/colorsData.csv"

function resetCsv()
    df = DataFrame(
        id = Int[],
        d_c1_r = Int[], d_c1_g = Int[], d_c1_b = Int[], d_c1_pc = Float64[],
        d_c2_r = Int[], d_c2_g = Int[], d_c2_b = Int[], d_c2_pc = Float64[],
        d_c3_r = Int[], d_c3_g = Int[], d_c3_b = Int[], d_c3_pc = Float64[]
    )
    CSV.write(CSV_file, df)
    print("CSV cleared !\n")
end

function addDominantToCsv(dominantColors, posterId)
    df = DataFrame(
        id = [posterId],
        d_c1_r = dominantColors[1][1], d_c1_g = dominantColors[1][2], d_c1_b = dominantColors[1][3], d_c1_pc = dominantColors[1][4],
        d_c2_r = dominantColors[2][1], d_c2_g = dominantColors[2][2], d_c2_b = dominantColors[2][3], d_c2_pc = dominantColors[2][4],
        d_c3_r = dominantColors[3][1], d_c3_g = dominantColors[3][2], d_c3_b = dominantColors[3][3], d_c3_pc = dominantColors[3][4]
    )
    CSV.write(CSV_file, df, append=true)
    print("CSV file written for poster : ", posterId, "\n")
end

#Main
function main()
    resetCsv()
    files = readdir("../data/posters/") 
    nbrFiles = length(files)

    for i in 1:10
        try
            img_path = "../data/posters/$(i).jpg"
            loaded_img = load(img_path)

            # Extract RGB colors
            all_colors = findColors(loaded_img)

            # Find dominant colors with K-means
            dominantColors = findDominantColors(all_colors, 6)
            addDominantToCsv(dominantColors, i)

            # GUI displays
            display(plot(loaded_img, title="Original Image"))
            readline()
            #sleep(0.5)
            display(plotRGBCloud(all_colors))
            readline()
            #sleep(0.5)
            display(plotClusteredPixelCloud(all_colors, dominantColors))
            readline()
            #sleep(0.5)
            display(plot(reconstructImage(loaded_img, dominantColors), title="Reconstructed Image"))
            readline()
            #sleep(0.5)
            showDominantColorBlocks(dominantColors)
            readline()
            #sleep(0.5)

        catch e
            println("File number $(i) caused an error: $e")
        end
    end
end

# Run main
main()
