ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
VERSION := $(shell yq e ".version" manifest.yaml)
S9PK_PATH=$(shell find . -name gitea.s9pk -print)
TS_FILES := $(shell find . -name \*.ts )
# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

install: gitea.s9pk
	embassy-cli package install gitea.s9pk

verify: gitea.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

clean:
	rm -rf docker-images
	rm -f gitea.s9pk
	rm -f image.tar

gitea.s9pk: manifest.yaml docker-images/aarch64.tar docker-images/x86_64.tar instructions.md scripts/embassy.js
	if ! [ -z "$(ARCH)" ]; then cp docker-images/$(ARCH).tar image.tar; fi
	embassy-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh check-web.sh
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/gitea/main:$(VERSION) --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh check-web.sh
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/gitea/main:$(VERSION) --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js
