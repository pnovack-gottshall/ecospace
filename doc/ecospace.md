---
title: "ecospace: Simulating Community Assembly and Ecological Diversification Using Ecospace Frameworks"
author: "Phil Novack-Gottshall"
date: "2020-06-11"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{ecospace}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

ecospace is an R package that implements stochastic simulations of community assembly (ecological diversification) using customizable ecospace frameworks (functional trait spaces). Simulations model the 'neutral', 'redundancy', 'partitioning', and 'expansion' models of Bush and Novack-Gottshall (2012) and Novack-Gottshall (2016a,b). It provides a wrapper to calculate common ecological disparity and functional ecology statistical dynamics as a function of species richness. Functions are written so they will work in a parallel-computing environment.

The package also contains a sample data set, functional traits for Late Ordovician (Type Cincinnatian) fossil species from the Kope and Waynesville formations, from Novack-Gottshall (2016b).

### References
Bush, A. and P.M. Novack-Gottshall. 2012. Modelling the ecological-functional diversification of marine Metazoa on geological time scales. *Biology Letters* 8: 151-155.

Novack-Gottshall, P.M. 2016a. General models of ecological diversification. I. Conceptual synthesis. *Paleobiology* 42: 185-208.

Novack-Gottshall, P.M. 2016b. General models of ecological diversification. II. Simulations and empirical applications. *Paleobiology* 42: 209-239.


---------

## Create an ecospace framework (functional trait space)

Start by creating an ecospace framework with 9 characters: 3 as factors, 3 as ordered factors, and 3 as ordered numeric types. The framework is fully customizable, allowing users to use most character types, define unique character and state names, and constrain possible states (either by a set number of 'multiple presences' or by weighting the state according to a species pool).


```r
library(ecospace)
nchar <- 9
ecospace <- create_ecospace(nchar=nchar, char.state=rep(3, nchar),
  char.type=rep(c("factor", "ord.fac", "ord.num"), nchar / 3))
```


---------

## Use ecospace framework to simulate a 50-species assemblage using the 'neutral' rule

In the 'neutral' model, all species have states chosen at random from the ecospace framework. 

```r
Smax <- 50
set.seed(314)
neutral_sample <- neutral(Sseed=5, Smax=Smax, ecospace=ecospace)
head(neutral_sample, 10)
```

```
##     char1  char2 char3   char4   char5 char6   char7   char8 char9
## 1  state3 state4   1.0 state10 state12   0.0 state17 state20   1.0
## 2  state1 state6   0.5  state9 state13   1.0 state17 state20   1.0
## 3  state3 state5   0.0  state9 state12   0.5 state15 state18   1.0
## 4  state3 state4   0.5  state8 state13   0.5 state17 state19   1.0
## 5  state3 state6   1.0  state9 state11   0.5 state16 state18   1.0
## 6  state3 state4   1.0  state9 state11   1.0 state17 state19   0.0
## 7  state1 state4   1.0 state10 state12   0.5 state16 state19   0.0
## 8  state3 state5   0.0  state8 state11   0.0 state17 state19   0.0
## 9  state1 state5   0.0 state10 state12   0.5 state16 state19   0.0
## 10 state2 state6   0.0  state8 state12   0.5 state16 state18   0.5
```

## Compare with assemblages built using the 'redundancy', 'partitioning', and 'expansion' rules

### Redundancy rules

The redundancy rules add species with traits redundant to those previously added. We will start the simulation by 'seeding' the assemblage with 5 species at random (before the rule starts). 


```r
set.seed(314)
Sseed=5
redund_sample <- redundancy(Sseed=Sseed, Smax=Smax, ecospace=ecospace)
```

Note that the number of functionally unique species will not change after the simulation begins in the default rule. Although there are 50 species, there are only 5 functionally unique entities.

```r
unique(redund_sample)
```

```
##    char1  char2 char3   char4   char5 char6   char7   char8 char9
## 1 state3 state4   1.0 state10 state12   0.0 state17 state20     1
## 2 state1 state6   0.5  state9 state13   1.0 state17 state20     1
## 3 state3 state5   0.0  state9 state12   0.5 state15 state18     1
## 4 state3 state4   0.5  state8 state13   0.5 state17 state19     1
## 5 state3 state6   1.0  state9 state11   0.5 state16 state18     1
```


Relax the rule so that new species are on average 95% functionally identical to pre-existing ones:

```r
set.seed(314)
redund_sample2 <- redundancy(Sseed=Sseed, Smax=Smax, ecospace=ecospace, strength=0.95)
```

