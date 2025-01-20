#!/bin/bash

if [ ! -d "onefinity-utils" ]; then
  mkdir "onefinity-utils"
else
  echo "Directory onefinity-utils already exists"
fi

if [ ! -d "onefinity" ]; then
  mkdir "onefinity"
else
  echo "Directory onefinity already exists"
fi

curl -o onefinity-utils/keygenerator https://onefinity.fra1.digitaloceanspaces.com/keygenerator
curl -o onefinity-utils/termui https://onefinity.fra1.digitaloceanspaces.com/termui
curl -o onefinity/node https://onefinity.fra1.digitaloceanspaces.com/node
curl -o go-onefinity.tar.gz https://onefinity.fra1.digitaloceanspaces.com/onefinity-go.tar.gz


echo "Downloads complete!"
