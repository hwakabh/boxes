source "docker" "distroless-debian_arm64" {
  // https://github.com/GoogleContainerTools/distroless/blob/main/README.md#how-do-i-use-distroless-images
  image       = "gcr.io/distroless/base-debian12:debug"
  run_command = ["-d", "-i", "-t", "--entrypoint=/busybox/sh", "--", "{{.Image}}"]
  changes = [
    "ENTRYPOINT /busybox/sh"
  ]
  // since we could not use `commit = true` for post-processor/vagrant to avoid hard-coded SHA,
  // we need to use exporting with it.
  // So `changes` will not be commited by builder/docker, then we need to override with `/busybox/sh` in Vagrantfile.pkrtpl
  export_path = "distroless-debian_arm64.tar"
}
