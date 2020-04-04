#!/bin/bash

echo "
     \_/
   __/''.
  /__ |  zk-admin
  || ||
"

ZNAME="zookeeper"
KNAME="kafka"

ZCMD="/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties"
KCMD="/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties"
ZPID="/var/run/$ZNAME.pid"
KPID="/var/run/$KNAME.pid"
ZLOG="/var/log/$ZNAME.log"
KLOG="/var/log/$KNAME.log"

function start-zookeeper {
	echo "---------------------------"
	echo ">> Starting Zookeeper..."
	echo -e "---------------------------"
	if [ -f "$ZPID" ]; then
		echo "$ Already running $ZNAME"
	else
		sudo sh /opt/kafka_2.13-2.4.0/bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
	fi
}

function start-kafka {
	echo -e "\n---------------------------"
	echo ">> Starting Kafka..."
	echo "---------------------------"
	if [ -f "$KPID" ]; then
		echo "$ Already running $KNAME"
		exit 1
	else
		sudo sh /opt/kafka_2.13-2.4.0/bin/kafka-server-start.sh config/server.properties
	fi
}

case "$1" in
  start)
    start-zookeeper
    start-kafka
    ;;
     echo "Usage: /etc/init.d/kafka {start}" && exit 1
    ;;
esac