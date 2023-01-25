# internal-runtime-def

## required changes:

1. replace all occurences of `<private_registry>` with your own docker registry
1. in `manifests/runtime.yaml`, replace `github.com/noam-codefresh/internal-runtime-def` with your fork (or manual copy) of this repository
1. in `manifests/internal-router/internal-router.yaml` update the `spec/hosts` field with your planned ingressHost
