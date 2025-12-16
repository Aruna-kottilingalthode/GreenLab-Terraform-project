#!/bin/bash
set -e

ssh -N \
  -o ServerAliveInterval=60 \
  -o ExitOnForwardFailure=yes \
  -R 5044:localhost:5044 \
  ubuntu@jumpbox.greenlab.local \
  -i ~/.ssh/id_rsa

