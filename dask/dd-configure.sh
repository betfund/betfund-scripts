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
    echo "$NAME"
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
  echo ">> Setting Cluster Region"
  echo "---------------------------"
  sudo sh -c "echo export REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}') >> /etc/profile"
  source /etc/profile
  echo "$REGION"
}

function configurebucket() {
  echo "---------------------------"
  echo ">> s3 Bucket Configuartion"
  echo "---------------------------"
  echo "Please enter desired bucket name, followed by [ENTER]"
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
  echo ">> Setter cluster zones:"
  echo "---------------------------"
  REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
  sudo sh -c "echo export ZONES=$(aws ec2 describe-availability-zones --region $REGION | grep ZoneName | awk 'NR==1{print $2}' | tr -d '",') >> /etc/profile"
}

case "$1" in
configure)
  configurecluster
  keygen
  setregion
  configurebucket
  setavailability
  echo "**IMPORTANT**"
  echo "EXECUTE THE BELOW COMMAND"
  echo "source /etc/profile"
  ;;
*)
  echo "Configure: {configure}" && exit 1
  ;;
esac
