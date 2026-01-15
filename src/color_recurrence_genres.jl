include("./colors_utils.jl")
using  .ColorUtils, CSV, DataFrames, Plots, Colors

f = ColorUtils.getColor(0,0,0)
println(f)

#----------------------------Get data from CSVs-----------------------------
# Iterate over each CSV file
for f in readdir("data/output/genreCSV/", join=true)
    data = CSV.read(f, DataFrame, delim = ',', select=1:13, silencewarnings=true)
    fileName = last(split(f, "/"))
    # data = CSV.read("data/colorsData_HSV.csv", DataFrame,delim = ',',select=1:13,silencewarnings=true)
    #println(data)

    matrice = Matrix(data)
    matrice_nbL = length(matrice[:,1])
    if matrice_nbL <= 0
        println("[INFO] No data found for file " * fileName)
        break
    end

    matrice_nbC = length(matrice[1,:])
    
    println("===========")
    println(matrice_nbL," X ",matrice_nbC)

    #-----------------------------Get colors from CSV----------------------------
    all_HSV_colors = String[]

    for i in 1:matrice_nbL
        h1 = matrice[i,2]
        s1 = matrice[i,3]
        v1 = matrice[i,4]
        color1 = ColorUtils.getColor(h1,s1,v1)
        push!(all_HSV_colors,color1)

        h2 = matrice[i,6]
        s2 = matrice[i,7]
        v2 = matrice[i,8]
        color2 = ColorUtils.getColor(h2,s2,v2)
        push!(all_HSV_colors,color2)

        h3 = matrice[i,10]
        s3 = matrice[i,11]
        v3 = matrice[i,12]
        color3 = ColorUtils.getColor(h3,s3,v3)
        push!(all_HSV_colors,color3)
    end
    #println(all_HSV_colors)
    # println(all_HSV_colors[1:10])
    # println()
    # println(length(all_HSV_colors))
    # println()

    #----------------------------Get recurrence per color--------------------------
    hsv_colors_recurrence = Dict{String,Int64}()
    color_names = ColorUtils.colors_list

    #initialize dico
    for color in color_names
        hsv_colors_recurrence[color] = 0
    end

    #count for each color how many times it appears
    for color in all_HSV_colors
        hsv_colors_recurrence[color] += 1
    end

    totalCount = 0

    println("Genre : " * fileName)
    println()
    for (color,count) in hsv_colors_recurrence
        println(color, " : ", count)
        totalCount += count
    end

    println()
    println("Total : ",totalCount)

    #Order dico to match colors_list order
    color_counts = [hsv_colors_recurrence[name] for name in color_names]
    bar_colors = [ColorUtils.colors_map[name] for name in color_names]

    plot_bar = Plots.bar(color_names,color_counts,fillcolor = bar_colors, bar_width = 1, title = fileName, xlabel = "Color Names", ylabel = "Recurence", legend = false, xticks = :all, xrotation = 45,size=(1200,800),margin = 15Plots.mm )
    savefig(plot_bar, "plots/hsv_color_rec" * fileName * ".png")
end

#-----------------------------------------------------------------------
