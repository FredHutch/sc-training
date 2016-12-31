Dask Training
===

Prepare session 
---

go to https://github.com/FredHutch/sc-training and prepare for training:

          1. training-preparation
           


checkout github training repos
---

```
> git clone git://github.com/FredHutch/sc-training
> cd sc-training/dask
```


What is dask ?
---

dask is a compute framework that allows data scientists to use dataframes
or arrays that span multiple cpus or multiple machines. 
These dataframe or array objects are (largely) compatible to pandas 
dataframes and numpy arrays.
This method allows us to work on data that is larger than a single machine 
or use more cpus than you would typically find on a single machine. 


---

first we are going to have a look at the code we want to execute.

```
> head nyc-taxi.py
#! /usr/bin/env python3

import sys, os 
from distributed import Executor, progress
from dask import dataframe as dd

if len(sys.argv) < 2:
    e = Executor('127.0.0.1:8786')
else:
    e = Executor(sys.argv[1])
```

you can launch nyc-taxi.py with the ip address / host name / port of the 
dask scheduler that is able to receive the data. For example we can 
time the execution of this script that this submitted to a dask cluster
which runs ontop of gizmo.

```
petersen@rhino1:/home…-training/dask$ time ./nyc-taxi.py gizmof8:12922
<Client: scheduler="gizmof8:12922" processes=4 cores=8>
.
.
real	4m16.661s
user	0m3.703s
sys	0m0.552s

```

so this script runs a little longer than 4 minutes when using 4 workers
with a total of 8 cpu cores.


Now let's start a new Dask cluster using the 'grabdask' script. When the
script asks how many workers we want we answer 64.

```
petersen@rhino1:/home…-training/dask$ grabdask 

Please enter the number of dask workers (default: 8): 64
Please enter the number of days to grab these workers (default: 1): 
Job 45980892: 2 cores per worker, 128 total cores.
Job 45980892 pending, reason: None
Job 45980892 started, waiting for Dask...

  WARNING: Dask has been started in your user context, which means that:
  Anyone connecting to port gizmof77:16575 could get access to your data
  in mounted file systems such as /home or /fh

  You can now connect to Dask, e.g. e = distributed.Executor("gizmof77:16575").
  For status monitoring with Bokeh please go to http://gizmof77:16576/
  or wait until browser is started....

```

We see the the Dask executor (or scheduler) is now listening on 
gizmof77:16575 so we pass this information to the nyc-taxi.py script: 

```
petersen@rhino1:/home…-training/dask$ time ./nyc-taxi.py gizmof77:16575
<Client: scheduler="gizmof77:16575" processes=64 cores=128>
payment type:
1    137641498
2     76840558
3       773472
4       263929
5           34
Name: payment_type, dtype: int64

real	0m25.622s
user	0m3.114s
sys	0m0.412s

```

We see that this script now runs in 26 instead of 266 seconds. While we
achieve a 10 fold performance improvement we need 16 times more 
computer power.

Running the same test with 2, 4, 8, 16, 64, 128 and 196 cores we get 
run times between 893 and 23 seconds:


![NYC Taxi runtimes](img/nyc-taxi-runtimes.png)


References
---

https://www.continuum.io/blog/developer-blog/high-performance-hadoop-anaconda-and-dask-your-cluster
http://matthewrocklin.com/blog/work/2016/02/22/dask-distributed-part-2
https://github.com/dask/dask-examples/blob/master/nyctaxi-2013.ipynb
