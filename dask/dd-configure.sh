#!/bin/bash

echo "
  __QQ
 (_)_'>
_/    dd-configure
"

function configurecluster() {
  echo "---------------------------"
  echo ">> Dask Cluster Configuartion"
  echo "---------------------------"
  echo "Please enter desired Dask cluster name, followed by [ENTER]"
  read cluster

  if [[ $cluster == *['!'@#\$%^\&*()_+]* ]]; then
    echo "Cluster name should NOT contain special charaters"
    exit 1
  else
    sudo sh -c "echo export NAME=$cluster.k8s.local >> /etc/profile"
  fi
}

function keygen() {
  echo "---------------------------"
  echo ">> Generating Keypair"
  echo "---------------------------"
  ssh-keygen
}

function setregion() {
  echo "---------------------------"
  echo ">> Setting cluster region"
  echo "---------------------------"
  REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
  export REGION && echo "$REGION"
}

function configurebucket() {
  echo "---------------------------"
  echo ">> s3 Bucket Configuartion"
  echo "---------------------------"
  echo "Please enter desired bucket cluster name, followed by [ENTER]"
  read bucket

  if [[ $bucket == *['!'@#\$%^\&*()_+]* ]]; then
    echo "Bucket name should NOT contain special charaters"
    exit 1
  else
    aws s3api create-bucket --bucket $bucket --region us-east-1
    sudo sh -c "echo export KOPS_STATE_STORE=s3://$bucket >> /etc/profile"
  fi
}

function setavailability() {
  echo "---------------------------"
  echo ">> Setting node availability"
  echo "---------------------------"
  ZONES=$(aws ec2 describe-availability-zones --region $REGION | grep ZoneName | awk '{print $2}' | tr -d '"')
  export ZONES && echo "$ZONES"
}

case "$1" in
configure)
  configurecluster
  keygen
  setregion
  configurebucket
  setavailability
  echo -e "\nFinished!\n"
  ;;
*)
  echo "Configure: {configure}" && exit 1
  ;;
esac
