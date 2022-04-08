MKFILE_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

edit-kustomizations:
	OVERLAY="$(OVERLAY)" $(MKFILE_DIR)/kustomize-set-image-tags.sh
.PHONY: edit-kustomizations

configure-ssh:
	sudo chown user ~/.ssh
	ssh-keyscan github.com >> ~/.ssh/known_hosts
	git config --global url."git@github.com:".insteadOf https://github.com/
.PHONY: configure-ssh

commit-kustomizations: configure-ssh
	git reset
	find ./k8s -type f -name kustomization.yaml -exec git add {} \+
	git commit -m "chore(k8s): update images to version $${TAG}"
	git push --set-upstream "$$(git remote show)" "$$(git rev-parse --abbrev-ref HEAD)"
.PHONY: commit-kustomizations
