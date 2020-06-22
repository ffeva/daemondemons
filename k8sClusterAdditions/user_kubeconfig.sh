#!/bin/bash
sudo mkdir -p ~username/.kube
sudo cp .kube/config ~username/.kube/config
sudo chown username.username ~username/.kube/config
