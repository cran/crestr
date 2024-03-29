#' Wrapper function of to add transparency to a colour.
#'
#' Add transparency to the selected colours.
#'
#' @param colour A R colour
#' @param alpha A value between 0 and 1 that defines the transparency
#'        0 for full transparency and 1 for no transparency
#' @return Return a colour with the provided level of transparency.
#' @export
#' @examples
#' makeTransparent('black',0.5)
#' makeTransparent('black',1:10/10)
#' makeTransparent(rainbow(10), 1:10/10)

makeTransparent <- function(colour, alpha) {
    if(base::missing(colour)) colour
    if(base::missing(alpha)) alpha

   scales::alpha(colour, alpha)
}
