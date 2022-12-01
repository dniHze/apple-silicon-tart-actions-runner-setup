#!/usr/bin/env bash
set -e
set -o pipefail

brew --version
brew update
brew upgrade
brew install aria2 \
             curl \
             ca-certificates \
             gh \
             gnupg \
             imagemagick \
             jq \
             swiftformat \
             unzip \
             wget \
             yq \
             zip
