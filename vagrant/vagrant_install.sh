yum -y install epel-release 
yum repolist

yum -y install git

#######################################################################
# Install additional tools for some debugging, running the remote, etc
#######################################################################

# Need to find rpms later
#yum install \
#  git \
#  python36 \
#  python3-psycopg2 \
#  netcat \
#  netcat-traditional \
#  vim \
#  mc \
#  ngrep \
#  procps tcpdump supervisor postgresql-client

yum -y install \
  CUnit-devel.x86_64 \
  CUnit.x86_64 \
  gdb \
  valgrind \
  curl

#################################################
# Install Apache for running Quilt
#################################################

# Install Apache
yum -y install \
  httpd.x86_64 \
  httpd-devel.x86_64 \
  mod_fcgid.x86_64

export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_LOG_DIR=/var/log/apache2
export APACHE_PID_FILE=/var/run/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
a2enmod rewrite
a2enmod fcgid

#################################################
# Acropolis
#################################################

 # Install dependencies
yum -y groupinstall 'Development Tools'
yum -y install \
  automake \
  autoconf \
  flex \
  gettext \
  libtool-ltdl.x86_64 \
  libtool-ltdl-devel.x86_64 \
  pkgconfig.x86_64 \
  libcurl-devel.x86_64 \
  raptor2-devel.x86_64 \
  raptor2.x86_64 \
  rasqal-devel-0.9.30-4.el7.x86_64 \
  rasqal-devel.x86_64 \
  rasqal.x86_64 \
  redland.x86_64 \
  redland-devel.x86_64 \
  fcgi-devel.x86_64 \
  jansson.x86_64 \
  jansson-devel.x86_64 \
  libxml2.x86_64 \
  libxml2-devel.x86_64 \
  libxslt.x86_64 \
  libxslt-devel.x86_64 \
  openssl.x86_64 \
  openssl-libs.x86_64 \
  libxml2-python \
  libpqxx-devel.x86_64 \
  libpqxx.x86_64 \
  mariadb-devel.i686 \
  mariadb-devel.x86_64 \
  uuid.x86_64 \
  uuid-devel.x86_64 \
  libuuid.x86_64 \
  libuuid-devel.x86_64 \
  ncurses.x86_64 \
  ncurses-devel.x86_64 \
  libedit-devel.x86_64 \
  libedit.x86_64
