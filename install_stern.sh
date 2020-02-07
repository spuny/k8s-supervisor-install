#!/bin/bash

cd /usr/local/bin

sudo wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
sudo mv stern_linux_amd64 stern
sudo chmod +x stern
