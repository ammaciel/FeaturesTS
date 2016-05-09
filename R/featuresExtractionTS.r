#' @title Features Extraction from Time Series
#' @name featuresExtractionTS
#' @aliases featuresExtractionTS
#' @author Adeline M. Maciel
#' @docType data
#'  
#' @description Performed a feature extraction from time series data. And return statistical summary for time series entire or by intervals of the time series
#' @usage featuresExtractionTS(fileTS = NULL, nameColumnValue = NULL, 
#' subInterval = FALSE, numberSubIntervals = 2)
#' @param fileTS A file time series.
#' @param nameColumnValue A name of column with value, such as, vegetation indice
#' @param subInterval Logical. If TRUE, the data.frame will be divide in subintervals, for example, given a data.frame with 23 rows and 3 subintervals, the first and second subinterval will have 8 rows each, and the last only 7 rows. If FALSE (the default) nothing subinterval will be created.
#' @param numberSubIntervals A number of subintervals.
#' @keywords datasets
#' @return new dataset of data.frame with statistical features
#' @import tools
#' @export 
#' 
#' @examples \dontrun{
#' # open a data example
#' library(featuresTS)
#' data("dataTS")
#' df <- dataTS
#'
#' # features extraction for entire data.frame without subIntervals
#' featuresExtractionTS(fileTS = df, nameColumnValue = "value", 
#' subInterval = FALSE)
#' # result in data.frame with statistical features
#'
#' # features extraction for entire data.frame and  2 subIntervals
#' featuresExtractionTS(fileTS = df, nameColumnValue = "value", 
#' subInterval = TRUE, numberSubIntervals = 2)
#'
#'}
#'
featuresExtractionTS <- function(fileTS = NULL, nameColumnValue = NULL, subInterval = FALSE, numberSubIntervals = 2){
  
  #library(tools)
  
  if (!is.null(fileTS)) {
    time <- fileTS
  }else {
    stop("File must be defined!")
  }
  
  indexLongitude <- which(colnames(time) == "longitude")
  indexLatitude <- which(colnames(time) == "latitude")
  longLat <- cbind(unique(time[,indexLongitude]),unique(time[,indexLatitude]))
  
  indexDate <- which(colnames(time) == "date")
  date <- unique(format(as.Date(time[,indexDate]), format = '%Y'))
  if (length(date) > 1){
    year <- paste(date, collapse = '_')
  } else {
    year <- date
  }
  
  if (!is.null(nameColumnValue)) {
    indexColumn <- which(colnames(time) == nameColumnValue)
    
    #library(plyr)
    vertice <- time[,indexColumn]
    vertices <- t(vertice)
    # total.featuresTS <- NULL
    
    length <- length(vertice) # nrow time series
    mean <- mean(vertice)
    max <- max(vertice)
    min <- min(vertice)
    sd <- sd(vertice)
    median <- median(vertice)
    sum <- sum(vertice)
    skewness <- skewness(vertice)
    kurtosis <- kurtosis(vertice)
    variance <- variance(vertice)
    amplitude <- amplitude(vertice) # difference between max and min
    area <- trapezoid.AUC(seq(length(vertice)),vertice)  # area time series
    perimeter <- trapezoid.PerC(seq(length(vertice)),vertice) # perimeter
    
    data.features <- cbind(length, mean, max, min, sd, median, sum, skewness, kurtosis, variance, amplitude, area,perimeter)
    info <- cbind(longLat, year) # longitude,latitude and year
    
    colnames(data.features) = c("length", "mean", "max", "min", "sd", "median", "sum", "skewness", "kurtosis", "variance", "amplitude", "area", "perimeter")
    colnames(info) = c("longitude", "latitude", "year")
    
    total.featuresTS <- cbind(vertices, data.features, info)
    rownames(total.featuresTS) <- NULL
    
    if (subInterval == TRUE) {
      
      numberSubIntervals <- as.integer(numberSubIntervals)
      
      if (numberSubIntervals >= 2 && numberSubIntervals <= nrow(time)){
        subInter <- split(time, f = rep_len(1:as.integer(numberSubIntervals), nrow(time)))
      } else {
        stop("The amount of subintervals should be >= 2 and lower that number of lines of the time series!")
      }
      
      subTotalTS <- NULL
      
      for(x in 1:length(subInter)){
        partTime <- sprintf("ts.subInter_%s",x)
        partTimeValues <- subInter[[x]]
        
        length.sub <- nrow(partTimeValues[,indexColumn])
        mean.sub <- mean(partTimeValues[,indexColumn])
        max.sub <- max(partTimeValues[,indexColumn])
        min.sub <- min(partTimeValues[,indexColumn])
        sd.sub <- sd(partTimeValues[,indexColumn])
        sum.sub <- sum(partTimeValues[,indexColumn])
        amplitude.sub <- amplitude(partTimeValues[,indexColumn])
        area.sub <- trapezoid.AUC(seq(length(partTimeValues[,indexColumn])),partTimeValues[,indexColumn])
        perimeter.sub <- trapezoid.PerC(seq(length(partTimeValues[,indexColumn])),partTimeValues[,indexColumn])
        
        
        subValues <- cbind(length.sub,mean.sub,max.sub,min.sub,sd.sub,sum.sub,amplitude.sub,area.sub,perimeter.sub)
        colnames(subValues) = c(sprintf("length.sub.%d", x), sprintf("mean.sub.%d", x), sprintf("max.sub.%d", x), sprintf("min.sub.%d", x), sprintf("sd.sub.%d", x), sprintf("sum.sub.%d", x), sprintf("amplitude.sub.%d", x), sprintf("area.sub.%d", x), sprintf("perimeter.sub.%d", x))
        
        subTotalTS <- cbind(subTotalTS,subValues)
      }
      
      total.featuresSubTS <- cbind(vertices, data.features, subTotalTS, info)
      rownames(total.featuresSubTS) <- NULL
      
      assign('data.features+SubTS', total.featuresSubTS, envir = parent.frame())
      
    }else {
      # total.featuresTS <- cbind(vertices, data.features, info)
      assign('data.featuresTS', total.featuresTS, envir = parent.frame())
    }
    
  }else {
    stop("Column with value for features extraction must be defined!")
  }
}

