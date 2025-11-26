# ProbStats-PosterColorimetryAnalysis

## Adding a Dependency
**Make sure Julia is opened in the project:**
```sh
# Press "]" to enter pkg mode
(@v1.11) pkg> activate . # Modify "." to path to the project

# If successfully opened in the project, should display
(<ProjectName>) pkg>
```

Then, to add a dependency, type in the Julia CLI: 
```sh
# Press "]" to enter pkg mode
(<ProjectName>) pkg> add pkg_name
```

Other useful commands:
```sh
# To remove a package
(<ProjectName>) pkg> remove pkg_name

# To update all packages to latest version
(<ProjectName>) pkg> update pkg_name
```

## Dominants colors finder
### *Description*

The [dominantsColors.jl](./src/dominantsColors.jl) file has the following goals :
- Finding every colors on each pixel of a poster image -> (DONE) ;
- Finding the 3 dominants colors and their porcentage in a poster -> (DONE) ;
    - Using [Median cut](https://fr.wikipedia.org/wiki/Median_cut).
- Storing all the data for further analysis and comparaison (DONE);
    - Data into [colorsData.csv]()

### *Libraries*
`using Plots, FileIO, ImageShow, TestImages, ImageTransformations, ColorTypes, Colors, ImageView, Clustering, Random
`

All of these libraries have to be installed using the julia pkg installer.
Inside a terminal : 

`julia` > press `]` in the the REPL julia to enter in package mode > `add Plots FileIO ImageShow TestImages ImageTransformations ColorTypes Colors ImageView Clustering Random`.

## CSV sorting
*This program sorts the color analysis results to different files according to the genre of the movie poster.* 
The code is located in `/src/python`.  

To execute it, launch *[main.py](src/python/main.py)* (using `uv run` with uv for example)

***You can change the paths if needed at the beginning of the file***
