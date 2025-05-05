source "virtualbox-iso" "alpine_amd64" {
  iso_url      = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-standard-3.20.6-x86_64.iso"
  iso_checksum = "file:https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-standard-3.20.6-x86_64.iso.sha512"

  // virtual hardware configurations
  guest_os_type = "Ubuntu"
  firmware      = "efi"

  // VM Specs
  vm_name              = "alpine-amd64"
  cpus                 = 1
  memory               = 1024
  disk_size            = 4096
  hard_drive_interface = "sata"
  iso_interface        = "virtio" # for initial boot
  usb                  = true     # for Packer to type text
  gfx_controller       = "vmsvga" # for fixing VERR_PGM_RAM_CONFLICT
  gfx_vram_size        = 128

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
