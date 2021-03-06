% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reveal.R
\name{split_mult}
\alias{split_mult}
\title{split columns in multiple by regex}
\usage{
split_mult(x, col, pattern = "_", into = NULL, prefix = "var", sep = "")
}
\arguments{
\item{x}{data frame}

\item{col}{character}

\item{pattern}{regex by which to split}

\item{into}{names of columns - character vector of length of n splits}

\item{prefix}{if into not specified, names created "prefix(sep)index"}

\item{sep}{separator of prefix and index}
}
\description{
Reveal helper. cuts column into multiple in reveal
}
\seealso{
modified from
\href{https://stackoverflow.com/a/47060452/7941188}{this thread on stackoverflow}
}
\keyword{internal}
