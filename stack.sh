#!/bin/bash

docker run -u $UID -v "$PWD/service":/build --rm -t $(docker build -q build) bash -c "cd build && stack --allow-different-user --stack-root=/build/.stack-docker --work-dir=.stack-work-docker $*"
