SHELL = /bin/bash

git/commit-image-changes:
	git reset
	find $(K8S_MANIFESTS_PATH) -type f -name kustomization.yaml -exec git add {} \+
	git commit -m "chore(k8s): update images to version $(IMAGE_TAG)"
	git push -u "$$(git remote show)" "$$(git rev-parse --abbrev-ref HEAD)"
.PHONY: git/commit-image-changes

git/configure-ssh:
	sudo chown user ~/.ssh
	ssh-keyscan github.com >> ~/.ssh/known_hosts
	git config --global url."git@github.com:".insteadOf https://github.com/
.PHONY: git/configure-ssh

.ONESHELL:
git/sync-branch:
	export DEFAULT_BRANCH="$$(git rev-parse --abbrev-ref HEAD)"
	git checkout $(BRANCH)
	git reset --hard $$(git remote show)/$${DEFAULT_BRANCH}
	git push --force -u "$$(git remote show)" $(BRANCH)
.PHONY: git/commit-image-changes
