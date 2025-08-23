# boxes
Vagrant Box generations with Packer

## Local Setup
Since Packer is generally expected to run on your local machine, you have to install `packer` commands first. \
Please refer the HashiCorp's [official documents](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) for its installation, but you can easily download binaries from [HashiCorp rpeository](https://releases.hashicorp.com/packer/).

```shell
# Clone this repository
% git clone git@github.com:hwakabh/boxes.git

# Navigate to directory of your prefered OS
% cd distroless-debian

# Install Packer plugins required for each build
% packer init .
% packer plugins installed

# Configure required variables
% export GHCR_TOKEN='***'

% export VAGRANT_HCP_CLIENT_ID='***'
% export VAGRANT_HCP_CLIENT_SECRET='***'

% export HCP_PROJECT_ID='***'
% export HCP_CLIENT_ID='***'
% export HCP_CLIENT_SECRET='***'

# Build Packer sources
% packer build .
```

<!-- *** -->
## Configurations
Regardless of what target OS you choose, all the form-factors of artifacts in this repository are Boxes or Container images.

The workflow of building container images (`builder/docker`) are:
1. `source/docker` for pulling existing container images and export with tar format
2. `post-processor/docker-import` for building container images from tar file
3. `post-processor/docker-push` for pushing images to registry, ghcr.io.

The workflow of build Vagrant boxes (`builder/vagrant`) for docker provider are:
1. `source/docker` for pulling existing container images and export with tar format
2. `post-processor/docker-import` for building container images from tar file
3. `post-processor/vagrant` for converting from Docker container image to Vagrant box, in order to run containers as box
4. `post-processor/vagrant-registry` for pushing boxes to HCP Vagrant Registry
5. then Packer will store artifact metadata to HCP Packer Registry, with the configurations of `hcp_packer_registry` block in each build

Since Vagrant has supported building container images by using built-in [Docker provider](https://developer.hashicorp.com/vagrant/docs/providers/docker), it seems to be a bit confusing, but this will leverage to use container and virtual machines at the same time with a single Vargrantfile.

Please also refer [the documents](.virtualmachines/README.md) about Packer's general build process of virtual machine images as Vagrant boxes.

<!-- *** -->
## Supported OS and artifacts
As Packer can build various types of artifacts, there is multiple image outputs from a single OS image, which you navigated before running `packer build` commands. \
Currently we have tested the following OS flavors, and implemented with the workflows of GitHub Actions.

| OS Name | Container Images | Box(docker) | Box(vmware_desktop) | Box(virtualbox) |
| --- | --- | --- | --- | --- |
| alpine (arm64) | [o](./alpine/docker-arm64.src.pkr.hcl) | x | [o](.virtualmachines/alpine/fusion-arm64.src.pkr.hcl) | [o](.virtualmachines/alpine/vbox-arm64.src.pkr.hcl) |
| alpine (amd64) | x | x | [o](.virtualmachines/alpine/fusion-amd64.src.pkr.hcl) (local-only) | [o](.virtualmachines/alpine/vbox-amd64.src.pkr.hcl) (local-only) |
| distroless-debian (arm64) | [o](./distroless-debian/docker-arm64.src.pkr.hcl) | x | x | x |
| distroless-debian (amd64) | x | x | x | x |

Regarding Boxes as artifacts, since Vagrant could be accepted to run on several platforms, there are multiple boxes for providers. \
Generally we expect to use VMware Fusion with vmware_desktop Vagrant provider, whereas the vmware_desktop provider is also supporting VMware Workstation. \
Please refer the provider documents about each Box.
- [docker provider](https://developer.hashicorp.com/vagrant/docs/providers/docker)
- [vmware_desktop provider](https://developer.hashicorp.com/vagrant/docs/providers/vmware)
- [virtualbox provider](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox)

For building arm64 docker images, we have used `ubuntu-24.04-arm` GitHub runner on implemented workflows. \
Please visit [GitHub's document](https://docs.github.com/en/actions/reference/runners/github-hosted-runners) if you would like to change runners for several CPU architectures or platforms.
