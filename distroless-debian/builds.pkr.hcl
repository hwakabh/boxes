packer {
  required_plugins {
    // builder/docker
    docker = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/docker"
    }
    // post-processor/vagrant, post-processor/vagrant-registry
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/builder/docker
  sources = [
    "source.docker.distroless-debian12_arm64"
  ]

  post-processor "docker-tag" {
    // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag
    repository = "ghcr.io/hwakabh/distroless"
    tags       = ["local"]
  }

  post-processors {
    post-processor "vagrant" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant
      provider_override = "docker"
      output            = "distroless_arm64.docker.box"
    }

    # post-processor "vagrant-registry" {
    #   // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
    #   client_id = "from env"
    #   client_secret = "from env"
    #   box_tag = "hwakabh/distroless-debian"
    #   architecture = "arm64"
    #   version = lookup(jsondecode(file("../.release-please-manifest.json")), "distroless-debian", "0.0.1")

    #   keep_input_artifact = false
    # }

  }
}
