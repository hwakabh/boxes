# Changelog

## [0.2.1](https://github.com/hwakabh/boxes/compare/alpine-v0.2.0...alpine-v0.2.1) (2025-05-04)


### Bug Fixes

* post-processor/docker-push with authentication ([91dd639](https://github.com/hwakabh/boxes/commit/91dd639ecddb9dc7501e324f4d12c8986fbcb6c7))


### Miscellaneous Chores

* added login_server for authenticate. ([aee68f0](https://github.com/hwakabh/boxes/commit/aee68f054a852a7bf29dd06d170b02aa7fe6d080))
* added tags for each docker-box builds. ([060c8b4](https://github.com/hwakabh/boxes/commit/060c8b4b60ef4e81c1b5caf268e6ed18c21605e6))
* **alpine:** added variables for pushing metadata/box for registry. ([ba91e40](https://github.com/hwakabh/boxes/commit/ba91e4039aa1e8f9212bec34ba95a3393946a66d))
* cleaned up codes and removed names of builds. ([8c43610](https://github.com/hwakabh/boxes/commit/8c4361045418e261389e6d752a0f7b31d175b9d1))
* commented out implementations. ([cf63c37](https://github.com/hwakabh/boxes/commit/cf63c379b106a9da2130bb4963b1f6ef65979e46))
* enabled login=true in post-processor/docker-push. ([13b24fa](https://github.com/hwakabh/boxes/commit/13b24fa5452fc915f02dc5fbc14d9c0683fd8f45))
* fixed conflicts. ([555ed9d](https://github.com/hwakabh/boxes/commit/555ed9da5c8ffa49c79685a6bbe1b0ae6494e100))
* fixed docker.cmd in Vagrantfile using templates. ([63c4be9](https://github.com/hwakabh/boxes/commit/63c4be959a0a30f6ce8d4118fc793c6dcc97a6d8))
* replaced post-processor for docker boxes. ([f634233](https://github.com/hwakabh/boxes/commit/f63423379783a6ec15dd18058a2e65094ccf85a9))
* run formats. ([66afbe3](https://github.com/hwakabh/boxes/commit/66afbe31386a4d8db551dc2dd5fa648d8f2ba8b4))
* run formats. ([547fe6e](https://github.com/hwakabh/boxes/commit/547fe6e4ebf0978b49110d8c388c7b92a636d24a))
* run formats. ([53a99d1](https://github.com/hwakabh/boxes/commit/53a99d14518480aa19955bbdf44ba7d8d9919d07))


### Build System

* **box:** fixed issue on hard-coded digest in Vagrantfile. ([fe14cf1](https://github.com/hwakabh/boxes/commit/fe14cf132aae9fe023e620888d6a52eee7d41986))


### Continuous Integration

* added post-processor/docker-push and removed commit=true in builder/docker. ([4372783](https://github.com/hwakabh/boxes/commit/437278330f5343928b4c13e1167314392f465c35))
* enhancements for box publishing to registry ([db02e4e](https://github.com/hwakabh/boxes/commit/db02e4ec70ea265a8f1b7ceba895d23e7ae4ec0e))
* envars and secrets for packer builds ([2ad84aa](https://github.com/hwakabh/boxes/commit/2ad84aae61142f61ae6c88f5db523dfa47baf378))
* registry integrations for docker-boxes ([3840460](https://github.com/hwakabh/boxes/commit/3840460c8ae61213518c736cfc2ea1f048d56777))
* replaced github_token with PAT from action secrets. ([e808252](https://github.com/hwakabh/boxes/commit/e8082522508600c54b7cfa6caf78777c93e25325))

## [0.2.0](https://github.com/hwakabh/boxes/compare/alpine-v0.1.0...alpine-v0.2.0) (2025-05-03)


### Features

* added check CI with initialized packer configs. ([fc973c4](https://github.com/hwakabh/boxes/commit/fc973c4354fa27c0d836bf5323dd45ad7969edfc))
* added templates for docker-provider boxes. ([5a6ac94](https://github.com/hwakabh/boxes/commit/5a6ac94c95291eed67dc19667ed8c4ea541b5fea))


### Miscellaneous Chores

* added initial templates for alpine. ([d445cb8](https://github.com/hwakabh/boxes/commit/d445cb8a4c2e7247d58eca19ae3f4ac75a9f5058))
* added vbox builds with skelton. ([32768fe](https://github.com/hwakabh/boxes/commit/32768fef3f110d848cb8caa9bafb179c50bb8ff6))
* fixed build names and overrides. ([8aa368b](https://github.com/hwakabh/boxes/commit/8aa368b6484c4db0ec38cfd77005f33a27834787))
* renamed template files for source/build separations. ([e99c516](https://github.com/hwakabh/boxes/commit/e99c51674fa367442c4fe99a182ed0542b08271a))
* run format. ([f0d7b53](https://github.com/hwakabh/boxes/commit/f0d7b538f1ec9767c92574af382d265873532573))
* run formats. ([f2c81b0](https://github.com/hwakabh/boxes/commit/f2c81b0f46f4374b03d2f1d3287777540305051c))
* run formats. ([4cf888b](https://github.com/hwakabh/boxes/commit/4cf888b2cfbc33eb20b9e28ffb04f62e2f96306d))
* run formats. ([f3f6b2c](https://github.com/hwakabh/boxes/commit/f3f6b2c313a50b3aa5177ce4c19d6604d5ea76e8))


### Continuous Integration

* added named fields for each sources. ([26f72db](https://github.com/hwakabh/boxes/commit/26f72db95d6b424bcc42b82c6ad0f80b75496c2d))
* added only fields for fixing build issue. ([8c9e263](https://github.com/hwakabh/boxes/commit/8c9e263a0f51edda3967ab8a3ff52b8a9c1529ff))
* added workflows for building docker boxes. ([5edd0be](https://github.com/hwakabh/boxes/commit/5edd0bebf6d8c89c89dbd38ecab156b3ec2740e6))
* enhancements for multiple builds ([931e69b](https://github.com/hwakabh/boxes/commit/931e69bfb77d2d4be5f717c83bc3bd3898348ceb))
* fixed references in only fields. ([f28bc54](https://github.com/hwakabh/boxes/commit/f28bc54b9e8e1a8c7f21a13238ee66faf946ae2f))
* updated names of each sources. ([593affe](https://github.com/hwakabh/boxes/commit/593affe11663f7193da454ae4400149c40b03a50))
