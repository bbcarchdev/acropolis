# Updating components and reconfiguring

From time to time you may wish to update individual components without
necessarily using `git submodule --update --recursive`. For example, because
you are working on a feature branch within a specific component.
Generally, you can do this without re-configuring the whole tree (which can
be time-consuming).

Remember that by default, submodules are *not checked out on any branch*; that
is, the `HEAD` points only to the specific commit tracked by the parent
project. A quick way to tell is if `git symbolic-ref HEAD` reports something
beginning with `refs/heads/...`, then you have already checked out a branch.

(You may find it useful to put something like this in your shell's
`$PROMPT_COMMAND`, or equivalent, so that you can always tell quickly
whether the current working directory is on a branch, and which branch it is).

If you're not currently working on a branch, or working on the wrong branch,
you can fetch it and check it out with:

```
$ git fetch origin branchname:branchname
$ git checkout branchname
```

Once checked out, or if you have made modifications to `configure.ac`,
the contents of the `m4` submodule, or any of the `Makefile.am` files, you
can re-configure within the specific project by running:

```
$ autoreconf -i
$ ./config.status --recheck
```

When you next run `make`, any build system files which need to be updated
will be, preserving the parameters and important environment variables that
you passed to the root `configure` script.

Note that if things have changed significantly between the
originally-configured version and the new one, or if you need to re-configure
with different options, you may need to re-run `configure` (possibly preceded
by `autoreconf -i`) from the root and re-run `make`. While dependency-tracking
should take proper care of rebuilding the correct files in this situation,
if you run into problems it's usually worth trying `make clean && make` to
confirm the problem wasn't due to left-over files before reporting bugs.

# Dependencies

On Debian-based systems, you can install packaged versions of the dependencies with:

    $ sudo apt-get install build-essential libtool libltdl-dev automake \
        autoconf pkg-config libcurl4-gnutls-dev autotools-dev \
        libraptor2-dev librasqal3-dev librdf0-dev libfcgi-dev \
        libjansson-dev gtk-doc-tools xsltproc libxml2-dev libssl-dev \
        cmake flex itstool docbook-xml docbook-xsl docbook-xsl-ns \
        gettext python-libxml2 libpq-dev libmysqlclient-dev \
        libqpid-proton-dev uuid-dev libncurses5-dev libedit-dev

## Compiler toolchain

On Debian-based systems, you can install the `build-essential` package.

On Mac OS X, simply type `clang` in a Terminal window, and if the command-line tools have not yet been installed, you will be asked if you'd like to download and install them.

It should be possible to build the stack without the Mac OS X command-line tools package if you have an up-to-date version of Xcode installed (or perform a build targetting a specific SDK, via the `--with-sdk=NAME` option to `configure`), but this has not been extensively tested.

Building a toolchain manually is beyond the scope for this document.

## PostgreSQL and MySQL client libraries

You are *strongly* encouraged to install binary packages for your operating
system rather than building from source.

On Debian-based systems, you can install the `libpq-dev` and `libmysqlclient-dev` packages.

On Mac OS X, after installing the pre-packaged versions, you should ensure that `/Library/PostgreSQL/VERSION/bin` and `/usr/local/mysql/bin` are in your `PATH` (so that build scripts can locate `pg_config` and `mysql_config`).

Building PostgreSQL and MySQL manually is beyond the scope of this document.

## Autoconf

    # On Mac OS X only:
    $ sed -i -e "s/'libtoolize';$/'glibtoolize';/;" bin/autoreconf.in
    
    # On all platforms:
    $ ./configure
    $ make
    $ sudo make install

## GNU Libtool

On Debian-based systems, you can install the `libtool` and `libltdl-dev` packages.


    # On Mac OS X only:
    $ ./configure --program-prefix=g
    
    # On other platforms:
    $ ./configure
    
    # On all platforms:
    $ make
    $ sudo make install
 
## Automake

    $ ./configure
    $ make
    $ sudo make install

## OpenSSL

