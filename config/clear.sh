#!/bin/bash
echo "Clear..."
rm -f ~/.local/share/icons/application-x-ugene-ext.png
rm -f ~/.local/share/pixmaps/ugene.png
rm -f ~/.local/share/mime/packages/*ugene*
rm -f ~/.local/share/mime/application/*ugene*
rm -f ~/.local/share/applications/ugene.desktop
rm -f ~/.local/share/applications/defaults.list
update-mime-database ~/.local/share/mime/
