FROM debian:wheezy
MAINTAINER Sergio Corato <sergiocorato@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONIOENCODING utf-8

RUN cp /etc/apt/sources.list /etc/apt/sources.list.back
RUN sed -i 's/deb http:\/\/security.debian.org.*/#NO/g' /etc/apt/sources.list
RUN sed -i 's/deb-src http:\/\/security.debian.org.*/#NO/g' /etc/apt/sources.list
RUN sed -i 's/deb http:\/\/deb.debian.org.*/#NO/g' /etc/apt/sources.list
RUN sed -i 's/deb-src http:\/\/deb.debian.org.*/#NO/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
RUN echo "deb http://archive.debian.org/debian wheezy-backports main" >> \
 /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian wheezy-backports main" >> \
 /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-security wheezy updates/main" >> \
 /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian-security wheezy updates/main" >> \
 /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian wheezy main" >> \
 /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian wheezy main" >> \
 /etc/apt/sources.list
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get -y --force-yes --no-install-recommends -t wheezy-backports install \
    libreoffice '^libreoffice-.*-it$'
RUN rm /usr/bin/soffice && cd /usr/bin && ln -s \
    ../lib/libreoffice/program/soffice.bin ./soffice
RUN sed -i 's/Logo=1/Logo=0/g' /etc/libreoffice/sofficerc && \
    sed -i 's/NativeProgress=false/NativeProgress=true/g' /etc/libreoffice/sofficerc
RUN apt-get install -y --force-yes supervisor
#    openjdk-8-jre openjdk-8-jre-headless tcpd uno-libs3 ure
# ? xvfb
RUN apt-get clean

EXPOSE 2002

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
