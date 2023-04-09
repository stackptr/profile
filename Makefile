.PHONY: build
build:
	docker build . -t stackptr/x64.co --platform linux/amd64
  
.PHONY: push
push:
	docker image push stackptr/x64.co
