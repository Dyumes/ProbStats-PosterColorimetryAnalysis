include("./colors_utils.jl")
using  .ColorUtils, CSV, DataFrames, Plots, Colors

#-----------------------------Get colors from CSV----------------------------
function get_colors_from_CSV(matrice)
    all_HSV_colors = []

    matrice_nbL = length(matrice[:,1])

    for i in 1:matrice_nbL
        # Color 1
        h1 = matrice[i,2]
        s1 = matrice[i,3]
        v1 = matrice[i,4]
        p1 = matrice[i,5]
        color1 = (ColorUtils.getColor(h1,s1,v1), p1)
        push!(all_HSV_colors,color1)

        # Color 2
        h2 = matrice[i,6]
        s2 = matrice[i,7]
        v2 = matrice[i,8]
        p2 = matrice[i,9]
        color2 = (ColorUtils.getColor(h2,s2,v2), p2)
        push!(all_HSV_colors,color2)

        # Color 3
        h3 = matrice[i,10]
        s3 = matrice[i,11]
        v3 = matrice[i,12]
        p3 = matrice[i,13]
        color3 = (ColorUtils.getColor(h3,s3,v3), p3)
        push!(all_HSV_colors,color3)
    end
    #println(all_HSV_colors)
    println(all_HSV_colors[1:10])
    println()
    println(length(all_HSV_colors))
    println()
    return all_HSV_colors
end

function get_color_recurrence_w_percent(input_path::String, genre_name, output_path::String, debug::Bool=false)
    # ==== Get data from CSV =====
    data = CSV.read(input_path, DataFrame,delim = ',',select=1:13,silencewarnings=true)
    #println(data)

    matrice = Matrix(data)
    matrice_nbL = length(matrice[:,1])
    if matrice_nbL <= 0
        println("[INFO] No data found in this file")
        return;
    end
    matrice_nbC = length(matrice[1,:])

    if (debug)
        println(matrice_nbL," X ",matrice_nbC)
        println()
    end

    # ==== Get recurrence per color =====
    hsv_colors_recurrence = Dict{String,Float64}()
    color_names = ColorUtils.colors_list

    # Initialize dictionnary
    for color in color_names
        hsv_colors_recurrence[color] = 0
    end

    # Get colors from CSV
    all_HSV_colors = get_colors_from_CSV(data_matrice)

    # Count for each color how many times it appears
    for color in all_HSV_colors
        value_to_add = (color[2] / 100)
        hsv_colors_recurrence[color[1]] += value_to_add
    end

    totalCount = 0

    for (color,count) in hsv_colors_recurrence
        if (debug) println(color, " : ", count) end
        totalCount += count
    end

    if (debug)
        println()
        println("Total : ",totalCount)
    end

    #Order dico to match colors_list order
    color_counts = [((hsv_colors_recurrence[name] / totalCount) * 100) for name in color_names]
    bar_colors = [ColorUtils.colors_map[name] for name in color_names]

    plot_bar = Plots.bar(
        color_names,
        color_counts,
        fillcolor=bar_colors, 
        bar_width=1,
        title=genre_name, 
        xlabel="Color Names", 
        ylabel="Recurrence", 
        legend=false, 
        xticks=:all, 
        xrotation=45,
        size=(1200,800),
        margin=15Plots.mm
    )
    savefig(plot_bar, output_path * genre_name * ".png")
end

function get_color_recurrence_w_percent_per_genre(path::String, debug::Bool=false)
    for f in readdir(path, join=true)
        fileName = last(split(f, "/"))
        if (debug) println("Genre : " * fileName) end
        if (debug) println("File : " * f) end

        get_color_recurrence_w_percent(f, fileName, "./plots_p/", true)
    end
end

get_color_recurrence_w_percent("./data/colorsData_HSV.csv", "all", "./plots_p/", true)


get_color_recurrence_w_percent_per_genre("./data/output/genreCSV/", true)