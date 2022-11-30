packer {
  required_plugins {
    tart = {
      version = ">= 0.5.1"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "xcode_version" {
  type =  string
  default = "14.0.1"
}

variable "actions_version" {
  type =  string
  default = "2.299.1"
}

variable "ios_latest" {
  type =  string
  default = "16.0"
}

variable "os_version" {
  type =  string
  default = "monterey"
}

source "tart-cli" "tart" {
  vm_base_name = "ghcr.io/cirruslabs/macos-${var.os_version}-base:latest"
  vm_name      = "${var.os_version}-xcode:${var.xcode_version}"
  cpu_count    = 6
  memory_gb    = 12
  disk_size_gb = 80
  ssh_password = "admin"
  ssh_username = "admin"
  ssh_timeout  = "120s"
}

build {
  sources = ["source.tart-cli.tart"]

  # Install core packages
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew --version",
      "brew update",
      "brew upgrade",
      "brew install aria2 curl ca-certificates gh gnupg imagemagick jq swiftformat unzip wget yq zip",
      "sudo softwareupdate --install-rosetta --agree-to-license",
    ]
  }
  # Set timezone to London
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "sudo systemsetup -settimezone Europe/London",
    ]
  }
  # Disable autoupdates
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "sudo softwareupdate --schedule off",
      "defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0",
      "defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0",
      "defaults write com.apple.commerce AutoUpdate -bool false",
      "defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false",
    ]
  }
  # Install openssl
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install openssl",
      "brew install \"openssl@1.1\"",
    ]
  }
  # Install git and extensions
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "echo Installing git",
      "brew install git",
      "git config --global --add safe.directory \"*\"",
      "echo Installing git-lfs",
      "brew install git-lfs",
      "git lfs install",
      "sudo git lfs install --system",
      "echo Installing hub",
      "brew install hub",
      "echo Disable all the Git help messages...",
      "git config --global advice.pushUpdateRejected false",
      "git config --global advice.pushNonFFCurrent false",
      "git config --global advice.pushNonFFMatching false",
      "git config --global advice.pushAlreadyExists false",
      "git config --global advice.pushFetchFirst false",
      "git config --global advice.pushNeedsForce false",
      "git config --global advice.statusHints false",
      "git config --global advice.statusUoption false",
      "git config --global advice.commitBeforeMerge false",
      "git config --global advice.resolveConflict false",
      "git config --global advice.implicitIdentity false",
      "git config --global advice.detachedHead false",
      "git config --global advice.amWorkDir false",
      "git config --global advice.rmHints false",
    ]
  }
  # Add xcodes
  provisioner "shell" {
    inline = [
      "echo 'export PATH=/usr/local/bin/:$PATH' >> ~/.zprofile",
      "source ~/.zprofile",
      "wget --quiet https://github.com/RobotsAndPencils/xcodes/releases/latest/download/xcodes.zip",
      "unzip xcodes.zip",
      "rm xcodes.zip",
      "chmod +x xcodes",
      "sudo mkdir -p /usr/local/bin/",
      "sudo mv xcodes /usr/local/bin/xcodes",
      "xcodes version",
    ]
  }
  # Copy Xcode from files directory
  provisioner "file" {
    source = "files/Xcode_${var.xcode_version}.xip"
    destination = "$HOME/Xcode_${var.xcode_version}.xip"
  }
  # Install Xcode
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "xcodes install ${var.xcode_version} --experimental-unxip --path $HOME/Xcode_${var.xcode_version}.xip",
      "sudo rm -rf ~/.Trash/*",
      "xcodes select ${var.xcode_version}",
      "sudo xcodebuild -runFirstLaunch",
    ]
  }
  # Install gems
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install libimobiledevice ideviceinstaller ios-deploy fastlane",
      "sudo gem update",
      "sudo gem install cocoapods bundler xcode-install xcpretty",
      "sudo gem uninstall --ignore-dependencies ffi && sudo gem install ffi -- --enable-libffi-alloc"
    ]
  }
  # Install xcparse
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install chargepoint/xcparse/xcparse",
    ]
  }
  # Create simulators
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "xcrun simctl create \"iPhone 11\" com.apple.CoreSimulator.SimDeviceType.iPhone-11 iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 11 Pro\" com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 11 Pro Max\" com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro-Max iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 12 mini\" com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 12\" com.apple.CoreSimulator.SimDeviceType.iPhone-12 iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 12 Pro\" com.apple.CoreSimulator.SimDeviceType.iPhone-12-Pro iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 12 Pro Max\" com.apple.CoreSimulator.SimDeviceType.iPhone-12-Pro-Max iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 13 Pro\" com.apple.CoreSimulator.SimDeviceType.iPhone-13-Pro iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 13 Pro Max\" com.apple.CoreSimulator.SimDeviceType.iPhone-13-Pro-Max iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 13 mini\" com.apple.CoreSimulator.SimDeviceType.iPhone-13-mini iOS${var.ios_latest}",
      "xcrun simctl create \"iPhone 13\" com.apple.CoreSimulator.SimDeviceType.iPhone-13 iOS${var.ios_latest}",
    ]
  }
  # Install latest GitHub Actions
  provisioner "shell" {
    inline = [
      "cd $HOME",
      "rm -r actions-runner",
      "mkdir actions-runner && cd actions-runner",
      "curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${var.actions_version}/actions-runner-osx-arm64-${var.actions_version}.tar.gz",
      "tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz",
    ]
  }
  # Make sure brew is in a good shape
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew doctor",
    ]
  }
}