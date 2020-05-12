#!/bin/bash

echo "
  __QQ
 (_)_'>
_/    dd-start
"

kops create cluster $NAME \
  --zones "$ZONES" \
  --authorization RBAC \
  --master-size t2.micro \
  --master-volume-size 10 \
  --node-size t2.medium \
  --node-volume-size 10 \
  --yes
