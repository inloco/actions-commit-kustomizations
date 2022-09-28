# Kustomize Image Tags Action

## Example

The following job:

```yaml
example:
  steps:
    - uses: inloco/actions-bootstrap@HEAD
    - uses: inloco/actions-kustomize-image-tags@HEAD
      with:
        images: |
          incognia/example:blue
          incognia/example:green
          incognia/example:red
```

will try to update image tags in the following directories:

- ./k8s/overlays/integration
- ./k8s/overlays/production
- ./k8s/overlays/staging

edit the kustomization `images` field, e.g.:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
# ...
images:
  - name: incognia/example:blue
    newTag: 610d69f-blue
  - name: incognia/example:green
    newTag: 610d69f-green
  - name: incognia/example:red
    newTag: 610d69f-red
```

and commit any changes to the current branch.
