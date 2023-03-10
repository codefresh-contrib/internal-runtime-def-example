# internal-runtime-def

## required changes:

1. fork this repository (or copy it in any other way) into your own organization's git provider
1. run the `init.sh` script with the following flags:
    * -r <GIT_REPO> - the private server+repository where you pushed this example. ex: "https://github.my-enterprise.com/some-org/internal-runtime-def-example"
    * -d <DOCKER_REGISTRY> - the private docker registry that contains all the required images. ex: "gcr.io/my-enterprise/codefresh-io"
    * -h <HELM_MUSEUM> - the private helm museum where the `codefresh-tunnel-client` chart was pushed. only needed for ingressless runtime installs, not required for Ingress installs.
    * -f - supply this optional flag to flatten the kustomizations, instead of leaving references to `https://github.com/codefresh-io/csdp-official`
1. get the "Raw" link to `manifests/runtime.yaml`
1. run the install command with `--runtime-def`:
```shell
cf runtime install <runtime_name> --runtime-def <runtime_yaml_raw_link> ...
```

image list for runtime 0.1.24:
```
argo-cd
-------
quay.io/codefresh/argocd:v2.6.0-cap-CR-fix-rollout-rollback
quay.io/codefresh/applicationset:v0.4.2-CR-13254-remove-private-logs
ghcr.io/dexidp/dex:v2.35.3
quay.io/codefresh/redis:7.0.7-alpine

argo-events
-----------
quay.io/codefresh/argo-events:v1.7.2-cap-CR-14600
nats-streaming:0.22.1
natsio/prometheus-nats-exporter:0.8.0
natsio/prometheus-nats-exporter:0.9.1
natsio/nats-server-config-reloader:0.7.0
nats:2.8.1
nats:2.8.2
nats:2.8.1-alpine
nats:2.8.2-alpine

argo-rollouts
-------------
quay.io/codefresh/argo-rollouts:v1.4.0-cap-sw

argo-workflows
--------------
quay.io/codefresh/argocli:v3.4-cap-CR-15902
quay.io/codefresh/argoexec:v3.4-cap-CR-15902
quay.io/codefresh/workflow-controller:v3.4-cap-CR-15902

app-proxy
---------
quay.io/codefresh/cap-app-proxy:1.2098.1
alpine:3.16

internal-router
---------------
nginx:1.22-alpine

sealed-secrets
--------------
quay.io/codefresh/sealed-secrets-controller:v0.17.5

tunnel-client
-------------
quay.io/codefresh/frpc:2022.10.09-b0811fd
```
