# Wrapper for gitea

Gitea is a community managed lightweight code hosting solution written in Go.
It is published under the MIT license. This repository creates the `s9pk` package that is installed to run `gitea` on [embassyOS](https://github.com/Start9Labs/embassy-os/).

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Build environment

Prepare your EmbassyOS build environment. In this example we are using Ubuntu 20.04.

1. Install docker

```
curl -fsSL https://get.docker.com -o- | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER
```

2. Set buildx as the default builder

```
docker buildx install
docker buildx create --use
```

3. Enable cross-arch emulated builds in docker

```
docker run --privileged --rm linuxkit/binfmt:v0.8
```

4. Install yq

```
sudo snap install yq
```

5. Install deno

```
sudo snap install deno
```

6. Install essentials build packages

```
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```

7. Build and install embassy-sdk

```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
make sdk
embassy-sdk init
```

Now you are ready to build the `gitea` package

## Cloning

Clone the Gitea Wrapper locally. Note the submodule link to the original project.

```
git clone https://github.com/Start9Labs/gitea-wrapper.git
cd gitea-wrapper
git submodule update --init
```

## Building

To build the `gitea` package, run the following command:

```
make
```

## Installing (on embassyOS)

Run the following commands to install:

> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install gitea.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`,
you can install simply by running:

```
make install
```

> **Tip:** You can also install the gitea.s9pk using **Sideload Service** under
the **Embassy > Settings** section.

## Verify Install

Go to your Embassy Services page, select **Gitea**, configure and start the service. Then, verify its interfaces are accessible.

**Done!** 
