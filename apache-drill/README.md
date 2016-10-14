Apache Drill Training
===

Prepare
---

go to https://github.com/FredHutch/sc-training/tree/master/apache-drill

* ensure that putty is installed or get it here: 
  https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi
* download and unzip https://raw.githubusercontent.com/FredHutch/sc-training/master/apache-drill/desktop-tool-config.zip
* Execute putty-good-defaults.reg

* navigate to page https://teams.fhcrc.org/sites/citwiki/SciComp/Pages/How%20to%20use%20Economy

checkout github training repos
---

* login to rhino via putty (you might have to set username@rhino1 in host name) 

```
> git clone git://github.com/FredHutch/sc-training
> cd apache-drill
```

installing apache drill 
---

first we are going to install multiple virtual machines

```
> prox --mem 64 --runlist drill.runlist new drill80 drill81 drill82
>
```
