% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.explore_calibration_dataset.R
\name{explore_calibration_dataset}
\alias{explore_calibration_dataset}
\title{Extract distributions from the database}
\usage{
explore_calibration_dataset(
  taxaType,
  save = FALSE,
  filename = "calibrationDataset.pdf",
  col = viridis::viridis(22)[3:22],
  width = 7.48,
  height = 7.48,
  as.png = FALSE,
  png.res = 300,
  xmn = NA,
  xmx = NA,
  ymn = NA,
  ymx = NA,
  continents = NA,
  countries = NA,
  realms = NA,
  biomes = NA,
  ecoregions = NA,
  dbname = "gbif4crest_02"
)
}
\arguments{
\item{taxaType}{A numerical index (between 1 and 6) to define the type of
palaeoproxy used: 1 for plants, 2 for beetles, 3 for chironomids,
4 for foraminifers, 5 for diatoms and 6 for rodents. The example
dataset uses taxaType=0 (pseudo-data). Default is 1.}

\item{save}{A boolean to indicate if the diagram should be saved as a pdf file.
Default is \code{FALSE}.}

\item{filename}{An absolute or relative path that indicates where the diagram
should be saved. Also used to specify the name of the file. Default:
the file is saved in the working directory under the name
\code{'Reconstruction_climate.pdf'}.}

\item{col}{A colour gradient.}

\item{width, height}{The dimensions of the pdf file (default 7.48in ~19cm).}

\item{as.png}{A boolean to indicate if the output should be saved as a png.
Default is \code{FALSE} and the figure is saved as a pdf file.}

\item{png.res}{The resolution of the png file (default 300 pixels per inch).}

\item{xmn, xmx, ymn, ymx}{The coordinates defining the study area.}

\item{continents}{A vector of the continent names defining the study area.}

\item{countries}{A vector of the country names defining the study area.}

\item{realms}{A vector of the studied botanical realms defining the study area.}

\item{biomes}{A vector of the studied botanical biomes defining the study area.}

\item{ecoregions}{A vector of the studied botanical ecoregions defining the
study area.}

\item{dbname}{The name of the database. Default is \code{'gbif4crest_02'}.}
}
\value{
The distribution data
}
\description{
This function will extract the distributions of all the studied climate proxy and plot the data on a map.
}
\examples{
\dontrun{
  #> Replace 'tempdir()' by the location where to save the sample (e.g. 'getwd()')
  d = explore_calibration_dataset(2, xmn=-85, xmx=-30, ymn=-60, ymx=15,
                                  save=TRUE, width = 4, height = 7.5,
                                  filename=file.path(tempdir(), 'calibrationDataset.pdf')
  )
  head(d)
}

}
