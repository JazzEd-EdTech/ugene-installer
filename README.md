# ugene-installer
Installer for UGENE based on Qt installer framework

###Preparing packages data
Set up environment:
```
UGENE_i386_PATH
UGENE_x86_64_PATH
EXT_TOOLS_i386_PATH
EXT_TOOLS_x86_64_PATH
CISTROME_PATH
RSCRIPT_PATH
```
Linux:
```
./prepare.sh clean
./prepare.sh
```
Mac OS X:
```
./prepare-mac.sh clean
./prepare-mac.sh
```

###Create installer
Windows:
```
binarycreator.exe -c config/config_win.xml -p packages installer -n
```
Linux:
```
binarycreator -c config/config_linux.xml -p packages installer -n
```
Mac OS X:
```
binarycreator -c config/config_mac.xml -p packages installer -n
```
