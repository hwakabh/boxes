source "docker" "docker_distroless-debian_arm64" {
  // https://github.com/GoogleContainerTools/distroless/blob/main/README.md#how-do-i-use-distroless-images
  image       = "gcr.io/distroless/base-debian12:debug"
  run_command = ["-d", "-i", "-t", "--entrypoint=/busybox/sh", "--", "{{.Image}}"]
  changes = [
    "ENTRYPOINT /busybox/sh"
  ]
  commit = true
}
