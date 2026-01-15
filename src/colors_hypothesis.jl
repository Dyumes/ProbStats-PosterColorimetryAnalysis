include("./colors_utils.jl")
using  .ColorUtils
# Veuillet Gaëtan
# Genre's 3 most current colors for further comparisons
module genreColorMatching
    using ..ColorUtils
    export get_genre_colors_names,genre_colors_by_our_results

    genre_colors = Dict(
        "Action" => [(0, 0.9, 0.9), (30, 0.85, 0.95), (220, 0.5, 0.25)], 
        "Adventure" => [(120, 0.7, 0.85), (45, 0.75, 0.9), (200, 0.6, 0.8)],
        "Animation" => [(200, 0.8, 0.95), (45, 0.85, 0.95), (300, 0.7, 0.95)],
        "Children" => [(50, 0.9, 0.95), (180, 0.85, 0.95), (300, 0.8, 0.95)],
        "Comedy" => [(60, 0.85, 0.95), (30, 0.8, 0.95), (330, 0.75, 0.9)],
        "Crime" => [(210, 0.6, 0.6), (0, 0.0, 0.2), (270, 0.0, 0.5)],
        "Documentary" => [(40, 0.5, 0.85), (120, 0.4, 0.8), (210, 0.35, 0.75)],
        "Drama" => [(240, 0.5, 0.6), (350, 0.4, 0.65), (30, 0.45, 0.7)],
        "Fantasy" => [(280, 0.7, 0.85), (200, 0.65, 0.8), (140, 0.6, 0.75)],
        "Film-Noir" => [(0, 0.0, 0.1), (220, 0.2, 0.3), (0, 0.0, 0.0)],
        "Horror" => [(0, 0.85, 0.6), (300, 0.7, 0.5), (260, 0.6, 0.4)],
        "Musical" => [(330, 0.8, 0.95), (60, 0.85, 0.95), (180, 0.75, 0.9)],
        "Mystery" => [(260, 0.6, 0.5), (210, 0.5, 0.45), (300, 0.55, 0.55)],
        "Romance" => [(330, 0.7, 0.9), (350, 0.6, 0.95), (300, 0.5, 0.85)],
        "Sci-fi" => [(200, 0.8, 0.85), (220, 0.0, 0.8), (180, 0.65, 0.75)],
        "Thriller" => [(0, 0.7, 0.55), (240, 0.6, 0.5), (300, 0.65, 0.45)],
        "War" => [(100, 0.5, 0.6), (60, 0.4, 0.55), (30, 0.45, 0.5)],
        "Western" => [(30, 0.7, 0.7), (20, 0.6, 0.6), (45, 0.55, 0.65)]
    )

    function get_genre_colors_names()
        genre_colors_map = Dict{String, Array{Any}}()

        for (genre, colors) in genre_colors
            converted_colors = []
            for (h, s, v) in colors
                push!(converted_colors, ColorUtils.getColor(h, s, v))
            end
            genre_colors_map[genre] = converted_colors            
        end
        return genre_colors_map
    end
        


    genre_colors_by_our_results = Dict(
        "Action" => ["orange", "red", "light_blue"], 
        "Adventure" => ["orange", "light_blue", "red"],
        "Animation" => ["orange", "light_blue", "red"],
        "Children" => ["orange", "red", "light_blue"],
        "Comedy" => ["orange","red","light_blue"],
        "Crime" => ["orange","red","yellow"],
        "Documentary" => ["orange","red","yellow"],
        "Drama" => ["orange","red","yellow"],
        "Fantasy" => ["red","orange","yellow"],
        "Film-Noir" => ["yellow","red","orange"],
        "Horror" => ["red","orange","black"],
        "IMAX" => ["yellow","blue", "light_blue"],
        "Musical" => ["orange","red","yellow"],
        "Mystery" => ["orange","red","yellow"],
        "Romance" => ["orange","red","yellow"],
        "Sci-fi" => ["red","light_blue","orange"],
        "Thriller" => ["red","orange","light_blue"],
        "War" => ["orange","red","yellow"],
        "Western" => ["orange","red","yellow"]
    )

end

