#!/usr/bin/env bash
set -e
set -o pipefail

echo Installing tools
brew install fastlane \
             ideviceinstaller \
             ios-deploy \
             libimobiledevice \
             rbenv \
             ruby

echo Checking ruby version
ruby --version

echo Updating gems
sudo gem update

echo Installing new gems
sudo gem install cocoapods bundler xcode-install xcpretty
sudo gem uninstall --ignore-dependencies ffi && sudo gem install ffi -- --enable-libffi-alloc