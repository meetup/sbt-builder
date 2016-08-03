PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CI_BUILD_NUMBER ?= $(USER)-snapshot

PUBLISH_TAG=mup.cr/blt/sbt-builder:0.1.$(CI_BUILD_NUMBER)
TESTER_TAG=mup.cr/blt/sbt-builder-rspec:0.1.$(CI_BUILD_NUMBER)

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

package-test:
	docker build -f test/docker/Dockerfile \
	  -t $(TESTER_TAG) test
	docker run -it --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e IMAGE_TAG=$(PUBLISH_TAG) \
		$(TESTER_TAG)

#Pushes the container to the docker registry/repository.
publish:
	@docker push $(PUBLISH_TAG)

publish-tag:
	@echo $(PUBLISH_TAG)
