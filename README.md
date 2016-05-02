# featuresTS

This package perfomed features extraction from time series data. The attributes extracted consists of statistical values, such as, maximum value, minimum value, standart deviation, variance, mean, median, amplitude, skewness, kurtosis, area under curve and perimeter about curve from time series. 

With package "featuresST" is possible to filter time series using Savitzky-Golay filters, divide time series data in parts as for annual or a interval defined by user and also performed features extraction using parts data, been generated statistical values about time series data and/or subinterval this time series.  

Time series data can be found using package wtss at http://github.com/gqueiroz/wtss

Prerequisites: Git, R and RStudio

To use the package:
  Open RStudio
  Install devtools \code{install.packages("devtools")}
  Charge package library(devtools)
  Load the featuresTS package install_github("ammaciel/FeaturesTS")

Usage examples:
  Load the featuresTS package \code{library(featuresTS)}
  Load a example data
  Create a connection obj = wtssClient("http://www.dpi.inpe.br/mds/mds")
  Get the list of products provided by the service objlist = listCoverages(obj)
  Get the description of an specific product objdesc = describeCoverages(obj,"MOD09Q1")
  Get a time series ts1 = getTimeSeries(obj, coverages="MOD09Q1", datasets=c("nir","quality","red","evi2"), latitude=-12, longitude=-45, from="2004-01-01", to="2004-05-01")  
