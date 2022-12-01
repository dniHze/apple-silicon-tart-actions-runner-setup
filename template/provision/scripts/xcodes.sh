#!/usr/bin/env bash
set -e
set -o pipefail

echo 'export PATH=/usr/local/bin/:$PATH' >> $HOME/.zprofile
source $HOME/.zprofile

echo Installing xcodes
wget --quiet https://github.com/RobotsAndPencils/xcodes/releases/latest/download/xcodes.zip
unzip xcodes.zip
rm xcodes.zip
chmod +x xcodes
sudo mkdir -p /usr/local/bin/
sudo mv xcodes /usr/local/bin/xcodes
xcodes version
