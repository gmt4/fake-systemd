FROM centos:7

ENV SHELL /bin/bash

# install gcc
RUN yum install -y gcc

RUN curl https://raw.githubusercontent.com/daleobrien/start-stop-daemon/master/start-stop-daemon.c > start-stop-daemon.c \
    &&  gcc start-stop-daemon.c -o start-stop-daemon \
    &&  mv start-stop-daemon /usr/bin/start-stop-daemon

RUN mv /usr/bin/systemctl /usr/bin/systemctl.real
ADD systemctl /usr/bin/systemctl

RUN yum clean all
