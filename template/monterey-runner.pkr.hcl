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

source "tart-cli" "tart" {
  vm_base_name = "ghcr.io/cirruslabs/macos-monterey-base:latest"
  vm_name      = "monterey-xcode:${var.xcode_version}"
  cpu_count    = 6
  memory_gb    = 12
  disk_size_gb = 80
  ssh_password = "admin"
  ssh_username = "admin"
  ssh_timeout  = "120s"
}

build {
  sources = ["source.tart-cli.tart"]

  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew --version",
      "brew update",
      "brew upgrade",
      "brew install curl wget unzip zip ca-certificates",
      "sudo softwareupdate --install-rosetta --agree-to-license"
    ]
  }

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
  provisioner "file" {
    source = "files/Xcode_${var.xcode_version}.xip"
    destination = "$HOME/Xcode_${var.xcode_version}.xip"
  }
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "xcodes install ${var.xcode_version} --experimental-unxip --path $HOME/Xcode_${var.xcode_version}.xip",
      "sudo rm -rf ~/.Trash/*",
      "xcodes select ${var.xcode_version}",
      "sudo xcodebuild -runFirstLaunch",
    ]
  }
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install libimobiledevice ideviceinstaller ios-deploy fastlane",
      "sudo gem update",
      "sudo gem install cocoapods",
      "sudo gem uninstall --ignore-dependencies ffi && sudo gem install ffi -- --enable-libffi-alloc"
    ]
  }
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install chargepoint/xcparse/xcparse",
    ]
  }
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew doctor",
    ]
  }
}