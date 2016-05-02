<h2>featuresTS</h2>

This package perfomed features extraction from time series data. The attributes extracted consists of statistical values, such as, maximum value, minimum value, standart deviation, variance, mean, median, amplitude, skewness, kurtosis, area under curve and perimeter about curve from time series. 

With package "featuresST" is possible to filter time series using Savitzky-Golay filters, divide time series data in parts as for annual or a interval defined by user and also performed features extraction using parts data, been generated statistical values about time series data and/or subinterval this time series.  

Time series data can be found using package wtss at <a href="http://github.com/gqueiroz/wtss/">http://github.com/gqueiroz/wtss<a>

<h3>Prerequisites: </h3> 
<ul>
  <li><a href="http://git-scm.com/">Git</a></li>
  <li><a href="http://www.r-project.org/">R</a></li>
  <li><a href="http://www.rstudio.com/">Rstudio</a></li>
  <li> time series data from wtss package
</ul>

<h3>How to use the package:</h3>
<ul>
  <li>Open RStudio</li>
  <li>Install devtools <code>install.packages("devtools")</code><li>
  <li>Load devtools <code>library(devtools)</code></li>
  <li>Install the featuresTS package <code>install_github("ammaciel/FeaturesTS")</code></li>
  <li>
</ul>

<h3>Examples:</h3>
<ul>
  <li> Load the featuresTS package <code>library(featuresTS) </code></li>
  <li> Load a example data <code> data("dataTS") </code></li>
  <li> Create new data.frame df <code> df <- dataTS </code></li>
  <li> Apply the filter about df data frame <code> filterTS(fileTS = df, nameColumnValue = "value", outlier = TRUE, value= -0.300) </code></li>
  <li> Split time series for year <code> splitTS(data.filtered,2002,2005,"date",typeInterval = "annual") </code></li>
  <li> Get attributes from time series splited in annual values without subintervals <code> example1 <- featuresExtractionTS(fileTS = ts.annual_2002, nameColumnValue = "filtered.value", subInterval = FALSE) </code> 
      and view example1 <code> utils::View(example1) </code> </li>
  <li> Get attributes from time series splited in annual values with subintervals <code> example2 <- featuresExtractionTS(fileTS = ts.annual_2002, nameColumnValue = "filtered.value", subInterval = TRUE, numberSubIntervals = 3) </code> 
      and view example2 <code> utils::View(example2) </code> </li>
</ul>  
  
  
