## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----climate_space, echo=FALSE, out.width="80%", fig.height=3, fig.width=6, fig.align='center', fig.cap="**Fig. 1**: Randomly generated temperature (A) and precipitation (B) climate data."----
    climate <- read.csv('https://raw.githubusercontent.com/mchevalier2/crestr/master/webpage/clim.csv')
    par(mfrow = c(1,2))

    temp_col <- pals::coolwarm(20)[(climate$Temperature-10) %/% 1]
    par(mar=c(1.5,1,1.5,0.3))
    plot(0, 0, type='n', axes=FALSE, frame=FALSE, xlim=c(0, 30), ylim=c(0, 30), asp=1, xaxs='i', yaxs='i')
    for (i in 1:nrow(climate)) {
        rect(climate[i, 'Lon'] - 1, climate[i, 'Lat'] - 1, climate[i, 'Lon'], climate[i, 'Lat'], col=temp_col[i], border=temp_col[i], lwd=0.2)
    }
    rect(0,0,30,30, lwd=0.5)
    mtext('A. Temperature', 3, line=0.2, font=2)
    mtext('Cold  <\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014> Warm', 1, cex=0.8)

    climate[climate[, 'Precipitation'] > 1000, 'Precipitation'] <- 1000
    prec_col <- pals::kovesi.linear_bgyw_15_100_c68(25)[6:25][(climate$Precipitation-2) %/% 50 + 1]
    par(mar=c(1.5,0.3,1.5,1))
    plot(0, 0, type='n', axes=FALSE, frame=FALSE, xlim=c(0, 30), ylim=c(0, 30), asp=1, xaxs='i', yaxs='i')
    for (i in 1:nrow(climate)) {
        rect(climate[i, 'Lon'] - 1, climate[i, 'Lat'] - 1, climate[i, 'Lon'], climate[i, 'Lat'], col=prec_col[i], border=prec_col[i], lwd=0.2)
    }
    rect(0,0,30,30, lwd=0.5)
    mtext('B. Precipitation', 3, line=0.2, font=2)
    mtext('Humid  <\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014\u2014> Dry', 4, cex=0.8, line=-0.5)

## ----species_distrib, echo=FALSE, out.width="90%", fig.height=5.2, fig.width=6, fig.align='center', fig.cap="**Fig. 2**: Distributions of our six taxa of interest (black dots) against the two studied climate gradients."----
distribs <- read.csv('https://raw.githubusercontent.com/mchevalier2/crestr/master/webpage/distrib.csv')
par(mfrow = c(3, 2))
par(mar=c(0,0.7,1,0.7))

for (tax in 1:6) {
    w <- which(distribs[, 'CODE'] == tax)
    plot(0, 0, type='n', axes=FALSE, frame=FALSE, xlim=c(0, 61), ylim=c(0, 30), asp=1, xaxs='i', yaxs='i')
    for (i in 1:nrow(climate)) {
      rect(climate[i, 'Lon'] - 1, climate[i, 'Lat'] - 1, climate[i, 'Lon'], climate[i, 'Lat'], col=temp_col[i], border=temp_col[i], lwd=0.2)
    }
    points(distribs[w, 1:2] - 0.5, pch=20, cex=0.7)
    rect(0,0,30,30, lwd=0.5)

    for (i in 1:nrow(climate)) {
      rect(climate[i, 'Lon'] + 30, climate[i, 'Lat'] - 1, climate[i, 'Lon'] + 31, climate[i, 'Lat'], col=prec_col[i], border=prec_col[i], lwd=0.2)
    }
    mtext(paste0('Taxon', tax), 3, line=-.3, font=2)
    points(distribs[w, 1] + 30.5, distribs[w, 2] - 0.5, pch=20, cex=0.7)
    rect(31,0, 61, 30, lwd=0.5)
}

## ----pollen_diagram, echo=FALSE, out.width="60%", fig.height=6, fig.width=3, fig.align='center', fig.cap="**Fig. 3**: Stratigraphic diagram of the fossil record to be used as the base for temperature and precipitation reconstructions."----
crestr::plot_diagram(crestr::crest_ex, bars=TRUE, bar_width=0.8, xlim=c(0,20))

