@echo off
X:
cd "x:\fast\_ADM\SciComp\setup\packages\MountainDuck\"
echo "Please wait....."
mkdir %APPDATA%\Cyberduck\
copy "fredhutch.mountainducklicense" %APPDATA%\Cyberduck\
mkdir %APPDATA%\Cyberduck\Profiles\
copy "OpenStack Swift Auth v2.0 (SwiftStack HTTPS).cyberduckprofile" %APPDATA%\Cyberduck\Profiles\
"Mountain Duck Installer-1.5.7.4825.exe" /install /passive
c:
cd "C:\Program Files (x86)\Mountain Duck\"
start "" /D "C:\Program Files (x86)\Mountain Duck" "C:\Program Files (x86)\Mountain Duck\Mountain Duck.exe"
rem msiexec /i "Mountain Duck Installer-1.5.4.4763.msi" /passive /norestart

