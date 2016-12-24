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

nyc0 = dd.read_csv(testdata+'/nyc-taxi-cleaned/yellow0/*.csv',
                parse_dates=['Trip_Pickup_DateTime', 'Trip_Dropoff_DateTime'])

nyc1 = dd.read_csv(testdata+'/nyc-taxi-cleaned/yellow1/*.csv',
        parse_dates=['pickup_datetime', 'dropoff_datetime'])
             # skipinitialspace=True)

nyc2 = dd.read_csv(testdata+'/nyc-taxi-cleaned/yellow2/*.csv',
        parse_dates=['tpep_pickup_datetime', 'tpep_dropoff_datetime'])


#nyc0.head()
#nyc1.head()
#nyc2.head()


nyc0, nyc1, nyc2 = e.persist([nyc0, nyc1, nyc2])


print(nyc0.head())
print(nyc0.Payment_Type.value_counts().compute())
print(nyc1.payment_type.value_counts().compute())
print(nyc2.payment_type.value_counts().compute())


#progress(nyc0, nyc1, nyc2)

