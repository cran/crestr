% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.speciesCharacteristics.R
\name{plot_taxaCharacteristics}
\alias{plot_taxaCharacteristics}
\title{Plot the distribution and responses of the studied taxa}
\usage{
plot_taxaCharacteristics(
  x,
  taxanames = x$inputs$taxa.name,
  climate = x$parameters$climate,
  col.density = viridis::plasma(20),
  col.climate = viridis::viridis(22)[3:20],
  save = FALSE,
  filename = "taxaCharacteristics.pdf",
  as.png = FALSE,
  png.res = 300,
  width = 7.48,
  w0 = 0.3,
  height = 3 * length(climate),
  h0 = 0.4,
  add_modern = FALSE,
  resol = 0.25
)
}
\arguments{
\item{x}{A \code{\link{crestObj}} generated by either the
\code{\link{crest.calibrate}}, \code{\link{crest.reconstruct}},
\code{\link{loo}} or \code{\link{crest}} functions.}

\item{taxanames}{A list of taxa to use for the plot (default is all the
recorded taxa).}

\item{climate}{Climate variables to be used to generate the plot. By default
all the variables are included.}

\item{col.density}{The colour gradient to use to map the density of species
(top left map).}

\item{col.climate}{The colour gradient to use to map the climate gradients
(left column).}

\item{save}{A boolean to indicate if the diagram should be saved as a pdf file.
Default is \code{FALSE}.}

\item{filename}{An absolute or relative path that indicates where the diagram
should be saved. Also used to specify the name of the file. Default:
the file is saved in the working directory under the name
\code{'taxaCharacteristics.pdf'}.}

\item{as.png}{A boolean to indicate if the output should be saved as a png.
Default is \code{FALSE} and the figure is saved as a pdf file.}

\item{png.res}{The resolution of the png file (default 300 pixels per inch).}

\item{width}{The width of the output file in inches (default 7.48in ~ 19cm).}

\item{w0}{The width of the left column with the names.}

\item{height}{The height of the output file in inches (default 3in ~ 7.6cm
per variables).}

\item{h0}{The vertical space used for the x-axes.}

\item{add_modern}{A boolean to add the location and the modern climate values
to the plot (default \code{FALSE}).}

\item{resol}{For advanced users only: if higher resolution data are used to
estimate the \code{pdfs}, use this parameter to define the resolution
of the maps on the figures. (default is 0.25 degrees to match with the
default database)}
}
\value{
No return value, this function is used to plot.
}
\description{
Plot the distribution and responses of the studied taxa
}
\examples{
\dontrun{
  data(crest_ex_pse)
  data(crest_ex_selection)
  reconstr <- crest.get_modern_data(
    pse = crest_ex_pse, taxaType = 0, df = crest_ex,
    climate = c("bio1", "bio12"),
    selectedTaxa = crest_ex_selection, dbname = "crest_example"
  )
  reconstr <- crest.calibrate(reconstr,
    geoWeighting = TRUE, climateSpaceWeighting = TRUE,
    bin_width = c(2, 20), shape = c("normal", "lognormal")
  )
  plot_taxaCharacteristics(reconstr, taxanames='Taxon1')
}

}
