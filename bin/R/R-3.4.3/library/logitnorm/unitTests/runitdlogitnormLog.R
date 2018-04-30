#require(logitnorm)

test.dlogitnorm <- function() {
	# Check dlogitnorm with arbitrary parameters at arbitrary points.
	m <- 1.4
	s <- 0.8
	x <- c(0.1, 0.8);
	# taken from https://en.wikipedia.org/w/index.php?title=Logit-normal_distribution&oldid=708557844
	x.density <- 1/s/sqrt(2*pi) * exp(-(log(x/(1-x)) - m)^2/2/s^2) / x / (1-x)
	stopifnot(all.equal(x.density, dlogitnorm(x, m, s)))
	stopifnot(all.equal(log(x.density), dlogitnorm(x, m, s, log=TRUE)))
}

test.plogitnorm <- function() {
	# Check plogitnorm with arbitrary parameters at arbitrary points.
	m <- 1.4
	s <- 0.8
	x <- c(0.1, 0.8);
	stopifnot(all.equal(pnorm(log(x/(1-x)), m, s), plogitnorm(x, m, s)))
	stopifnot(all.equal(pnorm(log(x/(1-x)), m, s, log=TRUE), log(plogitnorm(x, m, s))))
}

