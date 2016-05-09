#' @title Filter Time Series using Savitzky-Golay filter
#' @name filterTS
#' @aliases filterTS
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Return a new data.frame with values of time series filtered.
#' @usage filterTS(fileTS = NULL, nameColumnValue = NULL, outlier = FALSE, value = -0.3000)
#' @param fileTS A file time series
#' @param nameColumnValue A name of column with value to filter
#' @param outlier Logical. If FALSE (the default), there none outlier for to make interpolation. If TRUE, there some gaps with values to make interpolation. 
#' @param value A single integer if outlier is TRUE.
#' @keywords datasets
#' @seealso Savitzky-Golay filter details in \code{\link{signal}} package
#' @return dataFiltered A new data.frame with new column of the value filtered
#' @import tools
#' @importFrom signal sgolayfilt
#' @import zoo
#' @export
#'  
#' @examples \dontrun{
#' # open a data example
#' library(featuresTS)
#' data("dataTS")
#' df <- dataTS
#'  
#' # the time series data contains 4 columns and 207 rows like
#' # longitude  latitude       date   value
#' #  -57.0474 -11.36449 2004-06-25  0.3125
#' #  -57.0474 -11.36449 2004-07-11  0.3235
#' #  -57.0474 -11.36449 2004-07-27 -0.3000
#' #  -57.0474 -11.36449 2004-08-12  0.3648
#'
#' # apply function filterTS
#' filterTS(fileTS = df, nameColumnValue = "value", outlier = TRUE, value= -0.300)
#'
#' # show new data.frame with values filtered
#' head(dataFiltered)
#'
#'}
#'
filterTS <- function(fileTS = NULL, nameColumnValue = NULL, outlier = FALSE, value = -0.3000) {
  #library(tools)
  
  if (!is.null(fileTS)) {
    time <- fileTS
  }else {
    stop("File must be defined!")
  }
  
  if (!is.null(nameColumnValue)) {
    indexColumn <- which(colnames(time) == nameColumnValue)
    
    time$temp <- cbind(time[,indexColumn])
    
    # change outliers to NA value, after make interpolation
    if (outlier == TRUE) {
      #library(zoo)
      for (i in 1:nrow(time)) {
        if (time[i,indexColumn] == as.integer(outlier)) {
          time[i,indexColumn] <- NA
          time[,indexColumn] <- zoo::na.approx(time[,indexColumn])
        }
      }
    } else {
      cat("\nNo value for interpolation.\n\n")
    }
    
    # Savitzky-Golay smoothing filter
    #library(signal)
    sg = signal::sgolayfilt(time[,indexColumn],  p = 1, n = 3, ts = 30)
    
    time[,indexColumn] <- cbind(sg)
    
    colnames(time) <- c("longitude","latitude","date",sprintf("filtered.%s",nameColumnValue), sprintf("original.%s", nameColumnValue))
    
    dataFiltered <- time
    
    return(dataFiltered)
    
    cat("Done! File data frame 'data.filtered' created.\n")
  }else {
    stop("Column with value for cleaning must be defined!")
  }
  
}




#' dataTS
#' @name dataTS
#' @source wtss service
#'
#' @description Dataset example with one time series to run some functions this package
NULL


#' dataFeaturesTS
#' @name dataFeaturesTS
#'
#' @description Dataset of the time series alredy features extracted to perform focal extraction
NULL


