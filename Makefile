MKFILE_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

image-tag:
	test "$(IMAGE_TAG)" = 'commit-sha' && git describe --always --dirty --exclude '*' || printf "$(IMAGE_TAG)"
.PHONY: image-tag

edit-kustomizations:
	OVERLAY="$(OVERLAY)" $(MKFILE_DIR)/kustomize-set-image-tags.sh
.PHONY: edit-kustomizations

commit-kustomizations:
	git reset
	find ./k8s -type f -name kustomization.yaml -exec git add {} \+
	printf "chore(k8s): update images to version $(IMAGE_TAG)\n\n$$(git log --format=%B -n1 HEAD)" | git commit -F -
.PHONY: commit-kustomizations
