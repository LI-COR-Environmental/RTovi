\name{logitnorm-package}
\alias{logitnorm-package}\alias{logitnorm}
\title{Utilities for the logitnormal distribution in R}
\description{Utilities for the logitnormal distribution in R
\itemize{
\item Density, distribution, quantile and random generation function.
\item Estimation of the mode and the first two moments.
\item Estimation of distribution parameters from observations.
}
}%description


\details{
The package provides the main distribution functions:
\itemize{
\item density \code{\link{dlogitnorm}},
\item distribution \code{\link{plogitnorm}},
\item quantile \code{\link{qlogitnorm}}, and 
\item random generation function \code{\link{rlogitnorm}}.
}%itemize

Transformation functions 
 \itemize{
 \item{ (0,1) -> (-Inf,Inf): \code{\link{logit}} }
 \item{ (-Inf,Inf) -> (0,1): \code{\link{invlogit}} }
 }
    
Moments and mode 
 \itemize{
 \item{ Expected value and variance: \code{\link{momentsLogitnorm}} }
 \item{ Mode: \code{\link{modeLogitnorm}} }
 }
    
Estimating parameters 
 \itemize{
 \item{from mode and upper quantile: \code{\link{twCoefLogitnormMLE}} }
 \item{from mode and constraint to be unimodal and maximally flat: \code{\link{twCoefLogitnormMLEFlat}} }
 \item{from median and upper quantile: \code{\link{twCoefLogitnorm}} }
 \item{from expected value, i.e. mean and upper quantile: \code{\link{twCoefLogitnormE}} }
 \item{from a confidence interval which is symmetric at normal scale: \code{\link{twCoefLogitnormCi}} }
 \item{from prescribed quantiles: \code{\link{twCoefLogitnormN}} }
 }

Have a look at the package vignettes.
 }%details

\references{
Frederic, P. & Lad, F. (2008) Two Moments of the Logitnormal Distribution. 
Communications in Statistics-Simulation and Computation, 37, 1263-1269 
}%references
\author{Thomas Wutzler}

\keyword{ package }


