# Setup macOS GitHub Actions Runners with [Tart](https://github.com/cirruslabs/tart)

Work in progress. Set of scripts and images to automate VMs with Actions Runners on Apple Silicon devices.

## Pulling the image

```bash
# Making sure tart is installed
brew install tart
# Cloning VM
tart clone ghcr.io/dnihze/monterey-xcode::14.0.1 monterey-runner
# By default, VM uses 6 Cores and 12 GB of RAM. You can rescale it like this
tart set monterey-runner --cpu 4 --memory 8192
# Starting VM
tart run monterey-runner
```

## Configuring actions runner manually

```bash
# run VM in background
tart run --no-graphics monterey-runner &
# Defautlts ssh password is "admin". Also, give a couple of seconds for VM to boot
ssh admin@$(tart ip monterey-runner)
# Configure actions-runner
cd actions-runner
# For all options use ./config.sh --help
./config.sh --unaunattended --url <repo_url> --token <token> --name runner-$(uuidgen)
# Configure runner to start as a service
./svc.sh install && ./svc.sh start
```

## Pre-installed tooling

```text
* actions-runner
* aria2
* bundler
* curl
* ca-certificates
* cocoapods
* fastlane
* gh
* git-lfs
* gnupg
* hub
* ideviceinstaller
* imagemagick
* ios-deploy
* jq
* libimobiledevice
* Rosetta 2
* swiftformat
* unzip
* wget
* Xcode
* xcode-install
* xcodes
* xcparse
* xcpretty
* yq
* zip
```