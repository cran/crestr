## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----crestobj, echo=FALSE, fig.cap = "**Fig. 1** Structure of a crestObj, here called 'rcnstrctn', with the five main sub-lists in colour. For simplicity, lists with many elements ('tax' or 'clim') are represented with double framed boxes. The unframed terminal nodes on the right-hand side of each branch are simple R objects, such as numbers, strings, vectors or data frames. The names of the functions that modify these obsjects are indicated on the right.", out.width = '100%', out.extra='style="background:none; border:none; box-shadow:none;"'----
knitr::include_graphics("https://raw.githubusercontent.com/mchevalier2/crestr/master/webpage/fig-crestrobj_v1.png")

