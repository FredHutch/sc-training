#!/usr/bin/env Rscript
#
#  Create control table for series of cluster jobs 
#
#  control.R

library("RPostgreSQL")


# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")

# creates a connection to the postgres database
con <- dbConnect(drv, host = "mydb", port = 32055, user = "jfdey")

#
# create dataframe with list of files to process
#
nyc_taxi_path <- '/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/yellow'
file_list <- list.files(path = nyc_taxi_path, full.names = TRUE, pattern = "\\.csv$" )

nyc_taxi_control <- data.frame(file_list)
nyc_taxi_control["job_id"] <- NA
nyc_taxi_control["started"] <- NA
nyc_taxi_control["started"] <- NA


dbDisconnect(con)
