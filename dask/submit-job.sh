#! /bin/bash
sbatch --tasks=60 --ntasks-per-node=6 --cpus-per-task=2 --time=1-0 fhdask nyc-taxi.py

