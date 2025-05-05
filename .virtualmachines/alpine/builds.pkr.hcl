packer {
  required_version = ">= 1.7.0"
  required_plugins {
    // builder/vmware-iso
    vmware = {
      version = "~> 1"
      source  = "github.com/hashicorp/vmware"
    }
    // builder/virtualbox-iso
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    // post-processor/vagrant, post-processor/vagrant-registry
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

// since we use multiple-builds, we could not use `hcp_packer_registry` block
build {
  sources = [
    "source.vmware-iso.alpine_arm64",
    "source.vmware-iso.alpine_amd64",
    "source.virtualbox-iso.alpine_arm64",
    "source.virtualbox-iso.alpine_amd64",
  ]

  provisioner "file" {
    source      = "../.share/vagrant.pub"
    destination = "/tmp/vagrant.pub"
  }
  provisioner "shell" {
    script = "./scripts/setup.sh"
  }

  provisioner "file" {
    source      = "./scripts/answerfile"
    destination = "/tmp/answerfile"
  }
  provisioner "shell" {
    inline = [
      // "password" for updating root password, and "y" for installations to install
      "echo 'password\npassword\ny\n' | setup-alpine -f /tmp/answerfile",
      "reboot"
    ]
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["vmware-iso.alpine_arm64"]
      provider_override = "vmware"
      output            = "alpine_arm64.fusion.box"
    }
    post-processor "vagrant-registry" {
      only                = ["vmware-iso.alpine_arm64"]
      client_id           = var.VAGRANT_HCP_CLIENT_ID
      client_secret       = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag             = join("/", [var.VAGRANT_REGISTRY_NAME, "alpine"])
      architecture        = "arm64"
      version             = formatdate("YYYYMMDD-hhmmss", timestamp())
      keep_input_artifact = false
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["vmware-iso.alpine_amd64"]
      provider_override = "vmware"
      output            = "alpine_amd64.fusion.box"
    }
    post-processor "vagrant-registry" {
      only                = ["vmware-iso.alpine_amd64"]
      client_id           = var.VAGRANT_HCP_CLIENT_ID
      client_secret       = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag             = join("/", [var.VAGRANT_REGISTRY_NAME, "alpine"])
      architecture        = "amd64"
      version             = formatdate("YYYYMMDD-hhmmss", timestamp())
      keep_input_artifact = false
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["virtualbox-iso.alpine_arm64"]
      provider_override = "virtualbox"
      output            = "alpine_arm64.vbox.box"
    }
    post-processor "vagrant-registry" {
      only                = ["virtualbox-iso.alpine_arm64"]
      client_id           = var.VAGRANT_HCP_CLIENT_ID
      client_secret       = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag             = join("/", [var.VAGRANT_REGISTRY_NAME, "alpine"])
      architecture        = "arm64"
      version             = formatdate("YYYYMMDD-hhmmss", timestamp())
      keep_input_artifact = false
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["virtualbox-iso.alpine_amd64"]
      provider_override = "virtualbox"
      output            = "alpine_amd64.vbox.box"
    }
    post-processor "vagrant-registry" {
      only                = ["virtualbox-iso.alpine_amd64"]
      client_id           = var.VAGRANT_HCP_CLIENT_ID
      client_secret       = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag             = join("/", [var.VAGRANT_REGISTRY_NAME, "alpine"])
      architecture        = "amd64"
      version             = formatdate("YYYYMMDD-hhmmss", timestamp())
      keep_input_artifact = false
    }
  }

}
