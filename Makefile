default: build

build: kill
	docker build -t sneak/steemd .

run: kill
	docker run --name sneak-steemd -d sneak/steemd
	docker logs -f sneak-steemd

kill:
	-docker rm -f sneak-steemd
