FROM ubuntu:14.04
MAINTAINER Matthieu Lagacherie <matthieu.lagacherie@gmail.com>

RUN locale-gen fr_FR.UTF-8 && \
    echo 'LANG="fr_FR.UTF-8"' > /etc/default/locale

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

RUN apt-get install --yes wget make g++ python-dev
RUN mkdir /opt/ns
WORKDIR /opt/ns
RUN wget https://www.nsnam.org/release/ns-allinone-3.26.tar.bz2
RUN tar xjf ns-allinone-3.26.tar.bz2
RUN apt-get install --yes libgsl0-dev

WORKDIR /opt/ns/ns-allinone-3.26
RUN ./build.py --enable-examples --enable-tests

WORKDIR /opt/ns/ns-allinone-3.26/ns-3.26
RUN ./test.py core

ADD ./scripts/ /scripts/
RUN chmod +x /scripts/start.sh

VOLUME ['/data']

CMD /scripts/start.sh
