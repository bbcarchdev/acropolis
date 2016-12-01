#!/bin/bash
pytest --junitxml=junit.xml
cat junit.xml
