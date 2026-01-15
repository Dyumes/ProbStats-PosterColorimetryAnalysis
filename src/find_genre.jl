include("./colors_utils.jl")
using  .ColorUtils, CSV, DataFrames, Plots, Colors

#----------------------------Get data from CSV-----------------------------
data = CSV.read("data/colorsData_HSV.csv", DataFrame,delim = ',',select=1:13,silencewarnings=true)
#println(data)

matrice = Matrix(data)
matrice_nbL = length(matrice[:,1])
matrice_nbC = length(matrice[1,:])
println(matrice_nbL," X ",matrice_nbC)
println()

#-----------------------------Get colors from CSV----------------------------
all_HSV_colors = Array[]

for i in 1:matrice_nbL
    h1 = matrice[i,2]
    s1 = matrice[i,3]
    v1 = matrice[i,4]
    color1 = ColorUtils.getColor(h1,s1,v1)

    h2 = matrice[i,6]
    s2 = matrice[i,7]
    v2 = matrice[i,8]
    color2 = ColorUtils.getColor(h2,s2,v2)

    h3 = matrice[i,10]
    s3 = matrice[i,11]
    v3 = matrice[i,12]
    color3 = ColorUtils.getColor(h3,s3,v3)

    push!(all_HSV_colors,[color1,color2,color3])
end
#println(all_HSV_colors)
println(length(all_HSV_colors))
println()

#---------------------------- Genre Color Dictionary -------------------------
genre_colors = Dict(
    "Action" => ["red", "black", "orange"],
    "Romance" => ["pink", "magenta", "white"],
    "Horror" => ["black", "red", "grey"],
    "Comedy" => ["yellow", "orange", "light_blue"],
    "Sci-Fi" => ["blue", "cyan", "black"],
    "Drama" => ["grey", "black", "white"],
    "Fantasy" => ["purple", "magenta", "blue"],
    "Thriller" => ["black", "red", "grey"],
    "Adventure" => ["green", "orange", "blue"]
)

#---------------------------- Color Matching Function -------------------------
# Keep importance of dominant colors
function color_match_score_with_duplicates(poster_colors, genre_colors)
    matches = 0
    for pc in poster_colors
        if pc in genre_colors
            matches += 1
        end
    end
    return matches / 3.0
end

# Ignores dominance
function color_match_score_without_duplicates(poster_colors, genre_colors)
    unique_poster = unique(poster_colors) #if [red, red, blue] => [red, blue]
    matches = 0
    for pc in unique_poster
        if pc in genre_colors
            matches += 1
        end
    end
    return matches / length(unique_poster)
end

function find_best_genre(poster_colors, genre_dict, use_duplicates)
    best_genre = ""
    best_score = -1.0
    
    if use_duplicates
        for (genre, colors) in genre_dict
            score = color_match_score_with_duplicates(poster_colors, colors)
            if score > best_score
                best_score = score
                best_genre = genre
            end
        end
    else
        for (genre, colors) in genre_dict
            score = color_match_score_without_duplicates(poster_colors, colors)
            if score > best_score
                best_score = score
                best_genre = genre
            end
        end
    end
    return best_genre, best_score
end

#---------------------------- Match Genres --------------------
genre_results_with_duplicates = String[]
genre_results_without_duplicates = String[]

poster_ids = matrice[:,1]

for i in 1:length(all_HSV_colors)
    poster_id = poster_ids[i]
    poster_colors = all_HSV_colors[i]

    genre, score = find_best_genre(poster_colors, genre_colors, true)
    push!(genre_results_with_duplicates, genre)
    
    genre2, score2 = find_best_genre(poster_colors, genre_colors, false)
    push!(genre_results_without_duplicates, genre2)
    
    # Some differents for comparaison
    if genre != genre2 && i <= 200
        println("$poster_id: With : $genre,$score | Without: $genre2,$score2")
    end
end

#---------------------------- Sorted Genre Distribution --------------------
using StatsBase

genre_counts = countmap(genre_results_with_duplicates)
println("\nGenre distribution with duplicates:")
for (genre, count) in sort(collect(genre_counts), by=x->x[2], rev=true)
    percentage = round(count / length(genre_results_with_duplicates) * 100, digits=1)
    println("$genre: $count ($percentage%)")
end
println()

genre_counts = countmap(genre_results_without_duplicates)
println("\nGenre distribution without duplicates:")
for (genre, count) in sort(collect(genre_counts), by=x->x[2], rev=true)
    percentage = round(count / length(genre_results_without_duplicates) * 100, digits=1)
    println("$genre: $count ($percentage%)")
end