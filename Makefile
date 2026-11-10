#! make

VERSION := $(shell grep 'ARG SHINYPROXY_VERSION=' Dockerfile | cut -d= -f2)

build:
	docker build -t shinyproxy-kth:$(VERSION) .

test: clean
	docker network create sp-example-net
	docker run -v "/var/run/docker.sock:/var/run/docker.sock:ro" --net sp-example-net -p "8080:8080" -v "$$(pwd)/application.yaml:/opt/shinyproxy/application.yml" shinyproxy

clean:
	docker network rm sp-example-net
