PKG_VERSION := $(shell yq e ".version" manifest.yaml)
PKG_ID := $(shell yq e ".id" manifest.yaml)
TS_FILES := $(shell find . -name \*.ts )

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

# assumes /etc/embassy/config.yaml exists on local system with `host: "http://embassy-server-name.local"` configured
install: $(PKG_ID).s9pk
	embassy-cli package install $(PKG_ID).s9pk

verify: $(PKG_ID).s9pk
	embassy-sdk verify s9pk $(PKG_ID).s9pk

clean:
	rm -rf docker-images
	rm -f  $(PKG_ID).s9pk
	rm -f image.tar
	rm -f scripts/*.js

 $(PKG_ID).s9pk: manifest.yaml instructions.md scripts/embassy.js gitea/LICENSE docker-images/aarch64.tar docker-images/x86_64.tar
	if ! [ -z "$(ARCH)" ]; then cp docker-images/$(ARCH).tar image.tar; fi
	embassy-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js
