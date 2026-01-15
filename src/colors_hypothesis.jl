# Veuillet Gaëtan
# Genre's 3 most current colors for further comparisons

module genreColorMatching
    export genre_colors

    genre_colors = Dict(
        "Action" => [(0, 90, 90), (30, 85, 95), (220, 50, 25)], 
        "Adventure" => [(120, 70, 85), (45, 75, 90), (200, 60, 80)],
        "Animation" => [(200, 80, 95), (45, 85, 95), (300, 70, 95)],
        "Children" => [(50, 90, 95), (180, 85, 95), (300, 80, 95)],
        "Comedy" => [(60, 85, 95), (30, 80, 95), (330, 75, 90)],
        "Crime" => [(210, 60, 60), (0, 0, 20), (270, 40, 50)],
        "Documentary" => [(40, 50, 85), (120, 40, 80), (210, 35, 75)],
        "Drama" => [(240, 50, 60), (350, 40, 65), (30, 45, 70)],
        "Fantasy" => [(280, 70, 85), (200, 65, 80), (140, 60, 75)],
        "Film-Noir" => [(0, 0, 10), (220, 20, 30), (0, 0, 40)],
        "Horror" => [(0, 85, 60), (300, 70, 50), (260, 60, 40)],
        "Musical" => [(330, 80, 95), (60, 85, 95), (180, 75, 90)],
        "Mystery" => [(260, 60, 50), (210, 50, 45), (300, 55, 55)],
        "Romance" => [(330, 70, 90), (350, 60, 95), (300, 50, 85)],
        "Sci-fi" => [(200, 80, 85), (220, 70, 80), (180, 65, 75)],
        "Thriller" => [(0, 70, 55), (240, 60, 50), (300, 65, 45)],
        "War" => [(100, 50, 60), (60, 40, 55), (30, 45, 50)],
        "Western" => [(30, 70, 70), (20, 60, 60), (45, 55, 65)]
    )


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
