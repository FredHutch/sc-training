#! /usr/bin/env python3

import sys, os 
from distributed import Executor, progress
from dask import dataframe as dd

if len(sys.argv) < 2:
    e = Executor('127.0.0.1:8786')
else:
    e = Executor(sys.argv[1])

print(e)

testdata = '/fh/scratch/delete30/_HDC/testdata'
#testdata = '/fh/fast/_ADM/SciComp/data'

nyc2 = dd.read_csv(testdata+'/nyc-taxi-cleaned/yellow2/*.csv',
        parse_dates=['tpep_pickup_datetime', 'tpep_dropoff_datetime'])

nyc2 = e.persist(nyc2)

print('payment type, please wait ...')
print(nyc2.payment_type.value_counts().compute())

