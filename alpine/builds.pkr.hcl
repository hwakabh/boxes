packer {
  required_version = ">= 1.7.0"
  required_plugins {
    // builder/docker, post-processor/docker-import, post-processor/docker-push
    docker = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/docker"
    }
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
    "source.docker.alpine_arm64"
  ]

  post-processors {
    post-processor "docker-import" {
      repository = "ghcr.io/hwakabh/box/alpine_arm64"
      tag        = "latest"
    }
    post-processor "docker-push" {
      login          = true
      login_server   = "ghcr.io"
      login_username = "hwakabh"
      login_password = var.GHCR_TOKEN
    }
  }

  post-processors {
    // for avoiding hard-coded image digest in Vagrantfile of boxes, we need to import tar from builder/docker
    // post-proceesor.vagrant.override can be used only in JSON formats,
    // so that we need to add duplicated chains
    // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant#provider-specific-overrides
    post-processor "docker-import" {
      repository = "ghcr.io/hwakabh/box/alpine_arm64"
      tag        = "latest"
    }
    post-processor "vagrant" {
      provider_override    = "docker"
      vagrantfile_template = "./Vagrantfile.pkrtpl"
      output               = "alpine_arm64.docker.box"
    }
    post-processor "vagrant-registry" {
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }
}

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
      only          = ["vmware-iso.alpine_arm64"]
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["vmware-iso.alpine_amd64"]
      provider_override = "vmware"
      output            = "alpine_amd64.fusion.box"
    }
    post-processor "vagrant-registry" {
      only          = ["vmware-iso.alpine_amd64"]
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "amd64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["virtualbox-iso.alpine_arm64"]
      provider_override = "virtualbox"
      output            = "alpine_arm64.vbox.box"
    }
    post-processor "vagrant-registry" {
      only          = ["virtualbox-iso.alpine_arm64"]
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

  post-processors {
    post-processor "vagrant" {
      only              = ["virtualbox-iso.alpine_amd64"]
      provider_override = "virtualbox"
      output            = "alpine_amd64.vbox.box"
    }
    post-processor "vagrant-registry" {
      only          = ["virtualbox-iso.alpine_amd64"]
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "amd64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

}
