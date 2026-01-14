import csv

def main():
    # Config
    colorFileName = "../../data/output/colorsData_v2.csv"   # Path of the CSV file containing unsorted color data
    movieFileName = "../../data/db/movies.csv"              # Path of the CSV file containing movie data
    outputDir = "../../data/output/csv"                     # Path of the folder where the CSV files will be output
    

    genres = []
    output = {}
    header = ""
    print("Analyzing files...")
    with open(colorFileName, mode='r', encoding="utf-8-sig", newline="") as colorFile, open(movieFileName, mode='r', encoding="utf-8-sig", newline="") as movieFile:
        colorCSV = list(csv.reader(colorFile, delimiter=','))
        movieCSV = list(csv.reader(movieFile, delimiter=','))

        header = colorCSV[0]

        for clrLine in colorCSV:
            for movLine in movieCSV:
                # Gets only the 1st genre
                genre = movLine[-1].split("|")[0]
                
                if not (genre in genres):
                    genres.append(genre)
                    output.update({genre: []})

                if clrLine[0] == movLine[0]:
                    output[genre].append(clrLine)

    print(f"Writing results to '{outputDir}'...")
    for g in genres:
        with open(f"{outputDir}/{g}.csv", mode="w") as file:
            genreCSV = csv.writer(file)
            genreCSV.writerow(header)
            genreCSV.writerows(output[g])

    print("Done (◕‿◕)b !")


if __name__ == "__main__":
    main()
