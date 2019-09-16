PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CI_BUILD_NUMBER ?= $(USER)-snapshot

VERSION ?= 0.1.$(CI_BUILD_NUMBER)

PUBLISH_TAG=meetup/sbt-builder:$(VERSION)
GITHUB_REGISTRY_TAG=docker.pkg.github.com/meetup/sbt-builder:$(VERSION)
TESTER_TAG=mup.cr/blt/sbt-builder-rspec:$(VERSION)

# lists all available targets
list:
	@sh -c "$(MAKE) -p no_op__ | \
		awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);\
		for(i in A)print A[i]}' | \
		grep -v '__\$$' | \
		grep -v 'make\[1\]' | \
		grep -v 'Makefile' | \
		sort"

# required for list
no_op__:

#Assemles the software artifact using the defined build image.
package:
	docker build -t $(PUBLISH_TAG) .

component-test:
	docker build -f test/docker/Dockerfile \
	  -t $(TESTER_TAG) test
	docker run -it --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e IMAGE_TAG=$(PUBLISH_TAG) \
		$(TESTER_TAG)

#Pushes the container to the docker registry/repository.
publish: package component-test
	@docker push $(PUBLISH_TAG)

publish-github-registry: package component-test
	@docker login docker.pkg.github.com --username chenrui333 -p GITHUB_REGISTRY_TOKEN
	@docker tag $(PUBLISH_TAG) $(GITHUB_REGISTRY_TAG)
	@docker push $(GITHUB_REGISTRY_TAG)

version:
	@echo $(VERSION)

publish-tag:
	@echo $(PUBLISH_TAG)
