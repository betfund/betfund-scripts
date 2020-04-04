# betfund-scripts
Betfund VM configurations.

## Installation/Usage
```bash
$ git clone https://github.com/betfund/betfund-scripts.git
$ cd betfund-scripts
```

## Kafka/Zookeeper
To install dependencies
```bash
# NOTE: Configuraiton specific to machine required see output
sh zk-install.sh install
```

To start `zookeeper` and `kafka` daemon
```bash
sh zk-admin.sh start
```