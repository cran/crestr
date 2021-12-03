## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----gbif, echo = FALSE, fig.cap = "**Fig. 1** Data density of the six climate proxies available in the gbif4crest calibration database. The total number of unique species occurrences (N) is indicated for each proxy. The maps are based on the ‘Equal Earth’ map projection to better account for the relative sizes of the different continents.", out.width = '90%', fig.align = 'center'----
knitr::include_graphics("https://raw.githubusercontent.com/mchevalier2/crestr/master/webpage/fig-gbif_v1.png")

## ----gbiftables, echo = FALSE, fig.cap = "**FiG. 2** Structure of the gbif4crest PostgreSQL database. By default, the package extracts data from the TAXA, DISTRIB-QDGC and DATA-QDGC tables. The DISTRIB table contains the raw occurrence data and can be used to process the data at a different spatial resolution for example.", out.width = '100%', out.extra='style="background:none; border:none; box-shadow:none;"'----
knitr::include_graphics("https://raw.githubusercontent.com/mchevalier2/crestr/master/webpage/fig-gbiftables_v1.png")

