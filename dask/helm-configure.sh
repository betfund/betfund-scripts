#!/bin/bash

echo "
  __QQ
 (_)_'>
_/    helm-configure
"

function installhelm() {
  echo -e "---------------------------"
  echo ">> Installing helm"
  echo "---------------------------"
  curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
}

function configuretiller() {
  kubectl --namespace kube-system create serviceaccount tiller

  # Initialization for helm is needed for usage
  # Through helm init we can do a quickstart
  helm init --service-account tiller --history-max 100 --wait

  sleep 2

  helm repo add dask https://helm.dask.org/
  helm repo update
}

function permissiontiller() {
  kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
}

case "$1" in
configure)
  installhelm
  configuretiller
  permissiontiller
  ;;
*)
  echo "Configure: {configure}" && exit 1
  ;;
esac
