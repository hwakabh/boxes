packer {
  required_version = ">= 1.7.0"
  required_plugins {
    // builder/docker, post-processor/docker-tag
    docker = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/docker"
    }
    // builder/vmware-iso
    vmware = {
      version = "~> 1"
      source  = "github.com/hashicorp/vmware"
    }
    // post-processor/vagrant, post-processor/vagrant-registry
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  sources = [
    "source.vmware-iso.alpine_arm64",
    # "source.virtualbox.alpine_arm64",
    "source.docker.alpine_arm64"
  ]

  // For Fusion Boxes
  provisioner "file" {
    source      = "../.share/vagrant.pub"
    destination = "/tmp/vagrant.pub"
    only        = ["vmware-iso.alpine_arm64"]
  }
  provisioner "shell" {
    script = "./scripts/setup.sh"
    only   = ["vmware-iso.alpine_arm64"]
  }

  provisioner "file" {
    source      = "./scripts/answerfile"
    destination = "/tmp/answerfile"
    only        = ["vmware-iso.alpine_arm64"]
  }
  provisioner "shell" {
    inline = [
      // "password" for updating root password, and "y" for installations to install
      "echo 'password\npassword\ny\n' | setup-alpine -f /tmp/answerfile",
      "reboot"
    ]
    only = ["vmware-iso.alpine_arm64"]
  }

  post-processors {
    post-processor "vagrant" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant
      provider_override = "vmware"
      output            = "alpine_arm64.fusion.box"
      only              = ["vmware-iso.alpine_arm64"]
    }
    post-processor "vagrant-registry" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

  // For Docker Boxes
  post-processors {
    # post-processor "docker-tag" {
    #   // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag
    #   repository = "ghcr.io/hwakabh/alpine"
    #   tags       = ["box-arm64"]
    #   only       = ["docker.alpine_arm64"]
    # }
    post-processor "docker-import" {
      repository = "ghcr.io/hwakabh/alpine"
      tag = "box-arm64"
    }
    post-processor "docker-push" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-push
      login          = true
      login_server   = "ghcr.io"
      login_username = "hwakabh"
      login_password = var.GHCR_TOKEN
      only           = ["docker.alpine_arm64"]
    }
  }

  post-processors {
    // post-proceesor.vagrant.override can be used only in JSON formats,
    // so that we need to add duplicated chains
    // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant#provider-specific-overrides
    post-processor "vagrant" {
      provider_override = "docker"
      output            = "alpine_arm64.docker.box"
      only              = ["docker.alpine_arm64"]
    }
    post-processor "vagrant-registry" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/alpine"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")
    }
  }

  // required HCP_PROJECT_ID, HCP_CLIENT_ID & HCP_CLIENT_SECRET
  // https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-artifact-metadata
  hcp_packer_registry {
    bucket_name = "alpine"
    description = "metadata of builds with alpine by Packer"
    bucket_labels = {
      "owner"    = "hwakabh"
      "build_on" = "github-action"
    }
    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
}
