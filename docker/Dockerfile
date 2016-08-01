# Derived from https://hub.docker.com/r/antonyh/cucumber/~/dockerfile/ 
FROM ruby
MAINTAINER Christophe Gueret <christophe.gueret@bbc.co.uk>

# Prepare apt-get and install stuff we'll need
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y --no-install-recommends git wget netcat \
	netcat-traditional openssh-client

# Install Phantomjs
ENV PHANTOMJS_VERSION 2.1.1
RUN apt-get install -y libfreetype6 libfontconfig bzip2 && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 \
  https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs

# Install CasperJS
RUN git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs

# Clean apt-get
RUN apt-get autoremove -y && apt-get clean all && rm -rf /var/lib/apt/lists/*

# Install additional dependencies for Ruby
RUN gem install cucumber phantomjs bundler capybara selenium-webdriver\
  poltergeist rspec pry capybara-screenshot

# Define mount points and working directory
VOLUME ["/data"]
WORKDIR /data
COPY . /data

# Copy the run.sh that will be used to wait until Acropolis is up
COPY run.sh /
ENTRYPOINT ["/run.sh"]

# Run cucumber
CMD ["cucumber"]