On Debian-based systems, you can install the `libssl-dev` package.

For Mac OS X users, note that recent versions of the operating system have deprecated the bundled OpenSSL and Mac OS X 10.11 (El Capitan) removes it from the SDK altogether (although a version of the libraries is still present on the system for binary compatibility). You should download and build build from source if you're running, or planning to run, Mac OS X 10.10 (Yosemite) or newer. On other systems, it’s *highly* recommended that you install
the pre-packaged version of OpenSSL.

Note also that on Mac OS X, OpenSSL is no longer required by Acropolis components themselves, as Apple’s CommonCrypto APIs will be used instead where available, but other packages (such as `libqpid-proton`) do require it.

To build from source:

    # On Mac OS X only:
	$ ./Configure darwin64-x86_64-cc --prefix=/usr/local --openssldir=/usr/local/share/openssl shared
	
	# On other systems:
	$ ./config --prefix=/usr/local --openssldir=/usr/local/share/openssl
	
	# On all platforms:
	$ make
	$ sudo make install

## pkg-config

The `pkg-config` utility is used by the build system to locate different components. Generally, you should use your operating system's provided packages if they exist.

On Debian-based systems you can install the `pkg-config` package.

To install manually:

Download the latest `pkg-config` package (e.g., `pkg-config-0.28.tar.xz`) from the [pkg-config source package repository](http://pkgconfig.freedesktop.org/releases/). Unpack the sources, which will create a `pkg-config-VERSION` directory (for example, `pkg-config-0.28`); change to this directory, and execute the following:

    $ ./configure --with-internal-glib
    $ make
    $ sudo make install

## GNU Bison 3.x

Raptor requires [GNU Bison](http://www.gnu.org/software/bison/) 3.0.0 or newer to build from source. Some systems only ship with older versions.

To build manually:

Download the latest `bison` package (e.g., `bison-3.0.4.tar.xz`) from the [Bison source package repository](http://ftp.gnu.org/gnu/bison/). Unpack the sources, which will create a `bison-VERSION` directory (for example, `bison-3.0.4`); change to this directory and execute the following:

    # If you already have a system-provided version of bison that you want
    # to remain the default, you can install the new version as bison3:
    $ ./configure --program-suffix=3
    
    # Otherwise, you can simply use:
    $ ./configure
    
    $ make
    $ sudo make install

If you already have a system-provided version of bison that you want to remain the default, you can rename the installed copy of `bison` to `bison3`:

    $ cd /usr/local/bin 
    $ sudo mv bison bison3

## Flex

[Flex](http://flex.sourceforge.net) is required if building Raptor from source in maintainer mode.

On Debian-based systems, you can install the `flex` package.

To build manually:

    # On Mac OS X only:
    $ sed -i -e 's/-no-undefined//;' Makefile.in
    
    # On all platforms:
    $ ./configure
    $ make
    $ sudo make install

## GNU gettext

You only need to install [GNU gettext](https://www.gnu.org/software/gettext/) if you are building `gtk-doc` from source.

On Debian-based systems, you can install the `gettext` package.

To build manually:

Download `gettext-latest.tar.xz` from the [GNU gettext distribution repository](http://ftp.gnu.org/pub/gnu/gettext/).
Unpack the sources, which will create a `gettext-VERSION` directory (for example, `gettext-0.19.4`); change to this directory, and execute the following:

    $ ./configure
    $ make
    $ sudo make install

## libxml2 Python Bindings

You will need to have the `libxml2` Python bindings installed in order to build `itstool`.

You only need to install this if you are building `gtk-doc` (and in particular `itstool`) from source.

On Debian-based systems, you can install the `python-libxml2` package.

To build manually:

Use `xml2-config` to find out the current version of libxml2. [Download the corresponding source package](http://xmlsoft.org/sources/). For example, on Mac OS X 10.10 (Yosmite), you would download `libxml2-2.9.0.tar.gz`. Once downloaded, extract the tarball and change into the `python` directory within the `libxml-2.9.0` directory, and execute:

    $ sudo python2.6 setup.py build install clean
    $ sudo python2.7 setup.py build install clean

## ITS Tool

[ITS Tool](http://itstool.org) is required to build `gtk-doc` from source. It
depends upon the libxml2 Python Bindings.

On Debian-based systems, you can install the `itstool` package.

To build manually:

Download `itstool-2.0.2.tar.bz2` from the [ITS Tool website](http://itstool.org/download/). Extract the tarball, change to the `itstool-2.0.2` directory, and execute:

    $ ./configure
    $ make
    $ sudo make install

`itstool` will be installed in `/usr/local/bin/itstool`

## DocBook-XML 4.3 DTD

You only need to install this if you are building `gtk-doc` from source.

On Debian-based systems, you can install the `docbook-xml` package.

To install manually:

Download `docbook-xml-4.3.zip` from [the DocBook website](http://www.docbook.org/xml/4.3/). Execute the following in the download directory:

    $ mkdir docbook-4.3
    $ cd docbook-4.3
    $ unzip ../docbook-xml-4.3.zip
    $ cd ..
    $ sudo mkdir -p /usr/local/share/xml
    $ sudo mv docbook-4.3 /usr/local/share/xml
    $ sudo chown -R 0:0 /usr/local/share/xml/docbook-4.3
    $ sudo mkdir -p /etc/xml
    $ test -f /etc/xml/catalog || sudo xmlcatalog --noout --create /etc/xml/catalog
    $ sudo xmlcatalog --noout -add delegatePublic '-//OASIS//DTD DocBook XML V4.3//EN' /usr/local/share/xml/docbook-4.3/catalog.xml /etc/xml/catalog

## DocBook XSL stylesheets (for DocBook 4)

You only need to install these if you are building `gtk-doc` from source.

On Debian-based systems, you can install the `docbook-xsl` package.

To install manually:

Download `docbook-xsl-1.78.1.tar.bz2` from [the DocBook SourceForge project page](http://sourceforge.net/projects/docbook/files/docbook-xsl/1.78.1/). Unpack the archive, which will create a `docbook-xsl-1.78.1` directory, and execute the following:

    $ sudo mkdir -p /usr/local/share/xsl
    $ sudo mv docbook-xsl-1.78.1 /usr/local/share/xsl
    $ sudo chown -R 0:0 /usr/local/share/xsl/docbook-xsl-1.78.1
    $ sudo xmlcatalog --noout --add delegateURI 'http://docbook.sourceforge.net/release/xsl/' /usr/local/share/xsl/docbook-xsl-1.78.1/catalog.xml /etc/xml/catalog

## Namespaced DocBook XSL stylesheets (for DocBook 5)

These are required in order to generate manual pages 

On Debian-based systems, you can install the `docbook-xsl-ns` package.

To install manually:

Download `docbook-xsl-ns-1.78.1.tar.bz2` from [the DocBook SourceForge project page](http://sourceforge.net/projects/docbook/files/docbook-xsl/1.78.1/). Unpack the archive, which will create a `docbook-xsl-ns-1.78.1` directory, and execute the following:

    $ sudo mkdir -p /usr/local/share/xsl
    $ sudo mv docbook-xsl-ns-1.78.1 /usr/local/share/xsl
    $ sudo chown -R 0:0 /usr/local/share/xsl/docbook-xsl-ns-1.78.1
    $ sudo xmlcatalog --noout --add delegateURI 'http://docbook.sourceforge.net/release/xsl-ns/' /usr/local/share/xsl/docbook-xsl-ns-1.78.1/catalog.xml /etc/xml/catalog

## gtk-doc

You only need to install this if Raptor complains that `gtkdocize` is missing. `gtk-doc` requires `itstool`, the DocBook-XML 4.3 DTD, the DocBook XSL stylesheets and GNU gettext (instructions below).

On Debian-based systems, you can install the `gtk-doc-tools` package.

To build manually:

Download the latest `gtk-doc` package (e.g., `gtk-doc-1.24.tar.xz`) from the [gtk-doc source package repository](https://download.gnome.org/sources/gtk-doc/). Unpack the sources, which will create a `gtk-doc-VERSION` directory (for example, `gtk-doc-1.24`); change to this directory, and execute the following:

    $ ./configure
    $ make
    $ sudo make install

## Raptor

Raptor may depend upon `bison`, `flex` and `gtkdocize` (instructions for each are below); if you are building from source it is recommended that you try configuring the downloaded sources, and only install the dependencies if configuration fails.

On Debian-based systems you can install the `libraptor2-0` and `libraptor2-dev` packages.

To install manually:

Download the latest `raptor2-VERSION.tar.gz` package (e.g., `raptor2-2.0.15.tar.gz`) from the [librdf source package repository](http://download.librdf.org/source/). Unpack the sources, which will create a `raptor2-VERSION` directory (for example, `raptor2-2.0.15`); change to this directory, and execute the following:

    $ ./configure
    $ make
    $ sudo make install

## Rasqal

On Debian-based systems you can install the `librasqal3` and `librasqal3-dev` packages.

To install manually:

Download the latest `rasqal-VERSION.tar.gz` package (e.g., `rasqal-0.9.33.tar.gz`) from the [librdf source package repository](http://download.librdf.org/source/). Unpack the sources, which will create a `rasqal-VERSION` directory (for example, `rasqal-0.9.33`); change to this directory, and execute the following:

    $ ./configure
    $ make
    $ sudo make install

## Redland (librdf)

On Debian-based systems you can install the `librdf0` and `librdf0-dev` packages.

*Note:* if you find that Twine is unable to locate any contexts (named graphs) in parsed RDF, it may be that the version of librdf you have installed is too old. If you've installed the latest packaged version, you may need to build from a [clone of the librdf Git repository](https://github.com/dajobe/librdf).

To build manually:

Download the latest `redland-VERSION.tar.gz` package (e.g., `redland-1.0.17.tar.gz`) from the [librdf source package repository](http://download.librdf.org/source/). Unpack the sources, which will create a `redland-VERSION` directory (for example, `redland-1.0.17`); change to this directory, and execute the following:

    $ ./configure --with-virtuoso=no
    $ make
    $ sudo make install

## Jansson

On Debian-based systems, you can install the `libjansson-dev` package.

    $ ./configure
    $ make
    $ sudo make install

## FastCGI (libfcgi)

On Debian-based systems, you can install the `libfcgi-dev` package.

    $ ./configure
    $ make
    $ sudo make install

## CMake

CMake is required to build `qpid-proton`.

On Debian-based systems, you can install the `cmake` package.

On Mac OS X, download the [CMake disk image](http://www.cmake.org/download/) and drag the CMake app to `/Applications`. Then, in a Terminal, execute:

    $ for i in /Applications/CMake.app/Contents/bin/cmake* ; do sudo ln -s $i /usr/local/bin/ ; done

## qpid-proton

Building `qpid-proton` requires CMake.

On Debian-based systems, you can install `libqpid-proton-dev`.

    $ mkdir build
    $ cd build
    
    # The -DNOBUILD_JAVA=1 command-line option can be omitted if you have a 
    # working Java setup -- it is not required to build the Research & Education
    # Space, however.
    $ cmake .. -DNOBUILD_JAVA=1 -DCMAKE_OSX_ARCHITECTURES=x86_64
    
    # With newer versions of qpid-proton, you must specify -DBUILD_JAVA=0 instead of
    # -DNOBUILD_JAVA=1: if CMake reports that NOBUILD_JAVA was a "manually-specified
    # variable not used by the project", when executing the above, then run the
    # following instead:
    $ cmake .. -DBUILD_JAVA=0 -DCMAKE_OSX_ARCHITECTURES=x86_64
    
    $ make
    
    # On Mac OS X, execute the following command:
    $ sudo ln -s /usr/local/lib /usr/local/lib64
    
    # On all platforms:
    $ sudo make install
   