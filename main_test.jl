#https://juliahub.com/ui/Packages/General/ImageIO/0.6.0
#https://juliahub.com/ui/Packages/General/ImageShow

using Plots, FileIO, ImageShow, TestImages, ImageTransformations, ColorTypes, Colors, ImageView, Clustering, Random

#Author : Gaëtan Veuillet
#Date : november 2025
#Description : This program analyze a single poster (can be reported for multiple posters) and find the 3 dominant colors using k-means clustering.



#TODO : SEE IF K-MEANS IS REALLX GOOD FOR THIS USAGE, MAYBE TRY GAUSSIAN MIXTURE MODELS OR OTHER METHODS
#TODO : FIND A WAY TO STOCK EVERY DOMINANT COLOR FOR EACH POSTER/AND SO MOVIE, IN A FILE THAT IS WRITABLE AND READABLE FAST (LIKE CSV OR JSON)

#GLOBAL SETTINGS
Random.seed!(42) #For reproducibility and fix k-means randomness

function main()
    files = readdir("posters/") #Only for information and further usage
    nbrFiles = length(files)

    imgToAnalyze = "posters/2.jpg"
    global loaded_img = load(imgToAnalyze)
    p = plot(loaded_img)

    try
        for i in 1:1
            try
                sleep(0.1)
                p = plot()
                new_img = "posters/$(i).jpg"
                loaded_img = load(new_img)
                plot!(loaded_img)
                all_colors = findColors(loaded_img)
                findDominantColors(all_colors, 3)
                gui()
                
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

#Using k means to find dominant colors
function findDominantColors(rgbArray, k) #k = number of colors, in our case it's 3 (for now)
    print("Finding dominant colors...\n")
    data = hcat(
        [r for (r,g,b) in rgbArray],
        [g for (r,g,b) in rgbArray],
        [b for (r,g,b) in rgbArray])'

    #K-means clustering
    result = kmeans(data, k)
    centroids = result.centers
    assignments = result.assignments

    #Calculate the % of each cluster
    counts = [count(==(i), assignments) for i in 1:k]
    total = length(assignments)
    percentages = [c / total for c in counts]

    dominant_colors = [(
        round(Int, c[1]), 
        round(Int, c[2]), 
        round(Int, c[3]),
        round(p*100, digits=2))
        for (c,p) in zip(eachrow(centroids), percentages)]

    print("DOminants colors found !\n")
    println("Dominancts colors : $dominant_colors)\n")
    #Square of each dominant color
    plot!(Shape(
        [-100, -50, -50, -100], 
        [0, 0, 20, 20]),
        color = RGB(dominant_colors[1][1]/255, dominant_colors[1][2]/255, dominant_colors[1][3]/255), 
        label = "Dominant Color 1 - $(dominant_colors[1][4])%")

    plot!(Shape(
        [-100, -50, -50, -100], 
        [50, 50, 70, 70]),
        color = RGB(dominant_colors[2][1]/255, dominant_colors[2][2]/255, dominant_colors[2][3]/255), 
        label = "Dominant Color 2 - $(dominant_colors[2][4])%")

    plot!(Shape(
        [-100, -50, -50, -100], 
        [100, 100, 120, 120]),
        color = RGB(dominant_colors[3][1]/255, dominant_colors[3][2]/255, dominant_colors[3][3]/255), 
        label = "Dominant Color 3 - $(dominant_colors[3][4])%")
end


#Main call
main()



