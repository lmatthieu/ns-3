FROM ubuntu:14.04
MAINTAINER Matthieu Lagacherie <matthieu.lagacherie@gmail.com>

RUN locale-gen en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale

RUN apt-get -qq update


ADD ./scripts/ /scripts/
RUN chmod +x /scripts/start.sh

VOLUME ['/data']

CMD /scripts/start.sh