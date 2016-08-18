FROM phusion/baseimage:0.9.19

ENV STEEMD_REV master

ARG UBUNTU_MIRROR=mirror://mirrors.ubuntu.com/mirrors.txt
ARG STEEMD_REPO=https://github.com/steemit/steem.git

RUN sed -i \
    -e s#http://archive.ubuntu.com/ubuntu/#${UBUNTU_MIRROR}#g \
    -e s#http://security.ubuntu.com/ubuntu/#${UBUNTU_MIRROR}#g \
        /etc/apt/sources.list ; \
        cat /etc/apt/sources.list

RUN \
    apt-get update && \
    apt-get install -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        cmake \
        git \
        libboost-chrono-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libevent-dev \
        libminiupnpc-dev \
        libssl-dev \
        libtool \
        libzmq3-dev \
        libzmq5 \
        pkg-config \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    git clone $STEEMD_REPO /usr/local/src/steem && \
    cd /usr/local/src/steem && \
    git checkout $STEEMD_REV && \
    ./autogen.sh && \
    ./configure --enable-hardening && \
    make -j2 && \
    make install && \
    cd / && \
    rm -rf /usr/local/src/steem

RUN \
    apt-get remove -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        git \
        libtool \
        pkg-config \
    && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /var/lib/steemd
RUN useradd -s /bin/bash -m -d /var/lib/steemd steemd
RUN chown steemd:steemd -R /var/lib/steemd

VOLUME ["/var/lib/steemd"]

EXPOSE 8332

EXPOSE 8333

RUN mkdir -p /etc/service/steemd
ADD steemd.run /etc/service/steemd/run

RUN mkdir -p /etc/service/steemd/log
ADD steemd.log.run /etc/service/steemd/log/run

RUN chmod +x /etc/service/steemd/log/run \
    /etc/service/steemd/run
