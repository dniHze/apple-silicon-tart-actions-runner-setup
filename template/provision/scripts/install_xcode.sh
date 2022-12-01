#!/usr/bin/env bash
set -e
set -o pipefail

echo Installing Xcode
xcodes install $XCODE_VERSION --experimental-unxip --path $HOME/Xcode_$XCODE_VERSION.xip
sudo rm -rf ~/.Trash/*

echo Selecting default Xcode
xcodes select $XCODE_VERSION
xcodebuild -version

echo Launch Xcode for the first time
sudo xcodebuild -runFirstLaunch