Plot both 'redundancy' assemblages (using PCA with Gower dissimilarity), showing order of assembly. Seed species in red, next 5 in black, remainder in gray. Notice the redundancy models produce an ecospace with discrete clusters of life habits.

```r
library(FD, quietly=TRUE)
```

```
## This is vegan 2.5-6
```

```r
pc <- prcomp(FD::gowdis(redund_sample))
plot(pc$x, type="n", main=paste("Redundancy model,\n", Smax, "species"))
text(pc$x[,1], pc$x[,2], labels=seq(Smax), col=c(rep("red", Sseed), rep("black", 5),
  rep("slategray", (Smax - Sseed - 5))), pch=c(rep(19, Sseed), rep(21, (Smax - Sseed))),
  cex=.8)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

```r
pc.r <- prcomp(FD::gowdis(redund_sample2))
plot(pc.r$x, type="n", main=paste("Redundancy model (95% identical),\n", Smax, "species"))
text(pc.r$x[,1], pc.r$x[,2], labels=seq(Smax), col=c(rep("red", Sseed), rep("black", 5),
  rep("slategray", (Smax - Sseed - 5))), pch=c(rep(19, Sseed), rep(21, (Smax - Sseed))),
  cex=.8)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-2.png)
  

### Partitioning rules

The partitioning rules add species with traits intermediate to those previously added. We will start the simulation by 'seeding' the assemblage with 5 species at random (before the rule starts). 

The rules can be implemented in a "strict" (the default) version:

```r
set.seed(314)
Sseed=5
partS_sample <- partitioning(Sseed=Sseed, Smax=Smax, ecospace=ecospace)
```

Or in a "relaxed" version:

```r
set.seed(314)
Sseed=5
partR_sample <- partitioning(Sseed=Sseed, Smax=Smax, ecospace=ecospace, rule="relaxed")
```

Plot both 'partitioning' assemblages, showing order of assembly. Notice both partitioning models produce gradients, with the 'strict' version having linear gradients and the 'relaxed' version filling the centroid.

```r
pc.ps <- prcomp(FD::gowdis(partS_sample))
plot(pc.ps$x, type="n", main=paste("'Strict' partitioning model,\n", Smax, "species"))
text(pc.ps$x[,1], pc$x[,2], labels=seq(Smax), col=c(rep("red", Sseed), rep("black", 5),
  rep("slategray", (Smax - Sseed - 5))), pch=c(rep(19, Sseed), rep(21, (Smax - Sseed))),
  cex=.8)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png)

```r
pc.pr <- prcomp(FD::gowdis(partR_sample))
plot(pc.pr$x, type="n", main=paste("'Relaxed' partitioning model,\n", Smax, "species"))
text(pc.pr$x[,1], pc.pr$x[,2], labels=seq(Smax), col=c(rep("red", Sseed), rep("black", 5),
  rep("slategray", (Smax - Sseed - 5))), pch=c(rep(19, Sseed), rep(21, (Smax - Sseed))),
  cex=.8)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-2.png)




### Expansion rules

The expansion rules add species with traits maximally different from those previously added. We will start the simulation by 'seeding' the assemblage with 5 species at random (before the rule starts). 


```r
set.seed(314)
Sseed=5
exp_sample <- expansion(Sseed=Sseed, Smax=Smax, ecospace=ecospace)
```

Plot the assemblage, showing order of assembly. Notice how later species consistently expand the ecospace, exploring previously unexplored parts of the exospace.

