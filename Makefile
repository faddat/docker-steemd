BUILD_ARGS := --build-arg UBUNTU_MIRROR="mirror://mirrors.ubuntu.com/mirrors.txt"
ifdef UBUNTU_MIRROR
	BUILD_ARGS := --build-arg UBUNTU_MIRROR="$(UBUNTU_MIRROR)"
endif

default: build

build: kill
	docker build \
		-t sneak/steemd \
		$(BUILD_ARGS) \
		.

run: kill
	docker run \
		--name sneak-steemd \
		-e STEEMD_WITNESS_NAME=$(STEEMD_WITNESS_NAME) \
		-e STEEMD_MINER_NAME=$(STEEMD_MINER_NAME) \
		-e STEEMD_PRIVATE_KEY=$(STEEMD_PRIVATE_KEY) \
		-d \
		sneak/steemd
	docker logs -f sneak-steemd

kill:
	-docker rm -f sneak-steemd
