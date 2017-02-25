## ecospace: R Package for Simulating Community Assembly and Ecological Diversification Using Ecospace Frameworks

ecospace is an R package that implements stochastic simulations of community 
assembly (ecological diversification) using customizable ecospace frameworks 
(functional trait spaces). Simulations model the 'neutral', 'redundancy', 
'partitioning', and 'expansion' models of Bush and Novack-Gottshall (2012) and
Novack-Gottshall (2016a, b). The package provides a wrapper to calculate common
ecological disparity and functional ecology statistical dynamics as a function
of species richness. Functions are written so they will work in a
parallel-computing environment.

The package also contains a sample data set, functional traits for Late 
Ordovician (Type Cincinnatian) fossil species from the Kope and Waynesville 
formations.

The most recent public release of the code is on CRAN at:

http://cran.r-project.org/web/packages/ecospace

You can install the most recent public release version in R using:

	install.packages("ecospace")

The latest pre-release version can be found at GitHub:

	https://github.com/pnovack-gottshall/ecospace

Or downloaded directly in R using:

	library(devtools)
	devtools::install_github("pnovack-gottshall/ecospace")
	library(ecospace)
	

## References

Novack-Gottshall, P.M. 2016a. General models of ecological diversification. 
I. Conceptual synthesis. Paleobiology 42: 185-208.

Novack-Gottshall, P.M. 2016b. General models of ecological diversification. 
II. Simulations and empirical applications. Paleobiology 42: 209-239.

Bush, A. and P.M. Novack-Gottshall. 2012. Modelling the ecological-functional 
diversification of marine Metazoa on geological time scales. Biology Letters 8: 
151-155.

Reprints are available at https://www.researchgate.net/profile/Philip_Novack-Gottshall/contributions.

The most recent commit is currently: [![Travis-CI Build 
Status](https://travis-ci.org/pnovack-gottshall/ecospace.svg?branch=master)](https://travis-ci.org/pnovack-gottshall/ecospace)
(Travis CI)

This package is authored by Phil Novack-Gottshall 
(<mailto:pnovack-gottshall@ben.edu>) and offered under CC0.

The current total number of downloads of the ecospace package from the RStudio 
CRAN mirror is: [![Number of 
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/ecospace)](https://github.com/metacran/cranlogs.app)
