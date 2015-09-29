# Sample configuration files

This directory contains sample configuration files which match those used
in the live deployment of Acropolis for the Research & Education Space.

In these deployments:

* Anansi is configured with etcd, a RADOS bucket, and a local etcd proxy on each node
* Twine receives messages from a pre-configured Apache Qpid message broker and is able to fetch objects from the Anansi RADOS bucket, and pushes graph into a 4store cluster
* Spindle's Twine module stores indexes in a Postgres database, and writes pre-computed N-Quads to a RADOS bucket
* Quilt operates as a FastCGI application, spawned on-demand by Apache as needed
* Spindle's Quilt module is configured to query the Postgres database and read pre-computed N-Quads from the RADOS bucket
