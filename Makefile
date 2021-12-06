VERSION ?= 0.3.$(CI_BUILD_NUMBER)

PUBLISH_TAG=sbt-builder:$(VERSION)
# docker image push is only supported with a tag of the format :owner/:repo_name/:image_name.
GITHUB_REGISTRY_TAG=ghcr.io/meetup/sbt-builder:$(VERSION)

_authenticate:
	docker login ghcr.io -u meetcvs -p $(GITHUB_TOKEN)

package: _authenticate
	docker buildx build --platform linux/amd64,linux/arm64/8 build -t $(PUBLISH_TAG) .

publish: package
	@docker tag $(PUBLISH_TAG) $(GITHUB_REGISTRY_TAG)
	@docker push $(GITHUB_REGISTRY_TAG)
