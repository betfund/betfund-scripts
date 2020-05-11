#!/bin/bash

echo "
     \_/
   __/''.
  /__ |  zk-install
  || ||
"

JAVAHOME="/usr/lib/jvm/jre-1.8.0-openjdk"
JREHOME="/usr/lib/jvm/jre"

KAFKAHEAPOPTS="-Xmx256M -Xms128M"

function install-java() {
  echo "---------------------------"
  echo ">> Installing java-jdk"
  echo "---------------------------"
  sudo yum update
  sudo yum install java-1.8.0-openjdk.x86_64
}

function set-java-vars() {
  echo -e "\n---------------------------"
  echo ">> Setting Java variables"
  echo "---------------------------"
  if [ "$JAVA_HOME" = $JAVAHOME ]; then
    echo "$ JAVA_HOME already set."
  else
    sudo sh -c "echo export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk >> /etc/profile"
    echo "$ Set JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk"
  fi
  if [ "$JRE_HOME" = $JREHOME ]; then
    echo "$ JRE_HOME already set."
  else
    sudo sh -c "echo export JRE_HOME=/usr/lib/jvm/jre >> /etc/profile"
    echo "$ Set JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk"
  fi

  source /etc/profile
}

function install-kafka() {
  echo -e "\n---------------------------"
  echo ">> Installing Kafka"
  echo "---------------------------"
  if [ -d "/opt/kafka_2.13-2.4.0" ]; then
    echo "$ Kafka already installed"
  else
    echo "$ Installing Kafka"
    wget http://www-us.apache.org/dist/kafka/2.4.0/kafka_2.13-2.4.0.tgz
    tar -xvf kafka_2.13-2.4.0.tgz
    sudo mv kafk_2.13-2.4.0 /opt
  fi
}

function set-kafka-vars() {
  echo -e "\n---------------------------"
  echo ">> Setting Kafka variables"
  echo "---------------------------"
  if [[ -z "$KAFKA_HEAP_OPTS" ]]; then
    echo ">>>> IMPORTANT <<<<"
    echo "$ export KAFKA_HEAP_OPTS=\"-Xmx1G -Xms1G\" "
  fi
}

case "$1" in
install)
  install-java
  set-java-vars
  install-kafka
  set-kafka-vars
  echo -e "\nFinished!\n"
  ;;
*)
  echo "Install: {install}" && exit 1
  ;;
esac
