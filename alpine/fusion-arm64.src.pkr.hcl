source "vmware-iso" "alpine_arm64" {
  name = "fusion_alpine_arm64"

  // https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso
  // OS source image
  iso_url      = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-standard-3.20.6-aarch64.iso"
  iso_checksum = "file:https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-standard-3.20.6-aarch64.iso.sha512"

  // virtual hardware configurations
  guest_os_type = "arm-other-64"
  version       = "21"
  vmx_data = {
    "firmware"         = "efi"
    "architecture"     = "arm-other-64"
    "usb_xhci.present" = "TRUE" # for Packer to type text
  }

  // VM Specs
  vm_name              = "alpine-arm64"
  cpus                 = 1
  memory               = 2048
  network_adapter_type = "vmxnet3"
  disk_adapter_type    = "sata"
  disk_size            = 4000
  cdrom_adapter_type   = "sata"

  // After VM starting
  headless  = true
  boot_wait = "15s"
  boot_command = [
    "root<enter><wait>",
    "setup-interfaces<enter><wait><enter><wait><enter><wait><enter><wait>",
    "/etc/init.d/networking start<enter><wait5>",
    "setup-sshd -c openssh<enter><wait>",
    "echo 'root:root' | chpasswd<enter><wait>",
    "echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config<enter><wait>",
    "/etc/init.d/sshd restart<enter><wait5>",
    # "adduser -D vagrant<enter><wait>",
    # "echo 'vagrant:vagrant' | chpasswd<enter><wait>"
  ]

  // Credentials used by Packer for initial setup before OS installs
  ssh_username = "root"
  ssh_password = "root"
  ssh_timeout  = "180s"

  // Once SSH connection from Packer established, provisioner will take over the setup-alpine

  // all tasks by provisioner completed, the shutdown will be invoked for templating
  shutdown_command = "poweroff"
}
