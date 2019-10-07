FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONIOENCODING utf-8
RUN apt-get update -y
RUN apt-get -y --force-yes --no-install-recommends install \
    libreoffice '^libreoffice-.*-it$'
RUN rm /usr/bin/soffice && cd /usr/bin && ln -s \
    ../lib/libreoffice/program/soffice.bin ./soffice
RUN sed -i 's/Logo=1/Logo=0/g' /etc/libreoffice/sofficerc && \
    sed -i 's/NativeProgress=false/NativeProgress=true/g' /etc/libreoffice/sofficerc
RUN apt-get install -y --force-yes supervisor
RUN apt-get clean

EXPOSE 2002

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
