# Veuillet Gaëtan
# Check if the genre found correspond to the real movie genre -> 
#TODO : do simple stats (bernoulli), a bit harder -> matrix of confusion ?


using CSV, DataFrames, Random

""" EXEMPLE OF IMPLEMENTATION WHEN CARO HAVE FINISHED
genres_csv = extract_first_genres("../data/db/movies.csv")
genres_found = [...,...,...,...]
results = check_if_colors_right(genres_found, genres_csv) # a 0 and 1 array btw
show_stats(results) 

"""
#Extract the first genre of the movies and return a list
function extract_first_genres(csv_path::String)
    df = CSV.read(csv_path, DataFrame)
    
    first_genres = map(df.genres) do genres_str
        if ismissing(genres_str) || isempty(strip(genres_str))
            return ""
        end
        return split(genres_str, "|")[1]
    end
    
    return first_genres
end


function check_if_colors_right(genres_found, genres_csv)::Vector{Bool}
    if length(genres_found) != length(genres_csv)
        error("-GENRES FOUND & OG GENRES ARENT THE SAME LENGTH-")
    end
    
    return genres_found .== genres_csv
end

function compute_success_rate(match_results::Vector{Bool})::Float64
    return sum(match_results) / length(match_results)
end

function show_stats(match_results::Vector{Bool})
    total = length(match_results)
    successes = sum(match_results)
    failures = total - successes
    success_rate = successes / total
    
    println("//Ez stats//")
    println("Nbr of movies: $total")
    println("Success: $successes")
    println("Errors: $failures")
    println("Success %: $(round(success_rate * 100, digits=2))%")
end



# --TEST UNITAIRES--

function generate_test_genres(genres_csv, success_rate::Float64)::Vector{String}
    if !(0.0 <= success_rate <= 1.0)
        error("success_rate must be between 0.0 and 1.0")
    end
    
    n = length(genres_csv)
    n_correct = round(Int, n * success_rate)
    
    test_genres = copy(genres_csv)
    
    n_incorrect = n - n_correct
    incorrect_indices = shuffle(1:n)[1:n_incorrect]
    
    all_genres = ["Action", "Adventure", "Animation", "Children", "Comedy", 
                  "Crime", "Documentary", "Drama", "Fantasy", "Film-Noir",
                  "Horror", "Musical", "Mystery", "Romance", "Sci-Fi", 
                  "Thriller", "War", "Western"]
    
    for idx in incorrect_indices
        original = test_genres[idx]
        available = filter(g -> g != original, all_genres)
        test_genres[idx] = rand(available)
    end
    
    return test_genres
end



println("LOADING CSV GENRE...")
genres_csv = extract_first_genres("../data/db/movies.csv")
println("$(length(genres_csv)) MOVIES\n")

# Test 1: 100% of success
println("TEST 1: 100% of success")
test_100 = copy(genres_csv)
results_100 = check_if_colors_right(test_100, genres_csv)
show_stats(results_100)
println()

# Test 2: ~90% of success
println("TEST 2: ~90% of success")
test_90 = generate_test_genres(genres_csv, 0.90)
results_90 = check_if_colors_right(test_90, genres_csv)
show_stats(results_90)
println()

# Test 3: ~75% of success
println("TEST 3: ~75% of success")
test_75 = generate_test_genres(genres_csv, 0.75)
results_75 = check_if_colors_right(test_75, genres_csv)
show_stats(results_75)
println()

# Test 4: ~50% of success
println("TEST 4: ~50% of success")
test_50 = generate_test_genres(genres_csv, 0.50)
results_50 = check_if_colors_right(test_50, genres_csv)


show_stats(results_50)
println()

# Test 5: ~25% of success
println("TEST 5: ~25% of success")
test_25 = generate_test_genres(genres_csv, 0.25)
results_25 = check_if_colors_right(test_25, genres_csv)
show_stats(results_25)
println()

# Test 6: 0% of success
println("TEST 6: 0% of success")
test_0 = generate_test_genres(genres_csv, 0.0)
results_0 = check_if_colors_right(test_0, genres_csv)
show_stats(results_0)
println()

# Résumé
println("-" ^ 50)
println("RRESUME OF ALL TESTS")
println("-" ^ 50)
println("Test 100%: $(round(compute_success_rate(results_100) * 100, digits=2))%")
println("Test 90%:  $(round(compute_success_rate(results_90) * 100, digits=2))%")
println("Test 75%:  $(round(compute_success_rate(results_75) * 100, digits=2))%")
println("Test 50%:  $(round(compute_success_rate(results_50) * 100, digits=2))%")
println("Test 25%:  $(round(compute_success_rate(results_25) * 100, digits=2))%")
println("Test 0%:   $(round(compute_success_rate(results_0) * 100, digits=2))%")