## ----example------------------------------------------------------------------
library(crestr)
## loading example data
data(crest_ex)
data(crest_ex_pse)
data(crest_ex_selection)

## ----data_preview_fossil------------------------------------------------------
## the first 6 samples
head(crest_ex)

## the structure of the data frame
str(crest_ex)

## ----data_preview_pse---------------------------------------------------------
crest_ex_pse

## ----data_preview_selection---------------------------------------------------
crest_ex_selection

## ----extracting_data----------------------------------------------------------
reconstr <- crest.get_modern_data( df = crest_ex, # The fossil data
                              pse = crest_ex_pse, # The proxy-species equivalency table
                                    taxaType = 0, # The type of taxa is 0 for the example
                    climate = c("bio1", "bio12"), # The climate variables to reconstruct
               selectedTaxa = crest_ex_selection, # The taxa to use for each variable
                        dbname = "crest_example", # The database to extract the data
                                  verbose = FALSE # Print status messages
)

if(is.crestObj(reconstr)) reconstr$inputs$selectedTaxa

## ----print_crestobj-----------------------------------------------------------
reconstr

## ----calibrating, out.width="100%", fig.height=6, fig.width=6, fig.align='center', fig.cap="**Fig. 5**: Distribution of the climate data. The grey histogram represent the abundance of each climate bins in the study area and the black histogram represents how this climate space is sampled by the studied taxa. In a good calibration dataset, the two histograms should be more or less symmetrical. Note: This figure is designed for real data, hence the presence of some African country borders. Just ignore these here."----
reconstr <- crest.calibrate( reconstr, # A crestObj produced at the previous stage
         climateSpaceWeighting = TRUE, # Correct the PDFs for the heteregenous
                                       # distribution of the modern climate space
                 bin_width = c(2, 50), # The size of bins used for the correction
     shape = c("normal", "lognormal"), # The shape of the species PDFs
                       verbose = FALSE # Print status messages
)

plot_climateSpace(reconstr)

## ----plot-plot_taxaCharacteristics, fig.show="hold", fig.align='center', fig.height=6, fig.width=6, out.width="70%", fig.cap="**Fig. 6**: Distributions and responses of _Taxon2_ and _Taxon6_ to _bio1_. Again, ignore the coastline of Africa on this plot."----
plot_taxaCharacteristics(reconstr, taxanames='Taxon2', climate='bio1', h0=0.2)
plot_taxaCharacteristics(reconstr, taxanames='Taxon6', climate='bio1', h0=0.2)


## ----reconstructing-----------------------------------------------------------
reconstr <- crest.reconstruct( reconstr, # A crestObj produced at the previous stage
                         verbose = FALSE # Print status messages
)

if(is.crestObj(reconstr)) {
    names(reconstr)
    lapply(reconstr$reconstructions, names)
    head(reconstr$reconstructions$bio1$optima)
    str(reconstr$reconstructions$bio1$optima)
    signif(reconstr$reconstructions$bio1$likelihood[1:6, 1:6], 3)
    str(reconstr$reconstructions$bio1$likelihood)
}

## ----plot, fig.show="hold", fig.width="50%", fig.width=5, fig.height=3, fig.align='center', fig.cap="**Fig. 7**: (top) Reconstruction of mean annual temperature with the full distribution of the uncertainties. (bottom) Reconstruction of annual precipitation using the simplified visualisation option. In both cases, different levels of uncertainties can be provided."----
if(is.crestObj(reconstr)) {
    plot(reconstr, climate = 'bio1')
    plot(reconstr, climate = 'bio12', simplify=TRUE, uncertainties=c(0.4, 0.6, 0.8))
}

## ----export-------------------------------------------------------------------
export(reconstr, loc=tempdir(), dataname='crest-test')
list.files(file.path(tempdir(), 'crest-test'))