```r
pc.e <- prcomp(FD::gowdis(exp_sample))
plot(pc.e$x, type="n", main=paste("Expansion model,\n", Smax, "species"))
text(pc.e$x[,1], pc$x[,2], labels=seq(Smax), col=c(rep("red", Sseed), rep("black", 5),
  rep("slategray", (Smax - Sseed - 5))), pch=c(rep(19, Sseed), rep(21, (Smax - Sseed))),
  cex=.8)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png)


### Visually comparing four rules
It is instructive to compare the four models graphically. This is possible here because set.seed() was used when running each simulation, so they all share the same starting configurations. Plotting using vegan:metaMDS in two dimensions for improved visualization of simulation dynamics.


```r
library(vegan, quietly=TRUE)
start <- neutral_sample[1:Sseed,]
neu <- neutral_sample[(Sseed + 1):Smax,]
red <- redund_sample2[(Sseed + 1):Smax,]
par <- partR_sample[(Sseed + 1):Smax,]
exp <- exp_sample[(Sseed + 1):Smax,]
nmds.data <- rbind(start, neu, red, par, exp)
all <- metaMDS(gowdis(nmds.data), zerodist="add", k=2, trymax=10)
```

```
## Run 0 stress 0.2951275 
## Run 1 stress 0.2964677 
## Run 2 stress 0.301422 
## Run 3 stress 0.3028072 
## Run 4 stress 0.301234 
## Run 5 stress 0.3036484 
## Run 6 stress 0.3015024 
## Run 7 stress 0.3071218 
## Run 8 stress 0.3089082 
## Run 9 stress 0.3085946 
## Run 10 stress 0.2956312 
## Run 11 stress 0.3070162 
## Run 12 stress 0.2963661 
## Run 13 stress 0.3028339 
## Run 14 stress 0.2994072 
## Run 15 stress 0.3088487 
## Run 16 stress 0.2990526 
## Run 17 stress 0.2975779 
## Run 18 stress 0.3118919 
## Run 19 stress 0.2970432 
## Run 20 stress 0.3010247 
## *** No convergence -- monoMDS stopping criteria:
##      1: no. of iterations >= maxit
##     19: stress ratio > sratmax
```

```r
plot(all$points[,1], all$points[,2], col=c(rep("red", Sseed), rep("orange", nrow(neu)), rep("red", nrow(red)), rep("blue", nrow(par)), rep("purple", nrow(exp))), pch=c(rep(19, Sseed), rep(21, nrow(neu)), rep(22, nrow(red)), rep(23, nrow(par)), rep(24, nrow(exp))), main=paste("Combined models,\n", Smax, "species per model"), xlab="Axis 1", ylab="Axis 2", cex=2, cex.lab=1.5, lwd=1)

leg.txt <- c("seed", "neutral", "redundancy", "partitioning", "expansion")
leg.col <- c("red", "orange", "red", "blue", "purple")
leg.pch <- c(19, 21, 22, 23, 24)
legend("topright", inset=.02, legend=leg.txt, pch=leg.pch, col=leg.col, cex=.75)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)

---------

## Calculate ecological disparity (functional diversity) metrics

The package wraps around dbFD() in package FD to calculate common ecological disparity and functional diversity statistics. Statistics are calculated incrementally so dynamics can be understood as a function of species richness. See ?calc_metrics for explanation of each statistic.

(Note: warnings are turned off in this vignette, caused by attempting to calculate the total variance (V) on factor characters.)

Several users have requested changes to calc_metrics() to allow simple statistical calculation for the entire sample (instead of doing so incrementally). Starting with version 1.2.1, the argument increm=FALSE allows this functionality.


```r
# Using Smax=10 here to illustrate calculation for first 25 species in neutral assemblage
options(warn = -1)
metrics <- calc_metrics(samples=neutral_sample, Smax=10, Model="Neutral")
metrics
```

```
##      Model Param  S  H         D         M  V       FRic      FEve      FDiv
## 1  Neutral        1  1 0.0000000 0.0000000  0 0.00000000 0.0000000 0.0000000
## 2  Neutral        2  2 0.6666667 0.6666667 NA 0.00000000 0.0000000 0.0000000
## 3  Neutral        3  3 0.5925926 0.6111111 NA 0.00000000 0.0000000 0.0000000
## 4  Neutral        4  4 0.5185185 0.6111111 NA 0.01370026 0.9375000 0.8625152
## 5  Neutral        5  5 0.4777778 0.5555556 NA 0.02101865 0.8930041 0.9039789
## 6  Neutral        6  6 0.4691358 0.5555556 NA 0.02491659 0.9125000 0.9107635
## 7  Neutral        7  7 0.4761905 0.6388889 NA 0.02966768 0.9249088 0.8388073
## 8  Neutral        8  8 0.4720238 0.6703704 NA 0.04293560 0.9372212 0.8128629
## 9  Neutral        9  9 0.4624486 0.6574074 NA 0.05520866 0.9502268 0.8668060
## 10 Neutral       10 10 0.4718107 0.7777778 NA 0.08349234 0.9662675 0.8152025
##         FDis qual.FRic
## 1  0.0000000 0.0000000
## 2  0.0000000 0.0000000
## 3  0.0000000 0.0000000
## 4  0.3158627 1.0000000
## 5  0.3058220 0.9855804
## 6  0.3056585 0.9099909
## 7  0.3143135 0.8418771
## 8  0.3138985 0.8224502
## 9  0.3138736 0.6489874
## 10 0.3229843 0.6164307
```


