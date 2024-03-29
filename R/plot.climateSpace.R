#' Plot the studied climate space.
#'
#' Plot the studied climate space.
#'
#' @inheritParams plot.crestObj
#' @param x A \code{\link{crestObj}} generated by either the \code{\link{crest.calibrate}},
#'        \code{\link{crest.reconstruct}} or \code{\link{crest}} functions.
#' @param climate Climate variables to be used to generate the plot. By default
#'        all the variables are included.
#' @param add_modern A boolean to add the location and the modern climate values
#'        to the plot (default \code{FALSE}).
#' @param filename An absolute or relative path that indicates where the diagram
#'        should be saved. Also used to specify the name of the file. Default:
#'        the file is saved in the working directory under the name
#'        \code{'Climate_space.pdf'}.
#' @param width The width of the output file in inches (default 7.48in ~ 19cm).
#' @param height The height of the output file in inches (default 3in ~ 7.6cm
#'        per variables).
#' @param y0 The space to allocate to each title (default 0.3in ~ 0.76 cm.
#' @param resol For advanced users only: if higher resolution data are used to
#'        estimate the \code{pdfs}, use this parameter to define the resolution
#'        of the maps maps on the figures. (default is 0.25 degrees to match
#'        with the default database).
#' @return No return value, this function is used to plot.
#' @export
#' @examples
#' \dontrun{
#'   data(crest_ex_pse)
#'   data(crest_ex_selection)
#'   reconstr <- crest.get_modern_data(
#'     pse = crest_ex_pse, taxaType = 0,
#'     climate = c("bio1", "bio12"),
#'     selectedTaxa = crest_ex_selection, dbname = "crest_example"
#'   )
#'   reconstr <- crest.calibrate(reconstr,
#'     geoWeighting = TRUE, climateSpaceWeighting = TRUE,
#'     bin_width = c(2, 20), shape = c("normal", "lognormal")
#'   )
#'   plot_climateSpace(reconstr)
#' }
#'
plot_climateSpace <- function( x,
                      climate = x$parameters$climate,
                      save = FALSE, filename = 'Climate_space.pdf',
                      as.png = FALSE, png.res=300,
                      width=  7.48,
                      height = min(9, 3.5*length(climate)), y0 = 0.5,
                      add_modern = FALSE,
                      resol = 0.25
                      ) {

    if(base::missing(x)) x

    if (is.crestObj(x)) {
        test <- is.na(x$modelling$pdfs)
        if( test[1] & length(test) == 1 ) {
            stop('The crestObj requires the climate space to be calibrated. Run crest.calibrate() on your data.\n')
            return(invisible())
        }

        if(add_modern) {
            if (length(x$misc$site_info) <= 3) {
                add_modern <- FALSE
            }
        }

        ext <- c(x$parameters$xmn, x$parameters$xmx, x$parameters$ymn, x$parameters$ymx)
        ext_eqearth <- eqearth_get_ext(ext)
        xy_ratio <- diff(ext_eqearth[1:2]) / diff(ext_eqearth[3:4])

        y1 <- (height - length(climate)*y0) / length(climate)
        x1 <- min(c(width/3, xy_ratio * y1 ))
        y1 <- x1 / xy_ratio
        x2 <- width - 2*x1

        if(save) {
            opt_height <- round(length(climate) * (y0+y1), 3)
            if ((opt_height / height) >= 1.05 | (opt_height / height) <= 0.95) {
                cat('SUGGEST: Using height =', opt_height, 'would get rid of all the white spaces.\n')
            }
            if (x1 / width < 0.25) {
                opt_height <- round(length(climate) * (y0+width/3/xy_ratio), 3)
                cat('SUGGEST: Using height =', opt_height, 'would increase the width of the maps to a more optimal size.\n')
            }
        }

        if(save) {
            if(as.png) {
                grDevices::png(paste0(strsplit(filename, '.png')[[1]], '.png'), width = width, height = height, units='in', res=png.res)
            } else {
                grDevices::pdf(filename, width=width, height=height)
            }
        } else {
            par_usr <- graphics::par(no.readonly = TRUE)
            on.exit(graphics::par(par_usr))
        }

        distribs <- lapply(x$modelling$distributions,
                           function(x) { if(is.data.frame(x)) {
                                            x[, 2] = resol * (x[, 2] %/% resol) + resol/2;
                                            x[, 3] = resol * (x[, 3] %/% resol) + resol/2;
                                            return(stats::aggregate(. ~ longitude+latitude+taxonid, data = x, mean, na.action = NULL))
                                            } else {
                                                return(NA)
                                            }
                                        }
                          )

        veg_space      <- do.call(rbind, distribs)[, c('longitude', 'latitude')]
        veg_space      <- plyr::count(veg_space)
        veg_space      <- veg_space[!is.na(veg_space[, 1]), ]
        veg_space[, 3] <- base::log10(veg_space[, 3])
        veg_space      <- raster::rasterFromXYZ(veg_space, crs=sp::CRS("+proj=longlat +datum=WGS84 +no_defs"))

        ## Defining plotting matrix ------------------------------------------------
        m3 <- rep(c(1:(2*length(climate))), times=rep(c(1,3), times=length(climate)))
        m1 <- m3 + max(m3)
        m2 <- max(m1) + 1:(4*length(climate))

        y3 <- y1*0.05
        y3 <- min(y0/2, y3)
        y3 <- max(y3, y0/3)

        graphics::layout(cbind(m1, m2, m3 ),
               width  = c(x1, x2, x1),
               height = rep(c(y0, (y1-y3)/2, y3, (y1-y3)/2), times=length(climate)))

        graphics::par(ps=8*3/2)

        ## Plot species abundance --------------------------------------------------

        zlab=c(0, ceiling(max(raster::values(veg_space), na.rm=TRUE)))

        clab=c()
        i <- 0
        while(i <= max(zlab)){
          clab <- c( clab, c(1,2,5)*10**i )
          i <- i+1
        }
        clab <- c(clab[log10(clab) <= max(raster::values(veg_space), na.rm=TRUE)], clab[log10(clab) > max(raster::values(veg_space), na.rm=TRUE)][1])
        zlab[2] <- log10(clab[length(clab)])

        site_xy <- NA
        if (is.na(x$misc$site_info$long) | is.na(x$misc$site_info$lat)) add_modern <- FALSE
        if(add_modern) {
            site_xy <- c(x$misc$site_info$long, x$misc$site_info$lat)
        }

        graphics::par(mar = c(0, 0, 0, 0), ps=8*3/2)
        plot_map_eqearth(veg_space, ext, zlim = zlab, brks.pos=log10(clab), brks.lab=clab,
                col=viridis::plasma(20), title='Number of unique species occurences',
                site_xy = site_xy,
                dim=c(x1*width / sum(c(x1,x2,x1)), height / length(climate)))

        ## Plot climate spaces -----------------------------------------------------
        ll <- do.call(rbind, distribs)
        ll <- ll[!is.na(ll[, 1]), ]
        ll_unique <- unique(ll[, colnames(ll) != 'taxonid'])

        climate_space <- x$modelling$climate_space
        climate_space[, 1] = resol * (climate_space[, 1] %/% resol) + resol/2;
        climate_space[, 2] = resol * (climate_space[, 2] %/% resol) + resol/2;
        climate_space = stats::aggregate(. ~ longitude+latitude, data = climate_space, mean)

        cs_colour <- rep(NA, nrow(climate_space))
        for (i in 1:length(cs_colour)) {
            w <- which(ll_unique[, 1] == climate_space[i, 1] )
            cs_colour[i] <- ifelse(climate_space[i, 2] %in% ll_unique[w, 2], 'black', 'grey70' )
        }

        if(length(climate) > 1) {
            oo <- order(cs_colour, decreasing=TRUE)
            for(clim in 1:(length(climate)-1)) {
                miny <- min(climate_space[, climate[clim+1]], na.rm=TRUE)
                maxy <- max(climate_space[, climate[clim+1]], na.rm=TRUE)
                minx <- min(climate_space[, climate[clim]], na.rm=TRUE)
                maxx <- max(climate_space[, climate[clim]], na.rm=TRUE)

                dX <- maxx-minx
                dY <- maxy-miny
                minx <- minx - 0.03*dX
                maxx <- maxx + 0.03*dX
                miny <- miny - 0.03*dY
                maxy <- maxy + 0.03*dY

                xlim <- c(minx, maxx) + c(-0.005, 0.15)*dX
                ylim <- c(miny, maxy) + c(-0.1, 0.05**2)*dY

                graphics::par(mar=c(0,0,0,0), ps=8*3/2)
                plot(NA, NA, type='n', xlab='', ylab='', main='', axes=FALSE, frame=FALSE, xlim=xlim, ylim=c(0,1), xaxs='i', yaxs='i')
                graphics::text(mean(c(minx, maxx)),0.25, paste(climate[clim], '(x-axis) vs.', climate[clim+1], '(y-axis)'), adj=c(0.5,0), cex=1, font=1)


                graphics::par(mar=c(0,0.2,0,0.2))
                plot(NA, NA, type='n', xaxs='i', yaxs='i', axes=FALSE, frame=FALSE,
                     xlim=xlim, ylim=ylim) ; {

                    for(yval in graphics::axTicks(4)){
                         if (yval >= miny & yval <= maxy) {
                            graphics::segments(maxx, yval, minx, yval, col='grey90', lwd=0.5)
                            graphics::segments(maxx, yval, maxx-diff(xlim)*0.012, yval, lwd=0.5)
                            graphics::text(maxx+diff(xlim)*0.015, yval, yval, cex=6/8, adj=c(0,0.4))
                        }
                    }
                    for(xval in graphics::axTicks(1)){
                        if(xval >= minx & xval <= maxx) {
                            graphics::segments(xval, miny, xval, maxy, col='grey90', lwd=0.5)
                            graphics::segments(xval, miny, xval, miny+diff(ylim)*0.012, lwd=0.5)
                            graphics::text(xval, miny-diff(ylim)*0.015, xval, cex=6/8, adj=c(0.5,1))
                        }
                    }
                    graphics::rect(minx, miny, maxx, maxy, lwd=0.5)

                    graphics::points(climate_space[oo, climate[clim]], climate_space[oo, climate[clim+1]],
                        col=cs_colour[oo], pch=20, cex=0.5)

                    if (add_modern) {
                        if (is.numeric(x$misc$site_info$climate[, climate[clim]]) & is.numeric(x$misc$site_info$climate[, climate[clim + 1]])) {
                            graphics::points(x$misc$site_info$climate[, climate[clim]], x$misc$site_info$climate[, climate[clim+1]], pch=23, cex=2, lwd=2, col='white', bg='red')
                        }
                    }
                }
            }
        }

        ## Plot each variables -----------------------------------------------------
        for( clim in climate) {
            brks <- c(x$modelling$ccs[[clim]]$k1, max(x$modelling$ccs[[clim]]$k1)+diff(x$modelling$ccs[[clim]]$k1[1:2]))
            R1 <- raster::rasterFromXYZ(cbind(climate_space[, 1:2],
                                              climate_space[, clim] ),
                                        crs = sp::CRS("+proj=longlat +datum=WGS84 +no_defs"))
            graphics::par(mar = c(0, 0, 0, 0), ps=8*3/2)
            plot_map_eqearth(R1, ext, zlim=range(brks), col=viridis::viridis(length(brks)-1),
            brks.pos = brks, brks.lab = brks,
            title=accClimateVariables(clim)[3], site_xy = site_xy,
            dim=c(x1*width / sum(c(x1,x2,x1)), height / length(climate)))
        }

        for( clim in climate) {
            h1 <- graphics::hist(climate_space[, clim],
                       breaks=c(x$modelling$ccs[[clim]]$k1, max(x$modelling$ccs[[clim]]$k1)+diff(x$modelling$ccs[[clim]]$k1[1:2])),
                       plot=FALSE)
            h2 <- graphics::hist(ll[, clim],
                       breaks=c(x$modelling$ccs[[clim]]$k1, max(x$modelling$ccs[[clim]]$k1)+diff(x$modelling$ccs[[clim]]$k1[1:2])),
                       plot=FALSE)

            xval <- range(h1$breaks)

            ext_factor_x <- max(graphics::strwidth(paste0('     ', c(h1$counts, h2$counts)) , cex=6/8, units='inches')) + graphics::strheight('Number of occurrences', cex=6/8, units='inches')
            w <- x2 - 2*ext_factor_x # space allocated to the central part of the plot
            ratio <- diff(xval) / w # units per inch
            xval <- xval + c(-1, 1)*(ext_factor_x*ratio)

            graphics::par(mar=c(0,0,0,0), ps=8*3/2)
            plot(NA, NA, type='n', xlab='', ylab='', main='', axes=FALSE, frame=FALSE, xlim=c(0,1), ylim=c(0,1), xaxs='i', yaxs='i') ; {
                s1 <- graphics::strwidth('Observed', cex=1, font=2)
                s2 <- graphics::strwidth(' vs. ', cex=1, font=1)
                s3 <- graphics::strwidth('Sampled', cex=1, font=2)

                graphics::text(0.5-(s1+s2+s3)/2, 0.5, 'Observed', cex=1, font=2, col='grey70', adj=c(0,0))
                graphics::text(0.5-(s1+s2+s3)/2+s1, 0.5, '  vs.  ', cex=1, font=1, col='black', adj=c(0,0))
                graphics::text(0.5-(s1+s2+s3)/2+s1+s2, 0.5, ' Sampled', cex=1, font=2, col='black', adj=c(0,0))
                graphics::text(0.5, 0.3, paste(accClimateVariables(clim)[3],' [',clim,']',sep=''), cex=1, font=1, col='black', adj=c(0.5,1))
            }

            graphics::par(mar=c(0,0,0.1,0))
            opar <- graphics::par(lwd=0.5)
            plot(NA, NA, type='n', xlim=xval, ylim=c(0, max(h1$counts)), axes=FALSE, main='', xaxs='i', yaxs='i')  ;  {
                for(yval in graphics::axTicks(2)){
                    if(yval+graphics::strheight(yval, cex=6/8)/2 < max(h1$counts)) {
                        graphics::text(h1$breaks[1]-diff(xval)*0.015, yval, yval, cex=6/8, adj=c(1,ifelse(yval==0, 0, 0.4)))
                    }
                    graphics::segments(h1$breaks[1], yval, max(h1$breaks), yval, col=ifelse(yval==0, 'black', 'grey90'))
                    graphics::segments(h1$breaks[1], yval, h1$breaks[1]+diff(xval)*0.012, yval)
                }
                graphics::segments(h1$breaks[1],0,h1$breaks[1], max(h1$counts))
                plot(h1, add=TRUE, col='grey70')
                graphics::text(xval[1], max(h1$counts)/2, 'Number of occurrences', cex=6/8, adj=c(0.5, 1), srt=90)
            }
            graphics::par(opar)


            graphics::par(mar=c(0,0,0,0))
            plot(NA, NA, type='n', xlab='', ylab='', main='', axes=FALSE, frame=FALSE, xlim=xval, ylim=c(0,1), xaxs='i', yaxs='i')  ;  {
                d1 <- -9999999
                if(add_modern) {
                    #graphics::points(x$misc$site_info$climate[, clim], 0.5, pch=23, col='white', bg='red', cex=1.5, lwd=1.5)
                    if (is.numeric(x$misc$site_info$climate[, clim]) ) {
                        graphics::points(x$misc$site_info$climate[, clim], 0.83, pch=24, col=NA, bg='red', cex=0.9, lwd=1.5)
                        graphics::points(x$misc$site_info$climate[, clim], 0.17, pch=25, col=NA, bg='red', cex=0.9, lwd=1.5)
                    }
                }
                for(i in 1:length(h1$breaks)) {
                    d2 <- h1$breaks[i] - graphics::strwidth(paste0(' ', h1$breaks[i], ' '), cex=6/8, units='user')/2
                    if(d2 - d1 >= 0) {
                        d1 <- h1$breaks[i] + graphics::strwidth(paste0(' ', h1$breaks[i], ' '), cex=6/8, units='user')/2
                        graphics::text(h1$breaks[i], 0.5, h1$breaks[i], cex=6/8, adj=c(0.5, 0.5))
                        graphics::segments(h1$breaks[i], 1, h1$breaks[i], 0.9, lwd=0.5)
                        graphics::segments(h1$breaks[i], 0, h1$breaks[i], 0.1, lwd=0.5)
                    }
                }
            }

            graphics::par(mar=c(0.1,0,0,0))
            opar <- graphics::par(lwd=0.5)
            plot(NA, NA, type='n', xlim=xval, ylim=c(max(h2$counts), 0), axes=FALSE, main='', xaxs='i', yaxs='i')  ;  {
                M <- max(h2$breaks)
                for(yval in graphics::axTicks(4)){
                    if(yval-graphics::strheight(yval, cex=6/8)/2 < max(h2$counts)) {
                        graphics::text(M+diff(xval)*0.015, yval, yval, cex=6/8, adj=c(0,ifelse(yval==0, 1, 0.6)))
                    }
                    graphics::segments(M, yval, M-diff(xval)*0.012, yval)
                    graphics::segments(h2$breaks[1], yval, M, yval, col=ifelse(yval==0, 'black', 'grey90'))
                }
                plot(h2, add=TRUE, col='black', border='grey70')
                graphics::segments(M,0,M, max(h2$counts))
                graphics::segments(h1$breaks[1],0,max(h1$breaks),0)
                graphics::par(opar)
            }
            graphics::text(xval[2], max(h2$counts)/2, 'Number of occurrences', cex=6/8, adj=c(0.5, 1), srt=-90)
        }

        if(save) {
          grDevices::dev.off()
        }
    } else {
        cat('This function only works with a crestObj.\n\n')
    }
    invisible()
}
