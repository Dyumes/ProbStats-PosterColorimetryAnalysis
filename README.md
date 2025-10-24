# ProbStats-PosterColorimetryAnalysis

## Adding a Dependency
**Make sure Julia is opened in the project: **
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