```r
# Calculate statistics for just the entire sample
options(warn = -1)
metrics <- calc_metrics(samples=neutral_sample, increm=FALSE)
metrics
```

```
##    Model Param  S  H         D         M  V      FRic      FEve     FDiv
## 50             50 50 0.4408858 0.8888889 NA 0.1936463 0.9961949 0.768834
##         FDis qual.FRic
## 50 0.3196247 0.2027004
```

The more typical use of calc_metrics() is to calculate statistics incrementally (which is the default behavior).


```r
# Using Smax=10 here to illustrate calculation for first 10 species in neutral assemblage
options(warn = -1)
metrics <- calc_metrics(samples=neutral_sample, Smax=10, Model="Neutral", increm=TRUE)
metrics
```

```
##      Model Param  S  H         D         M  V       FRic      FEve      FDiv
## 1  Neutral        1  1 0.0000000 0.0000000  0 0.00000000 0.0000000 0.0000000
## 2  Neutral        2  2 0.6666667 0.6666667 NA 0.00000000 0.0000000 0.0000000
## 3  Neutral        3  3 0.5925926 0.6111111 NA 0.00000000 0.0000000 0.0000000
## 4  Neutral        4  4 0.5185185 0.6111111 NA 0.01370026 0.9375000 0.8625152
## 5  Neutral        5  5 0.4777778 0.5555556 NA 0.02101865 0.8930041 0.9039789
## 6  Neutral        6  6 0.4691358 0.5555556 NA 0.02491659 0.9125000 0.9107635
## 7  Neutral        7  7 0.4761905 0.6388889 NA 0.02966768 0.9249088 0.8388073
## 8  Neutral        8  8 0.4720238 0.6703704 NA 0.04293560 0.9372212 0.8128629
## 9  Neutral        9  9 0.4624486 0.6574074 NA 0.05520866 0.9502268 0.8668060
## 10 Neutral       10 10 0.4718107 0.7777778 NA 0.08349234 0.9662675 0.8152025
##         FDis qual.FRic
## 1  0.0000000 0.0000000
## 2  0.0000000 0.0000000
## 3  0.0000000 0.0000000
## 4  0.3158627 1.0000000
## 5  0.3058220 0.9855804
## 6  0.3056585 0.9099909
## 7  0.3143135 0.8418771
## 8  0.3138985 0.8224502
## 9  0.3138736 0.6489874
## 10 0.3229843 0.6164307
```


The functions are written so they can be run 'in parallel'. Although not run here, the following provides an example of how this can be implemented using lapply(), here building 25 'neutral' samples of 20 species each and then calculating disparity metrics on each.

Note the code will take a few seconds to run to completion.


```r
nreps <- 1:25 # A sequence of the samples to be simulated
n.samples <- lapply(X=nreps, FUN=neutral, Sseed=3, Smax=20, ecospace)

# Calculate functional diversity metrics for simulated samples
n.metrics <- lapply(X=nreps, FUN=calc_metrics, samples=n.samples, Model="neutral", Param="NA")

# Combine lists together into a single dataframe (the function is new to this package)
all <- rbind_listdf(n.metrics)

# Calculate mean dynamics across simulations
means <- n.metrics[[1]]
for(n in 1:20) means[n,4:11] <- apply(all[which(all$S==means$S[n]),4:11], 2, mean, na.rm=TRUE)

# Plot statistics as function of species richness, overlaying mean dynamics
par(mfrow=c(2,4), mar=c(4, 4, 1, .3))
attach(all)

plot(S, H, type="p", cex=.75, col="gray")
lines(means$S, means$H, type="l", lwd=2)
plot(S, D, type="p", cex=.75, col="gray")
lines(means$S, means$D, type="l", lwd=2)
plot(S, M, type="p", cex=.75, col="gray")
lines(means$S, means$M, type="l", lwd=2)
plot(S, V, type="p", cex=.75, col="gray")
lines(means$S, means$V, type="l", lwd=2)
plot(S, FRic, type="p", cex=.75, col="gray")
lines(means$S, means$FRic, type="l", lwd=2)
plot(S, FEve, type="p", cex=.75, col="gray")
lines(means$S, means$FEve, type="l", lwd=2)
plot(S, FDiv, type="p", cex=.75, col="gray")
lines(means$S, means$FDiv, type="l", lwd=2)
plot(S, FDis, type="p", cex=.75, col="gray")
lines(means$S, means$FDis, type="l", lwd=2)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png)
