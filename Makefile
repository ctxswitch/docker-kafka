PREFIX := $(HOME)
MAKE_PATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
DOCKERHUB_USER ?= ctxswitch

KAFKA_VERSIONS := \
	2.12_2.2.1 \
	2.12_2.1.1 \
	2.12_2.0.1 \
	2.12_1.1.1 \
	2.12_1.0.2 \
	2.11_0.11.0.3 \
	2.11_0.10.2.2 \
	2.11_0.8.2.2
KAFKA_LATEST := 2.2.1

.PHONY: all
all: $(KAFKA_VERSIONS)

%:: # Build versioned kafka container
	@docker build \
		--build-arg "KAFKA_VERSION=$(lastword $(subst _, ,$@))" \
		--build-arg "SCALA_VERSION=$(firstword $(subst _, ,$@))" \
		--tag $(DOCKERHUB_USER)/kafka:$(lastword $(subst _, ,$@)) \
		.

.PHONY: release
release: # Release all versions
	@docker tag $(DOCKERHUB_USER)/kafka:$(KAFKA_LATEST) $(DOCKERHUB_USER)/kafka:latest
	@docker push $(DOCKERHUB_USER)/kafka:latest
	$(foreach ver, $(KAFKA_VERSIONS),\
		$(shell docker push $(DOCKERHUB_USER)/kafka:$(lastword $(subst _, ,$(ver)))))

.PHONY: clean
clean:
	@docker rm $(shell docker ps -qa) || true
	@docker rmi $(shell docker images -q $(DOCKERHUB_USER)/kafka) --force || true