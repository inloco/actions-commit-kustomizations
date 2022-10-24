MKFILE_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

image-tag:
	test "$(IMAGE_TAG)" = 'commit-sha' && git describe --always --dirty --exclude '*' || printf "$(IMAGE_TAG)"
.PHONY: image-tag

edit-kustomizations:
	OVERLAY="$(OVERLAY)" $(MKFILE_DIR)/kustomize-set-image-tags.sh
.PHONY: edit-kustomizations

commit-kustomizations:
	git reset
	find $(K8S_PATH) -type f -name kustomization.yaml -exec git add {} \+
	printf "chore(k8s): update images to version $(IMAGE_TAG)\n\n$$(git log --format=%B -n1 HEAD)" | git commit -F -
	git push --set-upstream "$$(git remote show)" "$$(git rev-parse --abbrev-ref HEAD)" || echo "Skipping commit..."
.PHONY: commit-kustomizations
