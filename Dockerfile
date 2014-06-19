FROM phusion/baseimage:0.9.10
MAINTAINER Philipz <philipzheng@gmail.com>

RUN apt-get update -qq && apt-get install -y mysql-server-5.5 supervisor

ENV NEW_RELIC_LICENSE_KEY cd03cd02d80db78bf4e25f1d15ec98c7c12a5af0
ENV CUSTOM_HOSTNAME mysql.dockware.io

RUN apt-get install -yq ca-certificates wget

# generate a local to suppress warnings
RUN locale-gen en_US.UTF-8

# install new relic server monitoring
RUN echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
  wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
  apt-get update && apt-get install newrelic-sysmond

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD remote.conf /etc/syslog-ng/conf.d/
ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 664 /etc/mysql/conf.d/my.cnf
ADD run.sh /run.sh
RUN chmod +x /run.sh
ADD newrelic.sh /newrelic.sh
RUN chmod +x /newrelic.sh
RUN mkdir /etc/service/supervisor
ADD supervisor.sh /etc/service/supervisor/run
RUN chmod +x /etc/service/supervisor/run

VOLUME ["/var/lib/mysql"]
EXPOSE 3306
CMD ["/sbin/my_init"]
