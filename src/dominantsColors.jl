#https://juliahub.com/ui/Packages/General/ImageIO/0.6.0
#https://juliahub.com/ui/Packages/General/ImageShow

using Plots, FileIO, ImageShow, TestImages, ImageTransformations, ColorTypes, Colors, ImageView, Random, Statistics, DelimitedFiles, CSV, DataFrames

#Author : Gaëtan Veuillet
#Date : november 2025
#Description : This program analyze a single poster (can be reported for multiple posters) and find the 3 dominant colors using Median Cut.

#TODO : SEE IF MEDIAN CUT IS GOOD. IDK IF WE CAN USE PROCENTAGE OF OTHER NON DOMINANT COLORS
#TODO : CSV FILE WITH ID AND 3 DOMINATNS(R1, G1, B1, R2, G2, B2, ...) COLORS + FREE SPACE FOR GENRE

#GLOBAL SETTINGS
Random.seed!(42) #For reproducibility and fix randomness

function main()
    resetCsv()
    files = readdir("../data/posters/") #Only for information and further usage
    nbrFiles = length(files)

    imgToAnalyze = "../data/posters/2.jpg"
    global loaded_img = load(imgToAnalyze)
    p = plot(loaded_img)

    try
        for i in 1:10
            try
                #Only for visual information
                #sleep(0.5)
                #p = plot()
                new_img = "../data/posters/$(i).jpg"
                loaded_img = load(new_img)
                
                #Only for visual information
                #plot!(loaded_img)
                all_colors = findColors(loaded_img)
                dominantColors = findDominantColors(all_colors, 3)
                addDominantToCsv(dominantColors, i)
                #Only for visual information
                #gui()
            catch e
                println("Files nbr : $(i) caused an error: $e")
            end
        end
    catch e
        println("Interrupted by user") #Doesn't work yet :(, it's for CTRL + C
    end

end

function findColors(img)
    result = []
    pixels = vec(img)
    print("Finding colors...\n")
    for (i, pixel) in enumerate(pixels)
        r = round(Int, 255 * red(pixel))
        g = round(Int, 255*green(pixel))
        b = round(Int, 255*blue(pixel))
        push!(result, (r,g,b))
        #println("Pixel $i : R=$r, G=$g, B=$b")
    end
    print("All colors found !\n")
    return result
end

#Using Median Cut to find dominant colors
function findDominantColors(rgbArray, k) #k = number of colors, in our case it's 3 (for now)
    print("Finding dominant colors (Median Cut)...\n")
    
    #Start with all pixels in one box
    boxes = [rgbArray]

    #Split boxes until we have k boxes
    while length(boxes) < k
        max_range = 0
        box_idx = 0
        axis_idx = 0
        for (i, box) in enumerate(boxes)
            #Compute range per channel
            ranges = [maximum([c[j] for c in box]) - minimum([c[j] for c in box]) for j in 1:3]
            local_max = maximum(ranges)
            if local_max > max_range
                max_range = local_max
                box_idx = i
                axis_idx = findfirst(==(local_max), ranges)
            end
        end

        #Split the selected box along axis with largest range
        box = boxes[box_idx]
        sorted_box = sort(box, by = x -> x[axis_idx])
        mid = Int(floor(length(sorted_box)/2))
        box1 = sorted_box[1:mid]
        box2 = sorted_box[mid+1:end]
        boxes[box_idx] = box1
        push!(boxes, box2)
    end

    #Compute the mean color of each box (initial dominant colors)
    dominant_colors = []
    for box in boxes
        r = round(Int, mean([c[1] for c in box]))
        g = round(Int, mean([c[2] for c in box]))
        b = round(Int, mean([c[3] for c in box]))
        push!(dominant_colors, (r,g,b))
    end

    #Compute true percentages based on all pixels of the image
    counts = zeros(Int, length(dominant_colors))
    for pixel in rgbArray
        #Find index of closest dominant color
        distances = [sqrt(sum((pixel[i]-c[i])^2 for i in 1:3)) for c in dominant_colors]
        idx = argmin(distances)
        counts[idx] += 1
    end
    total_pixels = length(rgbArray)
    percentages = [round(100*c/total_pixels,digits=2) for c in counts]
    dominant_colors_with_pct = [(c[1],c[2],c[3],pct) for (c,pct) in zip(dominant_colors,percentages)]

    print("DOminant colors found!\n")
    println("Dominant colors : $dominant_colors_with_pct\n")

    #Square of each dominant color
    for (i,color) in enumerate(dominant_colors_with_pct)
        plot!(Shape(
            [-100, -50, -50, -100], 
            [20*(i-1), 20*(i-1), 20*i, 20*i]),
            color = RGB(color[1]/255, color[2]/255, color[3]/255),
            label = "Dominant Color $i - $(color[4])%")
    end

    return dominant_colors_with_pct
end

CSV_file = "../data/colorsData.csv"

function resetCsv()
    df = DataFrame(
        id = Int[],
        d_c1_r = Int[], d_c1_g = Int[], d_c1_b = Int[], d_c1_pc = Float64[],
        d_c2_r = Int[], d_c2_g = Int[], d_c2_b = Int[], d_c2_pc = Float64[],
        d_c3_r = Int[], d_c3_g = Int[], d_c3_b = Int[], d_c3_pc = Float64[],
    )

    CSV.write(CSV_file, df)
    print("CSV cleared !\n")
end

function addDominantToCsv(dominantColors, posterId)
    #print("Dominants Colors : ", dominantColors, " Poster's ID : ", posterId)
    df = DataFrame(
        #ID - for each color(R - G - B - %)
        id = [posterId],
        d_c1_r = dominantColors[1][1],
        d_c1_g = dominantColors[1][2],
        d_c1_b = dominantColors[1][3],
        d_c1_pc = dominantColors[1][4],

        d_c2_r = dominantColors[2][1],
        d_c2_g = dominantColors[2][2],
        d_c2_b = dominantColors[2][3],
        d_c2_pc = dominantColors[2][4],

        d_c3_r = dominantColors[3][1],
        d_c3_g = dominantColors[3][2],
        d_c3_b = dominantColors[3][3],
        d_c3_pc = dominantColors[3][4],
    )

    CSV.write(CSV_file, df, append=true)
    #print("\n", dominantColors[1][1])
    print("CSV file written for poster : ", posterId)

end

#Main call
main()
