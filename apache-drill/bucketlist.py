#! /usr/bin/env python3

# Script to extract files from a json based directory listing of a webserver
# github-syncer dirkpetersen / June 2014

import sys, os, requests, json, subprocess
import argparse, glob, re

STORAGE_URL = 'https://tin.fhcrc.org/v1/AUTH_Swift__ADM_IT_public'
bucket = 'nyc-taxi-data'

def main():

    objects = requests.get('%s/%s?format=json' % (STORAGE_URL, bucket)).json()
    files = [obj['name'] for obj in objects]
    for f in files:
        print('%s/%s/%s' % (STORAGE_URL,bucket,f))

def parse_arguments():
    """
    Gather command-line arguments.
    """
    return False
       
if __name__ == "__main__":
    args = parse_arguments()
    try:
        main()
    except KeyboardInterrupt:
        print('Exit !')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
