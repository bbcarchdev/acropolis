#!/bin/bash

for repo in quilt spindle twine anansi; do
  cd $repo
  git checkout develop
  git pull
  git submodule update --init --recursive
  cd ..
done
