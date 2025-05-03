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
    "source.docker.alpine_arm64"
  ]

  provisioner "file" {
    source      = "../.share/vagrant.pub"
    destination = "/tmp/vagrant.pub"
    only = ["vmware-iso.apline_arm64"]
  }
  provisioner "shell" {
    script = "./scripts/setup.sh"
    only = ["vmware-iso.apline_arm64"]
  }

  provisioner "file" {
    source      = "./scripts/answerfile"
    destination = "/tmp/answerfile"
    only = ["vmware-iso.apline_arm64"]
  }
  provisioner "shell" {
    inline = [
      // "password" for updating root password, and "y" for installations to install
      "echo 'password\npassword\ny\n' | setup-alpine -f /tmp/answerfile",
      "reboot"
    ]
    only = ["vmware-iso.apline_arm64"]
  }

  post-processor "docker-tag" {
    // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag
    repository = "hello-packer"
    tags       = ["latest"]
    only = ["docker.alpine_arm64"]
  }


  post-processors {
    post-processor "vagrant" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant
      override = {
        fusion_alpine_arm64 = {
          provider_override = "vmware"
          output = "alpine_arm64.fusion.box"
        }
        docker_alpine_arm64 = {
          provider_override = "docker"
          output = "alpine_arm64.docker.box"
        }
      }
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
