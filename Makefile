
.PHONY: help trainer test build publish keys

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

keys: ## generate keys for client/server in hidden_service/ssl
	@./scripts/genkeys.sh

trainer: build ## run docker container
	@docker run --rm -v ${PWD}/hidden_service:/app/hidden_service -p 12345:12345 -it konsumer/trainer

test: build ## run a volume-mounted trainer for quicker editing
	@docker run --rm -v ${PWD}/src:/app/src -v ${PWD}/hidden_service:/app/hidden_service -p 12345:12345 -it konsumer/trainer

build: ## build docker container
	@docker build --no-cache -f scripts/Dockerfile.trainer -t konsumer/trainer . # add --no-cache to force rebuild

publish: build ## publish trainer on dockerhub
	@docker push konsumer/trainer

rattata: ## connect to rattata service on trainer to test it
	@docker build -f scripts/Dockerfile.rattata-test -t konsumer/rattata-test .
	@docker run --rm -v ${PWD}/hidden_service:/app/hidden_service -it konsumer/rattata-test

pakemon: ## connect to pakemon service on trainer to test it
	@docker build -f scripts/Dockerfile.pakemon-test -t konsumer/pakemon-test .
	@docker run --rm -it konsumer/pakemon-test