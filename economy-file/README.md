Economy File Training
===


Prepare
---

go to https://github.com/FredHutch/sc-training/tree/master/economy-file

* ensure that putty is installed or get it here: 
  https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi
* download and unzip https://raw.githubusercontent.com/FredHutch/sc-training/master/economy-file/desktop-tool-config.zip
* Execute INSTALL-DUCK.bat and putty-good-defaults.reg
* Optionally install https://github.com/FredHutch/swiftclient-gui/raw/master/msi/OpenStack-Swift-Client-3.0.0-amd64.msi
 

* navigate to page https://teams.fhcrc.org/sites/citwiki/SciComp/Pages/How%20to%20use%20Economy%20File%20Storage.aspx


checkout github training repos
---

* login to rhino via putty (you might have to set username@rhino1 in host name) 

```
> git clone git://github.com/FredHutch/sc-training
> cd economy-file
```

uploading and downloading folders
---

first we want to switch to a departmental / PI account

```
> sw2account _SR
> sw2account henikoff_s
> swc ls /
```

then we try to upload and download some data. The samba logs which 
you find on most Linux systems are a good example for a quick test 

```
swc upload ./testdata /mytest/data
swc download /mytest/data ./downloads/data
swc archive ./testdata /mytest/archive
swc unarch /mytest/archive ./downloads/archive
swc search useful /mytest
swc compare ./downloads/data /mytest/data
swc rm -rf /mytest/archive
swc rm -rf /mytest/data
swc ls /mytest
swc rm -rf /mytest

```


we can search data in full text mode: 

```
> swc size /archive/Illumina
    checking swift folder archive/Illumina ...
    1,435,378,924,506 bytes (1.305 TB) in archive/Illumina (swift)

> time swc search TTTCAAAAACCAGTTTTCATCTTAA /archive/Illumina

real    3m45.709s

This went through more than 1 TB of data in less than 4 minutes

```

you can view up a 8GB sequencing file in ca 30 sec

```
> time swc less /archive/Illumina/110217_SN367_0145_A81GVBABXX/Data/Intensities/BaseCalls/GERALD_23-02-2011_solexa/s_4_2_sequence.txt

real    0m34.788s

```


in HPC scripts you can conditionally download large files to scatch,
even if they are deleted after 30 days, your script will always run.

```
#! /bin/bash
#SBATCH --partition=restart

bamfolder="/fh/scratch/delete30/lastname_f/bam"
if ! [[ -f $bamfolder/myfile.bam ]]; then
  swc download /bamarchive/myfile.bam $bamfolder/myfile.bam
fi
samtools .... /fh/scratch/delete30/lastname_f/bam/myfile.bam
```
