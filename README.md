<h2>featuresTS</h2>

This package perfom features extraction from time series data. The attributes extracted consist of statistical values, such as, maximum value, minimum value, standart deviation, variance, mean, median, amplitude, skewness, kurtosis, area under curve and perimeter of the curve from time series. 

With package "featuresST" is possible to filter time series using Savitzky-Golay filter, to divide time series data in parts as for annual or an interval defined by user and also to perform features extraction using time series data divided for year or another interval, as also generate statistical values about time series data and/or subintervals this time series. Besides is possible to extract focal neighborhood features for time series. 

With this features the user can to perform data mining on time series data to classify land use and land conver.

Time series data can be found using package wtss at <a href="http://github.com/gqueiroz/wtss/">http://github.com/gqueiroz/wtss<a>

<h3>Prerequisites: </h3> 
<ul>
  <li><a href="http://git-scm.com/">Git</a></li>
  <li><a href="http://www.r-project.org/">R</a></li>
  <li><a href="http://www.rstudio.com/">Rstudio</a></li>
  <li>Time series data from wtss package </li>
  <li>The focalFeaturesTS function requires that the igraph package is available. </li> 
</ul>

<h3>How to use the package:</h3>
<ul>
  <li>Open RStudio</li>
  <li>Install devtools <code> install.packages("devtools") </code> </li>
  <li>Load devtools <code> library(devtools) </code> </li>
  <li>Install the featuresTS package <code> install_github("ammaciel/FeaturesTS") </code> </li>
</ul>

<h3>Examples 1 - Only one time series:</h3>
<ul>
  <li> Load the featuresTS package <code> library(featuresTS) </code></li>
  <li> Load a example data <code> data("dataTS") </code></li>
  <li> Create new data.frame df <code> df <- dataTS </code></li>
  <li> Apply the filterTS function on df data frame <code> dataFiltered <- filterTS(fileTS = df, nameColumnValue = "value", outlier = TRUE, value= -0.300)  </code></li>
  <li> See filtered time series <code> plot.ts(dataFiltered$original.value, lwd = 2, col="black");lines(dataFiltered$filtered.value, lwd=2, col="red") </code></li>
  <li> Apply splitTS fcuntion to divide time series for year <code> splitTS(dataFiltered,2002,2005,"date",typeInterval = "annual") </code></li>
  <li> Get features from time series divided in annual values without subintervals <code> example1 <- featuresExtractionTS(fileTS = ts.annual_2002, nameColumnValue = "filtered.value", subInterval = FALSE) </code> </li>
  <li> Get features from time series divided in annual values with subintervals <code> example2 <- featuresExtractionTS(fileTS = ts.annual_2002, nameColumnValue = "filtered.value", subInterval = TRUE, numberSubIntervals = 3) </code> </li>
  <li> Show data frames example1 and example2 <code> utils::View(example1) </code> <code> utils::View(example2) </code> </li>
</ul>  

<h3>Examples 2 - For a set of time series to extraction of focal neighborhood features:</h3>
<ul>
  <li> Load the featuresTS package <code> library(featuresTS) </code></li>
  <li> Load the igraph package <code> library(igraph) </code></li>
  <li> Load a example data <code> data("dataFeaturesTS") </code></li>
  <li> Create new data.frame df <code> df <- dataFeaturesTS </code></li>
  <li> Apply the focalFeaturesTS function on df data frame df <code> dfTSwithFocalFeatures <- focalFeaturesTS(fileTS = df, valueToleranceRaster = 0.000891266)  </code></li>
  <li> See new data.frame <code> head(dfTSwithFocalFeatures) </code></li>
  <li> See plots with values of focal neighborhood to mean, max, min and standard deviation for features mean, max, min, stardard deviation and amplitude.  
</ul> 
  
  
