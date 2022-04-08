# Kustomize Image Tags Action

## Example

The following job:

```yaml
github:
  name: Update Kustomization Image Tags
  runs-on: ubuntu:latest
  steps:
    - uses: actions/checkout@v2
    - uses: inloco/actions-kustomize-image-tags@HEAD
      with:
        images: |
          org-name/image-blue
          org-name/image-green
          org-name/image-red
          org-name/image-yellow
```

will try to update image tags in the following directories:

- ./k8s/overlays/integration
- ./k8s/overlays/production
- ./k8s/overlays/staging

and will commit any changes to the current branch.
