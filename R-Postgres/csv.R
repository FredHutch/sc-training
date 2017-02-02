#!/usr/bin/env Rscript
#
# csv.R
library("RPostgreSQL")

nyc_taxi_path <- '/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/yellow'
fname <- 'yellow_tripdata_2010-01.csv'

nycdata <- read.csv(file=paste(nyc_taxi_path, fname, sep="/"), head=TRUE, sep=",")

# VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, 
# pickup_longitude, pickup_latitude, RateCodeID, store_and_fwd_flag, 
# dropoff_longitude, dropoff_latitude, 
# payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount

result_df <- setNames(data.frame(matrix(ncol = 3, nrow = 2)), c("Distance", "Amt", "Tip"))
rownames(result_df) = list("Cash", "Credit")

cash <- subset(nycdata, payment_type == "Cas" | payment_type == "CAS")
credit <- subset(nycdata, payment_type == "Cre" | payment_type == "CRE")

# Tip Amount

result_df[1,1] = mean(cash$trip_distance)
result_df[1,2] = mean(cash$total_amount)
result_df[1,3] <- mean(cash$tip_amount)

result_df[2,1] = mean(credit$trip_distance)
result_df[2,2] = mean(credit$total_amount)
result_df[2,3] <- mean(credit$tip_amount)

print.money <- function(x, ...) {
  print.default(paste0("$", formatC(as.numeric(x), format="f", digits=2, big.mark=",")))
}

format.money  <- function(x, ...) {
  paste0("$", formatC(as.numeric(x), format="f", digits=2, big.mark=","))
}

class(result_df$Tip) <- c("money", class(result_df$Tip))
class(result_df$Amt) <- c("money", class(result_df$Amt))

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "jfdey",
                 host = "mydb", port = 32057,
                 user = "jfdey")

dbWriteTable(con, "NYdata", result_df, overwrite=TRUE)

dbDisconnect(con)
