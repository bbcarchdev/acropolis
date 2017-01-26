export DEBIAN_FRONTEND=noninteractive

cd /home/vagrant
git clone https://github.com/bbcarchdev/acropolis.git --recursive
cd acropolis
autoreconf -i --force \
  && ./configure --prefix=/usr --enable-debug --disable-docs \
  && make clean \
  && make \
  && make install

