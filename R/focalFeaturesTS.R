#' @title Focal Features Extraction from Time Series
#' @name focalFeaturesTS
#' @aliases focalFeaturesTS
#' @author Adeline M. Maciel
#' @docType data
#'  
#' @description Performed a focal feature extraction from time series data. And return focal statistical summary for time series divided for year. Calculates for each input time series, cell  location, a statistic of the values within a specified neighborhood should be 8 around it (Queen's case).
#' @usage focalFeaturesTS(fileTS = NULL, valueToleranceRaster = 0.00000)
#' @param fileTS A file time series alredy with features extracted and divided for year ou subinterval.
#' @param valueToleranceRaster A number of tolerance case raster of the time series contains coordinate intervals not constant. Because this function trasforme time series for raster data. Default is 0.00000.
#' @keywords datasets
#' @return Dataset with features of focal neighborhood statistical
#' @import raster
#' @importFrom sp SpatialPixelsDataFrame
#' @importFrom dplyr filter
#' @export
#' 
#' @note This function requires that the igraph package is available. 
#' 
#' @examples \dontrun{
#' # open a data example
#' library(featuresTS)
#' data("dataFeaturesTS")
#' df <- dataFeaturesTS
#'
#' library(igraph)
#' # features extraction for entire data.frame without subIntervals
#' dfTSwithFocalFeatures <- focalFeaturesTS(fileTS = df, valueToleranceRaster = 0.000891266)
#' # result in data.frame with focal features
#' 
#' head(dfTSwithFocalFeatures)
#'
#'}
#'

focalFeaturesTS <- function(fileTS = NULL, valueToleranceRaster = 0.00000){ # time, dirsave
  # Start count time
  ptm <- proc.time()
  ptm1 <- Sys.time()
  
  if (!is.null(fileTS)) {
    time <- fileTS
  }else {
    stop("File must be defined!")
  }
  
  indexLongitude <- which(colnames(time) == "longitude")
  indexLatitude <- which(colnames(time) == "latitude")
  indexYear <- which(colnames(time) == "year")
  
  indexMean <- which(colnames(time) == "mean")
  indexMax <- which(colnames(time) == "max")
  indexMin <- which(colnames(time) == "min")
  indexSd <- which(colnames(time) == "sd")
  indexAmplitude <- which(colnames(time) == "amplitude")
  
  database <- time
  
  options(digits=10)
  long <- as.character(formatC(database[,indexLongitude], digits=5, format="f"))
  lat <- as.character(formatC(database[,indexLatitude], digits=5, format="f"))
  timeF <- cbind(database, long, lat, "order"=1:nrow(database))
  
  #library(dplyr)
  #library(raster)
  pts <- timeF[c(indexLongitude:indexLatitude,indexMean)] # long, lat and class 
  colnames(pts) <- c('x', 'y', 'z')
  
  pixels = sp::SpatialPixelsDataFrame(points = pts[c("x", "y")], data = pts, tolerance = valueToleranceRaster) 
  r1 = raster::raster(pixels[,'z'])
  #plot(r1,main="Raster 1 - original")
  
  ### INICIO ###
  #Verifica se tem pixels isolados, devido a operação de vizinhança que não vai visualizá-los
  # to isolate clumps adjacents to plot axes
  #library(igraph)
  rc <- raster::clump(r1, directions = 8)
  
  # get frequency table
  f<-raster::freq(rc)
  # save frequency table as data frame
  f<-as.data.frame(f)
  
  if (any(f$count <= 5) == TRUE){
    quant <- length(f$value[which(f$count <= 5)])
    cat(sprintf("YES! Have %s pixel isolated.\n", quant))
    ## which rows of the data.frame are only represented by clumps under 5 pixels?
    #str(which(f$count <= 5))
    ## which values do these correspond to?
    #str(f$value[which(f$count <= 5)])
    # put these into a vector of clump ID's to be removed
    removedID <- f$value[which(f$count <= 5)]
    
    # make a new raster to be sieved
    rcNew <- rc
    # assign NA to all clumps whose IDs are found in removedID
    rcNew[rc %in% removedID] <- NA
 
    r2 <- rcNew
    
  }else{
    cat("NO! Haven't any pixel isolated.\n")
    r2 <- r1
  }
  ### FIM ###
  
  # Extrai celulas do raster
  x <- as.data.frame(raster::rasterToPoints(r2)[,-3])
  colnames(x) <- c('x', 'y')
  coord <- x
  
  options(digits=10)
  long1 <- as.character(formatC(coord$x, digits=5, format="f"))
  lat1 <- as.character(formatC(coord$y, digits=5, format="f"))
  coord1 <- cbind(long1, lat1)
  
  df = timeF[FALSE,] # verifi
  
  for(x in 1:nrow(coord1)){
    temp <- dplyr::filter(timeF, grepl(coord1[x,1], timeF$long, fixed = TRUE) & grepl(coord1[x,2], timeF$lat, fixed = TRUE))
    
    timeF <- timeF[!(timeF$order %in% temp$order), ] # retira dado que já foi encontrado
   
    df <- rbind(df,temp)
    
  } # fim renomeio
  
  indexLong <- which(colnames(df) == "long")
  indexLat <- which(colnames(df) == "lat")
  indexOrder <- which(colnames(df) == "order")
  
  df0 <- df[,-c(indexLong:indexLat,indexOrder)]
  df1 <- df0[,-c(indexLongitude,indexLatitude,indexYear)]
  df2 <- df0[,c(indexLongitude,indexLatitude,indexYear)]
  
  df3 <- df 
  
  FocalOperation(df3, indexMean, indexLongitude, indexLatitude, valueToleranceRaster) # mean
  FocalOperation(df3, indexMax, indexLongitude, indexLatitude, valueToleranceRaster) # max
  FocalOperation(df3, indexMin, indexLongitude, indexLatitude, valueToleranceRaster) # min
  FocalOperation(df3, indexSd, indexLongitude, indexLatitude, valueToleranceRaster) # sd
  FocalOperation(df3, indexAmplitude, indexLongitude, indexLatitude, valueToleranceRaster) # amplitude
 
  df4 <-  df3[ , grepl( "focal." , names( df3 ) ) ]
  
  dfFocal <- cbind(df1,df4,df2)
  
  return(dfFocal)
  #assign('dfTS.withFocalFeatures', dfFocal, envir = parent.frame())

  proc.time() - ptm
  Sys.time() - ptm1

}


