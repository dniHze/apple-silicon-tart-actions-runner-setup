#!/usr/bin/env bash
set -e
set -o pipefail

echo Setting timezone to Europe/London
sudo systemsetup -settimezone Europe/London

echo Checking timezone
sudo systemsetup -gettimezone
