# Introduction

This project contains a complete buildable version of the [Research & Education Space](https://bbcarchdev.github.io/res/) stack, _Acropolis_.

The Research & Education Space is a platform being jointly delivered by [Jisc](http://www.jisc.ac.uk), the [British Universities Film & Video Council](http://bufvc.ac.uk) (BUFVC), and the [BBC](http://www.bbc.co.uk) with the aim of bringing as much as possible of the UK’s publicly-held archives, and more besides, to learners and teachers across the UK.

While not typically built and deployed as a single package, we have assembled this project to make it easier to experiment with the stack.

# Building the Research & Education Space stack

To build from a `git` clone, first ensure that all submodules have been checked out:

    $ git submodule update --init --recursive

You should install the various dependencies that the different components require. Unless you need to, or really know what you're doing, you should probably install versions that are pre-packaged for your operating system. Instructions for each of the dependencies are in the following section.

Next, use `autoreconf` to generate the `configure` scripts:

    $ autoreconf -i

Now, configure the project:

    $ ./configure

By default, the installation prefix will be `/opt/res` (this is to allow this project to be safely built and installed without conflicting with any individually-installed components of the stack), but if you'd prefer to install to somewhere else, such as `/usr/local`, you can pass an option to `configure` to specify that:

    $ ./configure --prefix=/usr/local

If you want to build debugging versions of components (i.e., compiler optimisations are reduced and debugging symbols are not stripped from compiled binaries), pass `--enable-debug`, e.g.:

    $ ./configure --prefix=/usr/local --enable-debug

If all goes well, all of the components will be configured and ready to build. To compile them, simply run `make`:

    $ make

Assuming no errors occur, you can now install it with:

    $ sudo make install

# Dependencies

On Debian-based systems, you can install packaged versions of the dependencies with:

    $ sudo apt-get install build-essential libtool libltdl-dev automake \
	    autoconf pkg-config libcurl4-openssl-dev autotools-dev \
		libraptor2-dev librasqal3-dev librdf0-dev libfcgi-dev \
		libjansson-dev gtk-doc-tools xsltproc libxml2-dev libssl-dev \
		cmake flex itstool docbook-xml docbook-xsl docbook-xsl-ns \
		gettext python-libxml2 libpq-dev libmysqlclient-dev \
		libqpid-proton-dev

## Compiler toolchain

On Debian-based systems, you can install the `build-essential` package.

On Mac OS X, simply type `clang` in a Terminal window, and if the command-line tools have not yet been installed, you will be asked if you'd like to download and install them.

It should be possible to build the stack without the Mac OS X command-line tools package if you have an up-to-date version of Xcode installed (or perform a build targetting a specific SDK, via the `--with-sdk=NAME` option to `configure`), but this has not been extensively tested.

Building a toolchain manually beyond the scope for this document.

## GNU Libtool

On Debian-based systems, you can install the `libtool` and `libltdl-dev` packages.


    # On Mac OS X only:
    $ ./configure --program-prefix=g
	
    # On other platforms:
    $ ./configure
	
    # On all platforms:
    $ make
    $ sudo make install
 
## Autoconf

    # On Mac OS X only:
	$ sed -i -e "s/'libtoolize';$/'glibtoolize';/;" bin/autoreconf.in
	
	# On all platforms:
	$ ./configure
	$ make
	$ sudo make install

## Automake

    $ ./configure
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

## qpid-proton

    $ mkdir build
    $ cd build
	# The -DNOBUILD_JAVA=1 command-line option can be omitted if you have a 
	# working Java setup -- it is not required to build the Research & Education
	# Space, however.
	$ cmake .. -DNOBUILD_JAVA=1
	$ make
	$ sudo ln -s /usr/local/lib /usr/local/lib64
	$ sudo make install

## CMake

On Debian-based systems, you can install the `cmake` package.

On Mac OS X, download the [CMake disk image](http://www.cmake.org/download/) and drag the CMake app to `/Applications`. Then, in a Terminal, execute:

    $ for i in /Applications/CMake.app/Contents/bin/cmake* ; do sudo ln -s $i /usr/local/bin/ ; done

## GNU Bison 3.x

Raptor requires [GNU Bison](http://www.gnu.org/software/bison/) 3.0.0 or newer to build from source. Some systems only ship with older versions.

To build manually:

* Download the latest `bison` package (e.g., `bison-3.0.4.tar.xz`) from the [Bison source package repository](http://ftp.gnu.org/gnu/bison/).
* Unpack the sources, which will create a `bison-VERSION` directory (for example, `bison-3.0.4`); change to this directory and execute the following:

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

## gtk-doc

You only need to install this if Raptor complains that `gtkdocize` is missing. `gtk-doc` requires `itstool`, the DocBook-XML 4.3 DTD, the DocBook XSL stylesheets and GNU gettext (instructions below).

On Debian-based systems, you can install the `gtk-doc-tools` package.

To build manually:

Download the latest `gtk-doc` package (e.g., `gtk-doc-1.24.tar.xz`) from the [gtk-doc source package repository](https://download.gnome.org/sources/gtk-doc/). Unpack the sources, which will create a `gtk-doc-VERSION` directory (for example, `gtk-doc-1.24`); change to this directory, and execute the following:

    $ ./configure
	$ make
	$ sudo make install

## ITS Tool

[ITS Tool](http://itstool.org) is required to build `gtk-doc` from source.

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

Download `docbook-xml-4.3.zip` from [the DocBook website](http://www.docbook.org/xml/4.3/). Unpack the ZIP into `/usr/local/share/xml/docbook-4.3`, and execute the following:

    $ sudo mkdir -p /etc/xml
	$ sudo xmlcatalog --noout --create /etc/xml/catalog
    $ sudo xmlcatalog --noout -add delegatePublic '-//OASIS//DTD DocBook XML V4.3//EN' /usr/local/share/xml/docbook-4.3/catalog.xml /etc/xml/catalog

## DocBook XSL stylesheets (for DocBook 4)

You only need to install these if you are building `gtk-doc` from source.

On Debian-based systems, you can install the `docbook-xsl` package.

To install manually:

Download `docbook-xsl-1.78.1.tar.bz2` from [the DocBook SourceForge project page](http://sourceforge.net/projects/docbook/files/docbook-xsl/1.78.1/). Unpack the archive, which will create a `docbook-xsl-1.78.1` directory, and execute the following:

    $ sudo mkdir -p /usr/local/share/xsl
	$ sudo mv docbook-xsl-1.78.1 /usr/local/share/xsl
	$ sudo xmlcatalog --noout --add delegateURI 'http://docbook.sourceforge.net/release/xsl/' /usr/local/share/xsl/docbook-xsl-1.78.1/catalog.xml /etc/xml/catalog

## Namespaced DocBook XSL stylesheets (for DocBook 5)

These are required in order to generate manual pages 

On Debian-based systems, you can install the `docbook-xsl-ns` package.

To install manually:

Download `docbook-xsl-ns-1.78.1.tar.bz2` from [the DocBook SourceForge project page](http://sourceforge.net/projects/docbook/files/docbook-xsl/1.78.1/). Unpack the archive, which will create a `docbook-xsl-ns-1.78.1` directory, and execute the following:

    $ sudo mkdir -p /usr/local/share/xsl
	$ sudo mv docbook-xsl-ns-1.78.1 /usr/local/share/xsl
	$ sudo xmlcatalog --noout --add delegateURI 'http://docbook.sourceforge.net/release/xsl-ns/' /usr/local/share/xsl/docbook-xsl-ns-1.78.1/catalog.xml /etc/xml/catalog

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

    $ sudo python setup.py build install
    $ sudo python setup.py clean
    $ sudo python2.6 setup build install
