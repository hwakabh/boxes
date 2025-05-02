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
    "source.vmware-iso.alpine_arm64"
  ]

  provisioner "file" {
    source = "../.share/vagrant.pub"
    destination = "/tmp/vagrant.pub"
  }
  provisioner "shell" {
    script = "./scripts/setup.sh"
  }

  provisioner "file" {
    source = "./scripts/answerfile"
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
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant
      provider_override = "vmware"
      output = "alpine_arm64.fusion.box"
    }
    # post-processor "vagrant-registry" {
    #   // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
    #   client_id = "from env"
    #   client_secret = "from env"
    #   box_tag = "hwakabh/alpine"
    #   architecture = "arm64"
    #   version = lookup(jsondecode(file("../.release-please-manifest.json")), "alpine", "0.0.1")

    #   keep_input_artifact = false
    # }
  }
}
