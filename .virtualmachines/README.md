# Building Boxes for virtual machines

As primary use case of Vagrant, the boxes are generally for running virtual machines on your local development environment. \
(such as Oracle VirtualBox, VMware Fusion/Workstations, Linux KVM, or Hyper-V)

Since almost all of CI solutions has not supported nested virtualization, currently we could not run these host-based hypervisor on CI runners. \
For building virtual machine based Vagrant boxes, it will be required to run `packer` commands on your local environment.

## Prerequisites
For building boxes with Packer's plugins, like `builder/vmware-iso` or `builder/virtualbox-iso`, \
Packer will expect to be installed Vagrant providers on which `packer build` will be invoked, for starting VMs to build machine images.

In this repository, we have Packer templetes to build boxes for:
- [Oracle VirtualBox](https://www.virtualbox.org)
- [VMware Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)

### Install VirtualBox

```shell
# Install virtualbox via brew
$ brew install --cask virtualbox

% vboxmanage -v
7.1.8r168469

# Install extension packs
$ wget -q https://download.virtualbox.org/virtualbox/7.0.26/Oracle_VM_VirtualBox_Extension_Pack-7.0.26-168464.vbox-extpack
$ echo 'y\n' | sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.26-168464.vbox-extpack
```

### Install Fusion
As we require to sign up Broadcom profile for installing VMware Fusion on your macOS platform, \
please be sure to confirm that you can login to [Broadcom Suppot portal](https://access.broadcom.com/default/ui/v1/signin/) with My Broadcom account.

Once you can download the installer of Fusion, you can proceed as general .dmg package installation.

```shell
$ hdiutil attach ./VMware-Fusion-13.6.2-24409261_universal.dmg
$ sudo cp -R /Volumes/VMware\ Fusion/VMware\ Fusion.app /Applications
```

<!-- *** -->
## Build boxes with Packer
Once you have installed Vagrant providers above, you can build boxes with `packer build` commands. \
This will invoke starting up virtual machines on your providers (like Fusion or VirtualBox).

Before building Boxes, since we have `post-processor/vagrant-registry` to push Boxes on HCP Vagrant Registry, \
we have to create key of Vagrant service-principle for this, and export its credentials. \
Please refer [the documents](https://developer.hashicorp.com/hcp/docs/hcp/iam/service-principal/key) for more details.

```shell
$ export VAGRANT_HCP_CLIENT_ID='***'
$ export VAGRANT_HCP_CLIENT_SECRET='***'
```

For building Vagrant Boxes:

```shell
# For example, building box of apline virtual machine running on Fusion
$ cd ./alpine
$ packer init .
$ PACKER_LOG=1 packer build -only=vmware-iso.alpine_arm64 .

# In case you will run builds for VirtualBox:
$ PACKER_LOG=1 packer build -only=virtualbox-iso.alpine_arm64 .
```

If your builds will be successfully completed, you can confirm the following message in logs:

```shell
% PACKER_LOG=1 packer build -only virtualbox-iso.alpine_arm64 .
# ...

Build 'virtualbox-iso.alpine_arm64' finished after 3 minutes 4 seconds.
==> Wait completed after 3 minutes 4 seconds
==> Builds finished. The artifacts of successful builds are:
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact-count []string{"2"}

==> Wait completed after 3 minutes 4 seconds

==> Builds finished. The artifacts of successful builds are:
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "builder-id", "mitchellh.post-processor.vagrant"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "id", "virtualbox"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "string", "'virtualbox' provider box: alpine_arm64.vbox.box"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "files-count", "1"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "file", "0", "alpine_arm64.vbox.box"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"0", "end"}
--> virtualbox-iso.alpine_arm64: 'virtualbox' provider box: alpine_arm64.vbox.box
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"1", "builder-id", "hashicorp.post-processor.vagrant-registry"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"1", "id", ""}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"1", "string", "'virtualbox': hwakabh/alpine"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"1", "files-count", "0"}
2025/05/05 01:02:40 machine readable: virtualbox-iso.alpine_arm64,artifact []string{"1", "end"}
--> virtualbox-iso.alpine_arm64: 'virtualbox': hwakabh/alpine
2025/05/05 01:02:40 [INFO] (telemetry) Finalizing.
2025/05/05 01:02:41 waiting for all plugin processes to complete...
2025/05/05 01:02:41 /usr/local/bin/packer: plugin process exited
2025/05/05 01:02:41 /Users/hwakabh/.config/packer/plugins/github.com/hashicorp/virtualbox/packer-plugin-virtualbox_v1.1.1_x5.0_darwin_arm64: plugin process exited
2025/05/05 01:02:41 /usr/local/bin/packer: plugin process exited
2025/05/05 01:02:41 /usr/local/bin/packer: plugin process exited
2025/05/05 01:02:41 /usr/local/bin/packer: plugin process exited
2025/05/05 01:02:41 /Users/hwakabh/.config/packer/plugins/github.com/hashicorp/vagrant/packer-plugin-vagrant_v1.1.5_x5.0_darwin_arm64: plugin process exited
2025/05/05 01:02:41 /Users/hwakabh/.config/packer/plugins/github.com/hashicorp/vagrant/packer-plugin-vagrant_v1.1.5_x5.0_darwin_arm64: plugin process exited
```

<!-- *** -->
## Using Boxes
As `post-processor/vagrant-registry` will publish the boxes to [HCP Vagrant Registry](https://developer.hashicorp.com/hcp/docs/vagrant), which are built by Packer, you can easily download them on your local environment. \
Please be sure that you need to sign up [HashiCorp Cloud Platform](https://www.hashicorp.com/en/cloud) first, for start using HCP Vagrant Registry.

By default the visibility of these boxes are set as Public, you can use like:

```shell
% vagrant init hwakabh/alpine --box-version 0.3.1 --minimal
% vagrant up
```
