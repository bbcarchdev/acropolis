locale-gen en_GB.UTF-8
export DEBIAN_FRONTEND=noninteractive

sed -i 's/httpredir.debian.org/mirror.vorboss.net/g' /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9E16A4D302DA096A && \

#echo "deb [arch=amd64] http://apt.bbcarchdev.net/debian/ wheezy main ports live stage dev" \
#  >> /etc/apt/sources.list.d/bbcarchdev-wheezy.list

# Install additional tools for some debugging, running the remote, etc
apt-get -y update && apt-get install -y --no-install-recommends \
  python3 python3-psycopg2 netcat netcat-traditional vim mc ngrep \
  procps tcpdump supervisor postgresql-client git

apt-get -y install libcunit1-ncurses-dev \
  gdb \
  valgrind

#################################################
# Install Apache for running Quilt
#################################################

# Install Apache
apt-get -y update && apt-get install -y --no-install-recommends \
  apache2 libapache2-mod-fcgid

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
 apt-get -y update && apt-get install -y --no-install-recommends \
   build-essential libtool libltdl-dev automake \
   autoconf pkg-config libcurl4-gnutls-dev autotools-dev \
   libraptor2-dev librasqal3-dev librdf0-dev libfcgi-dev \
   libjansson-dev libxml2-dev libssl-dev \
   flex gettext python-libxml2 libpq-dev libmysqlclient-dev \
   uuid-dev libncurses5-dev libedit-dev \
   && rm -rf /var/lib/apt/lists/*


