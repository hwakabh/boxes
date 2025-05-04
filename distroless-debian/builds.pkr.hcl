packer {
  required_plugins {
    // builder/docker, post-processor/docker-import, post-processor/docker-push
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
  sources = [
    "source.docker.distroless-debian_arm64"
  ]

  post-processors {
    post-processor "docker-import" {
      repository = "ghcr.io/hwakabh/distroless-debian"
      tag        = "box-arm64"
    }
    post-processor "docker-push" {
      login = true
      login_username = "hwakabh"
      login_password = var.GHCR_TOKEN
    }
  }

  post-processors {
    post-processor "docker-import" {
      repository = "ghcr.io/hwakabh/distroless-debian"
      tag        = "box-arm64"
    }
    post-processor "vagrant" {
      provider_override    = "docker"
      vagrantfile_template = "./Vagrantfile.pkrtpl"
      output               = "distroless_arm64.docker.box"
    }
    post-processor "vagrant-registry" {
      client_id     = var.VAGRANT_HCP_CLIENT_ID
      client_secret = var.VAGRANT_HCP_CLIENT_SECRET
      box_tag       = "hwakabh/distroless-debian"
      architecture  = "arm64"
      version       = lookup(jsondecode(file("../.release-please-manifest.json")), "distroless-debian", "0.0.1")
    }
  }

  // required HCP_PROJECT_ID, HCP_CLIENT_ID & HCP_CLIENT_SECRET
  hcp_packer_registry {
    bucket_name = "distroless-debian"
    description = "metadata of builds with distroless-debian by Packer"
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
