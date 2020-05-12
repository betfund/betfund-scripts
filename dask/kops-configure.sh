#!/bin/bash

echo "
  __QQ
 (_)_'>
_/    kops-configure
"

function configurecluster() {
  echo "---------------------------"
  echo ">> Kops Cluster Configuartion"
  echo "---------------------------"
  echo "Please enter desired kops cluster name, followed by [ENTER]"
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
  echo -e "---------------------------"
  echo ">> Generating Keypair"
  echo "---------------------------"
  ssh-keygen
}

function setregion() {
  echo -e "---------------------------"
  echo ">> Setting Cluster Region"
  echo "---------------------------"
  sudo sh -c "echo export REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}') >> /etc/profile"
  source /etc/profile
  echo "$REGION"
}

function configurebucket() {
  echo -e "---------------------------"
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
  echo -e "---------------------------"
  echo ">> Setting Cluster Zones"
  echo "---------------------------"
  REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
  sudo sh -c "echo export ZONES=$(aws ec2 describe-availability-zones --region $REGION | grep ZoneName | awk 'NR==1{print $2}' | tr -d '",') >> /etc/profile"
}

function teardown() {
  echo -e "---------------------------"
  echo ">> Tearing Down Kops Cluster"
  echo "---------------------------"
  kops delete cluster $NAME --yes
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
teardown)
  teardown
  ;;
*)
  echo "Configure: {configure}" && exit 1
  ;;
esac
