Apache Drill Training
===

Prepare
---

go to https://github.com/FredHutch/sc-training/tree/master/apache-drill

* ensure that putty is installed or get it here: 
  https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi
* download and unzip https://raw.githubusercontent.com/FredHutch/sc-training/master/apache-drill/desktop-tool-config.zip
* Execute putty-good-defaults.reg

checkout github training repos
---

* login to rhino via putty (you might have to set username@rhino1 in host name) and execute 

```
> git clone git://github.com/FredHutch/sc-training
> cd apache-drill
```

installing apache drill 
---

first we are going to install a machine container (please choose a different host name, e.g. not drill80)

```
> prox --bootstrap --mem 32G --disk 8 --cores 8 --runlist drill.runlist new drill80
```


Now let's say you would like to run a cluster of multiple machines for more performance. 
In this case we want to bootstrap multiple machines (let's call them drill90-92)

```
> prox --bootstrap --mem 32G --disk 8 --cores 8 --runlist drill.runlist new drill90 drill91 drill92

```

edit /etc/zookeeper/conf/zoo.cfg on all 3 machines 
```
# configure drill90-92 as servers so they know to talk to each other
server.1=drill90:2888:3888
server.2=drill91:2888:3888
server.3=drill92:2888:3888

# set leaderServer to "yes" on the first machine (e.g drill90). Leader accepts client connections.
leaderServes=yes

```

give each machine a unique zookeeper id between 1 and 255 and restart zookeeper:
```
> ssh drill90 'sudo sh -c "echo \"echo 1 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'
> ssh drill91 'sudo sh -c "echo \"echo 2 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'
> ssh drill92 'sudo sh -c "echo \"echo 3 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'

```




Prepare NYC taxi cab data
---

(you can skip this step if you login to the machine and the data already exists in
/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned)


download the taxi cab data (http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml)
from archive to a high performance file system (if it does not exist yet)

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
to separate them 

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

Using Drill
---

First we try this, 

SELECT * FROM dfs.`/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/yellow` limit 100

it will return this :

["vendor_id"," pickup_datetime"," dropoff_datetime"," passenger_count"," trip_distance"," pickup_longitude"," pickup_latitude"," rate_code"," store_and_fwd_flag"," dropoff_longitude"," dropoff_latitude"," payment_type"," fare_amount"," surcharge"," mta_tax"," tip_amount"," tolls_amount"," total_amount"]
["CMT","2014-08-16 14:58:49","2014-08-16 15:15:59","1","2.7000000000000002","-73.946537000000006","40.776812999999997","1","N","-73.976192999999995","40.755625000000002","CSH","14","0","0.5","0","0","14.5\r"]

by default each row comes back as a list /  string

then you go to the storage tab and click update in the line that shows "dfs"

add "skipFirstLine": true,
in the csv section right in front of 
"delimiter": "," 

When I try this query it scans as many csv files in parallel as there are cpus in
the system, in this cases this causes almost a saturation of the 10G network connection of the server

SELECT count(*) FROM dfs.`/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/yellow2`

This query causes a very high cpu utilization on the server but hardly any network throughput

"SELECT columns[0], columns[1] FROM dfs.`/fh/scratch/delete30/_HDC/testdata/nyc-taxi-cleaned/green`





