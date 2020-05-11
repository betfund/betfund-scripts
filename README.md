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
sh kafka/zk-install.sh install
```

To start `zookeeper` and `kafka` daemon
```bash
sh kafka/zk-admin.sh start
```

## Dask (configure ec2-dask cluster)

[Using kubernetes and helm](https://docs.dask.org/en/latest/setup/kubernetes-helm.html)

To install dependencies
```bash
sh dask/dd-install.sh install
```

To configure environment
```bash
// This requires an IAM user with s3 and ec2 privileges

sh dask/dd-configure.sh configure
```

To start the Dask cluster
```bash
sh dask/dd-start.sh
```