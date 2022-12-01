#!/usr/bin/env bash
set -e
set -o pipefail

echo Installing Rosetta 2
sudo softwareupdate --install-rosetta --agree-to-license
