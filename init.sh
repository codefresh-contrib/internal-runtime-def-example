#!/bin/bash

FLATTEN=false

echo "USAGE: $0 -r <GIT_REPO> -d <DOCKER_REGISTRY> [-h <HELM_MUSEUM> -f]"

while getopts 'r:d:h:f' OPTION; do
  case "$OPTION" in
    r) GIT_REPO=$OPTARG ;;
    d) DOCKER_REGISTRY=$OPTARG ;;
    h) HELM_MUSEUM=$OPTARG ;;
    f) FLATTEN=true ;;
  esac
done
shift "$(($OPTIND -1))"

: ${GIT_REPO:?Missing -r} ${DOCKER_REGISTRY:?Missing -d}

update_internal_refs() {
  echo "updating internal refs in manifests/runtime.yaml"
  sed -i '' 's@https://github\.com/codefresh-contrib/internal-runtime-def-example\.git@'"${GIT_REPO}"'@g' manifests/runtime.yaml
}

update_docker_registr() {
  echo "updating docker registry in all kustomization.yaml patches"
  find . -type f -name "kustomization.yaml" | xargs sed -i '' 's@<private_registry>@'"${DOCKER_REGISTRY}"@'g' manifests/app-proxy/kustomization.yaml
  sed -i '' 's@<private_registry>@'"${DOCKER_REGISTRY}"@'g' manifests/codefresh-tunnel-client/values.yaml
}

update_helm_museum() {
  echo "updating helm museum in codefresh-tunnel-client chart.yaml"
  sed -i '' 's@https://chartmuseum\.codefresh\.io@'"${HELM_MUSEUM}"'@g' manifests/codefresh-tunnel-client/chart.yaml
}

flatten() {
  local KUSTOMIZATIONS=()
  while IFS=  read -r -d $'\0'; do
    KUSTOMIZATIONS+=("$REPLY")
  done < <(find . -type f -name "kustomization.yaml" -print0)

  for i in "${KUSTOMIZATIONS[@]}"; do
    local COMPONENT_DIR=$(dirname ${i})
    local INSTALL_YAML=${COMPONENT_DIR}/install.yaml
    if [ ! -f ${INSTALL_YAML} ]; then
      echo "flattening ${i}"
      local RESOURCE=$(cat ${i} | grep https://github.com/codefresh.io/csdp.official)
      kustomize build ${RESOURCE:2} > ${INSTALL_YAML}
      sed -i '' 's@- https://github\.com/codefresh-io/csdp-official\.git/.*@- install.yaml@g' ${i}
    fi
  done
}

update_internal_refs
update_docker_registr
if [ -n "${HELM_MUSEUM}" ]; then
  update_helm_museum
fi

if [ "$FLATTEN" = true ]; then
  flatten
fi
