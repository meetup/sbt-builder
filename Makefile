VERSION ?= 0.2.$(CI_BUILD_NUMBER)

PUBLISH_TAG=sbt-builder:$(VERSION)
# docker image push is only supported with a tag of the format :owner/:repo_name/:image_name.
GITHUB_REGISTRY_TAG=docker.pkg.github.com/meetup/sbt-builder/sbt-builder:$(VERSION)
TESTER_TAG=mup.cr/blt/sbt-builder-rspec:$(VERSION)

_authenticate:
	echo $(GITHUB_TOKEN) | docker login ghcr.io -u meetcvs --password-stdin

package: _authenticate
	docker build -t $(PUBLISH_TAG) .

publish: package
	@docker tag $(PUBLISH_TAG) $(GITHUB_REGISTRY_TAG)
	@docker push $(GITHUB_REGISTRY_TAG)
