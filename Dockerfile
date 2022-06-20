FROM debian:latest
RUN apt update
RUN apt update
RUN apt install -y \
libavutil-dev \
libavformat-dev \
libavcodec-dev \
libmicrohttpd-dev \
libjansson-dev \
libssl-dev \
libsofia-sip-ua-dev \
libglib2.0-dev \
libopus-dev \
libogg-dev \
libcurl4-openssl-dev \
liblua5.3-dev \
libconfig-dev \
libusrsctp-dev \
libwebsockets-dev \
libnanomsg-dev \
librabbitmq-dev \
pkg-config \
gengetopt \
libtool \
automake \
build-essential \
wget \
git \
gtk-doc-tools \
cmake
WORKDIR /usr/local/src
RUN wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz && tar xfv v2.3.0.tar.gz && cd libsrtp-2.3.0 && ./configure --prefix=/usr --enable-openssl && make shared_library && make install
RUN apt install -y meson
RUN git clone https://gitlab.freedesktop.org/libnice/libnice && cd libnice && meson --prefix=/usr build && ninja -C build && ninja -C build install
RUN git clone https://github.com/sctplab/usrsctp && cd usrsctp && ./bootstrap && ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 && make && make install
RUN git clone https://libwebsockets.org/repo/libwebsockets && \
cd libwebsockets && \
mkdir build && cd build && \
cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
make && make install
RUN git clone https://github.com/eclipse/paho.mqtt.c.git && \
cd paho.mqtt.c && make && make install
RUN git clone https://github.com/meetecho/janus-gateway.git && \
cd janus-gateway && \
sh autogen.sh && \
./configure --prefix=/opt/janus --enable-post-processing && \
make && make install && make configs

EXPOSE 10000-10200/udp
EXPOSE 8188
EXPOSE 8088
EXPOSE 8089
EXPOSE 8889
EXPOSE 8000
EXPOSE 7088
EXPOSE 7089

ENTRYPOINT ["/opt/janus/bin/janus -r 10000-10200"]