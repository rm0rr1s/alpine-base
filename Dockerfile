FROM alpine:latest

RUN apk add --no-cache bash

# add supervisor conf file
ADD build/supervisor.conf /etc/supervisor.conf

ADD scripts/*.sh /usr/local/sbin/

ADD build/root/install.sh /root/

RUN chmod 755 \
	/root/install.sh \
	/usr/local/sbin/*.sh && \
	/bin/bash /root/install.sh

# docker settings
#################

# set environment variables for user media
ENV HOME /home/media

ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ "

# set environment variable for terminal
ENV TERM xterm

# run tini to manage graceful exit and zombie reaping
ENTRYPOINT ["/sbin/tini", "-g", "--"]
