# Acropolis

The [Research & Education Space](https://bbcarchdev.github.io/res/) software stack.

[![Current build status][travis]](https://travis-ci.org/bbcarchdev/acropolis)
[![Apache 2.0 licensed][license]](#license)
![Implemented in C][language]
[![Follow @RES_Project][twitter]](https://twitter.com/RES_Project)

This “umbrella” project has been assembled to make it easier to maintain and
run tests on the all of the individual components which make up the Acropolis
stack.

This software was developed as part of the [Research & Education Space project](https://bbcarchdev.github.io/res/) and is actively maintained by a development team within BBC Design and Engineering. We hope you’ll find this project useful!

## Table of Contents

* [Requirements](#requirements)
* [Using Acropolis](#using-acropolis)
* [Bugs and feature requests](#bugs-and-feature-requests)
* [Building from source](#building-from-source)
* [Automated builds](#automated-builds)
* [Contributing](#contributing)
* [Information for BBC Staff](#information-for-bbc-staff)
* [License](#license)

## Requirements

In order to build Acropolis in its entirety, you will need:—

* A working build environment, including a C compiler such as [Clang](https://clang.llvm.org), along with [Autoconf](https://www.gnu.org/software/autoconf/), [Automake](https://www.gnu.org/software/automake/) and [Libtool](https://www.gnu.org/software/libtool/)
* The [Jansson](http://www.digip.org/jansson/) JSON library
* [libfcgi](http://www.fastcgi.com)
* The client libraries for [PostgreSQL](https://www.postgresql.org) and/or [MySQL](https://dev.mysql.com/downloads/); it may be possible to use [MariaDB](https://mariadb.org)’s libraries in place of MySQL’s, but this is untested
* [libcurl](https://curl.haxx.se/libcurl/)
* [libxml2](http://xmlsoft.org/)
* The [Redland](http://librdf.org) RDF library (a more up-to-date version than your operating system provides may be required for some components to function correctly)

Optionally, you may also wish to install:—

* [Qpid Proton](https://qpid.apache.org/releases/qpid-proton-0.17.0/), if you wish to use AMQP messaging
* [CUnit](http://cunit.sourceforge.net/), to be able to compile some of the tests
* [`xsltproc`](http://xmlsoft.org/xslt/) and the [DocBook 5 XSL Stylesheets](http://wiki.docbook.org/DocBookXslStylesheets)

On a Debian-based system, the following should install all of the necessary
dependencies:

    $ sudo apt-get install -qq libjansson-dev libmysqlclient-dev libpq-dev libqpid-proton-dev libcurl4-gnutls-dev libxml2-dev librdf0-dev libltdl-dev uuid-dev libfcgi-dev automake autoconf libtool pkg-config libcunit1-ncurses-dev build-essential clang xsltproc docbook-xsl-ns

Acropolis has not yet been ported to non-Unix-like environments, and will install
as shared libraries and on macOS rather than a framework.

Much of it ought to build inside Cygwin on Windows, but this is untested.

[Contributions](#contributing) for building properly with Visual Studio or
Xcode, and so on, are welcome (provided they do not significantly
complicate the standard build logic).

## Using Acropolis

Once you have built and installed the Acropolis stack, you probably want to do something with it.

Acropolis consists of a number of different individual components, including
libraries, command-line tools, web-based servers, and back-end daemons. They
are:—

* [liburi](https://github.com/bbcarchdev/liburi): a library for parsing URIs
* [libsql](https://github.com/bbcarchdev/libsql): a library for accessing SQL databases
* [liblod](https://github.com/bbcarchdev/liblod): a library for interacting with [Linked Data](http://linkeddata.org) servers
* [libmq](https://github.com/bbcarchdev/libmq): a library for interacting with message queues
* [libcluster](https://github.com/bbcarchdev/libcluster): a library for implementing load-balancing clusters
* [libawsclient](https://github.com/bbcarchdev/libawsclient): a library for access services which use [Amazon Web Services authentication](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html)

* [Anansi](https://github.com/bbcarchdev/anansi): a web crawler
* [Twine](https://github.com/bbcarchdev/twine): an RDF workflow engine
* [Quilt](https://github.com/bbcarchdev/quilt): a Linked Data web server (via FastCGI)
* [Spindle](https://github.com/bbcarchdev/spindle): a Linked Data indexing engine

* [`twine-anansi-bridge`](https://github.com/bbcarchdev/twine-anansi-bridge): a plug-in module for Twine which allows it to retrieve resources for processing from Anansi’s cache

Note that this repository exists for development and testing purposes *only*: in
a production environment, each component is packaged and deployed individually.

### Components

#### Anansi

Anansi is a web crawler. It uses a relational database to track URLs that will be fetched, their status, and cache IDs. Anansi can operate in resizeable clusters of up to 256 nodes via [libcluster](https://github.com/bbcarchdev/libcluster).

Anansi has the notion of a *processor* —a named implementation of the "business logic" of evaluating resources that have been retrieved and using them to add new entries to the queue.

In the Research & Education Space, Anansi is configured to use the `lod` (Linked Open Data) processor, which:

* Only accepts resources which can be parsed by `librdf`
* Can apply licensing checks (based upon a configured list)
* Adds any URIs that it finds in retrieved RDF to the crawl queue (allowing spidering to actually occur)

#### Twine

Twine is a modular RDF-oriented processing engine. It can be configured to do a number of different things, but its main purpose is to fetch some data, convert it if necessary, perform some processing, and then put it somewhere.

Twine can operate as a daemon, which will continuously fetch data to process from a queue of some kind (see [libmq](https://github.com/bbcarchdev/libmq)), or it can be invoked from the command-line to ingest data directly from a file.

Twine is extended through two different kinds of loadable modules (which reside in `${libdir}/twine`, by default `/opt/res/lib/twine`):

* *Handlers* are responsible for taking some input and populating an RDF model based upon it. The mechanism is flexible enough to allow, for example, the input data to be a set of URLs which the module should fetch and parse, but it's also used for data conversion.
* *Processors* are modules which can manipulate the RDF model in some way, including dealing with storage and output.

Twine ships with a number of modules for interacting with SPARQL servers, XML data ingest via XSLT transform, as well as parsing and outputting RDF. More information can be found in the [Twine README](https://github.com/bbcarchdev/twine#plug-ins).

Twine is always configured with a *workflow*: a list of processors which should be invoked in turn for each item of data being processed. Like all configuration options, the workflow can be specified on the command-line.

In the Research & Education Space, the [Spindle](#spindle) project provides additional Twine modules which implement the key logic of the platform.

#### Quilt

Quilt is a Linked Data server designed to efficiently serve RDF data in a variety of serialisations, including templated HTML. Like Twine, Quilt is modular (see `${libdir}/quilt`), and in particular modules are used to provide *engine* implementations—these are the code responsible for populating an RDF model based upon the request parameters (Quilt itself then handles the serving of that model). The [Spindle](#spindle) project includes a Quilt module which implements the Research & Education Space public API.

#### Spindle

[Spindle](https://github.com/bbcarchdev/spindle) is the core of the Research & Education Space. It includes three processor modules for [Twine](#twine):

* `spindle-strip` uses a [rulebase](#the-rulebase) to decide which triples in an RDF model should be retained and which should be discarded.
* `spindle-correlate` processes graphs in conjunction with a SPARQL server (and optionally a PostgreSQL database) in order to aggregate *co-references*: the result is distinct RDF descriptions about the same things are clustered together.
* `spindle-generate` performs indexing of RDF data, including dealing with media resource licensing, and is responsible for generating "proxy" sets of triples which summarise the Research & Education Space's interpretation of the various pieces of source data about each thing they describe.

It also includes a module for [Quilt](#quilt), which uses the data from `spindle-correlate` and `spindle-generate` in order to provide the Research & Education Space API.

### Running the stack

Annotated configuration files are provided in the [`config`](config) directory which should help get you started. By default, the components expect to find these files in `/opt/res/etc`, but this can be altered by specifying the `--prefix` or `--sysconfdir` options when invoking the top-level `configure` script.

#### Requirements

You will need:

* A PostgreSQL database server, with databases for Anansi and Spindle (you do not need to define any tables or views, the schemas will be generated automatically)
* A [RADOS](http://docs.ceph.com/docs/master/rados/) or [FakeS3](https://github.com/jubos/fake-s3) bucket for Anansi and one for Spindle. Note that pending resolution of [`libawsclient#1`](https://github.com/bbcarchdev/libawsclient/issues/1), you can no longer use a real Amazon S3 bucket for storage.
* A SPARQL server, such as [4store](https://github.com/4store/4store).

In production, the Research & Education Space uses PostgreSQL, RADOS, and 4store. It has been successfully used in development environments with FakeS3 and alternative SPARQL servers.

#### Running Anansi

**Important!** Do not run the Anansi daemon (`crawld`) without first carefully checking the configuration to ensure that it doesn’t simply start crawling the web unchecked. If you're using the `lod` engine, you can enforce restrictions 

Anansi will use the PostgreSQL database you provide it to store the queue and cache state, and either an "S3" bucket (see above) or a filesystem path as a cache store, which will contain both metadata and the actual content of retrieved resources.

Once configured, you can invoke `crawld -t <URI>` to perform a single fetch of a URI that you specify. Depending upon the processor and the resource itself, this may cause other URIs to be added to the crawler queue in the database, but the `-t` option will cause the `crawld` process will exit once the URI specified on the command-line has been fetched.

#### Running Twine

Twine itself can be configured in many different ways, but in the Research & Education Space, there are two kinds of Twine instance:

* *Correlate* instances, which ingest RDF, updating an index of co-references in the PostgreSQL database, and storing the RDF in 4store.
* *Generate* instances, which processes items whose data has been recently been updated by the Correlate process (i.e., the Spindle PostgreSQL database is used as the queue), and updates indexes in the PostgreSQL database and storing N-Quads serialisations of the data about each things in the S3 bucket for Quilt to use.

For development and testing, the easiest way to emulate the production configuration is to have two Twine configurations, one for each of the two instance types. You can then run the Twine *daemon* in the background performing the "generate" tasks, while invoking the Twine command-line utility using the *correlate* configuration to process N-Quads files on disk.

Based upon the [sample configuration files](config), you should be able to do something like this:

	$ sudo /opt/res/sbin/twine-writerd -c /opt/res/etc/twine-generate.conf
	$ /opt/res/bin/twine -c /opt/res/etc/twine-correlate.conf some-data.nq

Note that using `sudo` isn't required if the `twine-writerd` PID file can be written as an unprivileged user.

### Inside Acropolis

Information about the design of the stack, its principles of operation, and how
to use the Research & Education Space can be found in our book for developers
and collection-holders, [Inside Acropolis](https://bbcarchdev.github.io/inside-acropolis/).

The live production API endpoint for the Research & Education Space can
be found at http://acropolis.org.uk/

## Bugs and feature requests

If you’ve found a bug, or have thought of a feature that you would like to
see added, you can [file a new issue](https://github.com/bbcarchdev/acropolis/issues). A member of the development team will triage it and add it to our internal prioritised backlog for development—but in the meantime we [welcome contributions](#contributing) and [encourage forking](https://github.com/bbcarchdev/acropolis/fork).

## Building from source

You will need git, automake, autoconf and libtool. Also see the [Requirements](#requirements)
section.

    $ git clone git://github.com/bbcarchdev/acropolis.git
    $ cd acropolis
    $ git submodule update --init --recursive
    $ autoreconf -i
    $ ./configure --prefix=/some/path --enable-debug
    $ make
    $ make check
    $ sudo make install

If you don’t specify an installation prefix to `./configure`, it will default to `/opt/res`.

**Important**: The Acropolis repository incorporates its various components as
[Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), which
means that each subdirectory will point to a specific commit. This allows
us to ensure that a fresh clone of the repository points to a stable set of
commit. 

However, if you are using this tree to modify or maintain Acropolis, you will
probably want to track the `develop` branches in each submodule instead of the
stable commit pointed to by default.

You can do this yourself by invoking `git fetch origin develop:develop && git checkout develop`
in each submodule, or if you have already configured the tree, you can attempt
`make checkout`, which will *attempt* to do the same thing automatically.

### When to re-run `autoreconf`

If any of the following occur, either through your own changes, or because a
`git pull` or `git checkout` caused them, you should re-run `autoreconf -i`
in the affected parts of the tree (directories or parent directories which
contain a `configure.ac`), or from the top-level:—

* Any files in the `m4` subdirectories are modified
* Any `Makefile.am` files are modified
* Any `configure.ac` files are modified
* Any `*.m4` files are modified
* Directories are added or removed

### Re-building part of the tree

The Automake-based build logic is designed to allow you to rebuild almost any part of
the tree whenever you need to: if you are just working on [Quilt](https://github.com/bbcarchdev/quilt),
for example, you may find yourself making and testing changes almost exclusively
within the `quilt` subdirectory for the duration of that work.

If you know your build logic changes are restricted to one particular submodule,
you can change into the submodule directory and run the following:

    quilt $ autoreconf -i && ./config.status --recheck && make clean
    quilt $ make

## Automated builds

We have configured [Travis](https://travis-ci.org/bbcarchdev/acropolis) to automatically build and invoke the tests on the stack for new commits on each branch. See [`.travis.yml`](.travis.yml) for the details.

You may wish to do similar for your own forks, if you intend to maintain them.

## Contributing

If you’d like to contribute to Acropolis, [fork this repository](https://github.com/bbcarchdev/acropolis/fork) and commit your changes to the
`develop` branch.

For larger changes, you should create a feature branch with
a meaningful name, for example one derived from the [issue number](https://github.com/bbcarchdev/acropolis/issues/).

Once you are satisfied with your contribution, open a pull request and describe
the changes you’ve made and a member of the development team will take a look.

## Information for BBC Staff

This is an open source project which is actively maintained and developed
by a team within Design and Engineering. Please bear in mind the following:—

* Bugs and feature requests **must** be filed in [GitHub Issues](https://github.com/bbcarchdev/acropolis/issues): this is the authoratitive list of backlog tasks.
* Issues with the label [triaged](https://github.com/bbcarchdev/acropolis/issues?q=is%3Aopen+is%3Aissue+label%3Atriaged) have been prioritised and added to the team’s internal backlog for development. Feel free to comment on the GitHub Issue in either case!
* You should never add nor remove the *triaged* label to yours or anybody else’s Github Issues.
* [Forking](https://github.com/bbcarchdev/acropolis/fork) is encouraged! See the “[Contributing](#contributing)” section.
* Under **no** circumstances may you commit directly to this repository, even if you have push permission in GitHub.
* If you’re joining the development team, contact *“Archive Development Operations”* in the GAL to request access to GitLab (although your line manager should have done this for you in advance).

Finally, thanks for taking a look at this project! We hope it’ll be useful, do get in touch with us if we can help with anything (*“RES-BBC”* in the GAL, and we have staff in BC and PQ).

## License

Copyright © 2017 [BBC](http://www.bbc.co.uk/)

The majority of the Acropolis stack is licensed under the terms of the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

However, see the documentation within individual submodules for exceptions
to this and information about third-party components which have been
incorporated into the tree.

[travis]: https://img.shields.io/travis/bbcarchdev/acropolis.svg
[license]: https://img.shields.io/badge/license-Apache%202.0-blue.svg
[language]: https://img.shields.io/badge/implemented%20in-C-yellow.svg 
[twitter]: https://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Follow%20@RES_Project