# ----------------
# 3.0 Functions helps
# ----------------
skewness<-function(x){
  n <- length(x)
  sd <- sd(x)
  mean <- mean(x)
  skewness <- n/((n-1)*(n-2))*sum((x-mean)^3)/sd^3
  return(skewness)
}

kurtosis<-function(x){
  n <- length(x)
  sd <- sd(x)
  mean <- mean(x)
  kurtosis <- (n*(n+1)/((n-1)*(n-2)*(n-3)))*sum((x-mean)^4)/sd^4-3*(n-1)^2/((n-2)*(n-3))
  return(kurtosis)
}

variance<-function(x){
  n <- length(x)
  mean <- mean(x)
  variance <- (sum((x-mean)^2)/n)
  return(variance)
}

amplitude <- function(valor){
  amplitude <- max(valor)-min(valor)
  return(amplitude)
}

# ----------------
# 3.1 Area Under Curve
# ----------------
trapezoid.AUC <- function (x, y, na.rm = FALSE) {
  if (na.rm) {
    idx <- na.omit(cbind(x, y))
    x <- x[idx]
    y <- y[idx]
  }
  if (length(x) != length(y))
    stop("length x must equal length y")
  idx <- order(x)
  x <- x[idx]
  y <- y[idx]
  
  a <- sum(apply(cbind(y[-length(y)], y[-1]), 1, mean) * (x[-1] - x[-length(x)]))
  
  return(a)
}

# ghg <- c(12, 14, 17, 13, 8)
# trapezoid.AUC(seq(length(ghg)),ghg)
# 54


# Pythagorean theorem
# c² = a² + b²
# ----------------
# 3.2 Perimeter of Curve
# ----------------
trapezoid.PerC <- function (x, y, na.rm = FALSE){
  if (na.rm) {
    idx <- na.omit(cbind(x, y))
    x <- x[idx]
    y <- y[idx]
  }
  
  if (length(x) != length(y))
    stop("length x must equal length y")
  idx <- order(x)
  x <- x[idx]
  y <- y[idx]
  
  # Pythagorean theorem
  # c^2 = a^2 + b^2
  # sqrt(c^2) + frequencia + primeiro valor do vector + utimo valor do vector = perimeter
  
  p <- sum(sqrt((apply(cbind(y[-length(y)], y[-1]), 1, diff)^2) + (x[-1] - x[-length(x)])^2) + (x[-1] - x[-length(x)])) + y[length(1)] + y[length(y)]
  
  return(p)
}

#ghg <- c(12, 14, 17, 13, 8)
#trapezoid.PerC(seq(length(ghg)),ghg)
# 38.62047

