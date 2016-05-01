#' @title Filter Time Series using Savitzky–Golay filter
#'
#' @description Return a new data.frame with values of time series filtered.
#' @usage{ filterTS( fileTS = data, nameColumnValue = "V1", outlier = if(TRUE)
#' define a number to next parameter value, value = integer ) }
#' @param fileTS file time series
#' @param nameColumnValue name of column with value to filter
#' @param outlier TRUE/FALSE if have any outlier for to make interpolation
#' @param value a single integer if outlier is TRUE
#' @keywords features extraction, time series, Savitzky–Golay filter
#' @seealso Savitzky–Golay filter details in \code{\link{signal}} package
#' @return data.filtered new data.frame with new column with value filtered
#' @examples
#' # open a data example
#' df <- read.csv("data/dataTimeSeries.csv")
#' #'
#' # the time series data contains 4 columns and 207 rows like
#' # longitude  latitude       date   value
#' #  -57.0474 -11.36449 2004-06-25  0.3125
#' #  -57.0474 -11.36449 2004-07-11  0.3235
#' #  -57.0474 -11.36449 2004-07-27 -0.3000
#' #  -57.0474 -11.36449 2004-08-12  0.3648
#'
#' # apply function filterTS
#' library(featuresTS)
#' filterTS(fileTS = df, nameColumnValue = "value", outlier = TRUE, value= -0.300)
#'
#' # show new data.frame with values filtered
#' head(data.filtered)
#'
#'
#'
#'
filterTS <- function(fileTS = NULL, nameColumnValue = NULL, outlier = FALSE, value = -0.3) {
  library(tools)

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
      library(zoo)
      for (i in 1:nrow(time)) {
        if (time[i,indexColumn] == as.integer(outlier)) {
          time[i,indexColumn] <- NA
          time[,indexColumn] <- na.approx(time[,indexColumn])
        }
      }
    } else {
      cat("\nNo value for interpolation.\n\n")
    }

    # Savitzky-Golay smoothing filter
    library(signal)
    sg = sgolayfilt(time[,indexColumn],  p = 1, n = 3, ts = 30)

    time[,indexColumn] <- cbind(sg)

    colnames(time) <- c("longitude","latitude","date","filtered.value","original.value")

    assign('data.filtered',time,envir = parent.frame())

    cat("Done! File data frame 'data.filtered' created.\n")
  }else {
    stop("Column with value for cleaning must be defined!")
  }

}
