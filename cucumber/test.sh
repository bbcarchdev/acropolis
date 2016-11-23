#!/bin/bash
curl -X POST --header "Content-Type: text/x-nquads" --data-binary @shakespeare-sample.nq  http://localhost:8000/ingest
