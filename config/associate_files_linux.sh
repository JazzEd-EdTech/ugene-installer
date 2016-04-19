#!/bin/bash

IS_ROOT="1"
LOG_FILE=associating.log

UGENE_BIN_PATH="$1"

#echo 'Extracting the icons to "~/.local/share/icons":'  | tee -a $LOG_FILE
if [ -e ~/.local/share/icons ]; then
    tar -xvzf icons.tar.gz -C ~/.local/share/icons 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/icons
    tar -xvzf icons.tar.gz -C ~/.local/share/icons 2>&1 | tee -a $LOG_FILE
fi
if [ -e ~/.local/share/pixmaps ]; then
    cp -f ugene.png ~/.local/share/pixmaps 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/pixmaps
    cp -f ugene.png ~/.local/share/pixmaps 2>&1 | tee -a $LOG_FILE
fi

#echo 'Creating the MIME types (copy application-x-ugene.xml to ~/.local/share/mime/packages):' | tee -a $LOG_FILE
if [ -e ~/.local/share/mime/packages/ ]; then
    cp -f application-x-ugene.xml ~/.local/share/mime/packages/ 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/mime/packages/
    cp -f application-x-ugene.xml ~/.local/share/mime/packages/ 2>&1 | tee -a $LOG_FILE
fi

#echo 'Updating new MIME types.' | tee -a $LOG_FILE
update-mime-database ~/.local/share/mime/ 2>&1 | tee -a $LOG_FILE

#echo 'Adding the MIME types to the ugene.desktop file.' | tee -a $LOG_FILE
if [ -e ~/.local/share/applications/ugene.desktop ]; then
    cp -f ugene.desktop ~/.local/share/applications/
    echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
    echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
else
    if [ -e ~/.local/share/applications/ ]; then
	cp -f ugene.desktop ~/.local/share/applications/
        echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
	echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
    else
        mkdir -p ~/.local/share/applications/
	cp -f ugene.desktop ~/.local/share/applications/
        echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
	echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
    fi
fi

#echo 'Setting UGENE as default application' | tee -a $LOG_FILE
if [ ! -e ~/.local/share/applications/defaults.list ]; then
    touch ~/.local/share/applications/defaults.list
    echo "[Default Applications]" >>~/.local/share/applications/defaults.list
fi
while read format; do
    echo $format"=ugene.desktop" >>~/.local/share/applications/defaults.list
done <format_list

exit 0
