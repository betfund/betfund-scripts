#!/bin/bash

echo "
  __QQ
 (_)_'>
_/    dd-install
"

function installkops() {
  echo "---------------------------"
  echo ">> Installing kops"
  echo "---------------------------"
  curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
  chmod +x ./kops
  sudo mv ./kops /usr/local/bin/
}

function installkubectl() {
  echo -e "---------------------------"
  echo ">> Installing kubectl"
  echo "---------------------------"
  curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
}

function installawscli() {
  echo -e "---------------------------"
  echo ">> Installing awscli"
  echo "---------------------------"
  sudo pip3.7 install awscli
}

function installhelm() {
  echo -e "---------------------------"
  echo ">> Installing helm"
  echo "---------------------------"
  curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

  # Initialization for helm is needed for usage
  # Through helm init we can do a quickstart
  helm init

  sleep 2

  helm repo add dask https://helm.dask.org/
  helm repo update
}

case "$1" in
install)
  installkops
  installkubectl
  installawscli
  installhelm
  echo -e "\nFinished!\n"
  ;;
*)
  echo "Install: {install}" && exit 1
  ;;
esac
