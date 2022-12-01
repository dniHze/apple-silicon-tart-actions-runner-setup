#!/usr/bin/env bash
set -e
set -o pipefail

echo Installing git
brew install git
git config --global --add safe.directory "*"

echo Installing git-lfs
brew install git-lfs
git lfs install
sudo git lfs install --system

echo Installing hub
brew install hub

echo Disable all the Git help messages...
git config --global advice.pushUpdateRejected false
git config --global advice.pushNonFFCurrent false
git config --global advice.pushNonFFMatching false
git config --global advice.pushAlreadyExists false
git config --global advice.pushFetchFirst false
git config --global advice.pushNeedsForce false
git config --global advice.statusHints false
git config --global advice.statusUoption false
git config --global advice.commitBeforeMerge false
git config --global advice.resolveConflict false
git config --global advice.implicitIdentity false
git config --global advice.detachedHead false
git config --global advice.amWorkDir false
git config --global advice.rmHints false
