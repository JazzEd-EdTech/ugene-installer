# ugene-installer
Installer for UGENE based on Qt installer framework

###Preparing packages data
Set up environment:
```
UGENE_PATH
EXT_TOOLS_PATH
CISTROME_PATH
RSCRIPT_PATH
```
Linux, Mac OS X:
```
./prepare.py clean
./prepare.py
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