# Focal operation for mean, max, min, sd, amplitude for Moore Neighborhood - 8 vizinhos
FocalOperation<-function(fileTS = NULL, val = NULL, long = NULL, lat = NULL, valueToleranceRaster = NULL ){ # val,time ## recebe coluna com valores e a base de dados

  #library(dplyr)
  #library(raster)
  #library(sp)
   time <- fileTS
  
  pts <- time[c(long:lat,val)] # long, lat and value such as means, max, min other 
  colnames(pts) <- c('x', 'y', 'z')
  pixels = sp::SpatialPixelsDataFrame(points = pts[c("x", "y")], data = pts, tolerance = valueToleranceRaster) 
  r2 = raster::raster(pixels[,'z'])
  plot(r2,main=sprintf("TS - feature: '%s'", (names(time)[val])))
  
  r <- r2
  
  ##  Calculate adjacent raster cells for each focal cell:
  a <- raster::adjacent(r, 1:ncell(r), directions=8, sorted=T, id=FALSE)
  
  ##  Create column to store correlations:
  out <- data.frame(a)
  out$value <- NA
  
  ##  Loop over all focal cells and their adjacencies,
  ##    extract the values across all adjacencies
  for (i in 1:nrow(a)) {
    out$value[i] <- c(r[a[i,2]])
  }
  
  # verificar se tem celulas vazias e remove da adjacencia
  if (any(is.na(out)) == TRUE){
    cat("YES! Some cells with NA.\n")
    
    b <- out[is.na(out$value),] # primeiro isola as linhas com celulas NA
    
    remo <- sort(unique(b$to)) # isola segunda coluna e cria lista com as celulas vazias
    
    outb <- out[!out$to %in% remo,] # remove linhas com segunda coluna "to" que contenham algum elemento das celulas vazias
    
    outc <- outb[!outb$from %in% remo,] # remove linhas com primeira coluna "from" que contenham algum elemento das celulas vazias
    
    out <- outc # recebe data.frame sem celulas vazias
    
  }else{
    cat("NO! Cells without NA.\n")
    out <- out
  }
  
  ##  Take the mean of the values by focal cell ID:
  r_vals_mean <- aggregate(out$value, by=list(out$from), FUN=mean)
  r_vals_max <- aggregate(out$value, by=list(out$from), FUN=max)
  r_vals_min <- aggregate(out$value, by=list(out$from), FUN=min)
  r_vals_sd <- aggregate(out$value, by=list(out$from), FUN=sd)
  
  time <- cbind(time,r_vals_mean$x,r_vals_max$x,r_vals_min$x,r_vals_sd$x)
  
  names(time)[names(time) == 'r_vals_mean$x'] <- sprintf("focal.mean.%s", names(time)[val]) # renomear coluna
  names(time)[names(time) == 'r_vals_max$x'] <- sprintf("focal.max.%s", names(time)[val])
  names(time)[names(time) == 'r_vals_min$x'] <- sprintf("focal.min.%s", names(time)[val])
  names(time)[names(time) == 'r_vals_sd$x'] <- sprintf("focal.sd.%s", names(time)[val])
  
  # show raster focal
  winFocal <- par(mfrow=c(2,2))
  # mean
  r_out <- r2[[1]]
  r_out[] <- r_vals_mean$x
  plot(r_out, main=sprintf("TS - focal: mean of the '%s''", (names(time)[val])))
  # max
  r_out <- r2[[1]]
  r_out[] <- r_vals_max$x
  plot(r_out, main=sprintf("TS - focal: max of the '%s'", (names(time)[val])))
  # min
  r_out <- r2[[1]]
  r_out[] <- r_vals_min$x
  plot(r_out, main=sprintf("TS - focal: min of the '%s'", (names(time)[val])))
  # sd
  r_out <- r2[[1]]
  r_out[] <- r_vals_sd$x
  plot(r_out, main=sprintf("TS - focal: standard deviation (sd) of the '%s'", (names(time)[val])))
  par(winFocal)
  
  assign('df3',time,envir=parent.frame())
  
}







