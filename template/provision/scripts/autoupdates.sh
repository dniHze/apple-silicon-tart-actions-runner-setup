#!/usr/bin/env bash
set -e
set -o pipefail

sudo softwareupdate --schedule off
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0
defaults write com.apple.commerce AutoUpdate -bool false
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
