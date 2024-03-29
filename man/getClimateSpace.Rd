% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbGetClimateSpace.R
\name{getClimateSpace}
\alias{getClimateSpace}
\title{Extract the distribution of the studied climate gradient(s) across the study area.}
\usage{
getClimateSpace(
  climate,
  xmn = NA,
  xmx = NA,
  ymn = NA,
  ymx = NA,
  continents = NA,
  countries = NA,
  basins = NA,
  sectors = NA,
  realms = NA,
  biomes = NA,
  ecoregions = NA,
  elev_min = NA,
  elev_max = NA,
  elev_range = NA,
  dbname = "gbif4crest_02"
)
}
\arguments{
\item{climate}{A vector of the climate variables to extract. See
\code{\link{accClimateVariables}} for the list of accepted values.}

\item{xmn, xmx, ymn, ymx}{The coordinates defining the study area.}

\item{continents}{A vector of the continent names defining the study area.}

\item{countries}{A vector of the country names defining the study area.}

\item{basins}{A vector of the ocean names defining the study area.}

\item{sectors}{A vector of the marine sector names defining the study area.}

\item{realms}{A vector of the studied botanical realms defining the study area.}

\item{biomes}{A vector of the studied botanical biomes defining the study area.}

\item{ecoregions}{A vector of the studied botanical ecoregions defining the
study area.}

\item{elev_min, elev_max}{Parameters to only selected grid cells with an
elevation higher than elev_min or lower than elev_max (default is
'\code{NA} ).}

\item{elev_range}{Parameters discard the grid cell with a high elevation
range (default is \code{NA}).}

\item{dbname}{The name of the data source database.}
}
\value{
A matrix of occurrence records with the associated climate.
}
\description{
Extract the distribution of the studied climate gradient(s) across the study area.
}
\examples{
\dontrun{
  climate <- getClimateSpace("bio1", -90, 90, -90, 90,
    continents = "Europe",
    countries = c("Germany", "Netherlands", "Sweden"),
    realms = "Palaearctic"
  )
  head(climate)
  raster::plot(raster::rasterFromXYZ(climate), asp=1)
}

}
\seealso{
\code{\link{accClimateVariables}}
for a list of accepted climate variable names, \code{\link{accCountryNames}}
for a list of accepted continent and country names, \code{\link{accBasinNames}}
for a list of accepted basin and sector names, \code{\link{accRealmNames}}
for a list of accepted realm, biome and ecoregion names.
}
