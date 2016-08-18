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
	docker run --name sneak-steemd -d sneak/steemd
	docker logs -f sneak-steemd

kill:
	-docker rm -f sneak-steemd
