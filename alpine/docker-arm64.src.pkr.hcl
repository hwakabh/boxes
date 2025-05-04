source "docker" "alpine_arm64" {
  image = "alpine:latest"
  // since we could not use `commit = true` for post-processor/vagrant to avoid hard-coded SHA,
  // we need to use exporting with it.
  export_path = "alpine_arm64.tar"
}
