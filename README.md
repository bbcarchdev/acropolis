# Introduction

This project contains a complete buildable version of the [Research & Education Space](https://bbcarchdev.github.io/res/) stack, _Acropolis_.

The Research & Education Space is a platform being jointly delivered by [Jisc](http://www.jisc.ac.uk), the [British Universities Film & Video Council](http://bufvc.ac.uk) (BUFVC), and the [BBC](http://www.bbc.co.uk) with the aim of bringing as much as possible of the UK’s publicly-held archives, and more besides, to learners and teachers across the UK.

While not typically built and deployed as a single package, we have assembled this project to make it easier to experiment with the stack.

# Building the Research & Education Space stack

To build from a `git` clone, first ensure that all submodules have been checked out:

    $ git submodule update --init --recursive

## Using autotools
You should install the various dependencies that the different components require. Unless you need to, or really know what you're doing, you should probably install versions that are pre-packaged for your operating system. Instructions for each of the dependencies are in `compile.md`.

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

## Using docker

You must have Docker and docker-compose installed. Then build the image:

    $ docker-compose build

# Running the Research & Education Space stack

The following assumes you built and installed the stack

## Using docker

You must have Docker and docker-compose installed. To run the stack do:

    $ docker-compose up
       
