#!/bin/bash

osascript <<END_SCRIPT
tell application "Finder" to make alias file to file (posix file "$1") at desktop
END_SCRIPT
