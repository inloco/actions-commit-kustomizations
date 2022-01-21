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
git/merge-argocd-stag:
	export DEFAULT_BRANCH="$$(git rev-parse --abbrev-ref HEAD)"
	git checkout argocd-stag
	git reset --hard $$(git remote show)/$${DEFAULT_BRANCH}
	git push --force -u "$$(git remote show)" argocd-stag
.PHONY: git/commit-image-changes
