FROM phusion/baseimage:0.9.19


# steem:master as of 2016-08-18
ARG STEEMD_REPO=https://github.com/steemit/steem.git
ARG STEEMD_REV=045c2a340d254d11dfcd22e1253646132465f9b7

# secp256k1:master as of 2016-08-18
ARG SECP256K1_REPO=https://github.com/bitcoin/secp256k1
ARG SECP256K1_REV=7a49cacd3937311fcb1cb36b6ba3336fca811991

ARG UBUNTU_MIRROR=mirror://mirrors.ubuntu.com/mirrors.txt

RUN sed -i \
    -e s#http://archive.ubuntu.com/ubuntu/#${UBUNTU_MIRROR}#g \
    -e s#http://security.ubuntu.com/ubuntu/#${UBUNTU_MIRROR}#g \
        /etc/apt/sources.list ; \
        grep -v deb-src /etc/apt/sources.list > \
            /etc/apt/sources.list.new && \
        mv /etc/apt/sources.list.new /etc/apt/sources.list && \
        cat /etc/apt/sources.list

RUN \
    apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        cmake \
        doxygen \
        git \
        libboost-all-dev \
        libreadline-dev \
        libssl-dev \
        libtool \
        ncurses-dev \
        python3 \
        python3-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    git clone \
        $SECP256K1_REPO \
        /usr/local/src/secp256k1 && \
    cd /usr/local/src/secp256k1 && \
    git checkout $SECP256K1_REV && \
    ./autogen.sh && \
    ./configure && \
    make -j8 && \
    ./tests && \
    make install && \
    cd / && \
    rm -rfv /usr/local/src/secp256k1

RUN \
    git clone \
        $STEEMD_REPO \
        /usr/local/src/steem && \
    cd /usr/local/src/steem && \
    git checkout $STEEMD_REV && \
    git submodule update --init --recursive && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DLOW_MEMORY_NODE=ON \
        . \
    && \
    make -j8 && \
    make install && \
    rm -rf /usr/local/src/steem

# FIXME run steemd tests as part of build

RUN \
    apt-get remove -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        doxygen \
        git \
        libssl-dev \
        libtool \
        pkg-config \
        python3-dev \
    && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /var/lib/steemd
RUN useradd -s /bin/bash -m -d /var/lib/steemd steemd
RUN chown steemd:steemd -R /var/lib/steemd

VOLUME ["/var/lib/steemd"]

# rpc service:
EXPOSE 8090
# p2p service:
EXPOSE 2001

RUN mkdir -p /etc/service/steemd
ADD steemd.run /etc/service/steemd/run
RUN chmod +x /etc/service/steemd/run
