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
    "source.docker.distroless-debian_arm64"
  ]

  post-processors {
    post-processor "docker-tag" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag
      repository = "ghcr.io/hwakabh/distroless-debian"
      tags       = ["box-arm64"]
    }
    # post-processor "docker-import" {
    #   repository = "ghcr.io/hwakabh/distroless-debian"
    #   tag = "box-arm64"
    # }
    # post-processor "docker-push" {
    #   // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-push
    #   login          = true
    #   login_server   = "ghcr.io"
    #   login_username = "hwakabh"
    #   login_password = var.GHCR_TOKEN
    # }
  }

  post-processors {
    post-processor "vagrant" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant
      provider_override = "docker"
      output            = "distroless_arm64.docker.box"
    }
    post-processor "vagrant-registry" {
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/distroless-debian"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "distroless-debian", "0.0.1")
    }
  }

  # // required HCP_PROJECT_ID, HCP_CLIENT_ID & HCP_CLIENT_SECRET
  # // https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-artifact-metadata
  # hcp_packer_registry {
  #   bucket_name = "distroless-debian"
  #   description = "metadata of builds with distroless-debian by Packer"
  #   bucket_labels = {
  #     "owner"    = "hwakabh"
  #     "build_on" = "github-action"
  #   }
  #   build_labels = {
  #     "build-time"   = timestamp()
  #     "build-source" = basename(path.cwd)
  #   }
  # }
}
