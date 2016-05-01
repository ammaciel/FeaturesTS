#' @title Split Time Series in Differents Intervals of Year
#' @name splitTS
#' @aliases splitTS 
#' @author Adeline M. Maciel
#' @docType data
#' 
#' @description Return a new data.frame with values of time series separeted for year, agricultural year ou interval defined by user.
#' @usage splitTS(fileTS = NULL, yearStart = NULL, yearEnd = NULL, 
#' nameColumnDate = NULL, typeInterval = c("annual","cropYear","myInterval"),
#' sameYear = TRUE, monthStart = 01, monthEnd = 12)
#' @param fileTS A file time series
#' @param yearStart A number integer of the year which starts time series, i.e, 2001
#' @param yearEnd A number integer of the year which ends time series, i.e, 2005
#' @param nameColumnDate A name of column with value of date in data.frame
#' @param typeInterval type of interval to split time series. Three types can be choose: "annual","cropYear"or "myInterval". Option annual data.frame will be separeted in data.frames by year, with time series from January until December, 12 months. Option cropYear, data.frame will be divided from July of a year until June of the nex year, with 12 months. And myInterval, user should choose the interval that split data.frame, for example, April until September, with 7 months, the same year or considering differents year, with 17 months. Default is annual.
#' @param sameYear TRUE/FALSE for define if data.frame will be split in year equals or not. Default is TRUE
#' @param monthStart A number integer defining the month starts to split, only if typeInterval is choose. Default is 1, January.
#' @param monthEnd A number integer defining the month ends to split, only if typeInterval is choose. Default is 12, December.
#' @keywords datasets
#' @return new dataset of data.frame with divided by interval
#' @import tools
#' @export 
#' @examples \dontrun{
#' # open a data example
#' library(featuresTS)
#' data <- data("dataTS")
#' df <- data
#'
#' # split data.frame df with typeInterval = annual in the same year
#' splitTS(df,2002,2005,"date",typeInterval = "annual")
#' # result in four new data.frames: ts.annual_2002, ts.annual_2003, ts.annual_2004
#' # and ts.annual_2005, with 12 months each
#'
#' # split data.frame df with typeInterval = cropYear, by different years
#' splitTS(df,2002,2005,"date",typeInterval = "cropYear")
#' # result in three new data.frames: ts.crop.year_2002_2003, ts.crop.year_2003_2004 and
#' # ts.crop.year_2004_2005, with 12 months each
#'
#' # split data.frame df with typeInterval = myInterval, but option sameYear = FALSE
#' splitTS(df,2002,2005,"date",typeInterval = "myInterval",
#' sameYear = FALSE, monthStart = 08, monthEnd = 03)
#' # result in three new data.frames: ts.myInterval_2002_2003, ts.myInterval_2003_2004 and
#' # ts.myInterval_2004_2005, with 8 months
#'
#' # split data.frame df with typeInterval = myInterval, but option sameYear = FALSE
#' splitTS(df,2002,2005,"date",typeInterval = "myInterval",
#' sameYear = FALSE, monthStart = 08, monthEnd = 03)
#' # result in four new data.frames: ts.myInterval_2002,  ts.myInterval_2003, ts.myInterval_2004 and
#' # ts.myInterval_2005, with 5 months
#'
#'}
#'
splitTS <- function(fileTS = NULL, yearStart = NULL, yearEnd = NULL, nameColumnDate = NULL, typeInterval = c("annual","cropYear","myInterval"), sameYear = TRUE, monthStart = 01, monthEnd = 12) {
  #library(tools)
  
  if (!is.null(fileTS)) {
    time <- fileTS
  }else {
    stop("File must be defined!")
  }
  
  if (!is.null(yearStart) && !is.null(yearEnd)) {
    yearStart <- yearStart
    yearEnd <- yearEnd
  } else {
    stop("Year START or END missing!")
  }
  
  if (!is.null(nameColumnDate)) {
    indexColumn <- which(colnames(time) == nameColumnDate)
    
    time$date <- format(time[,indexColumn], format = '%Y-%m')
    
    typeInterval <- match.arg(typeInterval)
    
    if (typeInterval == "annual") {
      cat(sprintf("Type of interval: %s\n", typeInterval))
      
      for (i in yearStart:yearEnd) {
        startYear <- i
        endYear <- startYear
        partTime <- sprintf("ts.annual_%s",startYear)
        assign(partTime,time[time$date >= sprintf("%s-01-01",startYear) &
                               time$date <= sprintf("%s-12-31",endYear),],envir = parent.frame())
      }
    } else if (typeInterval == "cropYear") {
      cat(sprintf("Type of interval: %s\n", typeInterval))
      yearEnd <- yearEnd - 1
      
      for (i in yearStart:yearEnd) {
        startYear <- i
        endYear <- startYear + 1
        partTime <- sprintf("ts.crop.year_%s_%s",startYear,endYear)
        assign(partTime,time[time$date >= sprintf("%s-07-01",startYear) &
                               time$date <= sprintf("%s-06-31",endYear),],envir = parent.frame())
      }
    }
    else if (typeInterval == "myInterval") {
      cat(sprintf("Type of interval: %s\n", typeInterval))
      
      if ((sameYear == TRUE) && (monthStart >= 1 && monthStart <= 12) && (monthEnd >= monthStart && monthEnd <= 12)) {
        cat(sprintf("\nInterval validated and consists of %d months\n\n", (monthEnd - monthStart) + 1 ))
        
        for (i in yearStart:yearEnd) {
          startYear <- i
          endYear <- startYear
          
          cat(sprintf("\tInterval choose: Start = %s-%02i-01 -- End = %s-%02i-31\n",startYear,monthStart,endYear,monthEnd))
          
          partTime <- sprintf("ts.myInterval_%s",startYear)
          assign(partTime,time[time$date >= sprintf("%s-%02i-01",startYear,monthStart) &
                                 time$date <= sprintf("%s-%02i-31",endYear,monthEnd),],envir = parent.frame()) # -07-01
        }
        cat("\nFiles created!\n\n")
      }
      else if ((sameYear == TRUE) && (monthStart < 1 || monthStart > 12  || monthEnd < monthStart || monthEnd < 1 || monthEnd > 12 )) {
        stop(
          "Interval invalidated! \n\tMonths must be between >= 01 or <= 12! \n\tIf interval in the same year is TRUE, 'Month END' must be more than 'Month START'!\n"
        )
        
      }
      else if ((sameYear == FALSE) && (monthStart >= 1 && monthStart <= 12) && (monthEnd >= 1 && monthEnd <= 12)) {
        cat(sprintf("\nInterval validated and consists of %d months\n\n", ((monthEnd + 12) - monthStart) + 1 ))
        
        yearEnd <- yearEnd - 1
        for (i in yearStart:yearEnd) {
          startYear <- i
          endYear <- startYear + 1
          
          cat(
            sprintf(
              "\tInterval choose: Start = %s-%02i-01 -- End = %s-%02i-31\n",startYear,monthStart,endYear,monthEnd
            )
          )
          
          partTime <-
            sprintf("ts.myInterval_%s_%s",startYear,endYear)
          assign(partTime,time[time$date >= sprintf("%s-%02i-01",startYear,monthStart) &
                                 time$date <= sprintf("%s-%02i-31",endYear,monthEnd),],envir = parent.frame())
        }
        cat("\nFiles created!\n\n")
        
      }
      else if ((sameYear == FALSE) && (monthStart < 1 || monthStart > 12 || monthEnd < 1 || monthEnd > 12 )) {
        stop("Interval invalidated! \n\tMonths must be between >= 01 or <= 12!\n")
      }
    }  else {
      stop("Interval should be: annual, cropYear or myInterval")
    }
  } else {
    stop("Column with name of feature date must be defined!")
  }
}
