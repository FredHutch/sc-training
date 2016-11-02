Apache Drill Training
===

Prepare session 
---

go to https://github.com/FredHutch/sc-training and look at 2 folders :

          1. training-preparation
          2. prep-nyc-taxi-data


checkout github training repos
---

```
> git clone git://github.com/FredHutch/sc-training
> cd apache-drill
```

installing apache drill 
---

first we are going to install a machine container (please choose a different host name, e.g. not drill80)

```
> prox new --bootstrap --mem 32G --disk 8 --cores 8 --runlist drill.runlist drill80
```

After the install is finishied you are prompted to start drill by executing 
something like this:
```
/opt/drill/apache-drill-x.x.x/bin/drill-embedded
```

A drill shell is loaded and you can execute SQL statements right there
or you go to the web interface at http://drill80:

http://drill80:8047/query and enter a simple SQL statement:

```
SHOW DATABASES;
```

This should return 6 entries 




Advanced: Using Drill in cluster mode:
---

Now let's say you would like to run a cluster of multiple machines for more performance. 
In this case we want to bootstrap 4 machines (let's call them drill90-93). 
The Zookeeper cluster resource manager will be installed on all 4 machines 
but the first machine will be the leader server. Drillbits (worker nodes ) 
will be installed only on the 3 remaining nodes (not on the leader)

```
> prox new --bootstrap --mem 32G --disk 8 --cores 8 --runlist drill.runlist drill90 drill91 drill92 drill93

```

edit /etc/zookeeper/conf/zoo.cfg on all 3 machines 
```
# configure drill90-92 as servers so they know to talk to each other
server.1=drill90:2888:3888
server.2=drill91:2888:3888
server.3=drill92:2888:3888
server.4=drill9:2888:3888

# set leaderServer to "yes" on the first machine (e.g drill90). Leader accepts client connections.
leaderServes=yes

```

give each machine a unique zookeeper id between 1 and 255 and restart zookeeper:
```
> ssh drill90 'sudo sh -c "echo \"echo 1 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'
> ssh drill91 'sudo sh -c "echo \"echo 2 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'
> ssh drill92 'sudo sh -c "echo \"echo 3 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'
> ssh drill93 'sudo sh -c "echo \"echo 4 > /var/lib/zookeeper/myid\" | sudo sh" && sudo systemctl restart zookeeper'

```


to configure drill, we need to edit drill-override.conf 

in /opt/drill/apache-drill-1.8.0/conf/drill-override.conf

replace this:

```
drill.exec: {
  cluster-id: "drillbits1",
  zk.connect: "localhost:2181"
}
```

with this:

```
drill.exec: {
  cluster-id: "thedrill",
  zk.connect: "drill91:2181,drill92:2181,drill93:2181"
}
```

then start the drillbit on each machine

```
> /opt/drill/apache-drill-1.8.0/bin/drillbit.sh restart
```

go to the query interface of one of the machines, e.g http://drill92:8047/query 
and check if all the drillbits are running: 




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





