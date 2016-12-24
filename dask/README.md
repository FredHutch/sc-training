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
that span multiple cpus or multiple machines. These dataframe objects are
compatible to pandas dataframes. 
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
dask scheduler that is able to receive the data 


References
---

https://www.continuum.io/blog/developer-blog/high-performance-hadoop-anaconda-and-dask-your-cluster
http://matthewrocklin.com/blog/work/2016/02/22/dask-distributed-part-2
https://github.com/dask/dask-examples/blob/master/nyctaxi-2013.ipynb
