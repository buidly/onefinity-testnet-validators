# Onefinity First Validator Setup Guide

## Overview
This repository contains the necessary tools and instructions to deploy Onefinity validator and observer nodes, as well as adding new validator nodes after genesis. The binary files are already compiled and ready to use. Please follow the instructions below to set up and manage your Onefinity validator or observer node.



---

## Contents
- [Supported Operating Systems](#supported-operating-systems)
- [Download Binaries](#download-binaries)
- [Setup go](#go)
- [Onefinity Validator Setup](#Onefinity-validator-setup)
- [Onefinity Validator/Observer Node Start](#Onefinity-validatorobserver-node-start)
- [Key Generation](#key-generation)
- [Install mxpy](#install-mxpy)
- [Configure `mxpy` Address HRP](#configure-mxpy-address-hrp)
- [How to Add a New Validator Node After Genesis](#how-to-add-a-new-validator-node-after-genesis)
- [Usefull links](#chain-links)

---

## Supported Operating Systems

The setup and configuration steps outlined in this documentation have been tested on Ubuntu 22.04 LTS and above. While other Linux distributions may work, they are not officially supported or tested.

---

## Download Binaries
Before installing or configuring anything else, you must download the precompiled binaries:

```bash
./download.sh
```
---

## Go

We also need an instance of already prepared go due to some shared libraries

Remove old go and install the new one

```bash
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go-onefinity.tar.gz

export PATH=$PATH:/usr/local/go/bin
```

Check if go is installed

```bash
go version
```

Verify missing libraries on node binary

```bash
ldd ./node
```

you might see those 2 lines

libvmexeccapi.so => not found
libwasmer_linux_amd64.so => not found


Find path of 

```bash
buidly/mx-evm-chain-vm-go@v0.0.0-20241218192919-285df70148f7/wasmer2/libvmexeccapi.so
buidly/mx-evm-chain-vm-go@v0.0.0-20241218192919-285df70148f7/wasmer/libwasmer_linux_amd64.so
```

Copy (or Symlink) Libraries to a Standard Path

```bash
find /usr/local/go -name "libvmexeccapi.so" 2>/dev/null
find /usr/local/go -name "libwasmer_linux_amd64.so" 2>/dev/null

sudo cp /usr/local/go/path/to/libvmexeccapi.so /usr/local/lib/
sudo cp /usr/local/go/path/to/libwasmer_linux_amd64.so /usr/local/lib/
```
(Adjust the paths accordingly.)




Update the linker cache:

```bash
sudo ldconfig
```
Run

```bash
ldd ./node
```

---

## Onefinity Validator Setup
Each validator node should have the following files and folders:
- `validatorKey.pem` (or `allValidatorsKey.pem` if a multisig node): The validator key used to deploy the node.
- `config` folder: Contains the configuration files required to run the node.

---

## Onefinity Validator/Observer Node Start

Follow the commands below to start a Onefinity validator node with the configuration from the `config` folder. Make sure you use the correct validator key or multisig key (`allValidatorsKey.pem`).

### Single Key Validator

```bash
./node \
  --profile-mode \
  --log-save \
  --log-level "*:DEBUG" \
  --log-logger-name \
  --log-correlation \
  --use-health-service \
  --rest-api-interface "localhost:9501" \
  --working-directory "~/working-dir/validator" \
  --config-external "./config/external_validator.toml" \
  --config "./config/config_validator.toml" \
  --validator-key-pem-file "./config/validatorKey.pem"
```
### Multi-Key Validator

```bash
./node \
  --profile-mode \
  --log-save \
  --log-level "*:DEBUG" \
  --log-logger-name \
  --log-correlation \
  --use-health-service \
  --rest-api-interface "localhost:9501" \
  --sk-index 1 \
  --working-directory "~/working-dir/validator" \
  --config-external "./config/external_validator.toml" \
  --config "./config/config_validator.toml" \
  --all-validator-keys-pem-file ./config/allValidatorsKey.pem
```
### Observer 

```
./node --port 21501 --profile-mode --log-save --log-level *:INFO --log-logger-name --log-correlation --use-health-service --rest-api-interface localhost:8080 --working-directory ~/working-dir --config-external ./config/external_observer.toml --config ./config/config_observer.toml
```
---

## Install mxpy

To interact with the blockchain and make transactions, you need to install `mxpy`.
You can find more detailed installation instructions and additional setup steps for `mxpy` [here](https://docs.multiversx.com/sdk-and-tools/sdk-py/installing-mxpy).

## Configure mxpy Address HRP

mxpy config set default_address_hrp one

---
## For the validator pem to interact with the mxpy we need to create a json with the path having the following structure

```bash
{
  "validators": [
    {
      "pemFile": "validatorKey.pem"
    }
  ]
}
```

---

## How to Add a New Validator Node After Genesis

```bash
mxpy validator stake \
  --pem=walletKey.pem \
  --value="2500000000000000000000" \
  --validators-file=validator.json \
  --proxy="https://gateway.validators.onefinity.network" \
  --gas-limit 25000000 \
  --recall-nonce \
  --send
```
---

## How to unstake a Validator Node After Genesis

```bash
mxpy validator unstake \
  --pem=walletKey.pem \
  --nodes-public-keys address \
  --proxy="https://gateway.validators.onefinity.network" \
  --gas-limit 25000000 \
  --recall-nonce \
  --send
```
---

## Chain links

https://api.validators.onefinity.network
https://gateway.validators.onefinity.network
https://rpc.validators.onefinity.network
https://index.validators.onefinity.network
https://explorer.validators.onefinity.network
https://ercwallet.validators.onefinity.network
https://litewallet.validators.onefinity.network