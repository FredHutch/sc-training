NYC-Taxi-data
===

Prepare session 
---

go to https://github.com/FredHutch/sc-training and look at training-preparation

Prepare NYC taxi cab data
---

you can skip this sesson if you see this data exists already in 
/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned)


The first step is to download the taxi cab data 
(http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml)
from our archive to a high performance file system (if it does not exist yet)

```
sw2account _ADM_IT_public
swc download /nyc-taxi-data /fh/scratch/delete30/_HDC/testdata/nyc-taxi-data
```

prepare / clean data for consumption (e.g remove empty line 2 from csv file)

```
cd /fh/scratch/delete30/_HDC/testdata
mkdir -p nyc-taxi-cleaned/yellow
mkdir -p nyc-taxi-cleaned/green
mkdir -p nyc-taxi-cleaned/fhv
mkdir -p nyc-taxi-cleaned/uber

ls nyc-taxi-data/yellow_*.csv | parallel -j 8 sed '2d' {} '>' ../nyc-taxi-cleaned/yellow/{}
ls nyc-taxi-data/green_*.csv | parallel -j 8 sed '2d' {} '>' ../nyc-taxi-cleaned/green/{}
ls nyc-taxi-data/fhv_*.csv | parallel -j 8 sed '2d' {} '>' ../nyc-taxi-cleaned/fhv/{}
ls nyc-taxi-data/uber-*.csv | parallel -j 8 sed '2d' {} '>' ../nyc-taxi-cleaned/uber/{}
```

The yellow cab data structure changed in 2015. We see different column names 
but also one column was added. So lets just put the files in 2 different folders
(yellow1 and yellow2) to separate them 

```
> head -n 1 yellow/yellow_tripdata_2016-06.csv | tr , "\n" | head -n3
VendorID
tpep_pickup_datetime
tpep_dropoff_datetime

> head -n 1 yellow/yellow_tripdata_2014-12.csv | tr , "\n" | head -n3
vendor_id
 pickup_datetime
 dropoff_datetime

>  head -n 1 yellow/yellow_tripdata_2016-06.csv | tr , "\n" | tail -n3
tolls_amount
improvement_surcharge
total_amount

> head -n 1 yellow/yellow_tripdata_2016-06.csv | tr , "\n" | tail -n4
tip_amount
tolls_amount
improvement_surcharge
total_amount

mkdir -p nyc-taxi-cleaned/yellow1
mkdir -p nyc-taxi-cleaned/yellow2

mv nyc-taxi-cleaned/yellow/yellow_tripdata_2016*.csv nyc-taxi-cleaned/yellow2/
mv nyc-taxi-cleaned/yellow/yellow_tripdata_2015*.csv nyc-taxi-cleaned/yellow2/
mv nyc-taxi-cleaned/yellow/yellow_*.csv nyc-taxi-cleaned/yellow1/
```

in case we want to still analyse all yellowcab data in a single process we create 
a single directory with all symbolic links pointing to yellow cab data : 

```
> cd /fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/yellow
> for i in $(ls ../yellow1/); do ln -s ../yellow1/$i $i; done
> for i in $(ls ../yellow2/); do ln -s ../yellow2/$i $i; done
```

Often we need to fix some permissions:
```
> cd /fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/
> find . -type d -exec chmod o+rx {} \;
> find . -type f -exec chmod o+r {} \;
```




