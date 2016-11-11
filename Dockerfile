#################################################
# Get some basic config sorted out
#################################################
FROM debian:wheezy
MAINTAINER Christophe Gueret <christophe.gueret@bbc.co.uk>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9E16A4D302DA096A && \
	echo "deb [arch=amd64] http://apt.bbcarchdev.net/debian/ wheezy main ports live stage dev" \
	>> /etc/apt/sources.list.d/bbcarchdev-wheezy.list

# Install additional tools for some debugging, running the remote, etc
RUN apt-get -y update && apt-get install -y --no-install-recommends \
	python3 python3-psycopg2 netcat netcat-traditional vim mc ngrep \
	procps tcpdump supervisor postgresql-client

RUN apt-get -y install libcunit1-ncurses-dev \
  gdb \
  valgrind

#################################################
# Install Apache for running Quilt
#################################################

# Install Apache
RUN apt-get -y update && apt-get install -y --no-install-recommends \
	apache2 libapache2-mod-fcgid

RUN rm -rf /var/lib/apt/lists/*

# Configure Apache to connect with Quilt FCGI and expose the port 80
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2
RUN a2enmod rewrite
RUN a2enmod fcgid
EXPOSE 80


#################################################
# Acropolis
#################################################

WORKDIR /usr/local/src

# Install dependencies
RUN apt-get -y update && apt-get install -y --no-install-recommends \
	build-essential libtool libltdl-dev automake \
	autoconf pkg-config libcurl4-gnutls-dev autotools-dev \
	libraptor2-dev librasqal3-dev librdf0-dev libfcgi-dev \
	libjansson-dev libxml2-dev libssl-dev \
	flex gettext python-libxml2 libpq-dev libmysqlclient-dev \
	uuid-dev libncurses5-dev libedit-dev \
	&& rm -rf /var/lib/apt/lists/*

# Copy the source tree
COPY . /usr/local/src
VOLUME ["/usr/local/src"]
VOLUME ["/data"]

# Compile everything
RUN autoreconf -i \
	&& ./configure --prefix=/usr --enable-debug --disable-docs \
	&& make clean \
	&& make \
	&& make install

#RUN make check

# Remove default configuration files and link to adjusted configuration
# files for the different components
RUN rm -f /usr/etc/twine.conf \
	&& rm -f /usr/etc/quilt.conf \
	&& rm -f /usr/etc/crawl.conf \
    && ln -s /usr/local/src/docker/crawl.conf /usr/etc/crawl.conf \
	&& ln -s /usr/local/src/docker/quilt.conf /usr/etc/quilt.conf \
	&& ln -s /usr/local/src/docker/twine.conf /usr/etc/twine.conf \
	&& ln -s /usr/local/src/docker/twine-anansi.conf /usr/etc/twine-anansi.conf \
	&& ln -s /usr/local/src/docker/supervisord.conf /etc/supervisor/conf.d/acropolis.conf

# Finish configuring Apache
RUN cp /usr/share/doc/quilt/apache2-example.conf /etc/apache2/sites-available/quilt \
	&& sed -i -e 's|data\.example\.com|localhost|' /etc/apache2/sites-available/quilt \
	&& a2dissite 000-default && a2ensite quilt
RUN	ln -sf /dev/stdout /var/log/apache2/quilt.access.log \
	&& ln -sf /dev/stderr /var/log/apache2/quilt.error.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log

# Expose the port used by the remote control
EXPOSE 8000

#################################################
# Run the services
#################################################

# Set an entry script to wait until S3, Postgres and 4store are ready
COPY docker /usr/local/src/
ENTRYPOINT ["/usr/local/src/docker/run.sh"]

# Do nothing by default
CMD ["tail", "-f", "/dev/null"]
