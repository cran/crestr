% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.utils.R
\name{eqearth_get_ext}
\alias{eqearth_get_ext}
\title{Calculates the extent of the plot in the equal earth projection.}
\usage{
eqearth_get_ext(ext, npoints = 15)
}
\arguments{
\item{ext}{A set of coordinates.}

\item{npoints}{The number of points used to draw the polygon along each dimension.}
}
\value{
The set of coordinates ext projected in equal earth.
}
\description{
Calculates the extent of the plot in the equal earth projection.
}
\examples{
\dontrun{
  eqearth_get_ext(c(-15, 50, 30, 70))
}

}
