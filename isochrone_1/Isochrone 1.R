# Isochrones
# 19.05.2026
# madeline lebreton, adapted from https://ipeagit.github.io/r5r/articles/isochrones.html 

### r5r needs JDK 21
# install.packages('rJavaEnv')
# rJavaEnv::java_quick_install(version = 21)

# 1. Point R directly to the real folder
Sys.setenv(JAVA_HOME = "C:/Users/Equipo/AppData/Local/R/cache/R/rJavaEnv/installed/windows/x64/21")
# 2. Force rJava to initialize using this new path
library(rJava)
.jinit() 

# allocate Ram 
options(java.parameters = "-Xmx2G") # increase java ram


library(r5r)
library(sf)
library(data.table)
library(ggplot2)



### build routable network with build_network
# system.file returns the directory with example data inside the r5r package
# set data path to directory containing your own data if not running this example
# (with the path to the directory where OpenStreetMap and GTFS data are stored)
data_path <- system.file("extdata/poa", package = "r5r")
r5r_network <- build_network(data_path)


### calculating and visualizing isochrones (polygon-based)
# read all points in the city
points <- fread(file.path(data_path, "poa_hexgrid.csv"))

# subset point with the geolocation of the central bus station
central_bus_stn <- points[291,]

# isochrone intervals
time_intervals <- seq(0, 100, 10)

# routing inputs
mode <- c("WALK", "TRANSIT")
max_walk_time <- 30      # in minutes
max_trip_duration <- 90  # in minutes
time_window <- 60        # in minutes
departure_datetime <- as.POSIXct("13-05-2019 14:00:00",
                                 format = "%d-%m-%Y %H:%M:%S")

# calculate travel time matrix
# r5r determines the isochrones considering the median travel 
# time of multiple travel time estimates calculated departing 
# every minute over a 60-minute time window, between 2pm and 4pm.
iso1 <- r5r::isochrone(
  r5r_network,
  origins = central_bus_stn,
  mode = mode,
  polygon_output = TRUE, 
  cutoffs = time_intervals,
  departure_datetime = departure_datetime,
  max_walk_time = max_walk_time,
  max_trip_duration = max_trip_duration,
  time_window = time_window,
  progress = FALSE
)

# read all points in the city
points <- fread(file.path(data_path, "poa_hexgrid.csv"))

# subset point with the geolocation of the central bus station
central_bus_stn <- points[291,]

# isochrone intervals
time_intervals <- seq(0, 100, 10)

# routing inputs
mode <- c("WALK", "TRANSIT")
max_walk_time <- 30      # in minutes
max_trip_duration <- 90  # in minutes
time_window <- 60        # in minutes
departure_datetime <- as.POSIXct("13-05-2019 14:00:00",
                                 format = "%d-%m-%Y %H:%M:%S")

# calculate travel time matrix
iso1 <- r5r::isochrone(
  r5r_network,
  origins = central_bus_stn,
  mode = mode,
  polygon_output = TRUE, 
  cutoffs = time_intervals,
  departure_datetime = departure_datetime,
  max_walk_time = max_walk_time,
  max_trip_duration = max_trip_duration,
  time_window = time_window,
  progress = FALSE,
  zoom = 10
)

# returns a polygon for each isochrone of each origin
head(iso1)
