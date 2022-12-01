packer {
  required_plugins {
    tart = {
      version = ">= 0.5.1"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "gha_version" {
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

variable "xcode_version" {
  type =  string
  default = "14.0.1"
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

  provisioner "shell" {
    scripts = [
      "provision/scripts/autoupdates.sh",
      "provision/scripts/timezones.sh",
      "provision/scripts/rosetta.sh",
      "provision/scripts/brew.sh",
      "provision/scripts/git.sh",
      "provision/scripts/openssl.sh",
      "provision/scripts/ruby.sh",
      "provision/scripts/xcodes.sh",
    ]
    execute_command = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
  }
  provisioner "file" {
    source = "provision/files/Xcode_${var.xcode_version}.xip"
    destination = "$HOME/Xcode_${var.xcode_version}.xip"
  }
  provisioner "shell" {
    scripts = [
      "provision/scripts/install_xcode.sh",
      "provision/scripts/xcparse.sh",
      "provision/scripts/simulators.sh",
    ]
    environment_vars = [
      "IOS_LATEST=${var.ios_latest}",
      "XCODE_VERSION=${var.xcode_version}",
    ]
    execute_command = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
  }
  provisioner "shell" {
    script = "provision/scripts/gha.sh"
    environment_vars = [
      "ACTIONS_VERSION=${var.gha_version}",
    ]
    execute_command = "chmod +x {{ .Path }}; source $HOME/.zprofile; {{ .Vars }} {{ .Path }}"
  }
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew doctor",
    ]
  }
}