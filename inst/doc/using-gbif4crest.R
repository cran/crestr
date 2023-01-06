## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----create-data, echo=FALSE--------------------------------------------------
library(crestr)
#attach(crest_ex_pse)
PSE <-rbind( c(1, 'Ericaceae', NA, NA, 'Ericaceae'),
             c(2, 'Asteraceae', 'Artemisia', NA, 'Artemisia'),
             c(2, 'Oleaceae', 'Olea', NA, 'Olea')
          )
colnames(PSE) <- colnames(crest_ex_pse)
rownames(PSE) <- 1:3
PSE <- as.data.frame(PSE)

#cbind(as.factor(c(1,2,2)), c('Ericaceae', 'Asteraceae', 'Oleaceae'))


## ----show-pse, echo=TRUE, eval=TRUE-------------------------------------------
PSE

## ----online-option, echo=TRUE, eval=TRUE--------------------------------------

reconstr <- crest.get_modern_data(  pse = PSE,
                                taxaType = 1,
                                climate = c("bio1", "bio12"),
                                # The name of the online database to extract the data from
                                dbname = "gbif4crest_02",
                                verbose = FALSE
)

if(is.crestObj(reconstr)) tapply(reconstr$modelling$taxonID2proxy[,1], reconstr$modelling$taxonID2proxy[,2], length)

## ----offline-option, echo=TRUE, eval=FALSE------------------------------------
#  
#  reconstr <- crest.set_modern_data(  pse = PSE,
#                                  taxaType = 1,
#                                  climate = c("bio1", "bio12"),
#                                  # The full path to the local gbif4crest database
#                                  dbname = "path/to/gbif4crest_02.sqlite3",
#                                  verbose = FALSE
#  )

