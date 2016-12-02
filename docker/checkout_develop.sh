#!/bin/bash

cd quilt
git checkout develop
git pull
git submodule update --init --recursive
cd ..
cd spindle
git checkout develop
git pull
git submodule update --init --recursive
cd ..
cd twine
git checkout develop
git pull
git submodule update --init --recursive
cd ..
