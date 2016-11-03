#################################################
# Get some basic config sorted out
#################################################
FROM debian:wheezy
MAINTAINER Christophe Gueret <christophe.gueret@bbc.co.uk>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install additional tools for some debugging, running the remote, etc
RUN apt-get -y update && apt-get install -y --no-install-recommends \
	python3 python3-psycopg2 netcat netcat-traditional vim mc ngrep \
	procps tcpdump gdb supervisor postgresql-client\
	&& rm -rf /var/lib/apt/lists/*
	
	
#################################################
# Install Apache for running Quilt
#################################################

# Install Apache
RUN apt-get -y update && apt-get install -y --no-install-recommends \
	apache2 libapache2-mod-fcgid \
	&& rm -rf /var/lib/apt/lists/*
	
# Configure Apache to connect with Quilt FCGI and expose the port 80
ENV APACHE_RUN_USER	 www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR	 /var/log/apache2
ENV APACHE_PID_FILE	 /var/run/apache2.pid
ENV APACHE_RUN_DIR	 /var/run/apache2
ENV APACHE_LOCK_DIR	 /var/lock/apache2
RUN a2enmod rewrite
RUN a2enmod fcgid
EXPOSE 80


#################################################
# Acropolis
#################################################

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
WORKDIR /usr/local/src

# Compile everything
RUN autoreconf -i \
	&& ./configure --prefix=/usr --enable-debug --disable-docs \
	&& make clean \
	&& make \
	&& make install

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
	
#################################################
# Run the services
#################################################

# Set an entry script to wait until S3, Postgres and 4store are ready
ENTRYPOINT ["/usr/local/src/docker/run.sh"]

# Set the default working directory
WORKDIR /

# Do nothing by default
CMD ["tail", "-f", "/dev/null"]

