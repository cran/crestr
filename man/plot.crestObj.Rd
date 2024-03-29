% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crestS3.R
\name{plot.crestObj}
\alias{plot.crestObj}
\title{Plot the reconstructions.}
\usage{
\method{plot}{crestObj}(
  x,
  climate = x$parameters$climate,
  uncertainties = x$parameters$uncertainties,
  optima = TRUE,
  add_modern = FALSE,
  simplify = FALSE,
  xlim = NA,
  ylim = NA,
  pt.cex = 0.8,
  pt.lwd = 0.8,
  pt.col = ifelse(simplify, "black", "white"),
  col.hiatus = "white",
  save = FALSE,
  width = 5.51,
  height = 5.51,
  as.png = FALSE,
  png.res = 300,
  filename = "Reconstruction.pdf",
  col = viridis::viridis(125)[26:125],
  ...
)
}
\arguments{
\item{x}{A \code{\link{crestObj}} produced by either the
\code{\link{crest.reconstruct}} or \code{\link{crest}}) functions.}

\item{climate}{The climate variables to plot (default is all the
reconstructed variables from x)}

\item{uncertainties}{A (vector of) threshold value(s) indicating the error
bars that should be calculated (default are the values stored in x).}

\item{optima}{A boolean to indicate whether to plot the optimum (\code{TRUE})
or the mean (\code{FALSE}) estimates.}

\item{add_modern}{Adds the modern climate values to the plot.}

\item{simplify}{A boolean to indicate if the full distribution of uncertainties
should be plotted (\code{FALSE}, default) or if they should be
simplified to the uncertainty range(s).}

\item{xlim}{the x limits (x1, x2) of the plot.  Note that \code{x1 > x2}
    is allowed and leads to a \sQuote{reversed axis}.

    The default value, \code{NULL}, indicates that the range of the
    \link{finite} values to be plotted should be used.}

\item{ylim}{the y limits of the plot.}

\item{pt.cex}{The size of the points (default 0.8).}

\item{pt.lwd}{The thickness of the lines (default 0.8).}

\item{pt.col}{The colour of the points and lines.}

\item{col.hiatus}{A colour for the hiatus(es) of the record (default white)}

\item{save}{A boolean to indicate if the diagram should be saved as a pdf file.
Default is \code{FALSE}.}

\item{width, height}{The dimensions of the pdf file (default 5.51in ~14cm).}

\item{as.png}{A boolean to indicate if the output should be saved as a png.
Default is \code{FALSE} and the figure is saved as a pdf file.}

\item{png.res}{The resolution of the png file (default 300 pixels per inch).}

\item{filename}{An absolute or relative path that indicates where the diagram
should be saved. Also used to specify the name of the file. Default:
the file is saved in the working directory under the name
\code{'Reconstruction_climate.pdf'}.}

\item{col}{A colour gradient.}

\item{...}{other \link[graphics]{graphical parameters} (see \code{\link[graphics]{par}} and
    section \sQuote{Details} below).}
}
\value{
No return value, this function is used to plot.
}
\description{
Plot the reconstructions and their uncertainties if they exist.
}
\examples{
\dontrun{
  data(crest_ex)
  data(crest_ex_pse)
  data(crest_ex_selection)
  reconstr <- crest(
    df = crest_ex, pse = crest_ex_pse, taxaType = 0,
    climate = c("bio1", "bio12"), bin_width = c(2, 20),
    shape = c("normal", "lognormal"),
    selectedTaxa = crest_ex_selection, dbname = "crest_example"
  )
  reconstr <- loo(reconstr)
}
## example using pre-saved reconstruction obtained with the previous command.
data(reconstr)
plot(reconstr)
plot(reconstr, climate='bio1', simplify = TRUE)

}
