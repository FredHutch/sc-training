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
> sw2account groudine_m
> swc ls /
```

then we try to upload and download some data 

```
> swc upload /fh/fast/_SR/tmp/qtest /data/qtest
> swc upload /fh/fast/_SR/tmp/bowtie2-2.1.0 /software/bowtie
> swc archive /fh/fast/_SR/tmp/bowtie2-2.1.0 /archive/bowtie

> swc compare /fh/fast/_SR/tmp/qtest /data/qtest

> swc download /data/qtest /fh/fast/_SR/tmp/qtest2
> swc unarch /archive/bowtie /fh/fast/_SR/tmp/bowtie

```


